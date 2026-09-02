GLOBAL_LIST_EMPTY(startup_messages)

SUBSYSTEM_DEF(titlescreen)
	name = "Fenysha Title Screen"
	init_order = INIT_ORDER_TITLE
	priority = FIRE_PRIORITY_DEFAULT
	wait = 2 SECONDS
	// Includes GAME so lobby-sitters still get the post-roundstart menu and a live status line.
	runlevels = RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME

	/// Preamble markup - everything up to and including <body>.
	var/title_html = TITLE_DEFAULT_HTML
	/// Which menu layout the rendered pages are built for. A change forces a full re-render.
	var/last_menu_variant
	/// Backdrop currently being displayed, as a resource reference. Seeded so it is never null:
	/// players connecting mid-boot need a valid image before Initialize() has picked one.
	var/current_title_screen = TITLE_DEFAULT_SCREEN_IMAGE
	/// Admin-set red banner text, or null.
	var/current_notice
	/// Backdrops eligible for the rotation, as resource references.
	var/list/title_screens = list()

	/// Deciseconds we expect this map to take to load.
	var/average_completion_time = TITLE_DEFAULT_LOADTIME
	/// Startup message key => average deciseconds into boot that it appeared.
	var/list/startup_message_timings = list()
	/// Decoded cache file, nulled once written back.
	var/list/progress_json = list()
	/// world.timeofday we are treating as boot time zero.
	var/progress_reference_time = 0

/datum/controller/subsystem/titlescreen/Initialize()
	if(fexists(TITLE_HTML_CONFIG_PATH))
		title_html = file2text(TITLE_HTML_CONFIG_PATH)

	SSmapping.HACK_LoadMapConfig()

	var/list/provisional = flist("[global.config.directory]/title_screens/images/")
	var/list/matched = list()
	var/use_rare_screens = prob(1)

	for(var/screen in provisional)
		var/list/parts = splittext(screen, "+")
		if(length(parts) == 1)
			if(parts[1] != "exclude" && parts[1] != "blank.png")
				matched += screen
			continue
		if((use_rare_screens && LOWER_TEXT(parts[1]) == "rare") || LOWER_TEXT(parts[1]) == LOWER_TEXT(SSmapping.current_map.map_name))
			matched += screen

	for(var/screen in matched)
		var/loaded = load_title_image(screen)
		if(loaded)
			title_screens += loaded

	check_progress_reference_time()
	load_progress_json()

	// The boot screen deliberately reuses the lobby backdrop rather than a separate splash.
	current_title_screen = TITLE_DEFAULT_SCREEN_IMAGE // pick_title_screen()

	GLOB.admin_verbs_fun += list(/client/proc/fenysha_change_title_screen, /client/proc/fenysha_set_title_notice)
	GLOB.admin_verbs_admin += /client/proc/fenysha_fix_title_screen
	GLOB.admin_verbs_debug += /client/proc/fenysha_set_title_html

	return ..()

/// Caches a config image into the rsc and hands back a reference browse() can send as-is.
/datum/controller/subsystem/titlescreen/proc/load_title_image(file_name)
	var/path = "[global.config.directory]/title_screens/images/[file_name]"
	if(!fexists(path))
		return null
	return fcopy_rsc(path)

/datum/controller/subsystem/titlescreen/proc/pick_title_screen()
	if(length(title_screens))
		return pick(title_screens)
	return TITLE_DEFAULT_SCREEN_IMAGE

/**
 * Which set of buttons the page should be showing.
 *
 * The menu is baked into the HTML, so output() can't swap READY for JOIN - crossing one of these
 * boundaries needs a full re-render.
 */
/datum/controller/subsystem/titlescreen/proc/get_menu_variant()
	if(!SSticker || SSticker.current_state == GAME_STATE_STARTUP)
		return "startup"
	if(SSticker.current_state <= GAME_STATE_PREGAME)
		return "pregame"
	return "started"

/datum/controller/subsystem/titlescreen/fire(resumed = FALSE)
	if(last_menu_variant != get_menu_variant())
		show_title_screen()
		return

	for(var/mob/dead/new_player/player in GLOB.new_player_list)
		if(!player.client || !player.title_screen_is_ready)
			continue
		player.client << output(build_status_line(player), "[TITLE_BROWSER_ID]:update_status")
		if(MC_TICK_CHECK)
			return

/// The live timer / readied-player line under the menu.
/datum/controller/subsystem/titlescreen/proc/build_status_line(mob/dead/new_player/player)
	if(!SSticker || SSticker.HasRoundStarted())
		return "ROUND IN PROGRESS"

	var/time_remaining = SSticker.GetTimeLeft()
	var/timer_text
	if(time_remaining > 0)
		timer_text = "THE GAME BEGINS IN [round(time_remaining / 10)]s"
	else if(time_remaining == -10)
		timer_text = "THE GAME IS DELAYED"
	else
		timer_text = "THE GAME BEGINS SOON"

	return "[timer_text] &mdash; [SSticker.totalPlayersReady] READY"

/// Make sure reference time is set up. If not, this is now time zero.
/datum/controller/subsystem/titlescreen/proc/check_progress_reference_time()
	if(!progress_reference_time)
		progress_reference_time = world.timeofday

/**
 * Deciseconds since we started counting this boot.
 *
 * Guards the reference time first: unset, this would return "deciseconds since midnight", which
 * dwarfs any estimate and pegs the progress bar at 100% for the whole load.
 */
/datum/controller/subsystem/titlescreen/proc/elapsed_boot_time()
	check_progress_reference_time()
	return max(0, world.timeofday - progress_reference_time)

/// Persist this round's timings the first time we leave startup.
/datum/controller/subsystem/titlescreen/proc/check_finish_progress()
	if(progress_json && SSticker.current_state >= GAME_STATE_PREGAME)
		save_progress_json()

/datum/controller/subsystem/titlescreen/proc/load_progress_json()
	var/json_file = file(TITLE_PROGRESS_CACHE_FILE)
	if(!fexists(json_file))
		return

	progress_json = json_decode(file2text(json_file))

	if(progress_json["_version"] != TITLE_PROGRESS_CACHE_VERSION)
		progress_json.Cut()
		return

	var/list/map_info = progress_json[SSmapping.current_map.map_name]
	if(!islist(map_info))
		return

	average_completion_time = max(map_info["total"] || TITLE_DEFAULT_LOADTIME, TITLE_MIN_LOADTIME)
	startup_message_timings = map_info["messages"] || list()

/datum/controller/subsystem/titlescreen/proc/save_progress_json()
	var/json_file = file(TITLE_PROGRESS_CACHE_FILE)
	var/list/map_info = list()

	progress_json["_version"] = TITLE_PROGRESS_CACHE_VERSION

	// Latest run is worth a quarter of the running average.
	if(progress_json[SSmapping.current_map.map_name])
		map_info["total"] = max(0.75 * average_completion_time + 0.25 * elapsed_boot_time(), TITLE_MIN_LOADTIME)
	else
		map_info["total"] = max(elapsed_boot_time(), TITLE_MIN_LOADTIME)
	map_info["messages"] = startup_message_timings
	progress_json[SSmapping.current_map.map_name] = map_info

	fdel(json_file)
	WRITE_FILE(json_file, json_encode(progress_json))

	progress_json = null

/datum/controller/subsystem/titlescreen/Recover()
	title_html = SStitlescreen.title_html
	current_title_screen = SStitlescreen.current_title_screen
	current_notice = SStitlescreen.current_notice
	title_screens = SStitlescreen.title_screens
	average_completion_time = SStitlescreen.average_completion_time
	startup_message_timings = SStitlescreen.startup_message_timings
	progress_json = SStitlescreen.progress_json
	progress_reference_time = SStitlescreen.progress_reference_time

/// Rebuild and resend the page to every player sitting in the lobby.
/datum/controller/subsystem/titlescreen/proc/show_title_screen()
	last_menu_variant = get_menu_variant()
	for(var/mob/dead/new_player/player in GLOB.new_player_list)
		INVOKE_ASYNC(player, TYPE_PROC_REF(/mob/dead/new_player, show_title_screen))

/// Big red banner text across the title screen. Pass null to clear.
/datum/controller/subsystem/titlescreen/proc/set_notice(new_notice)
	current_notice = new_notice ? sanitize_text(new_notice) : null
	show_title_screen()

/// Swap the backdrop. With no argument, rolls a fresh one from the configured pool.
/datum/controller/subsystem/titlescreen/proc/change_title_screen(new_screen)
	current_title_screen = new_screen || pick_title_screen()
	check_finish_progress()
	show_title_screen()

/**
 * Push a boot message to everyone watching the loading terminal.
 *
 * Arguments:
 * * msg - the line to show.
 * * warning - TRUE to mark it as an error.
 */
/proc/add_startup_message(msg, warning)
	// Strip the varying duration out so the same line keys to the same cached timing.
	var/static/regex/msg_key_regex = new(@"[0-9.]+( second)?s?!", "ig")

	var/msg_html = {"<p class="terminal_text">[warning ? "! " : ""][msg]</p>"}
	var/msg_key = msg_key_regex.Replace(msg, "#")

	GLOB.startup_messages += msg_html

	SStitlescreen.check_progress_reference_time()

	var/old_timing = SStitlescreen.startup_message_timings[msg_key]
	var/elapsed = SStitlescreen.elapsed_boot_time()
	var/new_timing
	if(!old_timing)
		new_timing = elapsed
	else
		new_timing = 0.75 * old_timing + 0.25 * elapsed
	SStitlescreen.startup_message_timings[msg_key] = new_timing

	for(var/mob/dead/new_player/player in GLOB.new_player_list)
		if(!player.client || !player.title_screen_is_ready)
			continue
		player.client << output(msg_html, "[TITLE_BROWSER_ID]:append_terminal_text")
		player.client << output(list2params(list(new_timing, SStitlescreen.average_completion_time)), "[TITLE_BROWSER_ID]:update_loading_progress")
