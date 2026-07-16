/datum/mind
	var/has_changed_spell = FALSE // If the person has changed their spells for theday
	var/free_spell_unbinds = 0 // Free spellbook unbinds used today (3 for t3 arcane+)
	var/strained_spell_unbinds = 0 // Costly spellbook unbinds used today (2 for real, "3" though the third one kills you)
	var/has_fed_spellbook_lux = FALSE // Lux-fed spellbook unbind used today
	/// If you have a spell granted by Rituos, resets when you sleep
	var/has_rituos = FALSE
	var/obj/effect/proc_holder/spell/rituos_spell
