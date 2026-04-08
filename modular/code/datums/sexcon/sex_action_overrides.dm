/datum/sex_action/chastityplay/proc/modular_get_chastity_device_name(mob/living/carbon/human/owner)
	if(owner?.sexcon?.has_chastity_flat())
		return "flat cage"
	if(owner?.sexcon?.has_chastity_cage())
		return "cage"
	return "chastity device"

/datum/sex_action/chastityplay/proc/modular_requires_other_target(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return !!(user && target && user != target)

/datum/sex_action/chastityplay/proc/modular_target_has_cage(mob/living/carbon/human/target)
	return !!target?.sexcon?.has_chastity_cage()

/datum/sex_action/chastityplay/proc/modular_target_has_front_chastity(mob/living/carbon/human/target)
	return !!(target?.sexcon?.has_chastity_cage() || target?.sexcon?.has_chastity_vagina())

/datum/sex_action/chastityplay/proc/modular_can_reach_target_groin(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!user || !target)
		return FALSE
	return check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE)

/datum/sex_action/chastityplay/proc/modular_play_chastity_impact_sound(mob/living/carbon/human/target, sound_to_play, volume = 40, chance = 100, vary = TRUE, frequency = -1)
	if(!target || !sound_to_play)
		return FALSE
	if(chance < 100 && !prob(chance))
		return FALSE
	if(islist(sound_to_play))
		if(!length(sound_to_play))
			return FALSE
		playsound(get_turf(target), pick(sound_to_play), volume, vary, frequency)
		return TRUE
	playsound(get_turf(target), sound_to_play, volume, vary, frequency)
	return TRUE

/mob/living/carbon/human/proc/modular_handle_werewolf_transform_chastity()
	if(!istype(chastity_device, /obj/item/chastity))
		return FALSE
	var/obj/item/chastity/chastity = chastity_device
	chastity.break_on_werewolf_transform(src)
	return TRUE
