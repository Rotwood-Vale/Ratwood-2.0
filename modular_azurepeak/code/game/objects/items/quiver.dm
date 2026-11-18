
/obj/item/quiver
	name = "quiver"
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
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	alternate_worn_layer = UNDER_CLOAK_LAYER
	strip_delay = 20
	var/max_storage = 20
	var/list/arrows = list()
	sewrepair = TRUE
	dropshrink = 0.9

/// Match each container's normal ammunition insertion rules.
/obj/item/quiver/proc/can_store_ammo(obj/item/ammo_casing/ammo)
	return istype(ammo, /obj/item/ammo_casing/caseless/rogue) && ammo.type != /obj/item/ammo_casing/caseless/rogue && !istype(ammo, /obj/item/ammo_casing/caseless/rogue/javelin)

/obj/item/quiver/sling/can_store_ammo(obj/item/ammo_casing/ammo)
	return istype(ammo, /obj/item/ammo_casing/caseless/rogue/sling_bullet) && ammo.type != /obj/item/ammo_casing/caseless/rogue/sling_bullet

/obj/item/quiver/javelin/can_store_ammo(obj/item/ammo_casing/ammo)
	return istype(ammo, /obj/item/ammo_casing/caseless/rogue/javelin)

/obj/item/quiver/zigs/can_store_ammo(obj/item/ammo_casing/ammo)
	return FALSE

/obj/item/quiver/quickdraw_interact(mob/living/user, obj/item/held_item)
	if(istype(held_item, /obj/item/ammo_casing))
		if(!can_store_ammo(held_item))
			to_chat(user, span_warning("That ammunition does not fit in [src]."))
			return TRUE
		attackby(held_item, user)
		return TRUE // Full/rejected insertion must not fall through into ordinary storage.
	if(!istype(held_item, /obj/item/gun/ballistic/revolver/grenadelauncher/bow) && !istype(held_item, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow) && !istype(held_item, /obj/item/gun/ballistic/revolver/grenadelauncher/sling))
		return FALSE
	var/obj/item/gun/ballistic/revolver/grenadelauncher/launcher = held_item
	if(launcher.chambered)
		to_chat(user, span_notice("[launcher] is already loaded."))
		return TRUE
	if(!istype(launcher, /obj/item/gun/ballistic/revolver/grenadelauncher/sling))
		if(user.get_num_arms(FALSE) < 2 || user.get_inactive_held_item())
			to_chat(user, span_warning("I need a free hand to load [launcher]!"))
			return TRUE
	if(istype(launcher, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow))
		var/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/crossbow = launcher
		if(!crossbow.cocked)
			to_chat(user, span_warning("I need to cock [launcher] first."))
			return TRUE
	if(!length(arrows))
		to_chat(user, span_warning("[src] is empty!"))
		return TRUE
	launcher.quiver_loading = TRUE
	var/handled = load_into_weapon(launcher, user)
	launcher.quiver_loading = FALSE
	if(handled)
		return TRUE
	to_chat(user, span_warning("Nothing in [src] fits [launcher]."))
	return TRUE

/// A round stays indexed until the weapon really moves it out of this container.
/obj/item/quiver/proc/load_into_weapon(obj/item/gun/ballistic/weapon, mob/user, params)
	if(!istype(weapon) || !istype(user) || weapon.chambered || !istype(weapon.magazine))
		return FALSE
	for(var/obj/item/ammo_casing/ammo in arrows)
		if(QDELETED(ammo) || ammo.loc != src)
			continue
		if(weapon.magazine.caliber ? ammo.caliber != weapon.magazine.caliber : ammo.type != weapon.magazine.ammo_type)
			continue
		weapon.attackby(ammo, user, params)
		if(!QDELETED(ammo) && ammo.loc != src)
			arrows -= ammo
			update_icon()
			if(HAS_TRAIT(user, TRAIT_COMBAT_AWARE))
				user.balloon_alert(user, "[length(arrows)] left...")
		return TRUE
	return FALSE

/obj/item/quiver/attack_turf(turf/T, mob/living/user)
	if(arrows.len >= max_storage)
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))
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
	to_chat(user, span_warning("I begin to take out the arrows from [src], one by one..."))
	for(var/obj/item/ammo_casing/caseless/rogue/arrow in arrows)
		if(!do_after(user, 0.5 SECONDS))
			return
		arrow.forceMove(user.loc)
		arrows -= arrow

	update_icon()

/obj/item/quiver/attackby(obj/A, loc, params)
	if(A.type in subtypesof(/obj/item/ammo_casing/caseless/rogue))
		if(A.type in subtypesof(/obj/item/ammo_casing/caseless/rogue/javelin))
			to_chat(loc, span_warning("Javelins are too big to fit in a quiver, silly!"))
			return FALSE
		else if(arrows.len < max_storage)
			if(ismob(loc))
				var/mob/M = loc
				if(!M.doUnEquip(A, TRUE, src, FALSE, silent = TRUE))
					return TRUE
			else
				A.forceMove(src)
			arrows |= A
			update_icon()
		else
			to_chat(loc, span_warning("Full!"))
		return
	if(istype(A, /obj/item/gun/ballistic/revolver/grenadelauncher/bow))
		load_into_weapon(A, loc, params)
		return TRUE
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
		. += span_notice("[arrows.len] inside.")
	. += span_notice("Click on the ground to pick up ammos on the floor.")

/obj/item/quiver/update_icon()
	if(arrows.len)
		icon_state = "quiver1"
	else
		icon_state = "quiver0"

/obj/item/quiver/arrows/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/iron/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/bluntarrows/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/blunt/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/bolts/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/bolt/bronze/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/bronze/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/bluntbolts/Initialize(mapload)
	. = ..()
	for(var/i in  1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/blunt/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/heavybluntbolts/Initialize(mapload)
	. = ..()
	for(var/i in  1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/heavyblunt/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/holybolts/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/holy/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/heavybolts/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/Wbolts/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/water/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/pyrobolts/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/pyro/A = new(src)
		arrows += A
	update_icon()


/obj/item/quiver/poisonarrows/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/poison/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/pyroarrows/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/pyro/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/Parrows/Initialize(mapload)
	. = ..()

/obj/item/quiver/boltsancient/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/ancient/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/Warrows/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/water/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/bodkin/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/steel/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/ancient/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/steel/ancient/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/bronzearrows/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/bronze/A = new(src)
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

/obj/item/quiver/javelin/attackby(obj/item/A, mob/user, params)
	if(!istype(A, /obj/item/ammo_casing/caseless/rogue/javelin))
		return ..()
	if(length(arrows) >= max_storage)
		to_chat(user, span_warning("Full!"))
		return
	if(A.loc == user)
		if(!user.transferItemToLoc(A, src))
			return
	else
		A.forceMove(src)
	arrows += A
	update_icon()

/obj/item/quiver/javelin/quickdraw_interact(mob/living/user, obj/item/held_item)
	if(held_item)
		if(!istype(held_item, /obj/item/ammo_casing/caseless/rogue/javelin))
			return ..()
		attackby(held_item, user)
		return TRUE
	draw_javelin(user, TRUE)
	return TRUE

/obj/item/quiver/javelin/proc/draw_javelin(mob/user, active_only = FALSE)
	if(!length(arrows))
		to_chat(user, span_warning("[src] is empty!"))
		return FALSE
	var/obj/item/javelin = arrows[length(arrows)]
	if(QDELETED(javelin) || javelin.loc != src)
		return FALSE
	var/drawn = user.put_in_active_hand(javelin)
	if(!drawn && !active_only)
		var/list/empty_hands = user.get_empty_held_indexes()
		for(var/hand_index in empty_hands)
			if(user.put_in_hand(javelin, hand_index))
				drawn = TRUE
				break
	if(!drawn)
		return FALSE
	arrows -= javelin
	update_icon()
	return TRUE

/obj/item/quiver/javelin/attack_right(mob/user)
	return draw_javelin(user)

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
		var/obj/item/ammo_casing/caseless/rogue/javelin/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/javelin/steel/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/javelin/steel/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/javelin/ancient/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/javelin/steel/ancient/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/javelin/stone/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/javelin/stone/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/javelin/bronze/Initialize(mapload)
	. = ..()
	for(var/i in 1 to 4)
		var/obj/item/ammo_casing/caseless/rogue/javelin/bronze/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/sling
	name = "sling bullet pouch"
	desc = "This pouch holds the ouch." //i came up with this line on an impulse
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "slingpouch"
	item_state = "slingpouch"
	// Bad Drakian adjustment: ITEM_SLOT_BACK allows either back slot; retain hip and neck slots.
	// slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_NECK
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_NECK | ITEM_SLOT_BACK
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
				if(!M.doUnEquip(A, TRUE, src, FALSE, silent = TRUE))
					return TRUE
			else
				A.forceMove(src)
			arrows |= A
			update_icon()
		else
			to_chat(loc, span_warning("Full!"))
		return
	if(istype(A, /obj/item/gun/ballistic/revolver/grenadelauncher/sling))
		load_into_weapon(A, loc, params)
		return TRUE
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
		var/obj/item/ammo_casing/caseless/rogue/sling_bullet/iron/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/sling/steel/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/sling_bullet/steel/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/sling/ancient/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/sling_bullet/ancient/A = new(src)
		arrows += A
	update_icon()

/obj/item/quiver/sling/bronze/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/sling_bullet/bronze/A = new(src)
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
