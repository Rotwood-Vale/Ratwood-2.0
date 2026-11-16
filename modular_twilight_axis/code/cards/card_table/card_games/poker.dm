/datum/card_table_session/proc/poker_discard(mob/user, card_index)
	var/datum/card_table_player/player = player_for_user(user)
	card_index = text2num("[card_index]")
	if(stage != CARD_TABLE_STAGE_PLAYING || game_type != CARD_TABLE_GAME_POKER || poker_variant != CARD_TABLE_POKER_DRAW || !player || player.ready || player.draws_used >= 1)
		return FALSE
	if(card_index < 1 || card_index > player.hand.len)
		return FALSE
	discard += list(player.hand[card_index])
	player.hand.Cut(card_index, card_index + 1)
	var/list/new_card = draw_one()
	if(new_card)
		player.hand += list(new_card)
	player.draws_used = 1
	message = "[player.name] swaps a card."
	return TRUE

/datum/card_table_session/proc/poker_ready(mob/user)
	var/datum/card_table_player/player = player_for_user(user)
	if(stage != CARD_TABLE_STAGE_PLAYING || game_type != CARD_TABLE_GAME_POKER || !player)
		return FALSE
	player.ready = TRUE
	message = "[player.name] is ready."
	for(var/datum/card_table_player/P in players)
		if(P.left)
			continue
		if(!P.ready)
			return TRUE
	poker_after_betting_round()
	return TRUE

/datum/card_table_session/proc/poker_player_in_hand(datum/card_table_player/player)
	return player_is_active(player) && !player.poker_folded

/datum/card_table_session/proc/poker_uses_community_cards()
	return poker_variant == CARD_TABLE_POKER_TEXAS || poker_variant == CARD_TABLE_POKER_OMAHA || poker_variant == CARD_TABLE_POKER_STUD

/datum/card_table_session/proc/poker_active_hands_count()
	var/count = 0
	for(var/datum/card_table_player/player in players)
		if(poker_player_in_hand(player))
			count++
	return count

/datum/card_table_session/proc/poker_next_betting_index(start_index)
	if(!players.len)
		return 0
	for(var/offset = 0, offset < players.len, offset++)
		var/check_index = start_index + offset
		while(check_index > players.len)
			check_index -= players.len
		var/datum/card_table_player/player = players[check_index]
		if(poker_player_in_hand(player) && !player.ready && !player.poker_all_in)
			return check_index
	return 0

/datum/card_table_session/proc/poker_reset_betting_round()
	poker_current_bet = 10
	for(var/datum/card_table_player/player in players)
		if(poker_player_in_hand(player) && !player.poker_all_in)
			player.ready = FALSE
			player.poker_bet = 0
		else if(poker_player_in_hand(player))
			player.ready = TRUE
	poker_turn_index = poker_next_betting_index(dealer_index + 1)
	poker_betting_round = community_cards.len
	return poker_turn_index

/datum/card_table_session/proc/poker_after_betting_round()
	if(poker_active_hands_count() <= 1)
		poker_finish()
		return
	if(!poker_uses_community_cards())
		poker_finish()
		return
	while(community_cards.len < 5)
		var/list/new_card = draw_one()
		if(!new_card)
			break
		community_cards += list(new_card)
		if(poker_reset_betting_round())
			message = "Community card [community_cards.len]/5 revealed. A new betting round begins."
			return
	poker_finish()

/datum/card_table_session/proc/poker_current_player() as /datum/card_table_player
	if(poker_turn_index < 1 || poker_turn_index > players.len)
		return null
	var/datum/card_table_player/player = players[poker_turn_index]
	if(!poker_player_in_hand(player) || player.ready || player.poker_all_in)
		return null
	return player

/datum/card_table_session/proc/poker_next_turn()
	if(poker_active_hands_count() <= 1)
		poker_finish()
		return
	for(var/offset = 1, offset <= players.len, offset++)
		var/check_index = poker_turn_index + offset
		while(check_index > players.len)
			check_index -= players.len
		var/datum/card_table_player/next_player = players[check_index]
		if(poker_player_in_hand(next_player) && !next_player.ready && !next_player.poker_all_in)
			poker_turn_index = check_index
			return
	poker_after_betting_round()

/datum/card_table_session/proc/poker_check(mob/user)
	var/datum/card_table_player/player = player_for_user(user)
	if(stage != CARD_TABLE_STAGE_PLAYING || game_type != CARD_TABLE_GAME_POKER || player != poker_current_player())
		return FALSE
	var/delta = max(0, poker_current_bet - player.poker_bet)
	poker_pot += delta
	player.poker_total_bet += delta
	player.poker_bet = poker_current_bet
	player.ready = TRUE
	message = poker_current_bet ? "[player.name] calls." : "[player.name] checks."
	poker_next_turn()
	return TRUE

/datum/card_table_session/proc/poker_bet(mob/user, amount)
	var/datum/card_table_player/player = player_for_user(user)
	if(stage != CARD_TABLE_STAGE_PLAYING || game_type != CARD_TABLE_GAME_POKER || player != poker_current_player())
		return FALSE
	amount = max(10, text2num("[amount]"))
	if(amount <= poker_current_bet)
		return poker_check(user)
	var/delta = max(0, amount - player.poker_bet)
	poker_current_bet = amount
	poker_pot += delta
	player.poker_total_bet += delta
	for(var/datum/card_table_player/other in players)
		if(poker_player_in_hand(other) && !other.poker_all_in)
			other.ready = FALSE
	player.poker_bet = poker_current_bet
	player.ready = TRUE
	message = "[player.name] bets [amount]."
	poker_next_turn()
	return TRUE

/datum/card_table_session/proc/poker_all_in(mob/user)
	var/datum/card_table_player/player = player_for_user(user)
	if(!player)
		return FALSE
	var/success = poker_bet(user, max(poker_current_bet + 100, player.poker_bet + 100))
	if(success)
		player.poker_all_in = TRUE
		message = "[player.name] goes all in."
	return success

/datum/card_table_session/proc/poker_fold(mob/user)
	var/datum/card_table_player/player = player_for_user(user)
	if(stage != CARD_TABLE_STAGE_PLAYING || game_type != CARD_TABLE_GAME_POKER || player != poker_current_player())
		return FALSE
	player.poker_folded = TRUE
	player.ready = TRUE
	player.result = "Fold"
	message = "[player.name] folds."
	poker_next_turn()
	return TRUE

/datum/card_table_session/proc/poker_finish_turn(mob/user, card_index)
	var/datum/card_table_player/player = player_for_user(user)
	card_index = text2num("[card_index]")
	if(stage != CARD_TABLE_STAGE_PLAYING || game_type != CARD_TABLE_GAME_POKER || !player || player.ready)
		return FALSE
	if(poker_variant == CARD_TABLE_POKER_DRAW && card_index >= 1 && card_index <= player.hand.len && player.draws_used < 1)
		discard += list(player.hand[card_index])
		player.hand.Cut(card_index, card_index + 1)
		var/list/new_card = draw_one()
		if(new_card)
			player.hand += list(new_card)
		player.draws_used = 1
	player.ready = TRUE
	message = "[player.name] ends their turn."
	for(var/datum/card_table_player/P in players)
		if(P.left)
			continue
		if(!P.ready)
			return TRUE
	poker_after_betting_round()
	return TRUE

/datum/card_table_session/proc/poker_score(list/hand)
	if(!hand)
		return 0
	var/list/counts = list()
	var/list/ranks = list()
	for(var/list/card in hand)
		var/rank = "[card["rank_value"]]"
		counts[rank]++
		ranks += card_table_card_rank_value(card)
	var/list/groups = list()
	for(var/rank_key in counts)
		groups += counts[rank_key]
	groups = sortList(groups)
	var/high = 0
	for(var/value in ranks)
		high = max(high, value)
	var/category = 1
	if(4 in groups)
		category = 7
	else if((3 in groups) && (2 in groups))
		category = 6
	else if(3 in groups)
		category = 4
	else
		var/pairs = 0
		for(var/group_count in groups)
			if(group_count == 2)
				pairs++
		if(pairs >= 2)
			category = 3
		else if(pairs == 1)
			category = 2
	return category * 100 + high

/datum/card_table_session/proc/poker_score_for_player(datum/card_table_player/player)
	if(!player)
		return 0
	var/list/scored_hand = list()
	for(var/list/card in player.hand)
		scored_hand += list(card)
	if(poker_uses_community_cards())
		for(var/list/table_card in community_cards)
			scored_hand += list(table_card)
	return poker_score(scored_hand)

/datum/card_table_session/proc/poker_finish()
	var/best_score = -1
	var/datum/card_table_player/winner = null
	for(var/datum/card_table_player/player in players)
		if(player.left)
			continue
		var/score = poker_score_for_player(player)
		if(score > best_score)
			best_score = score
			winner = player
	for(var/datum/card_table_player/P in players)
		if(P.left)
			if(!P.result)
				P.result = "Left"
		else if(P.poker_folded)
			P.result = "Fold"
		else
			P.result = (P == winner) ? "Winner" : "Lost"
	stage = CARD_TABLE_STAGE_FINISHED
	var/winner_name = winner ? winner.name : "Nobody"
	message = "[winner_name] wins the hand."
