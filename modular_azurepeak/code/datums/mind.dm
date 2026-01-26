/datum/mind
	var/has_changed_spell = FALSE // If the person has changed their spells for theday
	var/has_rituos = FALSE
	var/obj/effect/proc_holder/spell/rituos_spell
	var/datum/action/innate/khan_declare_action // Khan's declare war action
	var/khan_indestructible_active = FALSE // Whether Khan is channeling Indestructible ability
