/datum/sex_action/manticore_tail_sounding
	parent_type = /datum/sex_action/tailmaw
	name = "Sound them with tail feelers"
	check_same_tile = FALSE
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_COCK
	user_sex_part = SEX_PART_TAIL_MAW

/datum/sex_action/manticore_tail_sounding/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]'s tail maw blooms open against [target]'s cock, the feelers prodding curiously at the tip before a thin tendril traces circles around [target]'s slit, then pushes its way inside."))
	playsound(target, 'sound/misc/mat/insert (1).ogg', 15, TRUE, ignore_walls = FALSE)

/datum/sex_action/manticore_tail_sounding/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "A single feeler worms its way deeper into [target]'s urethra, the tendril pulsing with warmth as it secretes a tingling venom that numbs the initial burn, slowly easing the tissue open from within."
		if(SEX_FORCE_MID)
			message = "Two feelers push into [target]'s dickhole, the tiny tendrils spiraling around each other as they probe deeper, their tips smearing venom against the hardly-touched inner walls until the burning fades into a buzzing, electric pleasure."
		if(SEX_FORCE_HIGH)
			message = "A bundle of feelers forces its way into [target]'s urethra, the tendrils wriggling deeper with each pulse, stretching the slit wider than it was ever meant to go as they pump their tingling toxin into every raw inch of tissue."
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user]'s feelers flood [target]'s cock from within, a writhing mass of tendrils bulging the shaft visibly as they bore deeper, venom pouring into the abused canal until [target]'s entire length throbs and twitches with involuntary spasms."
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.make_sucking_noise()
	// Sounding: high pain, moderate arousal
	user.sexcon.perform_sex_action(target, 1, 7, TRUE)
	user.sexcon.try_do_pain_scream(target, 7)
	target.sexcon.handle_passive_ejaculation(user)
	user.sexcon.perform_sex_action(user, 1, 0, FALSE)
	user.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)

/datum/sex_action/manticore_tail_sounding/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]'s feelers slowly retract from [target]'s urethra one by one, each tendril pulling free with a faint pop, leaving the slit gaping and drooling a mixture of pre and sweet venom."))

/datum/sex_action/manticore_tail_sounding/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return target.sexcon.finished_check()

/datum/sex_action/manticore_tail_sounding/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!..())
		return FALSE
	var/obj/item/organ/penis/penis = target.getorganslot(ORGAN_SLOT_PENIS)
	return penis.sheath_type != SHEATH_TYPE_SLIT
