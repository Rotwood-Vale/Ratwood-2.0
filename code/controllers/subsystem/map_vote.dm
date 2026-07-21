#define MAP_VOTE_CACHE_LOCATION "data/map_vote_cache.json"
#define SS_INIT_SUCCESS 2

SUBSYSTEM_DEF(map_vote)
	name = "Map Vote"
	flags = SS_NO_FIRE

	/// admin override flag
	var/admin_override = FALSE

	/// vote finalized flag
	var/already_voted = FALSE

	/// selected map config
	var/datum/map_config/next_map_config

	/// cache: map_id => weight
	var/list/map_vote_cache

	/// rollback cache
	var/list/previous_cache

	/// UI tally
	var/tally_printout = span_red("Loading...")

/datum/controller/subsystem/map_vote/Initialize()
	if(rustg_file_exists(MAP_VOTE_CACHE_LOCATION))
		map_vote_cache = json_decode(file2text(MAP_VOTE_CACHE_LOCATION))
	else
		map_vote_cache = list()

	sanitize_cache()
	update_tally_printout()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/map_vote/proc/write_cache()
	rustg_file_write(json_encode(map_vote_cache), MAP_VOTE_CACHE_LOCATION)

/datum/controller/subsystem/map_vote/proc/sanitize_cache()
	var/max = 200
	for(var/map_name in map_vote_cache)
		var/found = FALSE

		for(var/id in config.maplist)
			var/datum/map_config/cfg = config.maplist[id]
			if(cfg.map_name == map_name)
				found = TRUE
				break

		if(!found)
			map_vote_cache -= map_name
			continue

		map_vote_cache[map_name] = min(map_vote_cache[map_name], max)

/datum/controller/subsystem/map_vote/proc/send_map_vote_notice(...)
	var/static/last_message_at
	if(last_message_at == world.time)
		message_admins("Duplicate map vote notice in same tick.")
	last_message_at = world.time

	var/list/messages = args.Copy()
	to_chat(world, span_purple(examine_block("Map Vote\n<hr>\n[messages.Join("\n")]")))

/datum/controller/subsystem/map_vote/proc/finalize_map_vote(datum/vote/map_vote/map_vote)
	if(already_voted)
		message_admins("Map vote already finalized.")
		return

	already_voted = TRUE

	var/flat = CONFIG_GET(number/map_vote_flat_bonus)
	previous_cache = map_vote_cache.Copy()

	// apply votes
	for(var/map_id in map_vote.choices)
		if(!(map_id in config.maplist))
			continue

		var/datum/map_config/cfg = config.maplist[map_id]
		map_vote_cache[map_id] += (map_vote.choices[map_id] * cfg.voteweight) + flat

	sanitize_cache()

	write_cache()

	update_tally_printout()

	if(admin_override)
		send_map_vote_notice("Admin override active. Map not changed.")
		return

	var/list/valid_maps = filter_cache_to_valid_maps()
	if(!length(valid_maps))
		send_map_vote_notice("No valid maps.")
		return

	// winner is now DIRECTLY a map_id
	var/winner_id = pick_weight(valid_maps)
	var/datum/map_config/winner_cfg = config.maplist[winner_id]

	if(!winner_cfg)
		send_map_vote_notice("Winner map could not be resolved (bad map_id: [winner_id]).")
		return

	if(!set_next_map(winner_cfg))
		send_map_vote_notice("Failed to set next map.")
		return

	send_map_vote_notice("Map Selected - [span_bold(winner_cfg.map_name)]")

	// decay winner so it doesn't repeat forever
	if(length(valid_maps) > 1)
		map_vote_cache[winner_id] = CONFIG_GET(number/map_vote_minimum_tallies)
		write_cache()
		update_tally_printout()

/datum/controller/subsystem/map_vote/proc/filter_cache_to_valid_maps()
	var/connected_players = length(GLOB.player_list)
	var/list/valid_maps = list()

	for(var/map_id in map_vote_cache)
		var/datum/map_config/cfg = config.maplist[map_id]
		if(!cfg)
			continue
		if(!cfg.votable)
			continue
		if(cfg.config_min_users && connected_players < cfg.config_min_users)
			continue
		if(cfg.config_max_users && connected_players > cfg.config_max_users)
			continue

		valid_maps[map_id] = map_vote_cache[map_id]

	return valid_maps

/datum/controller/subsystem/map_vote/proc/set_next_map(datum/map_config/change_to)
	if(!change_to.MakeNextMap())
		message_admins("Failed to write next_map.json for [change_to.map_name]!")
		return FALSE

	next_map_config = change_to
	return TRUE

/datum/controller/subsystem/map_vote/proc/revert_next_map()
	if(previous_cache)
		map_vote_cache = previous_cache
		previous_cache = null

	already_voted = FALSE
	admin_override = FALSE

	send_map_vote_notice("Next map reverted. Voting re-enabled.")
	update_tally_printout()

/datum/controller/subsystem/map_vote/proc/update_tally_printout()
	var/list/data = list()

	for(var/map_id in map_vote_cache)
		var/datum/map_config/cfg = config.maplist[map_id]
		if(!cfg)
			continue

		data += "[cfg.map_name] - [map_vote_cache[map_id]]"

	tally_printout = boxed_message("Current Tallies\n<hr>[data.Join("\n")]")

