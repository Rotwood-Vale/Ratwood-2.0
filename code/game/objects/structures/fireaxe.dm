/obj/structure/fireaxecabinet
	name = "剑架"
	desc = "一把历经久远传说、刻痕斑驳之剑的恰当归处。"
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "fireaxe"
	anchored = TRUE
	density = FALSE
	armor = ARMOR_DISPLAYCASE
	max_integrity = 150
	integrity_failure = 0.33
	locked = FALSE
	var/open = TRUE
	var/obj/item/rogueweapon/sword/long/heirloom

/obj/structure/fireaxecabinet/Initialize(mapload)
	. = ..()
	heirloom = new /obj/item/rogueweapon/sword/long/heirloom
	update_icon()

/obj/structure/fireaxecabinet/Destroy()
	if(heirloom)
		QDEL_NULL(heirloom)
	return ..()

/obj/structure/fireaxecabinet/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_MULTITOOL)
		toggle_lock(user)
	else if(I.tool_behaviour == TOOL_WELDER && user.used_intent.type == INTENT_HELP && !obj_broken)
		if(obj_integrity < max_integrity)
			if(!I.tool_start_check(user, amount=2))
				return

	else if(open || obj_broken)
		if(istype(I, /obj/item/rogueweapon/sword/long/heirloom) && !heirloom)
			var/obj/item/rogueweapon/sword/long/heirloom/F = I
			if(F.wielded)
				to_chat(user, "<span class='warning'>先把[F.name]解除双手持握。</span>")
				return
			if(!user.transferItemToLoc(F, src))
				return
			heirloom = F
			to_chat(user, "<span class='notice'>我把[F.name]放回了[name]里。</span>")
			update_icon()
			return
		else if(!obj_broken)
			toggle_open()
	else
		return ..()

/obj/structure/fireaxecabinet/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(obj_broken)
				playsound(loc, 'sound/blank.ogg', 90, TRUE)
			else
				playsound(loc, 'sound/blank.ogg', 90, TRUE)
		if(BURN)
			playsound(src.loc, 'sound/blank.ogg', 100, TRUE)

/obj/structure/fireaxecabinet/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	if(open)
		return
	. = ..()
	if(.)
		update_icon()

/obj/structure/fireaxecabinet/obj_break(damage_flag)
	..()

	if(!obj_broken && !(flags_1 & NODECONSTRUCT_1))
		update_icon()
		playsound(src, 'sound/blank.ogg', 100, TRUE)

/obj/structure/fireaxecabinet/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(open || obj_broken)
		if(heirloom)
			user.put_in_hands(heirloom)
			heirloom = null
			to_chat(user, "<span class='notice'>我从[name]里取出了这把剑。</span>")
			src.add_fingerprint(user)
			update_icon()
			return
	if(locked)
		to_chat(user, "<span class='warning'>[name]纹丝不动！</span>")
		return
	else
		open = !open
		update_icon()
		return

/obj/structure/fireaxecabinet/attack_tk(mob/user)
	if(locked)
		to_chat(user, "<span class='warning'>[name]纹丝不动！</span>")
		return
	else
		open = !open
		update_icon()
		return

/obj/structure/fireaxecabinet/update_icon()
	cut_overlays()
	if(heirloom)
		add_overlay("axe")
	if(!open)

		if(locked)
			add_overlay("locked")
		else
			add_overlay("unlocked")
	else
		add_overlay("glass_raised")

/obj/structure/fireaxecabinet/proc/toggle_lock(mob/user)
	to_chat(user, "<span class='notice'>正在重置电路……</span>")
	playsound(src, 'sound/blank.ogg', 50, TRUE)
	if(do_after(user, 20, target = src))
		to_chat(user, "<span class='notice'>我[locked ? "停用了" : "重新启用了"]锁定模块。</span>")
		locked = !locked
		update_icon()

/obj/structure/fireaxecabinet/verb/toggle_open()
	set name = "打开/关闭"
	set hidden = 1
	set src in oview(1)

	if(locked)
		to_chat(usr, "<span class='warning'>[name]纹丝不动！</span>")
		return
	else
		open = !open
		update_icon()
		return

/obj/structure/fireaxecabinet/south
	dir = SOUTH
	pixel_y = 32

/obj/structure/fireaxecabinet/unforgotten
	name = "未忘之刃剑架"
	desc = "一柄历经漫长岁月、刻痕累累的普赛顿长剑，正适合安放于此。"
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "fireaxe"
	heirloom = /obj/item/rogueweapon/greatsword/bsword/psy/unforgotten/

/obj/structure/fireaxecabinet/unforgotten/Initialize(mapload)
	. = ..()
	heirloom = new /obj/item/rogueweapon/greatsword/bsword/psy/unforgotten
	desc = heirloom.desc
	update_icon()

/obj/structure/fireaxecabinet/unforgotten/south
	dir = SOUTH
	pixel_y = 32

/obj/structure/fireaxecabinet/unforgotten/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_MULTITOOL)
		toggle_lock(user)
	else if(I.tool_behaviour == TOOL_WELDER && user.used_intent.type == INTENT_HELP && !obj_broken)
		if(obj_integrity < max_integrity)
			if(!I.tool_start_check(user, amount=2))
				return

	else if(open || obj_broken)
		if(istype(I, /obj/item/rogueweapon/greatsword/bsword/psy/unforgotten/) && !heirloom)
			var/obj/item/rogueweapon/greatsword/bsword/psy/unforgotten/F = I
			if(F.wielded)
				to_chat(user, "<span class='warning'>先把[F.name]解除双手持握。</span>")
				return
			if(!user.transferItemToLoc(F, src))
				return
			heirloom = F
			to_chat(user, "<span class='notice'>我把[F.name]放回了[name]里。</span>")
			desc = F.desc
			update_icon()
			return
		else if(!obj_broken)
			desc = initial(desc)
			toggle_open()
	else
		return ..()

/obj/structure/fireaxecabinet/unforgotten/update_icon()
	cut_overlays()
	if(heirloom)
		add_overlay("axe_forgotten")
	if(!open)

		if(locked)
			add_overlay("locked")
		else
			add_overlay("unlocked")
	else
		add_overlay("glass_raised")
