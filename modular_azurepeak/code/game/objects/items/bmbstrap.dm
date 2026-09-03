/obj/item/bmbstrap
	name = "Bombdolier"
	desc = "A strap for carrying grenades. A lunatic's invention, surely."
	icon_state = "bombdolier1"
	item_state = "bombdolier"
	icon = 'modular_azurepeak/icons/obj/items/bombdolier.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = FIRE_PROOF
	equip_delay_self = 5 SECONDS
	unequip_delay_self = 5 SECONDS
	max_integrity = 0
	sellprice = 35
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	alternate_worn_layer = UNDER_CLOAK_LAYER
	strip_delay = 20
	var/max_storage = 10
	var/list/tweps = list()
	var/list/fill_list = list() //use for custome fill that
	var/list/storable_types = list(
		/obj/item/bomb,
		/obj/item/tntstick,
		/obj/item/impact_grenade
	)
	sewrepair = TRUE

/obj/item/bmbstrap/attackby(obj/A, mob/living/carbon/user, params)
	var/obj/item/I = A
	if(!I)
		return ..()

	var/can_store = FALSE
	for(var/typepath in storable_types)
		if(istype(I, typepath))
			can_store = TRUE
			break

	if(!can_store)
		return ..()

	if(length(tweps) >= max_storage)
		to_chat(user, span_warning("Full!"))
		return TRUE

	if(!user.transferItemToLoc(I, src))
		return TRUE

	if(!(I in tweps))
		tweps += I

	update_icon()
	return TRUE

/obj/item/bmbstrap/MiddleClick(mob/living/user)
	if(!length(tweps))
		return
	var/alist/targets = alist()
	for(var/atom/movable/AM as anything in tweps)
		targets[AM.name] = AM
	var/selected_name = tgui_input_list(user, "WHAT DO YOU GET OUT?", name, targets)
	if(!selected_name)
		return
	var/atom/movable/AM = targets[selected_name]
	if(!HAS_TRAIT(user, TRAIT_EXPLOSIVE_SUPPLY) && !HAS_TRAIT(user, TRAIT_BOMBER_EXPERT))
		if(!do_after(user, 20, target = user))
			return TRUE
		to_chat(user, span_notice("You fumble to draw a grenade..."))
	if(!(AM in tweps)) //could've been taken out mid-do_after
		return TRUE
	tweps -= AM
	user.put_in_hands(AM)
	update_icon()
	return TRUE

/obj/item/bmbstrap/attack_right(mob/user)
	if(tweps.len)
		if(HAS_TRAIT(user, TRAIT_EXPLOSIVE_SUPPLY) || HAS_TRAIT(user, TRAIT_BOMBER_EXPERT)) //virtue and bomber roles
			var/obj/O = tweps[tweps.len]
			tweps -= O
			user.put_in_hands(O)
			update_icon()
		else
			if(do_after(user, 20, target = user))
				to_chat(user, span_notice("You fumble to draw a grenade..."))
				var/obj/O = tweps[tweps.len]
				tweps -= O
				user.put_in_hands(O)
				update_icon()
		return TRUE

/obj/item/bmbstrap/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += "Its current capacity is: ([tweps.len]/[max_storage])"
		. += "It contains: [counting_english_list(tweps)]"

/obj/item/bmbstrap/update_icon()
	switch(tweps.len)
		if(1)
			icon_state = "[item_state]1"
		if(2)
			icon_state = "[item_state]1"
		if(3)
			icon_state = "[item_state]2"
		if(4)
			icon_state = "[item_state]2"
		if(5)
			icon_state = "[item_state]3"
		if(6)
			icon_state = "[item_state]3"
		if(7)
			icon_state = "[item_state]4"
		if(8)
			icon_state = "[item_state]4"
		if(9)
			icon_state = "[item_state]5"
		if(10)
			icon_state = "[item_state]5"
		else
			icon_state = "[item_state]0"


/obj/item/bmbstrap/Initialize()
	. = ..()

/obj/item/bmbstrap/attack_turf(turf/T, mob/living/user)
	if(tweps.len >= max_storage)
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))
	for(var/obj/item/bomb in T.contents)
		if(istype(bomb, /obj/item/bomb) || istype(bomb, /obj/item/tntstick) || istype(bomb, /obj/item/impact_grenade))
			if(do_after(user, 5))
				if(!eatbomb(bomb))
					break

/obj/item/bmbstrap/proc/eatbomb(obj/A)
	if(istype(A, /obj/item/bomb) || istype(A, /obj/item/tntstick) || istype(A, /obj/item/impact_grenade))
		if(tweps.len < max_storage)
			A.forceMove(src)
			tweps += A
			update_icon()
			return TRUE
		else
			return FALSE

/obj/item/bmbstrap/attack_self(mob/living/user)
	..()

	if (!tweps.len)
		return
	to_chat(user, span_warning("I begin to take out the ammunition from [src], one by one..."))
	for(var/obj/item/bomb in tweps)
		if(istype(bomb, /obj/item/bomb) || istype(bomb, /obj/item/tntstick) || istype(bomb, /obj/item/impact_grenade))
			if(!do_after(user, 0.5 SECONDS))
				return
			bomb.forceMove(user.loc)
			tweps -= bomb

	update_icon()

/obj/item/bmbstrap/bomb_and_fire/Initialize(mapload)
	. = ..()
	fill_list = list(/obj/item/bomb,
	/obj/item/bomb,
	/obj/item/bomb,
	/obj/item/bomb,
	/obj/item/tntstick,
	/obj/item/tntstick,
	/obj/item/impact_grenade/explosion,
	/obj/item/impact_grenade/explosion,
	/obj/item/impact_grenade/smoke/fire_gas,
	/obj/item/impact_grenade/smoke/fire_gas,
	)
	for(var/i in 1 to max_storage)
		var/pickitem = pick(fill_list)
		fill_list -= pickitem

		var/obj/item/I = new pickitem(src)
		I.forceMove(src)
		tweps += I
	update_icon()

/obj/item/bmbstrap/firebomb/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/bomb/I = new(src)
		I.forceMove(src)
		tweps += I
	update_icon()
