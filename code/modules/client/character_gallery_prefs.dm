/datum/preferences
	/// Fingerprint of the character form's gallery values when last loaded or successfully saved, null when unknown
	var/saved_character_gallery
	var/saved_gnoll_gallery
	var/list/gallery_fingerprints
	var/character_gallery_generation = 0
	var/datum/character_gallery/character_gallery
	var/last_logged_framing

/datum/preferences/proc/character_gallery_headshot_thumbnail()
	if(!headshot_link)
		return ""
	return "<div style='display: inline-block; vertical-align: top; text-align: center; margin: 4px 6px 0 0;'><div style='width: 100px; height: 100px; overflow: hidden; border: 1px solid #555;'><img src='[GALLERY_ATTRIBUTE_LINK(headshot_link)]' style='width: 100%; height: 100%; [headshot_picture_style(headshot_zoom, headshot_x, headshot_y)]'></div><div style='font-size: 85%;'>Headshot</div></div>"

/// Updates the open character sheet when closing the gallery changes what it shows
/datum/preferences/proc/refresh_gallery_preferences_menu(mob/user)
	if(slot_randomized)
		ShowChoices(user, refresh_only = TRUE)
		return
	if(current_tab != 0 || !("Flavor Text" in open_categories))
		return
	if(displayed_gallery_headshot == character_gallery_headshot_thumbnail())
		return
	if(!user?.client || winget(user, "preferencess_window", "is-visible") != "true" || !user?.client)
		return
	if(current_tab != 0 || !("Flavor Text" in open_categories))
		return
	var/thumbnail = character_gallery_headshot_thumbnail()
	if(displayed_gallery_headshot != thumbnail)
		displayed_gallery_headshot = thumbnail
		send_byjax(user, "preferences_browser", "preferences_gallery_headshot", thumbnail)

/datum/preferences/proc/load_gallery_toggles(savefile/S)
	S["gallery_plain"]	>> gallery_plain
	gallery_plain = sanitize_integer(gallery_plain, FALSE, TRUE, FALSE)
	S["gallery_backdrop"]	>> gallery_backdrop
	gallery_backdrop = sanitize_gallery_backdrop_toggle(gallery_backdrop)
	S["gallery_card_deal"]	>> gallery_card_deal
	gallery_card_deal = sanitize_integer(gallery_card_deal, FALSE, TRUE, TRUE)
	S["gallery_image_sounds"]	>> gallery_image_sounds
	gallery_image_sounds = sanitize_integer(gallery_image_sounds, FALSE, TRUE, TRUE)
	S["gallery_image_tilt"]	>> gallery_image_tilt
	gallery_image_tilt = sanitize_integer(gallery_image_tilt, FALSE, TRUE, TRUE)
	S["gallery_candle_flicker"]	>> gallery_candle_flicker
	gallery_candle_flicker = sanitize_integer(gallery_candle_flicker, FALSE, TRUE, TRUE)
	S["gallery_easter_eggs"]	>> gallery_easter_eggs
	gallery_easter_eggs = sanitize_integer(gallery_easter_eggs, FALSE, TRUE, TRUE)
	var/saved_preview_layout
	S["gallery_artwork_preview_layout"] >> saved_preview_layout
	if(isnull(saved_preview_layout))
		var/legacy_preview_bottom
		S["gallery_artwork_preview_bottom"] >> legacy_preview_bottom
		if(legacy_preview_bottom == FALSE)
			saved_preview_layout = "side"
	if(!set_gallery_artwork_preview_layout(saved_preview_layout))
		gallery_artwork_preview_layout = initial(gallery_artwork_preview_layout)

/datum/preferences/proc/set_gallery_artwork_preview_layout(layout)
	if(!(layout in list("side", "popup")))
		return FALSE
	gallery_artwork_preview_layout = layout
	return TRUE

/datum/preferences/proc/change_gallery_artwork_preview_layout(layout)
	if(layout == gallery_artwork_preview_layout || !set_gallery_artwork_preview_layout(layout))
		return FALSE
	if(gallery_artwork_preview_layout != "popup")
		character_gallery?.close_artwork_preview()
	save_preferences()
	return TRUE

/datum/preferences/proc/save_gallery_toggles(savefile/S)
	WRITE_FILE(S["gallery_plain"], gallery_plain)
	WRITE_FILE(S["gallery_backdrop"], gallery_backdrop)
	WRITE_FILE(S["gallery_card_deal"], gallery_card_deal)
	WRITE_FILE(S["gallery_image_sounds"], gallery_image_sounds)
	WRITE_FILE(S["gallery_image_tilt"], gallery_image_tilt)
	WRITE_FILE(S["gallery_candle_flicker"], gallery_candle_flicker)
	WRITE_FILE(S["gallery_easter_eggs"], gallery_easter_eggs)
	WRITE_FILE(S["gallery_artwork_preview_layout"], gallery_artwork_preview_layout)

/datum/preferences/proc/character_gallery_state()
	return json_encode(list(headshot_frame_chat, gallery_form_state(src)))

/datum/preferences/proc/gnoll_gallery_state()
	return json_encode(gallery_form_state(gnoll_prefs))

/datum/preferences/proc/gallery_dirty()
	if(!gallery_fingerprints)
		gallery_fingerprints = list(character_gallery_state(), null)
	if(saved_character_gallery != gallery_fingerprints[1])
		return TRUE
	if(isnull(gallery_fingerprints[2]))
		gallery_fingerprints[2] = gnoll_gallery_state()
	return saved_gnoll_gallery != gallery_fingerprints[2]

/**
 * Drops the fingerprints gallery_dirty() keeps. Whatever writes a form's gallery values must call this,
 * directly or through refresh_character_gallery(), or the window goes on showing a stale dirty state
 */
/datum/preferences/proc/gallery_changed()
	gallery_fingerprints = null

/// load_character() must call this on its first line, so it runs whichever return the load leaves by
/datum/preferences/proc/begin_gallery_load()
	reset_gallery_links()
	gallery_changed()
	// Deferred until the load returns, as the load is still writing the values the window shows
	if(character_gallery)
		addtimer(CALLBACK(src, PROC_REF(refresh_character_gallery)), 0, TIMER_UNIQUE)
	saved_character_gallery = null
	saved_gnoll_gallery = null
	if(istype(gnoll_prefs))
		gnoll_prefs.gallery_alternates = list()
		gnoll_prefs.card_backgrounds = list()
		gnoll_prefs.art_view_settings = list()
		gnoll_prefs.artwork_defaults = null
		gnoll_prefs.blocked_links = list()

/**
 * Moves the load generation on and clears what the character form keeps beside its links
 *
 * Clears the sources, card materials, view settings, artwork defaults and blocked links, and leaves the gnoll
 * form as it is. For whatever replaces the character's images. An open Character Gallery then refuses its
 * pending edits and drops its Undo points, which would otherwise write the old images onto the new ones
 */
/datum/preferences/proc/reset_gallery_links()
	character_gallery_generation++
	gallery_alternates = list()
	card_backgrounds = list()
	art_view_settings = list()
	artwork_defaults = null
	blocked_links = list()

/datum/preferences/proc/finish_gallery_load(gnoll_loaded)
	gallery_changed()
	saved_character_gallery = character_gallery_state()
	saved_gnoll_gallery = gnoll_loaded ? gnoll_gallery_state() : null

/datum/preferences/proc/log_headshot_framing(action)
	var/datum/gnoll_prefs/gnoll = gnoll_prefs
	var/character_framing = headshot_framing_text(headshot_link, headshot_framed, headshot_zoom, headshot_x, headshot_y)
	var/gnoll_framing = headshot_framing_text(gnoll?.headshot_link, gnoll?.headshot_framed, gnoll?.headshot_zoom, gnoll?.headshot_x, gnoll?.headshot_y)
	var/framing = "[character_framing], gnoll form [gnoll_framing]"
	if(framing == last_logged_framing)
		return
	var/first = isnull(last_logged_framing)
	last_logged_framing = framing
	if(first && !headshot_framed && !gnoll?.headshot_framed)
		return
	log_game("[key_name(parent)] [action] slot [default_slot] with headshot framing: [framing].")

/datum/preferences/proc/open_character_gallery(mob/user, form)
	if(!character_gallery)
		character_gallery = new(src)
	character_gallery.selected_form = form
	character_gallery.ui_interact(user)

/// Pass values_changed FALSE only when no gallery value was written, as it keeps the dirty fingerprints
/datum/preferences/proc/refresh_character_gallery(values_changed = TRUE)
	if(values_changed)
		gallery_changed()
	if(character_gallery)
		SStgui.update_uis(character_gallery)

/datum/preferences/vv_edit_var(var_name, var_value)
	. = ..()
	refresh_character_gallery()

/datum/preferences/proc/open_examine_preview(mob/user, form, datum/examine_panel/panel)
	if(!panel)
		panel = new(user)
		panel.pref = src
		panel.holder = user
		panel.viewing = user
		panel.previewing = form
	if(panel.previewing != form)
		panel.previewing = form
		panel.gallery_figures = panel.roll_gallery_figures()
	panel.ui_interact(user)
	return panel
