/datum/customizer/organ/wings
	abstract_type = /datum/customizer/organ/wings
	name = "Wings"
	var/wings_color = "#FFFFFF"
	var/natural_gradient = /datum/hair_gradient/none
	var/natural_color = "#FFFFFF"
	var/dye_gradient = /datum/hair_gradient/none
	var/dye_color = "#FFFFFF"

/datum/customizer_choice/organ/wings
	abstract_type = /datum/customizer_choice/organ/wings
	name = "Wings"
	organ_type = /obj/item/organ/wings
	organ_slot = ORGAN_SLOT_WINGS
	organ_dna_type = /datum/organ_dna/wings
	customizer_entry_type = /datum/customizer_entry/organ/wings
	allows_accessory_color_customization = FALSE //Customized through wing color
	var/allows_natural_gradient = TRUE
	var/allows_dye_gradient = TRUE

/datum/customizer_entry/organ/wings
	var/wings_color = "#FFFFFF"
	var/natural_gradient = /datum/hair_gradient/none
	var/natural_color = "#FFFFFF"
	var/dye_gradient = /datum/hair_gradient/none
	var/dye_color = "#FFFFFF"

/datum/customizer_choice/organ/wings/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	..()
	var/datum/customizer/organ/wings/wings_entry = entry
	wings_entry.wings_color = sanitize_hexcolor(wings_entry.wings_color, 6, TRUE, initial(wings_entry.wings_color))
	wings_entry.natural_color = sanitize_hexcolor(wings_entry.natural_color, 6, TRUE, initial(wings_entry.natural_color))
	wings_entry.dye_color = sanitize_hexcolor(wings_entry.dye_color, 6, TRUE, initial(wings_entry.dye_color))

/datum/customizer_choice/organ/wings/imprint_organ_dna(datum/organ_dna/organ_dna, datum/customizer_entry/entry, datum/preferences/prefs)
	..()
	var/datum/organ_dna/wings/wings_dna = organ_dna
	var/datum/customizer_entry/organ/wings/wings_entry = entry

	// Check if there's > 1 color key first since that is handled separately
	var/datum/sprite_accessory/wings/wing_accessory = SPRITE_ACCESSORY(entry.accessory_type)
	if(wing_accessory.color_keys > 1)
		wings_dna.wings_color = wings_entry.accessory_colors
		return

	wings_dna.wings_color = wings_entry.wings_color
	wings_dna.wing_natural_gradient = wings_entry.natural_gradient
	wings_dna.wing_natural_color = wings_entry.natural_color
	wings_dna.wing_dye_gradient = wings_entry.dye_gradient
	wings_dna.wing_dye_color = wings_entry.dye_color

/datum/customizer_choice/organ/wings/apply_customizer_to_character(mob/living/carbon/human/human, datum/preferences/prefs, datum/customizer_entry/entry)
	var/datum/customizer_entry/organ/wings/wings_entry = entry
	var/obj/item/organ/wings/wing_organ = human.getorganslot(ORGAN_SLOT_WINGS)
	wing_organ.Remove(human)
	wing_organ.accessory_colors = wings_entry.wings_color
	wing_organ.Insert(human, TRUE, FALSE)
	human.update_body()

/datum/customizer_choice/organ/wings/generate_pref_choices(list/dat, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer/organ/wings/wings_entry = entry

	// Check if there's > 1 color key first since that is handled separately
	var/datum/sprite_accessory/wings/wing_accessory = SPRITE_ACCESSORY(entry.accessory_type)
	if(wing_accessory.color_keys > 1)
		dat += "<br><a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=reset_colors'>Reset colors</a>"
		var/list/color_list = color_string_to_list(entry.accessory_colors)
		for(var/index in 1 to wing_accessory.color_keys)
			var/named_index = (wing_accessory.color_keys == 1) ? wing_accessory.color_key_name : wing_accessory.color_key_names[index]
			dat += "<br>[named_index]: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=acc_color;color_index=[index]''><span class='color_holder_box' style='background-color:[color_list[index]]'></span></a>"
		return

	dat += "<br>Wings Color: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=wings_color''><span class='color_holder_box' style='background-color:[wings_entry.wings_color]'></span></a>"
	if(allows_natural_gradient)
		var/datum/hair_gradient/gradient = HAIR_GRADIENT(wings_entry.natural_gradient)
		dat += "<br>Natural Gradient: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=natural_gradient'>[gradient.name]</a>"
		if(wings_entry.natural_gradient != /datum/hair_gradient/none)
			dat += "<br>Natural Color: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=natural_gradient_color''><span class='color_holder_box' style='background-color:[wings_entry.natural_color]'></span></a>"
	if(allows_dye_gradient)
		var/datum/hair_gradient/gradient = HAIR_GRADIENT(wings_entry.dye_gradient)
		dat += "<br>Dye Gradient: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=dye_gradient'>[gradient.name]</a>"
		if(wings_entry.dye_gradient != /datum/hair_gradient/none)
			dat += "<br>Dye Color: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=dye_gradient_color''><span class='color_holder_box' style='background-color:[wings_entry.dye_color]'></span></a>"

/datum/customizer_choice/organ/wings/handle_topic(mob/user, list/href_list, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer/organ/wings/wings_entry = entry
	switch(href_list["customizer_task"])
		if("wings_color")
			var/new_color = color_pick_sanitized(user, "Choose your hair color:", "Character Preference", wings_entry.wings_color)
			if(!new_color)
				return
			wings_entry.wings_color = sanitize_hexcolor(new_color, 6, TRUE)
		if("natural_gradient")
			if(!allows_natural_gradient)
				return
			var/list/choice_list = hair_gradient_name_to_type_list()
			var/chosen_input = input(user, "Choose your natural gradient:", "Character Preference")  as null|anything in choice_list
			if(!chosen_input)
				return
			wings_entry.natural_gradient = choice_list[chosen_input]
		if("natural_gradient_color")
			if(!allows_natural_gradient)
				return
			var/new_color = color_pick_sanitized(user, "Choose your natural gradient color:", "Character Preference", wings_entry.natural_color)
			if(!new_color)
				return
			wings_entry.natural_color = sanitize_hexcolor(new_color, 6, TRUE)
		if("dye_gradient")
			if(!allows_dye_gradient)
				return
			var/list/choice_list = hair_gradient_name_to_type_list()
			var/chosen_input = input(user, "Choose your dye gradient:", "Character Preference")  as null|anything in choice_list
			if(!chosen_input)
				return
			wings_entry.dye_gradient = choice_list[chosen_input]
		if("dye_gradient_color")
			if(!allows_dye_gradient)
				return
			var/new_color = color_pick_sanitized(user, "Choose your dye gradient color:", "Character Preference", wings_entry.dye_color)
			if(!new_color)
				return
			wings_entry.dye_color = sanitize_hexcolor(new_color, 6, TRUE)

		// Here we hardcode the options from parent but without the colorable check (since it's false for wings)
		if("acc_color")
			if(!sprite_accessories)
				return
			var/index = text2num(href_list["color_index"])
			var/datum/sprite_accessory/wing_accessory = SPRITE_ACCESSORY(entry.accessory_type)
			if(index > wing_accessory.color_keys)
				return
			var/list/color_list = color_string_to_list(entry.accessory_colors)
			var/new_color = color_pick_sanitized(user, "Choose your accessory color:", "Character Preference","[color_list[index]]")
			if(!new_color)
				return
			color_list[index] = sanitize_hexcolor(new_color, 6, TRUE)
			var/color_string = color_list_to_string(color_list)
			entry.accessory_colors = color_string
			wings_entry.wings_color = color_string
		if("reset_colors")
			if(!sprite_accessories)
				return
			reset_accessory_colors(prefs, entry)

/datum/customizer/organ/wings/anthro
	customizer_choices = list(/datum/customizer_choice/organ/wings/anthro)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/organ/wings/anthro
	name = "Wings"
	organ_type = /obj/item/organ/wings/anthro
	sprite_accessories = list(
		/datum/sprite_accessory/wings/bat,
		/datum/sprite_accessory/wings/feathery,
		/datum/sprite_accessory/wings/featheryv2,
		/datum/sprite_accessory/wings/wide/succubus,
		/datum/sprite_accessory/wings/fairy,
		/datum/sprite_accessory/wings/bee,
		/datum/sprite_accessory/wings/wide/dragon_alt1,
		/datum/sprite_accessory/wings/wide/dragon_alt2,
		/datum/sprite_accessory/wings/wide/harpywings,
		/datum/sprite_accessory/wings/wide/harpywingsalt1,
		/datum/sprite_accessory/wings/wide/harpywingsalt2,
		/datum/sprite_accessory/wings/wide/harpywings_top,
		/datum/sprite_accessory/wings/wide/harpywingsalt1_top,
		/datum/sprite_accessory/wings/wide/harpywingsalt2_top,
		/datum/sprite_accessory/wings/wide/low_wings,
		/datum/sprite_accessory/wings/wide/low_wings_top,
		/datum/sprite_accessory/wings/wide/spider,
		/datum/sprite_accessory/wings/huge/dragon,
		/datum/sprite_accessory/wings/huge/angel,
		/datum/sprite_accessory/wings/huge/skeleton,
		/datum/sprite_accessory/wings/large/harpyswept,
		/datum/sprite_accessory/wings/large/harpyswept_alt,
		/datum/sprite_accessory/wings/large/harpyfluff,
		/datum/sprite_accessory/wings/large/harpyfolded,
		/datum/sprite_accessory/wings/large/harpyowl,
		/datum/sprite_accessory/wings/large/harpybat_alt,
		)

/datum/customizer/organ/wings/moth
	name = "Fluvian Wings"
	allows_disabling = TRUE
	default_disabled = FALSE
	customizer_choices = list(/datum/customizer_choice/organ/wings/moth)

/datum/customizer_choice/organ/wings/moth
	name = "Fluvian Wings"
	organ_type = /obj/item/organ/wings/moth
	sprite_accessories = list(
		/datum/sprite_accessory/wings/moth/plain,
		/datum/sprite_accessory/wings/moth/monarch,
		/datum/sprite_accessory/wings/moth/luna,
		/datum/sprite_accessory/wings/moth/atlas,
		/datum/sprite_accessory/wings/moth/reddish,
		/datum/sprite_accessory/wings/moth/royal,
		/datum/sprite_accessory/wings/moth/gothic,
		/datum/sprite_accessory/wings/moth/lovers,
		/datum/sprite_accessory/wings/moth/whitefly,
		/datum/sprite_accessory/wings/moth/punished,
		/datum/sprite_accessory/wings/moth/firewatch,
		/datum/sprite_accessory/wings/moth/deathhead,
		/datum/sprite_accessory/wings/moth/poison,
		/datum/sprite_accessory/wings/moth/ragged,
		/datum/sprite_accessory/wings/moth/moonfly,
		/datum/sprite_accessory/wings/moth/snow,
		/datum/sprite_accessory/wings/moth/oakworm,
		/datum/sprite_accessory/wings/moth/jungle,
		/datum/sprite_accessory/wings/moth/witchwing,
		/datum/sprite_accessory/wings/moth/rosy,
		/datum/sprite_accessory/wings/moth/featherful,
		/datum/sprite_accessory/wings/moth/brown,
		/datum/sprite_accessory/wings/moth/plasmafire,
		)

/datum/customizer/organ/wings/dracon
	customizer_choices = list(/datum/customizer_choice/organ/wings/dracon)
	allows_disabling = FALSE
	default_disabled = FALSE

/datum/customizer_choice/organ/wings/dracon
	name = "Drake Wings"
	organ_type = /obj/item/organ/wings/dracon
	sprite_accessories = list(
		/datum/sprite_accessory/wings/bat,
		/datum/sprite_accessory/wings/wide/succubus,
		/datum/sprite_accessory/wings/wide/dragon_alt1,
		/datum/sprite_accessory/wings/wide/dragon_alt2,
		/datum/sprite_accessory/wings/huge/dragon,
		/datum/sprite_accessory/wings/feathery,
		/datum/sprite_accessory/wings/featheryv2,
		/datum/sprite_accessory/wings/fairy,
		/datum/sprite_accessory/wings/bee,
		/datum/sprite_accessory/wings/wide/harpywings,
		/datum/sprite_accessory/wings/wide/harpywingsalt1,
		/datum/sprite_accessory/wings/wide/harpywingsalt2,
		/datum/sprite_accessory/wings/wide/harpywings_top,
		/datum/sprite_accessory/wings/wide/harpywingsalt1_top,
		/datum/sprite_accessory/wings/wide/harpywingsalt2_top,
		/datum/sprite_accessory/wings/wide/low_wings,
		/datum/sprite_accessory/wings/wide/low_wings_top,
		/datum/sprite_accessory/wings/wide/spider,
		/datum/sprite_accessory/wings/large/harpyswept,
		/datum/sprite_accessory/wings/huge/angel,
		/datum/sprite_accessory/wings/huge/skeleton,
	)

/datum/customizer/organ/wings/harpy
	name = "Harpy Wings"
	customizer_choices = list(/datum/customizer_choice/organ/wings/harpy)
	allows_disabling = FALSE

/datum/customizer_choice/organ/wings/harpy
	name = "Harpy Wings"
	organ_type = /obj/item/organ/wings/harpy
	sprite_accessories = list(
		/datum/sprite_accessory/wings/wide/harpywings,
		/datum/sprite_accessory/wings/wide/harpywingsalt1,
		/datum/sprite_accessory/wings/wide/harpywingsalt2,
		/datum/sprite_accessory/wings/wide/harpywings_top,
		/datum/sprite_accessory/wings/wide/harpywingsalt1_top,
		/datum/sprite_accessory/wings/wide/harpywingsalt2_top,
		/datum/sprite_accessory/wings/large/harpyswept,
		/datum/sprite_accessory/wings/large/harpyswept_alt,
		/datum/sprite_accessory/wings/large/harpyfluff,
		/datum/sprite_accessory/wings/large/harpyfolded,
		/datum/sprite_accessory/wings/large/harpyowl,
		/datum/sprite_accessory/wings/large/harpybat_alt,
		/datum/sprite_accessory/wings/feathery,
		/datum/sprite_accessory/wings/featheryv2,
		/datum/sprite_accessory/wings/huge/angel,

	)
