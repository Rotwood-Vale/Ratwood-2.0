/mob/living/carbon/proc/carbon_modular_examine_extension(mob/user, t_He, m1, m2, m3)
	var/list/lines = list()
	if(sexcon?.has_chastity_cage() && get_location_accessible(src, BODY_ZONE_PRECISE_GROIN))
		lines += "[t_He] is wearing a chastity device!\n"
	return lines

/mob/living/carbon/human/proc/human_modular_examine_extension(mob/user, observer_privilege, m1, m2, m3)
	var/list/lines = list()
	var/user_is_gnoll = FALSE
	var/user_is_clergy = FALSE
	var/user_is_inquisition = FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		user_is_gnoll = H.dna?.species?.id == "gnoll"
		user_is_inquisition = HAS_TRAIT(H, TRAIT_INQUISITION) || (H.mind?.assigned_role in GLOB.inquisition_positions)
		user_is_clergy = user_is_inquisition || (H.mind?.assigned_role in GLOB.church_positions)
		if(user_is_gnoll)
			var/datum/antagonist/gnoll/gnoll_antag = H.mind?.has_antag_datum(/datum/antagonist/gnoll)
			if(gnoll_antag?.is_examine_marked_target(src))
				lines += span_cultsmall("Graggar has marked them!")
			if(src.has_gnoll_scent_this_round)
				lines += span_cultsmall("They have gnoll scent, a breeder!")
	if(src.has_gnoll_scent_this_round && !user_is_gnoll)
		if(user_is_inquisition)
			lines += span_warning("They reek of profane beast-taint. This demands scrutiny.")
		else if(user_is_clergy)
			lines += span_warning("A profane, feral scent clings to them.")
		else
			lines += span_warning("They have a strange scent about them...")
	var/perception_level = 15
	if(isliving(user))
		var/mob/living/L = user
		perception_level = L.STAPER

	var/obj/item/chastity/worn_chastity = chastity_device
	if(worn_chastity)
		var/chastity_name = get_examine_item_name_with_custom_link(user, worn_chastity)
		var/cage_exposed = observer_privilege || get_location_accessible(src, BODY_ZONE_PRECISE_GROIN)
		if(cage_exposed)
			if(perception_level >= 15)
				lines += span_aiprivradio("[m1] secured in [chastity_name].")
			else if(perception_level >= 8)
				lines += span_aiprivradio("[m1] wearing [chastity_name].")
			else
				lines += span_warning("[m1] wearing some kind of intimate restraint.")
		else if(perception_level >= 15)
			lines += span_aiprivradio("[m1] wearing a chastity device under [m2] clothes.")

	return lines

/mob/living/carbon/human/proc/human_modular_chastity_toy_examine_line(mob/user, m2, m3)
	if(!chastity_device?.attached_toy)
		return null
	var/perception_level = 15
	if(isliving(user))
		var/mob/living/L = user
		perception_level = L.STAPER
	if(!isobserver(user) && !get_location_accessible(src, BODY_ZONE_PRECISE_GROIN))
		return null
	if(!isobserver(user) && perception_level < 8)
		return null
	return "[m3] [get_examine_item_name_with_custom_link(user, chastity_device.attached_toy)] attached to [m2] chastity device. "
