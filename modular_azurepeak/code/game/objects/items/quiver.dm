
/obj/item/quiver
	name = "箭袋"
	desc = ""
	icon_state = "quiver0"
	item_state = "quiver"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BACK
	resistance_flags = FIRE_PROOF
	max_integrity = 0
	sellprice = 2 // Shouldn't have added value lmao
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	alternate_worn_layer = UNDER_CLOAK_LAYER
	strip_delay = 20
	var/max_storage = 20
	var/list/arrows = list()
	sewrepair = TRUE
	dropshrink = 0.9

/obj/item/quiver/attack_turf(turf/T, mob/living/user)
	if(arrows.len >= max_storage)
		to_chat(user, span_warning("我的[src.name]已经满了！"))
		return
	to_chat(user, span_notice("我开始收拢这些弹药......"))
	for(var/obj/item/ammo_casing/caseless/rogue/arrow in T.contents)
		if(do_after(user, 5))
			if(!eatarrow(arrow))
				break

/obj/item/quiver/proc/eatarrow(obj/A)
	if(A.type in subtypesof(/obj/item/ammo_casing/caseless/rogue))
		if(arrows.len < max_storage)
			A.forceMove(src)
			arrows += A
			update_icon()
			return TRUE
		else
			return FALSE

/obj/item/quiver/attack_self(mob/living/user)
	..()

	if (!arrows.len)
		return
	to_chat(user, span_warning("我开始把[src]里的箭一支支取出来......"))
	for(var/obj/item/ammo_casing/caseless/rogue/arrow in arrows)
		if(!do_after(user, 0.5 SECONDS))
			return
		arrow.forceMove(user.loc)
		arrows -= arrow

	update_icon()

/obj/item/quiver/attackby(obj/A, loc, params)
	if(A.type in subtypesof(/obj/item/ammo_casing/caseless/rogue))
		if(A.type in subtypesof(/obj/item/ammo_casing/caseless/rogue/javelin))
			to_chat(loc, span_warning("标枪太大了，塞不进箭袋里，傻瓜！"))
			return FALSE
		else if(arrows.len < max_storage)
			if(ismob(loc))
				var/mob/M = loc
				M.doUnEquip(A, TRUE, src, TRUE, silent = TRUE)
			else
				A.forceMove(src)
			arrows += A
			update_icon()
		else
			to_chat(loc, span_warning("满了！"))
		return
	if(istype(A, /obj/item/gun/ballistic/revolver/grenadelauncher/bow))
		var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/B = A
		if(arrows.len && !B.chambered)
			for(var/AR in arrows)
				if(istype(AR, /obj/item/ammo_casing/caseless/rogue/arrow))
					arrows -= AR
					B.attackby(AR, loc, params)
					if(ismob(loc))
						var/mob/M = loc
						if(HAS_TRAIT(M, TRAIT_COMBAT_AWARE))
							M.balloon_alert(M, "还剩[length(arrows)]支......")
					break
		return
	..()

/obj/item/quiver/attack_right(mob/user)
	if(arrows.len)
		var/obj/O = arrows[arrows.len]
		arrows -= O
		O.forceMove(user.loc)
		user.put_in_hands(O)
		update_icon()
		return TRUE

/obj/item/quiver/examine(mob/user)
	. = ..()
	if(arrows.len)
		. += span_notice("里面有[arrows.len]支。")
	. += span_notice("点击地面即可拾起地上的弹药。")

/obj/item/quiver/update_icon()
	if(arrows.len)
		icon_state = "quiver1"
	else
		icon_state = "quiver0"

/obj/item/quiver/arrows/Initialize(mapload)
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/iron/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bluntarrows/Initialize(mapload)
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/blunt/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolts/Initialize(mapload)
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bluntbolts/Initialize(mapload)
	..()
	for(var/i in  1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/blunt/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/heavybluntbolts/Initialize(mapload)
	..()
	for(var/i in  1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/heavyblunt/A = new()
		arrows += A
	update_icon()
	
/obj/item/quiver/holybolts/Initialize(mapload)
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/holy/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/heavybolts/Initialize(mapload)
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/Wbolts/Initialize(mapload)
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/water/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/pyrobolts/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/pyro/A = new()
		arrows += A
	update_icon()


/obj/item/quiver/poisonarrows/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/poison/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/pyroarrows/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/pyro/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/Parrows/Initialize(mapload)
	. = ..()

/obj/item/quiver/boltsancient/Initialize(mapload)
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/ancient/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/Warrows/Initialize(mapload)
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/water/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bodkin/Initialize(mapload)
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/steel/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/ancient/Initialize(mapload)
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/steel/ancient/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/javelin
	name = "标枪袋"
	desc = ""
	icon_state = "javelinbag0"
	item_state = "javelinbag"
	max_storage = 4
	sellprice = 10
	dropshrink = 0.85

/obj/item/quiver/javelin/attack_turf(turf/T, mob/living/user)
	if(arrows.len >= max_storage)
		to_chat(user, span_warning("我的[src.name]已经满了！"))
		return
	to_chat(user, span_notice("我开始收拢这些弹药......"))
	for(var/obj/item/ammo_casing/caseless/rogue/javelin in T.contents)
		if(do_after(user, 5))
			if(!eatarrow(javelin))
				break

/obj/item/quiver/javelin/attackby(obj/A, loc, params)
	if(A.type in subtypesof(/obj/item/ammo_casing/caseless/rogue/javelin))
		if(arrows.len < max_storage)
			if(ismob(loc))
				var/mob/M = loc
				M.doUnEquip(A, TRUE, src, TRUE, silent = TRUE)
			else
				A.forceMove(src)
			arrows += A
			update_icon()
		else
			to_chat(loc, span_warning("满了！"))
		return
	..()

/obj/item/quiver/javelin/attack_right(mob/user)
	if(arrows.len)
		var/obj/O = arrows[arrows.len]
		arrows -= O
		O.forceMove(user.loc)
		user.put_in_hands(O)
		update_icon()
		return TRUE

/obj/item/quiver/javelin/examine(mob/user)
	. = ..()
	if(arrows.len)
		. += span_notice("里面有[arrows.len]支。")

/obj/item/quiver/javelin/update_icon()
	if(arrows.len)
		icon_state = "javelinbag1"
	else
		icon_state = "javelinbag0"

/obj/item/quiver/javelin/iron/Initialize(mapload)
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/javelin/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/javelin/steel/Initialize(mapload)
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/javelin/steel/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/javelin/ancient/Initialize(mapload)
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/javelin/steel/ancient/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/sling
	name = "投石索弹袋"
	desc = "这个袋子装着让人吃痛的玩意。" //i came up with this line on an impulse
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "slingpouch"
	item_state = "slingpouch"
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_NECK
	max_storage = 20
	w_class = WEIGHT_CLASS_NORMAL
	grid_height = 64
	grid_width = 32

/obj/item/quiver/sling/attack_turf(turf/T, mob/living/user)
	if(arrows.len >= max_storage)
		to_chat(user, span_warning("我的[src.name]已经满了！"))
		return
	to_chat(user, span_notice("我开始收拢这些弹药......"))
	for(var/obj/item/ammo_casing/caseless/rogue/sling_bullet in T.contents)
		if(do_after(user, 5))
			if(!eatarrow(sling_bullet))
				break

/obj/item/quiver/sling/attackby(obj/A, loc, params)
	if(A.type in subtypesof(/obj/item/ammo_casing/caseless/rogue/sling_bullet))
		if(arrows.len < max_storage)
			if(ismob(loc))
				var/mob/M = loc
				M.doUnEquip(A, TRUE, src, TRUE, silent = TRUE)
			else
				A.forceMove(src)
			arrows += A
			update_icon()
		else
			to_chat(loc, span_warning("满了！"))
		return
	if(istype(A, /obj/item/gun/ballistic/revolver/grenadelauncher/sling))
		var/obj/item/gun/ballistic/revolver/grenadelauncher/sling/B = A
		if(arrows.len && !B.chambered)
			for(var/AR in arrows)
				if(istype(AR, /obj/item/ammo_casing/caseless/rogue/sling_bullet))
					arrows -= AR
					B.attackby(AR, loc, params)
					break
		return
	..()

/obj/item/quiver/sling/attack_right(mob/user)
	if(arrows.len)
		var/obj/O = arrows[arrows.len]
		arrows -= O
		O.forceMove(user.loc)
		user.put_in_hands(O)
		update_icon()
		return TRUE

/obj/item/quiver/sling/update_icon()
	return

/obj/item/quiver/sling/iron/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/sling_bullet/iron/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/sling/ancient/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/sling_bullet/ancient/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/zigs
	name = "烟卷盒"
	desc = "满足你一切抽烟需求的小盒子。"
	icon = 'icons/roguetown/clothing/storage.dmi'
	icon_state = "smokebox"
	item_state = "smokebox"
	slot_flags = ITEM_SLOT_HIP
	max_storage = 10
	w_class = WEIGHT_CLASS_NORMAL
	grid_height = 64
	grid_width = 32
	dropshrink = 0.5

/obj/item/quiver/zigs/attackby(obj/A, loc, params)
	if(A.type in subtypesof(/obj/item/clothing/mask/cigarette/rollie))
		if(arrows.len < max_storage)
			if(ismob(loc))
				var/mob/M = loc
				M.doUnEquip(A, TRUE, src, TRUE, silent = TRUE)
			else
				A.forceMove(src)
			arrows += A
			update_icon()
		else

	..()

/obj/item/quiver/zigs/attack_right(mob/user)
	if(arrows.len)
		var/obj/O = arrows[arrows.len]
		arrows -= O
		O.forceMove(user.loc)
		user.put_in_hands(O)
		update_icon()
		return TRUE

/obj/item/quiver/zigs/update_icon()
	return

/obj/item/quiver/zigs/nicotine/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/clothing/mask/cigarette/rollie/nicotine/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/zigs/trippy/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/clothing/mask/cigarette/rollie/trippy/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/zigs/cannabis/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/clothing/mask/cigarette/rollie/cannabis/A = new()
		arrows += A
	update_icon()
