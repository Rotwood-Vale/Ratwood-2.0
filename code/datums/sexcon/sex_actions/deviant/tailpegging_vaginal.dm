/datum/sex_action/tailpegging_vaginal
	name = "Tail fuck their cunt"
	stamina_cost = 1.0
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_CUNT
	user_sex_part = SEX_PART_TAIL

/datum/sex_action/tailpegging_vaginal/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_TINY) && !HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] forces their tail into [target]'s tiny cunt!"))
		var/obj/item/bodypart/chest = target.get_bodypart(BODY_ZONE_CHEST)
		var/obj/item/bodypart/groin = target.get_bodypart(BODY_ZONE_PRECISE_GROIN)
		if(chest)
			chest.add_wound(/datum/wound/fracture/chest)
		if(groin)
			groin.add_wound(/datum/wound/fracture/groin)
		target.apply_damage(30, BRUTE, chest)
	else if(!HAS_TRAIT(target, TRAIT_TINY) && HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] tries and fails to insert their tiny tail into [target]'s cunt!"))
	else
		user.visible_message(span_warning("[user] slides their tail into [target]'s cunt!"))
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), 20, TRUE, ignore_walls = FALSE)

/datum/sex_action/tailpegging_vaginal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!HAS_TRAIT(target, TRAIT_TINY) && HAS_TRAIT(user, TRAIT_TINY))
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] tries to fuck [target]'s cunt with their tail, unsuccessfully."))
		user.sexcon.do_thrust_animate(target)
		playsound(target, 'sound/misc/mat/segso.ogg', 50, TRUE, -2, ignore_walls = FALSE)
		return FALSE

	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] fucks [target]'s cunt with their tail."))
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
	user.visible_message(span_warning("[user] pulls their tail out of [target]'s cunt."))

/datum/sex_action/tailpegging_vaginal/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
