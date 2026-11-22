/datum/card_table_session/proc/hand_value(list/hand)
	var/total = 0
	var/aces = 0
	for(var/list/card in hand)
		var/rank = "[card["rank"]]"
		if(rank == "A")
			aces++
		switch(blackjack_variant)
			if(CARD_TABLE_BLACKJACK_GRON)
				if(rank == "A")
					total += 1
				else if(rank == "J" || rank == "Q" || rank == "K")
					total += 11
				else
					total += card_table_card_value(card)
			if(CARD_TABLE_BLACKJACK_VALORIA)
				if(rank == "A" || rank == "J" || rank == "Q" || rank == "K")
					total += 10
				else
					total += card_table_card_value(card)
			if(CARD_TABLE_BLACKJACK_GRENZELHOFT)
				if(rank == "A" || rank == "J" || rank == "Q" || rank == "K")
					total += 10
				else
					total += card_table_card_value(card)
			if(CARD_TABLE_BLACKJACK_KAZENGUN)
				if(rank == "A" || rank == "J" || rank == "Q" || rank == "K")
					total += 1
				else
					total += card_table_card_value(card)
			else
				total += card_table_card_value(card)
	if(hand.len == 2 && aces == 2 && (blackjack_variant == CARD_TABLE_BLACKJACK_AZURE || blackjack_variant == CARD_TABLE_BLACKJACK_GRENZELHOFT))
		return 21
	if(blackjack_variant != CARD_TABLE_BLACKJACK_AZURE)
		return total
	while(total > 21 && aces > 0)
		total -= 10
		aces--
	return total

/datum/card_table_session/proc/blackjack_card_nominal(list/card)
	if(!islist(card))
		return 0
	var/rank = "[card["rank"]]"
	switch(blackjack_variant)
		if(CARD_TABLE_BLACKJACK_GRON)
			if(rank == "A")
				return 1
			if(rank == "J" || rank == "Q" || rank == "K")
				return 11
		if(CARD_TABLE_BLACKJACK_VALORIA)
			if(rank == "A" || rank == "J" || rank == "Q" || rank == "K")
				return 10
		if(CARD_TABLE_BLACKJACK_GRENZELHOFT)
			if(rank == "A" || rank == "J" || rank == "Q" || rank == "K")
				return 10
		if(CARD_TABLE_BLACKJACK_KAZENGUN)
			if(rank == "A" || rank == "J" || rank == "Q" || rank == "K")
				return 1
		else
			if(rank == "A")
				return 11
			if(rank == "J" || rank == "Q" || rank == "K")
				return 10
	return card_table_card_value(card)

/datum/card_table_session/proc/blackjack_all_done()
	for(var/datum/card_table_player/player in players)
		if(player.left)
			continue
		if(!player.standing && !player.busted)
			return FALSE
	return TRUE

/datum/card_table_session/proc/blackjack_mark_action(datum/card_table_player/player, busted = FALSE)
	blackjack_action_seq++
	blackjack_action_player_index = player_index(player)
	blackjack_action_bust = busted ? TRUE : FALSE

/datum/card_table_session/proc/blackjack_process_spirit_turn(mark_actions = TRUE)
	if(stage != CARD_TABLE_STAGE_PLAYING || game_type != CARD_TABLE_GAME_BLACKJACK)
		return
	for(var/datum/card_table_player/player in players)
		if(!player.is_spirit || player.left || player.standing || player.busted)
			continue
		while(!player.standing && !player.busted)
			var/value = hand_value(player.hand)
			if(value >= 17)
				player.standing = TRUE
				break
			var/list/card = draw_one()
			if(!card)
				player.standing = TRUE
				break
			player.hand += list(card)
			if(hand_value(player.hand) > 21)
				player.busted = TRUE
				player.standing = TRUE
			if(mark_actions)
				blackjack_mark_action(player, player.busted)
		message = "[player.name] plays the dealer's hand."

/datum/card_table_session/proc/blackjack_finish()
	var/datum/card_table_player/table_dealer = dealer_player()
	var/dealer_value = 0
	if(table_dealer)
		dealer_value = hand_value(table_dealer.hand)
	for(var/datum/card_table_player/player in players)
		if(player.left)
			if(!player.result)
				player.result = "Left"
			continue
		var/value = hand_value(player.hand)
		if(player == table_dealer)
			player.result = (value > 21) ? "Bust" : "Dealer"
		else if(value > 21)
			player.result = "Bust"
		else if(dealer_value > 21 || value > dealer_value)
			player.result = "Win"
		else if(value == dealer_value)
			player.result = "Push"
		else
			player.result = "Lose"
	stage = CARD_TABLE_STAGE_FINISHED
	message = "Blackjack is over."

/datum/card_table_session/proc/blackjack_hit(mob/user)
	var/datum/card_table_player/player = player_for_user(user)
	if(stage != CARD_TABLE_STAGE_PLAYING || game_type != CARD_TABLE_GAME_BLACKJACK || !player || player.standing || player.busted)
		return FALSE
	var/list/card = draw_one()
	if(!card)
		return FALSE
	player.hand += list(card)
	if(hand_value(player.hand) > 21)
		player.busted = TRUE
		player.standing = TRUE
		message = "[player.name] busts."
	else
		message = "[player.name] takes a card."
	blackjack_mark_action(player, player.busted)
	blackjack_process_spirit_turn(FALSE)
	if(blackjack_all_done())
		blackjack_finish()
	return TRUE

/datum/card_table_session/proc/blackjack_stand(mob/user)
	var/datum/card_table_player/player = player_for_user(user)
	if(stage != CARD_TABLE_STAGE_PLAYING || game_type != CARD_TABLE_GAME_BLACKJACK || !player)
		return FALSE
	player.standing = TRUE
	message = "[player.name] stands."
	blackjack_process_spirit_turn()
	if(blackjack_all_done())
		blackjack_finish()
	return TRUE

/datum/card_table_session/proc/xylix_choose_deck_card(mob/user, card_index)
	var/datum/card_table_player/player = player_for_user(user)
	card_index = text2num("[card_index]")
	if(stage != CARD_TABLE_STAGE_PLAYING || !player || !xylix_can_choose_card(user))
		return FALSE
	if(game_type == CARD_TABLE_GAME_BLACKJACK && (player.standing || player.busted))
		return FALSE
	var/max_index = min(xylix_peek_count(user), deck.len)
	if(card_index < 1 || card_index > max_index)
		return FALSE
	var/list/card = deck[card_index]
	deck.Cut(card_index, card_index + 1)
	player.hand += list(card)
	if(game_type == CARD_TABLE_GAME_BLACKJACK && hand_value(player.hand) > 21)
		player.busted = TRUE
		player.standing = TRUE
	if(game_type == CARD_TABLE_GAME_BLACKJACK)
		blackjack_mark_action(player, player.busted)
	xylix_cheat_used += user.ckey
	xylix_check_exposure(user)
	to_chat(user, span_notice("Xylix nudges [card_table_card_label(card)] right where you need it."))
	if(game_type == CARD_TABLE_GAME_BLACKJACK)
		blackjack_process_spirit_turn(FALSE)
	if(game_type == CARD_TABLE_GAME_BLACKJACK && blackjack_all_done())
		blackjack_finish()
	return TRUE
