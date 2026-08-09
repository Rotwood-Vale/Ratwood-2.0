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

	/// UI tally
	var/tally_printout = span_notice("Map vote tally carryover is disabled. Votes now use active round votes only.")

/datum/controller/subsystem/map_vote/Initialize()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/map_vote/proc/send_map_vote_notice(...)
	var/static/last_message_at
	if(last_message_at == world.time)
		message_admins("Duplicate map vote notice in same tick.")
	last_message_at = world.time

	var/list/messages = args.Copy()
	to_chat(world, span_purple(examine_block("Map Vote\n<hr>\n[messages.Join("\n")]")))

/datum/controller/subsystem/map_vote/proc/finalize_map_vote(datum/vote/map_vote/map_vote, winning_option)
	if(already_voted)
		message_admins("Map vote already finalized.")
		return

	if(admin_override)
		send_map_vote_notice("Admin override active. Map not changed.")
		return

	if(isnull(winning_option))
		send_map_vote_notice("No map winner selected.")
		return

	var/datum/map_config/winner_cfg = config.maplist[winning_option]
	if(!winner_cfg)
		send_map_vote_notice("Winner map could not be resolved (bad map_id: [winning_option]).")
		return
	if(!winner_cfg.votable)
		send_map_vote_notice("Winning map [winner_cfg.map_name] is no longer votable.")
		return

	var/connected_players = length(GLOB.player_list)
	if(winner_cfg.config_min_users && connected_players < winner_cfg.config_min_users)
		send_map_vote_notice("Winning map [winner_cfg.map_name] is no longer valid at the current player count.")
		return
	if(winner_cfg.config_max_users && connected_players > winner_cfg.config_max_users)
		send_map_vote_notice("Winning map [winner_cfg.map_name] is no longer valid at the current player count.")
		return

	if(!set_next_map(winner_cfg))
		send_map_vote_notice("Failed to set next map.")
		return

	already_voted = TRUE

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
	already_voted = FALSE
	admin_override = FALSE

	send_map_vote_notice("Next map reverted. Voting re-enabled.")

