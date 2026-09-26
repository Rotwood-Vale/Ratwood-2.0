/datum/sex_action/manticore_tailjob
	parent_type = /datum/sex_action/tailmaw
	name = "Engulf their cock with tail maw"
	check_same_tile = FALSE
	target_sex_part = SEX_PART_COCK
	user_sex_part = SEX_PART_TAIL_MAW

/datum/sex_action/manticore_tailjob/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]'s tail blooms open, the bonelike plates fanning apart as the maw descends over [target]'s cock, feelers latching on with a wet, suckling desperation."))
	playsound(target, 'sound/misc/mat/insert (1).ogg', 25, TRUE, ignore_walls = FALSE)

/datum/sex_action/manticore_tailjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user]'s tail pulses in slow, languid waves around [target]'s cock, the feelers inside tracing every ridge with agonizing care."
		if(SEX_FORCE_MID)
			message = "[user]'s tail maw suckles [target]'s cock in deliberate, milking contractions, the feelers spiraling tighter with each pulse."
		if(SEX_FORCE_HIGH)
			message = "[user]'s tail clamps down hard around [target]'s cock, the feelers inside writhing in frantic waves, the vacuum seal making an obscene, wet squelch."
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user]'s tail maw bears down on [target]'s cock with bruising force, every feeler suctioned tight and pumping, the muscular walls milking in crushing, rhythmic spasms."
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.make_sucking_noise()
	user.sexcon.perform_sex_action(target, 3, 0, TRUE)
	handle_tailmaw_ejaculation(user, target, target, user)
	user.sexcon.perform_sex_action(user, 2, 0, FALSE)
	user.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)

/datum/sex_action/manticore_tailjob/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]'s tail releases [target]'s cock with a wet pop, the feelers reluctantly peeling free one by one."))
	playsound(target, 'sound/misc/mat/insert (2).ogg', 20, TRUE, ignore_walls = FALSE)

/datum/sex_action/manticore_tailjob/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
