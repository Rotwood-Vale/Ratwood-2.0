/obj/item/bmbstrap
	name = "Bombdolier"
	desc = ""
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
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	alternate_worn_layer = UNDER_CLOAK_LAYER
	strip_delay = 20
	var/max_storage = 5
	var/list/tweps = list()
	sewrepair = TRUE

/obj/item/bmbstrap/attackby(obj/A, mob/living/carbon/user, params)
	if(istype(A, /obj/item/impact_grenade/smoke/mute_gas) || istype(A, /obj/item/impact_grenade/smoke/blind_gas) || istype(A, /obj/item/impact_grenade/smoke/fire_gas) || istype(A,/obj/item/impact_grenade/smoke/healing_gas) || istype(A,/obj/item/impact_grenade/smoke/poison_gas) || istype(A,/obj/item/impact_grenade/explosion))
		if(tweps.len < max_storage)
			user.transferItemToLoc(A, tweps)
			tweps += A
			update_icon()
		else
			to_chat(loc, span_warning("Full!"))
		return
	..()


/obj/item/bmbstrap/examine(mob/user)
	. = ..()
	if(tweps.len)
		. += span_notice("[tweps.len] inside.")

/obj/item/bmbstrap/update_icon()
	switch(tweps.len)
		if(1)
			icon_state = "bombdolier2"
		if(2)
			icon_state = "bombdolier3"
		if(3)
			icon_state = "bombdolier4"
		if(4)
			icon_state = "bombdolier5"
		if(5)
			icon_state = "bombdolier6"
		else
			icon_state = "bombdolier1"

/obj/item/bmbstrap/Initialize()
	. = ..()
