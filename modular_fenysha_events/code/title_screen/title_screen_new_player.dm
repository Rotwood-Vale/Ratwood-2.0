/mob/dead/new_player
	/// TRUE once the page has reported back that it can receive output() calls.
	var/title_screen_is_ready = FALSE
	/// Owns the title screen's button hrefs. See /datum/fenysha_title_menu.
	var/datum/fenysha_title_menu/title_menu

/mob/dead/new_player/proc/get_title_menu()
	if(!title_menu)
		title_menu = new(src)
	return title_menu

/**
 * Everything the page loads by name: the font and both backdrops.
 *
 * keep_local_name is required. Without it the transport renames each file to asset.<hash>.<ext>,
 * and the page's <img src> / CSS url() - which have to be written out ahead of time - never resolve.
 */
/datum/asset/simple/lobby
	keep_local_name = TRUE
	assets = list(
		"OCRAExtended.ttf" = 'modular_fenysha_events/html/OCRAEXT.TTF',
		TITLE_LOADING_RESOURCE = TITLE_DEFAULT_LOADING_IMAGE,
		TITLE_IMAGE_RESOURCE = TITLE_DEFAULT_SCREEN_IMAGE,
	)

/// Reveals the title browser and renders the current page into it.
/mob/dead/new_player/proc/show_title_screen()
	if(!client)
		return

	winset(src, TITLE_BROWSER_ID, "is-disabled=false;is-visible=true")

	var/datum/asset/simple/lobby/lobby_assets = get_asset_datum(/datum/asset/simple/lobby)
	lobby_assets.send(src)

	update_title_screen()

/// Rebuilds the page. Causes a visible flicker, so avoid it for live updates - use output() instead.
/mob/dead/new_player/proc/update_title_screen()
	if(!client)
		return

	// The stock backdrops ride the asset cache above. Only a runtime swap - an admin upload or a
	// config screen - needs sending here, under the same name so the markup doesn't have to change.
	if(SStitlescreen.current_loading_screen != TITLE_DEFAULT_LOADING_IMAGE)
		src << browse(SStitlescreen.current_loading_screen, "file=[TITLE_LOADING_RESOURCE];display=0")
	if(SStitlescreen.current_title_screen != TITLE_DEFAULT_SCREEN_IMAGE)
		src << browse(SStitlescreen.current_title_screen, "file=[TITLE_IMAGE_RESOURCE];display=0")
	src << browse(get_title_html(), "window=[TITLE_BROWSER_ID]")

/**
 * Hides the title browser, handing the screen back to the map.
 *
 * Lives on /mob rather than /mob/dead/new_player because the client has already been handed to its
 * new mob by the time the lobby mob would notice - Logout() runs with a null client. The mobs the
 * player actually lands on call this from their Login().
 */
/mob/proc/hide_title_screen()
	if(!client)
		return
	winset(client, TITLE_BROWSER_ID, "is-disabled=true;is-visible=false")

/mob/dead/new_player/hide_title_screen()
	title_screen_is_ready = FALSE
	return ..()

/**
 * Receiver for the title screen's button hrefs.
 *
 * The title screen deliberately does not route every button through /mob/dead/new_player/Topic():
 * that proc falls through to new_player_panel() for anything it doesn't return early on, which
 * would pop the character window open behind the lobby. Buttons RT's Topic handles cleanly are
 * delegated to it; the rest are handled here.
 *
 * Holds its owner weakly so the pair doesn't form a reference cycle with the mob.
 */
/datum/fenysha_title_menu
	var/datum/weakref/owner_ref

/datum/fenysha_title_menu/New(mob/dead/new_player/new_owner)
	. = ..()
	owner_ref = WEAKREF(new_owner)

/datum/fenysha_title_menu/Topic(href, list/href_list)
	var/mob/dead/new_player/owner = owner_ref?.resolve()
	if(!owner || owner != usr || !owner.client)
		return

	if(href_list["title_is_ready"])
		owner.title_screen_is_ready = TRUE
		return

	// Handled by RT's own Topic, which returns before its new_player_panel() fallthrough.
	var/static/list/delegated = list(
		"character_setup" = "show_preferences",
		"game_options" = "show_options",
		"keybinds" = "show_keybinds",
		"changelog" = "open_changelog",
		"late_join" = "late_join",
	)
	for(var/key in delegated)
		if(href_list[key])
			owner.Topic(href, list("[delegated[key]]" = "1"))
			return

	if(href_list["manifest"])
		owner.ViewManifest()
		return

	if(href_list["polls"])
		owner.handle_player_polling()
		return

	if(href_list["lore_primer"])
		owner.do_rp_prompt()
		return

	if(href_list["observe"])
		owner.ready = PLAYER_READY_TO_OBSERVE
		owner.make_me_an_observer()
		return

	if(href_list["toggle_ready"])
		toggle_ready(owner)
		return

	if(href_list["toggle_bodyhorror"])
		toggle_bodyhorror(owner)
		return

/**
 * Flips the body horror pref from the lobby.
 *
 * Hands off to the client proc rather than touching the flag here, so the
 * chat feedback and the save go through the one path the options menu uses.
 * The button is then repainted by output() rather than by rebuilding the page,
 * which would flicker the whole lobby.
 */
/datum/fenysha_title_menu/proc/toggle_bodyhorror(mob/dead/new_player/owner)
	var/client/player = owner.client
	if(!player?.prefs)
		return
	player.toggle_bodyhorror()
	player << output((player.prefs.toggles & BODY_HORROR) ? "1" : "0", "[TITLE_BROWSER_ID]:toggle_body_horror")

/datum/fenysha_title_menu/proc/toggle_ready(mob/dead/new_player/owner)
	if(SSticker.current_state > GAME_STATE_PREGAME)
		to_chat(owner, span_boldwarning("The game is starting. You cannot ready up now."))
		return

	if(owner.ready == PLAYER_READY_TO_PLAY)
		if(SSticker.job_change_locked)
			return
		owner.ready = PLAYER_NOT_READY
	else
		var/datum/preferences/prefs = owner.client.prefs
		if(length(prefs.flavortext) < MINIMUM_FLAVOR_TEXT)
			to_chat(owner, span_boldwarning("You need a minimum of [MINIMUM_FLAVOR_TEXT] characters in your flavor text in order to play."))
			return
		if(length(prefs.ooc_notes) < MINIMUM_OOC_NOTES)
			to_chat(owner, span_boldwarning("You need at least a few words in your OOC notes in order to play."))
			return
		owner.ready = PLAYER_READY_TO_PLAY

	owner.client << output(owner.ready, "[TITLE_BROWSER_ID]:toggle_ready")
