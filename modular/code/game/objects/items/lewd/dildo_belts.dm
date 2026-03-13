/obj/item/storage/belt/rogue
	var/obj/item/dildo/attached_toy = null

/obj/item/storage/belt/rogue/Destroy()
	if(attached_toy)
		vis_contents -= attached_toy
		attached_toy.forceMove(drop_location())
		attached_toy.update_icon()
		attached_toy.is_attached_to_belt = FALSE
		attached_toy = null
	return ..()

/obj/item/storage/belt/rogue/examine()
	. = ..()
	if(attached_toy)
		. += "[span_notice("\An [attached_toy] appears attached to \the [initial(name)]. Alt+RMB to remove it.")]"

/obj/item/storage/belt/rogue/leather/attackby(obj/item/I, mob/user, params)
	if(!istype(I, /obj/item/dildo/))
		return ..()
	var/obj/item/dildo/held_dildo = I
	if(held_dildo.is_attached_to_belt) // this dildo is already attached to a belt, don't attempt to attach to another belt
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

/obj/item/storage/belt/rogue/update_icon()
	. = ..()
	if(attached_toy)
		var/matrix/M = new
		M.Scale(-0.8,-0.8)
		attached_toy.transform = M
		attached_toy.pixel_y = -6
		attached_toy.vis_flags = VIS_INHERIT_ID | VIS_INHERIT_LAYER | VIS_INHERIT_PLANE
