/datum/round_event_control/antagonist/migrant_wave/gnolls
	name = "Gnolls Migration"
	typepath = /datum/round_event/migrant_wave/gnolls
	wave_type = /datum/migrant_wave/gnolls
	max_occurrences = 2
	weight = 5
	earliest_start = 0 SECONDS
	tags = list(
		TAG_COMBAT,
		TAG_VILLIAN,
	)

/datum/round_event_control/antagonist/migrant_wave/gnolls/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	var/slot_cap = 6
	for(var/datum/round_modifier/mod in SSgamemode.active_modifiers)
		if(mod.type == /datum/round_modifier/high_gnolls)
			slot_cap = 8
			break

	var/datum/job/gnoll_job = SSjob.GetJob("Gnoll")
	if(gnoll_job.total_positions >= slot_cap)
		return FALSE

/datum/round_event/migrant_wave/gnolls/start()
	var/two_spawn_chance = 100
	var/gnolls_to_add = 1
	var/slot_cap = 6

	for(var/datum/round_modifier/mod in SSgamemode.active_modifiers)
		switch(mod.type)
			if(/datum/round_modifier/medium_gnolls)
				two_spawn_chance = 50
				break
			if(/datum/round_modifier/high_gnolls)
				two_spawn_chance = 50
				slot_cap = 8
				break

	if(prob(two_spawn_chance))
		gnolls_to_add = 2

	var/datum/job/gnoll_job = SSjob.GetJob("Gnoll")
	gnoll_job.total_positions = min(gnoll_job.total_positions + gnolls_to_add, slot_cap)
	gnoll_job.spawn_positions = min(gnoll_job.spawn_positions + gnolls_to_add, slot_cap)
	SSrole_class_handler.assassins_in_round = TRUE
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		if(!player.client)
			continue

		to_chat(player, span_danger("Graggar demands blood, gnolls flock to [SSmapping.map_adjustment.realm_name]."))
