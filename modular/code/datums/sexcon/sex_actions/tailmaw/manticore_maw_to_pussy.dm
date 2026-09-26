/datum/sex_action/manticore_maw_to_pussy
	parent_type = /datum/sex_action/tailmaw
	name = "Seal tail maw over their pussy"
	check_same_tile = FALSE
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_CUNT
	user_sex_part = SEX_PART_TAIL_MAW

/datum/sex_action/manticore_maw_to_pussy/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]'s tail curls between [target]'s thighs, the maw blooming open to press flush against [target]'s cunt, sealing tight as the feelers inside spill out to taste the slick folds."))
	playsound(target, 'sound/misc/mat/insert (1).ogg', 25, TRUE, ignore_walls = FALSE)

/datum/sex_action/manticore_maw_to_pussy/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user]'s tail feelers lazily explore [target]'s folds, the tiny tendrils tracing the labia with maddening precision, a few bolder ones slipping just inside the entrance to taste the warmth within."
		if(SEX_FORCE_MID)
			message = "The feelers push deeper into [target]'s cunt, dozens of tiny tendrils wriggling past the entrance and carpeting [target]'s inner walls, each one pulsing independently as they secrete their sweet, tingling venom against every sensitive ridge."
		if(SEX_FORCE_HIGH)
			message = "[user]'s tail maw bears down on [target]'s pussy with crushing suction, the feelers invading in a writhing mass, filling [target]'s insides as the tendrils lash against [target]'s cervix, pumping venom and nectar in alternating waves."
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user]'s tail seals [target]'s cunt completely, the maw vacuum-locked as every feeler inside bores deeper, a churning mass of tendrils stretching [target]'s walls and flooding [target]'s womb with sweet slick until [target]'s stomach visibly distends."
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.make_sucking_noise()
	user.sexcon.perform_sex_action(target, 4, 1, TRUE)
	user.sexcon.perform_sex_action(user, 2, 0, FALSE)
	user.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)

/datum/sex_action/manticore_maw_to_pussy/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]'s tail peels free from [target]'s pussy with a long, wet sucking sound, the feelers withdrawing one by one as a flood of nectar pours from [target]'s gaping, trembling cunt."))

/datum/sex_action/manticore_maw_to_pussy/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return target.sexcon.finished_check()
