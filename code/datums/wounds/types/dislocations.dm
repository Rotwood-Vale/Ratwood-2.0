/datum/wound/dislocation
	name = "脱臼"
	check_name = span_bone("脱臼")
	severity = WOUND_SEVERITY_MODERATE
	crit_message = list(
		"%BODYPART猛地一震，疼痛难忍！",
		"%BODYPART被扭得错位了！",
		"%BODYPART被猛地拽出了关节窝！",
		"%BODYPART脱臼了！",
	)
	sound_effect = "fracturedry"
	whp = 40
	woundpain = 40
	mob_overlay = ""
	sewn_overlay = ""
	can_sew = FALSE
	can_cauterize = FALSE
	disabling = FALSE
	critical = TRUE
	passive_healing = 0.25
	qdel_on_droplimb = TRUE

	werewolf_infection_probability = 0
	/// Whether or not we can be surgically relocated
	var/can_relocate = TRUE

/datum/wound/dislocation/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/dislocation) && (type == other.type))
		return FALSE
	return TRUE

/datum/wound/dislocation/on_bodypart_gain(obj/item/bodypart/affected)
	. = ..()
	//disable temporarily
	affected.temporary_crit_paralysis(20 SECONDS)
	ADD_TRAIT(affected, TRAIT_FINGERLESS, "[type]")
	ADD_TRAIT(affected, TRAIT_BRITTLE, "[type]")
	switch(affected.body_zone)
		if(BODY_ZONE_R_LEG)
			affected.owner.add_movespeed_modifier(MOVESPEED_ID_DISLOCATION_RIGHT_LEG, multiplicative_slowdown = DISLOCATED_ADD_SLOWDOWN)
		if(BODY_ZONE_L_LEG)
			affected.owner.add_movespeed_modifier(MOVESPEED_ID_DISLOCATION_LEFT_LEG, multiplicative_slowdown = DISLOCATED_ADD_SLOWDOWN)

/datum/wound/dislocation/on_bodypart_loss(obj/item/bodypart/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_FINGERLESS, "[type]")
	REMOVE_TRAIT(affected, TRAIT_BRITTLE, "[type]")
	if(!affected.owner)
		return
	switch(affected.body_zone)
		if(BODY_ZONE_R_LEG)
			affected.owner.remove_movespeed_modifier(MOVESPEED_ID_DISLOCATION_RIGHT_LEG)
		if(BODY_ZONE_L_LEG)
			affected.owner.remove_movespeed_modifier(MOVESPEED_ID_DISLOCATION_LEFT_LEG)

/datum/wound/dislocation/on_mob_gain(mob/living/affected)
	. = ..()
	affected.emote("paincrit", TRUE)
	affected.Slowdown(20)
	shake_camera(affected, 2, 2)

/datum/wound/dislocation/proc/relocate_bone()
	if(!can_relocate)
		return FALSE
	qdel(src)
	return TRUE

/datum/wound/dislocation/neck
	name = "颈椎脱位"
	check_name = span_bone("颈部")
	crit_message = list(
		"脊椎错位了！",
		"脊椎扭曲了！",
		"%BODYPART被猛地拽出了关节窝！",
	)
	whp = 80
	woundpain = 100

/datum/wound/dislocation/neck/on_mob_gain(mob/living/affected)
	. = ..()
	ADD_TRAIT(affected, TRAIT_PARALYSIS, "[type]")
	if(iscarbon(affected))
		var/mob/living/carbon/carbon_affected = affected
		carbon_affected.update_disabled_bodyparts()

/datum/wound/dislocation/neck/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_PARALYSIS, "[type]")
	if(iscarbon(affected))
		var/mob/living/carbon/carbon_affected = affected
		carbon_affected.update_disabled_bodyparts()
