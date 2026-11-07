/datum/examine_panel
	/// Mob that the examine panel belongs to.
	var/mob/living/carbon/human/holder
	/// The screen containing the appearance of the mob
	var/atom/movable/screen/map_view/examine_panel_screen/examine_panel_screen

	var/datum/preferences/pref = null

	var/is_playing = FALSE

	var/mob/viewing

	/// Tells Examine Panel that we're previewing our written prefs, as well as which flavortext to preview (character, gnoll, etc)
	var/previewing = ""

	/// Rolled once per opening, so a refresh never makes a figure appear or vanish
	var/list/gallery_figures

/datum/examine_panel/New(mob/holder_mob)
	if(holder_mob)
		holder = holder_mob

/datum/examine_panel/Destroy(force)
	holder = null
	viewing = null
	qdel(examine_panel_screen)
	return ..()

/datum/examine_panel/ui_state(mob/user)
	return GLOB.always_state

/atom/movable/screen/map_view/examine_panel_screen
	name = "examine panel screen"

/datum/examine_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		gallery_figures = roll_gallery_figures()
		ui = new(user, src, "ExaminePanel")
		ui.set_autoupdate(FALSE) // this would not really ever need to autoupdate aside from maybe obscured stuff, but just re-examine at that point
		ui.open()

/datum/examine_panel/proc/roll_gallery_figures()
	if(!prob(GALLERY_TAVERN_FIGURE_CHANCE))
		return list()
	if(shows_lupian() || prob(50))
		return list(GALLERY_FIGURE_TAVERN_DOG)
	return list(GALLERY_FIGURE_TAVERN_CAT)

/datum/examine_panel/proc/shows_lupian()
	if(!length(previewing))
		return islupian(holder)
	return previewing == GALLERY_FORM_CHARACTER && istype(pref?.pref_species, /datum/species/lupian)

/datum/examine_panel/ui_data(mob/user)

	var/flavor_text
	var/flavor_text_nsfw
	var/obscured
	var/ooc_notes = ""
	var/ooc_notes_nsfw
	var/headshot = ""
	var/headshot_zoom = HEADSHOT_ZOOM_MIN
	var/headshot_x = HEADSHOT_X_DEFAULT
	var/headshot_y = HEADSHOT_Y_DEFAULT
	// The mob or preferences the headshot framing and the gallery backdrop are read from, none while the face is obscured
	var/datum/framing_source
	var/image_backdrop = GALLERY_BACKDROP_PICTURE
	var/list/img_gallery = list()
	var/list/nsfw_img_gallery = list()
	var/ooc_extra_image = ""
	var/nsfw_ooc_extra_image = ""
	var/char_name
	var/song_url
	var/song_title
	var/song_artist
	var/has_song = FALSE
	var/is_vet = FALSE
	var/is_naked = FALSE
	var/nsfw_examine_always = FALSE

	if(!length(previewing) && ishuman(holder))
		var/mob/living/carbon/human/holder_human = holder
		if(!(holder.wear_armor && holder.wear_armor.flags_inv) && !(holder.wear_shirt && holder.wear_shirt.flags_inv) && !(holder_human.underwear))
			is_naked = TRUE
		obscured = ((!isobserver(user)) && !holder_human.client?.prefs?.masked_examine) && ((holder_human.wear_mask && (holder_human.wear_mask.flags_inv & HIDEFACE)) || (holder_human.head && (holder_human.head.flags_inv & HIDEFACE)))
		flavor_text = obscured ? "Obscured" : holder.flavortext
		flavor_text_nsfw = obscured ? "Obscured" : holder.nsfwflavortext
		nsfw_examine_always = holder_human.client?.prefs?.nsfw_examine_always
		ooc_notes += holder.ooc_notes
		ooc_notes_nsfw += holder.erpprefs
		char_name = holder.name
		song_url = holder.ooc_extra
		song_title = holder_human.song_title
		song_artist = holder_human.song_artist
		is_vet = holder.check_agevet()
		if(!obscured)
			headshot += holder.headshot_link
			framing_source = holder
			img_gallery = holder.img_gallery
			nsfw_img_gallery = holder.nsfw_img_gallery
			ooc_extra_image = holder.ooc_extra_img
			nsfw_ooc_extra_image = holder.nsfw_ooc_extra_img
		if(!holder.headshot_link)
			headshot = "headshot_red.png"

	else if(pref)
		switch(previewing)
			if("character") // Flavortext for your character slot, nothing else
				is_naked = TRUE
				obscured = FALSE
				flavor_text = pref.flavortext
				flavor_text_nsfw = pref.nsfwflavortext
				nsfw_examine_always = FALSE
				ooc_notes = pref.ooc_notes
				ooc_notes_nsfw = pref.erpprefs
				headshot = pref.headshot_link
				framing_source = pref
				img_gallery = pref.img_gallery
				nsfw_img_gallery = pref.nsfw_img_gallery
				ooc_extra_image = pref.ooc_extra_img
				nsfw_ooc_extra_image = pref.nsfw_ooc_extra_img
				char_name = pref.real_name
				song_url = pref.ooc_extra
				song_title = pref.song_title
				song_artist = pref.song_artist
				if(viewing)
					is_vet = viewing.check_agevet()
				if(!headshot)
					headshot = "headshot_red.png"

			if("gnoll")
				var/datum/gnoll_prefs/gnoll = pref.gnoll_prefs // no way this DOESN'T exist here
				is_naked = TRUE
				obscured = FALSE
				flavor_text = gnoll.flavortext
				flavor_text_nsfw = gnoll.nsfwflavortext
				nsfw_examine_always = FALSE
				ooc_notes = gnoll.ooc_notes
				ooc_notes_nsfw = gnoll.erpprefs
				headshot = gnoll.headshot_link
				framing_source = gnoll
				img_gallery = gnoll.img_gallery
				nsfw_img_gallery = gnoll.nsfw_img_gallery
				ooc_extra_image = gnoll.ooc_extra_img
				nsfw_ooc_extra_image = gnoll.nsfw_ooc_extra_img
				char_name = gnoll.gnoll_name
				song_url = gnoll.ooc_extra
				song_title = gnoll.song_title
				song_artist = gnoll.song_artist
				if(viewing)
					is_vet = viewing.check_agevet()
				if(!headshot)
					headshot = "headshot_red.png"

	var/has_headshot = !!framing_source?.vars["headshot_link"]
	if(has_headshot)
		var/list/frame = gallery_headshot_frame(framing_source)
		headshot_zoom = frame[1]
		headshot_x = frame[2]
		headshot_y = frame[3]
	if(framing_source)
		image_backdrop = framing_source.vars["image_backdrop"]

	if(song_url)
		has_song = TRUE

	ooc_notes = html_encode(ooc_notes)
	ooc_notes = parsemarkdown_basic(ooc_notes, hyperlink=TRUE)
	ooc_notes_nsfw = html_encode(ooc_notes_nsfw)
	ooc_notes_nsfw = parsemarkdown_basic(ooc_notes_nsfw, hyperlink=TRUE)
	flavor_text = html_encode(flavor_text)
	flavor_text = parsemarkdown_basic(flavor_text, hyperlink=TRUE)
	flavor_text_nsfw = html_encode(flavor_text_nsfw)
	flavor_text_nsfw = parsemarkdown_basic(flavor_text_nsfw, hyperlink=TRUE)

	var/datum/preferences/viewer_prefs = user?.client?.prefs

	var/list/data = list(
		// Identity
		"character_name" = obscured ? "Unknown" : char_name,
		"headshot" = headshot,
		"has_headshot" = has_headshot,
		"headshot_zoom" = headshot_zoom,
		"headshot_x" = headshot_x,
		"headshot_y" = headshot_y,
		"is_admin" = check_rights_for(user?.client, R_ADMIN) ? TRUE : FALSE,
		"obscured" = obscured ? TRUE : FALSE,
		// Descriptions
		"flavor_text" = flavor_text,
		"ooc_notes" = ooc_notes,
		// Descriptions, but requiring manual input to see
		"flavor_text_nsfw" = flavor_text_nsfw,
		"ooc_notes_nsfw" = ooc_notes_nsfw,
		"img_gallery" = img_gallery,
		"nsfw_img_gallery" = nsfw_img_gallery,
		"ooc_extra_image" = ooc_extra_image,
		"nsfw_ooc_extra_image" = nsfw_ooc_extra_image,
		"is_playing" = is_playing,
		"has_song" = has_song,
		"is_vet" = is_vet,
		"is_naked" = is_naked,
		"nsfw_examine_always" = nsfw_examine_always,
		"gallery" = list(
			"plain" = viewer_prefs ? !!viewer_prefs.gallery_plain : TRUE,
			"backdrop" = !!viewer_prefs?.gallery_backdrop,
			"card_deal" = !!viewer_prefs?.gallery_card_deal,
			"image_sounds" = !!viewer_prefs?.gallery_image_sounds,
			"image_tilt" = !!viewer_prefs?.gallery_image_tilt,
			"candle_flicker" = !!viewer_prefs?.gallery_candle_flicker,
			"easter_eggs" = !!viewer_prefs?.gallery_easter_eggs,
		),
		"image_backdrop" = image_backdrop,
		"card_backgrounds" = gallery_card_backgrounds(framing_source),
		"gallery_figures" = gallery_figures || list(),
		"song_title" = has_song ? song_title : null,
		"song_artist" = has_song ? song_artist : null,
	)
	return data

/datum/examine_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	if(.)
		return

	if(!viewing)
		return

	var/client/C
	var/web_sound_url
	var/artist_name = "Song Artist Hidden"
	var/song_title
	var/list/music_extra_data = list()

	C = viewing.client

	if(!length(previewing) && ishuman(holder))
		web_sound_url = holder.ooc_extra
		if(holder.song_artist)
			artist_name = holder.song_artist
		song_title = holder.song_title
	else if(pref)
		switch(previewing)
			if("character")
				web_sound_url = pref.ooc_extra
				if(pref.song_artist)
					artist_name = pref.song_artist
				song_title = pref.song_title
			if("gnoll")
				var/datum/gnoll_prefs/gnoll = pref.gnoll_prefs
				web_sound_url = gnoll.ooc_extra
				if(gnoll.song_artist)
					artist_name = gnoll.song_artist
				song_title = gnoll.song_title

	if(!C || !web_sound_url)
		return

	if(!web_sound_url)
		return

	switch(action)
		if("toggle")
			if(!is_playing)
				is_playing = TRUE
				music_extra_data["link"] = web_sound_url
				music_extra_data["title"] = song_title
				music_extra_data["duration"] = "Song Duration Hidden"
				music_extra_data["artist"] = artist_name
				C.tgui_panel?.play_music(web_sound_url, music_extra_data)
			else
				is_playing = FALSE
				C.tgui_panel?.stop_music()
			return TRUE
		if("vet_chat")
			to_chat(viewing, span_boldgreen("This player is age-verified!"))
			return TRUE

/datum/examine_panel/ui_close()
	QDEL_NULL(src)

/datum/examine_panel/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/headshot_imgs),
		get_asset_datum(/datum/asset/simple/examine_gallery_sounds),
		get_asset_datum(/datum/asset/simple/examine_gallery_scenes),
		get_asset_datum(/datum/asset/simple/gallery_card_materials),
	)

/datum/asset/simple/examine_gallery_scenes
	assets = list(
		"gallery_tavern_room.jpg" = 'icons/tgui/gallery/tavern/room.jpg',
		"gallery_tavern_table.png" = 'icons/tgui/gallery/tavern/table.png',
		"gallery_tavern_mammon_the_cat.png" = 'icons/tgui/gallery/tavern/mammon_the_cat.png',
		"gallery_tavern_mammon_the_cat_blink_half.png" = 'icons/tgui/gallery/tavern/mammon_the_cat_blink_half.png',
		"gallery_tavern_mammon_the_cat_blink_shut.png" = 'icons/tgui/gallery/tavern/mammon_the_cat_blink_shut.png',
		"gallery_tavern_mammon_the_cat_judging_face.png" = 'icons/tgui/gallery/tavern/mammon_the_cat_judging_face.png',
		"gallery_tavern_mammon_the_cat_judging_blink_half.png" = 'icons/tgui/gallery/tavern/mammon_the_cat_judging_blink_half.png',
		"gallery_tavern_mammon_the_cat_judging_blink_shut.png" = 'icons/tgui/gallery/tavern/mammon_the_cat_judging_blink_shut.png',
		"gallery_tavern_mammon_the_cat_mouth_level.png" = 'icons/tgui/gallery/tavern/mammon_the_cat_mouth_level.png',
		"gallery_tavern_guinefort_the_dog.png" = 'icons/tgui/gallery/tavern/guinefort_the_dog.png',
		"gallery_tavern_guinefort_the_dog_blink_half.png" = 'icons/tgui/gallery/tavern/guinefort_the_dog_blink_half.png',
		"gallery_tavern_guinefort_the_dog_blink_shut.png" = 'icons/tgui/gallery/tavern/guinefort_the_dog_blink_shut.png',
		"gallery_tavern_guinefort_the_dog_annoyed_face.png" = 'icons/tgui/gallery/tavern/guinefort_the_dog_annoyed_face.png',
		"gallery_tavern_guinefort_the_dog_annoyed_blink_half.png" = 'icons/tgui/gallery/tavern/guinefort_the_dog_annoyed_blink_half.png',
		"gallery_tavern_guinefort_the_dog_annoyed_blink_shut.png" = 'icons/tgui/gallery/tavern/guinefort_the_dog_annoyed_blink_shut.png',
		"gallery_tavern_guinefort_the_dog_mouth_level.png" = 'icons/tgui/gallery/tavern/guinefort_the_dog_mouth_level.png',
		)

/datum/asset/simple/examine_gallery_sounds
	assets = list(
		"gallery_tick.ogg" = 'sound/misc/gallery_tick.ogg',
		"gallery_card.ogg" = 'sound/misc/gallery_card.ogg',
		"gallery_slip.ogg" = 'sound/misc/slip.ogg',
		)

/datum/asset/simple/headshot_imgs
	assets = list(
		"headshot_background.png" = 'icons/tgui/headshot_background.png',
		"headshot_red.png" = 'icons/tgui/headshot_red.png',
		)
