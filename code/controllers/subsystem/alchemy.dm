SUBSYSTEM_DEF(alchemy)
	name = "Alchemy"
	flags = SS_NO_FIRE

/datum/controller/subsystem/alchemy/Initialize()
	init_alchemy_runes()
	var/list/round_runes = GLOB.alch_round_runes
	var/list/cauldron_rec = GLOB.alch_cauldron_recipes
	log_world("Alchemy: Initialized [cauldron_rec.len] recipes and [round_runes.len] ingredient profiles.")
	return ..()
