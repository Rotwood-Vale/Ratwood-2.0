/datum/mind
	var/has_changed_spell = FALSE // If the person has changed their spells for theday
	var/has_rituos = FALSE
	var/obj/effect/proc_holder/spell/rituos_spell
	var/datum/action/innate/khan_declare_action // Khan's declare war action
	var/khan_indestructible_active = FALSE // Whether Khan is channeling Indestructible ability
	var/list/khan_chain_targets = list() // List of targets chained by Khan
	var/list/khan_chain_beams = list() // List of beam objects for chains
	var/list/khan_chain_lock_times = list() // List of lock times for each chain
	var/mob/living/carbon/human/khan_chained_by // Khan who has chained this person
