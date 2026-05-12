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
	dat += "<a href='?_src_=gnoll_prefs;action=random_name'>Random Gnoll Name</a><br><br>"

	// Pronouns section
	var/list/pronoun_options = get_pronoun_options()
	var/pronoun_label = get_selected_label(pronoun_options, gnoll_pronouns) || "He/Him"
	dat += "<b>Pronouns:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_pronouns'>[pronoun_label]</a>"
	dat += "<br><br>"

	// Pelt type section
	var/list/pelt_options = get_pelt_options()
	var/pelt_label = get_selected_label(pelt_options, pelt_type) || "Firepelt"
	dat += "<b>Pelt Pattern:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_pelt'>[pelt_label]</a>"
	dat += "<br><br>"

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
	dat += "<br>"

	// Height section
	var/list/height_options = get_descriptor_options("height")
	var/height_label = get_selected_label(height_options, descriptor_height) || "Moderate"
	dat += "<b>Height:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_descriptor;slot=height'>[height_label]</a>"
	dat += "<br><br>"

	// Body section
	var/list/body_options = get_descriptor_options("body")
	var/body_label = get_selected_label(body_options, descriptor_body) || "Muscular"
	dat += "<b>Build:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_descriptor;slot=body'>[body_label]</a>"
	dat += "<br><br>"

	// Fur section
	var/list/fur_options = get_descriptor_options("fur")
	var/fur_label = get_selected_label(fur_options, descriptor_fur) || "Coarse"
	dat += "<b>Coat:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_descriptor;slot=fur'>[fur_label]</a>"
	dat += "<br><br>"

	// Voice section
	var/list/voice_options = get_descriptor_options("voice")
	var/voice_label = get_selected_label(voice_options, descriptor_voice) || "Growly"
	dat += "<b>Voice:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_descriptor;slot=voice'>[voice_label]</a>"
	dat += "<br><br>"

	// Muzzle shape section
	var/list/muzzle_options = get_descriptor_options("muzzle")
	var/muzzle_label = get_selected_label(muzzle_options, descriptor_muzzle) || "Long"
	dat += "<b>Muzzle Shape:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_descriptor;slot=muzzle'>[muzzle_label]</a>"
	dat += "<br><br>"

	// Expression section
	var/list/expression_options = get_descriptor_options("expression")
	var/expression_label = get_selected_label(expression_options, descriptor_expression) || "Alert"
	dat += "<b>Expression:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_descriptor;slot=expression'>[expression_label]</a>"
	dat += "<br><br>"

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

		if("close")
			user << browse(null, "window=gnoll_prefs")

	return TRUE
