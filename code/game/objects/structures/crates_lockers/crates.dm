/obj/structure/closet/crate
	name = "木箱"
	desc = ""
	icon_state = "crate"
	req_access = null
	can_weld_shut = FALSE
	horizontal = TRUE
	allow_objects = TRUE
	allow_dense = FALSE
	dense_when_open = TRUE
	climbable = TRUE
	climb_time = 10 //real fast, because let's be honest stepping into or onto a crate is easy
	climb_stun = 0 //climbing onto crates isn't hard, guys
	delivery_icon = "deliverycrate"
	open_sound = 'sound/blank.ogg'
	close_sound = 'sound/blank.ogg'
	open_sound_volume = 35
	close_sound_volume = 50
	drag_slowdown = 0
	var/obj/item/paper/fluff/jobs/cargo/manifest/manifest
	var/base_icon_state

/obj/structure/closet/crate/Initialize(mapload)
	. = ..()
	if(!base_icon_state)
		base_icon_state = initial(icon_state)
	if(icon_state == "[base_icon_state]open")
		opened = TRUE
	update_icon()

/obj/structure/closet/crate/CanPass(atom/movable/mover, turf/target)
	if(!istype(mover, /obj/structure/closet))
		var/obj/structure/closet/crate/locatedcrate = locate(/obj/structure/closet/crate) in get_turf(mover)
		if(locatedcrate) //you can walk on it like tables, if you're not in an open crate trying to move to a closed crate
			if(opened) //if we're open, allow entering regardless of located crate openness
				return 1
			if(!locatedcrate.opened) //otherwise, if the located crate is closed, allow entering
				return 1
	return !density

/obj/structure/closet/crate/update_icon()
	icon_state = "[base_icon_state][opened ? "open" : ""]"

/obj/structure/closet/crate/attack_hand(mob/user)
	. = ..()
	if(.)
		return

/obj/structure/closet/crate/open(mob/living/user)
	. = ..()

/obj/structure/closet/crate/coffin
	name = "棺匣"
	desc = "一具装殓死者的棺匣。"
	icon_state = "casket"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	icon = 'icons/roguetown/misc/structure.dmi'
	material_drop_amount = 5
	open_sound = 'sound/blank.ogg'
	close_sound = 'sound/blank.ogg'
	open_sound_volume = 25
	close_sound_volume = 50

/obj/structure/closet/crate/coffin/keylock
	locked = 1
	keylock = 1

/obj/structure/closet/crate/coffin/keylock/psydung
	max_integrity = 9999
	lockid = "psy_bog_dung_lootkey_two"

/obj/structure/closet/crate/coffin/vampire
	name = "安眠棺匣"
	desc = "一具做工讲究的棺匣。"
	icon_state = "vcasket"

/obj/structure/closet/crate/coffin/royal
	name = "鎏金棺匣"
	desc = "一具以精木与鎏金金属打造的棺匣。"
	icon_state = "rcasket"

/obj/structure/closet/crate/coffin/royal/keylock
	locked = 1
	keylock = 1

/obj/structure/closet/crate/coffin/royal/keylock/psydon
	name = "圣徽棺匣"
	desc = "一具以精木与鎏金金属打造、饰有灵十字纹样的棺匣。它散发着一股奇异气息。"
	locked = 1
	keylock = 1
	max_integrity = 9999
