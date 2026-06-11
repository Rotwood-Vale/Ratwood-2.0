/datum/sex_action/spanking
	name = "拍打对方屁股"
	// Allow through all clothes, so no body zone accessibility check for clothing
	check_same_tile = FALSE
	do_time = 2.5 SECONDS // Slightly faster than average for repeated action
	stamina_cost = 0
	category = SEX_CATEGORY_HANDS

/datum/sex_action/spanking/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/spanking/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!user.sexcon.Adjacent_Or_Closet(target))
		return FALSE
	// No clothing or body zone checks, can always spank
	return TRUE

/datum/sex_action/spanking/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]摆好了[user.p_their()]的手，准备拍打[target]的屁股！"))

/datum/sex_action/spanking/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/force = user.sexcon.force
	var/sound = pick('sound/foley/slap.ogg', 'sound/foley/smackspecial.ogg')
	playsound(target, sound, 50, TRUE, -2, ignore_walls = FALSE)

	var/msg = "[user] [user.sexcon.get_generic_force_adjective()]拍打着[target]的屁股。"
	user.visible_message(user.sexcon.spanify_force(msg))

	// Arousal and pain logic
	var/arousal_amt = 1.2 + (force * 0.5)
	var/pain_amt = 2 * force
	user.sexcon.perform_sex_action(target, arousal_amt, pain_amt, TRUE)
	target.sexcon.handle_passive_ejaculation()

	// Soreness messaging depending on force
	if(force >= SEX_FORCE_HIGH)
		to_chat(target, span_warning("我的屁股开始被打得发疼了！"))
	else if(force == SEX_FORCE_MID)
		if(prob(30))
			to_chat(target, span_notice("我的臀后传来一阵愉悦的刺痛。"))
	else if(force == SEX_FORCE_LOW)
		if(prob(10))
			to_chat(target, span_notice("一阵温柔的热意在我的臀部蔓延开来。"))

/datum/sex_action/spanking/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]停下了拍打[target]的动作。"))

/datum/sex_action/spanking/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE 
