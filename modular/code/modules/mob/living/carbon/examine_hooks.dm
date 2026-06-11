/mob/living/carbon/proc/carbon_modular_examine_extension(mob/user, t_He, m1, m2, m3)
	var/list/lines = list()
	if(sexcon?.has_chastity_cage() && get_location_accessible(src, BODY_ZONE_PRECISE_GROIN))
		lines += "[t_He]穿着一个贞操装置！\n"
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
			if(src.has_gnoll_scent_this_round)
				lines += span_cultsmall("他们身上有豺狼人的气味，是个繁育者！")
	if(src.has_gnoll_scent_this_round && !user_is_gnoll)
		if(user_is_inquisition)
			lines += span_warning("他们散发着亵渎的兽类污秽气息，必须严加审视。")
		else if(user_is_clergy)
			lines += span_warning("一股亵渎而野性的气味萦绕在他们身上。")
		else
			lines += span_warning("他们身上有种古怪的气味......")
	var/perception_level = 15
	if(isliving(user))
		var/mob/living/L = user
		perception_level = L.STAPER

	var/obj/item/chastity/worn_chastity = chastity_device
	if(worn_chastity)
		var/chastity_name = get_examine_item_name_with_hover(user, worn_chastity)
		var/cage_exposed = observer_privilege || get_location_accessible(src, BODY_ZONE_PRECISE_GROIN)
		if(cage_exposed)
			if(perception_level >= 15)
				lines += span_aiprivradio("[m1]被固定在[chastity_name]中。")
			else if(perception_level >= 8)
				lines += span_aiprivradio("[m1]穿着[chastity_name]。")
			else
				lines += span_warning("[m1]穿着某种私密束缚装置。")
		else if(perception_level >= 15)
			lines += span_aiprivradio("[m1]在[m2]的衣物下穿着贞操装置。")

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
	return "[m3]的[get_examine_item_name_with_hover(user, chastity_device.attached_toy)]装在[m2]的贞操装置上。 "
