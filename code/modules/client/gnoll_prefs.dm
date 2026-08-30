/datum/gnoll_prefs
	var/gnoll_name = ""
	var/gnoll_pronouns = HE_HIM
	var/pelt_type = "firepelt"
	var/list/genitals = list(
		"penis" = FALSE,
		"vagina" = FALSE,
		"breasts" = FALSE
	)
	var/descriptor_height     = /datum/mob_descriptor/height/moderate
	var/descriptor_body       = /datum/mob_descriptor/body/muscular
	var/descriptor_fur        = /datum/mob_descriptor/fur/coarse
	var/descriptor_voice      = /datum/mob_descriptor/voice/growly
	var/descriptor_muzzle     = /datum/mob_descriptor/face/gnoll/long_muzzle
	var/descriptor_expression = /datum/mob_descriptor/face_exp/gnoll/alert

	var/gnoll_voice_color = "a0a0a0"
	var/datum/statpack/gnoll_statpack = new /datum/statpack/wildcard/fated()

	var/headshot_link
	var/flavortext
	var/ooc_notes
	var/ooc_extra
	var/ooc_extra_img
	var/ooc_extra_img_link
	var/song_artist
	var/song_title
	var/rumour
	var/noble_gossip
	var/nsfwflavortext
	var/nsfw_ooc_extra_img
	var/nsfw_ooc_extra_img_link
	var/erpprefs
	var/list/img_gallery = list()
	var/list/nsfw_img_gallery = list()

/datum/gnoll_prefs/New()
	. = ..()
	ensure_gnoll_name()

/datum/gnoll_prefs/proc/generate_random_gnoll_name()
	return "[pick(GLOB.wolf_prefixes)] [pick(GLOB.wolf_suffixes)]"

/datum/gnoll_prefs/proc/ensure_gnoll_name()
	if(!gnoll_name)
		gnoll_name = generate_random_gnoll_name()
	return gnoll_name

/datum/gnoll_prefs/proc/get_pronoun_options()
	var/static/list/pronoun_options = list(
		"He/Him" = HE_HIM,
		"She/Her" = SHE_HER,
		"They/Them" = THEY_THEM,
		"It/Its" = IT_ITS
	)
	return pronoun_options

/datum/gnoll_prefs/proc/get_pelt_options()
	var/static/list/pelt_options = list(
		"Firepelt" = "firepelt",
		"Rotpelt" = "rotpelt",
		"Whitepelt" = "whitepelt",
		"Bloodpelt" = "bloodpelt",
		"Nightpelt" = "nightpelt",
		"Darkpelt" = "darkpelt"
	)
	return pelt_options

/// Copypaste of the _load_statpack proc from preferences_savefile.dm
/datum/gnoll_prefs/proc/load_gnoll_statpack(savefile/S)
	var/statpack_type
	S["gnoll_statpack"] >> statpack_type
	if (statpack_type && ispath(statpack_type))
		gnoll_statpack = new statpack_type()
	else
		gnoll_statpack = pick(GLOB.statpacks - /datum/statpack/wildcard/virtuous)
		gnoll_statpack = GLOB.statpacks[gnoll_statpack]

/datum/gnoll_prefs/proc/get_descriptor_options(slot)
	var/static/list/descriptor_options_by_slot = list(
		"height" = list(
				"Moderate" = /datum/mob_descriptor/height/moderate,
				"Middling" = /datum/mob_descriptor/height/middling,
				"Short" = /datum/mob_descriptor/height/short,
				"Tall" = /datum/mob_descriptor/height/tall,
				"Towering" = /datum/mob_descriptor/height/towering,
				"Giant" = /datum/mob_descriptor/height/giant,
				"Tiny" = /datum/mob_descriptor/height/tiny
		),
		"body" = list(
				"Average" = /datum/mob_descriptor/body/average,
				"Athletic" = /datum/mob_descriptor/body/athletic,
				"Muscular" = /datum/mob_descriptor/body/muscular,
				"Herculean" = /datum/mob_descriptor/body/herculean,
				"Toned" = /datum/mob_descriptor/body/toned,
				"Heavy" = /datum/mob_descriptor/body/heavy,
				"Lean" = /datum/mob_descriptor/body/lean,
				"Burly" = /datum/mob_descriptor/body/burly,
				"Gaunt" = /datum/mob_descriptor/body/gaunt,
				"Lanky" = /datum/mob_descriptor/body/lanky
		),
		"fur" = list(
				"Plain" = /datum/mob_descriptor/fur/plain,
				"Short" = /datum/mob_descriptor/fur/short,
				"Coarse" = /datum/mob_descriptor/fur/coarse,
				"Bristly" = /datum/mob_descriptor/fur/bristly,
				"Fluffy" = /datum/mob_descriptor/fur/fluffy,
				"Shaggy" = /datum/mob_descriptor/fur/shaggy,
				"Silky" = /datum/mob_descriptor/fur/silky,
				"Lank" = /datum/mob_descriptor/fur/lank,
				"Mangy" = /datum/mob_descriptor/fur/mangy,
				"Velvety" = /datum/mob_descriptor/fur/velvety,
				"Dense" = /datum/mob_descriptor/fur/dense,
				"Matted" = /datum/mob_descriptor/fur/matted
		),
		"voice" = list(
				"Growly" = /datum/mob_descriptor/voice/growly,
				"Deep" = /datum/mob_descriptor/voice/deep,
				"Booming" = /datum/mob_descriptor/voice/booming,
				"Gravelly" = /datum/mob_descriptor/voice/gravelly,
				"Commanding" = /datum/mob_descriptor/voice/commanding,
				"Monotone" = /datum/mob_descriptor/voice/monotone,
				"Ordinary" = /datum/mob_descriptor/voice/ordinary,
				"Soft" = /datum/mob_descriptor/voice/soft,
				"Grave" = /datum/mob_descriptor/voice/grave,
				"Venomous" = /datum/mob_descriptor/voice/venomous,
				"Dispassionate" = /datum/mob_descriptor/voice/dispassionate,
				"Whiny" = /datum/mob_descriptor/voice/whiny,
				"Drawling" = /datum/mob_descriptor/voice/drawling,
				"Shrill" = /datum/mob_descriptor/voice/shrill,
				"Stilted" = /datum/mob_descriptor/voice/stilted
		),
		"muzzle" = list(
				"Long" = /datum/mob_descriptor/face/gnoll/long_muzzle,
				"Short" = /datum/mob_descriptor/face/gnoll/short_muzzle,
				"Broad" = /datum/mob_descriptor/face/gnoll/broad_muzzle,
				"Narrow" = /datum/mob_descriptor/face/gnoll/narrow_muzzle,
				"Scarred" = /datum/mob_descriptor/face/gnoll/scarred_muzzle,
				"Sharp" = /datum/mob_descriptor/face/gnoll/sharp_muzzle,
				"Worn" = /datum/mob_descriptor/face/gnoll/worn_muzzle,
				"Disfigured" = /datum/mob_descriptor/face/gnoll/disfigured_muzzle
		),
		"expression" = list(
				"Alert" = /datum/mob_descriptor/face_exp/gnoll/alert,
				"Snarling" = /datum/mob_descriptor/face_exp/gnoll/snarling,
				"Predatory" = /datum/mob_descriptor/face_exp/gnoll/predatory,
				"Hollow" = /datum/mob_descriptor/face_exp/gnoll/hollow,
				"Fierce" = /datum/mob_descriptor/face_exp/gnoll/fierce,
				"Vacant" = /datum/mob_descriptor/face_exp/gnoll/vacant,
				"Groveling" = /datum/mob_descriptor/face_exp/gnoll/groveling,
				"Leering" = /datum/mob_descriptor/face_exp/gnoll/leering
		)
	)

	return descriptor_options_by_slot[slot]

/datum/gnoll_prefs/proc/get_selected_label(list/options, value)
	for(var/label in options)
		if(options[label] == value)
			return "[label]"
	return null

/datum/gnoll_prefs/proc/list_has_value(list/options, value)
	for(var/label in options)
		if(options[label] == value)
			return TRUE
	return FALSE

/datum/gnoll_prefs/proc/get_descriptor_value(slot)
	switch(slot)
		if("height")
			return descriptor_height
		if("body")
			return descriptor_body
		if("fur")
			return descriptor_fur
		if("voice")
			return descriptor_voice
		if("muzzle")
			return descriptor_muzzle
		if("expression")
			return descriptor_expression

	return null

/datum/gnoll_prefs/proc/set_descriptor_value(slot, value)
	var/list/options = get_descriptor_options(slot)
	if(!options || !list_has_value(options, value))
		return FALSE

	switch(slot)
		if("height")
			descriptor_height = value
		if("body")
			descriptor_body = value
		if("fur")
			descriptor_fur = value
		if("voice")
			descriptor_voice = value
		if("muzzle")
			descriptor_muzzle = value
		if("expression")
			descriptor_expression = value
		else
			return FALSE

	return TRUE

/datum/gnoll_prefs/proc/gnoll_show_ui(mob/user)
	if(!user.client)
		return

	var/list/dat = list()
	dat += "<html><head><title>Gnoll Customization</title></head><body>"
	dat += "<center><h2>Choose your form to spread terror in the name of the GORESTAR!!</h2></center><br>"

	// Name section
	dat += "<b>Current Name:</b> [gnoll_name] "
	dat += "<a href='?_src_=gnoll_prefs;action=set_name'>Set Custom Name</a> | "
	dat += "<a href='?_src_=gnoll_prefs;action=random_name'>Random Gnoll Name</a><br>"

	// Pronouns section
	var/list/pronoun_options = get_pronoun_options()
	var/pronoun_label = get_selected_label(pronoun_options, gnoll_pronouns) || "He/Him"
	dat += "<b>Pronouns:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_pronouns'>[pronoun_label]</a>"
	dat += "<br>"

	dat += "<b>Voice Color:</b> <a href='?_src_=gnoll_prefs;action=voice_color'>Change</a><br>"

	dat += "<b>Gnoll Statpack:</b> <a href='?_src_=gnoll_prefs;action=gnoll_statpack'>Change</a><br>"
	dat += "<span style='color:#b2b2b2;'>" 
	if(gnoll_statpack)
		var/stats_string = gnoll_statpack.generate_modifier_string()
		if(stats_string)
			dat += "<b>[gnoll_statpack.name]</b> <i>" + stats_string + "</i><br>"
		else
			dat += "<b>[gnoll_statpack.name]</b><br>"
		dat += "[gnoll_statpack.desc]<br>"
	else
		dat += "None Selected<br>"
	dat += "</span><br>"

	// Pelt type section
	var/list/pelt_options = get_pelt_options()
	var/pelt_label = get_selected_label(pelt_options, pelt_type) || "Firepelt"
	dat += "<b>Pelt Pattern:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_pelt'>[pelt_label]</a>"
	dat += "<br>"

	// Genitals section
	dat += "<b>Genitals:</b><br>"
	var/list/genital_options = list(
		"Penis" = "penis",
		"Vagina" = "vagina",
		"Breasts" = "breasts"
	)
	for(var/genital_label in genital_options)
		var/genital_id = genital_options[genital_label]
		var/status = genitals[genital_id] ? "Yes" : "No"
		var/toggle_action = genitals[genital_id] ? "disable" : "enable"
		dat += "&nbsp;&nbsp;[genital_label]: [status] "
		dat += "<a href='?_src_=gnoll_prefs;action=toggle_genital;genital=[genital_id];toggle=[toggle_action]'>[toggle_action == "enable" ? "Enable" : "Disable"]</a><br>"
	// dat += "<br>"

	// Height section
	var/list/height_options = get_descriptor_options("height")
	var/height_label = get_selected_label(height_options, descriptor_height) || "Moderate"
	dat += "<b>Height:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_descriptor;slot=height'>[height_label]</a>"
	dat += "<br>"

	// Body section
	var/list/body_options = get_descriptor_options("body")
	var/body_label = get_selected_label(body_options, descriptor_body) || "Muscular"
	dat += "<b>Build:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_descriptor;slot=body'>[body_label]</a>"
	dat += "<br>"

	// Fur section
	var/list/fur_options = get_descriptor_options("fur")
	var/fur_label = get_selected_label(fur_options, descriptor_fur) || "Coarse"
	dat += "<b>Coat:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_descriptor;slot=fur'>[fur_label]</a>"
	dat += "<br>"

	// Voice section
	var/list/voice_options = get_descriptor_options("voice")
	var/voice_label = get_selected_label(voice_options, descriptor_voice) || "Growly"
	dat += "<b>Voice:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_descriptor;slot=voice'>[voice_label]</a>"
	dat += "<br>"

	// Muzzle shape section
	var/list/muzzle_options = get_descriptor_options("muzzle")
	var/muzzle_label = get_selected_label(muzzle_options, descriptor_muzzle) || "Long"
	dat += "<b>Muzzle Shape:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_descriptor;slot=muzzle'>[muzzle_label]</a>"
	dat += "<br>"

	// Expression section
	var/list/expression_options = get_descriptor_options("expression")
	var/expression_label = get_selected_label(expression_options, descriptor_expression) || "Alert"
	dat += "<b>Expression:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_descriptor;slot=expression'>[expression_label]</a>"
	dat += "<br>"

	dat += "<h3>Gnoll Flavortext (Optional)</h3>"

	dat += "<b>Headshot:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=headshot'>Change</a>"
	if(headshot_link != null)
		dat += "<br><img src='[headshot_link]' width='100px' height='100px'>"

	dat += "<br><b>Flavortext: </b><a href='?_src_=gnoll_prefs;action=formathelp'>(?)</a><a href='?_src_=gnoll_prefs;action=flavortext'>Change</a>"
	dat += "<br><b>NSFW Flavortext: </b><a href='?_src_=gnoll_prefs;action=formathelp'>(?)</a><a href='?_src_=gnoll_prefs;action=nsfwflavortext'>Change</a>"
	dat += "<br><b>OOC Notes: </b><a href='?_src_=gnoll_prefs;action=formathelp'>(?)</a><a href='?_src_=gnoll_prefs;action=ooc_notes'>Change</a>"

	dat += "<br><b>Rumours & Noble Gossip:</b><a href='?_src_=gnoll_prefs;action=formathelp'>(?)</a><br><a href='?_src_=gnoll_prefs;action=rumour'>Set Rumours</a><a href='?_src_=gnoll_prefs;action=gossip'>Set Gossip</a><a href='?_src_=gnoll_prefs;action=rumour_preview'><i>Preview</i></a>"

	dat += "<br><b>ERP Preferences:</b><a href='?_src_=gnoll_prefs;action=formathelp'>(?)</a><a href='?_src_=gnoll_prefs;action=erpprefs'>Change</a>"
	dat += "<br><b>Song:</b> <a href='?_src_=gnoll_prefs;action=ooc_extra'>Change URL</a>"
	dat += "<a href='?_src_=gnoll_prefs;action=change_title'>Change Title</a>"
	dat += "<a href='?_src_=gnoll_prefs;action=change_artist'>Change Artist</a>"
	dat += "<br><b>OOC Extra Image/Video/Gif (Flavor Text):</b> <a href='?_src_=gnoll_prefs;action=ooc_extra_img'>Change</a>"
	if(ooc_extra_img_link != null)
		dat += "<br><img src='[ooc_extra_img_link]' width='100px' height='100px'>"
	dat += "<br><b>NSFW OOC Extra Image/Video/Gif (Flavor Text):</b> <a href='?_src_=gnoll_prefs;action=nsfw_ooc_extra_img'>Change</a>"
	if(nsfw_ooc_extra_img_link != null)
		dat += "<br><img src='[nsfw_ooc_extra_img_link]' width='100px' height='100px'>"
	dat += "<br><B>Image Gallery:</b> <a href='?_src_=gnoll_prefs;action=img_gallery'>Add</a>"
	dat+= "<a href='?_src_=gnoll_prefs;action=clear_gallery'>Clear Gallery</a>"
	dat += "<br><B>Nsfw Image Gallery:</b> <a href='?_src_=gnoll_prefs;action=nsfw_img_gallery'>Add</a>"
	dat+= "<a href='?_src_=gnoll_prefs;action=clear_nsfw_gallery'>Clear Nsfw Gallery</a>"
	dat += "<br><a href='?_src_=gnoll_prefs;action=ooc_preview'><b>Preview Examine</b></a>"

	dat += "<center><a href='?_src_=gnoll_prefs;action=close'>Close</a></center>"
	dat += "</body></html>"

	var/datum/browser/popup = new(user, "gnoll_prefs", "Gnoll Customization", 500, 600)
	popup.set_content(dat.Join())
	popup.open()

/datum/gnoll_prefs/proc/gnoll_process_link(mob/user, list/href_list)
	if(!user || !user.client)
		return

	var/action = href_list["action"]
	switch(action)
		if("set_name")
			var/new_name = input(user, "Enter a custom name for your gnoll:", "Gnoll Name", gnoll_name) as text|null
			if(new_name)
				gnoll_name = sanitize_name(new_name)
				ensure_gnoll_name()
				gnoll_show_ui(user)

		if("random_name")
			gnoll_name = generate_random_gnoll_name()
			gnoll_show_ui(user)

		if("choose_pronouns")
			var/list/pronoun_options = get_pronoun_options()
			var/current_pronoun = get_selected_label(pronoun_options, gnoll_pronouns)
			var/selected_pronoun = input(user, "Choose pronouns", "Gnoll Customization", current_pronoun) as null|anything in pronoun_options
			if(!selected_pronoun)
				return
			gnoll_pronouns = pronoun_options[selected_pronoun]
			gnoll_show_ui(user)

		if("choose_pelt")
			var/list/pelt_options = get_pelt_options()
			var/current_pelt = get_selected_label(pelt_options, pelt_type)
			var/selected_pelt = input(user, "Choose pelt pattern", "Gnoll Customization", current_pelt) as null|anything in pelt_options
			if(!selected_pelt)
				return
			pelt_type = pelt_options[selected_pelt]
			gnoll_show_ui(user)

		if("choose_descriptor")
			var/slot = href_list["slot"]
			var/list/descriptor_options = get_descriptor_options(slot)
			if(!descriptor_options)
				return
			var/current_descriptor = get_selected_label(descriptor_options, get_descriptor_value(slot))
			var/selected_descriptor = input(user, "Describe my [slot]", "Gnoll Customization", current_descriptor) as null|anything in descriptor_options
			if(!selected_descriptor)
				return
			if(set_descriptor_value(slot, descriptor_options[selected_descriptor]))
				gnoll_show_ui(user)

		if("set_pronouns")
			var/new_pronouns = href_list["pronouns"]
			if(new_pronouns in list(HE_HIM, SHE_HER, THEY_THEM, IT_ITS))
				gnoll_pronouns = new_pronouns
				gnoll_show_ui(user)

		if("set_pelt")
			var/new_pelt = href_list["pelt"]
			var/list/valid_pelts = list("firepelt", "rotpelt", "whitepelt", "bloodpelt", "nightpelt", "darkpelt")
			if(new_pelt in valid_pelts)
				pelt_type = new_pelt
				gnoll_show_ui(user)

		if("toggle_genital")
			var/genital = href_list["genital"]
			var/toggle = href_list["toggle"]
			if(genital in genitals)
				genitals[genital] = (toggle == "enable")
				gnoll_show_ui(user)

		if("set_descriptor")
			var/slot = href_list["slot"]
			var/new_type = text2path(href_list["type"])
			if(!new_type)
				return
			switch(slot)
				if("height")
					var/list/valid_height = list(
						/datum/mob_descriptor/height/moderate,
						/datum/mob_descriptor/height/middling,
						/datum/mob_descriptor/height/short,
						/datum/mob_descriptor/height/tall,
						/datum/mob_descriptor/height/towering,
						/datum/mob_descriptor/height/giant,
						/datum/mob_descriptor/height/tiny
					)
					if(new_type in valid_height)
						descriptor_height = new_type
				if("body")
					var/list/valid_body = list(
						/datum/mob_descriptor/body/average,
						/datum/mob_descriptor/body/athletic,
						/datum/mob_descriptor/body/muscular,
						/datum/mob_descriptor/body/herculean,
						/datum/mob_descriptor/body/toned,
						/datum/mob_descriptor/body/heavy,
						/datum/mob_descriptor/body/lean,
						/datum/mob_descriptor/body/burly,
						/datum/mob_descriptor/body/gaunt,
						/datum/mob_descriptor/body/lanky
					)
					if(new_type in valid_body)
						descriptor_body = new_type
				if("fur")
					var/list/valid_fur = list(
						/datum/mob_descriptor/fur/plain,
						/datum/mob_descriptor/fur/short,
						/datum/mob_descriptor/fur/coarse,
						/datum/mob_descriptor/fur/bristly,
						/datum/mob_descriptor/fur/fluffy,
						/datum/mob_descriptor/fur/shaggy,
						/datum/mob_descriptor/fur/silky,
						/datum/mob_descriptor/fur/lank,
						/datum/mob_descriptor/fur/mangy,
						/datum/mob_descriptor/fur/velvety,
						/datum/mob_descriptor/fur/dense,
						/datum/mob_descriptor/fur/matted
					)
					if(new_type in valid_fur)
						descriptor_fur = new_type
				if("voice")
					var/list/valid_voice = list(
						/datum/mob_descriptor/voice/growly,
						/datum/mob_descriptor/voice/deep,
						/datum/mob_descriptor/voice/booming,
						/datum/mob_descriptor/voice/gravelly,
						/datum/mob_descriptor/voice/commanding,
						/datum/mob_descriptor/voice/monotone,
						/datum/mob_descriptor/voice/ordinary,
						/datum/mob_descriptor/voice/soft,
						/datum/mob_descriptor/voice/grave,
						/datum/mob_descriptor/voice/venomous,
						/datum/mob_descriptor/voice/dispassionate,
						/datum/mob_descriptor/voice/whiny,
						/datum/mob_descriptor/voice/drawling,
						/datum/mob_descriptor/voice/shrill,
						/datum/mob_descriptor/voice/stilted
					)
					if(new_type in valid_voice)
						descriptor_voice = new_type
				if("muzzle")
					var/list/valid_muzzle = list(
						/datum/mob_descriptor/face/gnoll/long_muzzle,
						/datum/mob_descriptor/face/gnoll/short_muzzle,
						/datum/mob_descriptor/face/gnoll/broad_muzzle,
						/datum/mob_descriptor/face/gnoll/narrow_muzzle,
						/datum/mob_descriptor/face/gnoll/scarred_muzzle,
						/datum/mob_descriptor/face/gnoll/sharp_muzzle,
						/datum/mob_descriptor/face/gnoll/worn_muzzle,
						/datum/mob_descriptor/face/gnoll/disfigured_muzzle
					)
					if(new_type in valid_muzzle)
						descriptor_muzzle = new_type
				if("expression")
					var/list/valid_expression = list(
						/datum/mob_descriptor/face_exp/gnoll/alert,
						/datum/mob_descriptor/face_exp/gnoll/snarling,
						/datum/mob_descriptor/face_exp/gnoll/predatory,
						/datum/mob_descriptor/face_exp/gnoll/hollow,
						/datum/mob_descriptor/face_exp/gnoll/fierce,
						/datum/mob_descriptor/face_exp/gnoll/vacant,
						/datum/mob_descriptor/face_exp/gnoll/groveling,
						/datum/mob_descriptor/face_exp/gnoll/leering
					)
					if(new_type in valid_expression)
						descriptor_expression = new_type
			gnoll_show_ui(user)
		if("headshot")
			to_chat(user, "<span class='notice'>Please use a relatively SFW image of the head and shoulder area to maintain immersion level. Lastly, ["<span class='bold'>do not use a real life photo or use any image that is less than serious.</span>"]</span>")
			to_chat(user, "<span class='notice'>If the photo doesn't show up properly in-game, ensure that it's a direct image link that opens properly in a browser.</span>")
			to_chat(user, "<span class='notice'>Keep in mind that the photo will be downsized to 325x325 pixels, so the more square the photo, the better it will look.</span>")
			var/new_headshot_link = tgui_input_text(user, "Input the headshot link (https, hosts: gyazo, lensdump, imgbox, catbox):", "Headshot", headshot_link,  encode = FALSE)
			if(new_headshot_link == null)
				return
			if(new_headshot_link == "")
				headshot_link = null
				gnoll_show_ui(user)
				return
			if(!valid_headshot_link(user, new_headshot_link))
				headshot_link = null
				gnoll_show_ui(user)
				return
			headshot_link = new_headshot_link
			to_chat(user, span_notice("Successfully updated gnoll headshot picture"))
			log_game("[user] has set their gnoll headshot image to '[headshot_link]'.")
			gnoll_show_ui(user)
		if("formathelp")
			var/list/dat = list()
			dat +="You can use backslash (\\) to escape special characters.<br>"
			dat += "<br>"
			dat += "# text : Defines a header.<br>"
			dat += "|text| : Centers the text.<br>"
			dat += "**text** : Makes the text <b>bold</b>.<br>"
			dat += "*text* : Makes the text <i>italic</i>.<br>"
			dat += "^text^ : Increases the <font size = \"4\">size</font> of the text.<br>"
			dat += "((text)) : Decreases the <font size = \"1\">size</font> of the text.<br>"
			dat += "* item : An unordered list item.<br>"
			dat += "--- : Adds a horizontal rule.<br>"
			dat += "-=FFFFFFtext=- : Adds a specific <font color = '#FFFFFF'>colour</font> to text.<br><br>"
			var/datum/browser/popup = new(user, "Formatting Help", nwidth = 400, nheight = 350)
			popup.set_content(dat.Join())
			popup.open(FALSE)
		if("flavortext")
			to_chat(user, "<span class='notice'>["<span class='bold'>Flavortext should not include nonphysical nonsensory attributes such as backstory or the character's internal thoughts.</span>"]</span>")
			var/new_flavortext = tgui_input_text(user, "Input your gnoll character description:", "Flavortext", flavortext, multiline = TRUE,  encode = FALSE, bigmodal = TRUE)
			if(new_flavortext == null)
				return
			if(new_flavortext == "")
				flavortext = null
				gnoll_show_ui(user)
				return
			flavortext = new_flavortext
			to_chat(user, "<span class='notice'>Successfully updated gnoll flavortext</span>")
			log_game("[user] has set their gnoll flavortext'.")
		if("ooc_notes")
			to_chat(user, "<span class='notice'>["<span class='bold'>OOC notes should be used for roleplay hooks and general information about your character.</span>"]</span>")
			var/new_ooc_notes = tgui_input_text(user, "Input your OOC preferences:", "OOC notes", ooc_notes, multiline = TRUE,  encode = FALSE, bigmodal = TRUE)
			if(new_ooc_notes == null)
				return
			if(new_ooc_notes == "")
				ooc_notes = null
				gnoll_show_ui(user)
				return
			ooc_notes = new_ooc_notes
			to_chat(user, "<span class='notice'>Successfully updated gnoll OOC notes.</span>")
			log_game("[user] has set their gnoll OOC notes'.")
		if("rumour")
			to_chat(user, span_notice("Rumours are things others might know, or think they know about you, they don't necessarily have to be precise, or even true. But remember that they can provide a hint to another player on how to interact with, or even think about your character.\n<b>Avoid explicit bodily descriptions, though rumors like \"sleeps around a lot\" are fine.</b>"))
			var/new_rumour = tgui_input_text(user, "Input rumours about your character: (400 Character Limit)", "Rumours", rumour, multiline = TRUE, encode = FALSE, bigmodal = TRUE)
			if(new_rumour == null)
				return
			if(new_rumour == "")
				rumour = null
				gnoll_show_ui(user)
				return
			if(length(new_rumour) > 400)
				to_chat(user, span_warning("Rumours cannot exceed 400 characters."))
				gnoll_show_ui(user)
				return
			rumour = new_rumour
			to_chat(user, span_notice("Successfully updated gnoll rumours"))
			log_game("[user] has set their gnoll's rumour'.")
		if("gossip")
			to_chat(user, span_notice("Gossip is rumours spread around, and known only in Noble circles, only other well-born individuals are aware of it. Gossip, similarly to standard rumours does not need to be precise or true, but remember that it can provide hints and avenues for other Nobles to interact with, and judge your Character.\n<b>Avoid explicit bodily descriptions, though rumors like \"sleeps around a lot\" are fine.</b>"))
			var/new_gossip = tgui_input_text(user, "Input noble gossip about your gnoll character: (400 Character Limit)", "Noble Gossip", noble_gossip, multiline = TRUE, encode = FALSE, bigmodal = TRUE)
			if(new_gossip == null)
				return
			if(new_gossip == "")
				noble_gossip = null
				gnoll_show_ui(user)
				return
			if(length(new_gossip) > 400)
				to_chat(user, span_notice("Gnoble gossip cannot exceed 400 characters."))
				gnoll_show_ui(user)
				return
			noble_gossip = new_gossip
			to_chat(user, span_notice("Successfully updated gnoll noble gossip"))
			log_game("[user] has set their gnoll's noble gossip'.")

		if("nsfwflavortext")
			to_chat(user, "<span class='notice'>["<span class='bold'>NSFW Flavortext can be used for setting things like body descriptions and other physical details that may be conisdered explicit.</span>"]</span>")
			to_chat(user, "<font color = '#d6d6d6'>Leave blank to clear.</font>")
			var/new_nsfwflavortext = tgui_input_text(user, "Input your gnoll character description:", "NSFW Flavortext", nsfwflavortext, multiline = TRUE,  encode = FALSE, bigmodal = TRUE)
			if(new_nsfwflavortext == null)
				return
			if(new_nsfwflavortext == "")
				new_nsfwflavortext = null
				nsfwflavortext = null
				to_chat(user, "<span class='notice'>Successfully deleted gnoll NSFW Flavor Text.</span>")
				gnoll_show_ui(user)
				return
			nsfwflavortext = new_nsfwflavortext
			to_chat(user, "<span class='notice'>Successfully updated gnoll NSFW flavortext</span>")
			log_game("[user] has set their gnoll NSFW flavortext'.")
		if("erpprefs")
			to_chat(user, "<span class='notice'>["<span class='bold'>Erotic Roleplay preferences. If you put 'anything goes' or 'no limits' here, do not be surprised if people take you up on it.</span>"]</span>")
			to_chat(user, "<font color = '#d6d6d6'>Leave blank to clear.</font>")
			var/new_erpprefs = tgui_input_text(user, "Input your preferences:", "ERP Preferences", erpprefs, multiline = TRUE,  encode = FALSE, bigmodal = TRUE)
			if(new_erpprefs == null)
				return
			if(new_erpprefs == "")
				new_erpprefs = null
				erpprefs = null
				to_chat(user, "<span class='notice'>Successfully deleted ERP preferences.</span>")
				gnoll_show_ui(user)
				return
			erpprefs = new_erpprefs
			to_chat(user, "<span class='notice'>Successfully updated ERP Preferences.</span>")
			log_game("[user] has set their ERP preferences'.")

		if("img_gallery")

			if(img_gallery.len >= 3)
				to_chat(user, "You already have three images in your gallery!")
				return

			to_chat(user, "<span class='notice'>Please use an image ["<span class='bold'>of your character</span>"] to maintain immersion level. Lastly, ["<span class='bold'>do not use a real life photo or use any image that is less than serious.</span>"]</span>")
			to_chat(user, "<span class='notice'>If the photo doesn't show up properly in-game, ensure that it's a direct image link that opens properly in a browser.</span>")
			to_chat(user, "<span class='notice'>Keep in mind that all three images are displayed next to eachother and justified to fill a horizontal rectangle. As such, vertical images work best.</span>")
			to_chat(user, "<span class='notice'>You can only have a maximum of ["<span class='bold'>THREE IMAGES</span>"] in your gallery at a time.</span>")

			var/new_galleryimg = tgui_input_text(user, "Input the image link (https, hosts: gyazo, lensdump, imgbox, catbox):", "Gallery Image",  encode = FALSE)

			if(new_galleryimg == null)
				return
			if(new_galleryimg == "")
				new_galleryimg = null
				gnoll_show_ui(user)
				return
			if(!valid_headshot_link(user, new_galleryimg))
				to_chat(user, "<span class='notice'>Invalid image link. Make sure it's a direct link from a valid host (gyazo, lensdump, imgbox, catbox).</span>")
				new_galleryimg = null
				gnoll_show_ui(user)
				return
			img_gallery += new_galleryimg
			to_chat(user, "<span class='notice'>Successfully added image to gnoll gallery.</span>")
			log_game("[user] has added an image to their gnoll gallery: '[new_galleryimg]'.")

		if("nsfw_img_gallery")

			if(nsfw_img_gallery.len >= 3)
				to_chat(user, "You already have three images in your gallery!")
				return

			to_chat(user, "<span class='notice'>Please use an image ["<span class='bold'>of your character</span>"] to maintain immersion level. Lastly, ["<span class='bold'>do not use a real life photo or use any image that is less than serious.</span>"]</span>")
			to_chat(user, "<span class='notice'>If the photo doesn't show up properly in-game, ensure that it's a direct image link that opens properly in a browser.</span>")
			to_chat(user, "<span class='notice'>Keep in mind that all three images are displayed next to eachother and justified to fill a horizontal rectangle. As such, vertical images work best.</span>")
			to_chat(user, "<span class='notice'>You can only have a maximum of ["<span class='bold'>THREE IMAGES</span>"] in your gallery at a time.</span>")

			var/new_galleryimg = tgui_input_text(user, "Input the image link (https, hosts: gyazo, lensdump, imgbox, catbox):", "Gallery Image",  encode = FALSE)

			if(new_galleryimg == null)
				return
			if(new_galleryimg == "")
				new_galleryimg = null
				gnoll_show_ui(user)
				return
			if(!valid_headshot_link(user, new_galleryimg))
				to_chat(user, "<span class='notice'>Invalid image link. Make sure it's a direct link from a valid host (gyazo, lensdump, imgbox, catbox).</span>")
				new_galleryimg = null
				gnoll_show_ui(user)
				return
			nsfw_img_gallery += new_galleryimg
			to_chat(user, "<span class='notice'>Successfully added gnoll image to nsfw gallery.</span>")
			log_game("[user] has added an image to their gnoll nsfw gallery: '[new_galleryimg]'.")

		if("clear_gallery")
			if(!img_gallery.len)
				to_chat(user, "You don't have any images in your gnoll gallery to clear!")
				return
			var/dachoice = tgui_alert(user, "Do you really want to clear your gnoll image gallery?", "Clear Gallery", list("Yae", "Nae"))
			if(dachoice == "Nae")
				gnoll_show_ui(user)
				return
			img_gallery = list()
			to_chat(user, "<span class='notice'>Successfully cleared gnoll image gallery.</span>")
			log_game("[user] has cleared their gnoll image gallery.")

		if("clear_nsfw_gallery")
			if(!nsfw_img_gallery.len)
				to_chat(user, "You don't have any images in your gnoll nsfw gallery to clear!")
				return
			var/dachoice = tgui_alert(user, "Do you really want to clear your gnoll nsfw image gallery?", "Clear nsfw Gallery", list("Yae", "Nae"))
			if(dachoice == "Nae")
				gnoll_show_ui(user)
				return
			nsfw_img_gallery = list()
			to_chat(user, "<span class='notice'>Successfully cleared gnoll nsfw image gallery.</span>")
			log_game("[user] has cleared their gnoll nsfw image gallery.")

		if("ooc_preview")
			var/datum/examine_panel/preview_examine_panel = new(user)
			preview_examine_panel.pref = user.client?.prefs
			preview_examine_panel.holder = user
			preview_examine_panel.viewing = user
			preview_examine_panel.previewing = "gnoll"
			preview_examine_panel.ui_interact(user)

		if("rumour_preview")
			var/msg = ""
			if(rumour && length(rumour))
				var/rumour_display = rumour
				rumour_display = html_encode(rumour_display)
				rumour_display = parsemarkdown_basic(rumour_display, hyperlink = TRUE)
				msg += "<b>You recall what you heard around Town about [gnoll_name]...</b><br>[rumour_display]"
			if(length(noble_gossip))
				if(msg)
					msg += "<br><br>"
				var/gossip_display = noble_gossip
				gossip_display = html_encode(gossip_display)
				gossip_display = parsemarkdown_basic(gossip_display, hyperlink = TRUE)
				msg += "<b>You recall what the other Blue-bloods hushed about [gnoll_name]...</b><br>[gossip_display]"
			if(msg)
				to_chat(user, "<span class='info'>[msg]</span>")

		if("ooc_extra")
			to_chat(user, "<span class='notice'>Add a link from a suitable host (catbox, etc) to an mp3 to embed in your flavor text.</span>")
			to_chat(user, "<span class='notice'>If the song doesn't  play properly, ensure that it's a direct link that opens properly in a browser.</span>")
			to_chat(user, "<font color = '#d6d6d6'>Leave blank to clear your current song.</font>")
			to_chat(user, "<font color ='red'>Abuse of this will get you banned.</font>")
			var/new_extra_link = tgui_input_text(user, "Input the accessory link (https, hosts: catbox):", "Song URL", ooc_extra, encode = FALSE)
			if(new_extra_link == null)
				return
			if(new_extra_link == "")
				new_extra_link = null
				ooc_extra = null
				to_chat(user, "<span class='notice'>Successfully deleted gnoll OOC Extra.</span>")
				gnoll_show_ui(user)
				return
			var/static/list/valid_extensions = list("mp3")
			if(!valid_headshot_link(user, new_extra_link, FALSE, valid_extensions))
				new_extra_link = null
				gnoll_show_ui(user)
				return

			var/list/value_split = splittext(new_extra_link, ".")

			// extension will always be the last entry
			var/extension = value_split[length(value_split)]
			if((extension in valid_extensions))
				ooc_extra = new_extra_link
				to_chat(user, "<span class='notice'>Successfully updated gnoll Song URL.</span>")
				log_game("[user] has set their gnoll Song URL to '[ooc_extra]'.")

		if("change_artist")
			var/new_artist = tgui_input_text(user, "Input your song's artist:", "Song Artist", song_artist,  encode = FALSE)
			if(new_artist == null)
				return
			if(new_artist == "")
				gnoll_show_ui(user)
				return
			song_artist = new_artist
			to_chat(user, "<span class='notice'>Successfully updated gnoll song artist.</span>")
			log_game("[user] has set their gnoll song artist.")

		if("change_title")
			var/new_title = tgui_input_text(user, "Input your song's title:", "Song title", song_title,  encode = FALSE)
			if(new_title== null)
				return
			if(new_title == "")
				gnoll_show_ui(user)
				return
			song_title = new_title
			to_chat(user, "<span class='notice'>Successfully updated gnoll song title.</span>")
			log_game("[user] has set their gnoll song title.")

		if("ooc_extra_img")
			to_chat(user, "<span class='notice'>Add a link to images/videos (jpg, png, gif, mp4) that will be displayed in your Flavor Text.</span>")
			to_chat(user, "<span class='notice'>Images/videos will be constrained by width but have limitless height. Suitable hosts: catbox, discord, gyazo, lensdump, imgbox.</span>")
			to_chat(user, "<font color='#d6d6d6'>Leave a single space to delete it.</font>")
			to_chat(user, "<font color='red'>Abuse of this will get you banned.</font>")
			var/link = tgui_input_text(user, "Input the image/video link (https):", "OOC Extra Image", ooc_extra_img_link, encode = FALSE)
			if(link == null)
				return
			if(link == "")
				link = null
				var/choice = tgui_alert(user, "Do you really want to clear your gnoll OOC Extra Image/Video/Gif?", "Clear OOC Extra Image/Video/Gif", list("Yae", "Nae"))
				if(choice == "Nae")
					gnoll_show_ui(user)
					return
				ooc_extra_img = null
				ooc_extra_img_link = null
				to_chat(user, "<span class='notice'>Successfully deleted gnoll OOC Extra Image.</span>")
				gnoll_show_ui(user)
				return
			var/static/list/valid_ext = list("jpg", "jpeg", "png", "gif", "mp4")
			if(!valid_headshot_link(user, link, FALSE, valid_ext))
				link = null
				gnoll_show_ui(user)
				return
			ooc_extra_img_link = link
			var/ext = LOWER_TEXT(splittext(link, ".")[length(splittext(link, "."))])
			var/info
			switch(ext)
				if("jpg", "jpeg", "png", "gif")
					ooc_extra_img = "<div align='center'><br><img src='[link]' style='max-width: 100%;'/></div>"
					info = "an image."
				if("mp4")
					ooc_extra_img = "<div align='center'><br><video style='max-width: 100%;' controls><source src='[link]' type='video/mp4'></video></div>"
					info = "a video."
			to_chat(user, "<span class='notice'>Successfully updated gnoll OOC Extra Image with [info]</span>")
			log_game("[user] has set their gnoll OOC Extra Image to '[link]'.")

		if("nsfw_ooc_extra_img")
			to_chat(user, "<span class='notice'>Add a link to NSFW images/videos (jpg, png, gif, mp4) that will be displayed in your NSFW Flavor Text.</span>")
			to_chat(user, "<span class='notice'>Images/videos will be constrained by width but have limitless height. Suitable hosts: catbox, discord, gyazo, lensdump, imgbox.</span>")
			to_chat(user, "<font color='#d6d6d6'>Leave a single space to delete it.</font>")
			to_chat(user, "<font color='red'>Abuse of this will get you banned.</font>")
			var/link = tgui_input_text(user, "Input the image/video link (https):", "NSFW OOC Extra Image", nsfw_ooc_extra_img_link, encode = FALSE)
			if(link == null)
				return
			if(link == "")
				link = null
				var/choice = tgui_alert(user, "Do you really want to clear your gnoll NSFW OOC Extra Image/Video/Gif?", "Clear NSFW OOC Extra Image/Video/Gif", list("Yae", "Nae"))
				if(choice == "Nae")
					gnoll_show_ui(user)
					return
				nsfw_ooc_extra_img = null
				nsfw_ooc_extra_img_link = null
				to_chat(user, "<span class='notice'>Successfully deleted gnoll NSFW OOC Extra Image.</span>")
				gnoll_show_ui(user)
				return
			var/static/list/valid_ext = list("jpg", "jpeg", "png", "gif", "mp4")
			if(!valid_headshot_link(user, link, FALSE, valid_ext))
				link = null
				gnoll_show_ui(user)
				return
			nsfw_ooc_extra_img_link = link
			var/ext = LOWER_TEXT(splittext(link, ".")[length(splittext(link, "."))])
			var/info
			switch(ext)
				if("jpg", "jpeg", "png", "gif")
					nsfw_ooc_extra_img = "<div align='center'><br><img src='[link]' style='max-width: 100%;'/></div>"
					info = "an image."
				if("mp4")
					nsfw_ooc_extra_img = "<div align='center'><br><video style='max-width: 100%;' controls><source src='[link]' type='video/mp4'></video></div>"
					info = "a video."
			to_chat(user, "<span class='notice'>Successfully updated gnoll NSFW OOC Extra Image with [info]</span>")
			log_game("[user] has set their gnoll NSFW OOC Extra Image to '[link]'.")

		if("gnoll_statpack")
			// Build statpack list
			var/list/statpacks_available = list()
			for (var/path as anything in GLOB.statpacks - /datum/statpack/wildcard/virtuous) // gnolls can't have virtues
				var/datum/statpack/SP = GLOB.statpacks[path]
				if (!SP.name)
					continue
				// Add stats to the name in the selection list
				var/display_name = SP.name
				var/stats = SP.generate_modifier_string()
				if(stats)
					display_name = "[SP.name] [stats]"
				statpacks_available[display_name] = SP
			
			statpacks_available = sort_list(statpacks_available)
			var/choice = tgui_input_list(usr, "Choose your gnoll statpack:", "Statpack Selection", statpacks_available)
			
			if(choice)
				var/datum/statpack/selected = statpacks_available[choice]
				gnoll_statpack = selected
				to_chat(usr, span_notice("Selected [choice] gnoll statpack."))
				to_chat(usr, "<span class='info'>[selected.description_string()]</span>")
			gnoll_show_ui(user)

		if("voice_color")
			var/new_voice = input(user, "Choose your gnoll's voice color:", "Character Preference","#"+gnoll_voice_color) as color|null
			if(new_voice)
				if(color_hex2num(new_voice) < 230)
					to_chat(user, "<font color='red'>This voice color is too dark for mortals.</font>")
					return
				gnoll_voice_color = sanitize_hexcolor(new_voice)
			gnoll_show_ui(user)

		if("close")
			user << browse(null, "window=gnoll_prefs")

	return TRUE

/datum/gnoll_prefs/proc/load_gnoll_prefs(savefile/S)
	if(istype(S))
		S["gnoll_name"]						>> gnoll_name
		S["gnoll_pronouns"]					>> gnoll_pronouns
		S["gnoll_pelt_type"]				>> pelt_type
		if(!pelt_type)
			pelt_type = "firepelt"
		S["gnoll_genitals_penis"]			>> genitals["penis"]
		S["gnoll_genitals_vagina"]			>> genitals["vagina"]
		S["gnoll_genitals_breasts"]			>> genitals["breasts"]
		S["gnoll_descriptor_height"]		>> descriptor_height
		if(!ispath(descriptor_height, /datum/mob_descriptor/height))
			descriptor_height = /datum/mob_descriptor/height/moderate
		S["gnoll_descriptor_body"]			>> descriptor_body
		if(!ispath(descriptor_body, /datum/mob_descriptor/body))
			descriptor_body = /datum/mob_descriptor/body/muscular
		S["gnoll_descriptor_fur"]			>> descriptor_fur
		if(!ispath(descriptor_fur, /datum/mob_descriptor/fur))
			descriptor_fur = /datum/mob_descriptor/fur/coarse
		S["gnoll_descriptor_voice"]			>> descriptor_voice
		if(!ispath(descriptor_voice, /datum/mob_descriptor/voice))
			descriptor_voice = /datum/mob_descriptor/voice/growly
		S["gnoll_descriptor_muzzle"]		>> descriptor_muzzle
		if(!ispath(descriptor_muzzle, /datum/mob_descriptor/face/gnoll))
			descriptor_muzzle = /datum/mob_descriptor/face/gnoll/long_muzzle
		S["gnoll_descriptor_expression"]	>> descriptor_expression
		if(!ispath(descriptor_expression, /datum/mob_descriptor/face_exp/gnoll))
			descriptor_expression = /datum/mob_descriptor/face_exp/gnoll/alert

	load_gnoll_statpack(S)
	
	S["gnoll_voice_color"]			>> gnoll_voice_color
	// Workaround for the voice color always being initially set to 000000 for some weird save reason
	if(color_hex2num(sanitize_hexcolor(gnoll_voice_color)) < 230)
		gnoll_voice_color = "a0a0a0"

	S["gnoll_headshot_link"]	>> headshot_link
	if(!valid_headshot_link(null, headshot_link, TRUE))
		headshot_link = null

	S["gnoll_flavortext"]			>> flavortext
	S["gnoll_ooc_notes"]			>> ooc_notes
	S["gnoll_ooc_extra"]			>> ooc_extra
	S["gnoll_ooc_extra_img"]		>> ooc_extra_img
	S["gnoll_ooc_extra_img_link"]	>> ooc_extra_img_link
	if(!valid_headshot_link(null, ooc_extra_img_link, FALSE, list("jpg", "jpeg", "png", "gif", "mp4")))
		ooc_extra_img = null
		ooc_extra_img_link = null

	S["gnoll_song_artist"] 			>> song_artist
	S["gnoll_song_title"] 			>> song_title
	S["gnoll_rumour"]				>> rumour
	S["gnoll_noble_gossip"]			>> noble_gossip
	S["gnoll_nsfwflavortext"]		>> nsfwflavortext
	S["gnoll_nsfw_ooc_extra_img"]		>> nsfw_ooc_extra_img
	S["gnoll_nsfw_ooc_extra_img_link"]	>> nsfw_ooc_extra_img_link
	if(!valid_headshot_link(null, nsfw_ooc_extra_img_link, FALSE, list("jpg", "jpeg", "png", "gif", "mp4")))
		nsfw_ooc_extra_img = null
		nsfw_ooc_extra_img_link = null
	S["gnoll_erpprefs"]			>> erpprefs
	S["gnoll_img_gallery"]	>> img_gallery
	img_gallery = SANITIZE_LIST(img_gallery)
	S["gnoll_nsfw_img_gallery"]	>> nsfw_img_gallery
	nsfw_img_gallery = SANITIZE_LIST(nsfw_img_gallery)

	return TRUE

// To be called by preferences savefile code ONLY
/datum/gnoll_prefs/proc/save_gnoll_prefs(savefile/S)
	if(istype(S))
		WRITE_FILE(S["gnoll_name"] , gnoll_name)
		WRITE_FILE(S["gnoll_pronouns"] , gnoll_pronouns)
		WRITE_FILE(S["gnoll_pelt_type"] , pelt_type)
		WRITE_FILE(S["gnoll_genitals_penis"] , genitals["penis"])
		WRITE_FILE(S["gnoll_genitals_vagina"] , genitals["vagina"])
		WRITE_FILE(S["gnoll_genitals_breasts"] , genitals["breasts"])
		WRITE_FILE(S["gnoll_descriptor_height"] , descriptor_height)
		WRITE_FILE(S["gnoll_descriptor_body"] , descriptor_body)
		WRITE_FILE(S["gnoll_descriptor_fur"] , descriptor_fur)
		WRITE_FILE(S["gnoll_descriptor_voice"] , descriptor_voice)
		WRITE_FILE(S["gnoll_descriptor_muzzle"] , descriptor_muzzle)
		WRITE_FILE(S["gnoll_descriptor_expression"] , descriptor_expression)

		WRITE_FILE(S["gnoll_voice_color"] , gnoll_voice_color) 
		WRITE_FILE(S["gnoll_statpack"] , preferences_typepath_or_null(gnoll_statpack))

		WRITE_FILE(S["gnoll_headshot_link"] , headshot_link)
		WRITE_FILE(S["gnoll_flavortext"] , html_decode(flavortext))
		WRITE_FILE(S["gnoll_ooc_notes"] , html_decode(ooc_notes))
		WRITE_FILE(S["gnoll_ooc_extra"] ,	ooc_extra)
		WRITE_FILE(S["gnoll_ooc_extra_img"] , ooc_extra_img)
		WRITE_FILE(S["gnoll_ooc_extra_img_link"] , ooc_extra_img_link)
		WRITE_FILE(S["gnoll_song_artist"] , song_artist)
		WRITE_FILE(S["gnoll_song_title"] , song_title)		
		WRITE_FILE(S["gnoll_rumour"] , html_decode(rumour))
		WRITE_FILE(S["gnoll_noble_gossip"] , html_decode(noble_gossip))
		WRITE_FILE(S["gnoll_nsfwflavortext"] , html_decode(nsfwflavortext))
		WRITE_FILE(S["gnoll_nsfw_ooc_extra_img"] , nsfw_ooc_extra_img)
		WRITE_FILE(S["gnoll_nsfw_ooc_extra_img_link"] , nsfw_ooc_extra_img_link)
		WRITE_FILE(S["gnoll_erpprefs"] , html_decode(erpprefs))
		WRITE_FILE(S["gnoll_img_gallery"] , img_gallery)
		WRITE_FILE(S["gnoll_nsfw_img_gallery"] , nsfw_img_gallery)
	
	return TRUE
