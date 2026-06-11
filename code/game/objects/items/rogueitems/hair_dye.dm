/obj/item/hair_dye_cream
	name = "染发膏"
	desc = "一种可用多种颜色与渐变来染发并做造型的膏体。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "cream"
	dropshrink = 0.8
	w_class = WEIGHT_CLASS_SMALL
	var/uses_remaining = 30
	grid_width = 32
	grid_height = 32

/obj/item/hair_dye_cream/attack(mob/living/M, mob/living/user)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	
	var/list/choices = list("头发颜色", "胡须颜色", "自然渐变", "自然渐变颜色", "染色渐变", "染色渐变颜色")
	var/chosen = input(user, "你想染哪里？", "染发") as null|anything in choices
	
	if(!chosen || !user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
		
	switch(chosen)
		if("头发颜色")
			var/new_hair_color = color_pick_sanitized(user, "选择头发颜色", "头发颜色", H.hair_color)
			if(new_hair_color)
				if(!do_after(user, 30 SECONDS, target = H))
					to_chat(user, span_warning("染发被打断了！"))
					return
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
						hair_entry.natural_gradient = current_hair.natural_gradient
						hair_entry.natural_color = current_hair.natural_color
						hair_entry.dye_gradient = current_hair.hair_dye_gradient
						hair_entry.dye_color = current_hair.hair_dye_color
						hair_entry.accessory_type = current_hair.accessory_type
						
						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(current_hair.accessory_type, null, H)
						hair_choice.customize_feature(new_hair, H, null, hair_entry)
						
						H.hair_color = hair_entry.hair_color
						H.dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						use_cream()
						H.dna.species.handle_body(H)
						H.update_body()
						H.update_hair()
						H.update_body_parts()
						user.visible_message(span_notice("[user]给[H]染了头发。"), span_notice("你给[H == user ? "自己" : "[H]"]染了头发。"))

		if("胡须颜色")
			var/new_facial_color = color_pick_sanitized(user, "选择胡须颜色", "胡须颜色", H.facial_hair_color)
			if(new_facial_color)
				if(!do_after(user, 30 SECONDS, target = H))
					to_chat(user, span_warning("染发被打断了！"))
					return
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
					var/datum/customizer_entry/hair/facial/facial_entry = new()
					facial_entry.hair_color = sanitize_hexcolor(new_facial_color, 6, TRUE)
					
					var/datum/bodypart_feature/hair/facial/current_facial = null
					for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
						current_facial = facial_feature
						break
					
					if(current_facial)
						facial_entry.accessory_type = current_facial.accessory_type
						
						var/datum/bodypart_feature/hair/facial/new_facial = new()
						new_facial.set_accessory_type(current_facial.accessory_type, null, H)
						facial_choice.customize_feature(new_facial, H, null, facial_entry)
						
						H.facial_hair_color = facial_entry.hair_color
						H.dna.update_ui_block(DNA_FACIAL_HAIR_COLOR_BLOCK)
						head.remove_bodypart_feature(current_facial)
						head.add_bodypart_feature(new_facial)
						use_cream()
						H.update_body()
						H.update_hair()
						H.update_body_parts()
						user.visible_message(span_notice("[user]给[H]染了胡须。"), span_notice("你给[H == user ? "自己" : "[H]"]染了胡须。"))

		if("自然渐变")
			var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
			var/list/valid_gradients = list()
			for(var/gradient_type in GLOB.hair_gradients)
				valid_gradients[gradient_type] = gradient_type
			
			var/new_style = input(user, "选择自然渐变", "头发渐变") as null|anything in valid_gradients
			if(new_style)
				if(!do_after(user, 30 SECONDS, target = H))
					to_chat(user, span_warning("染发被打断了！"))
					return
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
						use_cream()
						H.update_hair()
						user.visible_message(span_notice("[user]给[H]染了自然渐变。"), span_notice("你给[H == user ? "自己" : "[H]"]染了自然渐变。"))

		if("自然渐变颜色")
			var/new_gradient_color = color_pick_sanitized(user, "选择自然渐变颜色", "自然渐变颜色", H.hair_color)
			if(new_gradient_color)
				if(!do_after(user, 30 SECONDS, target = H))
					to_chat(user, span_warning("染发被打断了！"))
					return
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
						use_cream()
						H.update_hair()
						user.visible_message(span_notice("[user]给[H]染了自然渐变。"), span_notice("你给[H == user ? "自己" : "[H]"]染了自然渐变。"))

		if("染色渐变")
			var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
			var/list/valid_gradients = list()
			for(var/gradient_type in GLOB.hair_gradients)
				valid_gradients[gradient_type] = gradient_type
			
			var/new_style = input(user, "选择染色渐变", "头发渐变") as null|anything in valid_gradients
			if(new_style)
				if(!do_after(user, 30 SECONDS, target = H))
					to_chat(user, span_warning("染发被打断了！"))
					return
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
						use_cream()
						H.update_hair()
						user.visible_message(span_notice("[user]给[H]染了渐变。"), span_notice("你给[H == user ? "自己" : "[H]"]染了渐变。"))

		if("染色渐变颜色")
			var/new_gradient_color = color_pick_sanitized(user, "选择染色渐变颜色", "染色渐变颜色", H.hair_color)
			if(new_gradient_color)
				if(!do_after(user, 30 SECONDS, target = H))
					to_chat(user, span_warning("染发被打断了！"))
					return
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
						use_cream()
						H.update_hair()
						user.visible_message(span_notice("[user]给[H]染了渐变。"), span_notice("你给[H == user ? "自己" : "[H]"]染了渐变。"))

/obj/item/hair_dye_cream/proc/use_cream()
	uses_remaining--
	if(uses_remaining <= 0)
		icon_state = "empty_cream"
	else if(uses_remaining <= 15)
		icon_state = "low_cream" 
