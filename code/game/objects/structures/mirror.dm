//wip wip wup
/obj/structure/mirror
	name = "镜子"
	desc = "镜子啊镜子，墙上的镜子……"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "mirror"
	density = FALSE
	anchored = TRUE
	max_integrity = 200
	integrity_failure = 0.9
	break_sound = "glassbreak"
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	pixel_y = 32

/obj/structure/mirror/fancy
	icon_state = "fancymirror"
	pixel_y = 32

/obj/structure/mirror/Initialize(mapload)
	. = ..()
	if(icon_state == "mirror_broke" && !obj_broken)
		obj_break(null, mapload)

/obj/structure/mirror/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	if(obj_broken || !Adjacent(user))
		return

	if(!HAS_TRAIT(H, TRAIT_MIRROR_MAGIC))
		to_chat(H, span_warning("我看向镜中，却只见自己寻常的倒影。"))
		if(HAS_TRAIT(user, TRAIT_BEAUTIFUL))
			H.add_stress(/datum/stressevent/beautiful)
			to_chat(H, span_smallgreen("我看起来真不错！"))
			// Apply Xylix buff when examining someone with the beautiful trait
			if(HAS_TRAIT(H, TRAIT_XYLIX) && !H.has_status_effect(/datum/status_effect/buff/xylix_joy))
				H.apply_status_effect(/datum/status_effect/buff/xylix_joy)
				to_chat(H, span_info("我的美貌让我面带笑意，脚步也更添好运！"))
		if(HAS_TRAIT(H, TRAIT_UNSEEMLY))
			to_chat(H, span_warning("又一次提醒我自己那可憎的容貌。"))
			H.add_stress(/datum/stressevent/unseemly)
		return
	else
		perform_mirror_transform(H)

/obj/structure/mirror/examine_status(mob/user)
	if(obj_broken)
		return list() // no message spam
	return ..()

/obj/structure/mirror/obj_break(damage_flag, mapload)
	if(!obj_broken && !(flags_1 & NODECONSTRUCT_1))
		icon_state = "[icon_state]1"
		if(!mapload)
			new /obj/item/natural/glass_shard (get_turf(src))
		obj_broken = TRUE
	..()

/obj/structure/mirror/deconstruct(disassembled = TRUE)
//	if(!(flags_1 & NODECONSTRUCT_1))
//		if(!disassembled)
//			new /obj/item/shard( src.loc )
	..()

/obj/structure/mirror/welder_act(mob/living/user, obj/item/I)
	..()
	if(user.used_intent.type == INTENT_HARM)
		return FALSE

	if(!obj_broken)
		return TRUE

	if(!I.tool_start_check(user, amount=0))
		return TRUE

	to_chat(user, span_notice("我开始修理[src]……"))
	if(I.use_tool(src, user, 10, volume=50))
		to_chat(user, span_notice("我修好了[src]。"))
		obj_broken = 0
		icon_state = initial(icon_state)
		desc = initial(desc)

	return TRUE


/obj/structure/mirror/magic
	name = "魔镜"
	desc = ""
	icon_state = "magic_mirror"
	var/list/choosable_races = list()

/obj/structure/mirror/magic/New()
	if(!choosable_races.len)
		for(var/speciestype in subtypesof(/datum/species))
			var/datum/species/S = speciestype
			if(initial(S.changesource_flags) & MIRROR_MAGIC)
				choosable_races += initial(S.id)
		choosable_races = sortList(choosable_races)
	..()

/obj/structure/mirror/magic/lesser/New()
	var/list/selectable_species = get_selectable_species()
	choosable_races = selectable_species.Copy()
	..()

/obj/structure/mirror/magic/badmin/New()
	for(var/speciestype in subtypesof(/datum/species))
		var/datum/species/S = speciestype
		if(initial(S.changesource_flags) & MIRROR_BADMIN)
			choosable_races += initial(S.id)
	..()

/obj/structure/mirror/magic/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	var/should_update = FALSE

	var/choice = input(user, "想改变什么？", "魔法梳妆") as null|anything in list("名字", "种族", "性别", "发型", "眼睛", "配饰", "面部细节")

	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return

	switch(choice)
		if("名字")
			var/newname = copytext(sanitize_name(input(H, "我们叫什么来着？", "更改名字", H.name) as null|text),1,MAX_NAME_LEN)

			if(!newname)
				return
			if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
				return
			H.real_name = newname
			H.name = newname
			if(H.dna)
				H.dna.real_name = newname
			if(H.mind)
				H.mind.name = newname

		if("种族")
			var/newrace
			var/racechoice = input(H, "我们是什么来着？", "更改种族") as null|anything in choosable_races
			newrace = GLOB.species_list[racechoice]

			if(!newrace)
				return
			if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
				return
			H.set_species(newrace, icon_update=0)

			if(H.dna.species.use_skintones)
				var/new_s_tone = input(user, "选择你的肤色：", "更改种族")  as null|anything in GLOB.skin_tones
				if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
					return

				if(new_s_tone)
					H.skin_tone = new_s_tone
					H.dna.update_ui_block(DNA_SKIN_TONE_BLOCK)

			if(MUTCOLORS in H.dna.species.species_traits)
				var/new_mutantcolor = input(user, "选择你的皮肤颜色：", "更改种族","#"+H.dna.features["mcolor"]) as color|null
				if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
					return
				if(new_mutantcolor)
					var/temp_hsv = RGBtoHSV(new_mutantcolor)

					if(ReadHSV(temp_hsv)[3] >= ReadHSV("#7F7F7F")[3]) // mutantcolors must be bright
						H.dna.features["mcolor"] = sanitize_hexcolor(new_mutantcolor)

					else
						to_chat(H, span_notice("无效颜色。你选的颜色不够明亮。"))

			H.update_body()
			H.update_hair()
			H.update_body_parts()

		if("发型")
			var/hairchoice = alert(H, "要改发型还是发色？", "更改头发", "样式", "颜色")
			if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
				return
			if(hairchoice == "样式") //So you just want to use a mirror then?
				..()
			else
				var/new_hair_color = input(H, "选择你的发色", "发色","#"+H.hair_color) as color|null
				if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
					return
				if(new_hair_color)
					H.hair_color = sanitize_hexcolor(new_hair_color)
					H.facial_hair_color = H.hair_color
					H.dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
				if(H.gender == "male")
					var/new_face_color = input(H, "选择你的面部毛发颜色", "发色","#"+H.facial_hair_color) as color|null
					if(new_face_color)
						H.facial_hair_color = sanitize_hexcolor(new_face_color)
						H.dna.update_ui_block(DNA_FACIAL_HAIR_COLOR_BLOCK)
				H.update_hair()

		if("眼睛")
			var/new_eye_color = color_pick_sanitized(user, "选择你的眼睛颜色", "眼睛颜色", H.eye_color)
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

		if("配饰")
			var/datum/customizer_choice/bodypart_feature/accessory/accessory_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/accessory)
			var/list/valid_accessories = list("无")
			for(var/accessory_type in accessory_choice.sprite_accessories)
				var/datum/sprite_accessory/accessory/acc = new accessory_type()
				valid_accessories[acc.name] = accessory_type

			var/new_style = input(user, "选择你的配饰", "配饰造型") as null|anything in valid_accessories
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					// Remove existing accessory if any
					for(var/datum/bodypart_feature/accessory/old_acc in head.bodypart_features)
						head.remove_bodypart_feature(old_acc)
						break

					// Add new accessory if not "none"
					if(new_style != "无")
						var/datum/bodypart_feature/accessory/accessory_feature = new()
						accessory_feature.set_accessory_type(valid_accessories[new_style], H.hair_color, H)
						head.add_bodypart_feature(accessory_feature)
					should_update = TRUE

		if("面部细节")
			var/datum/customizer_choice/bodypart_feature/face_detail/face_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/face_detail)
			var/list/valid_details = list("无")
			for(var/detail_type in face_choice.sprite_accessories)
				var/datum/sprite_accessory/face_detail/detail = new detail_type()
				valid_details[detail.name] = detail_type

			var/new_detail = input(user, "选择你的面部细节", "面部细节") as null|anything in valid_details
			if(new_detail)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					// Remove existing face detail if any
					for(var/datum/bodypart_feature/face_detail/old_detail in head.bodypart_features)
						head.remove_bodypart_feature(old_detail)
						break

					// Add new face detail if not "none"
					if(new_detail != "无")
						var/datum/bodypart_feature/face_detail/detail_feature = new()
						detail_feature.set_accessory_type(valid_details[new_detail], H.hair_color, H)
						head.add_bodypart_feature(detail_feature)
					should_update = TRUE

	if(should_update)
		H.update_body()

/obj/structure/mirror/magic/proc/curse(mob/living/user)
	return

/obj/item/handmirror
	name = "手镜"
	desc = "镜啊镜，掌中之镜，天下谁人最美丽？"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "handmirror"
	grid_width = 32
	grid_height = 64
	dropshrink = 0.8

/obj/item/handmirror/attack_self(mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	if(HAS_TRAIT(H, TRAIT_MIRROR_MAGIC))
		to_chat(H, span_info("我凝视镜中，专注于勾勒塑形我身躯的幻魅魔法……"))
		if(do_after(H, 3 SECONDS))
			perform_mirror_transform(H)
		return

	if(HAS_TRAIT(user, TRAIT_BEAUTIFUL))
		H.add_stress(/datum/stressevent/beautiful)
		H.visible_message(span_notice("[H]欣赏着[H.p_their()]在[src]中的倒影。"), span_smallgreen("我看起来真不错！"))
	if(HAS_TRAIT(H, TRAIT_UNSEEMLY))
		to_chat(H, span_warning("又一次提醒我自己那可憎的容貌。"))
		H.add_stress(/datum/stressevent/unseemly)
	// Apply Xylix buff when examining someone with the beautiful trait
	if(HAS_TRAIT(H, TRAIT_XYLIX) && !H.has_status_effect(/datum/status_effect/buff/xylix_joy) && H.has_stress_event(/datum/stressevent/beautiful))
		H.apply_status_effect(/datum/status_effect/buff/xylix_joy)
		to_chat(H, span_info("我的美貌让我面带笑意，脚步也更添好运！"))
	return
