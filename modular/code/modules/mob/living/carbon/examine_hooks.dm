/mob/living/carbon/proc/carbon_modular_examine_extension(mob/user, t_He, m1, m2, m3)
	var/list/lines = list()
	if(sexcon?.has_chastity_cage() && get_location_accessible(src, BODY_ZONE_PRECISE_GROIN))
		lines += "[t_He] is wearing a chastity device!\n"
	return lines

/mob/living/carbon/human/proc/human_modular_examine_extension(mob/user, observer_privilege, m1, m2, m3)
	var/list/lines = list()
	var/perception_level = 15
	if(user != src && isliving(user))
		var/mob/living/L = user
		perception_level = L.STAPER

	var/obj/item/chastity/worn_chastity = chastity_device
	if(worn_chastity)
		var/cage_exposed = observer_privilege || get_location_accessible(src, BODY_ZONE_PRECISE_GROIN)
		if(cage_exposed || (user != src && perception_level >= 15))
			if(perception_level >= 15)
				var/chastity_msg = cage_exposed ? "[m1] secured in a [worn_chastity.name]." : "[m1] wearing a chastity device under [m2] clothes."
				lines += span_aiprivradio(chastity_msg)
			else if(perception_level >= 8)
				lines += span_aiprivradio("[m1] wearing a [worn_chastity.name].")
			else
				lines += span_warning("[m1] wearing some kind of intimate restraint.")

	return lines

/mob/living/carbon/human/proc/human_modular_chastity_toy_examine_line(mob/user, m2, m3)
	if(chastity_device?.attached_toy)
		return "[m3] [chastity_device.attached_toy.get_examine_string(user)] attached to [m2] chastity device. "
	return null
