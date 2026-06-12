/datum/sex_action/chastityplay/rimming_shield
	name = "从贞操盾后方舔弄"
	user_sex_part = SEX_PART_JAWS
	target_sex_part = SEX_PART_ANUS

/datum/sex_action/chastityplay/rimming_shield/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!requires_other_target(user, target))
		return FALSE
	if(!target.sexcon.has_chastity_anal())
		return FALSE
	return TRUE

/datum/sex_action/chastityplay/rimming_shield/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!requires_other_target(user, target))
		return FALSE
	if(!target.sexcon.has_chastity_anal())
		return FALSE
	if(!can_reach_target_groin(user, target))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	return TRUE

/datum/sex_action/chastityplay/rimming_shield/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]俯下身去，把[user.p_their()]的脸贴上[target]后庭护盾的下缘，寻找能够探入的角度。"))

/datum/sex_action/chastityplay/rimming_shield/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user][user.sexcon.get_generic_force_adjective()]将[user.p_their()]的舌头探入[target]的后庭护盾下方，顺着金属勉强容出的缝隙不断舔弄……"))
	user.sexcon.oralcourse_noise(target)
	user.sexcon.do_thrust_animate(target)

	user.sexcon.perform_sex_action(target, 2, 0, TRUE)
	if(target.sexcon.check_active_ejaculation())
		target.sexcon.ejaculate()

/datum/sex_action/chastityplay/rimming_shield/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]从[target]的护盾后退开来，下颌酸痛地重新直起身。"))

/datum/sex_action/chastityplay/rimming_shield/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE	
	return FALSE
