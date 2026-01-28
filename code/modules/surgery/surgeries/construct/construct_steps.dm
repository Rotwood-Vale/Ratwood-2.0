/// CONSTRUCT VERSIONS OF SURGERIES

/// Incision
/datum/surgery_step/incise/construct
    name = "Uncover"
    surgery_flags = SURGERY_CONSTRUCT
    surgery_flags_blocked = SURGERY_INCISED
    skill_used = /datum/skill/craft/engineering

/datum/surgery_step/incise/construct/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("I begin to make an opening in [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to make an opening in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to make an opening in [target]'s [parse_zone(target_zone)]."))
	return TRUE

/datum/surgery_step/incise/construct/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("[target]'s [parse_zone(target_zone)] opens up, exposing another layer."),
		span_notice("[target]'s [parse_zone(target_zone)] opens up, exposing an inner-layer."))
	var/obj/item/bodypart/gotten_part = target.get_bodypart(check_zone(target_zone))
	if(gotten_part)
		gotten_part.add_wound(/datum/wound/slash/incision/construct)
	return TRUE

/// Clamping
/datum/surgery_step/clamp/construct
    name = "Secure cogs"
    surgery_flags = SURGERY_CONSTRUCT
    surgery_flags_blocked = SURGERY_CLAMPED
    skill_used = /datum/skill/craft/engineering
    surgery_flags_blocked = null

/datum/surgery_step/clamp/construct/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("I begin to secure cogs in [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to secure cogs in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to secure cogs in [target]'s [parse_zone(target_zone)]."))
	return TRUE

/datum/surgery_step/clamp/construct/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("I secure the cogs in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] secure the cogs in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] secure the cogs in [target]'s [parse_zone(target_zone)]."))
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	bodypart?.add_embedded_object(tool, crit_message = FALSE)
	return TRUE

/// Retracting
/datum/surgery_step/retract/construct
    name = "Open inner-hatch"
    surgery_flags = SURGERY_CONSTRUCT
    surgery_flags_blocked = SURGERY_RETRACTED
    skill_used = /datum/skill/craft/engineering

/datum/surgery_step/retract/construct/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	return ..()

/datum/surgery_step/retract/construct/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	return ..()

/// Cauterizing -- Nothing, cautery doesn't affect them.

/// Saw bone
/datum/surgery_step/saw/construct
    name = "Saw support structure"
    surgery_flags = SURGERY_INCISED | SURGERY_RETRACTED | SURGERY_CONSTRUCT
    surgery_flags_blocked = SURGERY_BROKEN
    skill_used = /datum/skill/craft/engineering

/datum/surgery_step/saw/construct/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("I begin to saw through the support structure in [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to saw through the support structure in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to saw through the support structure in [target]'s [parse_zone(target_zone)]."))
	return TRUE

/datum/surgery_step/saw/construct/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("I saw [target]'s [parse_zone(target_zone)] open."),
		span_notice("[user] saws [target]'s [parse_zone(target_zone)] open!"),
		span_notice("[user] saws [target]'s [parse_zone(target_zone)] open!"))
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	if(bodypart)
		var/fracture_type = /datum/wound/fracture
		//yes we ignore crit resist here because this is a proper surgical procedure, not a crit
		switch(bodypart.body_zone)
			if(BODY_ZONE_HEAD)
				fracture_type = /datum/wound/fracture/head
			if(BODY_ZONE_PRECISE_NECK)
				fracture_type = /datum/wound/fracture/neck
			if(BODY_ZONE_CHEST)
				fracture_type = /datum/wound/fracture/chest
			if(BODY_ZONE_PRECISE_GROIN)
				fracture_type = /datum/wound/fracture/groin
		bodypart.add_wound(fracture_type)
	return TRUE

/// Drill bone
/datum/surgery_step/drill/construct
    name = "Drill inner-structure"
    surgery_flags = SURGERY_INCISED | SURGERY_RETRACTED | SURGERY_CONSTRUCT
    surgery_flags_blocked = SURGERY_BROKEN
    skill_used = /datum/skill/craft/engineering

/datum/surgery_step/drill/construct/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	return ..()

/datum/surgery_step/drill/construct/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("I drill into [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] drills into [target]'s [parse_zone(target_zone)]!"),
		span_notice("[user] drills into [target]'s [parse_zone(target_zone)]!"))
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	bodypart?.add_wound(/datum/wound/puncture/drilling)
	return TRUE

/// Extract lux (Kills dah construct btw)

/datum/surgery_step/extract_lux/construct
	surgery_flags_blocked = null
	surgery_flags = SURGERY_INCISED | SURGERY_CLAMPED | SURGERY_RETRACTED | SURGERY_BROKEN | SURGERY_CONSTRUCT
	skill_used = /datum/skill/craft/engineering

/datum/surgery_step/extract_lux/construct/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("I begin to extract the lux from [target]'s core... This seems like a bad idea."),
		span_notice("[user] begins to extract the lux from [target]'s core."),
		span_notice("[user] begins to extract the lux from [target]'s core."))
	return TRUE

/datum/surgery_step/extract_lux/construct/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("You extract a singular source of lux from [target]'s core, killing them."),
		"[user] extracts lux from [target]'s innards, killing them.",
		"[user] extracts lux from [target]'s innards, killing them.")
	new /obj/item/reagent_containers/lux(target.loc)
	SEND_SIGNAL(user, COMSIG_LUX_EXTRACTED, target)
	record_round_statistic(STATS_LUX_HARVESTED)
	target.death()
	target.emote(message = "siezes up, the soft hum of their core dying out as they go still as a statue.", forced = TRUE)
	return TRUE

/// Reshape face.
/datum/surgery_step/reshape_face/construct // Just doing this so they can have their own surgery. Doesn't change anything.
	surgery_flags = SURGERY_CONSTRUCT | SURGERY_INCISED | SURGERY_CLAMPED | SURGERY_RETRACTED
	surgery_flags_blocked = null
	skill_used = /datum/skill/craft/engineering

/// Set Bones
/datum/surgery_step/set_bone/construct
	skill_used = /datum/skill/craft/engineering
	surgery_flags = SURGERY_INCISED | SURGERY_RETRACTED | SURGERY_BROKEN | SURGERY_CONSTRUCT
	surgery_flags_blocked = null

/// Manipulate Organs
/datum/surgery_step/manipulate_organs/construct
	name = "Manipulate internal components"
	skill_used = /datum/skill/craft/engineering
	surgery_flags = SURGERY_INCISED | SURGERY_RETRACTED | SURGERY_CONSTRUCT
	surgery_flags_blocked = null

/// Mold organs
/datum/surgery_step/make_organs/construct
	name = "Mold auxiliary components"
	skill_used = /datum/skill/craft/engineering
	surgery_flags = SURGERY_INCISED | SURGERY_RETRACTED | SURGERY_CONSTRUCT
	surgery_flags_blocked = null

/datum/surgery_step/amputate/construct
	skill_used = /datum/skill/craft/engineering
	surgery_flags = SURGERY_INCISED | SURGERY_BROKEN | SURGERY_CONSTRUCT
	surgery_flags_blocked = null

/datum/surgery_step/relocate_bone/construct
	name = "Resecure internal support structure"
	skill_used = /datum/skill/craft/engineering
	surgery_flags = SURGERY_DISLOCATED | SURGERY_CONSTRUCT
	surgery_flags_blocked = null

/datum/surgery_step/remove_external_organs/construct
	surgery_flags = SURGERY_INCISED | SURGERY_CONSTRUCT
	skill_used = /datum/skill/craft/engineering
	surgery_flags_blocked = null

/datum/surgery_step/add_prosthetic/construct
	surgery_flags = SURGERY_CONSTRUCT
	skill_used = /datum/skill/craft/engineering
	surgery_flags_blocked = null

/datum/surgery_step/remove_prosthetic/construct
	surgery_flags = SURGERY_CONSTRUCT
	skill_used = /datum/skill/craft/engineering
	surgery_flags_blocked = null

/datum/surgery_step/infuse_lux/construct
	surgery_flags = SURGERY_INCISED | SURGERY_CLAMPED | SURGERY_RETRACTED | SURGERY_BROKEN | SURGERY_CONSTRUCT
	skill_used = /datum/skill/craft/engineering
	surgery_flags_blocked = null