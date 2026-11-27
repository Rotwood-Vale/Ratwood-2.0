/datum/sex_action/perverse
	abstract_type = /datum/sex_action/perverse
	var/requires_extreme = TRUE

/datum/sex_action/perverse/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!..())
		return FALSE
	if(requires_extreme && !both_extreme_erp(user, target))
		return FALSE
	if(target_needs_chastity && (!user.sexcon.chastity_content_enabled_for(user) || !target.sexcon.chastity_content_enabled_for(target)))
		return FALSE
	return TRUE

/datum/sex_action/perverse/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return ..() && shows_on_menu(user, target)

/datum/sex_action/perverse/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon.do_thrust_animate(target)

/datum/sex_action/perverse/proc/try_perverse_bedbreaker_wound(mob/living/carbon/human/user, mob/living/carbon/human/target, wound_zone, datum/wound/wound_type)
	if(!user?.sexcon || !target || (!HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) && user.STASTR <= 12))
		return FALSE
	if(!istype(user.rmb_intent, /datum/rmb_intent/strong) || user.sexcon.force <= SEX_FORCE_MID)
		return FALSE
	if(!both_extreme_erp(user, target) || target.has_wound(wound_type, TRUE) || !prob(10))
		return FALSE
	var/obj/item/bodypart/affected_part = target.get_bodypart(wound_zone)
	return !!affected_part?.add_wound(wound_type)
