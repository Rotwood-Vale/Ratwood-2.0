/datum/character_gallery/proc/sources_snapshot(form)
	var/datum/owner = image_owner(form)
	return json_encode(list(gallery_image_links(owner), gallery_alternate_state(owner), gallery_card_backgrounds(owner), gallery_art_view_settings(owner)))

/datum/character_gallery/proc/close_url_editor()
	url_editor = null
	close_artwork_preview()

/datum/character_gallery/proc/close_artwork_preview()
	var/datum/artwork_editor_preview/preview = artwork_preview
	if(!preview)
		return
	artwork_preview = null
	preview.gallery_ref = null
	SStgui.close_uis(preview)
	qdel(preview)

/datum/character_gallery/proc/handle_artwork_preview(action, list/params, mob/user)
	if(!prefs || user.client?.prefs != prefs)
		return FALSE
	if(!url_editor || url_editor["generation"] != prefs.character_gallery_generation || params["editor_id"] != url_editor["id"] || !is_gallery_art_slot(url_editor["image"]))
		return FALSE
	if(action == "set_artwork_preview_placement")
		if(!prefs.change_gallery_artwork_preview_layout(params["value"]))
			return FALSE
		SStgui.update_uis(user.client?.toggles_menu)
		return TRUE
	if(prefs.gallery_artwork_preview_layout != "popup")
		return FALSE
	switch(action)
		if("close_artwork_preview")
			close_artwork_preview()
			return TRUE
		if("update_artwork_preview")
			if(!artwork_preview)
				return FALSE
	var/url = params["url"]
	if(!isnull(url) && (!istext(url) || !artwork_preview_link_allowed(user, url)))
		return FALSE
	if(action == "open_artwork_preview" && !url)
		return FALSE
	if(!is_art_view_settings(params["view"]) || !is_card_material(params["background"]))
		return FALSE

	var/form = url_editor["form"]
	var/nsfw = findtext(url_editor["image"], "nsfw_art_") == 1
	var/datum/owner = image_owner(form)
	var/list/category = owner.vars["[GALLERY_NSFW_PREFIX(nsfw)]img_gallery"]
	var/is_new_artwork = !url_editor["main"]
	var/datum/tgui/gallery_ui = SStgui.get_open_ui(user, src)
	var/list/draft = list(
		"url" = url,
		"view" = sanitize_art_view_settings(params["view"]),
		"background" = params["background"],
		"alternate" = params["alternate"] == TRUE,
		"nsfw" = nsfw,
		"backdrop" = sanitize_image_backdrop(owner.vars["image_backdrop"]),
		"has_thumbnails" = length(category) + is_new_artwork > 1,
		"image" = url_editor["image"],
		"images" = category?.Copy(),
		"art_view_settings" = gallery_art_view_settings(owner),
		"card_backgrounds" = gallery_card_backgrounds(owner),
		"gallery_window" = gallery_ui?.window?.id,
	)
	if(artwork_preview)
		artwork_preview.draft = draft
		var/datum/tgui/open_ui = SStgui.get_open_ui(user, artwork_preview)
		// Queue the draft even if the popup has yet to answer its initial ping
		if(open_ui && !open_ui.closing)
			open_ui.window.send_message("update", open_ui.get_payload(with_data = TRUE))
		return FALSE
	var/datum/artwork_editor_preview/preview = new
	preview.gallery_ref = WEAKREF(src)
	preview.draft = draft
	var/datum/tgui/ui = new(user, preview, "ArtworkEditorPreview")
	ui.window_key = "ArtworkEditorPreview"
	ui.set_autoupdate(FALSE)
	if(!ui.open())
		qdel(ui)
		qdel(preview)
		return FALSE
	artwork_preview = preview
	return TRUE

/// Gives opening links the same legacy allowance as the inline preview.
/datum/character_gallery/proc/artwork_preview_link_allowed(mob/user, url)
	if(url == url_editor["main"] || url == url_editor["alternate"])
		return TRUE
	if(new_url_error(url, "Artwork") || findtext(url, ascii2text(92)))
		return FALSE
	var/static/regex/direct_host = regex(@"^https://(i\.gyazo\.com|[a-z0-9]\.l3n\.co|images2\.imgbox\.com|thumbs2\.imgbox\.com|files\.catbox\.moe|i\.ibb\.co|file\.garden)/")
	return findtext(url, direct_host) && valid_headshot_link(user, url, TRUE, url_editor["extensions"])

/datum/artwork_editor_preview
	var/datum/weakref/gallery_ref
	var/list/draft

/datum/artwork_editor_preview/ui_state(mob/user)
	return GLOB.always_state

/datum/artwork_editor_preview/ui_data(mob/user)
	return draft

/datum/artwork_editor_preview/ui_static_data(mob/user)
	return list("gallery" = gallery_viewer_settings(user.client?.prefs))

/datum/artwork_editor_preview/ui_assets(mob/user)
	. = list(get_asset_datum(/datum/asset/simple/gallery_card_materials))
	var/datum/preferences/prefs = user.client?.prefs
	if(prefs?.gallery_backdrop && !prefs.gallery_plain && draft["backdrop"] == GALLERY_BACKDROP_TAVERN)
		. += get_asset_datum(/datum/asset/simple/examine_gallery_scenes)

/datum/artwork_editor_preview/ui_close(mob/user)
	var/datum/character_gallery/gallery = gallery_ref?.resolve()
	if(gallery?.artwork_preview == src)
		gallery.artwork_preview = null
		SStgui.update_uis(gallery)
		qdel(src)

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
		var/list/defaults = gallery_artwork_defaults(image_owner(form))
		var/list/backgrounds = resolve_card_backgrounds(form, image, url_editor["main"], url_editor["alternate"], FALSE)
		var/list/settings = resolve_art_view_settings(form, image, url_editor["main"], url_editor["alternate"], FALSE)
		var/has_main = length(url_editor["main"])
		var/has_alternate = length(url_editor["alternate"])
		url_editor["main_background"] = has_main ? backgrounds[1] : defaults["card_background"]
		url_editor["alternate_background"] = has_alternate ? backgrounds[2] : defaults["card_background"]
		url_editor["main_view_settings"] = has_main ? settings[1] : sanitize_art_view_settings(defaults)
		url_editor["alternate_view_settings"] = has_alternate ? settings[2] : sanitize_art_view_settings(defaults)
	return TRUE


/datum/character_gallery/proc/save_urls(mob/user, list/params)
	if(!url_editor || params["editor_id"] != url_editor["id"])
		return FALSE
	if(!COOLDOWN_FINISHED(src, url_save_cooldown))
		url_editor["error"] = "Wait a moment before applying again."
		return FALSE
	var/form = url_editor["form"]
	var/list/urls = validate_urls(user, params)
	if(!urls)
		return FALSE
	var/main = urls["main"]
	var/alternate = urls["alternate"]
	var/active_alternate = urls["active_alternate"]
	var/promote_alternate = urls["promote_alternate"]
	var/image = url_editor["image"]
	for(var/field in list("main_view_settings", "alternate_view_settings"))
		if((field in params) && (!is_gallery_art_slot(image) || !is_art_view_settings(params[field])))
			url_editor["error"] = "Choose a valid opening view, lock and framing for each artwork source."
			return FALSE
	if(url_editor["sources"] != sources_snapshot(form))
		url_editor["error"] = "These images changed while the editor was open. Cancel and reopen it."
		return FALSE
	var/list/backgrounds
	var/backgrounds_changed = FALSE
	var/list/settings
	var/settings_changed = FALSE
	if(is_gallery_art_slot(image))
		backgrounds = resolve_card_backgrounds(form, image, main, alternate, promote_alternate)
		settings = resolve_art_view_settings(form, image, main, alternate, promote_alternate)
		var/main_source = promote_alternate ? "alternate" : "main"
		var/main_background_field = "[main_source]_background"
		var/main_view_field = "[main_source]_view_settings"
		// A new source keeps its opening defaults when the draft does not send its own settings
		if(!length(url_editor[main_source]))
			backgrounds[1] = url_editor[main_background_field]
			settings[1] = url_editor[main_view_field]
		if(length(alternate) && !length(url_editor["alternate"]))
			backgrounds[2] = url_editor["alternate_background"]
			settings[2] = url_editor["alternate_view_settings"]
		var/main_draft = params[main_background_field]
		if(is_card_material(main_draft))
			backgrounds[1] = main_draft
		var/alternate_draft = params["alternate_background"]
		if(length(alternate) && is_card_material(alternate_draft))
			backgrounds[2] = alternate_draft
		backgrounds_changed = backgrounds[1] != url_editor["main_background"] || (length(alternate) && backgrounds[2] != url_editor["alternate_background"])
		if(main_view_field in params)
			settings[1] = sanitize_art_view_settings(params[main_view_field])
		if(length(alternate) && ("alternate_view_settings" in params))
			settings[2] = sanitize_art_view_settings(params["alternate_view_settings"])
		settings_changed = json_encode(settings[1]) != json_encode(url_editor["main_view_settings"]) || (length(alternate) && json_encode(settings[2]) != json_encode(url_editor["alternate_view_settings"]))
	// A no-op must keep the previous row Undo. An Add has an empty main, which a validated main never equals
	if(main == url_editor["main"] && alternate == (url_editor["alternate"] || "") && active_alternate == url_editor["active_alternate"] && !backgrounds_changed && !settings_changed)
		close_url_editor()
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
	if(settings)
		set_gallery_art_view_settings(image_owner(form), image, active, settings[active_alternate ? 2 : 1])
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
		if(settings)
			source["view_settings"] = settings[active_alternate ? 1 : 2]
		alternates[image] = source
	var/materials = ""
	if(backgrounds)
		materials = length(alternate) ? ", card materials main '[backgrounds[1]]', alternate '[backgrounds[2]]'" : ", card material '[backgrounds[1]]'"
	if(settings)
		materials += ", artwork view settings main '[json_encode(settings[1])]', alternate '[json_encode(settings[2])]'"
	COOLDOWN_START(src, url_save_cooldown, CHARACTER_GALLERY_LOGGED_COOLDOWN)
	log_game("[user] has set [describe(form, FALSE, url_editor["label"])] URLs to main '[main]', alternate '[alternate]', using [active_alternate ? "alternate" : "main"][materials].")
	close_url_editor()
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
	return list(
		"main" = main,
		"alternate" = alternate,
		"active_alternate" = active_alternate,
		"promote_alternate" = promote_alternate,
	)

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

/datum/character_gallery/proc/resolve_art_view_settings(form, image, main, alternate, promote_alternate)
	var/list/settings = gallery_art_view_settings(image_owner(form))
	var/list/kept = resolve_source_values(form, image, settings[image], "view_settings", main, alternate, promote_alternate)
	return list(sanitize_art_view_settings(kept[1]), sanitize_art_view_settings(kept[2]))

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
	if(image != gallery_art_slot(nsfw, index) || index > IMAGE_GALLERY_MAX)
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
	set_gallery_art_view_settings(image_owner(form), image, null, null)
	return TRUE
