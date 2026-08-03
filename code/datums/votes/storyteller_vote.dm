/datum/vote/chaos
	name = "chaos"
	default_message = "Vote for round type. Adventure mode disables villains and doubles adventurer count."
	default_choices = list("Adventure", "Chaos")
	count_method = VOTE_COUNT_METHOD_SINGLE
	winner_method = VOTE_WINNER_METHOD_SIMPLE

/datum/vote/chaos/finalize_vote(winning_option)
	SSgamemode.chaos_vote_result(winning_option || "Chaos")

/datum/vote/chaos/can_be_initiated(forced)
	. = ..()
	if(. != VOTE_AVAILABLE)
		return .
	if(forced)
		return .

	// Storyteller votes can only be created if they're forced to be made.
	// (Either an admin makes it, or otherwise.)
	return "Only admins can create custom votes."
