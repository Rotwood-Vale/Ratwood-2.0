/proc/get_dildo_in_either_hand(mob/living/carbon/human/user)
	for(var/obj/item/thing in user.held_items)
		if(thing == null)
			continue
		if(!istype(thing, /obj/item/dildo))
			continue
		return thing
	return null

/proc/get_dildo_on_belt(mob/living/carbon/human/user)
	var/obj/item/storage/belt/rogue/belt = user.belt
	if(istype(belt) && belt?.attached_toy)
		return belt.attached_toy
	return null
