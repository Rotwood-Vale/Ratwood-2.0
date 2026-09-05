/// Cap on how many boot lines the terminal keeps on screen at once.
#define MAX_STARTUP_MESSAGES 1

/mob/dead/new_player/proc/get_title_html()
	var/dat = TITLE_DEFAULT_HTML
	if(SSticker.current_state == GAME_STATE_STARTUP)
		dat += build_startup_terminal()
	else
		dat += build_title_menu()

	// Tells the server the page is live and can receive output() calls.
	if(!title_screen_is_ready)
		var/datum/fenysha_title_menu/menu = get_title_menu()
		var/menu_ref = menu ? REF(menu) : REF(src)
		dat += {"<script>location.href = "byond://?src=[menu_ref];title_is_ready=1";</script>"}

	dat += "</body></html>"
	return dat

/// Boot terminal plus the SVG progress ring.
/mob/dead/new_player/proc/build_startup_terminal()
	var/dat = {"<img src="[TITLE_LOADING_RESOURCE]" class="bg" id="bg_layer" alt="">"}
	dat += {"
	<div class="container_loading" id="parallax_loader">
		<div class="terminal_text" id="terminal"></div>
		<svg class="progress_ring" width="60" height="60">
			<circle class="progress_ring_bg" stroke="rgba(240, 211, 11, 1)" stroke-width="4" fill="transparent" r="24" cx="30" cy="30"/>
			<circle class="progress_ring_circle" id="progress_circle" stroke="#a19020" stroke-width="4" fill="transparent" r="24" cx="30" cy="30"/>
		</svg>
	</div>
	"}

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
			var last_msg = terminal_lines.slice(-1);
			terminal.innerHTML = last_msg.length ? last_msg.pop() : '';
		}
		append_terminal_text();

		var circle = document.getElementById("progress_circle");
		var radius = circle.r.baseVal.value;
		var circumference = 2 * Math.PI * radius;
		circle.style.strokeDasharray = circumference + ' ' + circumference;
		circle.style.strokeDashoffset = circumference;

		function setProgress(percent) {
			var offset = circumference - (percent / 100 * circumference);
			circle.style.strokeDashoffset = offset;
		}

		var previous_tick = new Date().getTime();
		var progress_current_time = [SStitlescreen.elapsed_boot_time()];
		var progress_completion_time = [SStitlescreen.average_completion_time];
		var progress_current_position = 0;

		setInterval(function() {
			if(progress_current_time < progress_completion_time) {
				var current_tick = new Date().getTime();
				progress_current_time += (current_tick - previous_tick) / 100;
				previous_tick = current_tick;
			}

			progress_current_position = Math.min(Math.max(progress_current_time / progress_completion_time * 100, progress_current_position), 100);
			setProgress(progress_current_position);
		}, 16.666666667);

		function update_loading_progress(current_time, total_time) {
			progress_current_time = parseFloat(current_time);
			progress_completion_time = parseFloat(total_time);
		}

		function update_status() {}
		function toggle_ready() {}
		function toggle_body_horror() {}
		function update_current_character() {}
	</script>
	"}
	return dat

/// The lobby menu proper.
/mob/dead/new_player/proc/build_title_menu()
	var/datum/fenysha_title_menu/menu = get_title_menu()
	var/menu_ref = menu ? REF(menu) : REF(src)
	var/dat = {"<img src="[TITLE_IMAGE_RESOURCE]" class="bg" id="bg_layer" alt="">"}

	if(SStitlescreen.current_notice)
		dat += {"<div class="container_notice"><p class="menu_notice">[SStitlescreen.current_notice]</p></div>"}

	dat += {"<div class="container_nav" id="parallax_nav">"}

	if(!SSticker || SSticker.current_state <= GAME_STATE_PREGAME)
		dat += {"<a id="ready" class="menu_button" href='byond://?src=[menu_ref];toggle_ready=1'>[ready == PLAYER_READY_TO_PLAY ? "<span class='checked'>☑</span> READY" : "<span class='unchecked'>☒</span> READY"]</a>"}
	else
		dat += {"
			<a class="menu_button" href='byond://?src=[menu_ref];late_join=1'>JOIN GAME</a>
		"}

	dat += {"<a class="menu_button" href='byond://?src=[menu_ref];observe=1'>OBSERVE</a>"}

	dat += {"
		<hr>
		<a class="menu_button" href='byond://?src=[menu_ref];character_setup=1'>SETUP CHARACTER</a>
		<a class="menu_button" href='byond://?src=[menu_ref];game_options=1'>SETTINGS</a>
		<a id="be_antag" class="menu_button" href='byond://?src=[menu_ref];toggle_antag=1'>[client?.prefs?.be_special ? "<span class='checked'>☑</span> BE SPECIAL" : "<span class='unchecked'>☒</span> BE SPECIAL"]</a>
		<a id="body_horror" class="menu_button" href='byond://?src=[menu_ref];toggle_bodyhorror=1'>[(client?.prefs?.toggles & BODY_HORROR) ? "<span class='checked'>☑</span> BODY HORROR" : "<span class='unchecked'>☒</span> BODY HORROR"]</a>
	"}

	if(!IsGuestKey(key))
		dat += build_poll_button(menu_ref)

	var/character_name = uppertext(client?.prefs?.real_name || "UNNAMED")
	dat += {"
		<div class="character_display">
			CURRENT CHARACTER:<br>
			<span id="character_slot" class="character_name">[character_name]</span>
		</div>
	"}

	dat += "</div>"

	dat += {"
	<script language="JavaScript">
		const PLAYER_READY_TO_PLAY = "[PLAYER_READY_TO_PLAY]";
		const PLAYER_NOT_READY = "[PLAYER_NOT_READY]";
		var ready_mark = document.getElementById("ready");
		function toggle_ready(setReady) {
			if(!ready_mark) { return; }
			if(setReady === PLAYER_READY_TO_PLAY) {
				ready_mark.innerHTML = "<span class='checked'>☑</span> READY";
			} else {
				ready_mark.innerHTML = "<span class='unchecked'>☒</span> READY";
			}
		}

		var antag_int = 0;
		var antag_mark = document.getElementById("be_antag");
		var antag_marks = \[ "<span class='unchecked'>☒</span> BE ANTAGONIST", "<span class='checked'>☑</span> BE ANTAGONIST" \];
		function toggle_antag(setAntag) {
			if(!antag_mark) { return; }
			if(setAntag) {
				antag_int = setAntag;
				antag_mark.innerHTML = antag_marks\[antag_int\];
			} else {
				antag_int++;
				if (antag_int === antag_marks.length) { antag_int = 0; }
				antag_mark.innerHTML = antag_marks\[antag_int\];
			}
		}

		var horror_mark = document.getElementById("body_horror");
		function toggle_body_horror(setHorror) {
			if(!horror_mark) { return; }
			// Loose compare on purpose: output() arrives as a string, and "0"
			// is truthy, so a plain if() would read off as on.
			if(setHorror == 1) {
				horror_mark.innerHTML = "<span class='checked'>☑</span> BODY HORROR";
			} else {
				horror_mark.innerHTML = "<span class='unchecked'>☒</span> BODY HORROR";
			}
		}

		var character_name_slot = document.getElementById("character_slot");
		function update_current_character(name) {
			if(character_name_slot) { character_name_slot.textContent = name.toUpperCase(); }
		}

		function append_terminal_text() {}
		function update_loading_progress() {}
		function update_status() {}
		function toggle_translate() {}

		document.addEventListener("mousemove", function(e) {
			var cx = window.innerWidth / 2;
			var cy = window.innerHeight / 2;
			var dx = (e.clientX - cx) / cx;
			var dy = (e.clientY - cy) / cy;

			var nav = document.getElementById("parallax_nav");
			var bg = document.getElementById("bg_layer");

			if (nav) { nav.style.transform = "translate(" + (dx * 15) + "px, calc(-50% + " + (dy * 15) + "px))"; }
			if (bg) { bg.style.transform = "translate(calc(-50% + " + (-dx * 10) + "px), calc(-50% + " + (-dy * 10) + "px))"; }
		});
	</script>
	"}
	return dat

/mob/dead/new_player/proc/get_default_title_html()
	var/dat = SStitlescreen.title_html
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
