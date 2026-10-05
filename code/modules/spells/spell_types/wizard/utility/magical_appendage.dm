/obj/effect/proc_holder/spell/invoked/magical_appendage  // Changed from targeted to invoked
	name = "Magical Appendage"
	desc = "Temporarily grow yourself a third leg. I mean, a penis. Cannot be used if you already have one."
	clothes_req = FALSE
	charge_type = "recharge"
	associated_skill = /datum/skill/magic/arcane
	cost = 1 // Trash spell
	xp_gain = FALSE
	// Fix invoked spell variables
	releasedrain = 35
	chargedrain = 1  // Fixed from chargeddrain to chargedrain
	chargetime = 5
	recharge_time = 3 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 1
	invocations = list("Pendima")
	invocation_type = "whisper"
	hide_charge_effect = TRUE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/wind
	overlay_state = "mirror"

/obj/effect/proc_holder/spell/invoked/magical_appendage/cast(list/targets, mob/user)  // Changed to match invoked spell pattern
	if(!isliving(targets[1]))
		return
	var/mob/living/carbon/human/H = targets[1]
	if(!istype(H))
		return
	var/has_penis = !!H.getorganslot(ORGAN_SLOT_PENIS)
	if(has_penis & !H.magic_penis) //cannot be used if already have natural penis. sorry bros
		H.visible_message(span_notice("You already have a penis!"))
		return

	//ADD_TRAIT(H, TRAIT_MIRROR_MAGIC, TRAIT_GENERIC)
	H.visible_message(span_notice("[H]'s groin glows bright for a moment."), span_notice("You feel a stirring in your groin."))
	perform_magical_appendage(H)
	//addtimer(CALLBACK(src, PROC_REF(remove_mirror_magic), H), 5 MINUTES)
	return TRUE  // Return TRUE for successful cast

/obj/effect/proc_holder/spell/invoked/magical_appendage/proc/remove_mirror_magic(mob/living/carbon/human/H)
	if(!QDELETED(H))
		REMOVE_TRAIT(H, TRAIT_MIRROR_MAGIC, TRAIT_GENERIC)
		to_chat(H, span_warning("Your connection to mirrors fades away."))

/proc/perform_magical_appendage(mob/living/carbon/human/H)
	// Handles the actual appearance changing part of the spell. For reasons unknown to man, this previously lived exclusively on the mirror object.
	if (!H)
		return
	var/should_update = FALSE
	var/force_bodypart_update = FALSE
	var/list/choices = list("penis type", "penis color", "penis color 2", "testicles", "testicles color", "penis size", "testicle size")
	var/chosen = input(H, "Change what?", "Appearance") as null|anything in choices

	if(!chosen)
		return
		
	switch(chosen)
		if("penis type")
			var/list/valid_penis_types = list("none")
			for(var/choice_path in subtypesof(/datum/customizer_choice/organ/penis))
				var/datum/customizer_choice/organ/penis/choice = new choice_path()
				if(!choice?.organ_type)
					continue
				if(valid_penis_types[choice.name])
					continue
				var/accessory_type = null
				if(length(choice.sprite_accessories))
					accessory_type = choice.sprite_accessories[1]
				valid_penis_types[choice.name] = list(
					"organ_type" = choice.organ_type,
					"accessory_type" = accessory_type,
				)

			var/new_style = input(H, "Choose your penis type", "Penis Customization") as null|anything in valid_penis_types
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
					if(penis)
						penis.Remove(H)
						qdel(penis)
						H.update_body()
						should_update = TRUE
				else
					var/list/selection = valid_penis_types[new_style]
					var/new_organ_type = selection?["organ_type"] || /obj/item/organ/penis
					var/new_accessory_type = selection?["accessory_type"]

					var/obj/item/organ/penis/old_penis = H.getorganslot(ORGAN_SLOT_PENIS)
					var/new_size = old_penis?.penis_size || DEFAULT_PENIS_SIZE
					var/new_functional = isnull(old_penis) ? TRUE : old_penis.functional
					var/new_colors = old_penis?.accessory_colors

					if(old_penis)
						old_penis.Remove(H)
						qdel(old_penis)

					var/obj/item/organ/penis/penis = new new_organ_type()
					penis.penis_size = new_size
					penis.functional = new_functional
					if(new_accessory_type)
						penis.accessory_type = new_accessory_type
					if(new_colors)
						penis.accessory_colors = new_colors
					else
						// Use build_colors_for_accessory to properly set colors from character
						penis.build_colors_for_accessory(null)
					penis.Insert(H, TRUE, FALSE)
					H.update_body()
					H.magic_penis = TRUE
					should_update = TRUE

		if("penis color")
			var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
			if(penis)
				var/list/current_colors = list()
				if(penis.accessory_colors)
					current_colors = color_string_to_list(penis.accessory_colors)
				if(!length(current_colors))
					current_colors = list(H.dna.features["mcolor"] || "#FFFFFF", H.dna.features["mcolor"] || "#FFFFFF")
				var/new_color = color_pick_sanitized(H, "Choose your primary penis color", "Penis Color", current_colors[1])
				if(new_color)
					penis.Remove(H)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					penis.accessory_colors = color_list_to_string(current_colors)
					penis.Insert(H, TRUE, FALSE)
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have a penis!"))

		if("penis color 2")
			var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
			if(penis)
				var/list/current_colors = list()
				if(penis.accessory_colors)
					current_colors = color_string_to_list(penis.accessory_colors)
				if(!length(current_colors))
					current_colors = list(H.dna.features["mcolor"] || "#FFFFFF", H.dna.features["mcolor"] || "#FFFFFF")
				var/new_color = color_pick_sanitized(H, "Choose your secondary penis color (sheath/detail)", "Penis Color 2", current_colors[2])
				if(new_color)
					penis.Remove(H)
					current_colors[2] = sanitize_hexcolor(new_color, 6, TRUE)
					penis.accessory_colors = color_list_to_string(current_colors)
					penis.Insert(H, TRUE, FALSE)
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have a penis!"))

		if("testicles")
			var/list/valid_testicle_types = list("none")
			for(var/testicle_path in subtypesof(/datum/sprite_accessory/testicles))
				var/datum/sprite_accessory/testicles/testicles = new testicle_path()
				valid_testicle_types[testicles.name] = testicle_path

			var/new_style = input(H, "Choose your testicles type", "Testicles Customization") as null|anything in valid_testicle_types
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/testicles/testicles = H.getorganslot(ORGAN_SLOT_TESTICLES)
					if(testicles)
						testicles.Remove(H)
						qdel(testicles)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/testicles/testicles = H.getorganslot(ORGAN_SLOT_TESTICLES)
					if(!testicles)
						testicles = new()
						testicles.Insert(H, TRUE, FALSE)
					testicles.accessory_type = valid_testicle_types[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					testicles.build_colors_for_accessory(null)
					H.update_body()
					should_update = TRUE

		if("testicles color")
			var/obj/item/organ/testicles/testicles = H.getorganslot(ORGAN_SLOT_TESTICLES)
			if(testicles)
				var/list/current_colors = list()
				if(testicles.accessory_colors)
					current_colors = color_string_to_list(testicles.accessory_colors)
				if(!length(current_colors))
					current_colors = list(H.dna.features["mcolor"] || "#FFFFFF")
				var/new_color = color_pick_sanitized(H, "Choose your testicles color", "Testicles Color", current_colors[1])
				if(new_color)
					testicles.Remove(H)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					testicles.accessory_colors = color_list_to_string(current_colors)
					testicles.Insert(H, TRUE, FALSE)
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have testicles!"))

		if("penis size")
			var/list/penis_sizes = list("small", "average", "large")
			var/new_size = input(H, "Choose your penis size", "Penis Size") as null|anything in penis_sizes
			if(new_size)
				var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
				if(penis)
					var/size_num
					switch(new_size)
						if("small")
							size_num = 1
						if("average")
							size_num = 2
						if("large")
							size_num = 3

					penis.penis_size = size_num
					H.update_body()
					should_update = TRUE

		if("testicle size")
			var/list/testicle_sizes = list("small", "average", "large")
			var/new_size = input(H, "Choose your testicle size", "Testicle Size") as null|anything in testicle_sizes
			if(new_size)
				var/obj/item/organ/testicles/testicles = H.getorganslot(ORGAN_SLOT_TESTICLES)
				if(testicles)
					var/size_num
					switch(new_size)
						if("small")
							size_num = 1
						if("average")
							size_num = 2
						if("large")
							size_num = 3

					testicles.ball_size = size_num
					H.update_body()
					should_update = TRUE


	if(should_update)
		H.update_hair()
		H.update_body()
		H.update_body_parts(force_bodypart_update)
		if(H.sexcon)
			H.sexcon.update_erect_state()
