/datum/clan_leader
	var/list/lord_spells = list(
	)
	var/list/lord_verbs = list(
	)
	var/list/lord_traits = list()
	var/lord_title = "Lord"
	var/vitae_bonus = 5 // Extra vitae for lords
	var/ascended = FALSE

/datum/clan_leader/lord
	lord_spells = list(
		/obj/effect/proc_holder/spell/targeted/shapeshift/vampire/bat,
		/obj/effect/proc_holder/spell/targeted/shapeshift/gaseousform,
	)
	lord_verbs = list(
		/mob/living/carbon/human/proc/punish_spawn
	)
	lord_traits = list(TRAIT_HEAVYARMOR, TRAIT_INFINITE_ENERGY)
	lord_title = "Lord"
	vitae_bonus = 500 // Extra vitae for lords
	ascended = FALSE

/datum/clan_leader/wretch
	lord_spells = list(
		/obj/effect/proc_holder/spell/targeted/shapeshift/vampire/bat,
	)
	lord_verbs = list(
		/mob/living/carbon/human/proc/punish_spawn
	)
	lord_title = "Lord"
	ascended = FALSE

/datum/clan_leader/proc/make_new_leader(mob/living/carbon/human/H)
	// Grant a levitation discipline to leaders. Create a small coven instance
	// containing only the levitation power so we use the coven system properly.
	var/datum/coven/newc = new /datum/coven(1)
	newc.name = "Leader Levitation"
	// Explicitly set available powers to only the levitation power
	newc.all_powers = list(/datum/coven_power/levitation)
	// Initialize known_powers for level 1
	newc.initialize_powers_for_level(1)
	H.give_coven(newc)

	ADD_TRAIT(H, TRAIT_CLAN_LEADER, "clan")

	// Add lord spells
	for(var/spell_type in lord_spells)
		H.mind?.AddSpell(new spell_type(H.mind))

	// Add lord verbs
	for(var/verb_path in lord_verbs)
		H.verbs |= verb_path

	// Add lord traits
	for(var/trait in lord_traits)
		ADD_TRAIT(H, trait, "lord_component")

	// Update vampire datum if they have one
	var/datum/antagonist/vampire/vamp_datum = H.mind?.has_antag_datum(/datum/antagonist/vampire)
	H.maxbloodpool += vitae_bonus
	if(vamp_datum)
		vamp_datum.name = "[lord_title]"
		vamp_datum.antag_hud_name = "Vlord"

	// Give patron-specific coven based on deity
	if(istype(H.patron, /datum/patron/divine))
		if(!H.get_coven(/datum/coven/divine_coven))
			H.give_coven(/datum/coven/divine_coven)
	else if(istype(H.patron, /datum/patron/inhumen))
		if(!H.get_coven(/datum/coven/inhumen_coven))
			H.give_coven(/datum/coven/inhumen_coven)
	else if(istype(H.patron, /datum/patron/old_god))
		if(!H.get_coven(/datum/coven/old_god_coven))
			H.give_coven(/datum/coven/old_god_coven)


/datum/clan_leader/proc/remove_leader(mob/living/carbon/human/H)
	REMOVE_TRAIT(H, TRAIT_CLAN_LEADER, "clan")
	for(var/spell_type in lord_spells)
		H.mind?.RemoveSpell(spell_type)

	for(var/verb_path in lord_verbs)
		H.verbs -= verb_path

	for(var/trait in lord_traits)
		REMOVE_TRAIT(H, trait, "lord_component")
	H.maxbloodpool -= vitae_bonus


/datum/coven_power/levitation
	name = "Levitation"
	desc = "Channel the vampyric subtle grace to float above the ground for a short time."
	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_LYING
	target_type = NONE
	range = 0
	vitae_cost = 5
	toggled = TRUE
	duration_length = 2 SECONDS
	cooldown_length = 45 SECONDS

/datum/coven_power/levitation/activate()
	. = ..()
	if(!.)
		return FALSE
	if(!owner)
		return FALSE

	// Apply the existing vampire float buff
	owner.apply_status_effect(/datum/status_effect/buff/vampire_float)
	to_chat(owner, span_notice("You feel the world fall away beneath you."))
	owner.playsound_local(get_turf(owner), 'sound/misc/vampirespell.ogg', 100, FALSE)
	return TRUE

/datum/coven_power/levitation/on_refresh()
	// Ensure the float status stays applied while the power is refreshed (vitae drained by base)
	if(!owner)
		return
	if(!owner.has_status_effect(/datum/status_effect/buff/vampire_float))
		owner.apply_status_effect(/datum/status_effect/buff/vampire_float)

/datum/coven_power/levitation/deactivate()
	. = ..()
	if(!owner)
		return
	// Remove the floating status when levitation stops
	owner.remove_status_effect(/datum/status_effect/buff/vampire_float)
	to_chat(owner, span_notice("You fall gently back to the ground."))
	owner.playsound_local(get_turf(owner), 'sound/misc/vampirespell.ogg', 100, FALSE)
