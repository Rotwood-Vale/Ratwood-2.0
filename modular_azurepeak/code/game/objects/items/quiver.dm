/obj/item/quiver
	name = "quiver"
	desc = "A light, slingable bag that can store arrows. It is the best friend of many-a-plucksome archer."
	icon_state = "quiver0"
	item_state = "quiver"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	//lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	//righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BACK
	resistance_flags = FIRE_PROOF
	max_integrity = 0
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	alternate_worn_layer = UNDER_CLOAK_LAYER
	strip_delay = 2 SECONDS
	var/max_storage = 20 // Weight budget. Regular ammo = 1 weight each.
	var/list/arrows = list()
	var/preferred_ammo_type
	var/allowed_ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow
	sewrepair = TRUE
	experimental_inhand = TRUE
	experimental_onhip = TRUE
	experimental_onback = TRUE

/obj/item/quiver/getonmobprop(tag)
	..()
	if(tag)
		switch(tag)
			if("onback")
				return list(
					"shrink" = 0.5,
					"sx" = 1,
					"sy" = 4,
					"nx" = 1,
					"ny" = 2,
					"wx" = 3,
					"wy" = 3,
					"ex" = 0,
					"ey" = 2,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 8,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0
				)
			if("onbelt")
				return list(
					"shrink" = 0.35,
					"sx" = -4,
					"sy" = -6,
					"nx" = 5,
					"ny" = -6,
					"wx" = 0,
					"wy" = -6,
					"ex" = -1,
					"ey" = -6,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = -90,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 1
				)
			if("gen")
				return list(
					"shrink" = 0.4,
					"sx" = -7,
					"sy" = -4,
					"nx" = 7,
					"ny" = -4,
					"wx" = -4,
					"wy" = -4,
					"ex" = 2,
					"ey" = -4,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 8,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0
				)

/obj/item/quiver/proc/get_current_weight()
	. = 0
	for(var/obj/item/ammo_casing/caseless/rogue/A in arrows)
		. += A.ammo_weight

/obj/item/quiver/proc/get_ammo_types()
	var/list/types = list()
	for(var/obj/item/ammo_casing/caseless/rogue/A in arrows)
		if(!(A.type in types))
			types[A.type] = list("name" = A.name, "count" = 1, "ref" = A)
		else
			types[A.type]["count"]++
	return types

/obj/item/quiver/proc/pick_ammo(ammo_base_type, wanted_caliber)
	var/obj/item/ammo_casing/caseless/rogue/fallback
	for(var/obj/item/ammo_casing/caseless/rogue/A in arrows)
		if(ammo_base_type && !istype(A, ammo_base_type))
			continue
		if(wanted_caliber && A.caliber != wanted_caliber)
			continue
		if(!fallback)
			fallback = A
		if(preferred_ammo_type && istype(A, preferred_ammo_type))
			return A
	if(preferred_ammo_type && !wanted_caliber)
		preferred_ammo_type = fallback?.type
	return fallback

/obj/item/quiver/proc/try_quick_load(obj/item/gun/ballistic/revolver/grenadelauncher/B, mob/user, params)
	if(B.chambered)
		return FALSE
	if(!B.can_quick_load(user))
		return FALSE
	if(!length(arrows))
		to_chat(user, span_warning("[src] is empty!"))
		return FALSE
	var/obj/item/ammo_casing/caseless/rogue/AR = pick_ammo(allowed_ammo_type, B.magazine?.caliber)
	if(!AR)
		to_chat(user, span_warning("Nothing in [src] fits [B]."))
		return FALSE
	arrows -= AR
	B.quickloading = TRUE
	B.attackby(AR, user, params)
	B.quickloading = FALSE
	if(!B.chambered)
		arrows += AR
		return FALSE
	if(HAS_TRAIT(user, TRAIT_COMBAT_AWARE))
		user.balloon_alert(user, "[length(arrows)] left...")
	update_icon()
	return TRUE

/obj/item/quiver/attack_turf(turf/T, mob/living/user)
	if(get_current_weight() >= max_storage)
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))
	for(var/obj/item/ammo_casing/caseless/rogue/arrow in T.contents)
		if(do_after(user, 5))
			if(!eatarrow(arrow))
				break

/obj/item/quiver/proc/eatarrow(obj/A)
	if(!istype(A, allowed_ammo_type))
		return FALSE
	var/obj/item/ammo_casing/caseless/rogue/ammo = A
	if(get_current_weight() + ammo.ammo_weight <= max_storage)
		A.forceMove(src)
		arrows += A
		update_icon()
		return TRUE
	return FALSE

/obj/item/quiver/attack_self(mob/living/user)
	..()

	if (!arrows.len)
		return
	to_chat(user, span_warning("I begin to take out the arrows from [src], one by one..."))
	for(var/obj/item/ammo_casing/caseless/rogue/arrow in arrows)
		if(!do_after(user, 0.5 SECONDS))
			return
		arrow.forceMove(user.loc)
		arrows -= arrow

	update_icon()

/obj/item/quiver/attackby(obj/A, mob/user, params)
	if(istype(A, /obj/item/ammo_casing/caseless/rogue))
		if(!istype(A, allowed_ammo_type))
			to_chat(user, span_warning("That doesn't fit in [src]."))
			return FALSE
		var/obj/item/ammo_casing/caseless/rogue/ammo = A
		if(get_current_weight() + ammo.ammo_weight <= max_storage)
			if(ismob(user))
				user.doUnEquip(A, TRUE, src, TRUE, silent = TRUE)
			else
				A.forceMove(src)
			arrows += A
			update_icon()
		else
			to_chat(user, span_warning("Full!"))
		return
	if(istype(A, /obj/item/gun/ballistic/revolver/grenadelauncher))
		if(ismob(user))
			try_quick_load(A, user, params)
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

/obj/item/quiver/ShiftRightClick(mob/user)
	..()
	if(!user.canUseTopic(src, BE_CLOSE))
		return TRUE
	var/list/ammo_types = get_ammo_types()
	if(!length(ammo_types))
		to_chat(user, span_warning("[src] is empty."))
		return TRUE
	if(length(ammo_types) < 2)
		to_chat(user, span_notice("Only one ammo type loaded."))
		return TRUE
	var/list/choices = list()
	var/list/label_to_type = list()
	for(var/ammo_path in ammo_types)
		var/list/info = ammo_types[ammo_path]
		var/obj/item/ammo_casing/caseless/rogue/ref_ammo = info["ref"]
		var/label = "[info["name"]] ([info["count"]])"
		choices[label] = image(icon = ref_ammo.icon, icon_state = ref_ammo.icon_state)
		label_to_type[label] = ammo_path
	var/choice = show_radial_menu(user, src, choices, tooltips = TRUE)
	if(!choice || !label_to_type[choice])
		return TRUE
	preferred_ammo_type = label_to_type[choice]
	to_chat(user, span_notice("Selected: [ammo_types[preferred_ammo_type]["name"]]."))
	return TRUE

/obj/item/quiver/examine(mob/user)
	. = ..()
	if(!arrows.len)
		. += span_notice("Empty.")
		return
	. += span_notice("[arrows.len] inside. ([get_current_weight()]/[max_storage] weight)")
	var/list/ammo_types = get_ammo_types()
	for(var/ammo_path in ammo_types)
		var/list/info = ammo_types[ammo_path]
		var/selected_marker = (ammo_path == preferred_ammo_type) ? " (selected)" : ""
		. += span_notice("	[info["name"]] x[info["count"]][selected_marker]")


/obj/item/quiver/update_icon()
	if(arrows.len)
		icon_state = "quiver1"
	else
		icon_state = "quiver0"

/obj/item/quiver/arrows/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/iron/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bluntarrows/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/blunt/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt
	name = "bolt pouch"
	desc = "A leather canister that can be used to carry bolts. Smaller, sleeker, yet nevertheless spacious enough to pack enough ammunition for a full nite's hunt."
	icon_state = "boltpouch0"
	item_state = "boltpouch"
	max_storage = 16
	allowed_ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt

/obj/item/quiver/bolt/getonmobprop(tag)
	..()
	if(tag)
		switch(tag)
			if("onback")
				return list(
					"shrink" = 0.4,
					"sx" = 1,
					"sy" = 4,
					"nx" = 1,
					"ny" = 2,
					"wx" = 3,
					"wy" = 3,
					"ex" = 0,
					"ey" = 2,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 8,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0
				)
			if("onbelt")
				return list(
					"shrink" = 0.35,
					"sx" = -4,
					"sy" = -6,
					"nx" = 5,
					"ny" = -6,
					"wx" = 0,
					"wy" = -6,
					"ex" = -1,
					"ey" = -6,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = -90,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 1
				)

/obj/item/quiver/bolt/attack_turf(turf/T, mob/living/user)
	if(get_current_weight() >= max_storage)
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))
	for(var/obj/item/ammo_casing/caseless/rogue/bolt in T.contents)
		if(do_after(user, 5))
			if(!eatarrow(bolt))
				break

/obj/item/quiver/bolt/update_icon()
	if(arrows.len)
		icon_state = "boltpouch1"
	else
		icon_state = "boltpouch0"

/obj/item/quiver/bolt/standard/Initialize(mapload)
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/blunt/Initialize(mapload)
	. = ..()
	for(var/i in  1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/blunt/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/heavybluntbolts/Initialize(mapload)
	. = ..()
	for(var/i in  1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/heavyblunt/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/holybolts/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/holy/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/Wbolts/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/water/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/pyro/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/pyro/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/ancient/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/ancient/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/heavy
	name = "heavy bolt pouch"
	desc = "A heavy leather canister that can be used to carry heavier bolts. Casketed inside are the missiles that, whether launched from a mounted ballista or handheld siegebow, will devastate without quarter."
	icon_state = "boltpouch0"
	item_state = "boltpouch"
	max_storage = 8
	allowed_ammo_type = /obj/item/ammo_casing/caseless/rogue/heavy_bolt

/obj/item/quiver/bolt/heavy/attack_turf(turf/T, mob/living/user)
	if(get_current_weight() >= max_storage)
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))
	for(var/obj/item/ammo_casing/caseless/rogue/heavy_bolt in T.contents)
		if(do_after(user, 5))
			if(!eatarrow(heavy_bolt))
				break

/obj/item/quiver/bolt/heavy/update_icon()
	if(arrows.len)
		icon_state = "boltpouch1"
	else
		icon_state = "boltpouch0"

/obj/item/quiver/bolt/heavy/standard/Initialize(mapload)
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/A = new()
		arrows += A
	update_icon()
/* Temporary until Bronze weapon PR is in
/obj/item/quiver/bolt/heavy/bronze/Initialize(mapload)
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/bronze/A = new()
		arrows += A
	update_icon()
*/
/obj/item/quiver/bolt/heavy/decrepit/Initialize(mapload)
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/decrepit/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/heavy/ancient/Initialize(mapload)
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/ancient/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/heavy/blunt/Initialize(mapload)
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/blunt/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/heavy/silver/Initialize(mapload)
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/holy/A = new()
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

/obj/item/quiver/Warrows/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/water/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bodkin/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/steel/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/ancient/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/steel/ancient/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/javelin
	name = "javelinbag"
	desc = ""
	icon_state = "javelinbag0"
	item_state = "javelinbag"
	max_storage = 4
	dropshrink = 0.85

/obj/item/quiver/javelin/attack_turf(turf/T, mob/living/user)
	if(arrows.len >= max_storage)
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))
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
			to_chat(loc, span_warning("Full!"))
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
		. += span_notice("[arrows.len] inside.")

/obj/item/quiver/javelin/update_icon()
	if(arrows.len)
		icon_state = "javelinbag1"
	else
		icon_state = "javelinbag0"

/obj/item/quiver/javelin/iron/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/javelin/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/javelin/steel/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/javelin/steel/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/javelin/ancient/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/javelin/steel/ancient/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/sling
	name = "sling bullet pouch"
	desc = "This pouch holds the ouch." //i came up with this line on an impulse
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
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))
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
			to_chat(loc, span_warning("Full!"))
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
	name = "zig box"
	desc = "A box for all your smoking needs."
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
