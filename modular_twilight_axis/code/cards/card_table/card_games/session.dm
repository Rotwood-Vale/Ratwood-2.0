/datum/card_table_session
	var/obj/item/toy/cards/deck/owner
	var/game_type = CARD_TABLE_GAME_NONE
	var/stage = CARD_TABLE_STAGE_LOBBY
	var/list/players = list()
	var/list/observers = list()
	var/list/deck = list()
	var/list/discard = list()
	var/list/dealer_hand = list()
	var/list/community_cards = list()
	var/list/xylix_seen_cards = list()
	var/list/xylix_cheat_used = list()
	var/message = "Choose a game and take your seats."
	var/poker_variant = CARD_TABLE_POKER_DRAW
	var/blackjack_variant = CARD_TABLE_BLACKJACK_AZURE
	var/dealer_rotates = TRUE
	var/dealer_index = 0
	var/dealer_rounds = 0
	var/poker_turn_index = 0
	var/poker_current_bet = 10
	var/poker_pot = 0
	var/poker_betting_round = 0
	var/blackjack_action_seq = 0
	var/blackjack_action_player_index = 0
	var/blackjack_action_bust = FALSE

/datum/card_table_session/New(obj/item/toy/cards/deck/new_owner)
	owner = new_owner

/datum/card_table_session/Destroy()
	owner = null
	if(players)
		for(var/datum/card_table_player/P in players)
			qdel(P)
	players = null
	observers = null
	deck = null
	discard = null
	dealer_hand = null
	community_cards = null
	xylix_seen_cards = null
	xylix_cheat_used = null
	return ..()

/datum/card_table_session/proc/reset_to_lobby()
	stage = CARD_TABLE_STAGE_LOBBY
	for(var/i = players.len, i >= 1, i--)
		var/datum/card_table_player/leaver = players[i]
		if(leaver.left || leaver.is_spirit)
			players.Cut(i, i + 1)
			qdel(leaver)
	deck = list()
	discard = list()
	dealer_hand = list()
	community_cards = list()
	xylix_seen_cards = list()
	xylix_cheat_used = list()
	poker_turn_index = 0
	poker_current_bet = 10
	poker_pot = 0
	poker_betting_round = 0
	blackjack_action_seq = 0
	blackjack_action_player_index = 0
	blackjack_action_bust = FALSE
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
	if(dealer_index > players.len)
		dealer_index = players.len ? 1 : 0
	message = "The round has been reset. Players remain at the table."

/datum/card_table_session/proc/game_label()
	switch(game_type)
		if(CARD_TABLE_GAME_BLACKJACK)
			return "Blackjack"
		if(CARD_TABLE_GAME_POKER)
			return "Poker"
	return "None selected"

/datum/card_table_session/proc/poker_variant_label()
	switch(poker_variant)
		if(CARD_TABLE_POKER_TEXAS)
			return "Raneshi"
		if(CARD_TABLE_POKER_OMAHA)
			return "Valorian"
		if(CARD_TABLE_POKER_STUD)
			return "Giza"
	return "Rockhillian"

/datum/card_table_session/proc/blackjack_variant_label()
	switch(blackjack_variant)
		if(CARD_TABLE_BLACKJACK_GRON)
			return "Gronnic"
		if(CARD_TABLE_BLACKJACK_VALORIA)
			return "Valorian"
		if(CARD_TABLE_BLACKJACK_GRENZELHOFT)
			return "Grenzelhoftian"
		if(CARD_TABLE_BLACKJACK_KAZENGUN)
			return "Kazengunite"
	return "Rockhillian"

/datum/card_table_session/proc/dealer_rotation_label()
	return dealer_rotates ? "Rotating dealer" : "Fixed dealer"

/datum/card_table_session/proc/max_players()
	return max_players_for_game(game_type)

/datum/card_table_session/proc/max_players_for_game(new_game)
	switch(new_game)
		if(CARD_TABLE_GAME_BLACKJACK)
			return 5
		if(CARD_TABLE_GAME_POKER)
			return 6
	return 6

/datum/card_table_session/proc/min_players()
	switch(game_type)
		if(CARD_TABLE_GAME_BLACKJACK, CARD_TABLE_GAME_POKER)
			return 1
	return 0

/datum/card_table_session/proc/can_pack()
	return !players.len && !observers.len

/datum/card_table_session/proc/player_is_active(datum/card_table_player/player)
	return player && !player.left && player.result != "Out"

/datum/card_table_session/proc/active_players_count()
	var/count = 0
	for(var/datum/card_table_player/player in players)
		if(player_is_active(player))
			count++
	return count

/datum/card_table_session/proc/active_real_players_count()
	var/count = 0
	for(var/datum/card_table_player/player in players)
		if(player_is_active(player) && !player.is_spirit)
			count++
	return count

/datum/card_table_session/proc/has_spirit_opponent()
	for(var/datum/card_table_player/player in players)
		if(player.is_spirit && !player.left)
			return TRUE
	return FALSE

/datum/card_table_session/proc/player_for_user(mob/user)
	if(!user || !user.ckey)
		return null
	for(var/datum/card_table_player/player in players)
		if(!player.left && player.ckey == user.ckey)
			return player
	return null

/datum/card_table_session/proc/player_index(datum/card_table_player/target)
	if(!target)
		return 0
	for(var/i = 1, i <= players.len, i++)
		if(players[i] == target)
			return i
	return 0

/datum/card_table_session/proc/is_observer(mob/user)
	if(!user || !user.ckey)
		return FALSE
	return (user.ckey in observers)
