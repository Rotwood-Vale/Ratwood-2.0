/datum/patron/dragon
	parent_type = /datum/patron/inhumen
	name = "The Dragon"
	domain = "Dominion, Strength, Guardianship"
	desc = "An ancient, feared power worshipped by the island tribes. The Dragon's faithful honor draconic might, discipline, and supremacy over their own kin and hearths."
	worshippers = "Island Tribals"
	virtues = "Strength, Dominance, Discipline"
	sins = "Cowardice, Treachery, Wastefulness"
	mob_traits = list(TRAIT_LONGSTRIDER, TRAIT_RESISTHEATHANDS)
	// Tribals are not miracle casters; keep these as fallback hooks for compatibility and future content.
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison					= CLERIC_ORI,
					/obj/effect/proc_holder/spell/self/graggar_bloodrage				= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal					= CLERIC_T1,
					/obj/effect/proc_holder/spell/self/call_to_slaughter 				= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/projectile/blood_net 			= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/revel_in_slaughter 			= CLERIC_T3,
	)
	confess_lines = list(
		"THE DRAGON RULES!",
		"STRENGTH IS LAW!",
		"BY SCALE AND FIRE, WE ENDURE!",
	)
	associated_faith = /datum/faith/dragon
	preference_accessible = FALSE
	disabled_patron = TRUE

// Near tribal strongholds, dragon-fire, bad-cross, or ritual chalk
/datum/patron/dragon/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer in the tribal den.
	if(istype(get_area(follower), /area/rogue/under/cave/tribeden))
		return TRUE
	// Allows prayer near EEEVIL psycross
	for(var/obj/structure/fluff/psycross/zizocross/cross in view(4, get_turf(follower)))
		if(cross.divine == TRUE)
			to_chat(follower, span_danger("That acursed cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer near dragon-fire.
	for(var/obj/machinery/light/rogue/fire in view(4, get_turf(follower)))
		if(istype(fire, /obj/machinery/light/rogue/campfire) || istype(fire, /obj/machinery/light/rogue/hearth) || istype(fire, /obj/machinery/light/rogue/forge) || istype(fire, /obj/machinery/light/rogue/candle))
			return TRUE
	// Allows prayer atop ritual chalk tied to tribal inhuman rites (compatibility fallback).
	for(var/obj/structure/ritualcircle/graggar in view(1, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("For The Dragon to hear my prayers I must stand in tribal holy ground, near an inverted psycross, near dragon-fire, or atop a tribal rite circle!"))
	return FALSE

/datum/patron/dragon/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus,
	is_inhumen
)
	*is_inhumen = TRUE
	*message_out = span_info("A steady draconic warmth settles over [target].")
	*message_self = span_notice("A fierce inner heat steadies my body and resolve.")

	var/list/firey_stuff = list(/obj/machinery/light/rogue/torchholder, /obj/machinery/light/rogue/campfire, /obj/machinery/light/rogue/hearth, /obj/machinery/light/rogue/campfire/fireplace, /obj/machinery/light/rogue/candle, /obj/machinery/light/rogue/forge)
	var/bonus = 0

	for(var/obj/obj in oview(5, user))
		if(!(obj.type in firey_stuff))
			continue

		bonus = min(bonus + 0.5, 2.5)

	if(!bonus)
		return

	*situational_bonus = bonus
	*conditional_buff = TRUE
