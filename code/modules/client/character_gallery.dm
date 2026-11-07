/**
 * # Character gallery
 *
 * One window for every image of a character slot, for the character and its gnoll form.
 *
 * Prompts give up when the load generation moves while they are open. Only load_character() and the
 * load_preferences() before it change the slot, so the generation stands for the slot too, and a new
 * way to change slots must go through a load.
 */
/datum/character_gallery
	var/datum/preferences/prefs
	var/selected_form = GALLERY_FORM_CHARACTER
	/// Moves on when an image action on the form finishes, refused or not, so the window refuses actions opened before it. Framing and size edits must not move it, or the window drops its newer drafts
	var/list/form_revisions = list(GALLERY_FORM_CHARACTER = 0, GALLERY_FORM_GNOLL = 0)
	var/static/list/image_actions = list("save_urls", "use_url", "swap_all_urls", "clear_headshot", "clear_extra", "remove_art", "move_art", "clear_all", "undo_image", "remove_blocked_link")
	/// The entries of image_actions that can open a confirm() prompt. After sending one of these the window keeps the
	/// form busy for CHARACTER_GALLERY_PROMPT_TIMEOUT longer than usual, so an image action that calls confirm() must be
	/// listed here too, or the window frees the form after 10 seconds while the prompt is still open
	var/static/list/confirm_actions = list("clear_headshot", "clear_extra", "remove_art", "clear_all", "remove_blocked_link")
	var/list/url_editor
	var/url_editor_id = 0
	/// Last debounced framing or size edit received from the window, however it was answered
	var/edit_seq = 0
	var/list/save_feedback
	var/datum/weakref/preview_ref
	/// Each form's Undo points by name, each a list of "scope", "before", "after" and "index"
	var/list/undo_points = list(GALLERY_FORM_CHARACTER = list(), GALLERY_FORM_GNOLL = list())
	var/undo_generation
	/// Runs while a confirm() prompt is open, and prompt_open() refuses a second prompt or a URL editor until it ends.
	/// A cooldown of CHARACTER_GALLERY_PROMPT_TIMEOUT rather than a TRUE/FALSE flag, so the lock still lapses if
	/// confirm() runtimes before its COOLDOWN_RESET, where a flag would block every prompt and URL editor for good
	COOLDOWN_DECLARE(prompt_lock)

/datum/character_gallery/New(datum/preferences/prefs)
	src.prefs = prefs

/datum/character_gallery/Destroy(force)
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
	url_editor = null
	prefs.gallery_changed()
	if(user?.client)
		INVOKE_ASYNC(prefs, TYPE_PROC_REF(/datum/preferences, ShowChoices), user, null, TRUE)

/datum/character_gallery/ui_data(mob/user)
	var/datum/gnoll_prefs/gnoll = prefs.gnoll_prefs
	if(undo_generation != prefs.character_gallery_generation)
		undo_generation = prefs.character_gallery_generation
		reset_undo()
	if(url_editor && url_editor["generation"] != prefs.character_gallery_generation)
		url_editor = null
	var/list/editor_data = url_editor?.Copy()
	if(editor_data)
		editor_data -= list("sources", "generation")
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
	return list(
		"id" = form,
		"revision" = form_revisions[form],
		"alternates" = alternates,
		"undo" = undo_rows(form, links),
		"undo_removed" = undo_removed_rows(form, links),
		"undo_clear" = undo_available(form, GALLERY_UNDO_CLEAR, links),
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
		"card_backgrounds" = gallery_card_backgrounds(owner),
	)

/datum/character_gallery/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	// Every click answers with an update, since the window waits on one even for a refused action
	if(params["generation"] != prefs.character_gallery_generation)
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
	if(isnum(params["edit_seq"]))
		edit_seq = max(edit_seq, params["edit_seq"])
	// The URL editor keeps its own snapshot, and a failed Apply moves the revision while the editor stays open
	var/static/list/any_revision_actions = list("select_form", "preview", "save", "set_frame_chat", "set_backdrop", "save_urls", "cancel_urls")
	if(!(action in any_revision_actions) && params["revision"] != form_revisions[form])
		return TRUE
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
				url_editor = null
			return TRUE
		if("use_url")
			. = use_url(form, params["image"], !!params["alternate"])
		if("swap_all_urls")
			. = swap_all_urls(form)
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
		frame[1] = params["zoom"]
	if(!isnull(params["x"]))
		frame[2] = params["x"]
	if(!isnull(params["y"]))
		frame[3] = params["y"]
	frame[4] = TRUE
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

/datum/character_gallery/proc/art_rows(form, prefix)
	. = list()
	var/list/backgrounds = gallery_card_backgrounds(image_owner(form))
	var/list/alternates = get_alternates(form)
	var/list/gallery = get_gallery(form, prefix == "nsfw_art")
	for(var/index in 1 to length(gallery))
		. += list(list(gallery[index], deepCopyList(alternates["[prefix]_[index]"]), backgrounds["[prefix]_[index]"]))

/// Replaces a gallery's rows. Drops the gallery's row Undos, which are held by position and could restore onto the wrong image
/datum/character_gallery/proc/set_art_rows(form, prefix, list/rows)
	var/datum/owner = image_owner(form)
	var/list/alternates = get_alternates(form)
	var/list/points = undo_points[form]
	for(var/position in 1 to IMAGE_GALLERY_MAX)
		var/slot = "[prefix]_[position]"
		alternates -= slot
		points -= slot
		set_gallery_card_background(owner, slot, null, GALLERY_CARD_DEFAULT)
	var/list/gallery = list()
	for(var/list/row as anything in rows)
		gallery += row[1]
		if(row[2])
			alternates["[prefix]_[length(gallery)]"] = row[2]
		set_gallery_card_background(owner, "[prefix]_[length(gallery)]", row[1], row[3])
	set_gallery(form, prefix == "nsfw_art", gallery)

/datum/character_gallery/proc/capture(form, scope, list/links)
	var/datum/owner = image_owner(form)
	switch(scope)
		if("form")
			. = list()
			for(var/part in list("headshot", "extra", "nsfw_extra", "art", "nsfw_art", "blocked"))
				.[part] = capture(form, part, links)
			return
		if("art", "nsfw_art")
			return art_rows(form, scope)
		if("blocked")
			// Shallow, as nothing edits an entry in place and deepCopyList would make list entries into associative keys
			var/list/blocked = owner.vars["blocked_links"]
			return blocked.Copy()
	var/list/alternates = get_alternates(form)
	links ||= gallery_image_links(owner)
	. = list("link" = links[scope], "source" = deepCopyList(alternates[scope]))
	if(is_gallery_art_slot(scope))
		var/list/backgrounds = gallery_card_backgrounds(owner)
		.["background"] = backgrounds[scope]
	if(scope == "headshot")
		.["frame"] = gallery_headshot_frame(owner)
	else if(scope == "extra" || scope == "nsfw_extra")
		.["size"] = get_extra_size(form, scope == "nsfw_extra")

/datum/character_gallery/proc/restore(form, scope, list/saved)
	var/datum/owner = image_owner(form)
	switch(scope)
		if("form")
			for(var/part in saved)
				restore(form, part, saved[part])
			return
		if("art", "nsfw_art")
			set_art_rows(form, scope, saved)
			return
		if("blocked")
			owner.vars["blocked_links"] = saved
			return
	write_image(form, scope, saved["link"])
	if(is_gallery_art_slot(scope))
		set_gallery_card_background(owner, scope, saved["link"], saved["background"])
	if(saved["frame"])
		set_framing(form, saved["frame"])
	if(saved["size"])
		set_extra(form, scope == "nsfw_extra", saved["link"], saved["size"])
	var/list/alternates = get_alternates(form)
	alternates -= scope
	if(saved["source"])
		alternates[scope] = saved["source"]

/datum/character_gallery/proc/reset_undo()
	undo_points = list(GALLERY_FORM_CHARACTER = list(), GALLERY_FORM_GNOLL = list())

/datum/character_gallery/proc/remember_image(form, image, after)
	var/list/points = undo_points[form]
	points -= image
	var/list/before = capture(form, image)
	if(before["link"])
		points[image] = list("scope" = image, "before" = before, "after" = after)

/datum/character_gallery/proc/remember_scope(form, point_name, scope, list/before, index)
	var/list/points = undo_points[form]
	points[point_name] = list("scope" = scope, "before" = before, "after" = json_encode(capture(form, scope)), "index" = index)

/datum/character_gallery/proc/undo_available(form, point_name, list/links)
	if(!istext(point_name))
		return FALSE
	var/list/points = undo_points[form]
	var/list/point = points[point_name]
	if(!point)
		return FALSE
	if(point["scope"] != point_name)
		return point["after"] == json_encode(capture(form, point["scope"], links))
	links ||= gallery_image_links(image_owner(form))
	return links[point_name] == point["after"]

/datum/character_gallery/proc/undo_rows(form, list/links)
	. = list()
	var/list/points = undo_points[form]
	for(var/image in points)
		var/list/point = points[image]
		if(point["scope"] == image && undo_available(form, image, links))
			. += image

/datum/character_gallery/proc/undo_removed_rows(form, list/links)
	. = list()
	var/list/points = undo_points[form]
	for(var/scope in list("art", "nsfw_art", "blocked"))
		var/point_name = GALLERY_REMOVED_POINT(scope)
		var/list/point = points[point_name]
		if(point && undo_available(form, point_name, links))
			.[scope] = point["index"]

/datum/character_gallery/proc/undo_image(mob/user, form, point_name)
	if(!undo_available(form, point_name))
		return FALSE
	var/list/points = undo_points[form]
	var/list/point = points[point_name]
	points -= point_name
	restore(form, point["scope"], point["before"])
	log_game("[user] has undone [describe(form, FALSE, point_name)].")
	return TRUE

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

/datum/character_gallery/proc/sources_snapshot(form)
	var/datum/owner = image_owner(form)
	return json_encode(list(gallery_image_links(owner), gallery_alternate_state(owner), gallery_card_backgrounds(owner)))

/datum/character_gallery/proc/open_url_editor(mob/user, form, image, label)
	if(url_editor)
		return FALSE
	if(prompt_open(user))
		return FALSE
	var/list/links = gallery_image_links(image_owner(form))
	var/list/alternates = get_alternates(form)
	var/list/source = alternates[image]
	var/current = links[image]
	url_editor = list(
		"id" = ++url_editor_id,
		"generation" = prefs.character_gallery_generation,
		"sources" = sources_snapshot(form),
		"form" = form,
		"image" = image,
		"label" = label,
		"main" = source?["active_alternate"] ? source["inactive_url"] : current,
		"alternate" = source?["active_alternate"] ? current : source?["inactive_url"],
		"active_alternate" = !!source?["active_alternate"],
		"extensions" = gallery_image_extensions(image),
		"error" = null,
	)
	if(is_gallery_art_slot(image))
		var/list/backgrounds = resolve_card_backgrounds(form, image, url_editor["main"], url_editor["alternate"], FALSE)
		url_editor["main_background"] = backgrounds[1]
		url_editor["alternate_background"] = backgrounds[2]
	return TRUE

/datum/character_gallery/proc/save_urls(mob/user, list/params)
	if(!url_editor || params["editor_id"] != url_editor["id"])
		return FALSE
	var/form = url_editor["form"]
	var/list/urls = validate_urls(user, params)
	if(!urls)
		return FALSE
	var/main = urls[1]
	var/alternate = urls[2]
	var/active_alternate = urls[3]
	var/promote_alternate = urls[4]
	var/image = url_editor["image"]
	if(url_editor["sources"] != sources_snapshot(form))
		url_editor["error"] = "These images changed while the editor was open. Cancel and reopen it."
		return FALSE
	var/list/backgrounds
	var/backgrounds_changed = FALSE
	if(is_gallery_art_slot(image))
		backgrounds = resolve_card_backgrounds(form, image, main, alternate, promote_alternate)
		var/main_draft = params[promote_alternate ? "alternate_background" : "main_background"]
		if(is_card_material(main_draft))
			backgrounds[1] = main_draft
		var/alternate_draft = params["alternate_background"]
		if(length(alternate) && is_card_material(alternate_draft))
			backgrounds[2] = alternate_draft
		backgrounds_changed = backgrounds[1] != url_editor["main_background"] || (length(alternate) && backgrounds[2] != url_editor["alternate_background"])
	// Closes the editor without writing when the links, the active source and the card materials all match url_editor,
	// or remember_image() below replaces this row's Undo with one that restores the same image. An Add opens with an
	// empty main, which a validated main never equals, so an Add always writes
	if(main == url_editor["main"] && alternate == (url_editor["alternate"] || "") && active_alternate == url_editor["active_alternate"] && !backgrounds_changed)
		url_editor = null
		return TRUE
	var/list/active_frame
	var/list/inactive_frame
	// Read before write_image() replaces the headshot and resets its framing
	if(image == "headshot")
		var/list/frames = resolve_headshot_frames(form, main, alternate, promote_alternate)
		active_frame = active_alternate ? frames[2] : frames[1]
		inactive_frame = active_alternate ? frames[1] : frames[2]
	var/active = active_alternate ? alternate : main
	var/inactive = active_alternate ? main : alternate
	remember_image(form, image, active)
	write_image(form, image, active)
	if(backgrounds)
		set_gallery_card_background(image_owner(form), image, active, backgrounds[active_alternate ? 2 : 1])
	if(active_frame)
		set_framing(form, active_frame)
	var/list/alternates = get_alternates(form)
	alternates -= image
	if(length(alternate))
		var/list/source = list("current_url" = active, "inactive_url" = inactive, "active_alternate" = active_alternate)
		if(inactive_frame)
			source["framing"] = inactive_frame
		if(backgrounds)
			source["card_background"] = backgrounds[active_alternate ? 1 : 2]
		alternates[image] = source
	var/materials = ""
	if(backgrounds)
		materials = length(alternate) ? ", card materials main '[backgrounds[1]]', alternate '[backgrounds[2]]'" : ", card material '[backgrounds[1]]'"
	log_game("[user] has set [describe(form, FALSE, url_editor["label"])] URLs to main '[main]', alternate '[alternate]', using [active_alternate ? "alternate" : "main"][materials].")
	url_editor = null
	return TRUE

/datum/character_gallery/proc/validate_urls(mob/user, list/params)
	if(!istext(params["main"]) || !istext(params["alternate"]))
		url_editor["error"] = "Enter a current image URL and an optional alternate image URL."
		return null
	var/main = trim(params["main"])
	var/alternate = trim(params["alternate"])
	var/active_alternate = !!params["active_alternate"]
	if(!length(active_alternate ? alternate : main))
		url_editor["error"] = "Enter a current image URL."
		return null
	var/promote_alternate = active_alternate && !length(main)
	if(promote_alternate)
		main = alternate
		alternate = ""
		active_alternate = FALSE
	var/main_name = active_alternate ? "Alternate" : "Current"
	var/alternate_name = active_alternate ? "Current" : "Alternate"
	var/error = new_url_error(main, main_name) || new_url_error(alternate, alternate_name)
	if(error)
		url_editor["error"] = error
		return null
	var/list/extensions = gallery_image_extensions(url_editor["image"])
	var/invalid_text = "image link is invalid. Make sure it's a direct https link from a valid host, ending in [english_list(extensions, and_text = " or ")]."
	if(!valid_headshot_link(user, main, TRUE, extensions))
		url_editor["error"] = "[main_name] [invalid_text]"
		return null
	if(length(alternate) && !valid_headshot_link(user, alternate, TRUE, extensions))
		url_editor["error"] = "[alternate_name] [invalid_text]"
		return null
	return list(main, alternate, active_alternate, promote_alternate)

/// A link the editor opened with passes, since older saved links may break these rules and still load
/datum/character_gallery/proc/new_url_error(link, name)
	if(link == url_editor["main"] || link == url_editor["alternate"])
		return null
	if(length(link) > IMAGE_LINK_MAX_LENGTH)
		return "[name] image URL must be [IMAGE_LINK_MAX_LENGTH] characters or fewer."
	var/static/regex/whitespace = regex(@"\s")
	if(findtext(link, whitespace))
		return "[name] image URL can't contain spaces or line breaks."
	return null

/**
 * A per source value for an image's new main and alternate URLs, unsanitized, each the value its field
 * held while that field keeps its URL, or null when the field's URL changed
 *
 * Fields are matched to themselves only, so a URL moved from one field to the other gets null. The one
 * exception is a lone alternate promoted to the main, which keeps the alternate's value while its URL stays
 *
 * Arguments:
 * * current_value - the value of the source on show
 * * value_key - where the image's stored source keeps its own value
 * * promote_alternate - a lone alternate became the main, so the main takes the alternate's value
 */
/datum/character_gallery/proc/resolve_source_values(form, image, current_value, value_key, main, alternate, promote_alternate)
	var/list/links = gallery_image_links(image_owner(form))
	var/list/alternates = get_alternates(form)
	var/list/previous = alternates[image]
	var/current = links[image]
	var/old_main = current
	var/old_main_value = current_value
	var/old_alternate = previous?["inactive_url"]
	var/old_alternate_value = previous?[value_key]
	if(previous?["active_alternate"])
		old_main = previous["inactive_url"]
		old_main_value = previous[value_key]
		old_alternate = current
		old_alternate_value = current_value
	var/main_value = main == old_main ? old_main_value : null
	if(promote_alternate)
		main_value = main == old_alternate ? old_alternate_value : null
	var/alternate_value = alternate == old_alternate ? old_alternate_value : null
	return list(main_value, alternate_value)

/datum/character_gallery/proc/resolve_headshot_frames(form, main, alternate, promote_alternate)
	var/list/frames = resolve_source_values(form, "headshot", gallery_headshot_frame(image_owner(form)), "framing", main, alternate, promote_alternate)
	return list(sanitize_gallery_frame(frames[1]), sanitize_gallery_frame(frames[2]))

/datum/character_gallery/proc/resolve_card_backgrounds(form, image, main, alternate, promote_alternate)
	var/list/backgrounds = gallery_card_backgrounds(image_owner(form))
	var/list/kept = resolve_source_values(form, image, backgrounds[image], "card_background", main, alternate, promote_alternate)
	return list(sanitize_card_background(kept[1]), sanitize_card_background(kept[2]))

/datum/character_gallery/proc/write_image(form, image, link)
	switch(image)
		if("headshot")
			set_headshot(form, link)
			return TRUE
		if("extra", "nsfw_extra")
			var/nsfw = image == "nsfw_extra"
			set_extra(form, nsfw, link, get_extra(form, nsfw) ? get_extra_size(form, nsfw) : OOC_EXTRA_SIZE_MAX)
			return TRUE
	var/nsfw = findtext(image, "nsfw_art_") == 1
	var/prefix = GALLERY_ART_PREFIX(nsfw)
	var/index = text2num(copytext(image, length(prefix) + 2))
	// text2num() ignores whatever trails a number, so only an exact slot name comes back unchanged
	if(image != "[prefix]_[index]" || index > IMAGE_GALLERY_MAX)
		return FALSE
	var/list/gallery = get_gallery(form, nsfw)
	if(index == length(gallery) + 1)
		gallery += link
	else if(is_gallery_index(gallery, index))
		gallery[index] = link
	else
		return FALSE
	set_gallery(form, nsfw, gallery)
	set_gallery_card_background(image_owner(form), image, null, GALLERY_CARD_DEFAULT)
	return TRUE

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

/datum/preferences
	/// Fingerprint of the character form's gallery values when last loaded or successfully saved, null when unknown
	var/saved_character_gallery
	var/saved_gnoll_gallery
	var/list/gallery_fingerprints
	var/character_gallery_generation = 0
	var/datum/character_gallery/character_gallery
	var/last_logged_framing
	var/queued_save_timer

/datum/preferences/proc/character_gallery_thumbnails()
	var/list/thumbnails = list()
	if(headshot_link)
		thumbnails += gallery_thumbnail("Headshot", "<img src='[headshot_link]' style='width: 100%; height: 100%; [headshot_picture_style(headshot_zoom, headshot_x, headshot_y)]'>")
	if(ooc_extra_img_link)
		thumbnails += gallery_thumbnail("OOC Extra", extra_thumbnail_media(ooc_extra_img_link))
	if(nsfw_ooc_extra_img_link)
		thumbnails += gallery_thumbnail("NSFW OOC Extra", extra_thumbnail_media(nsfw_ooc_extra_img_link))
	if(!length(thumbnails))
		return ""
	return "<br>[thumbnails.Join()]"

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

/datum/preferences/proc/save_gallery_toggles(savefile/S)
	WRITE_FILE(S["gallery_plain"], gallery_plain)
	WRITE_FILE(S["gallery_backdrop"], gallery_backdrop)
	WRITE_FILE(S["gallery_card_deal"], gallery_card_deal)
	WRITE_FILE(S["gallery_image_sounds"], gallery_image_sounds)
	WRITE_FILE(S["gallery_image_tilt"], gallery_image_tilt)
	WRITE_FILE(S["gallery_candle_flicker"], gallery_candle_flicker)
	WRITE_FILE(S["gallery_easter_eggs"], gallery_easter_eggs)

/// Saves the preferences 2 seconds after the first of a burst of calls, so a run of gallery toggle clicks writes the
/// savefile once. Never starts savefile_cooldown, or each toggle click would make Save and Undo in Character Setup wait
/datum/preferences/proc/queue_save_preferences()
	queued_save_timer = addtimer(CALLBACK(src, PROC_REF(save_preferences)), 2 SECONDS, TIMER_UNIQUE|TIMER_STOPPABLE)

/datum/preferences/proc/flush_queued_save()
	var/pending = deltimer(queued_save_timer)
	queued_save_timer = null
	if(pending)
		save_preferences()

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
	character_gallery_generation++
	gallery_changed()
	// Deferred until the load returns, as the load is still writing the values the window shows
	if(character_gallery)
		addtimer(CALLBACK(src, PROC_REF(refresh_character_gallery)), 0, TIMER_UNIQUE)
	saved_character_gallery = null
	saved_gnoll_gallery = null
	gallery_alternates = list()
	card_backgrounds = list()
	blocked_links = list()
	if(istype(gnoll_prefs))
		gnoll_prefs.gallery_alternates = list()
		gnoll_prefs.card_backgrounds = list()
		gnoll_prefs.blocked_links = list()

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

/mob/living/carbon/human/proc/chat_headshot_markup()
	if(!headshot_frame_chat)
		return chat_headshot(headshot_link)
	return "<div class='chat_headshot'><div class='chat_headshot_frame'><img src='[headshot_link]' style='[headshot_picture_style(headshot_zoom, headshot_x, headshot_y)]'/></div></div>"
