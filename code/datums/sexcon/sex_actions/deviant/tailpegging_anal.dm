/datum/sex_action/tailpegging_anal
	name = "Tail fuck their ass"
	stamina_cost = 1.0
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_ANUS
	user_sex_part = SEX_PART_TAIL

/datum/sex_action/tailpegging_anal/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_TINY) && !HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] forces their tail into [target]'s tiny butt!"))
		var/obj/item/bodypart/chest = target.get_bodypart(BODY_ZONE_CHEST)
		var/obj/item/bodypart/groin = target.get_bodypart(BODY_ZONE_PRECISE_GROIN)
		if(chest)
			chest.add_wound(/datum/wound/fracture/chest)
		if(groin)
			groin.add_wound(/datum/wound/fracture/groin)
		target.apply_damage(30, BRUTE, chest)
	else if(!HAS_TRAIT(target, TRAIT_TINY) && HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] tries and fails to insert their tiny tail into [target]'s butt!"))
	else
		user.visible_message(span_warning("[user] slides their tail into [target]'s ass!"))
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), 20, TRUE, ignore_walls = FALSE)

/datum/sex_action/tailpegging_anal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!HAS_TRAIT(target, TRAIT_TINY) && HAS_TRAIT(user, TRAIT_TINY))
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] tries to fuck [target]'s ass with their tail, unsuccessfully."))
		user.sexcon.do_thrust_animate(target)
		playsound(target, 'sound/misc/mat/segso.ogg', 50, TRUE, -2, ignore_walls = FALSE)
		return FALSE

	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] fucks [target]'s ass with their tail."))
	if(HAS_TRAIT(target, TRAIT_TINY) && HAS_TRAIT(user, TRAIT_TINY))
		return FALSE

	target.lose_anal_virginity(user)
	user.sexcon.outercourse_noise(target)
	user.sexcon.do_thrust_animate(target)

	if(HAS_TRAIT(target, TRAIT_TINY) && !HAS_TRAIT(user, TRAIT_TINY))
		target.apply_damage(10, BRUTE, target.get_bodypart(BODY_ZONE_CHEST))
		target.apply_damage(3, BRUTE, target.get_bodypart(BODY_ZONE_PRECISE_GROIN))

	user.sexcon.perform_sex_action(target, 2.4, 7, TRUE)
	user.sexcon.handle_passive_ejaculation()

/datum/sex_action/tailpegging_anal/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] pulls their tail out of [target]'s ass."))

/datum/sex_action/tailpegging_anal/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
