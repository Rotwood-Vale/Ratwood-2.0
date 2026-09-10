import asyncio
import json
import logging
import re
import socket
import struct
import time
import urllib.parse
from datetime import datetime, timezone
from typing import Optional, Tuple, Union

from aiohttp import web
import discord
from redbot.core import Config, checks, commands
from redbot.core.bot import Red

log = logging.getLogger("red.ratwood")

GAME_STATE = {
    0: "Запуск",
    1: "Лобби",
    2: "Подготовка",
    3: "Раунд",
    4: "Конец раунда",
}

TICKET_TITLE_RE = re.compile(r"Ticket #(\d+)")
SERVER_FOOTER_RE = re.compile(r"server:(\S+)")
COLOR_AHELP = 0xE67E22
COLOR_TAKEN = 0x2ECC71
COLOR_CLOSED = 0x95A5A6
COLOR_ROUND_END = 0x3498DB
COLOR_ROUND_START = 0x79AC78
COLOR_ONLINE = 0x2ECC71
COLOR_OFFLINE = 0xE74C3C

SERVER_DEFAULTS = {
    "host": None,
    "port": None,
    "comms_key": "default_pwd",
    "connect_url": None,
    "proxy_url": None,
    "status_channel": None,
    "ahelp_channel": None,
    "round_channel": None,
    "admin_role": None,
    "display_name": None,
}


def format_clock(seconds: int) -> str:
    seconds = max(0, int(seconds))
    hours, rem = divmod(seconds, 3600)
    minutes, secs = divmod(rem, 60)
    if hours:
        return f"{hours:02d}:{minutes:02d}:{secs:02d}"
    return f"{minutes:02d}:{secs:02d}"


def format_duration_long(seconds: int) -> str:
    seconds = max(0, int(seconds))
    hours, rem = divmod(seconds, 3600)
    minutes, _ = divmod(rem, 60)
    if hours:
        return f"{hours}ч {minutes}м"
    return f"{minutes}м"


def flatten_params(raw: dict) -> dict:
    out = {}
    for key, value in raw.items():
        if isinstance(value, list):
            out[key] = value[0] if value else ""
        else:
            out[key] = value
    return out


def ticket_key(server: str, ticket_id: int) -> str:
    return f"{server}:{ticket_id}"


class AhelpButtons(discord.ui.View):
    def __init__(self):
        super().__init__(timeout=None)

    @discord.ui.button(label="Take Ticket", style=discord.ButtonStyle.success, custom_id="ratwood:ahelp:take")
    async def take_ticket(self, interaction: discord.Interaction, button: discord.ui.Button):
        cog = interaction.client.get_cog("Ratwood")
        if cog:
            await cog.handle_ticket_button(interaction, "take")

    @discord.ui.button(label="Reply", style=discord.ButtonStyle.primary, custom_id="ratwood:ahelp:reply")
    async def reply_ticket(self, interaction: discord.Interaction, button: discord.ui.Button):
        cog = interaction.client.get_cog("Ratwood")
        if cog:
            await cog.handle_ticket_button(interaction, "reply")

    @discord.ui.button(label="Close Ticket", style=discord.ButtonStyle.danger, custom_id="ratwood:ahelp:close")
    async def close_ticket(self, interaction: discord.Interaction, button: discord.ui.Button):
        cog = interaction.client.get_cog("Ratwood")
        if cog:
            await cog.handle_ticket_button(interaction, "close")


class ReplyModal(discord.ui.Modal, title="Ответ игроку"):
    reply = discord.ui.TextInput(
        label="Сообщение",
        style=discord.TextStyle.paragraph,
        max_length=1800,
        required=True,
    )

    def __init__(self, cog: "Ratwood", server: str, ticket_id: int):
        super().__init__()
        self.cog = cog
        self.server = server
        self.ticket_id = ticket_id

    async def on_submit(self, interaction: discord.Interaction):
        await interaction.response.defer(ephemeral=True)
        result = await self.cog.send_game_action(
            self.server,
            "reply",
            self.ticket_id,
            str(interaction.user),
            str(self.reply.value),
        )
        if result is None or str(result).lower().startswith("error"):
            await interaction.followup.send(
                f"Не удалось отправить ответ: {result or 'сервер не ответил'}",
                ephemeral=True,
            )
            return
        await self.cog.mark_ticket_responded(self.server, self.ticket_id, interaction.user, str(self.reply.value))
        await interaction.followup.send("Ответ отправлен игроку.", ephemeral=True)


class Ratwood(commands.Cog):
    """Статус нескольких игровых серверов, конец раунда и ахелпы."""

    def __init__(self, bot: Red):
        self.bot = bot
        self.config = Config.get_conf(self, identifier=0x52415457, force_registration=True)
        self.config.register_global(
            listen_host="0.0.0.0",
            listen_port=8081,
            timeout=8,
            stale_minutes=15,
            topic_interval=60,
            servers={},
            channel_servers={},
        )
        self.tickets = {}
        self.runner = None
        self.site = None
        self.status_task = None
        self.stale_task = None
        self.last_topics = {}

    async def cog_load(self):
        self.bot.add_view(AhelpButtons())
        self.status_task = asyncio.create_task(self.status_loop())
        self.stale_task = asyncio.create_task(self.stale_loop())
        await self.start_listener()

    async def cog_unload(self):
        for task in (self.status_task, self.stale_task):
            if task:
                task.cancel()
        if self.site:
            await self.site.stop()
        if self.runner:
            await self.runner.cleanup()

    def normalize_name(self, name: str) -> str:
        return name.strip().lower().replace(" ", "_")

    async def all_servers(self) -> dict:
        return await self.config.servers() or {}

    async def get_server(self, name: str) -> Optional[dict]:
        servers = await self.all_servers()
        return servers.get(self.normalize_name(name))

    async def save_server(self, name: str, cfg: dict):
        name = self.normalize_name(name)
        async with self.config.servers() as servers:
            merged = dict(SERVER_DEFAULTS)
            merged.update(servers.get(name) or {})
            merged.update(cfg)
            servers[name] = merged

    async def server_for_channel(self, channel_id: int) -> Tuple[Optional[str], Optional[dict]]:
        mapping = await self.config.channel_servers() or {}
        name = mapping.get(str(channel_id))
        servers = await self.all_servers()
        if name and name in servers:
            return name, servers[name]
        for sname, cfg in servers.items():
            for key in ("status_channel", "ahelp_channel", "round_channel"):
                if cfg.get(key) == channel_id:
                    return sname, cfg
        if len(servers) == 1:
            only = next(iter(servers.items()))
            return only[0], only[1]
        return None, None

    async def server_from_payload(self, payload: dict) -> Tuple[Optional[str], Optional[dict]]:
        servers = await self.all_servers()
        hinted = payload.get("server")
        if isinstance(hinted, list):
            hinted = hinted[0] if hinted else None
        if hinted:
            name = self.normalize_name(str(hinted))
            if name in servers:
                return name, servers[name]
        got = payload.get("key")
        if isinstance(got, list):
            got = got[0] if got else ""
        matches = [(name, cfg) for name, cfg in servers.items() if cfg.get("comms_key") and cfg.get("comms_key") == got]
        if len(matches) == 1:
            return matches[0]
        if len(servers) == 1:
            only = next(iter(servers.items()))
            return only[0], only[1]
        return None, None

    def display_name(self, name: str, cfg: dict) -> str:
        return cfg.get("display_name") or name

    async def start_listener(self):
        if self.site:
            await self.site.stop()
        if self.runner:
            await self.runner.cleanup()
        host = await self.config.listen_host()
        port = await self.config.listen_port()
        app = web.Application()
        app.router.add_post("/event", self.handle_http_event)
        app.router.add_get("/event", self.handle_http_event)
        app.router.add_get("/", self.handle_http_event)
        self.runner = web.AppRunner(app)
        await self.runner.setup()
        self.site = web.TCPSite(self.runner, host, port)
        try:
            await self.site.start()
            log.info("Listening for game events on %s:%s", host, port)
        except OSError as exc:
            log.exception("Failed to bind %s:%s: %s", host, port, exc)

    def query_server_sync(self, host: str, port: int, query: str, timeout: int) -> Optional[dict]:
        packet = (
            b"\x00\x83"
            + struct.pack(">H", len(query) + 6)
            + b"\x00\x00\x00\x00\x00"
            + query.encode("utf-8")
            + b"\x00"
        )
        conn = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        try:
            conn.settimeout(timeout)
            conn.connect((host, port))
            conn.sendall(packet)
            data = conn.recv(65535)
            if not data or len(data) < 6:
                return None
            payload = data[5:-1].decode("utf-8", errors="replace")
            if payload.startswith("{") or payload.startswith("["):
                parsed = json.loads(payload)
                return parsed.get("data", parsed)
            parsed = urllib.parse.parse_qs(payload)
            if not parsed:
                return {"response": payload}
            return flatten_params(parsed)
        except (OSError, TimeoutError, json.JSONDecodeError) as exc:
            log.debug("Topic query failed: %s", exc)
            return None
        finally:
            conn.close()

    async def query_server(self, cfg: dict, query: str = "?status") -> Optional[dict]:
        host = cfg.get("host")
        port = cfg.get("port")
        timeout = await self.config.timeout()
        if not host or not port:
            return None
        try:
            resolved = socket.gethostbyname(host)
        except OSError:
            resolved = host
        loop = asyncio.get_running_loop()
        return await loop.run_in_executor(
            None, self.query_server_sync, resolved, int(port), query, int(timeout)
        )

    async def query_with_key(self, cfg: dict, extra: dict) -> Optional[Union[str, dict]]:
        extra = dict(extra)
        extra["key"] = cfg.get("comms_key") or ""
        query = "?" + urllib.parse.urlencode(extra)
        result = await self.query_server(cfg, query)
        if isinstance(result, dict) and "response" in result:
            return result["response"]
        if isinstance(result, dict) and len(result) == 1:
            only = next(iter(result.values()))
            if isinstance(only, str):
                return only
        return result

    async def send_game_action(self, server: str, action: str, ticket_id: int, sender: str, msg: str = "") -> Optional[str]:
        cfg = await self.get_server(server)
        if not cfg:
            return "Error: unknown server"
        payload = {
            "discord_ahelp": "1",
            "action": action,
            "ticket": str(ticket_id),
            "sender": sender,
        }
        if msg:
            payload["msg"] = msg
        result = await self.query_with_key(cfg, payload)
        if result is None:
            return None
        if isinstance(result, dict):
            return " ".join(str(v) for v in result.values())
        return str(result)

    def connect_link(self, cfg: dict) -> Optional[str]:
        if cfg.get("connect_url"):
            return cfg["connect_url"]
        host = cfg.get("host")
        port = cfg.get("port")
        if host and port:
            return f"byond://{host}:{port}"
        return None

    def status_topic_text(self, cfg: dict, data: Optional[dict]) -> str:
        connect = self.connect_link(cfg)
        proxy = cfg.get("proxy_url")
        if not data:
            parts = ["🟥 Offline"]
            if connect:
                parts.append(f"Подключиться: {connect}")
            if proxy:
                parts.append(f"Прокси: {proxy}")
            return " | ".join(parts)
        players = data.get("players", "0")
        living = data.get("living", "?")
        lobby = data.get("lobby", "?")
        map_name = data.get("map_name", "Unknown")
        storyteller = data.get("storyteller") or "—"
        duration = format_clock(int(float(data.get("round_duration") or 0)))
        gamestate = GAME_STATE.get(int(float(data.get("gamestate") or 0)), "Unknown")
        online = "🟩" if int(float(data.get("gamestate") or 0)) < 4 else "🟨"
        parts = [f"{online} {gamestate}"]
        if connect:
            parts.append(f"Подключиться: {connect}")
        if proxy:
            parts.append(f"Прокси: {proxy}")
        parts.append(f"Онлайн/В игре/Лобби: {players}/{living}/{lobby}")
        parts.append(f"Карта: {map_name}")
        parts.append(f"Storyteller: {storyteller}")
        parts.append(f"Длительность раунда: {duration}")
        return " | ".join(parts)

    async def update_status_channel(self, name: str, cfg: dict):
        channel_id = cfg.get("status_channel")
        if not channel_id:
            return
        channel = self.bot.get_channel(channel_id)
        if not isinstance(channel, discord.TextChannel):
            return
        if not channel.permissions_for(channel.guild.me).manage_channels:
            log.debug("Missing Manage Channels on %s", channel.id)
            return
        data = await self.query_server(cfg, "?status")
        topic = self.status_topic_text(cfg, data)
        if topic == self.last_topics.get(name):
            return
        try:
            await channel.edit(topic=topic[:1024])
            self.last_topics[name] = topic
        except discord.HTTPException as exc:
            log.warning("Failed to edit status topic for %s: %s", name, exc)

    async def update_all_status_channels(self):
        servers = await self.all_servers()
        for name, cfg in servers.items():
            await self.update_status_channel(name, cfg)

    async def status_loop(self):
        await self.bot.wait_until_ready()
        await asyncio.sleep(8)
        while True:
            try:
                await self.update_all_status_channels()
            except Exception:
                log.exception("Status loop error")
            interval = await self.config.topic_interval()
            await asyncio.sleep(max(30, int(interval or 60)))

    async def stale_loop(self):
        await self.bot.wait_until_ready()
        while True:
            await asyncio.sleep(60)
            try:
                await self.flag_stale_tickets()
            except Exception:
                log.exception("Stale ticket loop error")

    async def flag_stale_tickets(self):
        minutes = int(await self.config.stale_minutes() or 15)
        cutoff = time.time() - minutes * 60
        for key, info in list(self.tickets.items()):
            if info.get("closed") or info.get("responded") or info.get("stale_pinged"):
                continue
            if info.get("created", time.time()) > cutoff:
                continue
            channel = self.bot.get_channel(info.get("channel_id"))
            if not isinstance(channel, discord.TextChannel):
                continue
            try:
                message = await channel.fetch_message(info["message_id"])
            except (discord.HTTPException, KeyError):
                continue
            embed = message.embeds[0] if message.embeds else None
            if not embed:
                continue
            ticket_id = info.get("ticket_id") or self.ticket_id_from_embed(embed)
            embed.title = f"📨 Ticket #{ticket_id} (Нет ответа {minutes} минут!)"
            server = info.get("server")
            cfg = await self.get_server(server) if server else None
            role_id = (cfg or {}).get("admin_role")
            mention = f"<@&{role_id}>" if role_id else ""
            embed.set_footer(text=f"Нет ответа {minutes} минут | server:{server}")
            try:
                await message.edit(content=mention or None, embed=embed, view=AhelpButtons())
                info["stale_pinged"] = True
            except discord.HTTPException:
                continue

    async def authorized(self, payload: dict) -> bool:
        name, cfg = await self.server_from_payload(payload)
        if not cfg:
            return False
        got = payload.get("key")
        if isinstance(got, list):
            got = got[0] if got else ""
        expected = cfg.get("comms_key")
        return bool(expected) and got == expected

    async def handle_http_event(self, request: web.Request):
        if request.method == "POST":
            try:
                payload = await request.json()
            except json.JSONDecodeError:
                payload = dict(request.query)
        else:
            payload = {k: v for k, v in request.query.items()}
        if not await self.authorized(payload):
            return web.Response(status=403, text="bad key")
        asyncio.create_task(self.dispatch_event(payload))
        return web.Response(text="ok")

    async def dispatch_event(self, payload: dict):
        await self.bot.wait_until_ready()
        name, cfg = await self.server_from_payload(payload)
        if not cfg:
            return
        event_type = payload.get("type")
        if event_type == "round_start":
            await self.post_round_start(name, cfg, payload)
        elif event_type == "round_end":
            await self.post_round_end(name, cfg, payload)
        elif event_type == "ahelp":
            await self.post_ahelp(name, cfg, payload)

    def link_line(self, cfg: dict, payload: Optional[dict] = None) -> str:
        connect = (payload or {}).get("connect_url") or self.connect_link(cfg)
        proxy = cfg.get("proxy_url")
        links = []
        if connect:
            links.append(f"[Подключиться]({connect})" if str(connect).startswith("http") else f"`{connect}`")
        if proxy:
            links.append(f"[Прокси]({proxy})" if str(proxy).startswith("http") else f"`{proxy}`")
        return " | ".join(links)

    async def post_round_start(self, name: str, cfg: dict, payload: dict):
        channel = self.bot.get_channel(cfg.get("round_channel") or cfg.get("status_channel"))
        if not isinstance(channel, discord.TextChannel):
            return
        round_id = payload.get("rogue_round_id") or payload.get("round_id") or "?"
        embed = discord.Embed(
            title=f"{self.display_name(name, cfg)}: раунд начался!",
            description=str(round_id),
            color=COLOR_ROUND_START,
            timestamp=datetime.now(timezone.utc),
        )
        if payload.get("map"):
            embed.add_field(name="Карта", value=str(payload["map"]), inline=True)
        if payload.get("storyteller"):
            embed.add_field(name="Storyteller", value=str(payload["storyteller"]), inline=True)
        links = self.link_line(cfg, payload)
        if links:
            embed.add_field(name="Ссылки", value=links, inline=False)
        await channel.send(embed=embed)

    async def post_round_end(self, name: str, cfg: dict, payload: dict):
        channel = self.bot.get_channel(cfg.get("round_channel") or cfg.get("status_channel"))
        if not isinstance(channel, discord.TextChannel):
            return
        round_id = payload.get("rogue_round_id") or payload.get("round_id") or "?"
        duration = format_duration_long(int(float(payload.get("duration") or 0)))
        embed = discord.Embed(
            title=f"{self.display_name(name, cfg)}: раунд {round_id} закончился!",
            color=COLOR_ROUND_END,
            timestamp=datetime.now(timezone.utc),
        )
        links = self.link_line(cfg, payload)
        if links:
            embed.description = "| " + links + " |"
        stats = [
            f"**Карта:** {payload.get('map') or '—'}",
            f"**Длительность:** {duration}",
            f"**Выживший персонал:** {payload.get('survivors', 0)}",
            f"**Смертей:** {payload.get('deaths', 0)}",
        ]
        if payload.get("storyteller"):
            stats.insert(1, f"**Storyteller:** {payload['storyteller']}")
        embed.add_field(name="— Статистика Раунда —", value="\n".join(stats), inline=False)
        species = payload.get("species") or {}
        if isinstance(species, dict) and species:
            ranked = sorted(species.items(), key=lambda item: int(item[1]), reverse=True)
            lines = [f"{sname}: {count}" for sname, count in ranked[:8]]
            embed.add_field(name="Топ видов", value="\n".join(lines), inline=False)
        await channel.send(embed=embed)

    def ticket_id_from_embed(self, embed: Optional[discord.Embed]) -> Optional[int]:
        if not embed or not embed.title:
            return None
        match = TICKET_TITLE_RE.search(embed.title)
        return int(match.group(1)) if match else None

    def server_from_embed(self, embed: Optional[discord.Embed]) -> Optional[str]:
        if not embed or not embed.footer or not embed.footer.text:
            return None
        match = SERVER_FOOTER_RE.search(embed.footer.text)
        return match.group(1) if match else None

    async def post_ahelp(self, name: str, cfg: dict, payload: dict):
        action = payload.get("action") or "new"
        ticket_id = int(payload.get("ticket") or 0)
        if not ticket_id:
            return
        if action == "new":
            await self.post_new_ahelp(name, cfg, payload, ticket_id)
            return
        info = self.tickets.get(ticket_key(name, ticket_id))
        if not info:
            return
        channel = self.bot.get_channel(info.get("channel_id"))
        if not isinstance(channel, discord.TextChannel):
            return
        try:
            message = await channel.fetch_message(info["message_id"])
        except discord.HTTPException:
            return
        embed = message.embeds[0] if message.embeds else discord.Embed(title=f"📨 Ticket #{ticket_id}")
        actor = payload.get("actor") or "Admin"
        text = payload.get("message") or ""
        if action == "message":
            embed.add_field(name=f"Игрок ({payload.get('ckey') or actor})", value=text[:1024] or "—", inline=False)
        elif action == "reply":
            embed.add_field(name=f"Ответ ({actor})", value=text[:1024] or "—", inline=False)
            info["responded"] = True
            embed.color = COLOR_TAKEN
        elif action == "take":
            embed.color = COLOR_TAKEN
            embed.set_footer(text=f"Взял: {actor} | server:{name}")
            info["responded"] = True
        elif action in ("close", "resolve"):
            embed.color = COLOR_CLOSED
            embed.title = f"📨 Ticket #{ticket_id} ({'закрыт' if action == 'close' else 'решён'})"
            embed.set_footer(text=f"{action} — {actor} | server:{name}")
            info["closed"] = True
            await message.edit(embed=embed, view=None)
            return
        await message.edit(embed=embed, view=AhelpButtons())

    async def post_new_ahelp(self, name: str, cfg: dict, payload: dict, ticket_id: int):
        channel = self.bot.get_channel(cfg.get("ahelp_channel"))
        if not isinstance(channel, discord.TextChannel):
            log.warning("Ahelp channel is not set for %s", name)
            return
        round_id = payload.get("rogue_round_id") or payload.get("round_id") or "?"
        embed = discord.Embed(
            title=f"📨 Ticket #{ticket_id}",
            color=COLOR_AHELP,
            timestamp=datetime.now(timezone.utc),
        )
        embed.add_field(name="Server", value=self.display_name(name, cfg), inline=True)
        embed.add_field(name="Player", value=f"`{payload.get('ckey') or 'unknown'}`", inline=True)
        embed.add_field(name="Round", value=f"`{round_id}`", inline=True)
        embed.add_field(name="Message", value=(payload.get("message") or "—")[:1024], inline=False)
        embed.set_footer(text=f"server:{name}")
        role_id = cfg.get("admin_role")
        mention = f"<@&{role_id}>" if role_id else None
        allowed = discord.AllowedMentions(roles=True) if mention else discord.AllowedMentions.none()
        message = await channel.send(
            content=mention,
            embed=embed,
            view=AhelpButtons(),
            allowed_mentions=allowed,
        )
        self.tickets[ticket_key(name, ticket_id)] = {
            "message_id": message.id,
            "channel_id": channel.id,
            "created": time.time(),
            "responded": False,
            "stale_pinged": False,
            "closed": False,
            "ckey": payload.get("ckey"),
            "server": name,
            "ticket_id": ticket_id,
        }

    async def can_handle_tickets(self, member: discord.Member, cfg: Optional[dict]) -> bool:
        if member.guild_permissions.administrator or member.guild_permissions.manage_messages:
            return True
        role_id = (cfg or {}).get("admin_role")
        if role_id and discord.utils.get(member.roles, id=role_id):
            return True
        return False

    async def handle_ticket_button(self, interaction: discord.Interaction, action: str):
        embed = interaction.message.embeds[0] if interaction.message.embeds else None
        ticket_id = self.ticket_id_from_embed(embed)
        server = self.server_from_embed(embed)
        cfg = await self.get_server(server) if server else None
        if not isinstance(interaction.user, discord.Member) or not await self.can_handle_tickets(interaction.user, cfg):
            await interaction.response.send_message("Недостаточно прав.", ephemeral=True)
            return
        if not ticket_id or not server:
            await interaction.response.send_message("Не удалось прочитать тикет.", ephemeral=True)
            return
        if action == "reply":
            await interaction.response.send_modal(ReplyModal(self, server, ticket_id))
            return
        await interaction.response.defer(ephemeral=True)
        result = await self.send_game_action(server, action, ticket_id, str(interaction.user))
        if result is None or str(result).lower().startswith("error"):
            await interaction.followup.send(
                f"Сервер не принял действие: {result or 'нет ответа'}",
                ephemeral=True,
            )
            return
        if action == "take":
            await self.mark_ticket_taken(server, ticket_id, interaction.user, interaction.message)
        elif action == "close":
            await self.mark_ticket_closed(server, ticket_id, interaction.user, interaction.message)
        await interaction.followup.send("Готово.", ephemeral=True)

    async def mark_ticket_taken(self, server: str, ticket_id: int, user: discord.abc.User, message: discord.Message):
        info = self.tickets.get(ticket_key(server, ticket_id), {})
        info["responded"] = True
        self.tickets[ticket_key(server, ticket_id)] = info
        embed = message.embeds[0] if message.embeds else discord.Embed(title=f"📨 Ticket #{ticket_id}")
        embed.color = COLOR_TAKEN
        embed.set_footer(text=f"Взял: {user} | server:{server}")
        await message.edit(embed=embed, view=AhelpButtons())

    async def mark_ticket_closed(self, server: str, ticket_id: int, user: discord.abc.User, message: discord.Message):
        info = self.tickets.get(ticket_key(server, ticket_id), {})
        info["closed"] = True
        info["responded"] = True
        self.tickets[ticket_key(server, ticket_id)] = info
        embed = message.embeds[0] if message.embeds else discord.Embed(title=f"📨 Ticket #{ticket_id}")
        embed.color = COLOR_CLOSED
        embed.title = f"📨 Ticket #{ticket_id} (закрыт)"
        embed.set_footer(text=f"Закрыл: {user} | server:{server}")
        await message.edit(embed=embed, view=None)

    async def mark_ticket_responded(self, server: str, ticket_id: int, user: discord.abc.User, text: str):
        info = self.tickets.get(ticket_key(server, ticket_id))
        if not info:
            return
        info["responded"] = True
        channel = self.bot.get_channel(info["channel_id"])
        if not isinstance(channel, discord.TextChannel):
            return
        try:
            message = await channel.fetch_message(info["message_id"])
        except discord.HTTPException:
            return
        embed = message.embeds[0] if message.embeds else discord.Embed(title=f"📨 Ticket #{ticket_id}")
        embed.color = COLOR_TAKEN
        embed.add_field(name=f"Ответ ({user})", value=text[:1024], inline=False)
        embed.set_footer(text=f"server:{server}")
        await message.edit(embed=embed, view=AhelpButtons())

    def status_embed(self, name: str, cfg: dict, data: Optional[dict]) -> discord.Embed:
        title = self.display_name(name, cfg)
        if not data:
            return discord.Embed(title=f"{title}: оффлайн", color=COLOR_OFFLINE)
        duration = format_clock(int(float(data.get("round_duration") or 0)))
        embed = discord.Embed(title=f"Статус: {title}", color=COLOR_ONLINE)
        embed.add_field(name="Карта", value=str(data.get("map_name") or "—"), inline=True)
        embed.add_field(name="Storyteller", value=str(data.get("storyteller") or "—"), inline=True)
        embed.add_field(
            name="Состояние",
            value=GAME_STATE.get(int(float(data.get("gamestate") or 0)), "—"),
            inline=True,
        )
        embed.add_field(name="Онлайн", value=str(data.get("players") or 0), inline=True)
        embed.add_field(name="В игре", value=str(data.get("living") or 0), inline=True)
        embed.add_field(name="Лобби", value=str(data.get("lobby") or 0), inline=True)
        embed.add_field(name="Админы", value=str(data.get("admins") or 0), inline=True)
        embed.add_field(name="Длительность", value=duration, inline=True)
        embed.add_field(name="Раунд", value=str(data.get("rogue_round_id") or data.get("round_id") or "—"), inline=True)
        connect = self.connect_link(cfg)
        if connect:
            embed.add_field(name="Подключиться", value=connect, inline=False)
        return embed

    @commands.guild_only()
    @commands.command()
    @commands.cooldown(1, 5, commands.BucketType.channel)
    async def status(self, ctx: commands.Context):
        """Статус сервера, привязанного к этому каналу."""
        name, cfg = await self.server_for_channel(ctx.channel.id)
        if not cfg:
            await ctx.send(
                "Этот канал не привязан к игровому серверу. "
                f"Админ: `{ctx.prefix}rw bind <имя>` в этом чате."
            )
            return
        data = await self.query_server(cfg, "?status")
        await ctx.send(embed=self.status_embed(name, cfg, data))

    @commands.guild_only()
    @commands.group(name="rw")
    @checks.admin_or_permissions(administrator=True)
    async def rw(self, ctx: commands.Context):
        """Настройка серверов Ratwood/SS13 для Discord."""
        pass

    @rw.command(name="add")
    async def rw_add(self, ctx: commands.Context, name: str, host: str, port: int):
        """Добавить игровой сервер: `rw add ratwood 127.0.0.1 7777`"""
        if not 1 <= port <= 65535:
            await ctx.send("Некорректный порт.")
            return
        name = self.normalize_name(name)
        existing = await self.get_server(name)
        await self.save_server(name, {"host": host, "port": port, "display_name": existing.get("display_name") if existing else name})
        await ctx.send(f"Сервер `{name}` → `{host}:{port}`. Дальше: `{ctx.prefix}rw bind {name}` в нужном чате.")

    @rw.command(name="remove")
    async def rw_remove(self, ctx: commands.Context, name: str):
        """Удалить сервер из кога."""
        name = self.normalize_name(name)
        async with self.config.servers() as servers:
            if name not in servers:
                await ctx.send("Такого сервера нет.")
                return
            del servers[name]
        async with self.config.channel_servers() as mapping:
            for channel_id, bound in list(mapping.items()):
                if bound == name:
                    del mapping[channel_id]
        await ctx.send(f"Сервер `{name}` удалён.")

    @rw.command(name="bind")
    async def rw_bind(self, ctx: commands.Context, name: str, channel: Optional[discord.TextChannel] = None):
        """Привязать канал к серверу. `!status` в этом чате будет спрашивать именно его."""
        name = self.normalize_name(name)
        if not await self.get_server(name):
            await ctx.send(f"Сервера `{name}` нет. Сначала `{ctx.prefix}rw add`.")
            return
        target = channel or ctx.channel
        async with self.config.channel_servers() as mapping:
            mapping[str(target.id)] = name
        cfg = await self.get_server(name)
        if not cfg.get("status_channel"):
            await self.save_server(name, {"status_channel": target.id})
        await ctx.send(f"{target.mention} → `{name}`. Здесь `{ctx.prefix}status` покажет этот сервер.")

    @rw.command(name="unbind")
    async def rw_unbind(self, ctx: commands.Context, channel: Optional[discord.TextChannel] = None):
        """Снять привязку канала."""
        target = channel or ctx.channel
        async with self.config.channel_servers() as mapping:
            mapping.pop(str(target.id), None)
        await ctx.send(f"Привязка {target.mention} снята.")

    @rw.command(name="list")
    async def rw_list(self, ctx: commands.Context):
        """Список серверов и привязанных каналов."""
        servers = await self.all_servers()
        mapping = await self.config.channel_servers() or {}
        if not servers:
            await ctx.send("Серверов нет. Добавьте: `rw add <имя> <хост> <порт>`.")
            return
        embed = discord.Embed(title="Игровые серверы")
        for name, cfg in servers.items():
            channels = [f"<#{cid}>" for cid, bound in mapping.items() if bound == name]
            status_ch = f"<#{cfg['status_channel']}>" if cfg.get("status_channel") else "—"
            ahelp_ch = f"<#{cfg['ahelp_channel']}>" if cfg.get("ahelp_channel") else "—"
            lines = [
                f"`{cfg.get('host')}:{cfg.get('port')}`",
                f"чаты !status: {', '.join(channels) or '—'}",
                f"topic: {status_ch}",
                f"ahelp: {ahelp_ch}",
            ]
            embed.add_field(name=self.display_name(name, cfg), value="\n".join(lines), inline=False)
        await ctx.send(embed=embed)

    @rw.command(name="host")
    async def rw_host(self, ctx: commands.Context, name: str, host: str):
        """IP/хост DreamDaemon для сервера."""
        if not await self.get_server(name):
            await ctx.send("Сначала `rw add`.")
            return
        await self.save_server(name, {"host": host})
        await ctx.send(f"`{self.normalize_name(name)}` host = `{host}`")

    @rw.command(name="port")
    async def rw_port(self, ctx: commands.Context, name: str, port: int):
        """Порт DreamDaemon."""
        if not await self.get_server(name) or not 1 <= port <= 65535:
            await ctx.send("Проверьте имя сервера и порт.")
            return
        await self.save_server(name, {"port": port})
        await ctx.send(f"`{self.normalize_name(name)}` port = `{port}`")

    @rw.command(name="commskey")
    @checks.is_owner()
    async def rw_commskey(self, ctx: commands.Context, name: str, key: str):
        """COMMS_KEY конкретного игрового сервера."""
        if not await self.get_server(name):
            await ctx.send("Сначала `rw add`.")
            return
        await self.save_server(name, {"comms_key": key})
        try:
            await ctx.message.delete()
        except discord.HTTPException:
            pass
        await ctx.send(f"Ключ для `{self.normalize_name(name)}` сохранён.")

    @rw.command(name="listenport")
    @checks.is_owner()
    async def rw_listenport(self, ctx: commands.Context, port: int):
        """Общий HTTP-порт для событий от всех игровых серверов."""
        if not 1024 <= port <= 65535:
            await ctx.send("Используйте порт 1024–65535.")
            return
        await self.config.listen_port.set(port)
        await self.start_listener()
        await ctx.send(f"Слушаю `{port}`.")

    @rw.command(name="connect")
    async def rw_connect(self, ctx: commands.Context, name: str, url: str):
        """Ссылка Подключиться."""
        if not await self.get_server(name):
            await ctx.send("Сначала `rw add`.")
            return
        await self.save_server(name, {"connect_url": url})
        await ctx.send(f"`{self.normalize_name(name)}` connect = `{url}`")

    @rw.command(name="proxy")
    async def rw_proxy(self, ctx: commands.Context, name: str, url: str):
        """Ссылка Прокси."""
        if not await self.get_server(name):
            await ctx.send("Сначала `rw add`.")
            return
        await self.save_server(name, {"proxy_url": url})
        await ctx.send(f"`{self.normalize_name(name)}` proxy = `{url}`")

    @rw.command(name="statuschannel")
    async def rw_statuschannel(self, ctx: commands.Context, name: str, channel: Optional[discord.TextChannel] = None):
        """Канал, у которого обновляется topic."""
        if not await self.get_server(name):
            await ctx.send("Сначала `rw add`.")
            return
        await self.save_server(name, {"status_channel": channel.id if channel else None})
        await ctx.send("Topic-канал " + (channel.mention if channel else "сброшен") + f" для `{self.normalize_name(name)}`.")

    @rw.command(name="ahelpchannel")
    async def rw_ahelpchannel(self, ctx: commands.Context, name: str, channel: Optional[discord.TextChannel] = None):
        """Канал ахелпов этого сервера."""
        if not await self.get_server(name):
            await ctx.send("Сначала `rw add`.")
            return
        await self.save_server(name, {"ahelp_channel": channel.id if channel else None})
        await ctx.send("Ahelp-канал " + (channel.mention if channel else "сброшен") + f" для `{self.normalize_name(name)}`.")

    @rw.command(name="roundchannel")
    async def rw_roundchannel(self, ctx: commands.Context, name: str, channel: Optional[discord.TextChannel] = None):
        """Канал начала/конца раунда."""
        if not await self.get_server(name):
            await ctx.send("Сначала `rw add`.")
            return
        await self.save_server(name, {"round_channel": channel.id if channel else None})
        await ctx.send("Раунд-канал " + (channel.mention if channel else "сброшен") + f" для `{self.normalize_name(name)}`.")

    @rw.command(name="adminrole")
    async def rw_adminrole(self, ctx: commands.Context, name: str, role: Optional[discord.Role] = None):
        """Роль для пинга ахелпов этого сервера."""
        if not await self.get_server(name):
            await ctx.send("Сначала `rw add`.")
            return
        await self.save_server(name, {"admin_role": role.id if role else None})
        await ctx.send("Админ-роль " + (role.mention if role else "сброшена") + f" для `{self.normalize_name(name)}`.")

    @rw.command(name="rename")
    async def rw_rename(self, ctx: commands.Context, name: str, *, display: str):
        """Отображаемое имя в эмбедах."""
        if not await self.get_server(name):
            await ctx.send("Сначала `rw add`.")
            return
        await self.save_server(name, {"display_name": display})
        await ctx.send(f"`{self.normalize_name(name)}` будет показываться как **{display}**.")

    @rw.command(name="current")
    async def rw_current(self, ctx: commands.Context, name: Optional[str] = None):
        """Настройки. Без имени — кто привязан к этому чату."""
        if not name:
            bound, cfg = await self.server_for_channel(ctx.channel.id)
            if not cfg:
                await ctx.send("К этому чату сервер не привязан. `rw list` покажет все.")
                return
            name, cfg = bound, cfg
        else:
            cfg = await self.get_server(name)
            name = self.normalize_name(name)
            if not cfg:
                await ctx.send("Нет такого сервера.")
                return
        embed = discord.Embed(title=f"Настройки `{name}`")
        for key, value in cfg.items():
            if key == "comms_key":
                value = "`скрыто`"
            elif key in ("status_channel", "ahelp_channel", "round_channel") and value:
                value = f"<#{value}>"
            elif key == "admin_role" and value:
                value = f"<@&{value}>"
            embed.add_field(name=key, value=str(value), inline=False)
        await ctx.send(embed=embed)

    @rw.command(name="refresh")
    async def rw_refresh(self, ctx: commands.Context, name: Optional[str] = None):
        """Обновить topic. Без имени — все серверы."""
        if name:
            cfg = await self.get_server(name)
            if not cfg:
                await ctx.send("Нет такого сервера.")
                return
            await self.update_status_channel(self.normalize_name(name), cfg)
        else:
            await self.update_all_status_channels()
        await ctx.send("Статус обновлён.")
