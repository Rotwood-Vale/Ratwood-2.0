/proc/resolve_collar_command_master(mob/living/carbon/human/pet)
	if(!pet)
		return null

	var/obj/item/clothing/neck/roguetown/cursed_collar/collar = pet.get_item_by_slot(SLOT_NECK)
	if(istype(collar) && collar.collar_master)
		return collar.collar_master

	var/obj/item/chastity/device = pet.chastity_device
	if(istype(device) && device.chastity_cursed && device.chastity_master)
		return device.chastity_master

	return null

/proc/format_control_log_actor(datum/mind/controller)
	if(controller?.current)
		return key_name(controller.current)
	return "Unknown controller"

/proc/log_collar_command(mob/living/carbon/human/pet, log_type, details = "")
	if(!pet)
		return

	var/datum/mind/controller = resolve_collar_command_master(pet)
	var/log_line = "COLLAR: [format_control_log_actor(controller)] -> [key_name(pet)] [log_type]"
	if(length(details))
		log_line += " ([details])"
	log_game(log_line)

	var/self_entry = "Collar command [log_type]"
	if(length(details))
		self_entry += " ([details])"
	pet.log_message(self_entry, LOG_GAME)

	if(controller?.current)
		controller.current.log_message("Collar command [log_type] on [pet]" + (length(details) ? " ([details])" : ""), LOG_GAME)

/proc/log_chastity_command(mob/living/carbon/human/wearer, datum/mind/controller, log_type, details = "", is_remote = FALSE)
	if(!wearer)
		return

	var/log_line = "CHASTITY: [format_control_log_actor(controller)] -> [key_name(wearer)] [log_type]"
	if(is_remote)
		log_line += " (remote)"
	if(length(details))
		log_line += " ([details])"
	log_game(log_line)

	var/self_entry = "Chastity command [log_type]"
	if(is_remote)
		self_entry += " (remote)"
	if(length(details))
		self_entry += " ([details])"
	wearer.log_message(self_entry, LOG_GAME)

	if(controller?.current)
		controller.current.log_message("Chastity command [log_type] on [wearer]" + (is_remote ? " (remote)" : "") + (length(details) ? " ([details])" : ""), LOG_GAME)