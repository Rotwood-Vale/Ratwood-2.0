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
	return "未知控制者"

/proc/log_collar_command(mob/living/carbon/human/pet, log_type, details = "")
	if(!pet)
		return

	var/datum/mind/controller = resolve_collar_command_master(pet)
	var/log_line = "COLLAR: [format_control_log_actor(controller)] -> [key_name(pet)] [log_type]"
	if(length(details))
		log_line += " ([details])"
	log_game(log_line)

	var/self_entry = "项圈指令 [log_type]"
	if(length(details))
		self_entry += " ([details])"
	pet.log_message(self_entry, LOG_GAME)

	if(controller?.current)
		controller.current.log_message("对[pet]执行项圈指令 [log_type]" + (length(details) ? "（[details]）" : ""), LOG_GAME)

/proc/log_chastity_command(mob/living/carbon/human/wearer, datum/mind/controller, log_type, details = "", is_remote = FALSE)
	if(!wearer)
		return

	var/log_line = "CHASTITY: [format_control_log_actor(controller)] -> [key_name(wearer)] [log_type]"
	if(is_remote)
		log_line += " (remote)"
	if(length(details))
		log_line += " ([details])"
	log_game(log_line)

	var/self_entry = "贞操指令 [log_type]"
	if(is_remote)
		self_entry += "（远程）"
	if(length(details))
		self_entry += "（[details]）"
	wearer.log_message(self_entry, LOG_GAME)

	if(controller?.current)
		controller.current.log_message("对[wearer]执行贞操指令 [log_type]" + (is_remote ? "（远程）" : "") + (length(details) ? "（[details]）" : ""), LOG_GAME)
