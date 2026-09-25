/datum/mind
	var/has_changed_spell = FALSE // If the person has changed their spells for theday
	/// If you have a spell granted by Rituos, resets when you sleep
	var/has_rituos = FALSE
	/// One bomb can be claimed from HERMES each day when set.
	var/has_bomb = FALSE
	/// One drug delivery can be claimed from HERMES each day when set.
	var/has_drug_delivery = FALSE
	var/obj/effect/proc_holder/spell/rituos_spell
