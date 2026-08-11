#define MAP_VOTE_CACHE_LOCATION "data/map_vote_cache.json"
#define SS_INIT_SUCCESS 2

// How much bonus a loss adds to a player's banked pity vote for that map.
#define MAP_VOTE_BONUS_INCREMENT 1

// Hard cap on a single player's banked bonus for a single map. Stops one
// very persistent minority from eventually forcing a win on their own.
#define MAP_VOTE_BONUS_MAX 10

SUBSYSTEM_DEF(map_vote)
	name = "Map Vote"
	flags = SS_NO_FIRE

	// admin override flag
	var/admin_override = FALSE

	// vote finalized flag
	var/already_voted = FALSE

	// selected map config
	var/datum/map_config/next_map_config

	// Per-player 'pity' cache: ckey (map_id banked bonus weight).
	// A player only carries weight for a map they personally voted for and
	// lost with. It's cleared the moment that map wins while they're voting
	// for it, and it never grows from rounds they weren't present for.
	var/list/player_vote_bonus

	// snapshot of player_vote_bonus before the last finalize, for revert_next_map()
	var/list/previous_bonus

	// UI tally
	var/tally_printout = span_red("Loading...")

/datum/controller/subsystem/map_vote/Initialize()
	if(rustg_file_exists(MAP_VOTE_CACHE_LOCATION))
		player_vote_bonus = json_decode(file2text(MAP_VOTE_CACHE_LOCATION))
	else
		player_vote_bonus = list()

	sanitize_cache()
	update_tally_printout()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/map_vote/proc/write_cache()
	rustg_file_write(json_encode(player_vote_bonus), MAP_VOTE_CACHE_LOCATION)

/datum/controller/subsystem/map_vote/proc/sanitize_cache()
	for(var/ckey in player_vote_bonus)
		var/list/maps_for_ckey = player_vote_bonus[ckey]

		for(var/map_id in maps_for_ckey)
			var/found = FALSE
			for(var/id in config.maplist)
				var/datum/map_config/cfg = config.maplist[id]
				if(cfg.map_name == map_id || id == map_id)
					found = TRUE
					break

			if(!found)
				maps_for_ckey -= map_id
				continue

			maps_for_ckey[map_id] = clamp(maps_for_ckey[map_id], 0, MAP_VOTE_BONUS_MAX)
			if(maps_for_ckey[map_id] <= 0)
				maps_for_ckey -= map_id

		if(!length(maps_for_ckey))
			player_vote_bonus -= ckey

/datum/controller/subsystem/map_vote/proc/send_map_vote_notice(...)
	var/static/last_message_at
	if(last_message_at == world.time)
		message_admins("Duplicate map vote notice in same tick.")
	last_message_at = world.time

	var/list/messages = args.Copy()
	to_chat(world, span_purple(examine_block("Map Vote\n<hr>\n[messages.Join("\n")]")))

/datum/controller/subsystem/map_vote/proc/get_valid_map_vote_choices()
	var/list/choices = list()

	for(var/map_id in config.maplist)
		var/datum/map_config/cfg = config.maplist[map_id]

		if(!cfg)
			continue
		if(!cfg.votable)
			continue

		choices += map_id

	return choices

/datum/controller/subsystem/map_vote/proc/filter_cache_to_valid_maps()
	var/connected_players = length(GLOB.player_list)
	var/list/valid_maps = list()

	for(var/map_id in config.maplist)
		var/datum/map_config/cfg = config.maplist[map_id]
		if(!cfg)
			continue
		if(!cfg.votable)
			continue
		if(cfg.config_min_users && connected_players < cfg.config_min_users)
			continue
		if(cfg.config_max_users && connected_players > cfg.config_max_users)
			continue

		valid_maps += map_id

	return valid_maps

// Returns a player's currently banked bonus for a given map (0 if none).
/datum/controller/subsystem/map_vote/proc/get_bonus_for(ckey, map_id)
	if(!player_vote_bonus[ckey])
		return 0
	var/list/maps_for_ckey = player_vote_bonus[ckey]
	return maps_for_ckey[map_id] || 0

/datum/controller/subsystem/map_vote/proc/finalize_map_vote(datum/vote/map_vote/map_vote)
	if(already_voted)
		message_admins("Map vote already finalized.")
		return

	already_voted = TRUE

	var/flat = CONFIG_GET(number/map_vote_flat_bonus)

	previous_bonus = deep_copy_list(player_vote_bonus)

	// ckey map_id, everyone credited with a vote this round (direct votes
	// tracked by the base /datum/vote itself, plus preference auto-votes for
	// non-voters that map_vote.dm adds in on top).
	var/list/ckey_choices = map_vote.choices_by_ckey

	// Tally this round using each voter's banked bonus, just applied per-voter now instead of
	// against a global running total.
	var/list/round_tally = list()
	for(var/ckey in ckey_choices)
		var/map_id = ckey_choices[ckey]
		if(!(map_id in config.maplist))
			continue

		var/datum/map_config/cfg = config.maplist[map_id]
		var/bonus = get_bonus_for(ckey, map_id)
		var/weight = (1 + bonus) * cfg.voteweight

		round_tally[map_id] = (round_tally[map_id] || 0) + weight

	// Flat per-map nudge, applied once to any map that got at least one vote
	// this round - same tie-breaker role it played before.
	for(var/map_id in round_tally)
		round_tally[map_id] += flat

	update_tally_printout(round_tally)

	if(admin_override)
		send_map_vote_notice("Admin override active. Map not changed.")
		return

	var/list/valid_maps = filter_cache_to_valid_maps()
	if(!length(valid_maps))
		send_map_vote_notice("No valid maps.")
		return

	// Pick the highest tally among maps that were actually voted on this round
	var/winner_id
	var/winner_amount = -1

	for(var/map_id in valid_maps)
		if(!(map_id in round_tally))
			continue
		var/tally = round_tally[map_id]
		if(tally > winner_amount)
			winner_id = map_id
			winner_amount = tally

	// Nobody voted for anything valid - fall back to the first valid map so
	// rotation doesn't stall out.
	if(isnull(winner_id))
		winner_id = valid_maps[1]

	var/datum/map_config/winner_cfg = config.maplist[winner_id]
	if(!winner_cfg)
		send_map_vote_notice("Winner map could not be resolved (bad map_id: [winner_id]).")
		return

	if(!set_next_map(winner_cfg))
		send_map_vote_notice("Failed to set next map.")
		return

	// Apply the pity adjustments. Only touches ckeys who actually voted this
	// round everyone else's banked bonus is left exactly as it was.
	for(var/ckey in ckey_choices)
		var/map_id = ckey_choices[ckey]

		if(!player_vote_bonus[ckey])
			player_vote_bonus[ckey] = list()
		var/list/maps_for_ckey = player_vote_bonus[ckey]

		if(map_id == winner_id)
			maps_for_ckey -= map_id
		else
			maps_for_ckey[map_id] = clamp((maps_for_ckey[map_id] || 0) + MAP_VOTE_BONUS_INCREMENT, 0, MAP_VOTE_BONUS_MAX)

		if(!length(maps_for_ckey))
			player_vote_bonus -= ckey

	sanitize_cache()
	write_cache()

	var/list/messages = list()

	messages += "Map Selected - [span_bold(next_map_config.map_name)]"
	messages += ""
	messages += "The next round will be played on [span_bold(next_map_config.map_name)]."

	send_map_vote_notice(arglist(messages))

/datum/controller/subsystem/map_vote/proc/set_next_map(datum/map_config/change_to)
	if(!change_to.MakeNextMap())
		message_admins("Failed to write next_map.json for [change_to.map_name]!")
		return FALSE

	next_map_config = change_to
	return TRUE

/datum/controller/subsystem/map_vote/proc/revert_next_map()
	if(previous_bonus)
		player_vote_bonus = previous_bonus
		previous_bonus = null
		write_cache()

	already_voted = FALSE
	admin_override = FALSE

	send_map_vote_notice("Next map reverted. Voting re-enabled.")
	update_tally_printout()

// Shows how many players currently have a banked bonus for each map, and
// (right after a vote runs) what that round's effective tally was.
/datum/controller/subsystem/map_vote/proc/update_tally_printout(list/round_tally)
	var/list/data = list()

	var/list/bonus_holders = list() // map_id -> number of ckeys currently banking a bonus for it
	for(var/ckey in player_vote_bonus)
		var/list/maps_for_ckey = player_vote_bonus[ckey]
		for(var/map_id in maps_for_ckey)
			bonus_holders[map_id] = (bonus_holders[map_id] || 0) + 1

	for(var/map_id in config.maplist)
		var/datum/map_config/cfg = config.maplist[map_id]
		if(!cfg || !cfg.votable)
			continue

		var/line = "[cfg.map_name]"
		if(round_tally && (map_id in round_tally))
			line += " - last tally: [round_tally[map_id]]"
		if(bonus_holders[map_id])
			line += " - [bonus_holders[map_id]] player(s) holding a bonus"

		data += line

	tally_printout = boxed_message("Current Tallies\n<hr>[data.Join("\n")]")

// Player-facing text: only shows THIS ckey's own banked bonuses, never
// anyone else's. This is what the "Show Map Vote Tallies" verb should call -
// it deliberately does not touch tally_printout, which is aggregate/admin data.
/datum/controller/subsystem/map_vote/proc/get_personal_tally_text(ckey)
	var/list/data = list()
	var/list/maps_for_ckey = player_vote_bonus[ckey]

	for(var/map_id in config.maplist)
		var/datum/map_config/cfg = config.maplist[map_id]
		if(!cfg || !cfg.votable)
			continue

		var/bonus = maps_for_ckey ? (maps_for_ckey[map_id] || 0) : 0
		if(!bonus)
			continue

		data += "[cfg.map_name] - bonus votes banked: [bonus]"

	if(!length(data))
		return boxed_message("Your Map Vote Bonuses\n<hr>You aren't currently holding a bonus for any map. \
			Bonuses build up when a map you vote for doesn't win, and clear once it does.")

	return boxed_message("Your Map Vote Bonuses\n<hr>[data.Join("\n")]")
