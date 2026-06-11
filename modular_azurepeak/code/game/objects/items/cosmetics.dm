/obj/item/azure_lipstick
	gender = PLURAL
	name = "红色唇膏"
	desc = "由蜡、颜料与油脂调和而成，供涂抹于双唇之上。"
	icon = 'modular_azurepeak/icons/obj/items/cosmetics.dmi'
	icon_state = "lipstick"
	w_class = WEIGHT_CLASS_TINY
	var/colour = "red"

/obj/item/azure_lipstick/purple
	name = "紫色唇膏"
	colour = "purple"

/obj/item/azure_lipstick/jade
	name = "翠玉色唇膏"
	colour = "lime"

/obj/item/azure_lipstick/black
	name = "黑色唇膏"
	colour = "black"

/obj/item/azure_lipstick/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/azure_lipstick/update_icon()
	cut_overlays()
	var/mutable_appearance/colored_overlay = mutable_appearance(icon, "lipstick_color")
	colored_overlay.color = colour
	add_overlay(colored_overlay)

/obj/item/azure_lipstick/attack(mob/M, mob/user)
	if(!ismob(M))
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.is_mouth_covered())
			to_chat(user, span_warning("先摘下[ H == user ? "你的" : "[H.p_their()]" ]面罩！"))
			return
		if(H == user)
			if(H.lip_style)	//if you already have lipstick on
				to_chat(user, span_notice("我用[src]擦掉了唇膏。"))
				H.lip_style = null
				H.update_body()
				return
			
			user.visible_message(
				span_notice("[user]用[src]涂抹着[user.p_their()]的双唇。"),
				span_notice("我花了点时间涂上[src]。完美！")
			)
			if(H.getorganslot(ORGAN_SLOT_SNOUT))
				H.lip_style = "lipstick_nosides"
			else
				H.lip_style = "lipstick"
			H.lip_color = colour
			H.update_body()
		else
			if(H.lip_style) // if they already have lipstick on
				user.visible_message(
					span_warning("[user]开始用[src]擦去[H]的唇膏。"),
					span_notice("我开始擦掉[H]的唇膏......")
				)
				if(do_after(user, 10, target = H))
					user.visible_message(
						span_notice("[user]用[src]擦掉了[H]的唇膏。"),
						span_notice("我擦掉了[H]的唇膏。")
					)
					H.lip_style = null
					H.update_body()
				return
			
			user.visible_message(
				span_warning("[user]开始用[src]涂抹[H]的双唇。"),
				span_notice("我开始把[src]涂在[H]的嘴唇上......")
			)
			if(do_after(user, 20, target = H))
				user.visible_message(
					span_notice("[user]用[src]涂抹了[H]的双唇。"),
					span_notice("我把[src]涂在了[H]的嘴唇上。")
				)
				if(H.getorganslot(ORGAN_SLOT_SNOUT))
					H.lip_style = "lipstick_nosides"
				else
					H.lip_style = "lipstick"
				H.lip_color = colour
				H.update_body()
	else
		to_chat(user, span_warning("那东西的嘴唇到底在哪？"))
