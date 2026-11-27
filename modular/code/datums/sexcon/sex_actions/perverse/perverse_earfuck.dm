/datum/sex_action/perverse_earfuck
	parent_type = /datum/sex_action/perverse
	name = "Fuck their ear"
	check_same_tile = FALSE
	user_sex_part = SEX_PART_COCK
	user_needs_functional = TRUE
	target_sex_part = SEX_PART_JAWS
	var/wound_type = /datum/wound/fracture/head/ears

/datum/sex_action/perverse_earfuck/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(span_notice("[user] nestles [user.p_their()] cock against [target]'s ear, pressing forwards into [target.p_their()] ear canal with a firm push."))

/datum/sex_action/perverse_earfuck/proc/apply_force_effects(mob/living/carbon/human/target, force)
	var/obj/item/organ/ears/ears = target.getorganslot(ORGAN_SLOT_EARS)
	if(!ears || ears.damage_multiplier <= 0)
		return

	var/blurriness = 0
	var/ringing_volume = 0
	switch(force)
		if(SEX_FORCE_LOW)
			ringing_volume = 10
		if(SEX_FORCE_MID)
			blurriness = 2
			ringing_volume = 20
		if(SEX_FORCE_HIGH)
			blurriness = 5
			ringing_volume = 35
		if(SEX_FORCE_EXTREME)
			blurriness = 8
			ringing_volume = 50
			target.apply_status_effect(/datum/status_effect/knot_fucked_stupid)
		if(SEX_FORCE_LUDICROUS)
			blurriness = 10
			ringing_volume = 65
			target.apply_status_effect(/datum/status_effect/knot_fucked_stupid)

	if(blurriness > target.eye_blurry)
		target.set_blurriness(blurriness)

	if(ringing_volume && world.time >= target.mob_timers["perverse_earfuck_ringing"])
		target.mob_timers["perverse_earfuck_ringing"] = world.time + 10 SECONDS
		target.playsound_local(target, 'sound/combat/bombard/flash_ring.ogg', ringing_volume, FALSE)

/datum/sex_action/perverse_earfuck/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	try_perverse_bedbreaker_wound(user, target, BODY_ZONE_HEAD, wound_type)
	apply_force_effects(target, user.sexcon.force)
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "A warm, wet feeling comes over [target]'s head as [user]'s cock [user.sexcon.get_generic_force_adjective()] slides through [target.p_their()] ear. The feeling is unnatural, like an unscratchable itch that slowly spreads through [target]'s head."
		if(SEX_FORCE_MID)
			message = "[target] abruptly shudders across [target.p_their()] entire body as [user]'s cock [user.sexcon.get_generic_force_adjective()] intrudes inside [target.p_their()] ear canal. A dizzying sense of delirium washes over [target] as [target.p_their()] eyelids involuntarily twitch."
		if(SEX_FORCE_HIGH)
			message = "[user] works [user.p_their()] cock through [target]'s eardrums, [user.sexcon.get_generic_force_adjective()] driving into the inner ear with a grinding pressure, snuffing out [target]'s hearing with a slick, wet noise."
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "Overwhelming heat floods [target]'s head as [user] [user.sexcon.get_generic_force_adjective()] drills the ruined cavity. Anything coherent left in [target]'s brain drowns in the sensation of [user]'s cock using [target.p_their()] skull."
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.oralcourse_noise(target, TRUE)
	user.sexcon.perform_sex_action(target, 2, 0, TRUE)
	user.sexcon.perform_sex_action(user, 2, 0, FALSE)
	target.sexcon.handle_passive_ejaculation()
	user.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_COCK)
	return TRUE

/datum/sex_action/perverse_earfuck/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(span_notice("[user] pulls [user.p_their()] cock from [target]'s head, trailing bloodied wetness in its wake."))

/datum/sex_action/perverse_earfuck/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return user.sexcon.finished_check() || target.sexcon.finished_check()
