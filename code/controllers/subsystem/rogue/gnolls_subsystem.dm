SUBSYSTEM_DEF(gnoll_scaling)
	name = "Gnoll Scaling Controller"
	flags = SS_NO_FIRE

	var/gnoll_scaling_mode = 0
	var/gnoll_playercount_lock = TRUE
	var/desired_gnoll_slots = 2
	var/gnoll_scaling_check_queued = FALSE
	var/last_logged_target_slots = 2
	var/last_storyteller_name = "Unknown"
	var/last_mode_origin = "default"
	var/admin_scaling_override = FALSE
	var/last_applied_total_positions = null
	var/last_applied_spawn_positions = null

	// Tuning values for each scaling mode.
	var/max_gnoll_slots = 6
	var/double_mode_slots = 2
	var/flat_mode_threshold_players = 125
	var/flat_mode_low_slots = 2
	var/flat_mode_high_slots = 4
	var/flat_mode_recheck_below_players = 125
	var/dynamic_mode_base_slots = 2
	var/dynamic_mode_start_players = 75
	var/dynamic_mode_players_per_extra_slot = 25
	var/dynamic_mode_recheck_below_players = 90

/datum/controller/subsystem/gnoll_scaling/proc/get_mode_name(mode)
	switch(mode)
		if(GNOLL_SCALING_NONE)
			return "NONE"
		if(GNOLL_SCALING_DOUBLE)
			return "DOUBLE"
		if(GNOLL_SCALING_FLAT)
			return "FLAT"
		if(GNOLL_SCALING_DYNAMIC)
			return "DYNAMIC"
	return "UNKNOWN([mode])"

//logging for admin notice around storyteller and gnoll scaling changes for bugfixing AND usefulness
/datum/controller/subsystem/gnoll_scaling/proc/get_scaling_context(mode, players_amt)
	return "mode=[get_mode_name(mode)], storyteller=[last_storyteller_name], origin=[last_mode_origin], active_humans=[players_amt]"

/datum/controller/subsystem/gnoll_scaling/proc/get_admin_scaling_snapshot()
	var/list/snapshot = list(
		"mode_id" = null,
		"mode_name" = "Unavailable",
		"has_pop_growth" = FALSE,
		"pop_remaining" = "N/A",
		"auto_scaling_disabled" = FALSE,
		"auto_scaling_status" = "Enabled",
	)

	if(admin_scaling_override)
		snapshot["auto_scaling_disabled"] = TRUE
		snapshot["auto_scaling_status"] = "Disabled for this round (manual slot override detected)"

	var/mode = get_gnoll_scaling()
	snapshot["mode_id"] = mode
	snapshot["mode_name"] = get_mode_name(mode)
	var/has_pop_growth = (mode == GNOLL_SCALING_FLAT || mode == GNOLL_SCALING_DYNAMIC)
	snapshot["has_pop_growth"] = has_pop_growth
	if(!has_pop_growth)
		return snapshot

	var/players_amt = get_active_player_count(alive_check = 1, afk_check = 1, human_check = 1)
	var/next_slot_at_players = null

	switch(mode)
		if(GNOLL_SCALING_FLAT)
			if(players_amt < flat_mode_threshold_players && flat_mode_high_slots > flat_mode_low_slots)
				next_slot_at_players = flat_mode_threshold_players
		if(GNOLL_SCALING_DYNAMIC)
			if(dynamic_mode_players_per_extra_slot > 0 && desired_gnoll_slots < max_gnoll_slots)
				var/current_extra_slots = max(desired_gnoll_slots - dynamic_mode_base_slots, 0)
				next_slot_at_players = dynamic_mode_start_players + ((current_extra_slots + 1) * dynamic_mode_players_per_extra_slot)

	if(!isnull(next_slot_at_players))
		var/pop_remaining = max(next_slot_at_players - players_amt, 0)
		snapshot["pop_remaining"] = "[pop_remaining] (next at [next_slot_at_players])"
	else
		snapshot["pop_remaining"] = "0 (no further slot increases in this mode)"

	return snapshot

/datum/controller/subsystem/gnoll_scaling/proc/resolve_preferred_mode(preferred_mode, storyteller_name = "Unknown")
	last_storyteller_name = storyteller_name
	last_mode_origin = "direct"
	if(preferred_mode == GNOLL_SCALING_RANDOM)
		last_mode_origin = "random"
		preferred_mode = pick(GNOLL_SCALING_DOUBLE, GNOLL_SCALING_FLAT, GNOLL_SCALING_DYNAMIC)

	if(!(preferred_mode in list(GNOLL_SCALING_NONE, GNOLL_SCALING_DOUBLE, GNOLL_SCALING_FLAT, GNOLL_SCALING_DYNAMIC)))
		last_mode_origin = "fallback"
		preferred_mode = GNOLL_SCALING_DOUBLE

	return preferred_mode

/datum/controller/subsystem/gnoll_scaling/proc/apply_storyteller_mode(preferred_mode, storyteller_name = "Unknown")
	gnoll_scaling_mode = resolve_preferred_mode(preferred_mode, storyteller_name)
	return gnoll_scaling_mode

/datum/controller/subsystem/gnoll_scaling/proc/queue_scaling_recheck()
	if(gnoll_scaling_check_queued)
		return
	gnoll_scaling_check_queued = TRUE
	addtimer(CALLBACK(src, PROC_REF(unlock_gnoll_scaling)), 6000)

// Scaling tuning quick reference:
// - NONE: disable gnoll spawning (0 slots).
// - DOUBLE: set double_mode_slots.
// - FLAT: below flat_mode_threshold_players uses flat_mode_low_slots, otherwise flat_mode_high_slots.
// - DYNAMIC: starts at dynamic_mode_base_slots, then adds using FLOOR((active_players - dynamic_mode_start_players) / dynamic_mode_players_per_extra_slot, 1)
//   once active_players is above dynamic_mode_start_players.
// - max_gnoll_slots clamps final slot count.
// - recheck_below_players controls when another scaling check is queued.
/datum/controller/subsystem/gnoll_scaling/proc/unlock_gnoll_scaling()
	gnoll_scaling_check_queued = FALSE
	if(admin_scaling_override)
		return
	var/players_amt = get_active_player_count(alive_check = 1, afk_check = 1, human_check = 1)

	var/mode = get_gnoll_scaling()
	var/target_slots = 2
	var/previous_target_slots = desired_gnoll_slots
	var/recheck_below_players = 0

	switch(mode)
		if(GNOLL_SCALING_NONE)
			target_slots = 0
		if(GNOLL_SCALING_DOUBLE)
			target_slots = double_mode_slots
		if(GNOLL_SCALING_FLAT)
			target_slots = (players_amt >= flat_mode_threshold_players) ? flat_mode_high_slots : flat_mode_low_slots
			recheck_below_players = flat_mode_recheck_below_players
		if(GNOLL_SCALING_DYNAMIC)
			target_slots = dynamic_mode_base_slots
			if(players_amt > dynamic_mode_start_players)
				target_slots += FLOOR((players_amt - dynamic_mode_start_players) / dynamic_mode_players_per_extra_slot, 1)
			recheck_below_players = dynamic_mode_recheck_below_players

	desired_gnoll_slots = target_slots
	gnoll_playercount_lock = (target_slots <= 1)
	if(target_slots != previous_target_slots && target_slots != last_logged_target_slots)
		last_logged_target_slots = target_slots
		var/log_msg = "GNOLL SCALING: target changed to [target_slots] ([get_scaling_context(mode, players_amt)])."
		log_game(log_msg)
		message_admins(log_msg)

	var/datum/job/gnoll_job = SSjob.GetJob("Gnoll")
	if(!gnoll_job)
		queue_scaling_recheck()
		return

	var/old_total = gnoll_job.total_positions
	var/old_spawn = gnoll_job.spawn_positions
	if(!isnull(last_applied_total_positions) && !isnull(last_applied_spawn_positions))
		if(old_total != last_applied_total_positions || old_spawn != last_applied_spawn_positions)
			admin_scaling_override = TRUE
			var/override_msg = "GNOLL SCALING: external slot change detected ([old_total]/[old_spawn] vs last scaling [last_applied_total_positions]/[last_applied_spawn_positions]); disabling gnoll auto-scaling until round restart."
			log_game(override_msg)
			message_admins(override_msg)
			return
	var/capped_target_slots = clamp(target_slots, 0, max_gnoll_slots)
	var/new_total = max(gnoll_job.current_positions, capped_target_slots)
	var/new_spawn = max(gnoll_job.current_positions, capped_target_slots)
	gnoll_job.total_positions = new_total
	gnoll_job.spawn_positions = new_spawn
	last_applied_total_positions = new_total
	last_applied_spawn_positions = new_spawn

	if(new_total != old_total || new_spawn != old_spawn)
		var/slot_log_msg = "GNOLL SCALING: slots changed from [old_total]/[old_spawn] to [new_total]/[new_spawn] ([get_scaling_context(mode, players_amt)])."
		log_game(slot_log_msg)
		message_admins(slot_log_msg)

	if(new_total > old_total || new_spawn > old_spawn)
		for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
			if(player.client)
				to_chat(player, span_alert("Graggar demands blood, gnolls flock to the Vale!"))

	if(recheck_below_players > 0 && players_amt < recheck_below_players)
		queue_scaling_recheck()

// Keep scaling state in sync when trusted game systems adjust gnoll slots outside this subsystem.
/datum/controller/subsystem/gnoll_scaling/proc/note_external_slot_adjustment(total_positions, spawn_positions)
	last_applied_total_positions = total_positions
	last_applied_spawn_positions = spawn_positions

/datum/controller/subsystem/gnoll_scaling/proc/get_gnoll_scaling()
	if(gnoll_scaling_mode != 0)
		return gnoll_scaling_mode

	var/preferred_mode = GNOLL_SCALING_DOUBLE
	var/storyteller_name = "Unknown"
	if(SSgamemode?.current_storyteller)
		preferred_mode = SSgamemode.current_storyteller.preferred_gnoll_mode
		storyteller_name = SSgamemode.current_storyteller.name
	else if(SSgamemode?.selected_storyteller)
		var/datum/storyteller/selected_storyteller = SSgamemode.storytellers[SSgamemode.selected_storyteller]
		if(selected_storyteller)
			preferred_mode = selected_storyteller.preferred_gnoll_mode
			storyteller_name = selected_storyteller.name

	gnoll_scaling_mode = resolve_preferred_mode(preferred_mode, storyteller_name)
	return gnoll_scaling_mode
