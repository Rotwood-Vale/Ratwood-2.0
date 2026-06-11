/datum/sex_action/tailpegging_anal
	name = "用尾巴抽插对方后穴"
	stamina_cost = 1.0
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_ANUS

/datum/sex_action/tailpegging_anal/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_TAIL) && !islamia(user))
		return FALSE
	return TRUE

/datum/sex_action/tailpegging_anal/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_TAIL) && !islamia(user))
		return FALSE
	return TRUE

/datum/sex_action/tailpegging_anal/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]将[user.p_their()]的尾巴滑入了[target]的后穴！"))
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), 20, TRUE, ignore_walls = FALSE)

/datum/sex_action/tailpegging_anal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]用[user.p_their()]的尾巴抽插着[target]的后穴。"))
	user.sexcon.outercourse_noise(target)
	user.sexcon.do_thrust_animate(target)

	user.sexcon.perform_sex_action(target, 2.4, 7, TRUE)
	user.sexcon.handle_passive_ejaculation()

/datum/sex_action/tailpegging_anal/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]的尾巴从[target]的后穴中抽了出来。"))

/datum/sex_action/tailpegging_anal/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
