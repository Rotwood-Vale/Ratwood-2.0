/obj/effect/proc_holder/spell/invoked/rituos
	name = "Rituos"
	desc = "Do a ritual for she of Z that skeletonises a part of your body and bestows upon you arcyne magycks until you next sleep. Once your whole body has become skeletonised you gain full access to the Arcyne, bolstering your knowledge of spells with each additional ritual."
	clothes_req = FALSE
	overlay_state = "rituos"
	associated_skill = /datum/skill/magic/arcane
	chargedloop = /datum/looping_sound/invokeholy
	chargedrain = 0
	chargetime = 50
	releasedrain = 90
	no_early_release = TRUE
	movement_interrupt = TRUE
	recharge_time = 2 MINUTES
	hide_charge_effect = TRUE
	/// List of limbs that don't get skeletonized. Chest has special handling once you are at that point
	var/static/list/excluded_bodyparts = list(/obj/item/bodypart/head, /obj/item/bodypart/chest)
	/// How many times Rituos has been casted
	var/rituos_counter = 0

/obj/effect/proc_holder/spell/invoked/rituos/miracle
	miracle = TRUE
	devotion_cost = 120
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/rituos/cast(list/targets, mob/living/carbon/user)
	. = ..()
	if(!user || !user.mind)
		return FALSE

	if(user.mind.has_rituos)
		to_chat(user, span_warning("I have not the mental fortitude to enact the Lesser Work again. I must rest first..."))
		return FALSE

	// Find a bodypart to skeletonize
	var/list/potential_bodypart = list()
	for(var/obj/item/bodypart/limb as anything in user.bodyparts)
		if(limb.type in excluded_bodyparts)
			continue
		if(limb.skeletonized)
			continue
		potential_bodypart += limb

	if(!length(potential_bodypart) && rituos_counter < 4)
		to_chat(user, span_warning("I have no remaining limbs to offer to the ritual!"))
		return FALSE

	var/obj/item/bodypart/part_to_bonify
	if(rituos_counter == 4)
		part_to_bonify = locate(/obj/item/bodypart/chest) in user.bodyparts
	else
		part_to_bonify = pick(potential_bodypart)

	if(!part_to_bonify)
		to_chat(user, span_warning("I have no remaining limbs to offer to the ritual!"))
		return FALSE

	if(!(user.mob_biotypes & MOB_UNDEAD))
		user.visible_message(span_warning("The pallor of the grave descends across [user]'s skin in a wave of arcyne energy..."), span_boldwarning("A deathly chill overtakes my body at my first culmination of the Lesser Work! I feel my heart slow down in my chest..."))
		user.mob_biotypes |= MOB_UNDEAD
		to_chat(user, span_smallred("I have forsaken the living. I am now closer to a deadite than a mortal... but I still yet draw breath and bleed."))

	part_to_bonify.skeletonize(FALSE)
	user.update_body_parts()
	user.visible_message(span_warning("Faint runes flare beneath [user]'s skin before [user.p_their()] flesh suddenly slides away from [user.p_their()] [part_to_bonify.name]!"), span_notice("I feel arcyne power surge throughout my frail mortal form, as the Rituos takes its terrible price from my [part_to_bonify.name]."))

	user.mind.has_rituos = TRUE
	rituos_counter++
	switch(rituos_counter)
		if(1)
			user.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
			ADD_TRAIT(user, TRAIT_ARCYNE_T3, "[type]")
			user.mind?.adjust_spellpoints(3)
		if(2,4)
			user.mind?.adjust_spellpoints(3)
		if(3)
			user.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
			user.mind?.adjust_spellpoints(3)
		if(5)
			user.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
			user.grant_language(/datum/language/undead)
			user.mind?.adjust_spellpoints(6)
			user.visible_message(span_boldwarning("[user]'s form swells with terrible power as they cast away almost all of the remnants of their mortal flesh, arcyne runes glowing upon their exposed bones..."), span_notice("I HAVE DONE IT! I HAVE COMPLETED HER LESSER WORK! I stand at the cusp of unspeakable power, but something is yet missing..."))
			ADD_TRAIT(user, TRAIT_NOHUNGER, "[type]")
			ADD_TRAIT(user, TRAIT_NOBREATH, "[type]")
			ADD_TRAIT(user, TRAIT_OVERTHERETIC, "[type]")
			if(prob(33))
				to_chat(user, span_small("...what have I done?"))
			user.mind?.RemoveSpell(src)