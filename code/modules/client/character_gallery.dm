/**
 * # Character gallery
 *
 * One window for every image of a character slot, for the character and its gnoll form.
 *
 * Prompts give up when the load generation moves while they are open. Only load_character() and the
 * load_preferences() before it change the slot, so the generation stands for the slot too, and a new
 * way to change slots must go through a load.
 *
 * ## Files
 *
 * This file holds the datum, its tgui procs, handle_action() and the procs its actions run.
 * character_gallery_undo.dm holds the Undo captures and restores, character_gallery_url_editor.dm the URL
 * editor from opening to Apply, and character_gallery_prefs.dm the [/datum/preferences] side. Procs that
 * take an owner rather than this datum live in character_gallery_images.dm.
 */
/datum/character_gallery
	var/datum/preferences/prefs
	var/selected_form = GALLERY_FORM_CHARACTER
	/// Moves on when an image action on the form finishes, refused or not, so the window refuses actions opened before it. Framing and size edits must not move it, or the window drops its newer drafts
	var/list/form_revisions = list(GALLERY_FORM_CHARACTER = 0, GALLERY_FORM_GNOLL = 0)
	var/static/list/image_actions = list("save_urls", "use_url", "swap_all_urls", "clear_headshot", "clear_extra", "remove_art", "move_art", "clear_all", "undo_image", "remove_blocked_link", "apply_artwork_settings", "set_artwork_defaults")
	/// The entries of image_actions that can open a confirm() prompt. After sending one of these the window keeps the
	/// form busy for CHARACTER_GALLERY_PROMPT_TIMEOUT longer than usual, so an image action that calls confirm() must be
	/// listed here too, or the window frees the form after 10 seconds while the prompt is still open
	var/static/list/confirm_actions = list("clear_headshot", "clear_extra", "remove_art", "clear_all", "remove_blocked_link")
	/**
	 * The open URL editor, null while none is open
	 *
	 * Holds "id", "form", "image", "label", the "main" and "alternate" links and "active_alternate" it opened with,
	 * "extensions" and "error". An art slot's editor also holds each source's opening "main_background",
	 * "alternate_background", "main_view_settings" and "alternate_view_settings".
	 *
	 * "generation" and "sources" stay server side, as ui_data() strips them. ui_data() closes the editor when a load
	 * moves the generation, and save_urls() refuses an Apply when "sources", the sources_snapshot() taken on opening,
	 * no longer matches the form
	 */
	var/list/url_editor
	var/url_editor_id = 0
	/// Last debounced framing or size edit received from the window, however it was answered
	var/edit_seq = 0
	var/list/save_feedback
	/// Each form's load generation when its last Artwork Settings Apply found nothing to change
	var/list/artwork_feedback = list()
	var/datum/weakref/preview_ref
	var/datum/artwork_editor_preview/artwork_preview
	/**
	 * Each form's Undo points by name, each a list of "scope", "before", "after" and "index"
	 *
	 * A row point is named for its image slot, which is also its scope. Its "before" is capture() of the slot and
	 * its "after" is the link the slot held after the change, null for a removal.
	 *
	 * A scope point is named apart from its scope, which undo_available() relies on: GALLERY_UNDO_CLEAR for "form",
	 * GALLERY_UNDO_ARTWORK_SETTINGS for artwork display changes and GALLERY_REMOVED_POINT() for "art", "nsfw_art" or "blocked".
	 * Its "before" is capture() of the scope and its "after" is json_encode() of the capture taken after the change.
	 * "index" is the removed position on a removed point and null on the other scope points
	 */
	var/list/undo_points = list(GALLERY_FORM_CHARACTER = list(), GALLERY_FORM_GNOLL = list())
	var/undo_generation
	/// Runs while a confirm() prompt is open, and prompt_open() refuses a second prompt or a URL editor until it ends.
	/// A cooldown of CHARACTER_GALLERY_PROMPT_TIMEOUT rather than a TRUE/FALSE flag, so the lock still lapses if
	/// confirm() runtimes before its COOLDOWN_RESET, where a flag would block every prompt and URL editor for good
	COOLDOWN_DECLARE(prompt_lock)
	/// Runs for CHARACTER_GALLERY_LOGGED_COOLDOWN once save_urls() saves, which refuses the next Apply until it ends. A failed Apply leaves it alone
	COOLDOWN_DECLARE(url_save_cooldown)
	/// Runs for CHARACTER_GALLERY_LOGGED_COOLDOWN once apply_artwork_settings() changes rows, which refuses the next Apply until it ends
	COOLDOWN_DECLARE(artwork_apply_cooldown)

/datum/character_gallery/New(datum/preferences/prefs)
	src.prefs = prefs

/datum/character_gallery/Destroy(force)
	close_artwork_preview()
	prefs = null
	return ..()

/datum/character_gallery/ui_state(mob/user)
	return GLOB.always_state

/datum/character_gallery/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/simple/gallery_card_materials))

/datum/character_gallery/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CharacterGallery")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/character_gallery/ui_close(mob/user)
	reset_undo()
	close_url_editor()
	artwork_feedback = list()
	prefs.gallery_changed()
	if(user?.client)
		INVOKE_ASYNC(prefs, TYPE_PROC_REF(/datum/preferences, refresh_gallery_preferences_menu), user)

/datum/character_gallery/ui_data(mob/user)
	var/datum/gnoll_prefs/gnoll = prefs.gnoll_prefs
	if(undo_generation != prefs.character_gallery_generation)
		undo_generation = prefs.character_gallery_generation
		reset_undo()
	if(url_editor && url_editor["generation"] != prefs.character_gallery_generation)
		close_url_editor()
	if(artwork_preview && prefs.gallery_artwork_preview_layout != "popup")
		close_artwork_preview()
	var/list/editor_data = url_editor?.Copy()
	if(editor_data)
		editor_data -= list("sources", "generation")
		editor_data["popup_open"] = !!artwork_preview
	var/list/feedback
	if(save_feedback?["generation"] == prefs.character_gallery_generation)
		feedback = list("message" = save_feedback["message"])
	// Before gallery_dirty(), since form_data() drops stale sources that change the fingerprint
	var/list/forms = list(
		form_data(GALLERY_FORM_CHARACTER, prefs.real_name),
		form_data(GALLERY_FORM_GNOLL, gnoll.gnoll_name),
	)
	return list(
		"url_editor" = editor_data,
		"artwork_preview_placement" = prefs.gallery_artwork_preview_layout,
		"generation" = prefs.character_gallery_generation,
		"edit_seq" = edit_seq,
		"selected_form" = selected_form,
		"can_save" = !IsGuestKey(user.key),
		"gallery_dirty" = prefs.gallery_dirty(),
		"save_feedback" = feedback,
		"headshot_frame_chat" = prefs.headshot_frame_chat,
		"forms" = forms,
	)

/datum/character_gallery/ui_static_data(mob/user)
	return list(
		"gallery" = gallery_viewer_settings(user.client?.prefs),
		"link_max_length" = IMAGE_LINK_MAX_LENGTH,
		// Deciseconds to the milliseconds tgui counts in
		"prompt_timeout" = CHARACTER_GALLERY_PROMPT_TIMEOUT * 100,
		"gallery_max" = IMAGE_GALLERY_MAX,
		"zoom_min" = HEADSHOT_ZOOM_MIN,
		"zoom_max" = HEADSHOT_ZOOM_MAX,
		"extra_size_min" = OOC_EXTRA_SIZE_MIN,
		"extra_size_max" = OOC_EXTRA_SIZE_MAX,
		"backdrop_options" = gallery_backdrop_options(),
		"card_background_options" = gallery_card_background_options(),
		"image_actions" = image_actions,
		"confirm_actions" = confirm_actions,
		"link_hosts" = IMAGE_LINK_HOSTS_TEXT,
	)

/datum/character_gallery/proc/form_data(form, name)
	var/datum/owner = image_owner(form)
	var/list/links
	if(length(owner.vars["gallery_alternates"]) || length(undo_points[form]))
		links = gallery_image_links(owner)
	if(sync_gallery_alternates(owner, links))
		prefs.gallery_changed()
	var/list/alternates = list()
	var/list/sources = get_alternates(form)
	for(var/image in sources)
		var/list/source = sources[image]
		alternates[image] = list("active_alternate" = source["active_alternate"])
	var/artwork_message
	if(artwork_feedback[form] == prefs.character_gallery_generation)
		artwork_message = "Every artwork already has these settings."
	var/list/art_links = gallery_art_links(owner)
	return list(
		"id" = form,
		"revision" = form_revisions[form],
		"alternates" = alternates,
		"undo" = undo_rows(form, links),
		"undo_removed" = undo_removed_rows(form, links),
		"undo_clear" = undo_available(form, GALLERY_UNDO_CLEAR, links),
		"undo_artwork_settings" = undo_available(form, GALLERY_UNDO_ARTWORK_SETTINGS, links),
		"artwork_feedback" = artwork_message,
		"artwork_defaults" = gallery_artwork_defaults(owner),
		"blocked_links" = owner.vars["blocked_links"],
		"name" = name,
		"headshot" = owner.vars["headshot_link"],
		"headshot_zoom" = owner.vars["headshot_zoom"],
		"headshot_x" = owner.vars["headshot_x"],
		"headshot_y" = owner.vars["headshot_y"],
		"ooc_extra_img" = owner.vars["ooc_extra_img_link"],
		"ooc_extra_img_size" = owner.vars["ooc_extra_img_size"],
		"nsfw_ooc_extra_img" = owner.vars["nsfw_ooc_extra_img_link"],
		"nsfw_ooc_extra_img_size" = owner.vars["nsfw_ooc_extra_img_size"],
		"img_gallery" = owner.vars["img_gallery"],
		"nsfw_img_gallery" = owner.vars["nsfw_img_gallery"],
		"image_backdrop" = owner.vars["image_backdrop"],
		"card_backgrounds" = gallery_card_backgrounds(owner, art_links),
		"art_view_settings" = gallery_art_view_settings(owner, art_links),
	)

/datum/character_gallery/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	// Every click answers with an update, since the window waits on one even for a refused action
	if(params["generation"] != prefs.character_gallery_generation)
		return TRUE
	if(action == "set_artwork_preview_placement" || action == "open_artwork_preview" || action == "update_artwork_preview" || action == "close_artwork_preview")
		return handle_artwork_preview(action, params, ui.user)
	if(action == "preview_scene")
		if(!url_editor || url_editor["id"] != params["editor_id"] || !is_gallery_art_slot(url_editor["image"]) || !prefs.gallery_backdrop || prefs.gallery_plain)
			return FALSE
		var/datum/asset/scenes = get_asset_datum(/datum/asset/simple/examine_gallery_scenes)
		if(!(scenes in ui.window.sent_assets) && ui.send_asset(scenes))
			ui.user.client?.browse_queue_flush()
		return TRUE
	var/form = params["form"] == GALLERY_FORM_GNOLL ? GALLERY_FORM_GNOLL : GALLERY_FORM_CHARACTER
	if(action == "save_urls" && url_editor)
		form = url_editor["form"]
	. = handle_action(action, params, ui.user, form)
	// After a load the window no longer waits on this action, and moving the revision would end a wait begun since
	if((action in image_actions) && params["generation"] == prefs.character_gallery_generation)
		form_revisions[form]++
	return TRUE

/**
 * Handles an action on a form before ui_act notes that it finished, including prompts that may yield
 *
 * A case that can change what the examine panel shows sets . and falls through to the Preview refresh
 * at the end, which also drops the dirty fingerprints. A case that cannot change it returns, which
 * skips both, so one that still writes a gallery value drops the fingerprints itself
 */
/datum/character_gallery/proc/handle_action(action, list/params, mob/user, form)
	var/sent_edit_seq = params["edit_seq"]
	if(isnum(sent_edit_seq) && !isnan(sent_edit_seq) && sent_edit_seq >= 0 && sent_edit_seq <= CHARACTER_GALLERY_EDIT_SEQ_MAX)
		edit_seq = max(edit_seq, sent_edit_seq)
	// The URL editor keeps its own snapshot, and a failed Apply moves the revision while the editor stays open
	var/static/list/any_revision_actions = list("select_form", "preview", "save", "set_frame_chat", "set_backdrop", "save_urls", "cancel_urls")
	if(!(action in any_revision_actions) && params["revision"] != form_revisions[form])
		return TRUE
	if(action == "set_artwork_defaults")
		return set_artwork_defaults(params["form"], params["changes"])
	if(action == "apply_artwork_settings")
		if(!(params["form"] in list(GALLERY_FORM_CHARACTER, GALLERY_FORM_GNOLL)) || !valid_artwork_changes(params["changes"]))
			return FALSE
	if(sync_gallery_alternates(image_owner(form)))
		prefs.gallery_changed()
	var/nsfw = !!params["nsfw"]
	switch(action)
		if("select_form")
			selected_form = form
			return TRUE
		if("preview")
			preview_ref = WEAKREF(prefs.open_examine_preview(user, form, preview_ref?.resolve()))
			return FALSE
		if("save")
			return save_slot(user, form)
		if("set_framing")
			. = update_framing(form, params)
		if("reset_framing")
			. = set_framing(form, null)
		// Always written to prefs whichever form is selected, as gnoll_prefs has no headshot_frame_chat var. Routing it
		// through image_owner(form) like the cases around it would runtime on the gnoll form
		if("set_frame_chat")
			prefs.headshot_frame_chat = !!params["enabled"]
			prefs.gallery_changed()
			return TRUE
		if("set_backdrop")
			. = set_backdrop(form, params["backdrop"])
		if("set_headshot")
			return open_url_editor(user, form, "headshot", "Headshot")
		if("clear_headshot")
			. = clear_headshot(user, form)
		if("set_extra")
			var/slot = GALLERY_EXTRA_SLOT(nsfw)
			return open_url_editor(user, form, slot, gallery_slot_label(slot))
		if("set_extra_size")
			. = resize_extra(form, nsfw, params["size"])
		if("clear_extra")
			. = clear_extra(user, form, nsfw)
		if("add_art")
			var/list/gallery = get_gallery(form, nsfw)
			var/index = length(gallery) + 1
			if(index <= IMAGE_GALLERY_MAX)
				return open_url_editor(user, form, gallery_art_slot(nsfw, index), gallery_art_label(nsfw, index))
		if("set_art")
			var/list/gallery = get_gallery(form, nsfw)
			var/index = params["index"]
			if(is_gallery_index(gallery, index))
				return open_url_editor(user, form, gallery_art_slot(nsfw, index), gallery_art_label(nsfw, index))
		if("save_urls")
			. = save_urls(user, params)
		if("cancel_urls")
			if(url_editor?["id"] == params["editor_id"])
				close_url_editor()
			return TRUE
		if("use_url")
			. = use_url(form, params["image"], !!params["alternate"])
		if("swap_all_urls")
			. = swap_all_urls(form)
		if("apply_artwork_settings")
			. = apply_artwork_settings(user, form, params["changes"], params["set_defaults"] == TRUE)
		if("remove_art")
			. = remove_art(user, form, nsfw, params["index"])
		if("move_art")
			. = move_art(form, nsfw, params["index"], params["direction"])
		if("clear_all")
			. = clear_all(user, form)
		if("undo_image")
			. = undo_image(user, form, params["image"])
		if("remove_blocked_link")
			. = remove_blocked_link(user, form, params["index"])
	if(.)
		artwork_feedback -= form
		prefs.gallery_changed()
		addtimer(CALLBACK(src, PROC_REF(update_preview)), 0.5 SECONDS, TIMER_UNIQUE)

/datum/character_gallery/proc/save_slot(mob/user, form)
	if(IsGuestKey(user.key))
		return FALSE
	// Returns before save_feedback is cleared below, so a click while savefile_cooldown runs keeps the last save's
	// message rather than showing a failure for a save that never ran
	if(!prefs.savefile_ready(user, "saving"))
		return TRUE
	// check_revision = FALSE, as this save writes the whole slot rather than one form's images. An image edit on the
	// form during the prompt must not refuse it, while a load during the prompt still does through character_gallery_generation
	if(prefs.slot_randomized)
		if(!confirm(user, form, "This character was randomized when it spawned. Saving now replaces your saved character and images with the random one. Save anyway?", "Save Randomized Character", list("Nae", "Yae"), check_revision = FALSE))
			return TRUE
		// A Character Setup save during the prompt starts the same cooldown
		if(!prefs.savefile_ready(user, "saving"))
			return TRUE
	var/generation = prefs.character_gallery_generation
	save_feedback = null
	COOLDOWN_START(prefs, savefile_cooldown, SAVEFILE_COOLDOWN_TIME)
	var/preferences_saved = prefs.save_preferences()
	var/character_saved = prefs.save_character()
	if(!preferences_saved || !character_saved)
		save_feedback = list("generation" = generation, "message" = "Couldn't save your character!")
		to_chat(user, span_warning("Couldn't save your character!"))
		return TRUE
	to_chat(user, span_notice("CHARACTER SAVED."))
	return TRUE

/datum/character_gallery/proc/swap_all_urls(form)
	if(form != selected_form)
		return FALSE
	var/list/alternates = get_alternates(form)
	for(var/image in alternates.Copy())
		var/list/source = alternates[image]
		if(use_url(form, image, !source["active_alternate"]))
			. = TRUE

/datum/character_gallery/proc/valid_artwork_changes(list/changes)
	if(!islist(changes))
		return FALSE
	for(var/field in changes)
		switch(field)
			if("opening_view")
				if(!is_art_opening_view(changes[field]))
					return FALSE
			if("lock")
				if(!is_art_view_lock(changes[field]))
					return FALSE
			if("card_background")
				if(!is_card_material(changes[field]))
					return FALSE
			else
				return FALSE
	return TRUE

/// Saves a settings patch for future artwork sources on this form
/datum/character_gallery/proc/set_artwork_defaults(form, list/changes)
	if(!(form in list(GALLERY_FORM_CHARACTER, GALLERY_FORM_GNOLL)) || !valid_artwork_changes(changes) || !length(changes))
		return FALSE
	var/datum/owner = image_owner(form)
	var/list/defaults = gallery_artwork_defaults(owner)
	var/changed = FALSE
	for(var/field in changes)
		if(defaults[field] != changes[field])
			defaults[field] = changes[field]
			changed = TRUE
	artwork_feedback -= form
	if(!changed)
		return FALSE
	owner.vars["artwork_defaults"] = defaults
	prefs.gallery_changed()
	return TRUE

/**
 * Applies one settings patch to both sources of occupied art rows, retaining one whole artwork Undo
 *
 * Accepts only a non-empty patch that passes valid_artwork_changes(), which handle_action() also checks
 * before it syncs the alternates
 */
/datum/character_gallery/proc/apply_artwork_settings(mob/user, form, list/changes, include_defaults)
	if(!COOLDOWN_FINISHED(src, artwork_apply_cooldown))
		return FALSE
	if(!valid_artwork_changes(changes) || !length(changes))
		return FALSE
	var/list/before = capture(form, "artwork")
	var/list/after = capture(form, "artwork")
	var/list/changed_rows = list()
	for(var/prefix in GALLERY_ART_PREFIXES)
		var/list/rows = after[prefix]
		var/list/previous_rows = before[prefix]
		for(var/index in 1 to length(rows))
			var/list/row = rows[index]
			row[GALLERY_ART_ROW_BACKGROUND] = patch_art_settings(row[GALLERY_ART_ROW_VIEW_SETTINGS], row[GALLERY_ART_ROW_BACKGROUND], changes)
			var/list/source = row[GALLERY_ART_ROW_SOURCE]
			if(source)
				source["card_background"] = patch_art_settings(source["view_settings"], source["card_background"], changes)
			if(json_encode(row) != json_encode(previous_rows[index]))
				changed_rows += "[prefix]_[index]"
	var/list/previous_defaults
	if(include_defaults)
		previous_defaults = gallery_artwork_defaults(image_owner(form))
		if(!set_artwork_defaults(form, changes))
			previous_defaults = null
	if(!length(changed_rows))
		if(previous_defaults)
			remember_scope(form, GALLERY_UNDO_ARTWORK_SETTINGS, "artwork_defaults", previous_defaults)
		else
			artwork_feedback[form] = prefs.character_gallery_generation
		return FALSE
	var/list/points = undo_points[form]
	for(var/image in changed_rows)
		points -= image
	restore_artwork_metadata(form, after)
	if(previous_defaults)
		remember_scope(form, GALLERY_UNDO_ARTWORK_SETTINGS, "artwork_and_defaults", list("artwork" = before, "artwork_defaults" = previous_defaults))
	else
		remember_scope(form, GALLERY_UNDO_ARTWORK_SETTINGS, "artwork", before)
	COOLDOWN_START(src, artwork_apply_cooldown, CHARACTER_GALLERY_LOGGED_COOLDOWN)
	log_game("[user] has changed artwork settings for [length(changed_rows)] rows of their [describe(form, FALSE, "character")]: [json_encode(changes)].")
	return TRUE

/**
 * Applies an Artwork Settings patch to one source of an art row, returning its card background
 *
 * Writes the patch's opening view and lock into view_settings in place. Returns the patch's card background
 * when it sets one, or else the background given. A row and its inactive source both go through here
 */
/datum/character_gallery/proc/patch_art_settings(list/view_settings, background, list/changes)
	if("opening_view" in changes)
		view_settings["opening_view"] = changes["opening_view"]
	if("lock" in changes)
		view_settings["lock"] = changes["lock"]
	if("card_background" in changes)
		return changes["card_background"]
	return background

/datum/character_gallery/proc/describe(form, nsfw, field_name)
	return "[form == GALLERY_FORM_GNOLL ? "gnoll " : ""][nsfw ? "NSFW " : ""][field_name]"

/datum/character_gallery/proc/confirm(mob/user, form, message, title, list/buttons = list("Yae", "Nae"), check_revision = TRUE)
	if(prompt_open(user))
		return FALSE
	COOLDOWN_START(src, prompt_lock, CHARACTER_GALLERY_PROMPT_TIMEOUT)
	var/generation = prefs.character_gallery_generation
	var/revision = form_revisions[form]
	var/answer = tgui_alert(user, message, title, buttons, timeout = CHARACTER_GALLERY_PROMPT_TIMEOUT)
	COOLDOWN_RESET(src, prompt_lock)
	if(answer != "Yae" || prefs.character_gallery_generation != generation)
		return FALSE
	if(check_revision && form_revisions[form] != revision)
		to_chat(user, span_warning("These images changed while the prompt was open, so nothing was changed."))
		return FALSE
	return TRUE

/datum/character_gallery/proc/prompt_open(mob/user)
	if(COOLDOWN_FINISHED(src, prompt_lock))
		return FALSE
	to_chat(user, span_warning("Finish the open prompt first."))
	return TRUE

/datum/character_gallery/proc/get_headshot(form)
	var/datum/owner = image_owner(form)
	return owner.vars["headshot_link"]

/datum/character_gallery/proc/set_headshot(form, link)
	var/datum/owner = image_owner(form)
	if(!link)
		var/list/alternates = get_alternates(form)
		alternates -= "headshot"
	owner.vars["headshot_link"] = link
	set_framing(form, null)

/datum/character_gallery/proc/set_framing(form, list/frame)
	set_gallery_frame(image_owner(form), sanitize_gallery_frame(frame))
	return TRUE

/datum/character_gallery/proc/update_framing(form, list/params)
	var/list/frame = gallery_headshot_frame(image_owner(form))
	if(!isnull(params["zoom"]))
		frame[GALLERY_FRAME_ZOOM] = params["zoom"]
	if(!isnull(params["x"]))
		frame[GALLERY_FRAME_X] = params["x"]
	if(!isnull(params["y"]))
		frame[GALLERY_FRAME_Y] = params["y"]
	frame[GALLERY_FRAME_FRAMED] = TRUE
	return set_framing(form, frame)

/datum/character_gallery/proc/set_backdrop(form, backdrop)
	var/datum/owner = image_owner(form)
	backdrop = sanitize_image_backdrop(backdrop)
	if(owner.vars["image_backdrop"] == backdrop)
		return FALSE
	owner.vars["image_backdrop"] = backdrop
	return TRUE

/datum/character_gallery/proc/get_extra(form, nsfw)
	var/datum/owner = image_owner(form)
	return owner.vars["[GALLERY_NSFW_PREFIX(nsfw)]ooc_extra_img_link"]

/datum/character_gallery/proc/get_extra_size(form, nsfw)
	var/datum/owner = image_owner(form)
	return owner.vars["[GALLERY_NSFW_PREFIX(nsfw)]ooc_extra_img_size"]

/datum/character_gallery/proc/set_extra(form, nsfw, link, size)
	if(!link)
		var/list/alternates = get_alternates(form)
		alternates -= GALLERY_EXTRA_SLOT(nsfw)
	set_gallery_extra(image_owner(form), nsfw, link, size)

/datum/character_gallery/proc/get_gallery(form, nsfw)
	var/datum/owner = image_owner(form)
	var/list/gallery = owner.vars["[GALLERY_NSFW_PREFIX(nsfw)]img_gallery"]
	return islist(gallery) ? gallery.Copy() : list()

/datum/character_gallery/proc/set_gallery(form, nsfw, list/gallery)
	var/datum/owner = image_owner(form)
	owner.vars["[GALLERY_NSFW_PREFIX(nsfw)]img_gallery"] = gallery

/// A form's alternates by slot name, the list itself rather than a copy, so changing it changes the form
/datum/character_gallery/proc/get_alternates(form)
	var/datum/owner = image_owner(form)
	return owner.vars["gallery_alternates"]

/datum/character_gallery/proc/clear_headshot(mob/user, form)
	if(!get_headshot(form))
		return FALSE
	if(!confirm(user, form, "Do you really want to remove your [describe(form, FALSE, "headshot")]?", "Remove Headshot"))
		return FALSE
	remember_image(form, "headshot", null)
	set_headshot(form, null)
	log_game("[user] has removed their [describe(form, FALSE, "Headshot image")].")
	return TRUE

/datum/character_gallery/proc/resize_extra(form, nsfw, size)
	var/link = get_extra(form, nsfw)
	if(!link)
		return FALSE
	set_extra(form, nsfw, link, sanitize_integer(size, OOC_EXTRA_SIZE_MIN, OOC_EXTRA_SIZE_MAX, OOC_EXTRA_SIZE_MAX))
	return TRUE

/datum/character_gallery/proc/clear_extra(mob/user, form, nsfw)
	if(!get_extra(form, nsfw))
		return FALSE
	if(!confirm(user, form, "Do you really want to remove your [describe(form, nsfw, "OOC Extra Image/Video/Gif")]?", "Remove OOC Extra Image/Video/Gif"))
		return FALSE
	remember_image(form, GALLERY_EXTRA_SLOT(nsfw), null)
	set_extra(form, nsfw, null, OOC_EXTRA_SIZE_MAX)
	log_game("[user] has removed their [describe(form, nsfw, "OOC Extra Image")].")
	return TRUE

/datum/character_gallery/proc/remove_art(mob/user, form, nsfw, index)
	if(!is_gallery_index(get_gallery(form, nsfw), index))
		return FALSE
	if(!confirm(user, form, "Remove image [index] from your [describe(form, nsfw, "gallery")]?", "Remove Image"))
		return FALSE
	// Checked again, as a purge can shorten the gallery during the prompt without moving the revision
	if(!is_gallery_index(get_gallery(form, nsfw), index))
		return FALSE
	cut_art(form, nsfw, index)
	log_game("[user] has removed image [index] from their [describe(form, nsfw, "gallery")].")
	return TRUE

/datum/character_gallery/proc/cut_art(form, nsfw, index)
	var/prefix = GALLERY_ART_PREFIX(nsfw)
	var/list/before = capture(form, prefix)
	var/list/rows = art_rows(form, prefix)
	rows.Cut(index, index + 1)
	set_art_rows(form, prefix, rows)
	remember_scope(form, GALLERY_REMOVED_POINT(prefix), prefix, before, index)

/datum/character_gallery/proc/remove_blocked_link(mob/user, form, index)
	var/datum/owner = image_owner(form)
	if(!is_gallery_index(owner.vars["blocked_links"], index))
		return FALSE
	if(!confirm(user, form, "Remove this hidden link from your [describe(form, FALSE, "character")]? Nobody else can see it.", "Remove Link"))
		return FALSE
	// Checked again, as a purge can shorten the list during the prompt without moving the revision
	if(!is_gallery_index(owner.vars["blocked_links"], index))
		return FALSE
	cut_blocked_link(form, index)
	log_game("[user] has removed a blocked link from their [describe(form, FALSE, "character")].")
	return TRUE

/datum/character_gallery/proc/cut_blocked_link(form, index)
	var/datum/owner = image_owner(form)
	var/list/before = capture(form, "blocked")
	var/list/blocked = before.Copy()
	blocked.Cut(index, index + 1)
	owner.vars["blocked_links"] = blocked
	remember_scope(form, GALLERY_REMOVED_POINT("blocked"), "blocked", before, index)

/datum/character_gallery/proc/move_art(form, nsfw, index, direction)
	if(direction != -1 && direction != 1)
		return FALSE
	var/prefix = GALLERY_ART_PREFIX(nsfw)
	var/list/rows = art_rows(form, prefix)
	if(!is_gallery_index(rows, index) || !is_gallery_index(rows, index + direction))
		return FALSE
	rows.Swap(index, index + direction)
	set_art_rows(form, prefix, rows)
	return TRUE

/datum/character_gallery/proc/is_gallery_index(list/gallery, index)
	return isnum(index) && ISINTEGER(index) && ISINRANGE(index, 1, length(gallery))

/**
 * The prefs holding a form's images
 *
 * [/datum/preferences] and [/datum/gnoll_prefs] share no parent declaring their image vars, so shared code
 * reads them by name through owner.vars. The compiler cannot check those names, so a new image var must
 * be declared on both types
 */
/datum/character_gallery/proc/image_owner(form)
	return form == GALLERY_FORM_GNOLL ? prefs.gnoll_prefs : prefs

/datum/character_gallery/proc/use_url(form, image, use_alternate)
	if(!istext(image))
		return FALSE
	var/datum/owner = image_owner(form)
	var/list/alternates = get_alternates(form)
	var/list/source = alternates[image]
	if(!source || !!source["active_alternate"] == use_alternate)
		return FALSE
	var/list/links = gallery_image_links(owner)
	var/current = links[image]
	var/list/backgrounds = gallery_card_backgrounds(owner)
	var/current_background = backgrounds[image]
	var/list/settings = gallery_art_view_settings(owner)
	var/list/current_settings = settings[image]
	var/list/current_frame
	if(image == "headshot")
		current_frame = gallery_headshot_frame(owner)
	if(!write_image(form, image, source["inactive_url"]))
		return FALSE
	source["current_url"] = source["inactive_url"]
	source["inactive_url"] = current
	source["active_alternate"] = use_alternate
	if(is_gallery_art_slot(image))
		set_gallery_card_background(owner, image, source["current_url"], source["card_background"])
		source["card_background"] = sanitize_card_background(current_background)
		set_gallery_art_view_settings(owner, image, source["current_url"], source["view_settings"])
		source["view_settings"] = sanitize_art_view_settings(current_settings)
	if(image == "headshot")
		set_framing(form, source["framing"])
		source["framing"] = current_frame
	return TRUE

/// Lists Nae first, as tgui_alert starts on its first button, so Enter answers no
/datum/character_gallery/proc/clear_all(mob/user, form)
	// Refuses an empty form here and not only in the window, as wipe_form() would still empty undo_points[form] and
	// leave a single Clear Undo that restores nothing in place of every row's Undo
	if(!form_has_images(form))
		return FALSE
	if(!confirm(user, form, "Clear every image of your [describe(form, FALSE, "character")]? This removes the headshot, both OOC extras, both art galleries and any hidden links.", "Clear All", list("Nae", "Yae")))
		return FALSE
	wipe_form(form)
	log_game("[user] has cleared every image of their [describe(form, FALSE, "character")].")
	return TRUE

/datum/character_gallery/proc/form_has_images(form)
	if(get_headshot(form) || get_extra(form, FALSE) || get_extra(form, TRUE))
		return TRUE
	if(length(get_gallery(form, FALSE)) || length(get_gallery(form, TRUE)))
		return TRUE
	var/datum/owner = image_owner(form)
	return length(owner.vars["blocked_links"]) > 0

/datum/character_gallery/proc/wipe_form(form)
	var/datum/owner = image_owner(form)
	var/list/before = capture(form, "form")
	set_headshot(form, null)
	set_extra(form, FALSE, null, OOC_EXTRA_SIZE_MAX)
	set_extra(form, TRUE, null, OOC_EXTRA_SIZE_MAX)
	set_art_rows(form, "art", list())
	set_art_rows(form, "nsfw_art", list())
	owner.vars["blocked_links"] = list()
	undo_points[form] = list()
	remember_scope(form, GALLERY_UNDO_CLEAR, "form", before)

/datum/character_gallery/proc/update_preview()
	var/datum/examine_panel/panel = preview_ref?.resolve()
	if(panel)
		SStgui.update_uis(panel)
