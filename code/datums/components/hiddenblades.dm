/datum/component/hidden_blades
	var/list/hidden_items = list()
	var/allowed_type = /obj/item/rogueweapon/huntingknife
	var/max_capacity = 2
	var/insert_sound
	var/deploy_sound
	var/jammed_message
	var/deploy_message

/datum/component/hidden_blades/Initialize(insert_sound, deploy_sound, jammed_message, deploy_message, allowed_type = /obj/item/rogueweapon/huntingknife, max_capacity = 2)
	. = ..()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	src.insert_sound = insert_sound
	src.deploy_sound = deploy_sound
	src.jammed_message = jammed_message
	src.deploy_message = deploy_message
	src.allowed_type = allowed_type
	src.max_capacity = max_capacity
	return .

/datum/component/hidden_blades/proc/stow(obj/item/storing_item, mob/living/carbon/user)
	var/obj/item/holder = parent
	if(!istype(storing_item, allowed_type))
		return FALSE
	if(length(hidden_items) >= max_capacity)
		to_chat(user, span_warning("My [parent] already has daggers slotted into it."))
		return TRUE
	if(holder.obj_integrity <= 0)
		to_chat(user, span_warning("[jammed_message]"))
		return TRUE
	if(!user.transferItemToLoc(storing_item, parent))
		return FALSE
	to_chat(user, span_warning("I quickly slot [storing_item] into [parent]!"))
	hidden_items += storing_item
	playsound(user, insert_sound)
	return TRUE

/datum/component/hidden_blades/proc/deploy(mob/user)
	var/obj/item/holder = parent
	if(holder.obj_integrity <= 0)
		to_chat(user, span_warning("[jammed_message]"))
		return TRUE
	if(!length(hidden_items))
		return FALSE
	var/active_empty = !user.get_active_held_item()
	var/inactive_empty = !user.get_inactive_held_item()
	if(!active_empty && !inactive_empty)
		to_chat(user, span_warning("I need a free hand to deploy my dagger!"))
		return TRUE
	user.visible_message(span_warning("[deploy_message]"), span_warning("I flick my wrists in a swift motion."))
	for(var/obj/item/hidden_item in hidden_items.Copy())
		if(!(active_empty || inactive_empty))
			break
		if(user.put_in_hands(hidden_item))
			hidden_items -= hidden_item
			active_empty = !user.get_active_held_item()
			inactive_empty = !user.get_inactive_held_item()
	playsound(user, deploy_sound)
	return TRUE

/datum/component/hidden_blades/proc/empty_hidden_items()
	for(var/obj/item/hidden_item in hidden_items.Copy())
		hidden_item.forceMove(get_turf(parent))
		hidden_items -= hidden_item
	return TRUE
