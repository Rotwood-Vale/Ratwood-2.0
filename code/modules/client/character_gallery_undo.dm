/// Restores source metadata without rebuilding rows, preserving unrelated row Undo points
/datum/character_gallery/proc/restore_artwork_metadata(form, list/saved)
	var/datum/owner = image_owner(form)
	var/list/alternates = get_alternates(form)
	var/list/backgrounds = gallery_card_backgrounds(owner)
	var/list/view_settings = gallery_art_view_settings(owner)
	for(var/prefix in GALLERY_ART_PREFIXES)
		var/list/rows = saved[prefix]
		for(var/index in 1 to length(rows))
			var/slot = "[prefix]_[index]"
			var/list/row = rows[index]
			if(backgrounds[slot] != row[GALLERY_ART_ROW_BACKGROUND])
				set_gallery_card_background(owner, slot, row[GALLERY_ART_ROW_URL], row[GALLERY_ART_ROW_BACKGROUND])
			if(json_encode(view_settings[slot]) != json_encode(row[GALLERY_ART_ROW_VIEW_SETTINGS]))
				set_gallery_art_view_settings(owner, slot, row[GALLERY_ART_ROW_URL], row[GALLERY_ART_ROW_VIEW_SETTINGS])
			var/list/current_source = live_gallery_source(alternates, slot, row[GALLERY_ART_ROW_URL])
			if(json_encode(gallery_art_source_state(current_source)) != json_encode(row[GALLERY_ART_ROW_SOURCE]))
				alternates -= slot
				if(row[GALLERY_ART_ROW_SOURCE])
					alternates[slot] = deepCopyList(row[GALLERY_ART_ROW_SOURCE])

/datum/character_gallery/proc/art_rows(form, prefix)
	. = list()
	var/list/backgrounds = gallery_card_backgrounds(image_owner(form))
	var/list/view_settings = gallery_art_view_settings(image_owner(form))
	var/list/alternates = get_alternates(form)
	var/list/gallery = get_gallery(form, prefix == "nsfw_art")
	for(var/index in 1 to length(gallery))
		var/slot = "[prefix]_[index]"
		var/list/source = live_gallery_source(alternates, slot, gallery[index])
		. += list(list(gallery[index], gallery_art_source_state(source), backgrounds[slot], view_settings[slot]))

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
		set_gallery_art_view_settings(owner, slot, null, null)
	var/list/gallery = list()
	for(var/list/row as anything in rows)
		gallery += row[GALLERY_ART_ROW_URL]
		var/slot = "[prefix]_[length(gallery)]"
		if(row[GALLERY_ART_ROW_SOURCE])
			alternates[slot] = row[GALLERY_ART_ROW_SOURCE]
		set_gallery_card_background(owner, slot, row[GALLERY_ART_ROW_URL], row[GALLERY_ART_ROW_BACKGROUND])
		set_gallery_art_view_settings(owner, slot, row[GALLERY_ART_ROW_URL], row[GALLERY_ART_ROW_VIEW_SETTINGS])
	set_gallery(form, prefix == "nsfw_art", gallery)

/**
 * A copy of part of a form for Undo, which restore() takes back with the same scope
 *
 * Scopes:
 * * "artwork" - both galleries' art_rows() under "art" and "nsfw_art"
 * * "artwork_defaults" - this form's defaults for new artwork
 * * "artwork_and_defaults" - both of the above, for a combined display change
 * * "form" - the capture of every part of the form under its own scope name
 * * "art" or "nsfw_art" - that gallery's art_rows()
 * * "blocked" - a shallow copy of blocked_links
 * * an image slot name - its "link" and a deep copy of its "source", with "background" and "view_settings" for
 *   an art slot, "frame" for the headshot and "size" for an OOC extra
 *
 * links is an optional gallery_image_links() result the caller already holds
 */
/datum/character_gallery/proc/capture(form, scope, list/links)
	var/datum/owner = image_owner(form)
	switch(scope)
		if("artwork_defaults")
			return gallery_artwork_defaults(owner)
		if("artwork_and_defaults")
			return list("artwork" = capture(form, "artwork"), "artwork_defaults" = gallery_artwork_defaults(owner))
		if("artwork")
			return list("art" = art_rows(form, "art"), "nsfw_art" = art_rows(form, "nsfw_art"))
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
		var/list/view_settings = gallery_art_view_settings(owner)
		.["view_settings"] = view_settings[scope]
	if(scope == "headshot")
		.["frame"] = gallery_headshot_frame(owner)
	else if(scope == "extra" || scope == "nsfw_extra")
		.["size"] = get_extra_size(form, scope == "nsfw_extra")

/datum/character_gallery/proc/restore(form, scope, list/saved)
	var/datum/owner = image_owner(form)
	switch(scope)
		if("artwork_defaults")
			owner.vars["artwork_defaults"] = saved.Copy()
			return
		if("artwork")
			restore_artwork_metadata(form, saved)
			return
		if("form", "artwork_and_defaults")
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
		set_gallery_art_view_settings(owner, scope, saved["link"], saved["view_settings"])
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
