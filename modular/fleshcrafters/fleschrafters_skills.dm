/obj/effect/proc_holder/spell/self/flesharm
	name = "Flesh Arm"
	desc = "Grow a flesh arm weapon from your right hand."
	overlay_state = "flesharm"
	antimagic_allowed = TRUE
	recharge_time = 20
	ignore_cockblock = TRUE

	var/obj/item/rogueweapon/fleshcrafter_flesharm/extended_right = null
	var/static/flesharm_type = /obj/item/rogueweapon/fleshcrafter_flesharm


/obj/effect/proc_holder/spell/self/flesharm/cast(list/targets, mob/user)
	. = ..()

	if(!user.has_hand_for_held_index(RIGHT_HANDS))
		return TRUE

	var/obj/item/current = user.get_item_for_held_index(RIGHT_HANDS)

	if(!current)
		var/obj/item/rogueweapon/fleshcrafter_flesharm/new_item = new(user)
		user.put_in_r_hand(new_item)
		extended_right = new_item
		RegisterSignal(new_item, COMSIG_QDELETING, PROC_REF(clear_right))
		return TRUE

	if(istype(current, flesharm_type))
		user.temporarilyRemoveItemFromInventory(I = current, force = TRUE)
		qdel(current)
		extended_right = null
		return TRUE

	return TRUE


/obj/effect/proc_holder/spell/self/flesharm/proc/clear_right(datum/source)
	SIGNAL_HANDLER
	if(extended_right == source)
		extended_right = null

/obj/item/rogueweapon/fleshcrafter_flesharm
	name = "flesh arm"
	desc = "A weaponized mass of flesh formed around your arm."
	icon = 'modular/fleshcrafters/fleshcrafters.dmi'
	icon_state = "flesharm"
	w_class = WEIGHT_CLASS_NORMAL
	force = 12


//