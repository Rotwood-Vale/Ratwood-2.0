/datum/action/cooldown/spell/mirror_transform
	name = "Mirror Transform"
	desc = "Temporarily grants you the ability to use mirrors to change your appearance."
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	button_icon_state = "mirror"
	sound = 'sound/magic/whiteflame.ogg'

	click_to_activate = TRUE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("Effingo")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 1 SECONDS
	hold_drain = 1
	charge_slowdown = 3
	charge_sound = null
	cooldown_time = 150 SECONDS

	associated_skill = /datum/skill/magic/arcane
	point_cost = 1
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/mirror_transform/cast(atom/cast_on)
	. = ..()
	if(!ishuman(cast_on))
		return FALSE
	var/mob/living/carbon/human/target = cast_on

	ADD_TRAIT(target, TRAIT_MIRROR_MAGIC, TRAIT_GENERIC)
	target.visible_message(span_notice("[target]'s reflection shimmers briefly."), span_notice("You feel a connection to mirrors forming..."))

	addtimer(CALLBACK(src, PROC_REF(remove_mirror_magic), target), 5 MINUTES)
	return TRUE

/datum/action/cooldown/spell/mirror_transform/proc/remove_mirror_magic(mob/living/carbon/human/target)
	if(QDELETED(target))
		return
	REMOVE_TRAIT(target, TRAIT_MIRROR_MAGIC, TRAIT_GENERIC)
	to_chat(target, span_warning("Your connection to mirrors fades away."))

/proc/perform_mirror_transform(mob/living/carbon/human/user)
	// Handles the actual appearance changing part of the spell. For reasons unknown to man, this previously lived exclusively on the mirror object.
	if (!user)
		return
	var/should_update = FALSE
	var/force_bodypart_update = FALSE
	var/list/choices = list("reset appearance", "hairstyle", "facial hairstyle", "accessory", "pubes", "pits", "face detail", "crest", "horns", "horn color", "ears", "ear color one", "ear color two", "tail", "tail color one", "tail color two", "tail feature", "tail feature color", "wings", "wing color one", "wing color two", "frills", "frill color", "antennas", "antenna color", "snout", "snout color", "head feature", "head feature color", "neck feature", "neck feature color", "back feature", "back feature color", "descriptors", "hair color", "facial hair color", "eye color", "skin color", "mutant color", "mutant color 2", "mutant color 3", "natural gradient", "natural gradient color", "dye gradient", "dye gradient color", "penis", "penis color", "penis color 2", "testicles", "testicles color", "breasts", "breasts color", "vagina", "vagina color", "breast size", "penis size", "testicle size")
	var/chosen = input(user, "Change what?", "Appearance") as null|anything in choices

	if(!chosen)
		return

	switch(chosen)
		if("reset appearance")
			if(!user.client?.prefs)
				to_chat(user, span_warning("You don't have character preferences saved!"))
				return

			// Verify this is the same character by checking if the preference slot's name matches
			if(user.get_saved_name() != user.pref_base_name)
				to_chat(user, span_warning("You can only reset to the appearance of the character you are currently playing!"))
				return

			if(alert(user, "Reset your appearance to match your character preferences? This will reapply all physical features, colors, and descriptors but won't change your name, skills, or abilities.", "Reset Appearance", "Yes", "No") != "Yes")
				return

			// Double-check after the alert (in case player switched slots)
			if(!user.client?.prefs || user.get_saved_name() != user.pref_base_name)
				return

			var/original_age = user.age
			user.reapply_preferences()
			user.age = original_age

			to_chat(user, span_notice("Your appearance has been reset to match your character preferences."))
			force_bodypart_update = TRUE
			should_update = TRUE

		if("hairstyle")
			var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
			var/list/valid_hairstyles = list()
			for(var/hair_type in hair_choice.sprite_accessories)
				var/datum/sprite_accessory/hair/head/hair = new hair_type()
				valid_hairstyles[hair.name] = hair_type

			var/new_style = input(user, "Choose your hairstyle", "Hair Styling") as null|anything in valid_hairstyles
			if(new_style)
				var/obj/item/bodypart/head/head = user.get_bodypart(BODY_ZONE_HEAD)
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
						new_hair.set_accessory_type(valid_hairstyles[new_style], hair_entry.hair_color, user)

						hair_choice.customize_feature(new_hair, user, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						user.update_hair()
						should_update = TRUE

		if("hair color")
			var/new_hair_color = color_pick_sanitized(user, "Choose your hair color", "Hair Color", user.hair_color)
			if(new_hair_color)
				var/obj/item/bodypart/head/head = user.get_bodypart(BODY_ZONE_HEAD)
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

						new_hair.set_accessory_type(current_hair.accessory_type, null, user)

						hair_choice.customize_feature(new_hair, user, null, hair_entry)

						user.hair_color = hair_entry.hair_color
						user.dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)

						user.dna.species.handle_body(user)
						user.update_body()
						user.update_hair()
						user.update_body_parts()
						should_update = TRUE

		if("facial hair color")
			var/new_facial_hair_color = color_pick_sanitized(user, "Choose your facial hair color", "Facial Hair Color", user.facial_hair_color)
			if(new_facial_hair_color)
				var/obj/item/bodypart/head/head = user.get_bodypart(BODY_ZONE_HEAD)
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
						new_facial.set_accessory_type(current_facial.accessory_type, null, user)
						facial_choice.customize_feature(new_facial, user, null, facial_entry)

						user.facial_hair_color = facial_entry.hair_color
						user.dna.update_ui_block(DNA_FACIAL_HAIR_COLOR_BLOCK)
						head.remove_bodypart_feature(current_facial)
						head.add_bodypart_feature(new_facial)
						should_update = TRUE

		if("eye color")
			var/new_eye_color = color_pick_sanitized(user, "Choose your eye color", "Eye Color", user.eye_color)
			if(new_eye_color)
				new_eye_color = sanitize_hexcolor(new_eye_color, 6, TRUE)
				var/obj/item/organ/eyes/eyes = user.getorganslot(ORGAN_SLOT_EYES)
				if(eyes)
					eyes.Remove(user)
					eyes.eye_color = new_eye_color
					eyes.Insert(user, TRUE, FALSE)
				user.eye_color = new_eye_color
				user.dna.features["eye_color"] = new_eye_color
				user.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
				user.update_body_parts()
				should_update = TRUE

		if("skin color")
			var/new_color = color_pick_sanitized(user, "Choose your skin color", "Skin Color", user.skin_tone)
			if(new_color)
				user.skin_tone = new_color
				user.update_body()
				should_update = TRUE

		if("mutant color")
			var/new_color = color_pick_sanitized(user, "Choose your mutant color", "Mutant Color", user.dna.features["mcolor"] || "#FFFFFF")
			if(new_color)
				user.dna.features["mcolor"] = new_color
				user.update_body()
				should_update = TRUE

		if("mutant color 2")
			var/new_color = color_pick_sanitized(user, "Choose your mutant color 2", "Mutant Color 2", user.dna.features["mcolor2"] || "#FFFFFF")
			if(new_color)
				user.dna.features["mcolor2"] = new_color
				user.update_body()
				should_update = TRUE

		if("mutant color 3")
			var/new_color = color_pick_sanitized(user, "Choose your mutant color 3", "Mutant Color 3", user.dna.features["mcolor3"] || "#FFFFFF")
			if(new_color)
				user.dna.features["mcolor3"] = new_color
				user.update_body()
				should_update = TRUE

		if("natural gradient")
			var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
			var/list/valid_gradients = list()
			for(var/gradient_type in GLOB.hair_gradients)
				valid_gradients[gradient_type] = gradient_type

			var/new_style = input(user, "Choose your natural gradient", "Hair Gradient") as null|anything in valid_gradients
			if(new_style)
				var/obj/item/bodypart/head/head = user.get_bodypart(BODY_ZONE_HEAD)
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
						new_hair.set_accessory_type(current_hair.accessory_type, null, user)
						hair_choice.customize_feature(new_hair, user, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE

		if("natural gradient color")
			var/new_gradient_color = color_pick_sanitized(user, "Choose your natural gradient color", "Natural Gradient Color", user.hair_color)
			if(new_gradient_color)
				var/obj/item/bodypart/head/head = user.get_bodypart(BODY_ZONE_HEAD)
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
						new_hair.set_accessory_type(current_hair.accessory_type, null, user)
						hair_choice.customize_feature(new_hair, user, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE

		if("dye gradient")
			var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
			var/list/valid_gradients = list()
			for(var/gradient_type in GLOB.hair_gradients)
				valid_gradients[gradient_type] = gradient_type

			var/new_style = input(user, "Choose your dye gradient", "Hair Gradient") as null|anything in valid_gradients
			if(new_style)
				var/obj/item/bodypart/head/head = user.get_bodypart(BODY_ZONE_HEAD)
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
						new_hair.set_accessory_type(current_hair.accessory_type, null, user)
						hair_choice.customize_feature(new_hair, user, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE

		if("dye gradient color")
			var/new_gradient_color = color_pick_sanitized(user, "Choose your dye gradient color", "Dye Gradient Color", user.hair_color)
			if(new_gradient_color)
				var/obj/item/bodypart/head/head = user.get_bodypart(BODY_ZONE_HEAD)
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
						new_hair.set_accessory_type(current_hair.accessory_type, null, user)
						hair_choice.customize_feature(new_hair, user, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE

		if("facial hairstyle")
			var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
			var/list/valid_facial_hairstyles = list()
			for(var/facial_type in facial_choice.sprite_accessories)
				var/datum/sprite_accessory/hair/facial/facial = new facial_type()
				valid_facial_hairstyles[facial.name] = facial_type

			var/new_style = input(user, "Choose your facial hairstyle", "Hair Styling") as null|anything in valid_facial_hairstyles
			if(new_style)
				var/obj/item/bodypart/head/head = user.get_bodypart(BODY_ZONE_HEAD)
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
						new_facial.set_accessory_type(valid_facial_hairstyles[new_style], facial_entry.hair_color, user)

						// Apply all the color data from the entry
						facial_choice.customize_feature(new_facial, user, null, facial_entry)

						head.remove_bodypart_feature(current_facial)
						head.add_bodypart_feature(new_facial)
						user.update_hair()
						should_update = TRUE

		if("accessory")
			var/datum/customizer_choice/bodypart_feature/accessory/accessory_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/accessory)
			var/list/valid_accessories = list("none")
			for(var/accessory_type in accessory_choice.sprite_accessories)
				var/datum/sprite_accessory/accessory/acc = new accessory_type()
				valid_accessories[acc.name] = accessory_type

			var/new_style = input(user, "Choose your accessory", "Accessory Styling") as null|anything in valid_accessories
			if(new_style)
				var/obj/item/bodypart/head/head = user.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					// Remove existing accessory if any
					for(var/datum/bodypart_feature/accessory/old_acc in head.bodypart_features)
						head.remove_bodypart_feature(old_acc)
						break

					// Add new accessory if not "none"
					if(new_style != "none")
						var/datum/bodypart_feature/accessory/accessory_feature = new()
						accessory_feature.set_accessory_type(valid_accessories[new_style], user.hair_color, user)
						head.add_bodypart_feature(accessory_feature)
					should_update = TRUE

		if("face detail")
			var/datum/customizer_choice/bodypart_feature/face_detail/face_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/face_detail)
			var/list/valid_details = list("none")
			for(var/detail_type in face_choice.sprite_accessories)
				var/datum/sprite_accessory/face_detail/detail = new detail_type()
				valid_details[detail.name] = detail_type

			var/new_detail = input(user, "Choose your face detail", "Face Detail") as null|anything in valid_details
			if(new_detail)
				var/obj/item/bodypart/head/head = user.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					// Remove existing face detail if any
					for(var/datum/bodypart_feature/face_detail/old_detail in head.bodypart_features)
						head.remove_bodypart_feature(old_detail)
						break

					// Add new face detail if not "none"
					if(new_detail != "none")
						var/datum/bodypart_feature/face_detail/detail_feature = new()
						detail_feature.set_accessory_type(valid_details[new_detail], user.hair_color, user)
						head.add_bodypart_feature(detail_feature)
					should_update = TRUE

		if("pubes")
			var/list/valid_pubes = list("none")
			for(var/pubes_type in subtypesof(/datum/sprite_accessory/pubes))
				if(is_abstract(pubes_type))
					continue
				var/datum/sprite_accessory/pubes/pube_accessory = SPRITE_ACCESSORY(pubes_type)
				if(!pube_accessory)
					continue
				valid_pubes[pube_accessory.name] = pubes_type

			var/new_pubes = input(user, "Style your pubic hair", "Pube Styling") as null|anything in valid_pubes
			if(new_pubes)
				var/obj/item/bodypart/chest = user.get_bodypart(BODY_ZONE_CHEST)
				if(chest)
					var/datum/bodypart_feature/pubes/current_pubes
					for(var/datum/bodypart_feature/pubes/pubes_feature in chest.bodypart_features)
						current_pubes = pubes_feature
						break

					if(new_pubes == "none")
						if(current_pubes)
							chest.remove_bodypart_feature(current_pubes)
							should_update = TRUE
							force_bodypart_update = TRUE
					else if(current_pubes)
						current_pubes.set_accessory_type(valid_pubes[new_pubes], current_pubes.accessory_colors, user)
						should_update = TRUE
						force_bodypart_update = TRUE
					else
						var/default_material = BODY_HAIR_MATERIAL_HAIR
						var/datum/species/current_species = user.dna.species
						for(var/customizer_type as anything in current_species.customizers)
							if(!ispath(customizer_type, /datum/customizer/bodypart_feature/pubes))
								continue
							var/datum/customizer/bodypart_feature/pubes/pubes_customizer = CUSTOMIZER(customizer_type)
							if(pubes_customizer)
								default_material = pubes_customizer.default_material
							break
						var/datum/bodypart_feature/pubes/pubes_feature = new()
						pubes_feature.set_material(default_material)
						pubes_feature.set_accessory_type(valid_pubes[new_pubes], null, user)
						chest.add_bodypart_feature(pubes_feature)
						should_update = TRUE
						force_bodypart_update = TRUE

		if("pits")
			var/list/valid_pits = list("none")
			for(var/pits_type in subtypesof(/datum/sprite_accessory/pits))
				if(is_abstract(pits_type))
					continue
				var/datum/sprite_accessory/pits/pits_accessory = SPRITE_ACCESSORY(pits_type)
				if(!pits_accessory)
					continue
				valid_pits[pits_accessory.name] = pits_type

			var/new_pits = input(user, "Style your armpit hair", "Pithair Styling") as null|anything in valid_pits
			if(new_pits)
				var/obj/item/bodypart/chest = user.get_bodypart(BODY_ZONE_CHEST)
				if(chest)
					var/datum/bodypart_feature/pits/current_pits
					for(var/datum/bodypart_feature/pits/pits_feature in chest.bodypart_features)
						current_pits = pits_feature
						break

					if(new_pits == "none")
						if(current_pits)
							chest.remove_bodypart_feature(current_pits)
							should_update = TRUE
							force_bodypart_update = TRUE
					else if(current_pits)
						current_pits.set_accessory_type(valid_pits[new_pits], current_pits.accessory_colors, user)
						should_update = TRUE
						force_bodypart_update = TRUE
					else
						var/default_material = BODY_HAIR_MATERIAL_HAIR
						var/datum/species/current_species = user.dna.species
						for(var/customizer_type as anything in current_species.customizers)
							if(!ispath(customizer_type, /datum/customizer/bodypart_feature/pits))
								continue
							var/datum/customizer/bodypart_feature/pits/pits_customizer = CUSTOMIZER(customizer_type)
							if(pits_customizer)
								default_material = pits_customizer.default_material
							break
						var/datum/bodypart_feature/pits/pits_feature = new()
						pits_feature.set_material(default_material)
						pits_feature.set_accessory_type(valid_pits[new_pits], null, user)
						chest.add_bodypart_feature(pits_feature)
						should_update = TRUE
						force_bodypart_update = TRUE

		if("penis")
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

			var/new_style = input(user, "Choose your penis type", "Penis Customization") as null|anything in valid_penis_types
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/penis/penis = user.getorganslot(ORGAN_SLOT_PENIS)
					if(penis)
						penis.Remove(user)
						qdel(penis)
						user.update_body()
						should_update = TRUE
				else
					var/list/selection = valid_penis_types[new_style]
					var/new_organ_type = selection?["organ_type"] || /obj/item/organ/penis
					var/new_accessory_type = selection?["accessory_type"]

					var/obj/item/organ/penis/old_penis = user.getorganslot(ORGAN_SLOT_PENIS)
					var/new_size = old_penis?.penis_size || DEFAULT_PENIS_SIZE
					var/new_functional = isnull(old_penis) ? TRUE : old_penis.functional
					var/new_colors = old_penis?.accessory_colors

					if(old_penis)
						old_penis.Remove(user)
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
					penis.Insert(user, TRUE, FALSE)
					user.update_body()
					should_update = TRUE

		if("penis color")
			var/obj/item/organ/penis/penis = user.getorganslot(ORGAN_SLOT_PENIS)
			if(penis)
				var/list/current_colors = list()
				if(penis.accessory_colors)
					current_colors = color_string_to_list(penis.accessory_colors)
				if(!length(current_colors))
					current_colors = list(user.dna.features["mcolor"] || "#FFFFFF", user.dna.features["mcolor"] || "#FFFFFF")
				var/new_color = color_pick_sanitized(user, "Choose your primary penis color", "Penis Color", current_colors[1])
				if(new_color)
					penis.Remove(user)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					penis.accessory_colors = color_list_to_string(current_colors)
					penis.Insert(user, TRUE, FALSE)
					user.update_body()
					should_update = TRUE
					force_bodypart_update = TRUE
			else
				to_chat(user, span_warning("You don't have a penis!"))

		if("penis color 2")
			var/obj/item/organ/penis/penis = user.getorganslot(ORGAN_SLOT_PENIS)
			if(penis)
				var/list/current_colors = list()
				if(penis.accessory_colors)
					current_colors = color_string_to_list(penis.accessory_colors)
				if(!length(current_colors))
					current_colors = list(user.dna.features["mcolor"] || "#FFFFFF", user.dna.features["mcolor"] || "#FFFFFF")
				var/new_color = color_pick_sanitized(user, "Choose your secondary penis color (sheath/detail)", "Penis Color 2", current_colors[2])
				if(new_color)
					penis.Remove(user)
					current_colors[2] = sanitize_hexcolor(new_color, 6, TRUE)
					penis.accessory_colors = color_list_to_string(current_colors)
					penis.Insert(user, TRUE, FALSE)
					user.update_body()
					should_update = TRUE
					force_bodypart_update = TRUE
			else
				to_chat(user, span_warning("You don't have a penis!"))

		if("testicles")
			var/list/valid_testicle_types = list("none")
			for(var/testicle_path in subtypesof(/datum/sprite_accessory/testicles))
				var/datum/sprite_accessory/testicles/testicles = new testicle_path()
				valid_testicle_types[testicles.name] = testicle_path

			var/new_style = input(user, "Choose your testicles type", "Testicles Customization") as null|anything in valid_testicle_types
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/testicles/testicles = user.getorganslot(ORGAN_SLOT_TESTICLES)
					if(testicles)
						testicles.Remove(user)
						qdel(testicles)
						user.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/testicles/testicles = user.getorganslot(ORGAN_SLOT_TESTICLES)
					if(!testicles)
						testicles = new()
						testicles.Insert(user, TRUE, FALSE)
					testicles.accessory_type = valid_testicle_types[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					testicles.build_colors_for_accessory(null)
					user.update_body()
					should_update = TRUE

		if("testicles color")
			var/obj/item/organ/testicles/testicles = user.getorganslot(ORGAN_SLOT_TESTICLES)
			if(testicles)
				var/list/current_colors = list()
				if(testicles.accessory_colors)
					current_colors = color_string_to_list(testicles.accessory_colors)
				if(!length(current_colors))
					current_colors = list(user.dna.features["mcolor"] || "#FFFFFF")
				var/new_color = color_pick_sanitized(user, "Choose your testicles color", "Testicles Color", current_colors[1])
				if(new_color)
					testicles.Remove(user)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					testicles.accessory_colors = color_list_to_string(current_colors)
					testicles.Insert(user, TRUE, FALSE)
					user.update_body()
					should_update = TRUE
			else
				to_chat(user, span_warning("You don't have testicles!"))

		if("breasts")
			var/list/valid_breast_types = list("none")
			for(var/breast_path in subtypesof(/datum/sprite_accessory/breasts))
				var/datum/sprite_accessory/breasts/breasts = new breast_path()
				valid_breast_types[breasts.name] = breast_path

			var/new_style = input(user, "Choose your breast type", "Breast Customization") as null|anything in valid_breast_types

			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/breasts/breasts = user.getorganslot(ORGAN_SLOT_BREASTS)
					if(breasts)
						breasts.Remove(user)
						qdel(breasts)
						user.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/breasts/breasts = user.getorganslot(ORGAN_SLOT_BREASTS)
					if(!breasts)
						breasts = new()
						breasts.Insert(user, TRUE, FALSE)

					breasts.accessory_type = valid_breast_types[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					breasts.build_colors_for_accessory(null)
					user.update_body()
					should_update = TRUE

		if("breasts color")
			var/obj/item/organ/breasts/breasts = user.getorganslot(ORGAN_SLOT_BREASTS)
			if(breasts)
				var/list/current_colors = list()
				if(breasts.accessory_colors)
					current_colors = color_string_to_list(breasts.accessory_colors)
				if(!length(current_colors))
					current_colors = list(user.dna.features["mcolor"] || "#FFFFFF")
				var/new_color = color_pick_sanitized(user, "Choose your breasts color", "Breasts Color", current_colors[1])
				if(new_color)
					breasts.Remove(user)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					breasts.accessory_colors = color_list_to_string(current_colors)
					breasts.Insert(user, TRUE, FALSE)
					user.update_body()
					should_update = TRUE
			else
				to_chat(user, span_warning("You don't have breasts!"))

		if("vagina")
			var/list/valid_vagina_types = list("none")
			for(var/vagina_path in subtypesof(/datum/sprite_accessory/vagina))
				var/datum/sprite_accessory/vagina/vagina = new vagina_path()
				valid_vagina_types[vagina.name] = vagina_path

			var/new_style = input(user, "Choose your vagina type", "Vagina Customization") as null|anything in valid_vagina_types

			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/vagina/vagina = user.getorganslot(ORGAN_SLOT_VAGINA)
					if(vagina)
						vagina.Remove(user)
						qdel(vagina)
						user.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/vagina/vagina = user.getorganslot(ORGAN_SLOT_VAGINA)
					if(!vagina)
						vagina = new()
						vagina.Insert(user, TRUE, FALSE)
					vagina.accessory_type = valid_vagina_types[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					vagina.build_colors_for_accessory(null)
					user.update_body()
					should_update = TRUE

		if("vagina color")
			var/obj/item/organ/vagina/vagina = user.getorganslot(ORGAN_SLOT_VAGINA)
			if(vagina)
				var/list/current_colors = list()
				if(vagina.accessory_colors)
					current_colors = color_string_to_list(vagina.accessory_colors)
				if(!length(current_colors))
					current_colors = list(user.dna.features["mcolor"] || "#FFFFFF")
				var/new_color = color_pick_sanitized(user, "Choose your vagina color", "Vagina Color", current_colors[1])
				if(new_color)
					vagina.Remove(user)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					vagina.accessory_colors = color_list_to_string(current_colors)
					vagina.Insert(user, TRUE, FALSE)
					user.update_body()
					should_update = TRUE
			else
				to_chat(user, span_warning("You don't have a vagina!"))

		if("breast size")
			var/list/breast_sizes = list("Flat", "Slight", "Small", "Moderate", "Large", "Generous", "Heavy", "Massive", "Heaping", "Obscene")
			var/new_size = input(user, "Choose your breast size", "Breast Size") as null|anything in breast_sizes
			if(new_size)
				var/obj/item/organ/breasts/breasts = user.getorganslot(ORGAN_SLOT_BREASTS)
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
					user.update_body()
					should_update = TRUE

		if("penis size")
			var/list/penis_sizes = list("small", "average", "large")
			var/new_size = input(user, "Choose your penis size", "Penis Size") as null|anything in penis_sizes
			if(new_size)
				var/obj/item/organ/penis/penis = user.getorganslot(ORGAN_SLOT_PENIS)
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
					user.update_body()
					should_update = TRUE
					force_bodypart_update = TRUE

		if("testicle size")
			var/list/testicle_sizes = list("small", "average", "large")
			var/new_size = input(user, "Choose your testicle size", "Testicle Size") as null|anything in testicle_sizes
			if(new_size)
				var/obj/item/organ/testicles/testicles = user.getorganslot(ORGAN_SLOT_TESTICLES)
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
					user.update_body()
					should_update = TRUE
					force_bodypart_update = TRUE

		if("tail")
			var/list/valid_tails = list("none")
			for(var/tail_path in subtypesof(/datum/sprite_accessory/tail))
				var/datum/sprite_accessory/tail/tail = new tail_path()
				valid_tails[tail.name] = tail_path

			var/new_style = input(user, "Choose your tail", "Tail Customization") as null|anything in valid_tails
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/tail/tail = user.getorganslot(ORGAN_SLOT_TAIL)
					if(tail)
						tail.Remove(user)
						qdel(tail)
						user.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/tail/tail = user.getorganslot(ORGAN_SLOT_TAIL)
					var/new_accessory_type = valid_tails[new_style]
					var/wants_tail_maw = new_accessory_type == /datum/sprite_accessory/tail/manticore
					if(!tail || wants_tail_maw != istype(tail, /obj/item/organ/tail/manticore))
						var/new_tail_type = wants_tail_maw ? /obj/item/organ/tail/manticore : /obj/item/organ/tail/anthro
						tail = new new_tail_type()
						tail.Insert(user, TRUE, FALSE)
					tail.accessory_type = new_accessory_type
					// Use build_colors_for_accessory to properly set colors from character
					tail.build_colors_for_accessory(null)
					user.update_body()
					should_update = TRUE

		if("tail color one")
			var/obj/item/organ/tail/tail = user.getorganslot(ORGAN_SLOT_TAIL)
			if(tail)
				var/list/current_colors = list()
				if(tail.accessory_colors)
					current_colors = color_string_to_list(tail.accessory_colors)
				if(!length(current_colors))
					current_colors = list(user.dna.features["mcolor"] || "#FFFFFF", user.dna.features["mcolor"] || "#FFFFFF")
				var/new_color = color_pick_sanitized(user, "Choose your primary tail color", "Tail Color One", current_colors[1])
				if(new_color)
					tail.Remove(user)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					tail.accessory_colors = color_list_to_string(current_colors)
					tail.Insert(user, TRUE, FALSE)
					user.dna.features["tail_color"] = current_colors[1]  // Update DNA features
					user.update_body()
					should_update = TRUE
			else
				to_chat(user, span_warning("You don't have a tail!"))

		if("tail color two")
			var/obj/item/organ/tail/tail = user.getorganslot(ORGAN_SLOT_TAIL)
			if(tail)
				var/list/current_colors = list()
				if(tail.accessory_colors)
					current_colors = color_string_to_list(tail.accessory_colors)
				if(!length(current_colors))
					current_colors = list(user.dna.features["mcolor"] || "#FFFFFF", user.dna.features["mcolor"] || "#FFFFFF")
				var/new_color = color_pick_sanitized(user, "Choose your secondary tail color", "Tail Color Two", current_colors[2])
				if(new_color)
					tail.Remove(user)
					current_colors[2] = sanitize_hexcolor(new_color, 6, TRUE)
					tail.accessory_colors = color_list_to_string(current_colors)
					tail.Insert(user, TRUE, FALSE)
					user.dna.features["tail_color2"] = current_colors[2]  // Update DNA features
					user.update_body()
					should_update = TRUE
			else
				to_chat(user, span_warning("You don't have a tail!"))

		if("ears")
			var/list/valid_ears = list("none")
			for(var/ears_path in subtypesof(/datum/sprite_accessory/ears))
				var/datum/sprite_accessory/ears/ears = new ears_path()
				valid_ears[ears.name] = ears_path

			var/new_style = input(user, "Choose your ears", "Ears Customization") as null|anything in valid_ears
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/ears/ears = user.getorganslot(ORGAN_SLOT_EARS)
					if(ears)
						ears.Remove(user)
						qdel(ears)
						user.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/ears/ears = user.getorganslot(ORGAN_SLOT_EARS)
					if(!ears)
						ears = new /obj/item/organ/ears()
						ears.Insert(user, TRUE, FALSE)
					ears.accessory_type = valid_ears[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					ears.build_colors_for_accessory(null)
					user.update_body()
					should_update = TRUE

		if("ear color one")
			var/obj/item/organ/ears/ears = user.getorganslot(ORGAN_SLOT_EARS)
			if(ears)
				var/list/current_colors = list()
				if(ears.accessory_colors)
					current_colors = color_string_to_list(ears.accessory_colors)
				if(!length(current_colors))
					current_colors = list(user.dna.features["mcolor"] || "#FFFFFF", user.dna.features["mcolor"] || "#FFFFFF")
				var/new_color = color_pick_sanitized(user, "Choose your primary ear color", "Ear Color One", current_colors[1])
				if(new_color)
					ears.Remove(user)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					ears.accessory_colors = color_list_to_string(current_colors)
					ears.Insert(user, TRUE, FALSE)
					user.dna.features["ears_color"] = current_colors[1]  // Update DNA features
					user.update_body()
					should_update = TRUE
			else
				to_chat(user, span_warning("You don't have ears!"))

		if("ear color two")
			var/obj/item/organ/ears/ears = user.getorganslot(ORGAN_SLOT_EARS)
			if(ears)
				var/list/current_colors = list()
				if(ears.accessory_colors)
					current_colors = color_string_to_list(ears.accessory_colors)
				if(!length(current_colors))
					current_colors = list(user.dna.features["mcolor"] || "#FFFFFF", user.dna.features["mcolor"] || "#FFFFFF")
				var/new_color = color_pick_sanitized(user, "Choose your secondary ear color", "Ear Color Two", current_colors[2])
				if(new_color)
					ears.Remove(user)
					current_colors[2] = sanitize_hexcolor(new_color, 6, TRUE)
					ears.accessory_colors = color_list_to_string(current_colors)
					ears.Insert(user, TRUE, FALSE)
					user.dna.features["ears_color2"] = current_colors[2]  // Update DNA features
					user.update_body()
					should_update = TRUE
			else
				to_chat(user, span_warning("You don't have ears!"))

		if("wings")
			var/list/valid_wings = list("none")
			for(var/wings_path in subtypesof(/datum/sprite_accessory/wings))
				var/datum/sprite_accessory/wings/wings = new wings_path()
				valid_wings[wings.name] = wings_path

			var/new_style = input(user, "Choose your wings", "Wings Customization") as null|anything in valid_wings
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/wings/wings = user.getorganslot(ORGAN_SLOT_WINGS)
					if(wings)
						wings.Remove(user)
						qdel(wings)
						user.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/wings/wings = user.getorganslot(ORGAN_SLOT_WINGS)
					if(!wings)
						wings = new /obj/item/organ/wings()
						wings.Insert(user, TRUE, FALSE)
					wings.accessory_type = valid_wings[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					wings.build_colors_for_accessory(null)
					user.update_body()
					should_update = TRUE

		if("wing color one")
			var/obj/item/organ/wings/wings = user.getorganslot(ORGAN_SLOT_WINGS)
			if(wings)
				var/list/current_colors = list()
				if(wings.accessory_colors)
					current_colors = color_string_to_list(wings.accessory_colors)
				if(!length(current_colors))
					current_colors = list(user.dna.features["mcolor"] || "#FFFFFF", user.dna.features["mcolor"] || "#FFFFFF")
				var/new_color = color_pick_sanitized(user, "Choose your primary wing color", "Wing Color One", current_colors[1])
				if(new_color)
					wings.Remove(user)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					wings.accessory_colors = color_list_to_string(current_colors)
					wings.Insert(user, TRUE, FALSE)
					user.update_body()
					should_update = TRUE
			else
				to_chat(user, span_warning("You don't have wings!"))

		if("wing color two")
			var/obj/item/organ/wings/wings = user.getorganslot(ORGAN_SLOT_WINGS)
			if(wings)
				var/list/current_colors = list()
				if(wings.accessory_colors)
					current_colors = color_string_to_list(wings.accessory_colors)
				if(!length(current_colors))
					current_colors = list(user.dna.features["mcolor"] || "#FFFFFF", user.dna.features["mcolor"] || "#FFFFFF")
				var/new_color = color_pick_sanitized(user, "Choose your secondary wing color", "Wing Color Two", current_colors[2])
				if(new_color)
					wings.Remove(user)
					current_colors[2] = sanitize_hexcolor(new_color, 6, TRUE)
					wings.accessory_colors = color_list_to_string(current_colors)
					wings.Insert(user, TRUE, FALSE)
					user.update_body()
					should_update = TRUE
			else
				to_chat(user, span_warning("You don't have wings!"))

		if("frills")
			var/list/valid_frills = list("none")
			for(var/frills_path in subtypesof(/datum/sprite_accessory/frills))
				var/datum/sprite_accessory/frills/frills = new frills_path()
				valid_frills[frills.name] = frills_path

			var/new_style = input(user, "Choose your frills", "Frills Customization") as null|anything in valid_frills
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/frills/frills = user.getorganslot(ORGAN_SLOT_FRILLS)
					if(frills)
						frills.Remove(user)
						qdel(frills)
						user.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/frills/frills = user.getorganslot(ORGAN_SLOT_FRILLS)
					if(!frills)
						frills = new /obj/item/organ/frills()
						frills.Insert(user, TRUE, FALSE)
					frills.accessory_type = valid_frills[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					frills.build_colors_for_accessory(null)
					user.update_body()
					should_update = TRUE

		if("frill color")
			var/obj/item/organ/frills/frills = user.getorganslot(ORGAN_SLOT_FRILLS)
			if(frills)
				var/list/current_colors = list()
				if(frills.accessory_colors)
					current_colors = color_string_to_list(frills.accessory_colors)
				if(!length(current_colors))
					current_colors = list(user.dna.features["mcolor"] || user.skin_tone || "#FFFFFF")
				var/new_color = color_pick_sanitized(user, "Choose your frill color", "Frill Color", current_colors[1])
				if(new_color)
					frills.Remove(user)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					frills.accessory_colors = color_list_to_string(current_colors)
					frills.Insert(user, TRUE, FALSE)
					user.update_body()
					should_update = TRUE
			else
				to_chat(user, span_warning("You don't have frills!"))

		if("antennas")
			var/list/valid_antennas = list("none")
			for(var/antennas_path in subtypesof(/datum/sprite_accessory/antenna))
				var/datum/sprite_accessory/antenna/antennas = new antennas_path()
				valid_antennas[antennas.name] = antennas_path

			var/new_style = input(user, "Choose your antennas", "Antennas Customization") as null|anything in valid_antennas
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/antennas/antennas = user.getorganslot(ORGAN_SLOT_ANTENNAS)
					if(antennas)
						antennas.Remove(user)
						qdel(antennas)
						user.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/antennas/antennas = user.getorganslot(ORGAN_SLOT_ANTENNAS)
					if(!antennas)
						antennas = new /obj/item/organ/antennas()
						antennas.Insert(user, TRUE, FALSE)
					antennas.accessory_type = valid_antennas[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					antennas.build_colors_for_accessory(null)
					user.update_body()
					should_update = TRUE

		if("antenna color")
			var/obj/item/organ/antennas/antennas = user.getorganslot(ORGAN_SLOT_ANTENNAS)
			if(antennas)
				var/list/current_colors = list()
				if(antennas.accessory_colors)
					current_colors = color_string_to_list(antennas.accessory_colors)
				if(!length(current_colors))
					current_colors = list(user.dna.features["mcolor"] || user.skin_tone || "#FFFFFF")
				var/new_color = color_pick_sanitized(user, "Choose your antenna color", "Antenna Color", current_colors[1])
				if(new_color)
					antennas.Remove(user)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					antennas.accessory_colors = color_list_to_string(current_colors)
					antennas.Insert(user, TRUE, FALSE)
					user.update_body()
					should_update = TRUE
			else
				to_chat(user, span_warning("You don't have antennas!"))

		if("snout")
			var/list/valid_snouts = list("none")
			for(var/snout_path in subtypesof(/datum/sprite_accessory/snout))
				var/datum/sprite_accessory/snout/snout = new snout_path()
				valid_snouts[snout.name] = snout_path

			var/new_style = input(user, "Choose your snout", "Snout Customization") as null|anything in valid_snouts
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/snout/snout = user.getorganslot(ORGAN_SLOT_SNOUT)
					if(snout)
						snout.Remove(user)
						qdel(snout)
						user.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/snout/snout = user.getorganslot(ORGAN_SLOT_SNOUT)
					if(!snout)
						snout = new /obj/item/organ/snout()
						snout.Insert(user, TRUE, FALSE)
					snout.accessory_type = valid_snouts[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					snout.build_colors_for_accessory(null)
					user.update_body()
					should_update = TRUE

		if("snout color")
			var/obj/item/organ/snout/snout = user.getorganslot(ORGAN_SLOT_SNOUT)
			if(snout)
				var/list/current_colors = list()
				if(snout.accessory_colors)
					current_colors = color_string_to_list(snout.accessory_colors)
				if(!length(current_colors))
					current_colors = list(user.dna.features["mcolor"] || user.skin_tone || "#FFFFFF")
				var/new_color = color_pick_sanitized(user, "Choose your snout color", "Snout Color", current_colors[1])
				if(new_color)
					snout.Remove(user)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					snout.accessory_colors = color_list_to_string(current_colors)
					snout.Insert(user, TRUE, FALSE)
					user.update_body()
					should_update = TRUE
			else
				to_chat(user, span_warning("You don't have a snout!"))

		if("tail feature")
			var/list/valid_tail_features = list("none")
			for(var/tail_feature_path in subtypesof(/datum/sprite_accessory/tail_feature))
				var/datum/sprite_accessory/tail_feature/tail_feature = new tail_feature_path()
				valid_tail_features[tail_feature.name] = tail_feature_path

			var/new_style = input(user, "Choose your tail feature", "Tail Feature Customization") as null|anything in valid_tail_features
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/tail_feature/tail_feature = user.getorganslot(ORGAN_SLOT_TAIL_FEATURE)
					if(tail_feature)
						tail_feature.Remove(user)
						qdel(tail_feature)
						user.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/tail_feature/tail_feature = user.getorganslot(ORGAN_SLOT_TAIL_FEATURE)
					if(!tail_feature)
						tail_feature = new /obj/item/organ/tail_feature()
						tail_feature.Insert(user, TRUE, FALSE)
					tail_feature.accessory_type = valid_tail_features[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					tail_feature.build_colors_for_accessory(null)
					user.update_body()
					should_update = TRUE

		if("tail feature color")
			var/obj/item/organ/tail_feature/tail_feature = user.getorganslot(ORGAN_SLOT_TAIL_FEATURE)
			if(tail_feature)
				var/list/current_colors = list()
				if(tail_feature.accessory_colors)
					current_colors = color_string_to_list(tail_feature.accessory_colors)
				if(!length(current_colors))
					current_colors = list(user.dna.features["mcolor"] || user.skin_tone || "#FFFFFF")
				var/new_color = color_pick_sanitized(user, "Choose your tail feature color", "Tail Feature Color", current_colors[1])
				if(new_color)
					tail_feature.Remove(user)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					tail_feature.accessory_colors = color_list_to_string(current_colors)
					tail_feature.Insert(user, TRUE, FALSE)
					user.update_body()
					should_update = TRUE
			else
				to_chat(user, span_warning("You don't have a tail feature!"))

		if("head feature")
			var/list/valid_head_features = list("none")
			for(var/head_feature_path in subtypesof(/datum/sprite_accessory/head_feature))
				var/datum/sprite_accessory/head_feature/head_feature = new head_feature_path()
				valid_head_features[head_feature.name] = head_feature_path

			var/new_style = input(user, "Choose your head feature", "Head Feature Customization") as null|anything in valid_head_features
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/head_feature/head_feature = user.getorganslot(ORGAN_SLOT_HEAD_FEATURE)
					if(head_feature)
						head_feature.Remove(user)
						qdel(head_feature)
						user.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/head_feature/head_feature = user.getorganslot(ORGAN_SLOT_HEAD_FEATURE)
					if(!head_feature)
						head_feature = new /obj/item/organ/head_feature()
						head_feature.Insert(user, TRUE, FALSE)
					head_feature.accessory_type = valid_head_features[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					head_feature.build_colors_for_accessory(null)
					user.update_body()
					should_update = TRUE

		if("head feature color")
			var/obj/item/organ/head_feature/head_feature = user.getorganslot(ORGAN_SLOT_HEAD_FEATURE)
			if(head_feature)
				var/list/current_colors = list()
				if(head_feature.accessory_colors)
					current_colors = color_string_to_list(head_feature.accessory_colors)
				if(!length(current_colors))
					current_colors = list(user.dna.features["mcolor"] || user.skin_tone || "#FFFFFF")
				var/new_color = color_pick_sanitized(user, "Choose your head feature color", "Head Feature Color", current_colors[1])
				if(new_color)
					head_feature.Remove(user)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					head_feature.accessory_colors = color_list_to_string(current_colors)
					head_feature.Insert(user, TRUE, FALSE)
					user.update_body()
					should_update = TRUE
			else
				to_chat(user, span_warning("You don't have a head feature!"))

		if("neck feature")
			var/list/valid_neck_features = list("none")
			for(var/neck_feature_path in subtypesof(/datum/sprite_accessory/neck_feature))
				var/datum/sprite_accessory/neck_feature/neck_feature = new neck_feature_path()
				valid_neck_features[neck_feature.name] = neck_feature_path

			var/new_style = input(user, "Choose your neck feature", "Neck Feature Customization") as null|anything in valid_neck_features
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/neck_feature/neck_feature = user.getorganslot(ORGAN_SLOT_NECK_FEATURE)
					if(neck_feature)
						neck_feature.Remove(user)
						qdel(neck_feature)
						user.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/neck_feature/neck_feature = user.getorganslot(ORGAN_SLOT_NECK_FEATURE)
					if(!neck_feature)
						neck_feature = new /obj/item/organ/neck_feature()
						neck_feature.Insert(user, TRUE, FALSE)
					neck_feature.accessory_type = valid_neck_features[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					neck_feature.build_colors_for_accessory(null)
					user.update_body()
					should_update = TRUE

		if("neck feature color")
			var/obj/item/organ/neck_feature/neck_feature = user.getorganslot(ORGAN_SLOT_NECK_FEATURE)
			if(neck_feature)
				var/list/current_colors = list()
				if(neck_feature.accessory_colors)
					current_colors = color_string_to_list(neck_feature.accessory_colors)
				if(!length(current_colors))
					current_colors = list(user.dna.features["mcolor"] || user.skin_tone || "#FFFFFF")
				var/new_color = color_pick_sanitized(user, "Choose your neck feature color", "Neck Feature Color", current_colors[1])
				if(new_color)
					neck_feature.Remove(user)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					neck_feature.accessory_colors = color_list_to_string(current_colors)
					neck_feature.Insert(user, TRUE, FALSE)
					user.update_body()
					should_update = TRUE
			else
				to_chat(user, span_warning("You don't have a neck feature!"))

		if("back feature")
			var/list/valid_back_features = list("none")
			for(var/back_feature_path in subtypesof(/datum/sprite_accessory/back_feature))
				var/datum/sprite_accessory/back_feature/back_feature = new back_feature_path()
				valid_back_features[back_feature.name] = back_feature_path

			var/new_style = input(user, "Choose your back feature", "Back Feature Customization") as null|anything in valid_back_features
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/back_feature/back_feature = user.getorganslot(ORGAN_SLOT_BACK_FEATURE)
					if(back_feature)
						back_feature.Remove(user)
						qdel(back_feature)
						user.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/back_feature/back_feature = user.getorganslot(ORGAN_SLOT_BACK_FEATURE)
					if(!back_feature)
						back_feature = new /obj/item/organ/back_feature()
						back_feature.Insert(user, TRUE, FALSE)
					back_feature.accessory_type = valid_back_features[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					back_feature.build_colors_for_accessory(null)
					user.update_body()
					should_update = TRUE

		if("back feature color")
			var/obj/item/organ/back_feature/back_feature = user.getorganslot(ORGAN_SLOT_BACK_FEATURE)
			if(back_feature)
				var/list/current_colors = list()
				if(back_feature.accessory_colors)
					current_colors = color_string_to_list(back_feature.accessory_colors)
				if(!length(current_colors))
					current_colors = list(user.dna.features["mcolor"] || user.skin_tone || "#FFFFFF")
				var/new_color = color_pick_sanitized(user, "Choose your back feature color", "Back Feature Color", current_colors[1])
				if(new_color)
					back_feature.Remove(user)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					back_feature.accessory_colors = color_list_to_string(current_colors)
					back_feature.Insert(user, TRUE, FALSE)
					user.update_body()
					should_update = TRUE
			else
				to_chat(user, span_warning("You don't have a back feature!"))

		if("crest")
			var/datum/customizer_choice/bodypart_feature/crest/crest_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/crest)
			var/list/valid_crests = list("none")
			for(var/crest_type in crest_choice.sprite_accessories)
				var/datum/sprite_accessory/crests/crest = new crest_type()
				valid_crests[crest.name] = crest_type

			var/new_style = input(user, "Choose your crest", "Crest Styling") as null|anything in valid_crests
			if(new_style)
				var/obj/item/bodypart/head/head = user.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					// Remove existing crest if any
					for(var/datum/bodypart_feature/crest/old_crest in head.bodypart_features)
						head.remove_bodypart_feature(old_crest)
						break

					// Add new crest if not "none"
					if(new_style != "none")
						var/datum/bodypart_feature/crest/crest_feature = new()
						crest_feature.set_accessory_type(valid_crests[new_style], user.hair_color, user)
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

			var/chosen_category = input(user, "Which descriptor category?", "Descriptor Category") as null|anything in descriptor_categories
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

			var/chosen_descriptor_name = input(user, "Choose your [chosen_category]", "[chosen_category] Selection") as null|anything in descriptor_options
			if(!chosen_descriptor_name)
				return

			var/new_descriptor_type = descriptor_options[chosen_descriptor_name]

			// Remove old descriptor from the same slot
			var/datum/mob_descriptor/new_desc = MOB_DESCRIPTOR(new_descriptor_type)
			if(user.mob_descriptors)
				for(var/old_desc_type in user.mob_descriptors)
					var/datum/mob_descriptor/old_desc = MOB_DESCRIPTOR(old_desc_type)
					if(old_desc.slot == new_desc.slot)
						user.remove_mob_descriptor(old_desc_type)
						break

			// Add new descriptor
			user.add_mob_descriptor(new_descriptor_type)
			to_chat(user, span_notice("Your [chosen_category] has been changed to [chosen_descriptor_name]."))

		if("horns")
			var/list/valid_horns = list("none")
			for(var/horns_path in subtypesof(/datum/sprite_accessory/horns))
				var/datum/sprite_accessory/horns/horns = new horns_path()
				valid_horns[horns.name] = horns_path

			var/new_style = input(user, "Choose your horns", "Horns Customization") as null|anything in valid_horns
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/horns/horns = user.getorganslot(ORGAN_SLOT_HORNS)
					if(horns)
						horns.Remove(user)
						qdel(horns)
						user.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/horns/horns = user.getorganslot(ORGAN_SLOT_HORNS)
					if(!horns)
						horns = new /obj/item/organ/horns()
						horns.Insert(user, TRUE, FALSE)
					horns.accessory_type = valid_horns[new_style]
					// Use build_colors_for_accessory to properly set colors from character
					horns.build_colors_for_accessory(null)
					user.update_body()
					should_update = TRUE

		if("horn color")
			var/obj/item/organ/horns/horns = user.getorganslot(ORGAN_SLOT_HORNS)
			if(horns)
				var/list/current_colors = list()
				if(horns.accessory_colors)
					current_colors = color_string_to_list(horns.accessory_colors)
				if(!length(current_colors))
					current_colors = list(user.dna.features["mcolor"] || user.skin_tone || "#FFFFFF")
				var/new_color = color_pick_sanitized(user, "Choose your horn color", "Horn Color", current_colors[1])
				if(new_color)
					horns.Remove(user)
					current_colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					horns.accessory_colors = color_list_to_string(current_colors)
					horns.Insert(user, TRUE, FALSE)
					user.update_body()
					should_update = TRUE
			else
				to_chat(user, span_warning("You don't have horns!"))

	if(should_update)
		user.update_hair()
		user.update_body()
		user.update_body_parts(force_bodypart_update)
		if(user.sexcon)
			user.sexcon.update_erect_state()
