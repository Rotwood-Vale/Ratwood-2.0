/datum/vote/map_vote
	name = "Map"
	default_message = "Vote for next round's map!"
	count_method = VOTE_COUNT_METHOD_SINGLE
	winner_method = VOTE_WINNER_METHOD_SIMPLE
	display_statistics = TRUE

/datum/vote/map_vote/New()
	. = ..()
	default_choices = SSmap_vote.get_valid_map_vote_choices()

/datum/vote/map_vote/create_vote(mob/vote_creator)
	default_choices = SSmap_vote.get_valid_map_vote_choices()
	. = ..()
	if(!.)
		return FALSE

	if(length(choices) == 1) // Only one choice, no need to vote. Let's just auto-rotate it to the only remaining map because it would just happen anyways.
		var/datum/map_config/change_me_out = global.config.maplist[choices[1]]
		finalize_vote(choices[1])// voted by not voting, very sad.
		to_chat(world, span_boldannounce("The map vote has been skipped because there is only one map left to vote for. \
			The map has been changed to [change_me_out.map_name]."))
		return FALSE
	if(length(choices) == 0)
		to_chat(world, span_boldannounce("A map vote was called, but there are no maps to vote for! \
			Players, complain to the admins. Admins, complain to the coders."))
		return FALSE

	return TRUE

/datum/vote/map_vote/toggle_votable()
	CONFIG_SET(flag/allow_vote_map, !CONFIG_GET(flag/allow_vote_map))

/datum/vote/map_vote/is_config_enabled()
	return CONFIG_GET(flag/allow_vote_map)

/datum/vote/map_vote/can_be_initiated(forced)
	. = ..()
	if(. != VOTE_AVAILABLE)
		return .

	if(SSmap_vote.next_map_config)
		return "The next map has already been selected."

	// The below case will be caught in create_vote() if the vote is being forced
	// This ensures proper map rotation if there aren't enough votable maps for whatever reason
	if(forced)
		return VOTE_AVAILABLE

	var/list/new_choices = SSmap_vote.get_valid_map_vote_choices()
	var/num_choices = length(new_choices)
	if(num_choices <= 1)
		return "There [num_choices == 1 ? "is only one map" : "are no maps"] to choose from."

	return VOTE_AVAILABLE

/datum/vote/map_vote/get_vote_result(list/non_voters)
	// Even if we have default no vote off,
	// if our default map is null for some reason, we shouldn't continue
	if(CONFIG_GET(flag/default_no_vote))
		return ..()

	for(var/non_voter_ckey in non_voters)
		var/client/non_voter_client = non_voters[non_voter_ckey]

		var/their_preferred_map = non_voter_client?.prefs?.preferred_map

		// No preferred map = abstain
		if(isnull(their_preferred_map))
			continue

		if(their_preferred_map in choices)
			choices[their_preferred_map] += 1
			choices_by_ckey[non_voter_ckey] = their_preferred_map

	return ..()

/datum/vote/map_vote/get_result_text(list/all_winners, real_winner, list/non_voters)
	var/title_text

	if(override_question)
		title_text = span_bold(override_question)
	else
		title_text = span_bold("[capitalize(name)] Vote")

	var/returned_text = "Winner Selection: Simple"

	var/total_votes = 0
	for(var/map in choices)
		total_votes += choices[map]

	if(total_votes <= 0)
		return span_bold("Vote Result: Inconclusive - No Votes!")

	returned_text += "\n"
	returned_text += "\nTotal Votes: [total_votes]"

	if(display_statistics)
		returned_text += "\n\nResults:"

		for(var/map in choices)
			var/direct_votes = choices[map]

			// How many of this map's voters are carrying a pity bonus in,
			// and how much, purely for admin/player visibility.
			var/bonus_voters = 0
			var/total_bonus_weight = 0

			for(var/ckey in choices_by_ckey)
				if(choices_by_ckey[ckey] != map)
					continue
				var/bonus = SSmap_vote.get_bonus_for(ckey, map)
				if(bonus > 0)
					bonus_voters++
					total_bonus_weight += bonus

			var/text = "[span_bold(map)]: [direct_votes] vote(s)"
			if(bonus_voters)
				text += " (+[total_bonus_weight] bonus from [bonus_voters] returning voter[bonus_voters == 1 ? "" : "s"])"

			returned_text += "\n[text]"

	return fieldset_block(title_text, returned_text, "boxed_message purple_box")

/datum/vote/map_vote/finalize_vote(winning_option)
	SSmap_vote.finalize_map_vote(src)
