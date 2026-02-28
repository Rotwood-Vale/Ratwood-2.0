/// Try to holds hands with the person also holding your hand. Returns TRUE if we start pass all checks
/mob/living/carbon/proc/try_handhold(mob/living/carbon/target, proximity, params)
	if(!iscarbon(target) || target.cmode || cmode) // No combat handholding
		return

	//Unarmed attack already checked that our arm is grabbed, so we just make sure that we're grabbing back the same hand
	var/body_zone = used_hand == 1 ? BODY_ZONE_PRECISE_L_HAND : BODY_ZONE_PRECISE_R_HAND
	var/obj/item/bodypart/my_hand = get_bodypart(body_zone)
	for(var/obj/item/grabbing/active_grab in target)
		if(active_grab.limb_grabbed == my_hand && zone_selected == active_grab.grab_held_by) // You have to grab the hand that has us
			start_handholding(target)
			return TRUE

/// Begins handholding
/mob/living/carbon/proc/start_handholding(mob/living/carbon/target)
	to_chat(src, span_warning("I hold [target]'s hand"))
	target.handholding = 1
	target.handholding_pixel_shift(1) //XANTODO Check based on hand
	Move(target.loc)
	setDir(target.dir)
	handholding = 2
	handholding_pixel_shift(2)

/mob/proc/check_handholding()
	return

/mob/living/carbon/human/check_handholding()
	if(pulledby && pulledby != src)
		var/obj/item/bodypart/LH
		var/obj/item/bodypart/RH
		LH = get_bodypart(BODY_ZONE_PRECISE_L_HAND)
		RH = get_bodypart(BODY_ZONE_PRECISE_R_HAND)
		if(LH || RH)
			for(var/obj/item/grabbing/G in src.grabbedby)
				if(G.limb_grabbed == LH || G.limb_grabbed == RH)
					return TRUE
