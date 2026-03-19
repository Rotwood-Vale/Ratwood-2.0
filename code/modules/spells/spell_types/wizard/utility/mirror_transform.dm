/obj/effect/proc_holder/spell/invoked/mirror_transform  // Changed from targeted to invoked
	name = "Mirror Transform"
	desc = "Temporarily grants you the ability to use mirrors to change your appearance."
	clothes_req = FALSE
	charge_type = "recharge"
	associated_skill = /datum/skill/magic/arcane
	cost = 1 // Trash spell
	xp_gain = TRUE
	// Fix invoked spell variables
	releasedrain = 35
	chargedrain = 1  // Fixed from chargeddrain to chargedrain
	chargetime = 10
	recharge_time = 300 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 1
	invocations = list("Effingo")
	invocation_type = "whisper"
	hide_charge_effect = TRUE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/wind
	overlay_state = "mirror"

/obj/effect/proc_holder/spell/invoked/mirror_transform/cast(list/targets, mob/user)  // Changed to match invoked spell pattern
	if(!isliving(targets[1]))
		return
	var/mob/living/carbon/human/H = targets[1]
	if(!istype(H))
		return

	ADD_TRAIT(H, TRAIT_MIRROR_MAGIC, TRAIT_GENERIC)
	H.visible_message(span_notice("[H]'s reflection shimmers briefly."), span_notice("You feel a connection to mirrors forming..."))
	
	addtimer(CALLBACK(src, PROC_REF(remove_mirror_magic), H), 5 MINUTES)
	return TRUE  // Return TRUE for successful cast

/obj/effect/proc_holder/spell/invoked/mirror_transform/proc/remove_mirror_magic(mob/living/carbon/human/H)
	if(!QDELETED(H))
		REMOVE_TRAIT(H, TRAIT_MIRROR_MAGIC, TRAIT_GENERIC)
		to_chat(H, span_warning("Your connection to mirrors fades away."))

/proc/perform_mirror_transform(mob/living/carbon/human/H)
	// Handles the actual appearance changing part of the spell. For reasons unknown to man, this previously lived exclusively on the mirror object.
	if (!H)
		return
	var/should_update = FALSE
	var/list/choices = list("reset appearance", "hairstyle", "facial hairstyle", "accessory", "face detail", "crest", "horns", "horn color", "ears", "ear color one", "ear color two", "tail", "tail color one", "tail color two", "tail feature", "tail feature color", "wings", "wing color one", "wing color two", "frills", "frill color", "antennas", "antenna color", "snout", "snout color", "head feature", "head feature color", "neck feature", "neck feature color", "back feature", "back feature color", "descriptors", "hair color", "facial hair color", "eye color", "skin color", "mutant color", "mutant color 2", "mutant color 3", "natural gradient", "natural gradient color", "dye gradient", "dye gradient color", "penis", "penis color", "penis color 2", "testicles", "testicles color", "breasts", "breasts color", "vagina", "vagina color", "breast size", "penis size", "testicle size")
	var/chosen = input(H, "Change what?", "Appearance") as null|anything in choices

	if(!chosen)
		return

	switch(chosen)
		if("reset appearance")
			if(!H.client || !H.client.prefs)
				to_chat(H, span_warning("You don't have character preferences saved!"))
				return
			
			// Verify this is the same character by checking if the preference slot's name matches
			if(H.client.prefs.real_name != H.real_name)
				to_chat(H, span_warning("You can only reset to the appearance of the character you are currently playing!"))
				return
			
			var/confirm = alert(H, "Reset your appearance to match your character preferences? This will reapply all physical features, colors, and descriptors but won't change your name, skills, or abilities.", "Reset Appearance", "Yes", "No")
			if(confirm != "Yes")
				return
			
			if(!H.client || !H.client.prefs)
				return
			
			// Double-check after the alert (in case player switched slots)
			if(H.client.prefs.real_name != H.real_name)
				to_chat(H, span_warning("You can only reset to the appearance of the character you are currently playing!"))
				return
			
			// Store the original name, age, and other non-physical attributes
			var/original_name = H.real_name
			var/original_age = H.age
			
			// Apply preferences but only physical appearance
			// We'll manually restore what we don't want changed
			H.client.prefs.copy_to(H, icon_updates = FALSE, roundstart_checks = FALSE, character_setup = TRUE)
			
			// Restore non-physical attributes
			H.real_name = original_name
			H.name = original_name
			H.dna.real_name = original_name
			if(H.mind)
				H.mind.name = original_name
			H.age = original_age
			
			// Update visuals
			H.update_body()
			H.update_hair()
			H.update_body_parts(TRUE)
			
			to_chat(H, span_notice("Your appearance has been reset to match your character preferences."))
			should_update = TRUE

		if("hairstyle")
			var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
			var/list/valid_hairstyles = list()
			for(var/hair_type in hair_choice.sprite_accessories)
				var/datum/sprite_accessory/hair/head/hair = new hair_type()
				valid_hairstyles[hair.name] = hair_type

			var/new_style = input(H, "Choose your hairstyle", "Hair Styling") as null|anything in valid_hairstyles
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						var/datum/customizer_entry/hair/hair_entry = new()
						hair_entry.hair_color = current_hair.hair_color

						if(istype(current_hair, /datum/bodypart_feature/hair/head))
							hair_entry.natural_gradient = current_hair.natural_gradient
							hair_entry.natural_color = current_hair.natural_color
							if(hasvar(current_hair, "hair_dye_gradient"))
								hair_entry.dye_gradient = current_hair.hair_dye_gradient
							if(hasvar(current_hair, "hair_dye_color"))
								hair_entry.dye_color = current_hair.hair_dye_color

						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(valid_hairstyles[new_style], hair_entry.hair_color, H)

						hair_choice.customize_feature(new_hair, H, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						H.update_hair()
						should_update = TRUE

		if("hair color")
			var/new_hair_color = color_pick_sanitized(H, "Choose your hair color", "Hair Color", H.hair_color)
			if(new_hair_color)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)

					var/datum/customizer_entry/hair/hair_entry = new()
					hair_entry.hair_color = sanitize_hexcolor(new_hair_color, 6, TRUE)

					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						var/datum/bodypart_feature/hair/head/new_hair = new()

						new_hair.set_accessory_type(current_hair.accessory_type, null, H)

						hair_choice.customize_feature(new_hair, H, null, hair_entry)

						H.hair_color = hair_entry.hair_color
						H.dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)

						H.dna.species.handle_body(H)
						H.update_body()
						H.update_hair()
						H.update_body_parts()
						should_update = TRUE

		if("facial hair color")
			var/new_facial_hair_color = color_pick_sanitized(H, "Choose your facial hair color", "Facial Hair Color", H.facial_hair_color)
			if(new_facial_hair_color)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)

					var/datum/customizer_entry/hair/facial/facial_entry = new()

					var/datum/bodypart_feature/hair/facial/current_facial = null
					for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
						current_facial = facial_feature
						break

					if(current_facial)
						facial_entry.hair_color = sanitize_hexcolor(new_facial_hair_color, 6, TRUE)
						facial_entry.accessory_type = current_facial.accessory_type

						var/datum/bodypart_feature/hair/facial/new_facial = new()
						new_facial.set_accessory_type(current_facial.accessory_type, null, H)
						facial_choice.customize_feature(new_facial, H, null, facial_entry)

						H.facial_hair_color = facial_entry.hair_color
						H.dna.update_ui_block(DNA_FACIAL_HAIR_COLOR_BLOCK)
						head.remove_bodypart_feature(current_facial)
						head.add_bodypart_feature(new_facial)
						should_update = TRUE

		if("eye color")
			var/new_eye_color = color_pick_sanitized(H, "Choose your eye color", "Eye Color", H.eye_color)
			if(new_eye_color)
				new_eye_color = sanitize_hexcolor(new_eye_color, 6, TRUE)
				var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
				if(eyes)
					eyes.Remove(H)
					eyes.eye_color = new_eye_color
					eyes.Insert(H, TRUE, FALSE)
				H.eye_color = new_eye_color
				H.dna.features["eye_color"] = new_eye_color
				H.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
				H.update_body_parts()
				should_update = TRUE

		if("skin color")
			var/new_color = color_pick_sanitized(H, "Choose your skin color", "Skin Color", H.skin_tone)
			if(new_color)
				H.skin_tone = new_color
				H.update_body()
				should_update = TRUE

		if("mutant color")
			var/new_color = color_pick_sanitized(H, "Choose your mutant color", "Mutant Color", H.dna.features["mcolor"] || "#FFFFFF")
			if(new_color)
				H.dna.features["mcolor"] = new_color
				H.update_body()
				should_update = TRUE

		if("mutant color 2")
			var/new_color = color_pick_sanitized(H, "Choose your mutant color 2", "Mutant Color 2", H.dna.features["mcolor2"] || "#FFFFFF")
			if(new_color)
				H.dna.features["mcolor2"] = new_color
				H.update_body()
				should_update = TRUE

		if("mutant color 3")
			var/new_color = color_pick_sanitized(H, "Choose your mutant color 3", "Mutant Color 3", H.dna.features["mcolor3"] || "#FFFFFF")
			if(new_color)
				H.dna.features["mcolor3"] = new_color
				H.update_body()
				should_update = TRUE

		if("natural gradient")
			var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
			var/list/valid_gradients = list()
			for(var/gradient_type in GLOB.hair_gradients)
				valid_gradients[gradient_type] = gradient_type

			var/new_style = input(H, "Choose your natural gradient", "Hair Gradient") as null|anything in valid_gradients
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						var/datum/customizer_entry/hair/hair_entry = new()
						hair_entry.hair_color = current_hair.hair_color
						hair_entry.natural_gradient = valid_gradients[new_style]
						hair_entry.natural_color = current_hair.natural_color
						hair_entry.dye_gradient = current_hair.hair_dye_gradient
						hair_entry.dye_color = current_hair.hair_dye_color
						hair_entry.accessory_type = current_hair.accessory_type

						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(current_hair.accessory_type, null, H)
						hair_choice.customize_feature(new_hair, H, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE

		if("natural gradient color")
			var/new_gradient_color = color_pick_sanitized(H, "Choose your natural gradient color", "Natural Gradient Color", H.hair_color)
			if(new_gradient_color)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)

					var/datum/customizer_entry/hair/hair_entry = new()

					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						hair_entry.hair_color = current_hair.hair_color
						hair_entry.natural_gradient = current_hair.natural_gradient
						hair_entry.natural_color = sanitize_hexcolor(new_gradient_color, 6, TRUE)
						hair_entry.dye_gradient = current_hair.hair_dye_gradient
						hair_entry.dye_color = current_hair.hair_dye_color
						hair_entry.accessory_type = current_hair.accessory_type

						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(current_hair.accessory_type, null, H)
						hair_choice.customize_feature(new_hair, H, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE

		if("dye gradient")
			var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
			var/list/valid_gradients = list()
			for(var/gradient_type in GLOB.hair_gradients)
				valid_gradients[gradient_type] = gradient_type

			var/new_style = input(H, "Choose your dye gradient", "Hair Gradient") as null|anything in valid_gradients
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						var/datum/customizer_entry/hair/hair_entry = new()
						hair_entry.hair_color = current_hair.hair_color
						hair_entry.natural_gradient = current_hair.natural_gradient
						hair_entry.natural_color = current_hair.natural_color
						hair_entry.dye_gradient = valid_gradients[new_style]
						hair_entry.dye_color = current_hair.hair_dye_color
						hair_entry.accessory_type = current_hair.accessory_type

						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(current_hair.accessory_type, null, H)
						hair_choice.customize_feature(new_hair, H, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE

		if("dye gradient color")
			var/new_gradient_color = color_pick_sanitized(H, "Choose your dye gradient color", "Dye Gradient Color", H.hair_color)
			if(new_gradient_color)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)

					var/datum/customizer_entry/hair/hair_entry = new()

					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						hair_entry.hair_color = current_hair.hair_color
						hair_entry.natural_gradient = current_hair.natural_gradient
						hair_entry.natural_color = current_hair.natural_color
						hair_entry.dye_gradient = current_hair.hair_dye_gradient
						hair_entry.dye_color = sanitize_hexcolor(new_gradient_color, 6, TRUE)
						hair_entry.accessory_type = current_hair.accessory_type

						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(current_hair.accessory_type, null, H)
						hair_choice.customize_feature(new_hair, H, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE

		if("facial hairstyle")
			var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
			var/list/valid_facial_hairstyles = list()
			for(var/facial_type in facial_choice.sprite_accessories)
				var/datum/sprite_accessory/hair/facial/facial = new facial_type()
				valid_facial_hairstyles[facial.name] = facial_type

			var/new_style = input(H, "Choose your facial hairstyle", "Hair Styling") as null|anything in valid_facial_hairstyles
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/facial/current_facial = null
					for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
						current_facial = facial_feature
						break

					if(current_facial)
						// Create a new facial hair entry with the SAME color as the current facial hair
						var/datum/customizer_entry/hair/facial/facial_entry = new()
						facial_entry.hair_color = current_facial.hair_color

						// Create the new facial hair with the new style but preserve color
						var/datum/bodypart_feature/hair/facial/new_facial = new()
						new_facial.set_accessory_type(valid_facial_hairstyles[new_style], facial_entry.hair_color, H)

						// Apply all the color data from the entry
						facial_choice.customize_feature(new_facial, H, null, facial_entry)

						head.remove_bodypart_feature(current_facial)
						head.add_bodypart_feature(new_facial)
						H.update_hair()
						should_update = TRUE

		if("accessory")
			var/datum/customizer_choice/bodypart_feature/accessory/accessory_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/accessory)
			var/list/valid_accessories = list("none")
			for(var/accessory_type in accessory_choice.sprite_accessories)
				var/datum/sprite_accessory/accessory/acc = new accessory_type()
				valid_accessories[acc.name] = accessory_type

			var/new_style = input(H, "Choose your accessory", "Accessory Styling") as null|anything in valid_accessories
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					// Remove existing accessory if any
					for(var/datum/bodypart_feature/accessory/old_acc in head.bodypart_features)
						head.remove_bodypart_feature(old_acc)
						break

					// Add new accessory if not "none"
					if(new_style != "none")
						var/datum/bodypart_feature/accessory/accessory_feature = new()
						accessory_feature.set_accessory_type(valid_accessories[new_style], H.hair_color, H)
						head.add_bodypart_feature(accessory_feature)
					should_update = TRUE

		if("face detail")
			var/datum/customizer_choice/bodypart_feature/face_detail/face_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/face_detail)
			var/list/valid_details = list("none")
			for(var/detail_type in face_choice.sprite_accessories)
				var/datum/sprite_accessory/face_detail/detail = new detail_type()
				valid_details[detail.name] = detail_type

			var/new_detail = input(H, "Choose your face detail", "Face Detail") as null|anything in valid_details
			if(new_detail)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					// Remove existing face detail if any
					for(var/datum/bodypart_feature/face_detail/old_detail in head.bodypart_features)
						head.remove_bodypart_feature(old_detail)
						break

					// Add new face detail if not "none"
					if(new_detail != "none")
						var/datum/bodypart_feature/face_detail/detail_feature = new()
						detail_feature.set_accessory_type(valid_details[new_detail], H.hair_color, H)
						head.add_bodypart_feature(detail_feature)
					should_update = TRUE

		if("penis")
			var/list/valid_penis_types = list("none")
			for(var/penis_path in subtypesof(/datum/sprite_accessory/penis))
				var/datum/sprite_accessory/penis/penis = new penis_path()
				valid_penis_types[penis.name] = penis_path

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
					var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
					if(!penis)
						penis = new()
						penis.Insert(H, TRUE, FALSE)
					penis.accessory_type = valid_penis_types[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					penis.build_colors_for_accessory(null)
					H.update_body()
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

		if("breasts")
			var/list/valid_breast_types = list("none")
			for(var/breast_path in subtypesof(/datum/sprite_accessory/breasts))
				var/datum/sprite_accessory/breasts/breasts = new breast_path()
				valid_breast_types[breasts.name] = breast_path

			var/new_style = input(H, "Choose your breast type", "Breast Customization") as null|anything in valid_breast_types

			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
					if(breasts)
						breasts.Remove(H)
						qdel(breasts)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
					if(!breasts)
						breasts = new()
						breasts.Insert(H, TRUE, FALSE)

					breasts.accessory_type = valid_breast_types[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					breasts.build_colors_for_accessory(null)
					H.update_body()
					should_update = TRUE

		if("breasts color")
			var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
			if(breasts)
				var/list/current_colors = list()
				if(breasts.accessory_colors)
					current_colors = color_string_to_list(breasts.accessory_colors)
				if(!length(current_colors))
					current_colors = list(H.dna.features["mcolor"] || "#FFFFFF")
				var/new_color = color_pick_sanitized(H, "Choose your breasts color", "Breasts Color", current_colors[1])
				if(new_color)
					breasts.Remove(H)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					breasts.accessory_colors = color_list_to_string(current_colors)
					breasts.Insert(H, TRUE, FALSE)
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have breasts!"))

		if("vagina")
			var/list/valid_vagina_types = list("none")
			for(var/vagina_path in subtypesof(/datum/sprite_accessory/vagina))
				var/datum/sprite_accessory/vagina/vagina = new vagina_path()
				valid_vagina_types[vagina.name] = vagina_path

			var/new_style = input(H, "Choose your vagina type", "Vagina Customization") as null|anything in valid_vagina_types

			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/vagina/vagina = H.getorganslot(ORGAN_SLOT_VAGINA)
					if(vagina)
						vagina.Remove(H)
						qdel(vagina)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/vagina/vagina = H.getorganslot(ORGAN_SLOT_VAGINA)
					if(!vagina)
						vagina = new()
						vagina.Insert(H, TRUE, FALSE)
					vagina.accessory_type = valid_vagina_types[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					vagina.build_colors_for_accessory(null)
					H.update_body()
					should_update = TRUE

		if("vagina color")
			var/obj/item/organ/vagina/vagina = H.getorganslot(ORGAN_SLOT_VAGINA)
			if(vagina)
				var/list/current_colors = list()
				if(vagina.accessory_colors)
					current_colors = color_string_to_list(vagina.accessory_colors)
				if(!length(current_colors))
					current_colors = list(H.dna.features["mcolor"] || "#FFFFFF")
				var/new_color = color_pick_sanitized(H, "Choose your vagina color", "Vagina Color", current_colors[1])
				if(new_color)
					vagina.Remove(H)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					vagina.accessory_colors = color_list_to_string(current_colors)
					vagina.Insert(H, TRUE, FALSE)
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have a vagina!"))

		if("breast size")
			var/list/breast_sizes = list("Flat", "Slight", "Small", "Moderate", "Large", "Generous", "Heavy", "Massive", "Heaping", "Obscene")
			var/new_size = input(H, "Choose your breast size", "Breast Size") as null|anything in breast_sizes
			if(new_size)
				var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
				if(breasts)
					var/size_num
					switch(new_size)
						if("Flat")
							size_num = 0
						if("Slight")
							size_num = 1
						if("Small")
							size_num = 2
						if("Moderate")
							size_num = 3
						if("Large")
							size_num = 4
						if("Generous")
							size_num = 5
						if("Heavy")
							size_num = 6
						if("Massive")
							size_num = 7
						if("Heaping")
							size_num = 8
						if("Obscene")
							size_num = 9

					breasts.breast_size = size_num
					H.update_body()
					should_update = TRUE

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

		if("tail")
			var/list/valid_tails = list("none")
			for(var/tail_path in subtypesof(/datum/sprite_accessory/tail))
				var/datum/sprite_accessory/tail/tail = new tail_path()
				valid_tails[tail.name] = tail_path

			var/new_style = input(H, "Choose your tail", "Tail Customization") as null|anything in valid_tails
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/tail/tail = H.getorganslot(ORGAN_SLOT_TAIL)
					if(tail)
						tail.Remove(H)
						qdel(tail)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/tail/tail = H.getorganslot(ORGAN_SLOT_TAIL)
					if(!tail)
						tail = new /obj/item/organ/tail/anthro()
						tail.Insert(H, TRUE, FALSE)
					tail.accessory_type = valid_tails[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					tail.build_colors_for_accessory(null)
					H.update_body()
					should_update = TRUE

		if("tail color one")
			var/obj/item/organ/tail/tail = H.getorganslot(ORGAN_SLOT_TAIL)
			if(tail)
				var/list/current_colors = list()
				if(tail.accessory_colors)
					current_colors = color_string_to_list(tail.accessory_colors)
				if(!length(current_colors))
					current_colors = list(H.dna.features["mcolor"] || "#FFFFFF", H.dna.features["mcolor"] || "#FFFFFF")
				var/new_color = color_pick_sanitized(H, "Choose your primary tail color", "Tail Color One", current_colors[1])
				if(new_color)
					tail.Remove(H)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					tail.accessory_colors = color_list_to_string(current_colors)
					tail.Insert(H, TRUE, FALSE)
					H.dna.features["tail_color"] = current_colors[1]  // Update DNA features
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have a tail!"))

		if("tail color two")
			var/obj/item/organ/tail/tail = H.getorganslot(ORGAN_SLOT_TAIL)
			if(tail)
				var/list/current_colors = list()
				if(tail.accessory_colors)
					current_colors = color_string_to_list(tail.accessory_colors)
				if(!length(current_colors))
					current_colors = list(H.dna.features["mcolor"] || "#FFFFFF", H.dna.features["mcolor"] || "#FFFFFF")
				var/new_color = color_pick_sanitized(H, "Choose your secondary tail color", "Tail Color Two", current_colors[2])
				if(new_color)
					tail.Remove(H)
					current_colors[2] = sanitize_hexcolor(new_color, 6, TRUE)
					tail.accessory_colors = color_list_to_string(current_colors)
					tail.Insert(H, TRUE, FALSE)
					H.dna.features["tail_color2"] = current_colors[2]  // Update DNA features
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have a tail!"))
		if("ears")
			var/list/valid_ears = list("none")
			for(var/ears_path in subtypesof(/datum/sprite_accessory/ears))
				var/datum/sprite_accessory/ears/ears = new ears_path()
				valid_ears[ears.name] = ears_path

			var/new_style = input(H, "Choose your ears", "Ears Customization") as null|anything in valid_ears
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
					if(ears)
						ears.Remove(H)
						qdel(ears)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
					if(!ears)
						ears = new /obj/item/organ/ears()
						ears.Insert(H, TRUE, FALSE)
					ears.accessory_type = valid_ears[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					ears.build_colors_for_accessory(null)
					H.update_body()
					should_update = TRUE

		if("ear color one")
			var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
			if(ears)
				var/list/current_colors = list()
				if(ears.accessory_colors)
					current_colors = color_string_to_list(ears.accessory_colors)
				if(!length(current_colors))
					current_colors = list(H.dna.features["mcolor"] || "#FFFFFF", H.dna.features["mcolor"] || "#FFFFFF")
				var/new_color = color_pick_sanitized(H, "Choose your primary ear color", "Ear Color One", current_colors[1])
				if(new_color)
					ears.Remove(H)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					ears.accessory_colors = color_list_to_string(current_colors)
					ears.Insert(H, TRUE, FALSE)
					H.dna.features["ears_color"] = current_colors[1]  // Update DNA features
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have ears!"))

		if("ear color two")
			var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
			if(ears)
				var/list/current_colors = list()
				if(ears.accessory_colors)
					current_colors = color_string_to_list(ears.accessory_colors)
				if(!length(current_colors))
					current_colors = list(H.dna.features["mcolor"] || "#FFFFFF", H.dna.features["mcolor"] || "#FFFFFF")
				var/new_color = color_pick_sanitized(H, "Choose your secondary ear color", "Ear Color Two", current_colors[2])
				if(new_color)
					ears.Remove(H)
					current_colors[2] = sanitize_hexcolor(new_color, 6, TRUE)
					ears.accessory_colors = color_list_to_string(current_colors)
					ears.Insert(H, TRUE, FALSE)
					H.dna.features["ears_color2"] = current_colors[2]  // Update DNA features
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have ears!"))

		if("wings")
			var/list/valid_wings = list("none")
			for(var/wings_path in subtypesof(/datum/sprite_accessory/wings))
				var/datum/sprite_accessory/wings/wings = new wings_path()
				valid_wings[wings.name] = wings_path

			var/new_style = input(H, "Choose your wings", "Wings Customization") as null|anything in valid_wings
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/wings/wings = H.getorganslot(ORGAN_SLOT_WINGS)
					if(wings)
						wings.Remove(H)
						qdel(wings)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/wings/wings = H.getorganslot(ORGAN_SLOT_WINGS)
					if(!wings)
						wings = new /obj/item/organ/wings()
						wings.Insert(H, TRUE, FALSE)
					wings.accessory_type = valid_wings[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					wings.build_colors_for_accessory(null)
					H.update_body()
					should_update = TRUE

		if("wing color one")
			var/obj/item/organ/wings/wings = H.getorganslot(ORGAN_SLOT_WINGS)
			if(wings)
				var/list/current_colors = list()
				if(wings.accessory_colors)
					current_colors = color_string_to_list(wings.accessory_colors)
				if(!length(current_colors))
					current_colors = list(H.dna.features["mcolor"] || "#FFFFFF", H.dna.features["mcolor"] || "#FFFFFF")
				var/new_color = color_pick_sanitized(H, "Choose your primary wing color", "Wing Color One", current_colors[1])
				if(new_color)
					wings.Remove(H)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					wings.accessory_colors = color_list_to_string(current_colors)
					wings.Insert(H, TRUE, FALSE)
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have wings!"))

		if("wing color two")
			var/obj/item/organ/wings/wings = H.getorganslot(ORGAN_SLOT_WINGS)
			if(wings)
				var/list/current_colors = list()
				if(wings.accessory_colors)
					current_colors = color_string_to_list(wings.accessory_colors)
				if(!length(current_colors))
					current_colors = list(H.dna.features["mcolor"] || "#FFFFFF", H.dna.features["mcolor"] || "#FFFFFF")
				var/new_color = color_pick_sanitized(H, "Choose your secondary wing color", "Wing Color Two", current_colors[2])
				if(new_color)
					wings.Remove(H)
					current_colors[2] = sanitize_hexcolor(new_color, 6, TRUE)
					wings.accessory_colors = color_list_to_string(current_colors)
					wings.Insert(H, TRUE, FALSE)
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have wings!"))

		if("frills")
			var/list/valid_frills = list("none")
			for(var/frills_path in subtypesof(/datum/sprite_accessory/frills))
				var/datum/sprite_accessory/frills/frills = new frills_path()
				valid_frills[frills.name] = frills_path

			var/new_style = input(H, "Choose your frills", "Frills Customization") as null|anything in valid_frills
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/frills/frills = H.getorganslot(ORGAN_SLOT_FRILLS)
					if(frills)
						frills.Remove(H)
						qdel(frills)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/frills/frills = H.getorganslot(ORGAN_SLOT_FRILLS)
					if(!frills)
						frills = new /obj/item/organ/frills()
						frills.Insert(H, TRUE, FALSE)
					frills.accessory_type = valid_frills[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					frills.build_colors_for_accessory(null)
					H.update_body()
					should_update = TRUE

		if("frill color")
			var/obj/item/organ/frills/frills = H.getorganslot(ORGAN_SLOT_FRILLS)
			if(frills)
				var/list/current_colors = list()
				if(frills.accessory_colors)
					current_colors = color_string_to_list(frills.accessory_colors)
				if(!length(current_colors))
					current_colors = list(H.dna.features["mcolor"] || H.skin_tone || "#FFFFFF")
				var/new_color = color_pick_sanitized(H, "Choose your frill color", "Frill Color", current_colors[1])
				if(new_color)
					frills.Remove(H)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					frills.accessory_colors = color_list_to_string(current_colors)
					frills.Insert(H, TRUE, FALSE)
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have frills!"))

		if("antennas")
			var/list/valid_antennas = list("none")
			for(var/antennas_path in subtypesof(/datum/sprite_accessory/antenna))
				var/datum/sprite_accessory/antenna/antennas = new antennas_path()
				valid_antennas[antennas.name] = antennas_path

			var/new_style = input(H, "Choose your antennas", "Antennas Customization") as null|anything in valid_antennas
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/antennas/antennas = H.getorganslot(ORGAN_SLOT_ANTENNAS)
					if(antennas)
						antennas.Remove(H)
						qdel(antennas)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/antennas/antennas = H.getorganslot(ORGAN_SLOT_ANTENNAS)
					if(!antennas)
						antennas = new /obj/item/organ/antennas()
						antennas.Insert(H, TRUE, FALSE)
					antennas.accessory_type = valid_antennas[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					antennas.build_colors_for_accessory(null)
					H.update_body()
					should_update = TRUE

		if("antenna color")
			var/obj/item/organ/antennas/antennas = H.getorganslot(ORGAN_SLOT_ANTENNAS)
			if(antennas)
				var/list/current_colors = list()
				if(antennas.accessory_colors)
					current_colors = color_string_to_list(antennas.accessory_colors)
				if(!length(current_colors))
					current_colors = list(H.dna.features["mcolor"] || H.skin_tone || "#FFFFFF")
				var/new_color = color_pick_sanitized(H, "Choose your antenna color", "Antenna Color", current_colors[1])
				if(new_color)
					antennas.Remove(H)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					antennas.accessory_colors = color_list_to_string(current_colors)
					antennas.Insert(H, TRUE, FALSE)
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have antennas!"))

		if("snout")
			var/list/valid_snouts = list("none")
			for(var/snout_path in subtypesof(/datum/sprite_accessory/snout))
				var/datum/sprite_accessory/snout/snout = new snout_path()
				valid_snouts[snout.name] = snout_path

			var/new_style = input(H, "Choose your snout", "Snout Customization") as null|anything in valid_snouts
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/snout/snout = H.getorganslot(ORGAN_SLOT_SNOUT)
					if(snout)
						snout.Remove(H)
						qdel(snout)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/snout/snout = H.getorganslot(ORGAN_SLOT_SNOUT)
					if(!snout)
						snout = new /obj/item/organ/snout()
						snout.Insert(H, TRUE, FALSE)
					snout.accessory_type = valid_snouts[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					snout.build_colors_for_accessory(null)
					H.update_body()
					should_update = TRUE

		if("snout color")
			var/obj/item/organ/snout/snout = H.getorganslot(ORGAN_SLOT_SNOUT)
			if(snout)
				var/list/current_colors = list()
				if(snout.accessory_colors)
					current_colors = color_string_to_list(snout.accessory_colors)
				if(!length(current_colors))
					current_colors = list(H.dna.features["mcolor"] || H.skin_tone || "#FFFFFF")
				var/new_color = color_pick_sanitized(H, "Choose your snout color", "Snout Color", current_colors[1])
				if(new_color)
					snout.Remove(H)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					snout.accessory_colors = color_list_to_string(current_colors)
					snout.Insert(H, TRUE, FALSE)
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have a snout!"))

		if("tail feature")
			var/list/valid_tail_features = list("none")
			for(var/tail_feature_path in subtypesof(/datum/sprite_accessory/tail_feature))
				var/datum/sprite_accessory/tail_feature/tail_feature = new tail_feature_path()
				valid_tail_features[tail_feature.name] = tail_feature_path

			var/new_style = input(H, "Choose your tail feature", "Tail Feature Customization") as null|anything in valid_tail_features
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/tail_feature/tail_feature = H.getorganslot(ORGAN_SLOT_TAIL_FEATURE)
					if(tail_feature)
						tail_feature.Remove(H)
						qdel(tail_feature)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/tail_feature/tail_feature = H.getorganslot(ORGAN_SLOT_TAIL_FEATURE)
					if(!tail_feature)
						tail_feature = new /obj/item/organ/tail_feature()
						tail_feature.Insert(H, TRUE, FALSE)
					tail_feature.accessory_type = valid_tail_features[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					tail_feature.build_colors_for_accessory(null)
					H.update_body()
					should_update = TRUE

		if("tail feature color")
			var/obj/item/organ/tail_feature/tail_feature = H.getorganslot(ORGAN_SLOT_TAIL_FEATURE)
			if(tail_feature)
				var/list/current_colors = list()
				if(tail_feature.accessory_colors)
					current_colors = color_string_to_list(tail_feature.accessory_colors)
				if(!length(current_colors))
					current_colors = list(H.dna.features["mcolor"] || H.skin_tone || "#FFFFFF")
				var/new_color = color_pick_sanitized(H, "Choose your tail feature color", "Tail Feature Color", current_colors[1])
				if(new_color)
					tail_feature.Remove(H)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					tail_feature.accessory_colors = color_list_to_string(current_colors)
					tail_feature.Insert(H, TRUE, FALSE)
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have a tail feature!"))

		if("head feature")
			var/list/valid_head_features = list("none")
			for(var/head_feature_path in subtypesof(/datum/sprite_accessory/head_feature))
				var/datum/sprite_accessory/head_feature/head_feature = new head_feature_path()
				valid_head_features[head_feature.name] = head_feature_path

			var/new_style = input(H, "Choose your head feature", "Head Feature Customization") as null|anything in valid_head_features
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/head_feature/head_feature = H.getorganslot(ORGAN_SLOT_HEAD_FEATURE)
					if(head_feature)
						head_feature.Remove(H)
						qdel(head_feature)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/head_feature/head_feature = H.getorganslot(ORGAN_SLOT_HEAD_FEATURE)
					if(!head_feature)
						head_feature = new /obj/item/organ/head_feature()
						head_feature.Insert(H, TRUE, FALSE)
					head_feature.accessory_type = valid_head_features[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					head_feature.build_colors_for_accessory(null)
					H.update_body()
					should_update = TRUE

		if("head feature color")
			var/obj/item/organ/head_feature/head_feature = H.getorganslot(ORGAN_SLOT_HEAD_FEATURE)
			if(head_feature)
				var/list/current_colors = list()
				if(head_feature.accessory_colors)
					current_colors = color_string_to_list(head_feature.accessory_colors)
				if(!length(current_colors))
					current_colors = list(H.dna.features["mcolor"] || H.skin_tone || "#FFFFFF")
				var/new_color = color_pick_sanitized(H, "Choose your head feature color", "Head Feature Color", current_colors[1])
				if(new_color)
					head_feature.Remove(H)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					head_feature.accessory_colors = color_list_to_string(current_colors)
					head_feature.Insert(H, TRUE, FALSE)
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have a head feature!"))

		if("neck feature")
			var/list/valid_neck_features = list("none")
			for(var/neck_feature_path in subtypesof(/datum/sprite_accessory/neck_feature))
				var/datum/sprite_accessory/neck_feature/neck_feature = new neck_feature_path()
				valid_neck_features[neck_feature.name] = neck_feature_path

			var/new_style = input(H, "Choose your neck feature", "Neck Feature Customization") as null|anything in valid_neck_features
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/neck_feature/neck_feature = H.getorganslot(ORGAN_SLOT_NECK_FEATURE)
					if(neck_feature)
						neck_feature.Remove(H)
						qdel(neck_feature)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/neck_feature/neck_feature = H.getorganslot(ORGAN_SLOT_NECK_FEATURE)
					if(!neck_feature)
						neck_feature = new /obj/item/organ/neck_feature()
						neck_feature.Insert(H, TRUE, FALSE)
					neck_feature.accessory_type = valid_neck_features[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					neck_feature.build_colors_for_accessory(null)
					H.update_body()
					should_update = TRUE

		if("neck feature color")
			var/obj/item/organ/neck_feature/neck_feature = H.getorganslot(ORGAN_SLOT_NECK_FEATURE)
			if(neck_feature)
				var/list/current_colors = list()
				if(neck_feature.accessory_colors)
					current_colors = color_string_to_list(neck_feature.accessory_colors)
				if(!length(current_colors))
					current_colors = list(H.dna.features["mcolor"] || H.skin_tone || "#FFFFFF")
				var/new_color = color_pick_sanitized(H, "Choose your neck feature color", "Neck Feature Color", current_colors[1])
				if(new_color)
					neck_feature.Remove(H)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					neck_feature.accessory_colors = color_list_to_string(current_colors)
					neck_feature.Insert(H, TRUE, FALSE)
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have a neck feature!"))

		if("back feature")
			var/list/valid_back_features = list("none")
			for(var/back_feature_path in subtypesof(/datum/sprite_accessory/back_feature))
				var/datum/sprite_accessory/back_feature/back_feature = new back_feature_path()
				valid_back_features[back_feature.name] = back_feature_path

			var/new_style = input(H, "Choose your back feature", "Back Feature Customization") as null|anything in valid_back_features
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/back_feature/back_feature = H.getorganslot(ORGAN_SLOT_BACK_FEATURE)
					if(back_feature)
						back_feature.Remove(H)
						qdel(back_feature)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/back_feature/back_feature = H.getorganslot(ORGAN_SLOT_BACK_FEATURE)
					if(!back_feature)
						back_feature = new /obj/item/organ/back_feature()
						back_feature.Insert(H, TRUE, FALSE)
					back_feature.accessory_type = valid_back_features[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					back_feature.build_colors_for_accessory(null)
					H.update_body()
					should_update = TRUE

		if("back feature color")
			var/obj/item/organ/back_feature/back_feature = H.getorganslot(ORGAN_SLOT_BACK_FEATURE)
			if(back_feature)
				var/list/current_colors = list()
				if(back_feature.accessory_colors)
					current_colors = color_string_to_list(back_feature.accessory_colors)
				if(!length(current_colors))
					current_colors = list(H.dna.features["mcolor"] || H.skin_tone || "#FFFFFF")
				var/new_color = color_pick_sanitized(H, "Choose your back feature color", "Back Feature Color", current_colors[1])
				if(new_color)
					back_feature.Remove(H)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					back_feature.accessory_colors = color_list_to_string(current_colors)
					back_feature.Insert(H, TRUE, FALSE)
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have a back feature!"))

		if("crest")
			var/datum/customizer_choice/bodypart_feature/crest/crest_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/crest)
			var/list/valid_crests = list("none")
			for(var/crest_type in crest_choice.sprite_accessories)
				var/datum/sprite_accessory/crests/crest = new crest_type()
				valid_crests[crest.name] = crest_type

			var/new_style = input(H, "Choose your crest", "Crest Styling") as null|anything in valid_crests
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					// Remove existing crest if any
					for(var/datum/bodypart_feature/crest/old_crest in head.bodypart_features)
						head.remove_bodypart_feature(old_crest)
						break

					// Add new crest if not "none"
					if(new_style != "none")
						var/datum/bodypart_feature/crest/crest_feature = new()
						crest_feature.set_accessory_type(valid_crests[new_style], H.hair_color, H)
						head.add_bodypart_feature(crest_feature)
					should_update = TRUE

		if("descriptors")
			// Build list of descriptor categories
			var/list/descriptor_categories = list()
			for(var/choice_type in typesof(/datum/descriptor_choice))
				if(is_abstract(choice_type))
					continue
				var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
				descriptor_categories[choice.name] = choice_type
			
			var/chosen_category = input(H, "Which descriptor category?", "Descriptor Category") as null|anything in descriptor_categories
			if(!chosen_category)
				return
			
			var/datum/descriptor_choice/chosen_choice = DESCRIPTOR_CHOICE(descriptor_categories[chosen_category])
			if(!chosen_choice)
				return
			
			// Build list of available descriptors in this category
			var/list/descriptor_options = list()
			for(var/desc_type in chosen_choice.descriptors)
				var/datum/mob_descriptor/desc = MOB_DESCRIPTOR(desc_type)
				descriptor_options[desc.name] = desc_type
			
			var/chosen_descriptor_name = input(H, "Choose your [chosen_category]", "[chosen_category] Selection") as null|anything in descriptor_options
			if(!chosen_descriptor_name)
				return
			
			var/new_descriptor_type = descriptor_options[chosen_descriptor_name]
			
			// Remove old descriptor from the same slot
			var/datum/mob_descriptor/new_desc = MOB_DESCRIPTOR(new_descriptor_type)
			if(H.mob_descriptors)
				for(var/old_desc_type in H.mob_descriptors)
					var/datum/mob_descriptor/old_desc = MOB_DESCRIPTOR(old_desc_type)
					if(old_desc.slot == new_desc.slot)
						H.remove_mob_descriptor(old_desc_type)
						break
			
			// Add new descriptor
			H.add_mob_descriptor(new_descriptor_type)
			to_chat(H, span_notice("Your [chosen_category] has been changed to [chosen_descriptor_name]."))

		if("horns")
			var/list/valid_horns = list("none")
			for(var/horns_path in subtypesof(/datum/sprite_accessory/horns))
				var/datum/sprite_accessory/horns/horns = new horns_path()
				valid_horns[horns.name] = horns_path

			var/new_style = input(H, "Choose your horns", "Horns Customization") as null|anything in valid_horns
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/horns/horns = H.getorganslot(ORGAN_SLOT_HORNS)
					if(horns)
						horns.Remove(H)
						qdel(horns)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/horns/horns = H.getorganslot(ORGAN_SLOT_HORNS)
					if(!horns)
						horns = new /obj/item/organ/horns()
						horns.Insert(H, TRUE, FALSE)
					horns.accessory_type = valid_horns[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					horns.build_colors_for_accessory(null)
					H.update_body()
					should_update = TRUE

		if("horn color")
			var/obj/item/organ/horns/horns = H.getorganslot(ORGAN_SLOT_HORNS)
			if(horns)
				var/list/current_colors = list()
				if(horns.accessory_colors)
					current_colors = color_string_to_list(horns.accessory_colors)
				if(!length(current_colors))
					current_colors = list(H.dna.features["mcolor"] || H.skin_tone || "#FFFFFF")
				var/new_color = color_pick_sanitized(H, "Choose your horn color", "Horn Color", current_colors[1])
				if(new_color)
					horns.Remove(H)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					horns.accessory_colors = color_list_to_string(current_colors)
					horns.Insert(H, TRUE, FALSE)
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have horns!"))


	if(should_update)
		H.update_hair()
		H.update_body()
		H.update_body_parts()
