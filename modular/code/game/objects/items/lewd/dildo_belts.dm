/obj/item/storage/belt/rogue
	var/obj/item/dildo/attached_toy = null

/obj/item/storage/belt/rogue/Destroy()
	if(attached_toy)
		vis_contents -= attached_toy
		attached_toy.forceMove(drop_location())
		attached_toy.update_icon()
		attached_toy.is_attached_to_belt = FALSE
		attached_toy = null
	refresh_toy_overlay()
	return ..()

/obj/item/storage/belt/rogue/examine()
	. = ..()
	if(attached_toy)
		. += "[span_notice("\An [attached_toy] appears attached to \the [initial(name)]. Alt+RMB to remove it.")]"

// Prevent equipping a toy belt if the wearer already has a toy attached to their chastity device, since the belt and chastity device share the same sprite overlay for attached toys and it would cause visual bugs to have toys on both at the same time. The same check is done in reverse when trying to attach a toy to a belt while wearing a chastity device with an attached toy in chastity_core.dm.
/obj/item/storage/belt/rogue/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(!..())
		return FALSE
	if(slot != SLOT_BELT)
		return TRUE
	if(!attached_toy || !ishuman(M))
		return TRUE
	var/mob/living/carbon/human/H = M
	if(H.chastity_device?.attached_toy)
		if(!disable_warning)
			var/mob/living/warn_target = equipper ? equipper : M
			to_chat(warn_target, span_warning("[H] cannot wear a toy belt while [H.p_they()] already [H.p_have()] a toy mounted to [H.p_their()] chastity device."))
		return FALSE
	return TRUE

/obj/item/storage/belt/rogue/leather/attackby(obj/item/I, mob/user, params)
	if(!istype(I, /obj/item/dildo/))
		return ..()
	var/obj/item/dildo/held_dildo = I
	if(held_dildo.is_attached_to_belt) // this dildo is already attached to a belt, don't attempt to attach to another belt
		return
	if(istype(loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = loc
		if(H.chastity_device?.attached_toy)
			to_chat(user, span_warning("[H] already has a toy attached to [H.p_their()] chastity device."))
			return
	if(attached_toy) // belt already has attached toy
		to_chat(user, span_info("\The [initial(name)] already has a toy attached! Remove it first."))
		return
	if(!user.transferItemToLoc(held_dildo, null)) // we're not storing the dildo inside the belt, rather we're moving it to nullspace then restoring it on delete/deattachment
		to_chat(user, span_warning("\The [held_dildo] is stuck to your hand!"))
		return
	held_dildo.is_attached_to_belt = TRUE
	user.visible_message(span_warning("[user] equips \the [held_dildo] onto \the [initial(name)]."))
	attached_toy = held_dildo
	playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
	vis_contents += attached_toy
	update_icon()
	refresh_toy_overlay()

/obj/item/storage/belt/rogue/AltRightClick(mob/user)
	if(!attached_toy)
		return
	if(!isliving(user) || !user.TurfAdjacent(src))
		return
	if(user.get_active_held_item())
		to_chat(user, span_info("I can't do that with my hand full!"))
		return
	user.visible_message(span_warning("[user] removes \the [attached_toy] from \the [initial(name)]."))
	vis_contents -= attached_toy
	if(!user.put_in_hands(attached_toy))
		var/atom/movable/S = attached_toy
		S.forceMove(get_turf(src))
	attached_toy.update_icon()
	attached_toy.is_attached_to_belt = FALSE
	attached_toy = null
	update_icon()
	refresh_toy_overlay()

/obj/item/storage/belt/rogue/proc/refresh_toy_overlay()
	if(!istype(loc, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = loc
	if(H.belt != src)
		return
	H.update_inv_belt()

/obj/item/storage/belt/rogue/update_icon()
	. = ..()
	if(attached_toy)
		var/matrix/M = new
		M.Scale(-0.8,-0.8)
		attached_toy.transform = M
		attached_toy.pixel_y = -6
		attached_toy.vis_flags = VIS_INHERIT_ID | VIS_INHERIT_LAYER | VIS_INHERIT_PLANE
