/datum/vote/storyteller
	name = "storyteller"
	default_message = "Vote for the next storyteller."
	count_method = VOTE_COUNT_METHOD_SINGLE
	winner_method = VOTE_WINNER_METHOD_SIMPLE

/datum/vote/storyteller/New()
	. = ..()
	default_choices = SSgamemode.storyteller_vote_choices()
/datum/vote/storyteller/create_vote()
	default_choices = SSgamemode.storyteller_vote_choices()
	return ..()

/datum/vote/storyteller/finalize_vote(winning_option)
	SSgamemode.storyteller_vote_result(winning_option)

/datum/vote/storyteller/can_be_initiated(forced)
	. = ..()
	if(. != VOTE_AVAILABLE)
		return .
	if(forced)
		return .

	// Storyteller votes can only be created if they're forced to be made.
	// (Either an admin makes it, or otherwise.)
	return "Only admins can create custom votes."
