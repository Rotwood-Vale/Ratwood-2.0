/datum/surgery/debride_charring
	name = "Charring Debridement"
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)

	possible_locs = list(
		BODY_ZONE_HEAD,
		BODY_ZONE_CHEST,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
		BODY_ZONE_PRECISE_R_HAND,
		BODY_ZONE_PRECISE_L_HAND,
		BODY_ZONE_PRECISE_R_FOOT,
		BODY_ZONE_PRECISE_L_FOOT,
	)

	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/debride_charring,
		/datum/surgery_step/cauterize,
	)

/datum/surgery_step/debride_charring
	name = "Debride charred tissue"
	time = 8 SECONDS
	accept_hand = FALSE

	implements = list(
		TOOL_SCALPEL = 80,
		TOOL_SHARP = 60,
	)

	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)

	surgery_flags = SURGERY_INCISED | SURGERY_RETRACTED

	skill_min = SKILL_LEVEL_JOURNEYMAN
	skill_median = SKILL_LEVEL_EXPERT

/datum/surgery_step/debride_charring/validate_bodypart(mob/user, mob/living/carbon/target, obj/item/bodypart/bodypart, target_zone)
	. = ..()
	if(!.)
		return

	var/has_charring = FALSE

	for(var/datum/wound/charring/C in bodypart.wounds)
		has_charring = TRUE

	if(!has_charring)
		to_chat(user, span_warning("There is no charred flesh to remove on [target]'s [parse_zone(target_zone)]."))

	return has_charring

/datum/surgery_step/debride_charring/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target,
		span_notice("I begin removing dead burnt tissue from [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins removing burnt tissue from [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins removing burnt tissue from [target]'s [parse_zone(target_zone)].")
	)
	return TRUE

/datum/surgery_step/debride_charring/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target,
		span_notice("I successfully remove the burnt tissue from [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] removes burnt tissue from [target]'s [parse_zone(target_zone)]!"),
		span_notice("[user] removes burnt tissue from [target]'s [parse_zone(target_zone)]!")
	)

	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	target.apply_damage(5, BRUTE, target_zone)

	// Remove charring from treated limb
	if(bodypart)
		for(var/datum/wound/charring/C in bodypart.wounds)
			qdel(C)

	return TRUE
