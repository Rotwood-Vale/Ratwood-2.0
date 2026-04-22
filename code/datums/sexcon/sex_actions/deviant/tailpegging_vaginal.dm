/datum/sex_action/tailpegging_vaginal
	name = "Tail fuck their cunt"
	stamina_cost = 1.0
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_CUNT

/datum/sex_action/tailpegging_vaginal/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_TAIL))
		return FALSE
	return TRUE

/datum/sex_action/tailpegging_vaginal/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_TAIL))
		return FALSE
	return TRUE

/datum/sex_action/tailpegging_vaginal/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_TINY) && !HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] forces [user.p_their()] tail into [target]'s tiny cunt!"))
		var/obj/item/bodypart/chest = target.get_bodypart(BODY_ZONE_CHEST)
		var/obj/item/bodypart/groin = target.get_bodypart(BODY_ZONE_PRECISE_GROIN)
		chest?.add_wound(/datum/wound/fracture/chest)
		groin?.add_wound(/datum/wound/fracture/groin)
		if(chest)
			target.apply_damage(30, BRUTE, chest)
	else if(!HAS_TRAIT(target, TRAIT_TINY) && HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] tries and fails to insert [user.p_their()] tiny tail into [target]'s cunt."))
	else
		user.visible_message(span_warning("[user] slides [user.p_their()] tail into [target]'s cunt!"))
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), 20, TRUE, ignore_walls = FALSE)

/datum/sex_action/tailpegging_vaginal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!HAS_TRAIT(target, TRAIT_TINY) && HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] tries to fuck [target]'s cunt with [user.p_their()] tail, unsuccessfully."))
		user.sexcon.outercourse_noise(target)
		user.sexcon.do_thrust_animate(target)
		return FALSE
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] fucks [target]'s cunt with their tail."))
	if(HAS_TRAIT(target, TRAIT_TINY) && HAS_TRAIT(user, TRAIT_TINY))
		return FALSE
	user.sexcon.outercourse_noise(target)
	user.sexcon.do_thrust_animate(target)
	if(HAS_TRAIT(target, TRAIT_TINY) && !HAS_TRAIT(user, TRAIT_TINY))
		target.apply_damage(10, BRUTE, target.get_bodypart(BODY_ZONE_CHEST))
		target.apply_damage(3, BRUTE, target.get_bodypart(BODY_ZONE_PRECISE_GROIN))

	user.sexcon.perform_sex_action(target, 2.4, 7, TRUE)
	user.sexcon.handle_passive_ejaculation()

/datum/sex_action/tailpegging_vaginal/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!HAS_TRAIT(target, TRAIT_TINY) && HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] stops trying to insert [user.p_their()] tiny tail into [target]'s cunt."))
	else
		user.visible_message(span_warning("[user] pulls [user.p_their()] tail out of [target]'s cunt."))

/datum/sex_action/tailpegging_vaginal/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
