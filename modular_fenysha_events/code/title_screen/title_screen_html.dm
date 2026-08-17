/// Cap on how many boot lines the terminal keeps on screen at once.
#define MAX_STARTUP_MESSAGES 1

/mob/dead/new_player/proc/get_title_html()
	var/dat = SStitlescreen.title_html
	dat += {"<img src="[TITLE_IMAGE_RESOURCE]" class="bg" alt="" draggable="false" ondragstart="return false;">"}

	if(SSticker.current_state == GAME_STATE_STARTUP)
		dat += build_startup_terminal()
	else
		dat += build_title_menu()

	// Tells the server the page is live and can receive output() calls.
	if(!title_screen_is_ready)
		dat += {"<script>location.href = "byond://?src=[REF(get_title_menu())];title_is_ready=1";</script>"}

	dat += "</body></html>"
	return dat

/// Boot terminal plus the predictive loading bar.
/mob/dead/new_player/proc/build_startup_terminal()
	var/dat = {"<div class="container_terminal" id="terminal"></div>"}
	dat += {"<div class="container_progress" id="progress_container"><div class="progress_bar" id="progress"></div></div>"}

	dat += {"
	<script language="JavaScript">
		var terminal = document.getElementById("terminal");
		var terminal_lines = \[
	"}

	for(var/message in GLOB.startup_messages)
		dat += {""[replacetext(message, "\"", "\\\"")]","}

	dat += {"
		\];

		function append_terminal_text(text) {
			if(text) { terminal_lines.push(text); }
			while(terminal_lines.length > [MAX_STARTUP_MESSAGES]) { terminal_lines.shift(); }
			terminal.innerHTML = terminal_lines.join("");
		}
		append_terminal_text();

		var progress_bar = document.getElementById("progress");
		// Milliseconds, real wall clock.
		var previous_tick = new Date().getTime();
		// Everything below is in tenths of a second, like BYOND.
		var progress_current_time = [SStitlescreen.elapsed_boot_time()];
		var progress_completion_time = [SStitlescreen.average_completion_time];
		var progress_current_position = 0;

		function real_position() {
			// A zero estimate would divide to Infinity, which clamps to a permanent 100%.
			if(!(progress_completion_time > 0)) { progress_completion_time = 1; }
			// Boot has outrun the estimate. Stretch it so the bar keeps creeping rather than
			// sitting pinned at the end for the rest of the load.
			if(progress_current_time >= progress_completion_time) {
				progress_completion_time = progress_current_time * 1.15;
			}
			return progress_current_time / progress_completion_time * 100;
		}

		function draw_progress() {
			progress_bar.style.width = "" + progress_current_position + "%";
		}

		setInterval(function() {
			// Keep creeping on wall clock between server messages, otherwise the bar freezes
			// for the whole of a long silent step like map load.
			var current_tick = new Date().getTime();
			progress_current_time += (current_tick - previous_tick) / 100;
			previous_tick = current_tick;

			// Forwards only between server updates, and never quite full - reaching 100 is
			// the server's call, not something we extrapolate our way into.
			progress_current_position = Math.min(Math.max(real_position(), progress_current_position), 99);
			draw_progress();
		}, 16.666666667);

		function update_loading_progress(current_time, total_time) {
			progress_current_time = parseFloat(current_time);
			progress_completion_time = parseFloat(total_time);
			previous_tick = new Date().getTime();
			// The server is authoritative. Without this the ratchet above would make a single
			// bad reading stick for the whole load.
			progress_current_position = Math.min(real_position(), 99);
			draw_progress();
		}

		function update_status() {}
		function toggle_ready() {}
	</script>
	"}
	return dat

/// The lobby menu proper.
/mob/dead/new_player/proc/build_title_menu()
	var/datum/fenysha_title_menu/menu = get_title_menu()
	var/menu_ref = REF(menu)
	var/dat = ""

	if(SStitlescreen.current_notice)
		dat += {"<div class="container_notice"><p class="menu_notice">[SStitlescreen.current_notice]</p></div>"}

	dat += {"<div class="container_nav">"}

	if(SSticker.current_state <= GAME_STATE_PREGAME)
		dat += {"<a id="ready" class="menu_button" href='byond://?src=[menu_ref];toggle_ready=1'>[ready == PLAYER_READY_TO_PLAY ? "<span class='checked'>&#9745;</span> READY" : "<span class='unchecked'>&#9746;</span> READY"]</a>"}
	else
		dat += {"<a class="menu_button" href='byond://?src=[menu_ref];late_join=1'>JOIN THE VALE</a>"}
		dat += {"<a class="menu_button" href='byond://?src=[menu_ref];manifest=1'>FOLK OF THE VALE</a>"}

	dat += {"<a class="menu_button" href='byond://?src=[menu_ref];observe=1'>OBSERVE</a>"}

	var/character_name = uppertext(client?.prefs?.real_name || "UNNAMED")
	dat += {"
		<hr>
		<a class="menu_button" href='byond://?src=[menu_ref];character_setup=1'>SETUP CHARACTER (<span id="character_slot">[character_name]</span>)</a>
		<a class="menu_button" href='byond://?src=[menu_ref];game_options=1'>GAME OPTIONS</a>
		<a class="menu_button" href='byond://?src=[menu_ref];keybinds=1'>KEYBINDS</a>
		<hr>
		<a class="menu_button" href='byond://?src=[menu_ref];lore_primer=1'>LORE PRIMER</a>
		<a class="menu_button" href='byond://?src=[menu_ref];changelog=1'>CHANGELOG</a>
	"}

	if(!IsGuestKey(key))
		dat += build_poll_button(menu_ref)

	dat += {"<hr><span class="menu_status" id="status">[SStitlescreen.build_status_line(src)]</span>"}
	dat += "</div>"

	dat += {"
	<script language="JavaScript">
		const PLAYER_READY_TO_PLAY = "[PLAYER_READY_TO_PLAY]";
		var ready_mark = document.getElementById("ready");
		function toggle_ready(setReady) {
			if(!ready_mark) { return; }
			if(setReady === PLAYER_READY_TO_PLAY) {
				ready_mark.innerHTML = "<span class='checked'>&#9745;</span> READY";
			} else {
				ready_mark.innerHTML = "<span class='unchecked'>&#9746;</span> READY";
			}
		}

		var status_line = document.getElementById("status");
		function update_status(text) {
			if(status_line) { status_line.innerHTML = text; }
		}

		var character_name_slot = document.getElementById("character_slot");
		function update_current_character(name) {
			if(character_name_slot) { character_name_slot.textContent = name.toUpperCase(); }
		}

		function append_terminal_text() {}
		function update_loading_progress() {}
	</script>
	"}
	return dat

/// Flags the button when the player has polls they haven't answered.
/mob/dead/new_player/proc/build_poll_button(menu_ref)
	if(!SSdbcore.Connect())
		return ""

	var/isadmin = client?.holder ? 1 : 0
	var/datum/DBQuery/query_get_new_polls = SSdbcore.NewQuery({"
		SELECT id FROM [format_table_name("poll_question")]
		WHERE (adminonly = 0 OR :isadmin = 1)
		AND Now() BETWEEN starttime AND endtime
		AND deleted = 0
		AND id NOT IN (SELECT pollid FROM [format_table_name("poll_vote")] WHERE ckey = :ckey AND deleted = 0)
		AND id NOT IN (SELECT pollid FROM [format_table_name("poll_textreply")] WHERE ckey = :ckey AND deleted = 0)
	"}, list("isadmin" = isadmin, "ckey" = ckey))

	var/output = ""
	if(query_get_new_polls.Execute())
		if(query_get_new_polls.NextRow())
			output = {"<a class="menu_button menu_newpoll" href='byond://?src=[menu_ref];polls=1'>POLLS (NEW)</a>"}
		else
			output = {"<a class="menu_button" href='byond://?src=[menu_ref];polls=1'>POLLS</a>"}
	qdel(query_get_new_polls)
	return output

#undef MAX_STARTUP_MESSAGES
