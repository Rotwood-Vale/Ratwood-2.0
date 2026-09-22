/datum/sex_action/manticore_tailpeg
	parent_type = /datum/sex_action/tailmaw
	name = "Peg them with tail"
	check_same_tile = FALSE
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_ANUS
	user_sex_part = SEX_PART_TAIL_MAW

/datum/sex_action/manticore_tailpeg/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]'s tail curls between [target]'s legs, the sealed bud pressing against [target]'s rim before pushing inside with a slow, deliberate pressure."))
	playsound(target, 'sound/misc/mat/insert (1).ogg', 25, TRUE, ignore_walls = FALSE)

/datum/sex_action/manticore_tailpeg/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user]'s tail eases in and out of [target]'s rear, the sealed bud's ridged plates dragging across [target]'s walls with each careful stroke."
		if(SEX_FORCE_MID)
			message = "[user] works [user.p_their()] tail deeper, the bud twisting as it pumps [target]'s ass, plates grinding against the stretched rim."
		if(SEX_FORCE_HIGH)
			message = "[user]'s tail pistons into [target]'s ass, the sealed bud punching deep enough to make [target]'s stomach bulge, plates rattling with each wet thrust."
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user] ruts [target]'s guts with [user.p_their()] tail like an animal, the bud hammering [target]'s insides without care, each thrust accompanied by a sickening wet slap."
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.outercourse_noise(target, TRUE)
	user.sexcon.perform_sex_action(target, 2, 3, TRUE)
	user.sexcon.perform_sex_action(user, 1, 0, TRUE)
	user.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)

/datum/sex_action/manticore_tailpeg/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]'s tail slides free from [target]'s ruined rear, the bud glistening with slick."))

/datum/sex_action/manticore_tailpeg/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return target.sexcon.finished_check()
