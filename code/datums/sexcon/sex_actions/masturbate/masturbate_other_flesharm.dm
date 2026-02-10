/datum/sex_action/masturbate_other_flesharm
	name = "Use flesharm on cock"
	category = SEX_CATEGORY_HANDS
	target_sex_part = SEX_PART_COCK

	var/static/flesharm_type = /obj/item/rogueweapon/fleshcrafter_flesharm

/datum/sex_action/masturbate_other_flesharm/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!get_flesharm(user))
		return FALSE
	return TRUE

/datum/sex_action/masturbate_other_flesharm/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!target.sexcon.can_use_penis())
		return FALSE
	if(!get_flesharm(user))
		return FALSE
	return TRUE

/datum/sex_action/masturbate_other_flesharm/proc/get_flesharm(mob/living/carbon/human/user)
	for(var/obj/item/I in user.contents)
		if(istype(I, flesharm_type) && I.loc == user)
			return I
	return null

/datum/sex_action/masturbate_other_flesharm/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/W = get_flesharm(user)
	if(W)
		user.visible_message(span_warning("[user] presses \the [W] against [target]'s cock..."))

/datum/sex_action/masturbate_other_flesharm/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/W = get_flesharm(user)
	if(!W)
		return

	var/chosen_verb = pick(list(
		"moves \the [W] along [target]'s cock",
		"rubs \the [W] over [target]'s shaft",
		"uses \the [W] on [target]"
	))

	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] [chosen_verb]..."))
	playsound(user, 'sound/misc/mat/fingering.ogg', 30, TRUE, -2)

	target.sexcon.perform_sex_action(user, 3, 0, TRUE)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/masturbate_other_flesharm/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] lowers the fleshy weapon."))

/datum/sex_action/masturbate_other_flesharm/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return target.sexcon.finished_check()