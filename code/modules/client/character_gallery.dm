/**
 * # Character gallery
 *
 * One window for every image a character slot holds, for the character and for its gnoll form: the
 * headshot and its framing, both OOC extra images and their sizes, and both art galleries. Only the
 * headshot opens a separate workspace. Each image can retain a main and an alternate URL.
 *
 * Forms are named "character" and "gnoll", the values the examine panel previews by.
 *
 * Every prompt and confirmation notes the loaded slot and load generation, giving up if Character
 * Setup loads a character while it is open.
 */
/datum/character_gallery
	/// The preferences whose images this window edits
	var/datum/preferences/prefs
	/// The form on show
	var/selected_form = "character"
	/// Last framing edit acknowledged for each form in this window
	var/list/framing_revisions = list("character" = 0, "gnoll" = 0)
	/// Invalidates edits opened before a form's image sources or art order changed
	var/list/source_revisions = list("character" = 0, "gnoll" = 0)
	/// Last completed image action for each form, including cancelled or rejected changes
	var/list/action_revisions = list("character" = 0, "gnoll" = 0)
	/// The URL dialog's source snapshot and any validation feedback
	var/list/url_editor
	var/url_editor_id = 0
	/// Last immediate debounced edit received from the window
	var/settled_revision = 0
	/// Last save result, tied to the character load that requested it
	var/list/save_feedback
	/// The examine panel that Preview opened, refreshed after every change
	var/datum/weakref/preview_ref
	/// Each save writes the whole savefile, so saves are spaced out
	COOLDOWN_DECLARE(save_cooldown)
	/// Running while a prompt or confirmation is open, so only one is. It lapses with the prompt's timeout, so it never sticks
	COOLDOWN_DECLARE(prompt_lock)

/datum/character_gallery/New(datum/preferences/prefs)
	src.prefs = prefs

/datum/character_gallery/Destroy(force)
	prefs = null
	return ..()

/datum/character_gallery/ui_state(mob/user)
	return GLOB.always_state

/datum/character_gallery/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CharacterGallery")
		ui.open()

/// Redraws the Character tab when the gallery closes, since its thumbnails do not redraw on their own
/datum/character_gallery/ui_close(mob/user)
	if(user?.client)
		INVOKE_ASYNC(prefs, TYPE_PROC_REF(/datum/preferences, ShowChoices), user)

/datum/character_gallery/ui_data(mob/user)
	var/datum/gnoll_prefs/gnoll = prefs.gnoll_prefs
	sync_gallery_alternates(prefs)
	sync_gallery_alternates(gnoll)
	if(url_editor && (url_editor["slot"] != prefs.default_slot || url_editor["generation"] != prefs.character_gallery_generation))
		url_editor = null
	var/list/editor_data = url_editor?.Copy()
	if(editor_data)
		editor_data -= list("sources", "slot", "generation", "revision", "adding")
	return list(
		"url_editor" = editor_data,
		"link_max_length" = IMAGE_LINK_MAX_LENGTH,
		"prompt_timeout" = CHARACTER_GALLERY_PROMPT_TIMEOUT * 100,
		"slot" = prefs.default_slot,
		"generation" = prefs.character_gallery_generation,
		"settled_revision" = settled_revision,
		"selected_form" = selected_form,
		"can_save" = !IsGuestKey(user.key),
		"gallery_dirty" = isnull(prefs.saved_gallery_state) || prefs.saved_gallery_state != prefs.gallery_state(),
		"save_feedback" = save_feedback?["slot"] == prefs.default_slot && save_feedback?["generation"] == prefs.character_gallery_generation ? save_feedback : null,
		"headshot_frame_chat" = prefs.headshot_frame_chat,
		"gallery_max" = IMAGE_GALLERY_MAX,
		"zoom_min" = HEADSHOT_ZOOM_MIN,
		"zoom_max" = HEADSHOT_ZOOM_MAX,
		"extra_size_min" = OOC_EXTRA_SIZE_MIN,
		"extra_size_max" = OOC_EXTRA_SIZE_MAX,
		"forms" = list(
			list(
				"id" = "character",
				"source_revision" = source_revisions["character"],
				"action_revision" = action_revisions["character"],
				"alternates" = prefs.gallery_alternates,
				"framing_revision" = framing_revisions["character"],
				"name" = prefs.real_name,
				"headshot" = prefs.headshot_link,
				"headshot_zoom" = prefs.headshot_zoom,
				"headshot_x" = prefs.headshot_x,
				"headshot_y" = prefs.headshot_y,
				"headshot_framed" = prefs.headshot_framed,
				"ooc_extra_img" = prefs.ooc_extra_img_link,
				"ooc_extra_img_size" = prefs.ooc_extra_img_size,
				"nsfw_ooc_extra_img" = prefs.nsfw_ooc_extra_img_link,
				"nsfw_ooc_extra_img_size" = prefs.nsfw_ooc_extra_img_size,
				"img_gallery" = prefs.img_gallery,
				"nsfw_img_gallery" = prefs.nsfw_img_gallery,
			),
			list(
				"id" = "gnoll",
				"source_revision" = source_revisions["gnoll"],
				"action_revision" = action_revisions["gnoll"],
				"alternates" = gnoll.gallery_alternates,
				"framing_revision" = framing_revisions["gnoll"],
				"name" = gnoll.gnoll_name,
				"headshot" = gnoll.headshot_link,
				"headshot_zoom" = gnoll.headshot_zoom,
				"headshot_x" = gnoll.headshot_x,
				"headshot_y" = gnoll.headshot_y,
				"headshot_framed" = gnoll.headshot_framed,
				"ooc_extra_img" = gnoll.ooc_extra_img_link,
				"ooc_extra_img_size" = gnoll.ooc_extra_img_size,
				"nsfw_ooc_extra_img" = gnoll.nsfw_ooc_extra_img_link,
				"nsfw_ooc_extra_img_size" = gnoll.nsfw_ooc_extra_img_size,
				"img_gallery" = gnoll.img_gallery,
				"nsfw_img_gallery" = gnoll.nsfw_img_gallery,
			),
		),
	)

/datum/character_gallery/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(params["slot"] != prefs.default_slot || params["generation"] != prefs.character_gallery_generation)
		return FALSE
	var/form = params["form"] == "gnoll" ? "gnoll" : "character"
	if(action == "save_urls" && url_editor)
		form = url_editor["form"]
	. = handle_action(action, params, ui.user)
	if(isnum(params["action_revision"]) && params["slot"] == prefs.default_slot && params["generation"] == prefs.character_gallery_generation)
		action_revisions[form] = max(action_revisions[form], params["action_revision"])
		return TRUE

/// Handles an action before ui_act acknowledges its completion, including prompts that may yield
/datum/character_gallery/proc/handle_action(action, list/params, mob/user)
	if((action == "set_framing" || action == "set_extra_size") && isnum(params["settled_revision"]))
		settled_revision = max(settled_revision, params["settled_revision"])
	var/form = params["form"] == "gnoll" ? "gnoll" : "character"
	var/nsfw = !!params["nsfw"]
	var/static/list/source_actions = list("set_headshot", "clear_headshot", "set_extra", "clear_extra", "add_art", "set_art", "remove_art", "move_art", "clear_all", "use_url", "swap_all_urls", "set_framing", "reset_framing", "set_extra_size")
	if((action in source_actions) && params["source_revision"] != source_revisions[form])
		return TRUE
	var/static/list/prompting_actions = list("set_headshot", "clear_headshot", "set_extra", "clear_extra", "add_art", "set_art", "remove_art", "clear_all")
	var/prompting = (action in prompting_actions)
	if(prompting)
		if(!COOLDOWN_FINISHED(src, prompt_lock))
			to_chat(user, span_warning("Finish the open prompt first."))
			return FALSE
		COOLDOWN_START(src, prompt_lock, CHARACTER_GALLERY_PROMPT_TIMEOUT)
	switch(action)
		if("select_form")
			selected_form = form
			return TRUE
		if("preview")
			open_preview(user, form)
			return FALSE
		if("save")
			if(IsGuestKey(user.key))
				return FALSE
			save_feedback = list("slot" = prefs.default_slot, "generation" = prefs.character_gallery_generation, "success" = FALSE)
			if(!COOLDOWN_FINISHED(src, save_cooldown))
				save_feedback["message"] = "Please wait a moment before saving again."
				to_chat(user, span_warning("Wait a moment before saving again."))
				return TRUE
			COOLDOWN_START(src, save_cooldown, 2 SECONDS)
			var/preferences_saved = prefs.save_preferences()
			var/character_saved = prefs.save_character()
			if(!preferences_saved || !character_saved)
				save_feedback["message"] = "Could not save all character data. Please try again."
				to_chat(user, span_warning("Could not save all character data."))
				return TRUE
			save_feedback["success"] = TRUE
			save_feedback["message"] = "Character saved."
			to_chat(user, span_notice("CHARACTER SAVED."))
			return TRUE
		if("set_framing")
			. = update_framing(form, params)
			if(isnum(params["revision"]))
				framing_revisions[form] = params["revision"]
		if("reset_framing")
			. = set_framing(form, HEADSHOT_ZOOM_MIN, HEADSHOT_POSITION_DEFAULT, HEADSHOT_POSITION_DEFAULT, FALSE)
		// Character only, since gnolls never show a chat headshot
		if("set_frame_chat")
			prefs.headshot_frame_chat = !!params["enabled"]
			return TRUE
		if("set_headshot")
			. = open_url_editor(form, "headshot", "Headshot")
		if("clear_headshot")
			. = clear_headshot(user, form)
		if("set_extra")
			. = open_url_editor(form, nsfw ? "nsfw_extra" : "extra", "[nsfw ? "NSFW " : ""]OOC Extra")
		if("set_extra_size")
			. = resize_extra(form, nsfw, params["size"])
		if("clear_extra")
			. = clear_extra(user, form, nsfw)
		if("add_art")
			var/list/gallery = get_gallery(form, nsfw)
			if(length(gallery) < IMAGE_GALLERY_MAX)
				. = open_url_editor(form, "[nsfw ? "nsfw_art" : "art"]_[length(gallery) + 1]", "[nsfw ? "NSFW" : "SFW"] Art [length(gallery) + 1]", TRUE)
		if("set_art")
			var/list/gallery = get_gallery(form, nsfw)
			if(is_gallery_index(gallery, params["index"]))
				. = open_url_editor(form, "[nsfw ? "nsfw_art" : "art"]_[params["index"]]", "[nsfw ? "NSFW" : "SFW"] Art [params["index"]]")
		if("save_urls")
			form = url_editor?["form"]
			if(!form)
				return FALSE
			. = save_urls(user, params)
			if(!.)
				return TRUE
		if("cancel_urls")
			if(url_editor?["id"] == params["editor_id"])
				url_editor = null
			return TRUE
		if("use_url")
			. = use_url(form, params["image"], !!params["alternate"])
		if("swap_all_urls")
			if(form != selected_form)
				return FALSE
			var/datum/owner = image_owner(form)
			sync_gallery_alternates(owner)
			var/list/alternates = owner.vars["gallery_alternates"]
			for(var/image in alternates.Copy())
				var/list/source = alternates[image]
				if(use_url(form, image, !source["active_alternate"]))
					. = TRUE
		if("remove_art")
			. = remove_art(user, form, nsfw, params["index"])
		if("move_art")
			. = move_art(form, nsfw, params["index"], params["direction"])
		if("clear_all")
			. = clear_all(user, form)
	if(prompting)
		COOLDOWN_RESET(src, prompt_lock)
	if(.)
		var/static/list/source_changes = list("save_urls", "use_url", "swap_all_urls", "clear_headshot", "clear_extra", "remove_art", "move_art", "clear_all")
		if(action in source_changes)
			source_revisions[form]++
		refresh_preview()

/// Names a field for chat and logs, such as "gnoll NSFW gallery"
/datum/character_gallery/proc/describe(form, nsfw, field_name)
	return "[form == "gnoll" ? "gnoll " : ""][nsfw ? "NSFW " : ""][field_name]"

/datum/character_gallery/proc/get_headshot(form)
	if(form == "gnoll")
		return prefs.gnoll_prefs.headshot_link
	return prefs.headshot_link

/// Sets a form's headshot, leaving the new picture unframed
/datum/character_gallery/proc/set_headshot(form, link)
	var/datum/owner = image_owner(form)
	var/list/alternates = owner.vars["gallery_alternates"]
	alternates -= "headshot"
	if(form == "gnoll")
		prefs.gnoll_prefs.headshot_link = link
	else
		prefs.headshot_link = link
	set_framing(form, HEADSHOT_ZOOM_MIN, HEADSHOT_POSITION_DEFAULT, HEADSHOT_POSITION_DEFAULT, FALSE)

/// Sets a form's headshot framing, where a value out of range falls back to its default. Returns TRUE
/datum/character_gallery/proc/set_framing(form, zoom, x, y, framed)
	zoom = sanitize_integer(zoom, HEADSHOT_ZOOM_MIN, HEADSHOT_ZOOM_MAX, HEADSHOT_ZOOM_MIN)
	x = sanitize_headshot_position(x)
	y = sanitize_headshot_position(y)
	framed = !!framed
	if(form == "gnoll")
		var/datum/gnoll_prefs/gnoll = prefs.gnoll_prefs
		gnoll.headshot_zoom = zoom
		gnoll.headshot_x = x
		gnoll.headshot_y = y
		gnoll.headshot_framed = framed
		return TRUE
	prefs.headshot_zoom = zoom
	prefs.headshot_x = x
	prefs.headshot_y = y
	prefs.headshot_framed = framed
	return TRUE

/// Applies the framing values the window sent and keeps the rest, marking the headshot framed. Returns TRUE
/datum/character_gallery/proc/update_framing(form, list/params)
	var/datum/gnoll_prefs/gnoll = prefs.gnoll_prefs
	var/is_gnoll = form == "gnoll"
	var/zoom = is_gnoll ? gnoll.headshot_zoom : prefs.headshot_zoom
	var/x = is_gnoll ? gnoll.headshot_x : prefs.headshot_x
	var/y = is_gnoll ? gnoll.headshot_y : prefs.headshot_y
	if(!isnull(params["zoom"]))
		zoom = params["zoom"]
	if(!isnull(params["x"]))
		x = params["x"]
	if(!isnull(params["y"]))
		y = params["y"]
	return set_framing(form, zoom, x, y, TRUE)

/datum/character_gallery/proc/get_extra(form, nsfw)
	if(form == "gnoll")
		var/datum/gnoll_prefs/gnoll = prefs.gnoll_prefs
		return nsfw ? gnoll.nsfw_ooc_extra_img_link : gnoll.ooc_extra_img_link
	return nsfw ? prefs.nsfw_ooc_extra_img_link : prefs.ooc_extra_img_link

/datum/character_gallery/proc/get_extra_size(form, nsfw)
	if(form == "gnoll")
		var/datum/gnoll_prefs/gnoll = prefs.gnoll_prefs
		return nsfw ? gnoll.nsfw_ooc_extra_img_size : gnoll.ooc_extra_img_size
	return nsfw ? prefs.nsfw_ooc_extra_img_size : prefs.ooc_extra_img_size

/// Sets one of a form's OOC extra images and its size, along with the flavour text markup that shows it
/datum/character_gallery/proc/set_extra(form, nsfw, link, size)
	if(!link)
		var/datum/owner = image_owner(form)
		var/list/alternates = owner.vars["gallery_alternates"]
		alternates -= nsfw ? "nsfw_extra" : "extra"
	var/markup = link ? ooc_extra_img_markup(link, size) : null
	if(form == "gnoll")
		var/datum/gnoll_prefs/gnoll = prefs.gnoll_prefs
		if(nsfw)
			gnoll.nsfw_ooc_extra_img_link = link
			gnoll.nsfw_ooc_extra_img_size = size
			gnoll.nsfw_ooc_extra_img = markup
			return
		gnoll.ooc_extra_img_link = link
		gnoll.ooc_extra_img_size = size
		gnoll.ooc_extra_img = markup
		return
	if(nsfw)
		prefs.nsfw_ooc_extra_img_link = link
		prefs.nsfw_ooc_extra_img_size = size
		prefs.nsfw_ooc_extra_img = markup
		return
	prefs.ooc_extra_img_link = link
	prefs.ooc_extra_img_size = size
	prefs.ooc_extra_img = markup

/// A copy of one of a form's art galleries, to change and hand back to set_gallery()
/datum/character_gallery/proc/get_gallery(form, nsfw)
	var/list/gallery
	if(form == "gnoll")
		gallery = nsfw ? prefs.gnoll_prefs.nsfw_img_gallery : prefs.gnoll_prefs.img_gallery
	else
		gallery = nsfw ? prefs.nsfw_img_gallery : prefs.img_gallery
	return islist(gallery) ? gallery.Copy() : list()

/datum/character_gallery/proc/set_gallery(form, nsfw, list/gallery)
	if(form == "gnoll")
		if(nsfw)
			prefs.gnoll_prefs.nsfw_img_gallery = gallery
		else
			prefs.gnoll_prefs.img_gallery = gallery
		return
	if(nsfw)
		prefs.nsfw_img_gallery = gallery
	else
		prefs.img_gallery = gallery

/datum/character_gallery/proc/clear_headshot(mob/user, form)
	if(!get_headshot(form))
		return FALSE
	var/slot = prefs.default_slot
	var/generation = prefs.character_gallery_generation
	var/source_revision = source_revisions[form]
	var/current = get_headshot(form)
	if(tgui_alert(user, "Do you really want to clear your [describe(form, FALSE, "headshot")]?", "Clear Headshot", list("Yae", "Nae"), timeout = CHARACTER_GALLERY_PROMPT_TIMEOUT) != "Yae" || (prefs.default_slot != slot || prefs.character_gallery_generation != generation))
		return FALSE
	if(source_revision != source_revisions[form] || current != get_headshot(form))
		return FALSE
	set_headshot(form, null)
	log_game("[user] has cleared their [describe(form, FALSE, "Headshot image")].")
	return TRUE

/// Sets how wide an OOC extra image shows, where a size out of range falls back to the largest. Returns TRUE when there is an image to size
/datum/character_gallery/proc/resize_extra(form, nsfw, size)
	var/link = get_extra(form, nsfw)
	if(!link)
		return FALSE
	set_extra(form, nsfw, link, sanitize_integer(size, OOC_EXTRA_SIZE_MIN, OOC_EXTRA_SIZE_MAX, OOC_EXTRA_SIZE_MAX))
	return TRUE

/datum/character_gallery/proc/clear_extra(mob/user, form, nsfw)
	if(!get_extra(form, nsfw))
		return FALSE
	var/slot = prefs.default_slot
	var/generation = prefs.character_gallery_generation
	var/source_revision = source_revisions[form]
	var/current = get_extra(form, nsfw)
	if(tgui_alert(user, "Do you really want to clear your [describe(form, nsfw, "OOC Extra Image/Video/Gif")]?", "Clear OOC Extra Image/Video/Gif", list("Yae", "Nae"), timeout = CHARACTER_GALLERY_PROMPT_TIMEOUT) != "Yae" || (prefs.default_slot != slot || prefs.character_gallery_generation != generation))
		return FALSE
	if(source_revision != source_revisions[form] || current != get_extra(form, nsfw))
		return FALSE
	set_extra(form, nsfw, null, OOC_EXTRA_SIZE_MAX)
	log_game("[user] has cleared their [describe(form, nsfw, "OOC Extra Image")].")
	return TRUE

/datum/character_gallery/proc/remove_art(mob/user, form, nsfw, index)
	var/list/gallery = get_gallery(form, nsfw)
	if(!is_gallery_index(gallery, index))
		return FALSE
	var/old_link = gallery[index]
	var/slot = prefs.default_slot
	var/generation = prefs.character_gallery_generation
	var/source_revision = source_revisions[form]
	if(tgui_alert(user, "Remove image [index] from your [describe(form, nsfw, "gallery")]?", "Remove Image", list("Yae", "Nae"), timeout = CHARACTER_GALLERY_PROMPT_TIMEOUT) != "Yae" || (prefs.default_slot != slot || prefs.character_gallery_generation != generation))
		return FALSE
	// Only if the slot still holds the image the prompt was opened on
	gallery = get_gallery(form, nsfw)
	if(source_revisions[form] != source_revision || !is_gallery_index(gallery, index) || gallery[index] != old_link)
		return FALSE
	var/datum/owner = image_owner(form)
	sync_gallery_alternates(owner)
	var/list/alternates = owner.vars["gallery_alternates"]
	var/prefix = nsfw ? "nsfw_art" : "art"
	for(var/position in index to length(gallery))
		alternates -= "[prefix]_[position]"
		var/list/next_source = alternates["[prefix]_[position + 1]"]
		if(next_source)
			alternates["[prefix]_[position]"] = next_source
	gallery.Cut(index, index + 1)
	set_gallery(form, nsfw, gallery)
	log_game("[user] has removed image [index] from their [describe(form, nsfw, "gallery")].")
	return TRUE

/// Swaps an art image with its neighbour, a direction of -1 moving it up and 1 down. Returns TRUE when it moved
/datum/character_gallery/proc/move_art(form, nsfw, index, direction)
	if(direction != -1 && direction != 1)
		return FALSE
	var/list/gallery = get_gallery(form, nsfw)
	if(!is_gallery_index(gallery, index) || !is_gallery_index(gallery, index + direction))
		return FALSE
	var/datum/owner = image_owner(form)
	sync_gallery_alternates(owner)
	var/list/alternates = owner.vars["gallery_alternates"]
	var/prefix = nsfw ? "nsfw_art" : "art"
	var/first = "[prefix]_[index]"
	var/second = "[prefix]_[index + direction]"
	var/list/first_source = alternates[first]
	var/list/second_source = alternates[second]
	alternates -= first
	alternates -= second
	if(first_source)
		alternates[second] = first_source
	if(second_source)
		alternates[first] = second_source
	gallery.Swap(index, index + direction)
	set_gallery(form, nsfw, gallery)
	return TRUE

/datum/character_gallery/proc/is_gallery_index(list/gallery, index)
	return isnum(index) && index == round(index) && index >= 1 && index <= length(gallery)

/datum/character_gallery/proc/image_owner(form)
	return form == "gnoll" ? prefs.gnoll_prefs : prefs

/// Opens a snapshot of one image's sources; applying it requires that the form has not changed
/datum/character_gallery/proc/open_url_editor(form, image, label, adding = FALSE)
	if(url_editor)
		return FALSE
	var/datum/owner = image_owner(form)
	sync_gallery_alternates(owner)
	var/list/links = gallery_image_links(owner)
	var/list/alternates = owner.vars["gallery_alternates"]
	var/list/source = alternates[image]
	var/current = links[image]
	url_editor = list(
		"id" = ++url_editor_id,
		"slot" = prefs.default_slot,
		"generation" = prefs.character_gallery_generation,
		"revision" = source_revisions[form],
		"sources" = json_encode(list(links, gallery_alternate_state(owner))),
		"form" = form,
		"image" = image,
		"label" = label,
		"adding" = adding,
		"main" = source?["active_alternate"] ? source["inactive_url"] : current,
		"alternate" = source?["active_alternate"] ? current : source?["inactive_url"],
		"active_alternate" = !!source?["active_alternate"],
		"error" = null,
	)
	return TRUE

/// Validates both URLs before changing either one, preserving each headshot source's own framing
/datum/character_gallery/proc/save_urls(mob/user, list/params)
	if(!url_editor || params["editor_id"] != url_editor["id"])
		return FALSE
	var/form = url_editor["form"]
	if(url_editor["slot"] != prefs.default_slot || url_editor["generation"] != prefs.character_gallery_generation || url_editor["revision"] != source_revisions[form])
		url_editor["error"] = "This image changed while its URLs were open. Cancel and reopen Replace to edit its current URLs."
		return FALSE
	if(!istext(params["main"]) || !istext(params["alternate"]))
		url_editor["error"] = "Enter a current image URL and an optional alternate image URL."
		return FALSE
	var/main = trim(params["main"])
	var/alternate = trim(params["alternate"])
	var/active_alternate = !!params["active_alternate"]
	if(!length(active_alternate ? alternate : main))
		url_editor["error"] = "Enter a current image URL."
		return FALSE
	// Keep the current source when its stored counterpart is removed
	var/promote_alternate = active_alternate && !length(main)
	if(promote_alternate)
		main = alternate
		alternate = ""
		active_alternate = FALSE
	var/image = url_editor["image"]
	var/list/extensions = gallery_image_extensions(image)
	if(!valid_headshot_link(user, main, TRUE, extensions))
		url_editor["error"] = "[active_alternate ? "Alternate" : "Current"] image URL is invalid. Use a direct HTTPS link from an allowed host, ending in [english_list(extensions)]."
		return FALSE
	if(length(alternate) && !valid_headshot_link(user, alternate, TRUE, extensions))
		url_editor["error"] = "[active_alternate ? "Current" : "Alternate"] image URL is invalid. Use a direct HTTPS link from an allowed host, ending in [english_list(extensions)]."
		return FALSE
	var/datum/owner = image_owner(form)
	sync_gallery_alternates(owner)
	var/list/links = gallery_image_links(owner)
	var/list/alternates = owner.vars["gallery_alternates"]
	if(url_editor["sources"] != json_encode(list(links, gallery_alternate_state(owner))))
		url_editor["error"] = "These images changed while the editor was open. Cancel and reopen it."
		return FALSE
	var/list/previous = alternates[image]
	var/old_main = previous?["active_alternate"] ? previous["inactive_url"] : links[image]
	var/old_alternate = previous?["active_alternate"] ? links[image] : previous?["inactive_url"]
	var/list/main_frame
	var/list/alternate_frame
	if(image == "headshot")
		var/list/current_frame = gallery_headshot_frame(owner)
		var/list/old_main_frame = previous?["active_alternate"] ? previous["framing"] : current_frame
		var/list/old_alternate_frame = previous?["active_alternate"] ? current_frame : previous?["framing"]
		main_frame = main == old_main ? old_main_frame : null
		if(promote_alternate)
			main_frame = main == old_alternate ? old_alternate_frame : null
		alternate_frame = alternate == old_alternate ? old_alternate_frame : null
		main_frame = sanitize_gallery_frame(main_frame)
		alternate_frame = sanitize_gallery_frame(alternate_frame)
	var/active = active_alternate ? alternate : main
	if(!write_image(form, image, active, url_editor["adding"]))
		url_editor["error"] = "This image slot is no longer available. Cancel and reopen the editor."
		return FALSE
	if(image == "headshot")
		var/list/frame = active_alternate ? alternate_frame : main_frame
		set_framing(form, frame[1], frame[2], frame[3], frame[4])
	alternates -= image
	if(length(alternate))
		alternates[image] = list("current_url" = active, "inactive_url" = active_alternate ? main : alternate, "active_alternate" = active_alternate)
		if(image == "headshot")
			var/list/source = alternates[image]
			source["framing"] = active_alternate ? main_frame : alternate_frame
	log_game("[user] has set [describe(form, FALSE, url_editor["label"])] URLs to main '[main]', alternate '[alternate]', using [active_alternate ? "alternate" : "main"].")
	url_editor = null
	return TRUE

/// Writes only known image slots; art additions must still be at the end of a nonfull gallery
/datum/character_gallery/proc/write_image(form, image, link, adding = FALSE)
	switch(image)
		if("headshot")
			set_headshot(form, link)
			return TRUE
		if("extra", "nsfw_extra")
			var/nsfw = image == "nsfw_extra"
			set_extra(form, nsfw, link, get_extra(form, nsfw) ? get_extra_size(form, nsfw) : OOC_EXTRA_SIZE_MAX)
			return TRUE
	for(var/nsfw in list(FALSE, TRUE))
		var/list/gallery = get_gallery(form, nsfw)
		var/prefix = nsfw ? "nsfw_art" : "art"
		for(var/index in 1 to IMAGE_GALLERY_MAX)
			if(image != "[prefix]_[index]")
				continue
			if(adding)
				if(index != length(gallery) + 1)
					return FALSE
				gallery += link
			else
				if(!is_gallery_index(gallery, index))
					return FALSE
				gallery[index] = link
			set_gallery(form, nsfw, gallery)
			return TRUE
	return FALSE

/// Swaps the active and inactive URLs and headshot frames without discarding either source
/datum/character_gallery/proc/use_url(form, image, alternate)
	if(!istext(image))
		return FALSE
	var/datum/owner = image_owner(form)
	sync_gallery_alternates(owner)
	var/list/alternates = owner.vars["gallery_alternates"]
	var/list/source = alternates[image]
	if(!source || !!source["active_alternate"] == alternate)
		return FALSE
	var/list/links = gallery_image_links(owner)
	var/current = links[image]
	var/list/current_frame
	if(image == "headshot")
		current_frame = gallery_headshot_frame(owner)
	if(!write_image(form, image, source["inactive_url"]))
		return FALSE
	source["current_url"] = source["inactive_url"]
	source["inactive_url"] = current
	source["active_alternate"] = alternate
	if(image == "headshot")
		var/list/frame = source["framing"]
		set_framing(form, frame[1], frame[2], frame[3], frame[4])
		source["framing"] = current_frame
	alternates[image] = source
	return TRUE

/// Clears every image of a form, behind a confirmation whose default button is no. Returns TRUE when cleared
/datum/character_gallery/proc/clear_all(mob/user, form)
	var/slot = prefs.default_slot
	var/generation = prefs.character_gallery_generation
	var/source_revision = source_revisions[form]
	var/sources = json_encode(gallery_image_links(image_owner(form)))
	if(tgui_alert(user, "Clear every image of your [describe(form, FALSE, "character")]? This removes the headshot, both OOC extras and both art galleries.", "Clear All", list("Nae", "Yae"), timeout = CHARACTER_GALLERY_PROMPT_TIMEOUT) != "Yae" || (prefs.default_slot != slot || prefs.character_gallery_generation != generation))
		return FALSE
	if(source_revision != source_revisions[form] || sources != json_encode(gallery_image_links(image_owner(form))))
		return FALSE
	set_headshot(form, null)
	set_extra(form, FALSE, null, OOC_EXTRA_SIZE_MAX)
	set_extra(form, TRUE, null, OOC_EXTRA_SIZE_MAX)
	set_gallery(form, FALSE, list())
	set_gallery(form, TRUE, list())
	var/datum/owner = image_owner(form)
	owner.vars["gallery_alternates"] = list()
	log_game("[user] has cleared every image of their [describe(form, FALSE, "character")].")
	return TRUE

/// Opens the examine panel's preview of a form, reusing the one already open
/datum/character_gallery/proc/open_preview(mob/user, form)
	var/datum/examine_panel/panel = preview_ref?.resolve()
	if(!panel)
		panel = new(user)
		panel.pref = prefs
		panel.holder = user
		panel.viewing = user
		preview_ref = WEAKREF(panel)
	panel.previewing = form
	panel.ui_interact(user)

/// Refreshes the open Preview once changes settle, so a burst of them rebuilds the panel once
/datum/character_gallery/proc/refresh_preview()
	addtimer(CALLBACK(src, PROC_REF(update_preview)), 0.5 SECONDS, TIMER_UNIQUE)

/datum/character_gallery/proc/update_preview()
	var/datum/examine_panel/panel = preview_ref?.resolve()
	if(panel)
		SStgui.update_uis(panel)

/datum/preferences
	/// Inactive image URLs, their active source names and inactive headshot framing, keyed by image slot
	var/list/gallery_alternates = list()
	/// Serialized gallery values last loaded or successfully saved, across both forms
	var/saved_gallery_state
	/// Changes on every character load, including reloading the current slot
	var/character_gallery_generation = 0
	/// The Character Gallery window, made the first time it opens
	var/datum/character_gallery/character_gallery
	/// The headshot framing last written to the logs, so a save or a spawn only logs a change
	var/last_logged_framing

/// Gallery values only, excluding names, other character settings and window state
/datum/preferences/proc/gallery_state()
	var/static/list/fields = list("headshot_link", "headshot_zoom", "headshot_x", "headshot_y", "headshot_framed", "ooc_extra_img_link", "ooc_extra_img_size", "nsfw_ooc_extra_img_link", "nsfw_ooc_extra_img_size", "img_gallery", "nsfw_img_gallery")
	var/list/character = list()
	var/list/gnoll = list()
	for(var/field in fields)
		character += list(vars[field])
		gnoll += list(gnoll_prefs ? gnoll_prefs.vars[field] : null)
	character += list(gallery_alternate_state(src))
	gnoll += list(gallery_alternate_state(gnoll_prefs))
	return json_encode(list(headshot_frame_chat, character, gnoll))

/**
 * Logs the headshot framing on a save or a spawn, when it differs from the last one logged.
 *
 * A spawn uses the preferences in memory, saved or not, so both are logged. Nothing is logged until
 * something has been framed, so players who never frame add no lines.
 */
/datum/preferences/proc/log_headshot_framing(action)
	var/datum/gnoll_prefs/gnoll = gnoll_prefs
	var/framing = "[headshot_framing_text(headshot_link, headshot_framed, headshot_zoom, headshot_x, headshot_y)], gnoll form [headshot_framing_text(gnoll?.headshot_link, gnoll?.headshot_framed, gnoll?.headshot_zoom, gnoll?.headshot_x, gnoll?.headshot_y)]"
	if(framing == last_logged_framing)
		return
	var/first = isnull(last_logged_framing)
	last_logged_framing = framing
	if(first && !headshot_framed && !gnoll?.headshot_framed)
		return
	log_game("[key_name(parent)] [action] slot [default_slot] with headshot framing: [framing].")

/// Opens the Character Gallery window on a form, "character" or "gnoll"
/datum/preferences/proc/open_character_gallery(mob/user, form)
	if(!character_gallery)
		character_gallery = new(src)
	character_gallery.selected_form = form
	character_gallery.ui_interact(user)

/// The chat examine headshot, shown as the examine panel's square when its owner turned that on
/mob/living/carbon/human/proc/chat_headshot_markup()
	if(!headshot_frame_chat)
		return chat_headshot(headshot_link)
	return "<div class='chat_headshot'><div class='chat_headshot_frame'><img src='[headshot_link]' style='[headshot_picture_style(headshot_framed, headshot_zoom, headshot_x, headshot_y)]'/></div></div>"

/**
 * The inline style that shows a headshot in a square box, matching HeadshotFrame in tgui.
 *
 * Unframed, the picture stretches over the square. Framed, it covers the square and zooms about the
 * point at X and Y percent.
 */
/proc/headshot_picture_style(framed, zoom, x, y)
	if(!framed)
		return "object-fit: fill;"
	var/position = "[x]% [y]%"
	return "object-fit: cover; object-position: [position]; transform: scale([zoom / 100]); transform-origin: [position];"

/// The Character tab's thumbnails of the headshot and both OOC extra images, the headshot as the examine panel shows it
/datum/preferences/proc/character_gallery_thumbnails()
	var/list/thumbnails = list()
	if(headshot_link)
		thumbnails += gallery_thumbnail("Headshot", "<img src='[headshot_link]' style='width: 100%; height: 100%; [headshot_picture_style(headshot_framed, headshot_zoom, headshot_x, headshot_y)]'>")
	if(ooc_extra_img_link)
		thumbnails += gallery_thumbnail("OOC Extra", extra_thumbnail_media(ooc_extra_img_link))
	if(nsfw_ooc_extra_img_link)
		thumbnails += gallery_thumbnail("NSFW OOC Extra", extra_thumbnail_media(nsfw_ooc_extra_img_link))
	if(!length(thumbnails))
		return ""
	return "<br>[thumbnails.Join()]"

/// One captioned 100 pixel square for the Character tab
/proc/gallery_thumbnail(caption, media)
	return "<div style='display: inline-block; vertical-align: top; text-align: center; margin: 4px 6px 0 0;'><div style='width: 100px; height: 100px; overflow: hidden; border: 1px solid #555;'>[media]</div><div style='font-size: 85%;'>[caption]</div></div>"

/// An OOC extra image or video stretched over its thumbnail square
/proc/extra_thumbnail_media(link)
	var/list/link_parts = splittext(link, ".")
	if(LOWER_TEXT(link_parts[length(link_parts)]) == "mp4")
		return "<video src='[link]' muted preload='metadata' style='width: 100%; height: 100%; object-fit: fill;'></video>"
	return "<img src='[link]' style='width: 100%; height: 100%; object-fit: fill;'>"

/// A headshot's framing for logs, such as "250% at 40, 10 on https://i.gyazo.com/...", or that there is none
/proc/headshot_framing_text(link, framed, zoom, x, y)
	if(!link)
		return "no headshot"
	if(!framed)
		return "unframed on [link]"
	return "[zoom]% at [x], [y] on [link]"

/// A headshot position from a save or the window, clamped into range and kept to a tenth of a percent, or the default when not a number
/proc/sanitize_headshot_position(value)
	if(!isnum(value))
		return HEADSHOT_POSITION_DEFAULT
	return clamp(round(value, 0.1), 0, HEADSHOT_POSITION_MAX)

/// The links of a loaded art gallery that pass valid_headshot_link(), at most [IMAGE_GALLERY_MAX] of them
/proc/valid_gallery_links(list/gallery)
	. = list()
	if(!islist(gallery))
		return
	for(var/link in gallery)
		if(length(.) >= IMAGE_GALLERY_MAX)
			return
		if(istext(link) && valid_headshot_link(null, link, TRUE))
			. += link

/// The flavour text markup that shows an OOC extra image or video link, at most size percent of the column wide
/proc/ooc_extra_img_markup(link, size = OOC_EXTRA_SIZE_MAX)
	var/list/link_parts = splittext(link, ".")
	if(LOWER_TEXT(link_parts[length(link_parts)]) == "mp4")
		return "<div align='center'><br><video style='max-width: [size]%;' controls controlslist='nodownload' preload='metadata'><source src='[link]' type='video/mp4'></video></div>"
	return "<div align='center'><br><img src='[link]' style='max-width: [size]%;'/></div>"

/// A form's active image URLs under stable slot names, with art slots following their row order
/proc/gallery_image_links(datum/owner)
	var/list/links = list("headshot" = owner.vars["headshot_link"], "extra" = owner.vars["ooc_extra_img_link"], "nsfw_extra" = owner.vars["nsfw_ooc_extra_img_link"])
	for(var/field in list("img_gallery", "nsfw_img_gallery"))
		var/list/gallery = owner.vars[field]
		var/prefix = field == "img_gallery" ? "art" : "nsfw_art"
		for(var/index in 1 to min(length(gallery), IMAGE_GALLERY_MAX))
			links["[prefix]_[index]"] = gallery[index]
	return links

/proc/gallery_image_extensions(image)
	var/static/list/pictures = list("jpg", "jpeg", "png")
	var/static/list/media = list("jpg", "jpeg", "png", "gif", "mp4")
	return image == "extra" || image == "nsfw_extra" ? media : pictures

/proc/gallery_headshot_frame(datum/owner)
	return list(owner.vars["headshot_zoom"], owner.vars["headshot_x"], owner.vars["headshot_y"], owner.vars["headshot_framed"])

/proc/sanitize_gallery_frame(list/frame)
	if(!islist(frame) || length(frame) != 4)
		return list(HEADSHOT_ZOOM_MIN, HEADSHOT_POSITION_DEFAULT, HEADSHOT_POSITION_DEFAULT, FALSE)
	return list(sanitize_integer(frame[1], HEADSHOT_ZOOM_MIN, HEADSHOT_ZOOM_MAX, HEADSHOT_ZOOM_MIN), sanitize_headshot_position(frame[2]), sanitize_headshot_position(frame[3]), !!frame[4])

/// Serializes sources in slot order, so switching back does not appear dirty just because keys moved
/proc/gallery_alternate_state(datum/owner)
	var/list/state = list()
	if(!owner)
		return state
	var/list/alternates = owner.vars["gallery_alternates"]
	if(!length(alternates))
		return state
	var/list/links = gallery_image_links(owner)
	for(var/image in links)
		var/list/source = alternates[image]
		if(source)
			state += list(list(image, source["current_url"], source["inactive_url"], source["active_alternate"], source["framing"]))
	return state

/// Loads only bounded, valid alternates bound to the active image saved in the same slot
/proc/valid_gallery_alternates(datum/owner, list/raw)
	var/list/result = list()
	if(!islist(raw))
		return result
	var/list/links = gallery_image_links(owner)
	for(var/image in links)
		var/list/source = raw[image]
		if(!islist(source) || !links[image] || source["current_url"] != links[image])
			continue
		var/inactive = source["inactive_url"]
		if(!istext(inactive) || !valid_headshot_link(null, inactive, TRUE, gallery_image_extensions(image)))
			continue
		var/list/clean = list("current_url" = links[image], "inactive_url" = inactive, "active_alternate" = !!source["active_alternate"])
		if(image == "headshot")
			clean["framing"] = sanitize_gallery_frame(source["framing"])
		result[image] = clean
	return result

/// Discards alternate state after another editor or a purge changes an active image directly
/proc/sync_gallery_alternates(datum/owner)
	if(!owner)
		return
	var/list/alternates = owner.vars["gallery_alternates"]
	if(!islist(alternates))
		owner.vars["gallery_alternates"] = list()
		return
	if(!length(alternates))
		return
	var/list/links = gallery_image_links(owner)
	for(var/image in alternates.Copy())
		var/list/source = alternates[image]
		if(!links[image] || !islist(source) || source["current_url"] != links[image])
			alternates -= image
