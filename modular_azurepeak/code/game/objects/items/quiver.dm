
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
	var/preferred_ammo_type
	var/allowed_ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow
	sewrepair = TRUE
	dropshrink = 0.9

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
				M.doUnEquip(A, TRUE, src, TRUE, silent = TRUE)
			else
				A.forceMove(src)
			arrows += A
			update_icon()
		else
			to_chat(loc, span_warning("Full!"))
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
							M.balloon_alert(M, "[length(arrows)] left...")
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
		var/obj/item/ammo_casing/caseless/rogue/arrow/iron/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bluntarrows/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/blunt/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolts/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/bronze/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/bronze/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bluntbolts/Initialize(mapload)
	. = ..()
	for(var/i in  1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/blunt/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/heavybluntbolts/Initialize(mapload)
	. = ..()
	for(var/i in  1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/heavyblunt/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/holybolts/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/holy/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/heavybolts/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/Wbolts/Initialize(mapload)
	. = ..()
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
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/ancient/A = new()
		arrows += A
	update_icon()

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

/obj/item/quiver/bronzearrows/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/bronze/A = new()
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

/obj/item/quiver/javelin/bronze/Initialize(mapload)
	. = ..()
	for(var/i in 1 to 4)
		var/obj/item/ammo_casing/caseless/rogue/javelin/bronze/A = new()
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

/obj/item/quiver/sling/steel/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/sling_bullet/steel/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/sling/ancient/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/sling_bullet/ancient/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/sling/bronze/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/sling_bullet/bronze/A = new()
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

// ============================================================
// MECHANIZED QUIVERS
// Three variants: bow, crossbow, siegebow
// - Auto-pickup of matching ammo when walking over it
// - Stores the matching ranged weapon via holster component
// - Crafted at the autosmither
// ============================================================

// ---- BASE TYPE ----

/obj/item/quiver/mechanized
	name = "mechanized quiver"
	desc = "A cogwork quiver that automatically collects ammunition."
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "mechquiver0"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = FIRE_PROOF
	max_integrity = 400
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/bronze
	//whether a weapon can go on a particular quiver
	var/obj/item/gun/ballistic/revolver/grenadelauncher/valid_weapon
	var/obj/item/gun/ballistic/revolver/grenadelauncher/holstered_weapon
	//we're giving it the same delay as the great weapon straps have
	equip_delay_self = 5 SECONDS
	unequip_delay_self = 5 SECONDS
	strip_delay = 2 SECONDS
	var/sheathe_time = 2 SECONDS
	//these control the pixel adjustment for hanging bows/crossbows on
	var/bowoverlay_x = 8
	var/bowoverlay_y = -4

//referencing the mechanized ore bag code for the autopickup part. look in storage.dm
/obj/item/quiver/mechanized/equipped(mob/living/user, slot)
	. = ..()
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(on_user_moved))

/obj/item/quiver/mechanized/dropped(mob/living/user)
	. = ..()
	UnregisterSignal(user, COMSIG_MOVABLE_MOVED)

/obj/item/quiver/mechanized/proc/on_user_moved(mob/living/source)
	SIGNAL_HANDLER
	if(!source || source.incapacitated())
		return
	// tried to use the signal handler from the ore bag but it gave warnings about passive listenders, went with a recommended use of the async process
	INVOKE_ASYNC(src, PROC_REF(pickup_from_turf), get_turf(source), source)

//compartmentalized arrow pickup
/obj/item/quiver/mechanized/proc/pickup_from_turf(turf/T, mob/living/user)
	for(var/obj/item/ammo_casing/caseless/rogue/A in T.contents)
		if(!istype(A, /obj/item/ammo_casing/caseless/rogue/bolt))
			continue

//copying parts in from great weapon straps
/obj/item/quiver/mechanized/proc/holster_bow(obj/item/gun/ballistic/revolver/grenadelauncher/W, mob/living/user)
	if(!istype(W, valid_weapon))
		if(user)
			to_chat(user, span_warning("[W] doesn't fit in [src]. Only Bows"))
		return FALSE
	if(holstered_weapon)
		if(user)
			to_chat(user, span_warning("[src] already has [holstered_weapon.name] holstered."))
		return FALSE
	W.forceMove(src)
	holstered_weapon = W
	if(!move_after(user, sheathe_time, target = user))
		return FALSE
	if(user)
		to_chat(user, span_notice("I stow [W] into [src]."))
		playsound(src, 'sound/misc/chestclose.ogg', 30, TRUE)
	update_icon()
	return TRUE

/obj/item/quiver/mechanized/proc/draw_bow(mob/living/user)
	if(!holstered_weapon)
		to_chat(user, span_warning("Nothing is holstered in [src]."))
		return FALSE
	if(!move_after(user, sheathe_time, target = user))
		return FALSE
	var/obj/item/gun/ballistic/revolver/grenadelauncher/W = holstered_weapon
	holstered_weapon = null
	if(!user.put_in_active_hand(W))
		W.forceMove(get_turf(user))
	playsound(src, 'sound/misc/chestclose.ogg', 30, TRUE)
	update_icon()
	return TRUE

/obj/item/quiver/mechanized/MiddleClick(mob/living/user)
	//pull out the bow if its holstered
	if(holstered_weapon)
		draw_bow(user)
		return
	// nothing is holstered, are we carrying a valid bow?
	var/obj/item/held = user.get_active_held_item()
	if(!held)
		to_chat(user, span_warning("I'm not holding anything to stow in [src]."))
		return
	if(!valid_weapon || !istype(held, valid_weapon))
		to_chat(user, span_warning("[held] doesn't fit in [src]."))
		return
	if(user.transferItemToLoc(held, src))
		holstered_weapon = held
		to_chat(user, span_notice("I holster [held] into [src]."))
		playsound(src, 'sound/misc/chestclose.ogg', 30, TRUE)
		update_icon()

/obj/item/quiver/mechanized/attack_right(mob/user)
	if(holstered_weapon)
		draw_bow(user)
		return TRUE
	return ..()

/obj/item/quiver/mechanized/examine(mob/user)
	. = ..()
	if(holstered_weapon)
		. += span_notice("Holstered: [holstered_weapon.name].")
	else
		. += span_warning("No weapon holstered. Left-click with a compatible weapon to holster it.")

/obj/item/quiver/mechanized/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Automatically picks up compatible ammo when you walk over it.")
	. += span_info("Middle Click with a compatible weapon to holster it.")
	. += span_info("Right-click to draw the holstered weapon to your active hand.")

//this controls the overlays, you migh need to adjust the bowoverlay_x and bowoverlay_y vars in the specific quiver types depending on the graphic
/obj/item/quiver/mechanized/update_overlays()
	. = ..()
	if(!holstered_weapon)
		return
	var/mutable_appearance/weapon_overlay = mutable_appearance(
		holstered_weapon.icon,
		holstered_weapon.icon_state
	)
	var/matrix/M = matrix()
	M.Scale(0.5, 0.5)
	weapon_overlay.transform = M
	weapon_overlay.pixel_x = bowoverlay_x
	weapon_overlay.pixel_y = bowoverlay_y
	. += weapon_overlay

//we destroy both to ensure we don't have jankiness, hopefully?
/obj/item/quiver/mechanized/Destroy()
	if(holstered_weapon && !QDELETED(holstered_weapon))
		holstered_weapon.forceMove(get_turf(src))
	holstered_weapon = null
	return ..()

// ============================================================
// QUIVERS
// ============================================================

//bow and arrows
/obj/item/quiver/mechanized/bow
	name = "mechanized bow quiver"
	desc = "A mechanical quiver for bows and arrows, it will suck up arrows off the ground and hold a bow!"
	icon_state = "mechquiver0"
	max_storage = 20
	allowed_ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow
	valid_weapon = /obj/item/gun/ballistic/revolver/grenadelauncher/bow

/obj/item/quiver/mechanized/bow/update_icon()
	icon_state = arrows.len ? "mechquiver1" : "mechquiver0"
	// Rebuild overlays whenever icon updates so holstered weapon shows
	bowoverlay_x = -14
	bowoverlay_y = -14
	cut_overlays()
	var/list/new_overlays = update_overlays()
	if(length(new_overlays))
		overlays = new_overlays

//crossbow, slurbow, bolts, and light bolts
/obj/item/quiver/mechanized/crossbow
	name = "mechanized bolt quiver"
	desc = "A mechanical bolt pouch for crossbows, slurbows, and bolts. It will suck up bolts off the ground and hold a crossbow or slurbow!"
	icon_state = "mechboltpouch0"
	max_storage = 20
	allowed_ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt
	valid_weapon = list(/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow)

/obj/item/quiver/mechanized/crossbow/update_icon()
	icon_state = arrows.len ? "mechboltpouch1" : "mechboltpouch0"
	cut_overlays()
	var/list/new_overlays = update_overlays()
	if(length(new_overlays))
		overlays = new_overlays

// Accept both standard bolts and light bolts
/obj/item/quiver/mechanized/crossbow/eatarrow(obj/A)
	if(!istype(A, /obj/item/ammo_casing/caseless/rogue/bolt))
		update_icon()
		return TRUE

/obj/item/quiver/mechanized/crossbow/pickup_from_turf(turf/T, mob/living/user)
	// Standard bolts
	for(var/obj/item/ammo_casing/caseless/rogue/bolt/A in T.contents)
		if(istype(A, /obj/item/ammo_casing/caseless/rogue/heavy_bolt))
			continue // skip heavy bolts
		eatarrow(A)

/obj/item/quiver/mechanized/crossbow/holster_bow(obj/item/gun/ballistic/revolver/grenadelauncher/W, mob/living/user)
	if(!istype(W, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow) || \
	    istype(W, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy))
		if(user)
			to_chat(user, span_warning("[W] doesn't fit — it can carry only crossbows and slurbows."))
		return FALSE
	return ..()

/obj/item/quiver/mechanized/crossbow/MiddleClick(mob/living/user)
	//if there's somthing holstered, pull it out
	if(holstered_weapon)
		draw_bow(user)
		return
	//next we check what we're holding and holster it if its valid
	var/obj/item/held = user.get_active_held_item()
	if(!held)
		to_chat(user, span_warning("I'm not holding anything to stow in [src]."))
		return
	if(!istype(held, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow) || \
	   !istype(held, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow))
		to_chat(user, span_warning("[held] doesn't fit — only crossbows and slurbows."))
		return
	if(user.transferItemToLoc(held, src))
		holstered_weapon = held
		to_chat(user, span_notice("I clip [held] to [src]."))
		playsound(src, 'sound/misc/chestclose.ogg', 30, TRUE)
		update_icon()

// ============================================================
// SIEGEBOW QUIVER — heavy bolts only, siegebow only
// ============================================================

/obj/item/quiver/mechanized/siegebow
	name = "mechanized heavy bolt quiver"
	desc = "A mechanical heavy bolt pouch for siegebows and heavy bolts. It will suck up heavy bolts off the ground and hold a siegebow!"
	icon_state = "mechboltpouch0"
	w_class = WEIGHT_CLASS_HUGE
	max_storage = 8
	allowed_ammo_type = /obj/item/ammo_casing/caseless/rogue/heavy_bolt
	valid_weapon = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy

/obj/item/quiver/mechanized/siegebow/update_icon()
	icon_state = arrows.len ? "mechboltpouch1" : "mechboltpouch0"
	cut_overlays()
	var/list/new_overlays = update_overlays()
	if(length(new_overlays))
		overlays = new_overlays

/obj/item/quiver/mechanized/siegebow/pickup_from_turf(turf/T, mob/living/user)
	for(var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/A in T.contents)
		eatarrow(A)
	if(!holstered_weapon)
		for(var/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy/W in T.contents)
			holster_bow(W, null)
			break

/obj/item/quiver/mechanized/siegebow/holster_bow(obj/item/gun/ballistic/revolver/grenadelauncher/W, mob/living/user)
	if(!istype(W, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy))
		if(user)
			to_chat(user, span_warning("[W] doesn't fit — it can carry only siegebows."))
		return FALSE
	return ..()

/obj/item/quiver/mechanized/siegebow/MiddleClick(mob/living/user)
	//if there's somthing holstered, pull it out
	if(holstered_weapon)
		draw_bow(user)
		return
	//next we check what we're holding and holster it if its valid
	var/obj/item/held = user.get_active_held_item()
	if(!held)
		to_chat(user, span_warning("I'm not holding anything to stow in [src]."))
		return
	if(!istype(held, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy))
		to_chat(user, span_warning("[held] doesn't fit — this pouch can only hold siegebows."))
		return
	if(user.transferItemToLoc(held, src))
		holstered_weapon = held
		to_chat(user, span_notice("I strap [held] to [src]."))
		playsound(src, 'sound/misc/chestclose.ogg', 30, TRUE)
		update_icon()
