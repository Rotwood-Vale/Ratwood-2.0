/// The inline style that frames a headshot in a square box, which must match HeadshotFrame in tgui
/proc/headshot_picture_style(zoom, x, y)
	var/position = "[x]% [y]%"
	return "object-fit: cover; object-position: [position]; transform: scale([zoom / 100]); transform-origin: [position];"

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

/// The card materials, whose ids must match the list in tgui's common/CardBackground.tsx. Returns a static list, which callers must never change
/proc/gallery_card_background_options()
	var/static/list/options = list(
		list("value" = "black", "label" = "Original Black"),
		list("value" = "charcoal", "label" = "Charcoal"),
		list("value" = "red", "label" = "Oxblood"),
		list("value" = "green", "label" = "Deep Moss"),
		list("value" = "transparent", "label" = "Transparent"),
		list("value" = "glass", "label" = "Old Glass"),
	)
	return options

/// Whether a value is one of the ids in gallery_card_background_options(), which are gathered once on the first call
/proc/is_card_material(value)
	var/static/list/materials
	if(!materials)
		materials = list()
		for(var/list/option as anything in gallery_card_background_options())
			materials += option["value"]
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

/// Each occupied art slot's card backdrop. art_links, when given, must be what gallery_art_links(owner) returns
/proc/gallery_card_backgrounds(datum/owner, list/art_links)
	. = list()
	if(!owner)
		return
	var/list/backgrounds = owner.vars["card_backgrounds"]
	if(isnull(art_links))
		art_links = gallery_art_links(owner)
	for(var/image in art_links)
		.[image] = read_card_background(backgrounds, image, art_links[image])

/proc/set_gallery_card_background(datum/owner, image, link, background)
	var/list/backgrounds = owner.vars["card_backgrounds"]
	if(!islist(backgrounds))
		backgrounds = list()
		owner.vars["card_backgrounds"] = backgrounds
	backgrounds -= image
	background = sanitize_card_background(background)
	if(link && background != GALLERY_CARD_DEFAULT)
		backgrounds[image] = list("url" = link, "background" = background)

/// The opening view ids, which ART_VIEW_LABELS in tgui's common/artViewSettings.ts must match
/proc/is_art_opening_view(value)
	var/static/list/views = list("whole", "fitted", "scroll")
	return istext(value) && (value in views)

/proc/is_art_view_lock(value)
	var/static/list/locks = list("none", "view", "zoom", "both")
	return istext(value) && (value in locks)

/// Whether a crop holds x, y, w and h as numbers from 0 to 1, a share of the picture's width or height each
/proc/is_art_crop(list/crop)
	var/static/list/fields = list("x", "y", "w", "h")
	if(!islist(crop) || length(crop) != 4)
		return FALSE
	for(var/field in fields)
		var/value = crop[field]
		if(!isnum(value) || isnan(value) || value < 0 || value > 1)
			return FALSE
	return TRUE

/// Fits a valid crop inside the picture with each side at least GALLERY_ART_CROP_MIN, as ART_CROP_MIN in tgui does, or returns null
/proc/sanitize_art_crop(list/crop)
	if(!is_art_crop(crop))
		return null
	var/left = clamp(round(crop["x"], 0.0001), 0, 1 - GALLERY_ART_CROP_MIN)
	var/top = clamp(round(crop["y"], 0.0001), 0, 1 - GALLERY_ART_CROP_MIN)
	var/width = clamp(round(crop["w"], 0.0001), GALLERY_ART_CROP_MIN, 1 - left)
	var/height = clamp(round(crop["h"], 0.0001), GALLERY_ART_CROP_MIN, 1 - top)
	return list("x" = left, "y" = top, "w" = width, "h" = height)

/// Whether settings from the window hold a valid opening view and lock, and a valid crop or none, with no other keys
/proc/is_art_view_settings(list/settings)
	var/static/list/fields = list("opening_view", "lock", "crop")
	if(!islist(settings) || !is_art_opening_view(settings["opening_view"]) || !is_art_view_lock(settings["lock"]))
		return FALSE
	for(var/field in settings)
		if(!(field in fields))
			return FALSE
	return isnull(settings["crop"]) || is_art_crop(settings["crop"])

/**
 * Missing or invalid settings read as the default, which must match DEFAULT_ART_VIEW in tgui's common/artViewSettings.ts
 *
 * A crop is kept only when valid, whichever view opens
 */
/proc/sanitize_art_view_settings(list/settings)
	. = list("opening_view" = "whole", "lock" = "zoom")
	if(!islist(settings) || !is_art_view_lock(settings["lock"]))
		return
	if(!is_art_opening_view(settings["opening_view"]))
		return
	.["opening_view"] = settings["opening_view"]
	.["lock"] = settings["lock"]
	var/list/crop = sanitize_art_crop(settings["crop"])
	if(crop)
		.["crop"] = crop

/proc/is_default_art_view(list/settings)
	var/list/default_settings = sanitize_art_view_settings(null)
	return settings["opening_view"] == default_settings["opening_view"] && settings["lock"] == default_settings["lock"] && isnull(settings["crop"])

/// Returns the three settings a new artwork source can inherit, using game defaults for missing or invalid fields
/proc/sanitize_artwork_defaults(list/defaults)
	. = sanitize_art_view_settings(null)
	.["card_background"] = GALLERY_CARD_DEFAULT
	if(!islist(defaults))
		return
	if(is_art_opening_view(defaults["opening_view"]))
		.["opening_view"] = defaults["opening_view"]
	if(is_art_view_lock(defaults["lock"]))
		.["lock"] = defaults["lock"]
	.["card_background"] = sanitize_card_background(defaults["card_background"])

/// Returns an independent defaults record for the character or gnoll editor
/proc/gallery_artwork_defaults(datum/owner)
	return sanitize_artwork_defaults(owner ? owner.vars["artwork_defaults"] : null)

/// The record stored for an image's view settings, which must already be sanitized
/proc/art_view_settings_entry(link, list/settings)
	. = list("url" = link, "opening_view" = settings["opening_view"], "lock" = settings["lock"])
	var/list/crop = settings["crop"]
	if(crop)
		.["crop"] = crop.Copy()

/proc/read_art_view_settings(list/settings, image, link)
	var/list/entry = islist(settings) ? settings[image] : null
	if(!link || !islist(entry) || entry["url"] != link)
		return sanitize_art_view_settings(null)
	return sanitize_art_view_settings(entry)

/**
 * Projects occupied art slots in gallery order, using defaults when a stored URL no longer matches
 *
 * art_links, when given, must be what gallery_art_links(owner) returns
 */
/proc/gallery_art_view_settings(datum/owner, list/art_links)
	. = list()
	if(!owner)
		return
	var/list/settings = owner.vars["art_view_settings"]
	if(isnull(art_links))
		art_links = gallery_art_links(owner)
	for(var/image in art_links)
		.[image] = read_art_view_settings(settings, image, art_links[image])

/proc/set_gallery_art_view_settings(datum/owner, image, link, list/settings)
	var/list/stored = owner.vars["art_view_settings"]
	if(!islist(stored))
		stored = list()
		owner.vars["art_view_settings"] = stored
	stored -= image
	settings = sanitize_art_view_settings(settings)
	if(link && !is_default_art_view(settings))
		stored[image] = art_view_settings_entry(link, settings)

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
		if(!links[image] || !live_gallery_source(alternates, image, links[image]))
			alternates -= image
			. = TRUE

/// An image slot's alternate source while its current link is still the link given, or else null
/proc/live_gallery_source(list/alternates, slot, link)
	var/list/source = alternates[slot]
	if(!islist(source) || source["current_url"] != link)
		return null
	return source

/proc/ooc_extra_img_markup(link, size = OOC_EXTRA_SIZE_MAX)
	if(is_video_link(link))
		return "<div align='center'><br><video style='max-width: [size]%;' controls controlslist='nodownload' preload='metadata'><source src='[GALLERY_ATTRIBUTE_LINK(link)]' type='video/mp4'></video></div>"
	return "<div align='center'><br><img src='[GALLERY_ATTRIBUTE_LINK(link)]' style='max-width: [size]%;'/></div>"

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
	var/artwork_defaults
	S["[prefix]artwork_defaults"] >> artwork_defaults
	owner.vars["artwork_defaults"] = sanitize_artwork_defaults(artwork_defaults)
	if(length(blocked) > IMAGE_BLOCKED_MAX)
		blocked.Cut(1, length(blocked) - IMAGE_BLOCKED_MAX + 1)
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
	for(var/art in GALLERY_ART_PREFIXES)
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
		if(row["art"] && !is_default_art_view(view))
			view_settings[slot] = art_view_settings_entry(link, view)
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
	WRITE_FILE(S["[prefix]artwork_defaults"], gallery_artwork_defaults(owner))

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
	state += list(gallery_artwork_defaults(owner))
	return state

/proc/gallery_image_links(datum/owner)
	var/list/links = list("headshot" = owner.vars["headshot_link"], "extra" = owner.vars["ooc_extra_img_link"], "nsfw_extra" = owner.vars["nsfw_ooc_extra_img_link"])
	var/list/art_links = gallery_art_links(owner)
	for(var/image in art_links)
		links[image] = art_links[image]
	return links

/// Each occupied art slot's link by slot name, the SFW gallery then the NSFW one in gallery order, each cut at IMAGE_GALLERY_MAX
/proc/gallery_art_links(datum/owner)
	. = list()
	for(var/field in list("img_gallery", "nsfw_img_gallery"))
		var/list/gallery = owner.vars[field]
		for(var/index in 1 to min(length(gallery), IMAGE_GALLERY_MAX))
			.[gallery_art_slot(field == "nsfw_img_gallery", index)] = gallery[index]

/// The examine Image Gallery's settings from its viewer's preferences. With none, Plain Gallery is on, every effect off and the volume full
/proc/gallery_viewer_settings(datum/preferences/viewer_prefs)
	return list(
		"plain" = viewer_prefs ? !!viewer_prefs.gallery_plain : TRUE,
		"backdrop" = !!viewer_prefs?.gallery_backdrop,
		"card_deal" = !!viewer_prefs?.gallery_card_deal,
		"image_sounds" = !!viewer_prefs?.gallery_image_sounds,
		"image_tilt" = !!viewer_prefs?.gallery_image_tilt,
		"candle_flicker" = !!viewer_prefs?.gallery_candle_flicker,
		"easter_eggs" = !!viewer_prefs?.gallery_easter_eggs,
		"sound_volume" = viewer_prefs ? viewer_prefs.at_overall(viewer_prefs.mastervol) : 100,
	)

/proc/gallery_image_extensions(image)
	var/static/list/pictures = list("jpg", "jpeg", "png")
	var/static/list/media = list("jpg", "jpeg", "png", "gif", "mp4")
	return image == "extra" || image == "nsfw_extra" ? media : pictures

/proc/gallery_headshot_frame(datum/owner)
	return list(owner.vars["headshot_zoom"], owner.vars["headshot_x"], owner.vars["headshot_y"], owner.vars["headshot_framed"])

/// Writes the frame as given, so it must already be sanitized
/proc/set_gallery_frame(datum/owner, list/frame)
	owner.vars["headshot_zoom"] = frame[GALLERY_FRAME_ZOOM]
	owner.vars["headshot_x"] = frame[GALLERY_FRAME_X]
	owner.vars["headshot_y"] = frame[GALLERY_FRAME_Y]
	owner.vars["headshot_framed"] = frame[GALLERY_FRAME_FRAMED]

/// Gives an owner's headshot the unframed defaults
/proc/reset_gallery_frame(datum/owner)
	set_gallery_frame(owner, sanitize_gallery_frame(null))

/proc/sanitize_gallery_frame(list/frame)
	if(!islist(frame) || length(frame) != 4 || !frame[GALLERY_FRAME_FRAMED])
		return list(HEADSHOT_ZOOM_MIN, HEADSHOT_X_DEFAULT, HEADSHOT_Y_DEFAULT, FALSE)
	return list(
		sanitize_integer(frame[GALLERY_FRAME_ZOOM], HEADSHOT_ZOOM_MIN, HEADSHOT_ZOOM_MAX, HEADSHOT_ZOOM_MIN),
		sanitize_headshot_position(frame[GALLERY_FRAME_X], HEADSHOT_X_DEFAULT),
		sanitize_headshot_position(frame[GALLERY_FRAME_Y], HEADSHOT_Y_DEFAULT),
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
	return GALLERY_BACKDROP_TAVERN

/proc/sanitize_gallery_backdrop_toggle(value)
	// A missing key reads as null, which is not FALSE under == and so stays on
	if(value == FALSE || value == "" || value == GALLERY_BACKDROP_NONE)
		return FALSE
	return TRUE
