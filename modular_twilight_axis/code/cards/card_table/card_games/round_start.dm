/datum/card_table_session/proc/start_game(mob/user)
	if(stage != CARD_TABLE_STAGE_LOBBY || game_type == CARD_TABLE_GAME_NONE)
		return FALSE
	var/datum/card_table_player/requester = player_for_user(user)
	if(!requester || player_index(requester) != 1)
		return FALSE
	if(players.len < min_players())
		to_chat(user, span_warning("Not enough players."))
		return FALSE
	if(players.len)
		if(!dealer_rotates)
			dealer_index = 1
		else if(!dealer_index)
			dealer_index = 1
		else if(dealer_rounds > 0)
			advance_dealer()
		dealer_rounds++
	deck = card_table_make_deck()
	discard = list()
	dealer_hand = list()
	community_cards = list()
	xylix_seen_cards = list()
	xylix_cheat_used = list()
	for(var/datum/card_table_player/player in players)
		player.hand = list()
		player.standing = FALSE
		player.busted = FALSE
		player.ready = FALSE
		player.draws_used = 0
		player.poker_folded = FALSE
		player.poker_all_in = FALSE
		player.poker_bet = 0
		player.poker_total_bet = 0
		player.result = null
		player.left = FALSE
	stage = CARD_TABLE_STAGE_PLAYING
	blackjack_action_seq = 0
	blackjack_action_player_index = 0
	blackjack_action_bust = FALSE
	switch(game_type)
		if(CARD_TABLE_GAME_BLACKJACK)
			for(var/datum/card_table_player/bj_player in players)
				deal_to(bj_player, 2)
			for(var/datum/card_table_player/bj_reveal_player in players)
				xylix_try_reveal_for_turn_holder(bj_reveal_player)
			message = "Blackjack has begun. Variant: [blackjack_variant_label()]. [dealer_rotation_label()]."
		if(CARD_TABLE_GAME_POKER)
			for(var/datum/card_table_player/poker_player in players)
				switch(poker_variant)
					if(CARD_TABLE_POKER_TEXAS)
						deal_to(poker_player, 2)
					if(CARD_TABLE_POKER_OMAHA)
						deal_to(poker_player, 4)
					else
						deal_to(poker_player, 5)
			if(poker_uses_community_cards())
				community_cards += list(draw_one())
			poker_pot = 0
			poker_reset_betting_round()
			for(var/datum/card_table_player/poker_reveal_player in players)
				xylix_try_reveal_for_turn_holder(poker_reveal_player)
			message = "Poker has begun. Variant: [poker_variant_label()]. [dealer_rotation_label()]."
	SStgui.update_uis(owner)
	return TRUE
