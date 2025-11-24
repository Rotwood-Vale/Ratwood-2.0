/datum/patron/inhumen/baotha
	name = "Baotha"
	domain = "Hedonism, Debauchery, Addiction, Heartbreak"
	desc = "The Lady of Debauchery was the only snow elf to have survived Zizo's massacre, having been kept by the Naledi as a concubine. Until one dae, She was consumed by Her depravity and addiction, stealing a shard of SYON from Her captors and ascending to godhood. Her followers desire only to experience mind-rotting pleasures."
	worshippers = "Widows, Gamblers, Addicts, Scorned Lovers, Far-Gone Prostitutes"
	mob_traits = list(TRAIT_DEPRAVED, TRAIT_CRACKHEAD)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison					= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/baothavice					= CLERIC_T0,
					/obj/effect/proc_holder/spell/targeted/touch/loversruin				= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/baothablessings				= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/griefflower					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/projectile/blowingdust		= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/joyride						= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/lasthigh						= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/painkiller					= CLERIC_T3,
	)
	confess_lines = list(
		"BAOTHA DEMANDS PLEASURE!",
		"LIVE, LAUGH, LOVE!",
		"BAOTHA IS MY JOY!",
	)
	storyteller = /datum/storyteller/baotha

/datum/patron/inhumen/baotha/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer in the Zzzzzzzurch(!)
	if(istype(get_area(follower), /area/rogue/indoors/shelter/mountains))
		return TRUE
	// Allows prayer near EEEVIL psycross
	for(var/obj/structure/fluff/psycross/zizocross/cross in view(4, get_turf(follower)))
		if(cross.divine == TRUE)
			to_chat(follower, span_danger("That acursed cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayers in the bath house - whore.
	if(istype(get_area(follower), /area/rogue/indoors/town/bath))
		return TRUE
	// Allows prayers if actively high on drugs.
	if(follower.has_status_effect(/datum/status_effect/buff/ozium) || follower.has_status_effect(/datum/status_effect/buff/moondust) || follower.has_status_effect(/datum/status_effect/buff/moondust_purest) || follower.has_status_effect(/datum/status_effect/buff/druqks) || follower.has_status_effect(/datum/status_effect/buff/starsugar))
		return TRUE
	// Allows prayers if the user is drunk.
	if(follower.has_status_effect(/datum/status_effect/buff/drunk))
		return TRUE
	// Allows praying atop ritual chalk of the god.
	for(var/obj/structure/ritualcircle/baotha in view(1, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("For Baotha to hear my prayers I must either be in the church of the abandoned, near an inverted psycross, within the town's bathhouse, or actively partaking in one of various types of nose-candy!"))
	return FALSE

#define BAOTHA_SUFFERING_DIVIDER 3.535 // max bonus at 50 pain/bleedrate and pain_mod = 1

/datum/patron/inhumen/baotha/on_lesser_heal(
    mob/living/user,
    mob/living/target,
    message_out,
    message_self,
    conditional_buff,
    situational_bonus,
	is_inhumen
)
	*is_inhumen = TRUE
	*message_out = span_info("Hedonistic impulses and emotions throb all about from [target].")
	*message_self = span_notice("An intoxicating rush of narcotic delight soothes my suffering!")

	if(!ishuman(target))
		*message_self = span_notice("An intoxicating rush of narcotic delight flows through me!")
		return

	var/mob/living/carbon/human/human_target = target
	var/bonus = 0

	if(human_target.has_status_effect(/datum/status_effect/buff/druqks) \
	|| human_target.has_status_effect(/datum/status_effect/buff/drunk))
		bonus += 0.5

	if(human_target.get_stress_event(/datum/stressevent/lasthigh))
		bonus += 0.5

	if(!HAS_TRAIT(target, TRAIT_NOPAIN) || HAS_TRAIT(target, TRAIT_CRACKHEAD))
		var/raw_suffering = 0

		for(var/datum/wound/wound in human_target.get_wounds())
			raw_suffering += wound.woundpain + wound.bleed_rate

		var/suffering = sqrt(raw_suffering) / BAOTHA_SUFFERING_DIVIDER
		var/to_add = HAS_TRAIT(target, TRAIT_DEPRAVED) ? suffering : suffering * human_target.physiology.pain_mod
		bonus += min(to_add, 2)

	*conditional_buff = TRUE
	*situational_bonus = bonus

#undef BAOTHA_SUFFERING_DIVIDER
