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

/datum/sex_action/proc/modular_get_orison_patron_data(patron_type)
	var/static/list/orison_default_data = list(
		"message" = "",
		"arousal_mult" = 2,
		"pain" = 0
	)
	var/static/list/orison_none_data = list(
		"message" = "but nothing unusual happens...",
		"arousal_mult" = 0,
		"pain" = 0
	)
	var/static/list/orison_painful_glow_data = list(
		"message" = "the glow looks painful...",
		"arousal_mult" = 2,
		"pain" = 5
	)
	var/static/list/orison_indulgence_data = list(
		"message" = "the air grows sweet with indulgence...",
		"arousal_mult" = 15,
		"pain" = 0,
		"indulgence" = TRUE
	)
	var/static/list/orison_harsh_data = list(
		"message" = "that looks painful...",
		"arousal_mult" = 2,
		"pain" = 15
	)
	var/static/list/orison_ominous_data = list(
		"message" = "an ominous veil enveloping it...",
		"arousal_mult" = 1,
		"pain" = 0
	)
	var/static/list/orison_primal_data = list(
		"message" = "with primal force...",
		"arousal_mult" = 6,
		"pain" = 10
	)
	var/static/list/orison_cold_data = list(
		"message" = "a cold aura enveloping it...",
		"arousal_mult" = 4,
		"pain" = 5
	)
	var/static/list/orison_jingle_data = list(
		"message" = "where is that jingle coming from?",
		"arousal_mult" = 4,
		"pain" = 0,
		"jingle" = TRUE
	)

	switch(patron_type)
		if(/datum/patron/old_god)
			return orison_none_data

		if(/datum/patron/divine/astrata, /datum/patron/divine/malum, /datum/patron/inhumen/matthios)
			return orison_painful_glow_data

		if(/datum/patron/divine/eora, /datum/patron/inhumen/baotha)
			return orison_indulgence_data

		if(/datum/patron/divine/ravox, /datum/patron/inhumen/graggar)
			return orison_harsh_data

		if(/datum/patron/divine/noc)
			return orison_ominous_data

		if(/datum/patron/divine/abyssor, /datum/patron/divine/dendor)
			return orison_primal_data

		if(/datum/patron/divine/necra, /datum/patron/inhumen/zizo)
			return orison_cold_data

		if(/datum/patron/divine/xylix)
			return orison_jingle_data

	return orison_default_data

/datum/sex_action/proc/modular_try_show_orison_indulgence_notice(mob/living/carbon/human/receiver, mob/living/carbon/human/performer, list/orison_data)
	if(!receiver || !performer || !performer.sexcon || !islist(orison_data))
		return
	if(!orison_data["indulgence"])
		return
	if(performer.sexcon.orison_indulgence_notice_shown)
		return

	performer.sexcon.orison_indulgence_notice_shown = TRUE
	to_chat(receiver, span_love("The pleasure is overwhelming!!!"))
