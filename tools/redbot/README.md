# Ratwood RedBot cog

Ког для нескольких игровых серверов с одной командой `!status`.

`!status` в канале A показывает сервер A, в канале B — сервер B. Topic, конец раунда и ахелпы тоже настраиваются отдельно на каждый сервер.

## Игра (каждый DreamDaemon)

В `config/comms.txt`:

```
COMMS_KEY unique_key_for_this_server
BOT_IP 127.0.0.1:8081
BOT_SERVER_NAME ratwood
```

`BOT_SERVER_NAME` должен совпадать с именем из `rw add`. Ключ — уникальный на каждый игровой инстанс.

## Discord

Старый ког `status` тоже регистрирует `!status`. Перед загрузкой:

```
[p]unload status
[p]load ratwood
```

Файлы: `/root/.local/share/Red-DiscordBot/data/pipipupu/cogs/CogManager/cogs/ratwood`

```
[p]rw add ratwood 127.0.0.1 7777
[p]rw commskey ratwood unique_key_for_this_server
[p]rw connect ratwood byond://127.0.0.1:7777
[p]rw ahelpchannel ratwood #ahelp-ratwood
[p]rw adminrole ratwood @Admin
```

В нужном чате:

```
[p]rw bind ratwood
```

После этого `!status` в этом чате ходит только на этот сервер. Второй сервер:

```
[p]rw add event 127.0.0.1 7778
[p]rw bind event
```

(вторую команду писать уже в чате event-сервера)

```
[p]rw list
[p]status
```
