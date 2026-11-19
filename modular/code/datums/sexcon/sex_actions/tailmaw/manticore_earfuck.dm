/datum/sex_action/manticore_earfuck
	parent_type = /datum/sex_action/tailmaw
	name = "Fuck their ears with tendrils"
	check_same_tile = FALSE
	user_sex_part = SEX_PART_TAIL_MAW
	var/wound_type = /datum/wound/fracture/head/ears

/datum/sex_action/manticore_earfuck/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(span_notice("[user]'s tail rises, engulfing [target]'s head, its bonelike plates glomping tight as a fan of fuckhungry feelers begin probing [target.p_their()] ears."))

/datum/sex_action/manticore_earfuck/proc/apply_force_effects(mob/living/carbon/human/target, force)
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

	if(ringing_volume && world.time >= target.mob_timers["manticore_earfuck_ringing"])
		target.mob_timers["manticore_earfuck_ringing"] = world.time + 10 SECONDS
		target.playsound_local(target, 'sound/combat/bombard/flash_ring.ogg', ringing_volume, FALSE)

/datum/sex_action/manticore_earfuck/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	try_tailmaw_bedbreaker_wound(user, target, BODY_ZONE_HEAD, wound_type)
	apply_force_effects(target, user.sexcon.force)
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "Gingerly and sweet, the tendrils from [user]'s tail [user.sexcon.get_generic_force_adjective()] pump [target]'s ears, each worming feeler leaving the insides faintly tingling with a heavy, unwanted pressure."
		if(SEX_FORCE_MID)
			message = "Tinnitus fills [target]'s head as [user]'s feelers [user.sexcon.get_generic_force_adjective()] invade [target.p_their()] ear canal. The pressure is wrong, a disorienting wave of fuzzy nausea building behind [target.p_their()] eyes."
		if(SEX_FORCE_HIGH)
			message = "Dozens of tendrils squirms past [target]'s eardrums, [user.sexcon.get_generic_force_adjective()] frotting against [target.p_their()] brain, lacing its squishy ridges with intoxicating envenomed-slick."
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user]'s tail maw [user.sexcon.get_generic_force_adjective()] grips the sides of [target]'s head, feelers swarming into [target.p_their()] head. [target]'s hearing gives way under the onslaught; coherence gives way to deafening ringing and concussive pressure boring into [target.p_their()] skull."
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.oralcourse_noise(target, TRUE)
	user.sexcon.perform_sex_action(target, 2, 0, TRUE)
	user.sexcon.perform_sex_action(user, 2, 0, FALSE)
	target.sexcon.handle_passive_ejaculation()
	user.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)
	return TRUE

/datum/sex_action/manticore_earfuck/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(span_notice("[user]'s tail draws away from [target]'s head, tendrils pulled free from [target.p_their()] ravaged ears leaving them weeping with a stewed mixed of venom, blood, and intercranial juices."))

/datum/sex_action/manticore_earfuck/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return user.sexcon.finished_check() || target.sexcon.finished_check()
