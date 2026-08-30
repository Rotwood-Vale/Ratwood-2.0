/datum/vote/endround
	name = "endround"
	default_message = "Vote to end the current round."
	winner_method = VOTE_WINNER_METHOD_SIMPLE

/datum/vote/endround/New()
	. = ..()
	default_choices = list(
		"Continue Playing",
		"End Round"
	)

/datum/vote/endround/finalize_vote(winning_option)
	if(winning_option == "Continue Playing")
		log_game("LOG VOTE: CONTINUE PLAYING AT [REALTIMEOFDAY]")
		GLOB.round_timer = world.time + ROUND_EXTENSION_TIME
		return

	log_game("LOG VOTE: ROUNDVOTEEND [REALTIMEOFDAY]")

	to_chat(world, "<font color='purple'>[ROUND_END_TIME_VERBAL]</font>")

	SSgamemode.roundvoteend = TRUE
	SSgamemode.round_ends_at = world.time + ROUND_END_TIME

	world.TgsAnnounceVoteEndRound()

/datum/vote/endround/can_be_initiated(forced)
	. = ..()
	if(. != VOTE_AVAILABLE)
		return .
	if(forced)
		return .

	// endround votes can only be created if they're forced to be made.
	// (Either an admin makes it, or otherwise.)
	return "Only admins can create custom votes."
