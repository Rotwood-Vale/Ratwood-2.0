/datum/vote/chaos
	name = "chaos"
	default_choices = list("Low Chaos", "Medium Chaos", "High Chaos")
	count_method = VOTE_COUNT_METHOD_SINGLE
	winner_method = VOTE_WINNER_METHOD_SIMPLE

/datum/vote/chaos/finalize_vote(winning_option)
	SSgamemode.chaos_vote_result(winning_option || "Medium Chaos")

/datum/vote/chaos/can_be_initiated(forced)
	. = ..()
	if(. != VOTE_AVAILABLE)
		return .
	if(forced)
		return .

	// Storyteller votes can only be created if they're forced to be made.
	// (Either an admin makes it, or otherwise.)
	return "Only admins can create custom votes."
