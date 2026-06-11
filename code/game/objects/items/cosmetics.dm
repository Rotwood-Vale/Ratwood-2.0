/obj/item/lipstick
	gender = PLURAL
	name = "红色口红"
	desc = ""
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "lipstick"
	w_class = WEIGHT_CLASS_TINY
	var/colour = "red"
	var/open = FALSE

/obj/item/lipstick/purple
	name = "紫色口红"
	colour = "purple"

/obj/item/lipstick/jade
	//It's still called Jade, but theres no HTML color for jade, so we use lime.
	name = "翠玉口红"
	colour = "lime"

/obj/item/lipstick/black
	name = "黑色口红"
	colour = "black"

/obj/item/lipstick/random
	name = "口红"
	icon_state = "random_lipstick"

/obj/item/lipstick/random/Initialize(mapload)
	. = ..()
	icon_state = "lipstick"
	colour = pick("red","purple","lime","black","green","blue","white")
	switch(colour)
		if("red") name = "红色口红"
		if("purple") name = "紫色口红"
		if("lime") name = "翠玉口红"
		if("black") name = "黑色口红"
		if("green") name = "绿色口红"
		if("blue") name = "蓝色口红"
		if("white") name = "白色口红"

/obj/item/lipstick/attack_self(mob/user)
	cut_overlays()
	to_chat(user, span_notice("我将[src][open ? "旋紧" : "旋开"]了。"))
	open = !open
	if(open)
		var/mutable_appearance/colored_overlay = mutable_appearance(icon, "lipstick_uncap_color")
		colored_overlay.color = colour
		icon_state = "lipstick_uncap"
		add_overlay(colored_overlay)
	else
		icon_state = "lipstick"

/obj/item/lipstick/attack(mob/M, mob/user)
	if(!open)
		return

	if(!ismob(M))
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.is_mouth_covered())
			to_chat(user, span_warning("先摘下[ H == user ? "我的" : "[H.p_their()]的" ]面罩！"))
			return
		if(H.lip_style)	//if they already have lipstick on
			to_chat(user, span_warning("我得先擦掉旧口红！"))
			return
		if(H == user)
			user.visible_message(
				span_notice("[user]用[src]涂抹了[user.p_their()]的嘴唇。"),
				span_notice("我仔细涂上了[src]。完美！")
			)
			H.lip_style = "lipstick"
			H.lip_color = colour
			H.update_body()
		else
			user.visible_message(
				span_warning("[user]开始给[H]涂抹[src]。"),
				span_notice("我开始给[H]涂抹[src]……")
			)
			if(do_after(user, 20, target = H))
				user.visible_message(
					span_notice("[user]给[H]涂好了[src]。"),
					span_notice("我给[H]涂好了[src]。")
				)
				H.lip_style = "lipstick"
				H.lip_color = colour
				H.update_body()
	else
		to_chat(user, span_warning("那东西的嘴唇在哪？"))

//you can wipe off lipstick with paper!
/obj/item/paper/attack(mob/M, mob/user)
	if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		if(!ismob(M))
			return

		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(!H.lip_style)
				return
			if(H == user)
				to_chat(user, span_notice("我用[src]擦掉了口红。"))
				H.lip_style = null
				H.update_body()
			else
				user.visible_message(
					span_warning("[user]开始用[src]擦掉[H]的口红。"),
					span_notice("我开始擦掉[H]的口红……")
				)
				if(do_after(user, 10, target = H))
					user.visible_message(
						span_notice("[user]用[src]擦掉了[H]的口红。"),
						span_notice("我擦掉了[H]的口红。")
					)
					H.lip_style = null
					H.update_body()
	else
		..()

// /obj/item/razor
// 	name = "electric razor"
// 	desc = ""
// 	icon = 'icons/obj/items_and_weapons.dmi'
// 	icon_state = "razor"
// 	flags_1 = CONDUCT_1
// 	w_class = WEIGHT_CLASS_TINY

// /obj/item/razor/suicide_act(mob/living/carbon/user)
// 	user.visible_message(span_suicide("[user] begins shaving [user.p_them()]self without the razor guard! It looks like [user.p_theyre()] trying to commit suicide!"))
// 	shave(user, BODY_ZONE_PRECISE_MOUTH)
// 	shave(user, BODY_ZONE_HEAD)//doesnt need to be BODY_ZONE_HEAD specifically, but whatever
// 	return BRUTELOSS

// /obj/item/razor/proc/shave(mob/living/carbon/human/H, location = BODY_ZONE_PRECISE_MOUTH)
// 	return


// /obj/item/razor/attack(mob/M, mob/user)
// 	return
