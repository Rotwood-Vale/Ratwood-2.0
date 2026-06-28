// =====================================================================================
// 群体心灵链接（重制版）—— 把所有被链接者接入"同一个聊天室"窗口，
// 交互方式仿照【管理员帮助(ahelp)对话界面】：每位成员都拥有一个浏览器对话窗口，
// 窗口里滚动显示完整的对话历史，底部有"发送消息 / 刷新"按钮，点击即可在同一房间内交流。
//
// Group Mind-Link (reworked): instead of the old ",m broadcast", every linked target now
// joins the SAME chat ROOM rendered in a /datum/browser window. The window shows the full
// conversation log and a "send / refresh" footer, mimicking the ADMIN-HELP (ahelp) ticket
// dialogue interface (a running conversation thread with a reply box).
//
// 若成员不慎关闭了对话窗口，可在 IC 标签下使用动词【Group Mindlink】随时重新打开（仅链接期间出现）。
// If a member closes the window, the IC-tab verb [Group Mindlink] reopens it (present only while linked).
//
// 全部代码均位于 modular_z121 之下，且复用主线已有系统（/datum/browser、COMSIG_MOB_SAY、
// station_time_timestamp、mind.known_people、verbs 列表），不改动 modular_z121 之外的任何文件。
// Everything lives under modular_z121 and only *reuses* mainline systems; nothing outside is edited.
// =====================================================================================

// 全局表：mob -> 它当前所在的群体心灵链接（聊天室）。用于"同一个人不能同时在两条链接里"的去重。
// Global registry mapping each mob to the single group-mindlink (chat room) it currently belongs to.
GLOBAL_LIST_EMPTY(active_group_mindlinks)

// 聊天室浏览器窗口统一使用的 window 名称。固定名称可让重复 open() 刷新同一个窗口而非弹新窗。
// Fixed BYOND window id for the chat room; a constant id makes repeated open() refresh the same window.
#define GROUP_MINDLINK_WINDOW_ID "group_mindlink_chat"

// 给参与者分配名字颜色用的调色板（仿管理员/玩家不同着色），按加入顺序循环取色，便于区分发言者。
// Palette used to color each participant's name (so speakers are easy to tell apart), cycled by join order.
GLOBAL_LIST_INIT(group_mindlink_name_colors, list("#d18cff", "#7fd1ff", "#9fe07f", "#ffd27f", "#ff9f9f", "#ff7fe0", "#7fffd4"))

// -------------------------------------------------------------------------------------
// 聊天室核心数据 datum：持有成员、对话历史、每人一个浏览器窗口，并负责渲染与广播。
// Core chat-room datum: owns the members, the message history and one browser window per member,
// and is responsible for rendering + broadcasting.
// -------------------------------------------------------------------------------------
/datum/group_mindlink_custom
	// 参与者列表（mob/living）。所有发言都会推送给这里的每一个人。
	// List of participating mobs; every message is pushed to all of them.
	var/list/participants = list()
	// 对话历史：每条是一个关联表 list("name"=发言者名, "color"=名字颜色, "text"=已转义文本, "time"=时间戳)。
	// 存成结构化数据而非纯 HTML，方便后续每位成员重新渲染窗口时复用。
	// Conversation log; each entry is an assoc list so we can re-render every member's window cheaply.
	var/list/message_log = list()
	// 每位成员对应的浏览器窗口对象：mob -> /datum/browser。窗口对象持久保存以便重复刷新。
	// Per-member browser window: mob -> /datum/browser, kept persistent so we can refresh in place.
	var/list/windows = list()
	// 成员名字颜色缓存：mob -> 颜色字符串。加入时一次性分配，渲染时直接查表。
	// Cached name color per member, assigned once at join time.
	var/list/member_colors = list()
	// 链接是否仍然有效；置为 FALSE 后所有信号处理与渲染都会短路，避免对已过期链接做无谓操作。
	// Whether the link is still live; once FALSE all handlers short-circuit.
	var/active = TRUE

// 构造：登记成员、分配颜色、注册说话信号、为有客户端者打开聊天室窗口，并广播一条系统加入提示。
// Constructor: register members, assign colors, hook speech, open windows for clients, post a join notice.
/datum/group_mindlink_custom/New(list/new_participants)
	// 防御：没有传入成员列表则直接构造一个空房间（cast() 侧已保证至少两人，此处仅作健壮性兜底）。
	// Guard: tolerate a missing list defensively (cast() already guarantees >= 2 members).
	if(!islist(new_participants))
		new_participants = list()

	// 重新初始化各容器，避免与类型定义上的默认 list() 共享引用导致的串台问题。
	// Re-init containers so we never share the type-level default list() reference between instances.
	participants = list()
	message_log = list()
	windows = list()
	member_colors = list()

	// 逐个登记成员：去重、写入全局表、注册 COMSIG_MOB_SAY 以支持 ",m" 快捷发言，并按顺序分配名字颜色。
	// Register each member: dedupe, write global table, hook speech for the ",m" shortcut, assign a color.
	for(var/mob/living/member as anything in new_participants)
		// 跳过非法对象或重复对象，保证 participants 中每个成员唯一且类型正确。
		// Skip invalid / duplicate entries so participants stays unique and well-typed.
		if(!istype(member) || (member in participants))
			continue
		participants += member
		// 全局表记录该成员归属本房间，供 cast() 做"已在别的链接里"判定与替换。
		// Record ownership in the global table for cast()'s "already linked elsewhere" replacement logic.
		GLOB.active_group_mindlinks[member] = src
		// 监听其说话事件，使旧的 ",m 前缀" 仍可作为不开窗口时的快捷发送通道。
		// Listen to speech so the legacy ",m" prefix still works as a no-window quick-send.
		RegisterSignal(member, COMSIG_MOB_SAY, PROC_REF(handle_speech))
		// 按当前成员序号从调色板循环取一个稳定颜色，便于在聊天记录中区分不同发言者。
		// Pick a stable palette color by index so different speakers are visually distinct.
		var/list/palette = GLOB.group_mindlink_name_colors
		member_colors[member] = palette[(length(member_colors) % length(palette)) + 1]
		// 仅在链接期间为该成员授予 IC 标签下的【Group Mindlink】重开动词；先判存避免重复授予。
		// Grant the IC-tab [Group Mindlink] reopen verb only while linked; guard against double-adding.
		if(!(/mob/living/proc/group_mindlink_reopen in member.verbs))
			member.verbs += /mob/living/proc/group_mindlink_reopen

	// 为每位拥有客户端的成员打开（或准备）聊天室窗口；没有客户端的 NPC 仅留在房间里但不弹窗。
	// Open the chat window for every member that has a client; clientless mobs stay in the room silently.
	for(var/mob/living/member as anything in participants)
		open_window_for(member)

	return ..()

// 析构：标记失效、关闭并清理所有窗口、解绑信号、从全局表移除成员，避免悬挂引用与内存泄漏。
// Destructor: mark dead, tear down all windows, unhook signals, remove members from the global table.
/datum/group_mindlink_custom/Destroy()
	active = FALSE
	// 关闭每位成员的浏览器窗口并释放窗口对象，防止留下空白弹窗或 /datum/browser 泄漏。
	// Close + free each member's browser window so no orphan popups or browser datums leak.
	for(var/mob/living/member as anything in participants)
		close_window_for(member)
	for(var/mob/living/member as anything in participants)
		// 仅当全局表里记录的仍是本房间时才移除，避免误删该成员"已被替换进的新房间"的记录。
		// Only clear the global entry if it still points at us (don't clobber a newer room the member joined).
		if(GLOB.active_group_mindlinks[member] == src)
			GLOB.active_group_mindlinks -= member
		// 解除说话监听，否则信号会指向已删除的 datum 造成运行时报错。
		// Unregister speech, otherwise the signal would fire into a deleted datum.
		UnregisterSignal(member, COMSIG_MOB_SAY)
		// 链接结束，收回该成员的【Group Mindlink】重开动词，使其不再残留在 IC 标签下。
		// Link over: revoke the [Group Mindlink] reopen verb so it doesn't linger in the IC tab.
		if(!QDELETED(member))
			member.verbs -= /mob/living/proc/group_mindlink_reopen
	// 清空容器引用，帮助 GC 并避免析构后被误用。
	// Null out containers to help GC and prevent post-destroy misuse.
	participants = null
	message_log = null
	windows = null
	member_colors = null
	return ..()

// -------------------------------------------------------------------------------------
// 窗口管理：为单个成员创建/刷新聊天室浏览器窗口。
// Window management: create/refresh the chat-room browser window for one member.
// -------------------------------------------------------------------------------------
/datum/group_mindlink_custom/proc/open_window_for(mob/living/member)
	// 防御：链接已失效、成员已删除或没有客户端时，没有窗口可开，直接返回。
	// Guard: nothing to open if the link is dead, the member is gone, or it has no client.
	if(!active || QDELETED(member) || !member.client)
		return FALSE
	// 复用已有的窗口对象（保持同一 window_id 实现"刷新"而非"弹新窗"）；首次则新建一个。
	// Reuse the existing browser (same window_id => refresh in place); create one on first use.
	var/datum/browser/popup = windows[member]
	if(!popup)
		// 以该成员为宿主新建浏览器窗口，宽 440 高 560（与固定高度的消息区/输入栏布局匹配），
		// ref 指向本 datum 以便 onclose 回调路由到我们的 Topic()。
		// New browser owned by the member; 440x560 matches the fixed-height log + input-bar layout;
		// ref=src so the onclose hook routes back into our Topic().
		popup = new(member, GROUP_MINDLINK_WINDOW_ID, "群体心灵链接 · 心灵聊天室", 440, 560, src)
		windows[member] = popup
	// 写入最新聊天内容并打开/刷新窗口。
	// Push the latest content and open/refresh the window.
	popup.set_content(build_window_html(member))
	popup.open()
	return TRUE

// 关闭并丢弃某成员的窗口对象（成员退出 / 房间销毁时调用）。
// Close and drop a member's browser window (on member leave / room destroy).
/datum/group_mindlink_custom/proc/close_window_for(mob/living/member)
	var/datum/browser/popup = windows?[member]
	if(!popup)
		return
	// 主动关闭客户端那一侧的弹窗，再删除窗口对象本身。
	// Close the client-side popup, then qdel the browser datum itself.
	popup.close()
	windows -= member
	qdel(popup)

// -------------------------------------------------------------------------------------
// 渲染：把 message_log 拼成聊天室 HTML（仿管理员帮助 ahelp 对话：滚动对话记录 + 底部回复栏）。
// Rendering: turn message_log into chat-room HTML (ahelp-dialogue-like scroll log + reply footer).
// -------------------------------------------------------------------------------------
/datum/group_mindlink_custom/proc/build_window_html(mob/living/viewer)
	// 顶部：当前在场成员清单，每个名字用其专属颜色显示，便于辨认发言者。
	// Header roster: each name shown in its assigned color so speakers are easy to recognize.
	var/list/roster = list()
	for(var/mob/living/member as anything in participants)
		if(QDELETED(member))
			continue
		roster += "<span style='color:[member_colors[member]]'>[member.real_name]</span>"
	// 先把成员名拼成一行，避免在字符串插值 [] 里再嵌套带引号的字符串字面量。
	// Pre-join the roster so we don't nest a quoted string literal inside [] interpolation.
	var/roster_text = roster.Join(" · ")

	// 注意：HTML / CSS 一律写成单行，避免依赖"串内反斜杠续行"特性，确保任何 BYOND 版本都能编译。
	// Note: keep HTML/CSS on single lines to avoid in-string backslash continuation (max portability).
	// 样式表：深色聊天主题——气泡式消息、自己的发言靠右且换色、输入栏常驻底部；body 不滚动，仅消息区滚动。
	// Stylesheet: dark chat theme — bubble messages, own lines right-aligned & recolored, sticky input bar;
	// the body never scrolls, only the message pane does.
	var/css = "<style>body{margin:0;padding:0;overflow:hidden;background:#15171c;font-family:Verdana,Geneva,sans-serif;color:#e6e9ef;}.hdr{background:#23262e;padding:7px 10px;border-bottom:2px solid #4a5468;font-size:11px;font-weight:bold;color:#eef1f6;}.hdr .ros{display:block;margin-top:3px;font-weight:normal;font-size:10px;color:#9aa1ad;}.log{height:412px;overflow-y:auto;overflow-x:hidden;padding:8px 10px;}.msg{margin:7px 0;clear:both;}.msg .meta{font-size:9px;color:#5d636e;margin-bottom:1px;}.msg .nm{font-weight:bold;font-size:10px;}.msg .bub{display:inline-block;max-width:82%;background:#2b2f39;padding:6px 9px;border-radius:9px;font-size:12px;line-height:1.4;word-wrap:break-word;text-align:left;}.msg.me{text-align:right;}.msg.me .meta{text-align:right;}.msg.me .bub{background:#35506e;color:#f0f5fb;}.sys{text-align:center;color:#777d88;font-style:italic;font-size:10px;margin:6px 0;}.empty{text-align:center;color:#666c77;font-style:italic;font-size:11px;margin-top:36px;}.barwrap{background:#23262e;border-top:1px solid #3a3f49;}.inp{width:100%;box-sizing:border-box;background:#101216;border:1px solid #444b57;border-radius:6px;color:#eef1f6;font-family:Verdana;font-size:12px;padding:6px 8px;}.btn{width:100%;box-sizing:border-box;background:#4a5d7e;border:0;border-radius:6px;color:#ffffff;font-weight:bold;font-size:12px;padding:7px 0;cursor:pointer;}.btn:hover{background:#5a6f94;}</style>"

	// 顶部标题栏 + 在场清单。
	// Header bar + roster line.
	var/header = "<div class='hdr'>心灵聊天室 · 在场 [length(participants)] 人<span class='ros'>[roster_text]</span></div>"

	// 主体：逐条渲染对话历史。系统消息居中斜体；普通发言渲染成气泡，并区分"自己(me)/他人"。
	// Body: render history. System lines centered/italic; normal lines as bubbles split into self(me)/others.
	var/list/lines = list()
	for(var/list/entry as anything in message_log)
		if(entry["system"])
			lines += "<div class='sys'>\[[entry["time"]]\] [entry["text"]]</div>"
		else
			// 与本窗口观看者引用一致 => 这是"我"发的，靠右显示。
			// Matches this viewer's ref => it's the viewer's own line, render right-aligned.
			var/cls = (entry["speaker_ref"] == REF(viewer)) ? "msg me" : "msg"
			lines += "<div class='[cls]'><div class='meta'><span class='nm' style='color:[entry["color"]]'>[entry["name"]]</span> · [entry["time"]]</div><div class='bub'>[entry["text"]]</div></div>"

	// 历史为空时给出占位提示，并点明"打字 + 回车"的用法。
	// Empty-state placeholder that also states the "type + Enter" usage.
	var/body = length(lines) ? lines.Join() : "<div class='empty'>还没有人说话，输入文字并按回车即可开始交流。</div>"

	// 底部输入区：一个 HTML 表单。文本框 name=msg；按【回车】或点【发送】都会提交到本 datum 的 Topic()，
	// 因此无需先点按钮即可实时发送。hidden 字段 src=本 datum 用于路由，action=send 标记这是发送请求。
	// Bottom input: an HTML form. Pressing Enter (or 发送) submits to this datum's Topic(), so messages can be
	// sent in real time without first clicking a button. Hidden src routes to us; action=send marks a send.
	var/form = "<form><input type='hidden' name='src' value='[REF(src)]'><input type='hidden' name='action' value='send'><table class='barwrap' width='100%' cellspacing='0' cellpadding='6'><tr><td><input id='inp' class='inp' type='text' name='msg' autocomplete='off' maxlength='1024'></td><td width='58'><input class='btn' type='submit' value='发送'></td></tr></table></form>"

	// 渲染后脚本：把消息区滚到底部并自动聚焦输入框，实现"打开即可打字、回车即发、发完仍聚焦"的实时体验。
	// Post-render script: scroll the log to bottom and auto-focus the input — type-immediately, Enter-to-send,
	// and keep focus after sending, for a real-time feel.
	var/js = "<script type='text/javascript'>(function(){var l=document.getElementById('log');if(l){l.scrollTop=l.scrollHeight;}var i=document.getElementById('inp');if(i){i.focus();}})();</script>"

	// 组装：样式 + 标题栏 + 滚动消息区(id=log) + 输入表单 + 脚本。
	// Assemble: style + header + scrollable log (id=log) + input form + script.
	return "[css][header]<div id='log' class='log'>[body]</div>[form][js]"

// 把当前聊天内容刷新到所有在场且有客户端的成员窗口（每次有新消息后调用）。
// Refresh the current content into every present, client-having member's window (after each new message).
/datum/group_mindlink_custom/proc/render_all()
	if(!active)
		return
	for(var/mob/living/member as anything in participants)
		// 跳过已删除的成员；其余成员若有客户端则打开/刷新窗口（已关窗的会被重新拉起，确保不漏看消息）。
		// Skip deleted members; (re)open windows for the rest, so a member who closed it still sees new messages.
		if(QDELETED(member))
			continue
		open_window_for(member)

// -------------------------------------------------------------------------------------
// 消息写入：把一条发言（或系统提示）追加进历史并广播刷新。
// Message ingestion: append one line (speech or system notice) to the log and broadcast a refresh.
// -------------------------------------------------------------------------------------
/datum/group_mindlink_custom/proc/add_message(mob/living/speaker, raw_text)
	// 防御：链接失效或空文本直接忽略，避免往历史里塞无意义的空行。
	// Guard: ignore when the link is dead or the text is empty.
	if(!active)
		return FALSE
	var/clean = trim(raw_text)
	if(!clean)
		return FALSE
	// 转义用户输入，防止其中的 < > 等字符破坏窗口 HTML（安全 + 稳定）。
	// HTML-escape user input so stray < > can't break the window markup (safety + stability).
	clean = html_encode(clean)
	// 预备发言者信息：姓名 + 专属颜色，供历史记录与普通聊天框两处复用。
	// Prepare speaker info: name + assigned color, reused by both the log entry and the normal chat mirror.
	var/speaker_name = speaker?.real_name || "未知"
	var/speaker_color = member_colors?[speaker] || "#ffffff"
	// 组装一条结构化历史记录：发言者名、颜色、引用、转义文本、站点时间戳。
	// Build one structured log entry: name, color, ref, escaped text, station timestamp.
	message_log += list(list(
		"system" = FALSE,
		"name" = speaker_name,
		"color" = speaker_color,
		"speaker_ref" = speaker ? REF(speaker) : null,
		"text" = clean,
		"time" = station_time_timestamp(),
	))
	// 同步镜像到每位成员的【普通聊天框】：即使有人没打开对话窗口，也能在主聊天里看到这条心灵讯息，
	// 不会因没开窗而漏掉对话。用心灵紫着色 + "[心灵聊天室]" 前缀标明来源，名字沿用其专属颜色。
	// Mirror into every member's NORMAL chat box too: even someone who never opened the dialogue window
	// still sees the line in main chat, so messages aren't missed. Tagged with a purple "[心灵聊天室]"
	// prefix to mark the source, and the speaker's name keeps its assigned color.
	for(var/mob/living/member as anything in participants)
		if(QDELETED(member))
			continue
		if(member == speaker)
			// 发言者自己看到的回显：用"我"指代自己。
			// The speaker's own echo: refer to themselves as "我".
			to_chat(member, span_purple("\[心灵聊天室\] 我：[clean]"))
		else
			// 其他成员看到的：带颜色的发言者姓名 + 内容。
			// Other members see: the colored speaker name + the message body.
			to_chat(member, span_purple("\[心灵聊天室\] <span style='color:[speaker_color]'>[speaker_name]</span>：[clean]"))
	// 广播刷新，让所有成员立即在各自窗口看到这条新消息。
	// Broadcast a refresh so all members see the new line immediately.
	render_all()
	return TRUE

// 追加一条"系统提示"到历史（加入/退出/即将消散等），同样会广播刷新。
// Append a "system notice" line (join/leave/expiry) to the log and broadcast a refresh.
/datum/group_mindlink_custom/proc/add_system_message(text)
	if(!active)
		return
	message_log += list(list(
		"system" = TRUE,
		"text" = html_encode(text),
		"time" = station_time_timestamp(),
	))
	render_all()

// -------------------------------------------------------------------------------------
// Topic：处理聊天室窗口里 href 的点击（发送 / 刷新 / 关闭）。usr 即点击该 href 的成员。
// Topic: handle href clicks from the chat window (send / refresh / close). usr is the clicking member.
// -------------------------------------------------------------------------------------
/datum/group_mindlink_custom/Topic(href, href_list)
	..()
	// 链接已失效则不再响应任何交互。
	// Reject all interaction once the link is dead.
	if(!active)
		return
	// 取出点击者；必须是本房间成员才允许操作，杜绝越权往别人房间发消息。
	// Resolve the clicker; only a member of THIS room may act, preventing cross-room injection.
	var/mob/living/clicker = usr
	if(!istype(clicker) || !(clicker in participants))
		return

	switch(href_list["action"])
		if("send")
			// 表单提交：直接读取窗口内文本框 msg 的内容（按回车或点"发送"都会走到这里）。
			// Form submit: read the in-window text field msg directly (Enter or the 发送 button both land here).
			var/msg = href_list["msg"]
			// 发送时机已失效（链接过期 / 成员已不在房间）则放弃本次发送。
			// Abort if the send window is no longer valid (link expired / member left).
			if(!active || !(clicker in participants))
				return
			// 写入并广播该条发言；add_message 会裁剪并忽略空白。
			// 若为空白（只敲了回车），add_message 返回 FALSE，此时单独刷新该成员窗口以重新聚焦输入框。
			// Ingest + broadcast; add_message trims and ignores blanks. On a blank (bare Enter) it returns FALSE,
			// so we just refresh this member's window to re-focus the input box.
			if(!add_message(clicker, msg))
				open_window_for(clicker)
		if("refresh")
			// 手动刷新：仅重渲染点击者自己的窗口即可。
			// Manual refresh: just re-render the clicker's own window.
			open_window_for(clicker)
		if("close")
			// 窗口被关闭（onclose 回调）：丢弃该成员的窗口对象；下条消息到来时会自动重新弹出。
			// Window closed (onclose hook): drop the window object; it reopens on the next message.
			windows -= clicker

// -------------------------------------------------------------------------------------
// 兼容旧用法：发言以 ",m" 开头时，作为不依赖窗口的快捷发送通道直接投入聊天室历史。
// Backward-compat: a message beginning with ",m" is treated as a window-less quick-send into the room.
// -------------------------------------------------------------------------------------
/datum/group_mindlink_custom/proc/handle_speech(mob/living/speaker, list/speech_args)
	SIGNAL_HANDLER
	// 链接失效或无文本则不拦截，让正常说话照常进行。
	// Do nothing (let normal speech proceed) when the link is dead or there is no text.
	if(!active)
		return
	var/message = speech_args[SPEECH_MESSAGE]
	if(!message)
		return
	// 仅当消息以 ",m" 起头时才作为心灵讯息处理；否则不干涉正常说话。
	// Only intercept when the message starts with ",m"; otherwise leave normal speech alone.
	if(findtext(message, ",m", 1, 3))
		// 去掉 ",m" 前缀并裁剪空白，得到真正要发送的内容。
		// Strip the ",m" prefix and trim to get the actual payload.
		message = trim(copytext(message, 3))
		// 把这次说话从正常语音通道里抹掉（无论是否有内容），避免心灵私语被旁人听见。
		// Always suppress the spoken line (whether or not it had content) so it isn't overheard.
		speech_args[SPEECH_MESSAGE] = null
		if(!message)
			return
		// 投入聊天室历史并广播——快捷通道与窗口"发送消息"走完全相同的入口。
		// 注意：本过程是 SIGNAL_HANDLER（不允许睡眠），而 add_message → render_all → 浏览器 open()
		// 存在会睡眠的子类重载（/datum/browser/modal/open）；故用 INVOKE_ASYNC 把它派发到允许睡眠的
		// 独立上下文执行，既消除"信号处理器中睡眠"的告警，又不改变功能。
		// Push into the room log + broadcast — same entry point as the window's send.
		// NOTE: this is a SIGNAL_HANDLER (must not sleep), but add_message -> render_all -> browser open()
		// has a sleeping override (/datum/browser/modal/open). Dispatch it via INVOKE_ASYNC so it runs in a
		// sleep-allowed context, clearing the "sleep in signal handler" lint without changing behavior.
		INVOKE_ASYNC(src, PROC_REF(add_message), speaker, message)

// 通知房间即将/已经消散：写入一条系统提示，告知所有人链接结束。
// Notify that the room has expired: log a system notice telling everyone the link has ended.
/datum/group_mindlink_custom/proc/notify_expired()
	if(!active)
		return
	// 收集仍然在场者的名字，用于在系统提示里点名"谁与谁之间的链接断开了"。
	// Collect the names of the still-present members for the expiry notice.
	var/list/member_names = list()
	for(var/mob/living/member as anything in participants)
		if(QDELETED(member))
			continue
		member_names += member.real_name
	// 先在房间里留下一条系统提示（此时 active 仍为 TRUE，窗口能渲染出这条消息）。
	// Post a system notice while still active so the window can render it.
	add_system_message("群体心灵链接逐渐消散了……（[english_list(member_names)]）")
	// 再分别给每个人发一条聊天框提示，确保关掉窗口的人也能知道链接已结束。
	// Also send a chat-box line to each member, so even those who closed the window learn it ended.
	for(var/mob/living/member as anything in participants)
		if(QDELETED(member))
			continue
		to_chat(member, span_warning("我与[english_list(member_names)]之间的群体心灵链接逐渐消散了……"))
	// 最后置为失效，阻止后续任何渲染/发送。Destroy() 会负责真正关窗与清理。
	// Finally mark inactive to block further render/send. Destroy() handles the real teardown.
	active = FALSE

// =====================================================================================
// 法术本体：群体心灵链接。施法成功后把"施法者认识的人"全部接入同一个心灵聊天室。
// The spell proper: on a successful cast, pull everyone the caster knows into one chat room.
// =====================================================================================
/obj/effect/proc_holder/spell/invoked/group_mindlink
	name = "群体心灵链接"
	// 描述更新为新机制：进入同一聊天室窗口，并保留 ",m" 快捷发言说明。
	// Description updated for the new mechanic: a shared chat-room window, with the ",m" shortcut kept.
	desc = "将施法者与自己认识的人接入同一个『心灵聊天室』对话窗口（仿管理员帮助 ahelp 对话界面），持续五分钟。在窗口底部输入文字并按回车即可实时交流；也可在发言前输入 ,m 快捷发送。若关闭窗口，可在 IC 标签下用『Group Mindlink』动词重新打开。"
	associated_skill = /datum/skill/magic/arcane
	cost = 5
	xp_gain = TRUE
	recharge_time = 6 MINUTES
	spell_tier = 3
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "group_mindlink"
	invocations = list("群念相连。")
	invocation_type = "whisper"
	chargedloop = /datum/looping_sound/invokegen
	chargedrain = 1
	chargetime = 5 SECONDS
	releasedrain = 30
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	warnie = "spellwarning"
	ignore_los = TRUE
	miracle = FALSE
	human_req = TRUE

// 施法：收集施法者认识且在场的人，建立聊天室，并设置 5 分钟后自动断开的定时器。
// Cast: gather the caster's present acquaintances, build the room, and schedule a 5-minute auto-break.
/obj/effect/proc_holder/spell/invoked/group_mindlink/cast(list/targets, mob/living/user)
	. = ..()
	// 防御：施法者必须是合法的、拥有 mind 的生物，否则无法读取其熟人名单。
	// Guard: the caster must be a valid living mob with a mind to read known_people from.
	if(!istype(user) || !user.mind)
		return FALSE

	// 参与者列表先放入施法者自己；同时准备"成功加入名"和"缺席/找不到名"两个清单用于事后反馈。
	// Start the roster with the caster; also track joined names and missing names for feedback.
	var/list/participant_mobs = list(user)
	var/list/missing_names = list()

	// 防御：熟人名单为空 => 无人可链接，回退施法（退还消耗）并提示。
	// Guard: empty acquaintance list => nobody to link; revert the cast and inform the user.
	if(!length(user.mind.known_people))
		to_chat(user, span_warning("没有我认识的人可供建立群体心灵链接！"))
		revert_cast()
		return FALSE

	// 遍历熟人名单，逐个尝试在世界里找到对应的活人；找不到的记入缺席名单。
	// Walk the acquaintance list and try to resolve each name to a living human; unresolved ones go to "missing".
	for(var/person_name in user.mind.known_people)
		var/mob/living/found_person = find_known_human(person_name)
		if(!found_person)
			missing_names += person_name
			continue
		// 排除乌鸦信使等非真人对象，避免把它们当成可对话的链接成员。
		// Exclude crow-messenger style non-players so they aren't treated as chattable members.
		if(istype(found_person, /mob/living/simple_animal/hostile/retaliate/bat/crow))
			continue
		if(!(found_person in participant_mobs))
			participant_mobs += found_person

	// 防御：除了施法者外没人能加入（全部缺席/被排除）则回退施法并提示。
	// Guard: nobody but the caster could join => revert and inform.
	if(length(participant_mobs) <= 1)
		to_chat(user, span_warning("我认识的人里，没有能加入群体心灵链接的对象。"))
		revert_cast()
		return FALSE

	// 施法表现：给周围与施法者各一段提示文本，渲染"心灵网络铺展开来"的过程。
	// Cast flavor: visible + self messages depicting the mind-network spreading out.
	user.visible_message(span_notice("[user] 轻触太阳穴，闭目凝神，随后一道无形的心灵网络在熟识之人之间铺展开来……"), \
		span_notice("我将自己与熟识之人的心念编织进同一张无形之网。"))

	// 去重收尾：若任一即将加入者已身处别的旧链接，先收集这些旧链接，稍后统一过期并销毁，避免一人多房间。
	// Dedupe: if any joiner is already in an older room, collect those rooms to expire+destroy (one room per person).
	var/list/links_to_replace = list()
	for(var/mob/living/member as anything in participant_mobs)
		var/datum/group_mindlink_custom/existing_link = GLOB.active_group_mindlinks[member]
		if(existing_link && existing_link.active && !(existing_link in links_to_replace))
			links_to_replace += existing_link
	// 让旧链接体面退场（发系统提示）再销毁，确保其窗口被关闭、信号被解绑。
	// Gracefully expire (notice) then destroy old rooms so their windows close and signals unhook.
	for(var/datum/group_mindlink_custom/existing_link as anything in links_to_replace)
		existing_link.notify_expired()
		qdel(existing_link)

	// 创建新的聊天室：构造函数会自动开窗并登记成员。
	// Create the new room; the constructor opens windows and registers members automatically.
	var/datum/group_mindlink_custom/link = new(participant_mobs)

	// 在房间历史里写下开场系统提示，并罗列当前全部成员，作为"会话开始"的第一条记录。
	// Seed the room with an opening system notice listing all members ("conversation started").
	var/list/participant_names = list()
	for(var/mob/living/member as anything in participant_mobs)
		participant_names += member.real_name
	link.add_system_message("心灵聊天室已建立。在场成员：[english_list(participant_names)]。输入文字并按回车开始交流。")

	// 再给每位成员一条聊天框提示，告知操作方式（窗口已弹出 + ,m 快捷发言 + IC 标签重开动词）。
	// Also chat-box each member the usage hint (window popped + ",m" shortcut + IC-tab reopen verb).
	for(var/mob/living/member as anything in participant_mobs)
		to_chat(member, span_notice("你被接入『心灵聊天室』。窗口已弹出——在底部输入文字并按回车即可实时交流，或在发言前输入 ,m 快捷发送。若关闭窗口，可在 IC 标签下使用『Group Mindlink』动词重新打开。"))

	// 把缺席/找不到的熟人名字反馈给施法者，让其知道哪些人没能接入。
	// Report missing acquaintances to the caster so they know who could not be linked.
	if(length(missing_names))
		to_chat(user, span_notice("这些熟识之人当前不在场或无法接入链接：[english_list(missing_names)]"))

	// 5 分钟后自动断开：用定时器回调 break_link，过期时发系统提示并销毁房间。
	// Auto-break after 5 minutes via a timer calling break_link, which expires + destroys the room.
	addtimer(CALLBACK(src, PROC_REF(break_link), link), 5 MINUTES)
	return TRUE

// 辅助：按真实姓名在全局人类列表里查找对应的活人，找不到返回 null。
// Helper: find a living human by real_name in the global human list, or null if absent.
/obj/effect/proc_holder/spell/invoked/group_mindlink/proc/find_known_human(person_name)
	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == person_name)
			return HL
	return null

// 定时回调：让链接过期（发系统提示）并销毁，窗口与信号由 Destroy() 统一清理。
// Timer callback: expire (notice) then destroy the link; Destroy() cleans up windows + signals.
/obj/effect/proc_holder/spell/invoked/group_mindlink/proc/break_link(datum/group_mindlink_custom/link)
	// 防御：链接已被提前销毁或已失效则无需重复处理。
	// Guard: nothing to do if the link was already destroyed or is inactive.
	if(!link || QDELETED(link) || !link.active)
		return
	link.notify_expired()
	qdel(link)

// =====================================================================================
// IC 标签动词：重新打开心灵聊天室对话窗口。
// 该动词只在 cast()/New() 把成员接入链接时通过 verbs |= 授予，链接结束（Destroy）时通过
// verbs -= 收回，所以它仅在"自己确实处于某个链接中"时出现在玩家的 IC 标签下。
// 这样玩家不慎关闭对话窗口后，随时能一键重开——等价于用户期望的"group mindlink 表情/指令"。
//（说明：BYOND 的 emote() 会把带空格的表情键当成自定义 *me 动作处理，因此带空格的"真表情键"
//  无法被正常派发；故此处采用引擎对"IC 动词"原生支持的方式实现，效果与表情一致且稳定可用。）
//
// IC-tab verb: reopen the mind-link chat dialogue window.
// It is granted (verbs |=) only when the mob is linked and revoked (verbs -=) on link teardown,
// so it shows in the IC tab ONLY while the player is actually in a link. This is the reopen path
// the user asked for. (Note: BYOND's emote() treats any space-containing emote key as a custom *me
// action, so a real spaced emote key can't dispatch; an IC-category verb is the engine-native,
// reliable equivalent.)
// =====================================================================================
/mob/living/proc/group_mindlink_reopen()
	// 在 IC 标签下显示为"Group Mindlink"，与用户要求的名称一致。
	// Shows up under the IC tab as "Group Mindlink", matching the requested name.
	set name = "Group Mindlink"
	set category = "IC"
	set desc = "重新打开你的群体心灵链接对话窗口。"

	// 从全局表查出本人当前所属的聊天室；不存在/已失效则说明链接已结束。
	// Look up the room this mob belongs to; absent/inactive means the link has already ended.
	var/datum/group_mindlink_custom/link = GLOB.active_group_mindlinks[src]
	if(!link || !link.active || !(src in link.participants))
		// 链接已不存在：提示玩家，并顺手收回这个已失效的残留动词（防止 Destroy 未能清理的边角情况）。
		// No live link: inform the player and self-revoke this stale verb (covers any teardown edge case).
		to_chat(src, span_warning("我此刻并不处于任何群体心灵链接之中。"))
		verbs -= /mob/living/proc/group_mindlink_reopen
		return

	// 重新打开（或刷新）本人的对话窗口；open_window_for 内部已含客户端等防御检查。
	// Reopen (or refresh) this member's dialogue window; open_window_for guards for client etc.
	link.open_window_for(src)
	to_chat(src, span_notice("我重新接通了心灵聊天室。"))

// 清理本文件定义的局部宏，避免污染全局命名空间。
// Undefine the file-local macro to avoid leaking it into the global namespace.
#undef GROUP_MINDLINK_WINDOW_ID
