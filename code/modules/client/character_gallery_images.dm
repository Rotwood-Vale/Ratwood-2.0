/// The inline style that frames a headshot in a square box, which must match HeadshotFrame in tgui
/proc/headshot_picture_style(zoom, x, y)
	var/position = "[x]% [y]%"
	return "object-fit: cover; object-position: [position]; transform: scale([zoom / 100]); transform-origin: [position];"

/proc/gallery_thumbnail(caption, media)
	return "<div style='display: inline-block; vertical-align: top; text-align: center; margin: 4px 6px 0 0;'><div style='width: 100px; height: 100px; overflow: hidden; border: 1px solid #555;'>[media]</div><div style='font-size: 85%;'>[caption]</div></div>"

/proc/is_video_link(link)
	var/list/link_parts = splittext(link, ".")
	return LOWER_TEXT(link_parts[length(link_parts)]) == "mp4"

/proc/headshot_framing_text(link, framed, zoom, x, y)
	if(!link)
		return "no headshot"
	if(!framed)
		return "unframed on [link]"
	return "[zoom]% at [x], [y] on [link]"

/proc/sanitize_headshot_position(value, default)
	if(!isnum(value) || isnan(value))
		return default
	return clamp(round(value, 0.1), 0, HEADSHOT_POSITION_MAX)

/proc/gallery_slot_label(image)
	var/static/list/labels = list("headshot" = "Headshot", "extra" = "OOC Extra", "nsfw_extra" = "NSFW OOC Extra")
	if(!istext(image))
		return null
	if(labels[image])
		return labels[image]
	if(findtext(image, "art_") == 1)
		return "SFW Art"
	if(findtext(image, "nsfw_art_") == 1)
		return "NSFW Art"
	return null

/proc/gallery_art_slot(nsfw, index)
	return "[GALLERY_ART_PREFIX(nsfw)]_[index]"

/proc/gallery_art_label(nsfw, index)
	return "[nsfw ? "NSFW" : "SFW"] Art [index]"

/proc/add_blocked_link(list/blocked, label, url)
	if(!istext(url) || !length(url))
		return
	for(var/list/entry as anything in blocked)
		if(entry["url"] == url)
			return
	blocked += list(list("label" = label, "url" = url))

/// Whether a saved link may show in a slot when the gallery loads. It leaves out the IMAGE_LINK_MAX_LENGTH and
/// whitespace checks in new_url_error(), which only a newly typed link must pass. Adding them here would move a
/// saved link that breaks them into blocked_links on the next load
/proc/gallery_link_valid(link, image)
	return istext(link) && valid_headshot_link(null, link, TRUE, gallery_image_extensions(image))

/**
 * Attaches saved sources to the rows being loaded, each to its own row or else to the first free row
 * of its gallery showing its link, since only art rows shift
 *
 * A source no row holds has its links blocked, except a valid current link, which was only a copy of a row
 */
/proc/attach_gallery_sources(list/rows, list/saved, list/blocked)
	if(!islist(saved))
		return
	var/list/shifted = list()
	for(var/image in saved)
		if(!gallery_slot_label(image))
			continue
		var/list/source = saved[image]
		if(!islist(source))
			continue
		var/list/own_row = rows[image]
		if(length(source["current_url"]) && own_row?["link"] == source["current_url"])
			own_row["source"] = source
		else
			shifted[image] = source
	for(var/image in shifted)
		var/list/source = shifted[image]
		var/current = source["current_url"]
		var/label = gallery_slot_label(image)
		var/list/row = free_gallery_row(rows, current, label)
		if(row)
			row["source"] = source
			continue
		if(!gallery_link_valid(current, image))
			add_blocked_link(blocked, label, current)
		add_blocked_link(blocked, "[label] alternate", source["inactive_url"])

/proc/free_gallery_row(list/rows, current, label)
	if(!length(current))
		return null
	for(var/slot in rows)
		var/list/row = rows[slot]
		if(row["link"] == current && !row["source"] && gallery_slot_label(slot) == label)
			return row
	return null

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
			state += list(list(image, source["current_url"], source["inactive_url"], source["active_alternate"], source["framing"], sanitize_card_background(source["card_background"]), is_gallery_art_slot(image) ? sanitize_art_view_settings(source["view_settings"]) : null))
	return state

/proc/clean_gallery_alternate(image, list/source)
	var/list/clean = list("current_url" = source["current_url"], "inactive_url" = source["inactive_url"], "active_alternate" = !!source["active_alternate"])
	if(image == "headshot")
		clean["framing"] = sanitize_gallery_frame(source["framing"])
	if(is_gallery_art_slot(image) && source["card_background"])
		clean["card_background"] = sanitize_card_background(source["card_background"])
	if(is_gallery_art_slot(image) && source["view_settings"])
		clean["view_settings"] = sanitize_art_view_settings(source["view_settings"])
	return clean

/proc/is_gallery_art_slot(image)
	return istext(image) && (findtext(image, "art_") == 1 || findtext(image, "nsfw_art_") == 1)

/// The card materials, whose ids must match is_card_material() and the list in tgui's common/CardBackground.tsx
/proc/gallery_card_background_options()
	return list(
		list("value" = "black", "label" = "Original Black"),
		list("value" = "charcoal", "label" = "Charcoal"),
		list("value" = "red", "label" = "Oxblood"),
		list("value" = "green", "label" = "Deep Moss"),
		list("value" = "transparent", "label" = "Transparent"),
		list("value" = "glass", "label" = "Old Glass"),
	)

/proc/is_card_material(value)
	var/static/list/materials = list("black", "charcoal", "red", "green", "transparent", "glass")
	return istext(value) && (value in materials)

/proc/sanitize_card_background(value)
	return is_card_material(value) ? value : GALLERY_CARD_DEFAULT

/proc/read_card_background(list/backgrounds, image, link)
	if(!islist(backgrounds))
		return GALLERY_CARD_DEFAULT
	var/list/entry = backgrounds[image]
	if(!link || !islist(entry) || entry["url"] != link)
		return GALLERY_CARD_DEFAULT
	return sanitize_card_background(entry["background"])

/proc/gallery_card_backgrounds(datum/owner)
	. = list()
	if(!owner)
		return
	var/list/backgrounds = owner.vars["card_backgrounds"]
	for(var/field in list("img_gallery", "nsfw_img_gallery"))
		var/list/gallery = owner.vars[field]
		for(var/index in 1 to min(length(gallery), IMAGE_GALLERY_MAX))
			var/image = gallery_art_slot(field == "nsfw_img_gallery", index)
			.[image] = read_card_background(backgrounds, image, gallery[index])

/proc/set_gallery_card_background(datum/owner, image, link, background)
	var/list/backgrounds = owner.vars["card_backgrounds"]
	if(!islist(backgrounds))
		backgrounds = list()
		owner.vars["card_backgrounds"] = backgrounds
	backgrounds -= image
	background = sanitize_card_background(background)
	if(link && background != GALLERY_CARD_DEFAULT)
		backgrounds[image] = list("url" = link, "background" = background)

/proc/is_art_opening_view(value)
	return istext(value) && (value == "whole" || value == "scroll")

/proc/is_art_view_lock(value)
	var/static/list/locks = list("none", "view", "zoom", "both")
	return istext(value) && (value in locks)

/proc/is_art_view_settings(list/settings)
	return islist(settings) && length(settings) == 2 && is_art_opening_view(settings["opening_view"]) && is_art_view_lock(settings["lock"])

/proc/sanitize_art_view_settings(list/settings)
	if(!islist(settings) || !is_art_opening_view(settings["opening_view"]) || !is_art_view_lock(settings["lock"]))
		return list("opening_view" = "whole", "lock" = "none")
	return list("opening_view" = settings["opening_view"], "lock" = settings["lock"])

/proc/read_art_view_settings(list/settings, image, link)
	var/list/entry = islist(settings) ? settings[image] : null
	if(!link || !islist(entry) || entry["url"] != link)
		return sanitize_art_view_settings(null)
	return sanitize_art_view_settings(entry)

/// Projects occupied art slots in gallery order, using defaults when a stored URL no longer matches
/proc/gallery_art_view_settings(datum/owner)
	. = list()
	if(!owner)
		return
	var/list/settings = owner.vars["art_view_settings"]
	for(var/field in list("img_gallery", "nsfw_img_gallery"))
		var/list/gallery = owner.vars[field]
		for(var/index in 1 to min(length(gallery), IMAGE_GALLERY_MAX))
			var/image = gallery_art_slot(field == "nsfw_img_gallery", index)
			.[image] = read_art_view_settings(settings, image, gallery[index])

/proc/set_gallery_art_view_settings(datum/owner, image, link, list/settings)
	var/list/stored = owner.vars["art_view_settings"]
	if(!islist(stored))
		stored = list()
		owner.vars["art_view_settings"] = stored
	stored -= image
	settings = sanitize_art_view_settings(settings)
	if(link && (settings["opening_view"] != "whole" || settings["lock"] != "none"))
		stored[image] = list("url" = link, "opening_view" = settings["opening_view"], "lock" = settings["lock"])

/// Gives row snapshots one representation for absent and explicit default source settings
/proc/gallery_art_source_state(list/source)
	if(!islist(source))
		return null
	return list(
		"current_url" = source["current_url"],
		"inactive_url" = source["inactive_url"],
		"active_alternate" = !!source["active_alternate"],
		"card_background" = sanitize_card_background(source["card_background"]),
		"view_settings" = sanitize_art_view_settings(source["view_settings"]),
	)

/datum/asset/simple/gallery_card_materials
	assets = list("gallery_card_paint.png" = 'icons/tgui/gallery/paint.png')

/proc/sync_gallery_alternates(datum/owner, list/links)
	if(!owner)
		return FALSE
	var/list/alternates = owner.vars["gallery_alternates"]
	if(!islist(alternates))
		owner.vars["gallery_alternates"] = list()
		return TRUE
	if(!length(alternates))
		return FALSE
	links ||= gallery_image_links(owner)
	for(var/image in alternates.Copy())
		var/list/source = alternates[image]
		if(!links[image] || !islist(source) || source["current_url"] != links[image])
			alternates -= image
			. = TRUE

/proc/ooc_extra_img_markup(link, size = OOC_EXTRA_SIZE_MAX)
	if(is_video_link(link))
		return "<div align='center'><br><video style='max-width: [size]%;' controls controlslist='nodownload' preload='metadata'><source src='[link]' type='video/mp4'></video></div>"
	return "<div align='center'><br><img src='[link]' style='max-width: [size]%;'/></div>"

/proc/set_gallery_extra(datum/owner, nsfw, link, size)
	var/field = "[GALLERY_NSFW_PREFIX(nsfw)]ooc_extra_img"
	owner.vars["[field]_link"] = link
	owner.vars["[field]_size"] = size
	owner.vars[field] = link ? ooc_extra_img_markup(link, size) : null

/proc/load_gallery_images(savefile/S, datum/owner, prefix)
	var/list/saved = read_gallery_images(S, prefix)
	var/list/blocked = saved["blocked"]
	var/list/settled = settle_gallery_rows(saved["rows"], saved["frame"], blocked)
	var/list/links = settled["links"]
	var/list/galleries = settled["galleries"]
	owner.vars["headshot_link"] = links["headshot"]
	set_gallery_frame(owner, settled["frame"])
	set_gallery_extra(owner, FALSE, links["extra"], saved["extra_size"])
	set_gallery_extra(owner, TRUE, links["nsfw_extra"], saved["nsfw_extra_size"])
	owner.vars["img_gallery"] = galleries["art"]
	owner.vars["nsfw_img_gallery"] = galleries["nsfw_art"]
	owner.vars["gallery_alternates"] = settled["alternates"]
	owner.vars["card_backgrounds"] = settled["backgrounds"]
	owner.vars["art_view_settings"] = settled["view_settings"]
	if(length(blocked) > IMAGE_BLOCKED_MAX)
		blocked.Cut(IMAGE_BLOCKED_MAX + 1)
	owner.vars["blocked_links"] = blocked
	owner.vars["image_backdrop"] = saved["backdrop"]

/proc/read_gallery_images(savefile/S, prefix)
	var/value
	var/list/blocked = list()
	S["[prefix]blocked_links"] >> value
	if(islist(value))
		for(var/list/entry as anything in value)
			if(islist(entry) && istext(entry["label"]))
				add_blocked_link(blocked, entry["label"], entry["url"])

	var/list/rows = list()
	S["[prefix]headshot_link"] >> value
	rows["headshot"] = list("link" = value)
	S["[prefix]ooc_extra_img_link"] >> value
	rows["extra"] = list("link" = value)
	S["[prefix]nsfw_ooc_extra_img_link"] >> value
	rows["nsfw_extra"] = list("link" = value)
	for(var/art in list("art", "nsfw_art"))
		S["[prefix][GALLERY_NSFW_PREFIX(art == "nsfw_art")]img_gallery"] >> value
		if(!islist(value))
			continue
		var/raw_index = 0
		for(var/link in value)
			rows["[art]_[++raw_index]"] = list("link" = link, "art" = art)
	var/list/frame = list()
	for(var/field in list("headshot_zoom", "headshot_x", "headshot_y", "headshot_framed"))
		S["[prefix][field]"] >> value
		frame += list(value)
	frame = sanitize_gallery_frame(frame)
	S["[prefix]gallery_alternates"] >> value
	attach_gallery_sources(rows, value, blocked)
	S["[prefix]card_backgrounds"] >> value
	var/list/backgrounds = islist(value) ? value : list()
	for(var/image in rows)
		if(!is_gallery_art_slot(image))
			continue
		var/list/row = rows[image]
		row["background"] = read_card_background(backgrounds, image, row["link"])
	S["[prefix]art_view_settings"] >> value
	var/list/view_settings = islist(value) ? value : list()
	for(var/image in rows)
		if(!is_gallery_art_slot(image))
			continue
		var/list/row = rows[image]
		row["view_settings"] = read_art_view_settings(view_settings, image, row["link"])

	var/extra_size
	S["[prefix]ooc_extra_img_size"] >> extra_size
	var/nsfw_extra_size
	S["[prefix]nsfw_ooc_extra_img_size"] >> nsfw_extra_size
	S["[prefix]image_backdrop"] >> value
	return list(
		"blocked" = blocked,
		"rows" = rows,
		"frame" = frame,
		"extra_size" = sanitize_integer(extra_size, OOC_EXTRA_SIZE_MIN, OOC_EXTRA_SIZE_MAX, OOC_EXTRA_SIZE_MAX),
		"nsfw_extra_size" = sanitize_integer(nsfw_extra_size, OOC_EXTRA_SIZE_MIN, OOC_EXTRA_SIZE_MAX, OOC_EXTRA_SIZE_MAX),
		"backdrop" = sanitize_image_backdrop(value),
	)

/proc/settle_gallery_rows(list/rows, list/frame, list/blocked)
	var/list/links = list()
	var/list/alternates = list()
	var/list/backgrounds = list()
	var/list/view_settings = list()
	var/list/galleries = list("art" = list(), "nsfw_art" = list())
	for(var/image in rows)
		var/list/row = rows[image]
		var/label = gallery_slot_label(image)
		var/link = row["link"]
		var/list/source = row["source"]
		var/background = sanitize_card_background(row["background"])
		var/list/view = sanitize_art_view_settings(row["view_settings"])
		var/inactive_valid = source && gallery_link_valid(source["inactive_url"], image)
		var/link_valid = gallery_link_valid(link, image)
		if(!link_valid)
			add_blocked_link(blocked, label, link)
		if(source && !inactive_valid)
			add_blocked_link(blocked, "[label] alternate", source["inactive_url"])
			source = null
		if(!link_valid && !inactive_valid)
			continue
		// A failed link gives its slot to the valid alternate
		if(!link_valid)
			link = source["inactive_url"]
			background = sanitize_card_background(source["card_background"])
			view = sanitize_art_view_settings(source["view_settings"])
			if(image == "headshot")
				frame = sanitize_gallery_frame(source["framing"])
			source = null
		var/slot = image
		if(row["art"])
			var/list/gallery = galleries[row["art"]]
			if(length(gallery) >= IMAGE_GALLERY_MAX)
				add_blocked_link(blocked, label, link)
				if(source)
					add_blocked_link(blocked, "[label] alternate", source["inactive_url"])
				continue
			gallery += link
			slot = "[row["art"]]_[length(gallery)]"
		links[slot] = link
		if(row["art"] && background != GALLERY_CARD_DEFAULT)
			backgrounds[slot] = list("url" = link, "background" = background)
		if(row["art"] && (view["opening_view"] != "whole" || view["lock"] != "none"))
			view_settings[slot] = list("url" = link, "opening_view" = view["opening_view"], "lock" = view["lock"])
		if(source)
			alternates[slot] = clean_gallery_alternate(slot, source)
	return list("links" = links, "alternates" = alternates, "galleries" = galleries, "frame" = frame, "backgrounds" = backgrounds, "view_settings" = view_settings)

/// Also writes the extra markup, which a build reading the save back still needs
/proc/save_gallery_images(savefile/S, datum/owner, prefix)
	sync_gallery_alternates(owner)
	for(var/field in gallery_value_fields())
		WRITE_FILE(S["[prefix][field]"], owner.vars[field])
	// Left out of gallery_value_fields(), since the fingerprint covers markup through its link and sources and materials in slot order
	var/static/list/save_only_fields = list("ooc_extra_img", "nsfw_ooc_extra_img", "gallery_alternates", "card_backgrounds", "art_view_settings")
	for(var/field in save_only_fields)
		WRITE_FILE(S["[prefix][field]"], owner.vars[field])

/// The vars saved under their own names and fingerprinted. Returns a static list, which callers must never change
/proc/gallery_value_fields()
	var/static/list/fields = list("headshot_link", "headshot_zoom", "headshot_x", "headshot_y", "headshot_framed", "ooc_extra_img_link", "ooc_extra_img_size", "nsfw_ooc_extra_img_link", "nsfw_ooc_extra_img_size", "img_gallery", "nsfw_img_gallery", "blocked_links", "image_backdrop")
	return fields

/proc/gallery_form_state(datum/owner)
	var/list/state = list()
	for(var/field in gallery_value_fields())
		state += list(owner ? owner.vars[field] : null)
	state += list(gallery_alternate_state(owner))
	state += list(gallery_card_backgrounds(owner))
	state += list(gallery_art_view_settings(owner))
	return state

/proc/gallery_image_links(datum/owner)
	var/list/links = list("headshot" = owner.vars["headshot_link"], "extra" = owner.vars["ooc_extra_img_link"], "nsfw_extra" = owner.vars["nsfw_ooc_extra_img_link"])
	for(var/field in list("img_gallery", "nsfw_img_gallery"))
		var/list/gallery = owner.vars[field]
		var/prefix = GALLERY_ART_PREFIX(field == "nsfw_img_gallery")
		for(var/index in 1 to min(length(gallery), IMAGE_GALLERY_MAX))
			links["[prefix]_[index]"] = gallery[index]
	return links

/proc/gallery_image_extensions(image)
	var/static/list/pictures = list("jpg", "jpeg", "png")
	var/static/list/media = list("jpg", "jpeg", "png", "gif", "mp4")
	return image == "extra" || image == "nsfw_extra" ? media : pictures

/proc/gallery_headshot_frame(datum/owner)
	return list(owner.vars["headshot_zoom"], owner.vars["headshot_x"], owner.vars["headshot_y"], owner.vars["headshot_framed"])

/// Writes the frame as given, so it must already be sanitized
/proc/set_gallery_frame(datum/owner, list/frame)
	owner.vars["headshot_zoom"] = frame[1]
	owner.vars["headshot_x"] = frame[2]
	owner.vars["headshot_y"] = frame[3]
	owner.vars["headshot_framed"] = frame[4]

/proc/sanitize_gallery_frame(list/frame)
	if(!islist(frame) || length(frame) != 4 || !frame[4])
		return list(HEADSHOT_ZOOM_MIN, HEADSHOT_X_DEFAULT, HEADSHOT_Y_DEFAULT, FALSE)
	return list(
		sanitize_integer(frame[1], HEADSHOT_ZOOM_MIN, HEADSHOT_ZOOM_MAX, HEADSHOT_ZOOM_MIN),
		sanitize_headshot_position(frame[2], HEADSHOT_X_DEFAULT),
		sanitize_headshot_position(frame[3], HEADSHOT_Y_DEFAULT),
		TRUE,
	)

/// The examine Image Gallery's backdrops in the order the Character Gallery offers them, each id matching one in the gallery's backdrops.ts
/proc/gallery_backdrop_options()
	return list(
		list("value" = GALLERY_BACKDROP_NONE, "label" = "None"),
		list("value" = GALLERY_BACKDROP_PICTURE, "label" = "Blurred Picture"),
		list("value" = GALLERY_BACKDROP_TAVERN, "label" = "Tavern"),
	)

/proc/is_gallery_backdrop(backdrop)
	for(var/list/option as anything in gallery_backdrop_options())
		if(option["value"] == backdrop)
			return TRUE
	return FALSE

/proc/sanitize_image_backdrop(backdrop)
	if(is_gallery_backdrop(backdrop))
		return backdrop
	return GALLERY_BACKDROP_PICTURE

/proc/sanitize_gallery_backdrop_toggle(value)
	// A missing key reads as null, which is not FALSE under == and so stays on
	if(value == FALSE || value == "" || value == GALLERY_BACKDROP_NONE)
		return FALSE
	return TRUE
