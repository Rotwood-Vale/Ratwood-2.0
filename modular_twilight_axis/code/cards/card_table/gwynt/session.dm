GLOBAL_VAR_INIT(ccg_music_channel, null)

/// Arlette's soundtrack gets its own sound channel, reserved from SSsounds the first time it's needed.
/proc/ccg_music_channel()
	if(!GLOB.ccg_music_channel)
		GLOB.ccg_music_channel = SSsounds.reserve_sound_channel_datumless()
	return GLOB.ccg_music_channel

#define CHANNEL_GWYNT_MUSIC ccg_music_channel()
#define CCG_SIDE_ONE "one"
#define CCG_SIDE_TWO "two"
#define CCG_HAND_SIZE 12
#define CCG_MULLIGAN_COUNT 2
#define CCG_SOUND_MULLIGAN 'sound/items/cardshuffle.ogg'
#define CCG_SOUND_ROUND_START 'sound/items/blackeye_warn.ogg'
#define CCG_SOUND_CARD_PLAY 'sound/items/book_page.ogg'
#define CCG_SOUND_WEATHER 'sound/items/gem.ogg'
#define CCG_SOUND_SPECIAL 'sound/items/firelight.ogg'
#define CCG_SOUND_HORN 'modular_twilight_axis/sound/gwynt/gwynt_horn.wav'
#define CCG_SOUND_GAME_END 'modular_twilight_axis/sound/gwynt/gwynt_game_end.wav'
#define CCG_SOUNDTRACK_VOLUME 50
#define CCG_SOUNDTRACK_DEFAULT 'modular_twilight_axis/sound/gwynt/gwynt_slow_tension.ogg'
#define CCG_SOUNDTRACK_HARD_CARDS 'modular_twilight_axis/sound/gwynt/gwynt_hard_cards.ogg'
#define CCG_SOUNDTRACK_BANDIT_CONFRONTATION 'modular_twilight_axis/sound/gwynt/gwynt_bandit_confrontation.ogg'
#define CCG_SOUNDTRACK_VAMPIRE_NEGOTIATIONS 'modular_twilight_axis/sound/gwynt/gwynt_vampire_negotiations.ogg'
#define CCG_SOUNDTRACK_LAST_SIEGE 'modular_twilight_axis/sound/gwynt/gwynt_last_siege.ogg'
#define CCG_SOUNDTRACK_DEFAULT_LENGTH 1950
#define CCG_SOUNDTRACK_HARD_CARDS_LENGTH 1645
#define CCG_SOUNDTRACK_BANDIT_CONFRONTATION_LENGTH 1498
#define CCG_SOUNDTRACK_VAMPIRE_NEGOTIATIONS_LENGTH 1433
#define CCG_SOUNDTRACK_LAST_SIEGE_LENGTH 1296

/datum/ccg_played_card
	var/card_id
	var/owner_side
	var/play_id
	var/current_power = 0

/datum/ccg_played_card/New(new_card_id, new_owner_side)
	card_id = new_card_id
	owner_side = new_owner_side
	var/datum/ccg_card/card = ccg_card(card_id)
	current_power = card ? card.power : 0

/datum/ccg_match
	var/obj/item/ccg_deck/owner
	var/obj/item/ccg_deck/challenger
	var/list/player_ckeys = list()
	var/list/player_names = list()
	var/list/spectator_ckeys = list()
	var/list/decks = list()
	var/list/hands = list()
	var/list/discarded = list()
	var/list/board = list()
	var/list/round_wins = list()
	var/list/passed = list()
	var/list/weather = list()
	var/list/weather_board = list()
	var/list/row_effects = list()
	var/list/combo_morale = list()
	var/list/mulligans_left = list()
	var/list/mulligan_ready = list()
	var/list/faction_ids = list()
	var/list/leader_ids = list()
	var/list/leader_used = list()
	var/list/carryover_cards = list()
	var/list/soundtrack_timers = list()
	var/list/soundtrack_files = list()
	var/list/soundtrack_titles = list()
	var/list/soundtrack_repeats = list()
	var/turn = CCG_SIDE_ONE
	var/round_number = 1
	var/in_mulligan = TRUE
	var/next_play_id = 1
	var/turns_played = 0
	var/result_text
	var/last_message

/datum/ccg_match/New(obj/item/ccg_deck/new_owner, mob/p1, obj/item/ccg_deck/d1, mob/p2, obj/item/ccg_deck/d2)
	owner = new_owner
	challenger = d2
	player_ckeys[CCG_SIDE_ONE] = p1.ckey
	player_ckeys[CCG_SIDE_TWO] = p2.ckey
	player_names[CCG_SIDE_ONE] = p1.real_name ? p1.real_name : p1.name
	player_names[CCG_SIDE_TWO] = p2.real_name ? p2.real_name : p2.name
	decks[CCG_SIDE_ONE] = shuffle(d1.card_ids.Copy())
	decks[CCG_SIDE_TWO] = shuffle(d2.card_ids.Copy())
	hands[CCG_SIDE_ONE] = list()
	hands[CCG_SIDE_TWO] = list()
	discarded[CCG_SIDE_ONE] = list()
	discarded[CCG_SIDE_TWO] = list()
	round_wins[CCG_SIDE_ONE] = 0
	round_wins[CCG_SIDE_TWO] = 0
	mulligans_left[CCG_SIDE_ONE] = CCG_MULLIGAN_COUNT
	mulligans_left[CCG_SIDE_TWO] = CCG_MULLIGAN_COUNT
	mulligan_ready[CCG_SIDE_ONE] = FALSE
	mulligan_ready[CCG_SIDE_TWO] = FALSE
	faction_ids[CCG_SIDE_ONE] = d1.faction_id
	faction_ids[CCG_SIDE_TWO] = d2.faction_id
	if(faction_has_effect(CCG_SIDE_ONE, CCG_FACTION_EFFECT_EXTRA_MULLIGAN))
		mulligans_left[CCG_SIDE_ONE]++
	if(faction_has_effect(CCG_SIDE_TWO, CCG_FACTION_EFFECT_EXTRA_MULLIGAN))
		mulligans_left[CCG_SIDE_TWO]++
	leader_ids[CCG_SIDE_ONE] = d1.leader_id
	leader_ids[CCG_SIDE_TWO] = d2.leader_id
	leader_used[CCG_SIDE_ONE] = FALSE
	leader_used[CCG_SIDE_TWO] = FALSE
	carryover_cards[CCG_SIDE_ONE] = list()
	carryover_cards[CCG_SIDE_TWO] = list()
	select_soundtrack_for(p1, p1, p2)
	select_soundtrack_for(p2, p1, p2)
	start_round(TRUE)

/datum/ccg_match/Destroy()
	stop_soundtracks()
	if(owner)
		if(owner.match == src)
			owner.match = null
		if(owner.match_host)
			owner.match_host = null
	if(challenger)
		if(challenger.match == src)
			challenger.match = null
		if(challenger.match_host == owner)
			challenger.match_host = null
	owner = null
	challenger = null
	player_ckeys = null
	player_names = null
	spectator_ckeys = null
	decks = null
	hands = null
	discarded = null
	board = null
	round_wins = null
	passed = null
	weather = null
	weather_board = null
	row_effects = null
	combo_morale = null
	mulligans_left = null
	mulligan_ready = null
	faction_ids = null
	leader_ids = null
	leader_used = null
	carryover_cards = null
	soundtrack_timers = null
	soundtrack_files = null
	soundtrack_titles = null
	soundtrack_repeats = null
	return ..()

/datum/ccg_match/proc/select_soundtrack_for(mob/listener, mob/player_one, mob/player_two)
	if(!listener?.ckey)
		return
	var/target_ckey = listener.ckey
	soundtrack_files[target_ckey] = ccg_combat_soundtrack_file(listener)
	soundtrack_titles[target_ckey] = ccg_combat_soundtrack_title(listener)
	soundtrack_repeats[target_ckey] = TRUE
	if(!prob(10))
		return
	if(ccg_soundtrack_has_antag(player_one, /datum/antagonist/lich) || ccg_soundtrack_has_antag(player_two, /datum/antagonist/lich))
		soundtrack_files[target_ckey] = CCG_SOUNDTRACK_LAST_SIEGE
		soundtrack_titles[target_ckey] = "Last Siege"
		soundtrack_repeats[target_ckey] = FALSE
		return
	if(ccg_soundtrack_is_open_vampire_lord(player_one) || ccg_soundtrack_is_open_vampire_lord(player_two))
		soundtrack_files[target_ckey] = CCG_SOUNDTRACK_VAMPIRE_NEGOTIATIONS
		soundtrack_titles[target_ckey] = "Vampire Negotiations"
		soundtrack_repeats[target_ckey] = FALSE
		return
	if(ccg_soundtrack_has_antag(player_one, /datum/antagonist/bandit) || ccg_soundtrack_has_antag(player_two, /datum/antagonist/bandit))
		soundtrack_files[target_ckey] = CCG_SOUNDTRACK_BANDIT_CONFRONTATION
		soundtrack_titles[target_ckey] = "Bandit Confrontation"
		soundtrack_repeats[target_ckey] = FALSE
		return

/datum/ccg_match/proc/soundtrack_title_for(mob/user)
	if(user?.ckey && soundtrack_titles[user.ckey])
		return soundtrack_titles[user.ckey]
	return "Combat Music"

/proc/ccg_soundtrack_has_antag(mob/player, antag_path)
	return !!player?.mind?.has_antag_datum(antag_path)

/proc/ccg_soundtrack_is_open_vampire_lord(mob/player)
	if(!player?.mind?.has_antag_datum(/datum/antagonist/vampire/lord))
		return FALSE
	var/datum/component/vampire_disguise/disguise_comp = player.GetComponent(/datum/component/vampire_disguise)
	if(disguise_comp?.disguised)
		return FALSE
	return TRUE

/datum/ccg_match/proc/update_deck_uis()
	if(owner)
		SStgui.update_uis(owner)
	if(challenger)
		SStgui.update_uis(challenger)
	for(var/spectator_ckey in spectator_ckeys)
		var/mob/spectator = ccg_find_mob_by_ckey(spectator_ckey)
		if(spectator)
			SStgui.update_user_uis(spectator)

/datum/ccg_match/proc/is_participant(mob/user)
	if(!user?.ckey)
		return FALSE
	return user.ckey == player_ckeys[CCG_SIDE_ONE] || user.ckey == player_ckeys[CCG_SIDE_TWO]

/datum/ccg_match/proc/add_spectator(mob/user)
	if(!user?.ckey || is_participant(user))
		return FALSE
	spectator_ckeys |= user.ckey
	return TRUE

/datum/ccg_match/proc/remove_spectator(mob/user)
	if(!user?.ckey || !(user.ckey in spectator_ckeys))
		return FALSE
	spectator_ckeys -= user.ckey
	return TRUE

/datum/ccg_match/proc/play_cue(sound_file)
	if(!sound_file)
		return
	var/turf/source = get_turf(owner)
	if(!source)
		source = get_turf(challenger)
	if(source)
		playsound(source, sound_file, 50, FALSE)

/datum/ccg_match/proc/stop_soundtrack_for(mob/user)
	stop_soundtrack_for_ckey(user?.ckey)

/datum/ccg_match/proc/stop_soundtrack_for_ckey(target_ckey)
	if(target_ckey && soundtrack_timers[target_ckey])
		deltimer(soundtrack_timers[target_ckey])
		soundtrack_timers -= target_ckey
	var/mob/player = ccg_find_mob_by_ckey(target_ckey)
	if(player)
		player.stop_sound_channel(CHANNEL_GWYNT_MUSIC)

/datum/ccg_match/proc/stop_soundtracks()
	stop_soundtrack_for_ckey(player_ckeys[CCG_SIDE_ONE])
	stop_soundtrack_for_ckey(player_ckeys[CCG_SIDE_TWO])
	for(var/spectator_ckey in spectator_ckeys)
		stop_soundtrack_for_ckey(spectator_ckey)

/datum/ccg_match/proc/sync_soundtrack_for(mob/user)
	if(!user?.client?.prefs)
		return
	if(!user.client.prefs.ccg_soundtrack_enabled || result_text)
		stop_soundtrack_for(user)
		return
	if(!soundtrack_files[user.ckey])
		select_soundtrack_for(user, ccg_find_mob_by_ckey(player_ckeys[CCG_SIDE_ONE]), ccg_find_mob_by_ckey(player_ckeys[CCG_SIDE_TWO]))
	if(!soundtrack_files[user.ckey])
		return
	if(ccg_is_soundtrack_playing(user))
		return
	stop_soundtrack_for(user)
	var/soundtrack_file = soundtrack_files[user.ckey]
	var/repeat_track = soundtrack_repeats[user.ckey] ? TRUE : FALSE
	var/sound/track = sound(soundtrack_file, repeat = repeat_track, wait = 0, channel = CHANNEL_GWYNT_MUSIC, volume = ccg_soundtrack_volume(user))
	SEND_SOUND(user, track)
	if(!repeat_track)
		soundtrack_timers[user.ckey] = addtimer(CALLBACK(src, PROC_REF(restart_soundtrack_for_ckey), user.ckey), ccg_soundtrack_length(soundtrack_file), TIMER_STOPPABLE)

/datum/ccg_match/proc/restart_soundtrack_for_ckey(target_ckey)
	if(soundtrack_timers[target_ckey])
		soundtrack_timers -= target_ckey
	if(result_text)
		return
	var/mob/player = ccg_find_mob_by_ckey(target_ckey)
	if(player?.client?.prefs?.ccg_soundtrack_enabled)
		player.stop_sound_channel(CHANNEL_GWYNT_MUSIC)
		select_soundtrack_for(player, ccg_find_mob_by_ckey(player_ckeys[CCG_SIDE_ONE]), ccg_find_mob_by_ckey(player_ckeys[CCG_SIDE_TWO]))
		sync_soundtrack_for(player)

/proc/ccg_soundtrack_length(soundtrack_file)
	switch(soundtrack_file)
		if(CCG_SOUNDTRACK_HARD_CARDS)
			return CCG_SOUNDTRACK_HARD_CARDS_LENGTH
		if(CCG_SOUNDTRACK_BANDIT_CONFRONTATION)
			return CCG_SOUNDTRACK_BANDIT_CONFRONTATION_LENGTH
		if(CCG_SOUNDTRACK_VAMPIRE_NEGOTIATIONS)
			return CCG_SOUNDTRACK_VAMPIRE_NEGOTIATIONS_LENGTH
		if(CCG_SOUNDTRACK_LAST_SIEGE)
			return CCG_SOUNDTRACK_LAST_SIEGE_LENGTH
	return CCG_SOUNDTRACK_DEFAULT_LENGTH

/proc/ccg_is_soundtrack_playing(mob/user)
	if(!user?.client)
		return FALSE
	for(var/sound/S in user.client.SoundQuery())
		if(S.channel == CHANNEL_GWYNT_MUSIC)
			return TRUE
	return FALSE

/proc/ccg_soundtrack_volume(mob/user)
	if(user?.client?.prefs)
		return user.client.prefs.musicvol
	return CCG_SOUNDTRACK_VOLUME

/proc/ccg_combat_soundtrack_file(mob/user)
	var/soundtrack_file
	if(isliving(user))
		var/mob/living/L = user
		soundtrack_file = ccg_pick_soundtrack_file(L.cmode_music_override)
	if(!soundtrack_file)
		soundtrack_file = ccg_pick_soundtrack_file(user?.cmode_music)
	if(!soundtrack_file)
		soundtrack_file = ccg_pick_soundtrack_file(user?.client?.prefs?.combat_music?.musicpath)
	return soundtrack_file || CCG_SOUNDTRACK_DEFAULT

/proc/ccg_combat_soundtrack_title(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(length(L.cmode_music_override) && L.cmode_music_override_name)
			return L.cmode_music_override_name
	if(user?.client?.prefs?.combat_music?.name && length(user.client.prefs.combat_music.musicpath))
		return user.client.prefs.combat_music.name
	return "Combat Music"

/proc/ccg_pick_soundtrack_file(soundtrack_source)
	if(islist(soundtrack_source))
		var/list/soundtrack_list = soundtrack_source
		if(length(soundtrack_list))
			return pick(soundtrack_list)
	if(isfile(soundtrack_source) || istext(soundtrack_source))
		return soundtrack_source
	return null

/datum/ccg_match/proc/start_round(first_round = FALSE)
	board = list(
		CCG_SIDE_ONE = list(CCG_ROW_INFANTRY = list(), CCG_ROW_ARCHERS = list(), CCG_ROW_SIEGE = list()),
		CCG_SIDE_TWO = list(CCG_ROW_INFANTRY = list(), CCG_ROW_ARCHERS = list(), CCG_ROW_SIEGE = list())
	)
	passed[CCG_SIDE_ONE] = FALSE
	passed[CCG_SIDE_TWO] = FALSE
	weather = list()
	weather_board = list()
	row_effects = list(
		CCG_SIDE_ONE = list(CCG_ROW_INFANTRY = list(), CCG_ROW_ARCHERS = list(), CCG_ROW_SIEGE = list()),
		CCG_SIDE_TWO = list(CCG_ROW_INFANTRY = list(), CCG_ROW_ARCHERS = list(), CCG_ROW_SIEGE = list())
	)
	combo_morale = list(
		CCG_SIDE_ONE = list(CCG_ROW_INFANTRY = 0, CCG_ROW_ARCHERS = 0, CCG_ROW_SIEGE = 0),
		CCG_SIDE_TWO = list(CCG_ROW_INFANTRY = 0, CCG_ROW_ARCHERS = 0, CCG_ROW_SIEGE = 0)
	)
	if(first_round)
		draw_cards(CCG_SIDE_ONE, CCG_HAND_SIZE)
		draw_cards(CCG_SIDE_TWO, CCG_HAND_SIZE)
		for(var/side in list(CCG_SIDE_ONE, CCG_SIDE_TWO))
			if(faction_has_effect(side, CCG_FACTION_EFFECT_OPENING_DRAW))
				draw_cards(side, 1)
		in_mulligan = TRUE
		last_message = "Choose cards to redraw."
	else
		in_mulligan = FALSE
		last_message = "Round [round_number] begins."
		play_cue(CCG_SOUND_ROUND_START)
		for(var/side in list(CCG_SIDE_ONE, CCG_SIDE_TWO))
			for(var/card_id in carryover_cards[side])
				var/datum/ccg_card/card = ccg_card(card_id)
				if(card && valid_unit_row(card.row))
					add_played_card(side, card.row, card_id, side)
			carryover_cards[side] = list()
			if(faction_has_effect(side, CCG_FACTION_EFFECT_REVIVE_UNIT))
				revive_random_discard(side)
	if(first_round)
		turn = prob(50) ? CCG_SIDE_ONE : CCG_SIDE_TWO
	else
		turn = (round_number % 2) ? CCG_SIDE_ONE : CCG_SIDE_TWO

/datum/ccg_match/proc/draw_to_hand_size(side)
	var/list/hand = hands[side]
	var/needed = CCG_HAND_SIZE - length(hand)
	if(needed > 0)
		draw_cards(side, needed)

/datum/ccg_match/proc/draw_cards(side, amount)
	var/list/deck = decks[side]
	var/list/hand = hands[side]
	for(var/i = 1, i <= amount, i++)
		if(!length(deck))
			return
		hand += deck[1]
		deck.Cut(1, 2)

/datum/ccg_match/proc/mulligan_card(mob/user, card_id, obj/item/ccg_deck/deck_context)
	var/side = side_for_user(user, deck_context)
	if(!side || !in_mulligan || mulligan_ready[side] || mulligans_left[side] <= 0)
		return FALSE
	var/list/hand = hands[side]
	var/card_index = hand.Find(card_id)
	if(!card_index)
		return FALSE
	var/list/deck = decks[side]
	if(!length(deck))
		return FALSE
	hand.Cut(card_index, card_index + 1)
	deck += card_id
	decks[side] = shuffle(deck)
	draw_cards(side, 1)
	mulligans_left[side]--
	last_message = "[player_names[side]] redraws a card."
	play_cue(CCG_SOUND_MULLIGAN)
	return TRUE

/datum/ccg_match/proc/ready_mulligan(mob/user, obj/item/ccg_deck/deck_context)
	var/side = side_for_user(user, deck_context)
	if(!side || !in_mulligan)
		return FALSE
	mulligan_ready[side] = TRUE
	last_message = "[player_names[side]] is ready."
	if(mulligan_ready[CCG_SIDE_ONE] && mulligan_ready[CCG_SIDE_TWO])
		in_mulligan = FALSE
		last_message = "Round [round_number] begins."
		play_cue(CCG_SOUND_ROUND_START)
	return TRUE

/datum/ccg_match/proc/side_for_user(mob/user, obj/item/ccg_deck/deck_context)
	if(!user?.ckey)
		return null
	if(player_ckeys[CCG_SIDE_ONE] == player_ckeys[CCG_SIDE_TWO] && deck_context)
		if(deck_context == owner)
			return CCG_SIDE_ONE
		if(deck_context == challenger)
			return CCG_SIDE_TWO
	if(user.ckey == player_ckeys[CCG_SIDE_ONE])
		return CCG_SIDE_ONE
	if(user.ckey == player_ckeys[CCG_SIDE_TWO])
		return CCG_SIDE_TWO
	return null

/datum/ccg_match/proc/opposite(side)
	return side == CCG_SIDE_ONE ? CCG_SIDE_TWO : CCG_SIDE_ONE

/datum/ccg_match/proc/faction_effect(side)
	var/datum/ccg_faction/faction = ccg_faction(faction_ids[side])
	return faction?.effect

/datum/ccg_match/proc/faction_has_effect(side, effect)
	return faction_effect(side) == effect

/datum/ccg_match/proc/valid_unit_row(row)
	return row in list(CCG_ROW_INFANTRY, CCG_ROW_ARCHERS, CCG_ROW_SIEGE)

/datum/ccg_match/proc/add_played_card(side, row, card_id, owner_side)
	var/datum/ccg_played_card/played = new /datum/ccg_played_card(card_id, owner_side)
	played.play_id = next_play_id
	next_play_id++
	board[side][row] += played
	return played

/datum/ccg_match/proc/add_row_effect(side, row, card_id, owner_side)
	var/datum/ccg_played_card/played = new /datum/ccg_played_card(card_id, owner_side)
	played.play_id = next_play_id
	next_play_id++
	row_effects[side][row] += played
	return played

/datum/ccg_match/proc/find_played_card(side, row, play_id)
	if(!valid_unit_row(row))
		return null
	var/id_num = text2num("[play_id]")
	for(var/datum/ccg_played_card/played in board[side][row])
		if(played.play_id == id_num)
			return played
	return null

/datum/ccg_match/proc/is_unit_card(datum/ccg_card/card)
	return card && valid_unit_row(card.row) && !is_special_action_card(card)

/datum/ccg_match/proc/play_card(mob/user, card_id, obj/item/ccg_deck/deck_context, list/params)
	var/side = side_for_user(user, deck_context)
	if(!side || in_mulligan || side != turn || passed[side] || result_text)
		return FALSE
	var/list/hand = hands[side]
	if(!(card_id in hand))
		return FALSE
	var/datum/ccg_card/card = ccg_card(card_id)
	if(!card)
		return FALSE
	var/card_index = hand.Find(card_id)
	if(!card_index)
		return FALSE
	hand.Cut(card_index, card_index + 1)
	if(is_special_action_card(card))
		if(!apply_special_action_card(card, side, params))
			hand.Insert(card_index, card_id)
			return FALSE
		if(card.effect == CCG_EFFECT_HORN)
			play_cue(CCG_SOUND_HORN)
		else
			play_cue(CCG_SOUND_SPECIAL)
	else if(is_weather_card(card))
		apply_weather_card(card, side)
		play_cue(CCG_SOUND_WEATHER)
	else
		var/play_side = side
		var/play_row = card.row
		if(card.effect == CCG_EFFECT_AGILE)
			var/requested_row = params?["row"]
			if(!valid_unit_row(requested_row))
				hand.Insert(card_index, card_id)
				return FALSE
			play_row = requested_row
		if(card.effect == CCG_EFFECT_SPY)
			play_side = opposite(side)
			draw_cards(side, 2)
		add_played_card(play_side, play_row, card_id, side)
		if(card.effect == CCG_EFFECT_MUSTER)
			muster_copies(card, side, play_side, play_row)
		if(card.effect == CCG_EFFECT_MEDIC)
			if(!revive_discard(side, params?["revive"]))
				hand.Insert(card_index, card_id)
				remove_last_played(play_side, play_row)
				return FALSE
		apply_card_effect(card, side, play_side)
		if(apply_combo_effect(card, side, play_side))
			last_message = "[player_names[side]] plays [card.name]. A combo triggers."
		else
			last_message = "[player_names[side]] plays [card.name]."
		play_cue(CCG_SOUND_CARD_PLAY)
	recalculate_board()
	if(is_weather_card(card))
		last_message = "[player_names[side]] plays [card.name]."
	turns_played++
	advance_turn()
	return TRUE

/datum/ccg_match/proc/pass(mob/user, obj/item/ccg_deck/deck_context)
	var/side = side_for_user(user, deck_context)
	if(!side || in_mulligan || side != turn || result_text)
		return FALSE
	passed[side] = TRUE
	last_message = "[player_names[side]] passes."
	turns_played++
	advance_turn()
	return TRUE

/datum/ccg_match/proc/use_leader(mob/user, obj/item/ccg_deck/deck_context)
	var/side = side_for_user(user, deck_context)
	if(!side || in_mulligan || side != turn || passed[side] || leader_used[side] || result_text)
		return FALSE
	var/datum/ccg_leader/leader = ccg_leader(leader_ids[side])
	if(!leader)
		return FALSE
	leader_used[side] = TRUE
	if(leader.effect == CCG_EFFECT_CLEAR_WEATHER)
		for(var/datum/ccg_played_card/played in weather_board)
			discarded[played.owner_side] += played.card_id
		weather_board = list()
		weather = list()
		play_cue(CCG_SOUND_WEATHER)
	else if(leader.effect == CCG_EFFECT_HORN)
		if(valid_unit_row(leader.target_row) && !row_has_effect(side, leader.target_row, CCG_EFFECT_HORN))
			add_row_effect(side, leader.target_row, "base_horn_infantry", side)
		play_cue(CCG_SOUND_HORN)
	else if(leader.effect == CCG_EFFECT_SCORCH_GLOBAL)
		recalculate_board()
		scorch_strongest_global()
		play_cue(CCG_SOUND_SPECIAL)
	else if(leader.effect == CCG_LEADER_EFFECT_DRAW)
		draw_cards(side, 1)
		play_cue(CCG_SOUND_SPECIAL)
	last_message = "[player_names[side]] uses leader: [leader.name]."
	recalculate_board()
	turns_played++
	advance_turn()
	return TRUE

/datum/ccg_match/proc/advance_turn()
	if(passed[CCG_SIDE_ONE] && passed[CCG_SIDE_TWO])
		end_round()
		return
	var/other = opposite(turn)
	if(!passed[other])
		turn = other

/datum/ccg_match/proc/apply_weather_card(datum/ccg_card/card, side)
	if(card.effect == CCG_EFFECT_CLEAR_WEATHER)
		clear_weather()
		discarded[side] += card.id
	else if(card.effect == CCG_EFFECT_FROST)
		weather |= CCG_ROW_INFANTRY
		weather_board += new /datum/ccg_played_card(card.id, side)
	else if(card.effect == CCG_EFFECT_FOG)
		weather |= CCG_ROW_ARCHERS
		weather_board += new /datum/ccg_played_card(card.id, side)
	else if(card.effect == CCG_EFFECT_RAIN)
		weather |= CCG_ROW_SIEGE
		weather_board += new /datum/ccg_played_card(card.id, side)

/datum/ccg_match/proc/clear_weather()
	for(var/datum/ccg_played_card/played in weather_board)
		discarded[played.owner_side] += played.card_id
	weather_board = list()
	weather = list()

/datum/ccg_match/proc/is_weather_card(datum/ccg_card/card)
	return card && card.row == CCG_ROW_WEATHER && (card.effect in list(CCG_EFFECT_CLEAR_WEATHER, CCG_EFFECT_FROST, CCG_EFFECT_FOG, CCG_EFFECT_RAIN))

/datum/ccg_match/proc/is_special_action_card(datum/ccg_card/card)
	return card && (card.row == CCG_ROW_WEATHER || card.power <= 0) && (card.effect in list(CCG_EFFECT_DECOY, CCG_EFFECT_HORN, CCG_EFFECT_SCORCH_GLOBAL, CCG_EFFECT_MARDROEME))

/datum/ccg_match/proc/apply_special_action_card(datum/ccg_card/card, side, list/params)
	if(card.effect == CCG_EFFECT_DECOY)
		var/target_row = params?["row"]
		var/target_id = params?["target"]
		if(!return_own_unit_to_hand(side, target_row, target_id))
			return FALSE
		discarded[side] += card.id
		last_message = "[player_names[side]] plays [card.name]."
		return TRUE
	if(card.effect == CCG_EFFECT_SCORCH_GLOBAL)
		recalculate_board()
		scorch_strongest_global()
		discarded[side] += card.id
		last_message = "[player_names[side]] plays [card.name]."
		return TRUE
	if(card.effect == CCG_EFFECT_HORN || card.effect == CCG_EFFECT_MARDROEME)
		var/target_row = card.target_row
		if(!target_row)
			target_row = params?["row"]
		if(!valid_unit_row(target_row))
			return FALSE
		if(card.effect == CCG_EFFECT_HORN && row_has_effect(side, target_row, CCG_EFFECT_HORN))
			discarded[side] += card.id
			last_message = "[player_names[side]] plays [card.name], but that row already has a horn."
			return TRUE
		add_row_effect(side, target_row, card.id, side)
		last_message = "[player_names[side]] plays [card.name]."
		return TRUE
	return FALSE

/datum/ccg_match/proc/row_has_effect(side, row, effect)
	for(var/datum/ccg_played_card/played in row_effects[side][row])
		var/datum/ccg_card/card = ccg_card(played.card_id)
		if(card?.effect == effect)
			return TRUE
	return FALSE

/datum/ccg_match/proc/row_has_unit_effect(side, row, effect)
	for(var/check_row in list(CCG_ROW_INFANTRY, CCG_ROW_ARCHERS, CCG_ROW_SIEGE))
		for(var/datum/ccg_played_card/played in board[side][check_row])
			var/datum/ccg_card/card = ccg_card(played.card_id)
			if(card?.effect != effect)
				continue
			var/effect_row = card.target_row
			if(!effect_row)
				effect_row = card.row
			if(effect_row == row)
				return TRUE
	return FALSE

/datum/ccg_match/proc/apply_card_effect(datum/ccg_card/card, owner_side, play_side)
	if(card.effect == CCG_EFFECT_SCORCH)
		scorch_strongest_enemy(owner_side)
	else if(card.effect == CCG_EFFECT_SCORCH_INFANTRY)
		scorch_enemy_infantry(owner_side)
	else if(card.effect == CCG_EFFECT_SCORCH_GLOBAL)
		recalculate_board()
		scorch_strongest_global()
	else if(card.effect == CCG_EFFECT_CLEAR_WEATHER)
		clear_weather()

/datum/ccg_match/proc/apply_combo_effect(datum/ccg_card/card, owner_side, play_side)
	if(card.combo_effect == CCG_EFFECT_NONE || !length(card.combo_with))
		return FALSE
	if(!combo_partner_present(card, play_side))
		return FALSE
	if(card.combo_effect == CCG_EFFECT_SCORCH)
		scorch_strongest_enemy(owner_side)
	else if(card.combo_effect == CCG_EFFECT_MORALE)
		combo_morale[play_side][card.row]++
		recalculate_board()
	return TRUE

/datum/ccg_match/proc/combo_partner_present(datum/ccg_card/card, play_side)
	for(var/row in list(CCG_ROW_INFANTRY, CCG_ROW_ARCHERS, CCG_ROW_SIEGE))
		for(var/datum/ccg_played_card/played in board[play_side][row])
			if(played.card_id != card.id && (played.card_id in card.combo_with))
				return TRUE
	return FALSE

/datum/ccg_match/proc/scorch_strongest_enemy(owner_side)
	var/enemy = opposite(owner_side)
	var/datum/ccg_played_card/strongest
	var/strongest_row
	for(var/row in list(CCG_ROW_INFANTRY, CCG_ROW_ARCHERS, CCG_ROW_SIEGE))
		for(var/datum/ccg_played_card/played in board[enemy][row])
			if(!strongest || played.current_power > strongest.current_power)
				var/datum/ccg_card/card = ccg_card(played.card_id)
				if(card?.hero)
					continue
				strongest = played
				strongest_row = row
	if(strongest)
		destroy_played_card(enemy, strongest_row, strongest)

/datum/ccg_match/proc/scorch_enemy_infantry(owner_side)
	recalculate_board()
	var/enemy = opposite(owner_side)
	var/row_total = 0
	var/highest = 0
	for(var/datum/ccg_played_card/played in board[enemy][CCG_ROW_INFANTRY])
		var/datum/ccg_card/card = ccg_card(played.card_id)
		if(card?.hero)
			continue
		row_total += played.current_power
		highest = max(highest, played.current_power)
	if(row_total < 10 || highest <= 0)
		return
	var/list/infantry_row = board[enemy][CCG_ROW_INFANTRY]
	var/list/infantry_copy = infantry_row.Copy()
	for(var/datum/ccg_played_card/played in infantry_copy)
		if(played.current_power == highest)
			var/datum/ccg_card/card = ccg_card(played.card_id)
			if(!card?.hero)
				destroy_played_card(enemy, CCG_ROW_INFANTRY, played)

/datum/ccg_match/proc/scorch_strongest_global()
	var/highest = 0
	for(var/side in list(CCG_SIDE_ONE, CCG_SIDE_TWO))
		for(var/row in list(CCG_ROW_INFANTRY, CCG_ROW_ARCHERS, CCG_ROW_SIEGE))
			for(var/datum/ccg_played_card/played in board[side][row])
				var/datum/ccg_card/card = ccg_card(played.card_id)
				if(!card?.hero)
					highest = max(highest, played.current_power)
	if(highest <= 0)
		return
	for(var/side in list(CCG_SIDE_ONE, CCG_SIDE_TWO))
		for(var/row in list(CCG_ROW_INFANTRY, CCG_ROW_ARCHERS, CCG_ROW_SIEGE))
			var/list/board_row = board[side][row]
			var/list/row_copy = board_row.Copy()
			for(var/datum/ccg_played_card/played in row_copy)
				if(played.current_power == highest)
					var/datum/ccg_card/card = ccg_card(played.card_id)
					if(!card?.hero)
						destroy_played_card(side, row, played)

/datum/ccg_match/proc/destroy_played_card(side, row, datum/ccg_played_card/played)
	board[side][row] -= played
	discarded[played.owner_side] += played.card_id
	var/datum/ccg_card/card = ccg_card(played.card_id)
	if(card?.effect == CCG_EFFECT_AVENGER && card.avenger_card && ccg_card(card.avenger_card))
		add_played_card(side, row, card.avenger_card, played.owner_side)

/datum/ccg_match/proc/remove_last_played(side, row)
	var/list/row_cards = board[side][row]
	if(!length(row_cards))
		return FALSE
	row_cards.Cut(row_cards.len, row_cards.len + 1)
	return TRUE

/datum/ccg_match/proc/return_own_unit_to_hand(side, row, play_id)
	var/datum/ccg_played_card/played = find_played_card(side, row, play_id)
	var/datum/ccg_card/card = ccg_card(played?.card_id)
	if(!played || !is_unit_card(card) || card.hero)
		return FALSE
	board[side][row] -= played
	hands[side] += played.card_id
	return TRUE

/datum/ccg_match/proc/revive_discard(side, target_card_id)
	var/list/discard = discarded[side]
	var/list/choices = revive_choices(side)
	if(!length(choices))
		return TRUE
	if(!target_card_id || !(target_card_id in choices))
		return FALSE
	var/card_id = target_card_id
	var/index = discard.Find(card_id)
	if(index)
		discard.Cut(index, index + 1)
		var/datum/ccg_card/card = ccg_card(card_id)
		var/play_side = side
		if(card.effect == CCG_EFFECT_SPY)
			play_side = opposite(side)
			draw_cards(side, 2)
		add_played_card(play_side, card.row, card_id, side)
		return TRUE
	return FALSE

/datum/ccg_match/proc/revive_choices(side)
	var/list/out = list()
	var/list/discard = discarded[side]
	for(var/id in discard)
		var/datum/ccg_card/card = ccg_card(id)
		if(!is_unit_card(card) || card.hero)
			continue
		out |= id
	return out

/datum/ccg_match/proc/muster_copies(datum/ccg_card/card, owner_side, play_side, play_row)
	var/list/hand = hands[owner_side]
	var/index = hand.Find(card.id)
	while(index)
		hand.Cut(index, index + 1)
		add_played_card(play_side, play_row, card.id, owner_side)
		index = hand.Find(card.id)
	var/list/deck = decks[owner_side]
	index = deck.Find(card.id)
	while(index)
		deck.Cut(index, index + 1)
		add_played_card(play_side, play_row, card.id, owner_side)
		index = deck.Find(card.id)

/datum/ccg_match/proc/recalculate_board()
	for(var/side in list(CCG_SIDE_ONE, CCG_SIDE_TWO))
		for(var/row in list(CCG_ROW_INFANTRY, CCG_ROW_ARCHERS, CCG_ROW_SIEGE))
			var/morale = 0
			var/list/bond_counts = list()
			for(var/datum/ccg_played_card/played in board[side][row])
				var/datum/ccg_card/card = ccg_card(played.card_id)
				if(card?.effect == CCG_EFFECT_MORALE)
					morale++
				if(card?.effect == CCG_EFFECT_BOND)
					var/current_bond_count = bond_counts[played.card_id]
					if(!current_bond_count)
						current_bond_count = 0
					bond_counts[played.card_id] = current_bond_count + 1
			morale += combo_morale[side][row]
			var/horn = row_has_effect(side, row, CCG_EFFECT_HORN) || row_has_unit_effect(side, row, CCG_EFFECT_HORN)
			var/mardroeme = row_has_effect(side, row, CCG_EFFECT_MARDROEME) || row_has_unit_effect(side, row, CCG_EFFECT_MARDROEME)
			for(var/datum/ccg_played_card/played in board[side][row])
				var/datum/ccg_card/card = ccg_card(played.card_id)
				if(!card)
					continue
				var/value = card.power
				if(card.effect == CCG_EFFECT_BERSERK && mardroeme)
					value = max(value, card.bear_power)
				if((row in weather) && !card.hero)
					value = min(value, 1)
				var/final_bond_count = bond_counts[played.card_id]
				if(card.effect == CCG_EFFECT_BOND && final_bond_count > 1 && !card.hero)
					value *= final_bond_count
				if(card.effect != CCG_EFFECT_MORALE && !card.hero)
					value += morale
				if(horn && !card.hero)
					value *= 2
				played.current_power = value

/datum/ccg_match/proc/score(side)
	recalculate_board()
	var/total = 0
	for(var/row in list(CCG_ROW_INFANTRY, CCG_ROW_ARCHERS, CCG_ROW_SIEGE))
		for(var/datum/ccg_played_card/played in board[side][row])
			total += played.current_power
	return total

/datum/ccg_match/proc/end_round()
	var/score_one = score(CCG_SIDE_ONE)
	var/score_two = score(CCG_SIDE_TWO)
	var/winning_side
	var/draw_round = FALSE
	if(score_one > score_two)
		winning_side = CCG_SIDE_ONE
		last_message = "[player_names[CCG_SIDE_ONE]] wins the round [score_one] to [score_two]."
	else if(score_two > score_one)
		winning_side = CCG_SIDE_TWO
		last_message = "[player_names[CCG_SIDE_TWO]] wins the round [score_two] to [score_one]."
	else
		if(faction_has_effect(CCG_SIDE_ONE, CCG_FACTION_EFFECT_WIN_DRAWS) && !faction_has_effect(CCG_SIDE_TWO, CCG_FACTION_EFFECT_WIN_DRAWS))
			winning_side = CCG_SIDE_ONE
			last_message = "[player_names[CCG_SIDE_ONE]] wins the drawn round by faction claim."
		else if(faction_has_effect(CCG_SIDE_TWO, CCG_FACTION_EFFECT_WIN_DRAWS) && !faction_has_effect(CCG_SIDE_ONE, CCG_FACTION_EFFECT_WIN_DRAWS))
			winning_side = CCG_SIDE_TWO
			last_message = "[player_names[CCG_SIDE_TWO]] wins the drawn round by faction claim."
		else
			draw_round = TRUE
			last_message = "The round is a draw."
	if(winning_side)
		round_wins[winning_side]++
		if(faction_has_effect(winning_side, CCG_FACTION_EFFECT_ROUND_WIN_DRAW))
			draw_cards(winning_side, 1)
		if(score_one != score_two)
			var/losing_side = opposite(winning_side)
			if(faction_has_effect(losing_side, CCG_FACTION_EFFECT_ROUND_LOSS_DRAW))
				draw_cards(losing_side, 1)
	else if(draw_round)
		round_wins[CCG_SIDE_ONE]++
		round_wins[CCG_SIDE_TWO]++
	prepare_faction_carryover(CCG_SIDE_ONE)
	prepare_faction_carryover(CCG_SIDE_TWO)
	for(var/side in list(CCG_SIDE_ONE, CCG_SIDE_TWO))
		var/list/carryover_for_side = carryover_cards[side] || list()
		var/list/side_carryover = carryover_for_side.Copy()
		for(var/row in list(CCG_ROW_INFANTRY, CCG_ROW_ARCHERS, CCG_ROW_SIEGE))
			for(var/datum/ccg_played_card/played in board[side][row])
				if(played.card_id in side_carryover)
					side_carryover -= played.card_id
					continue
				discarded[played.owner_side] += played.card_id
	for(var/datum/ccg_played_card/played in weather_board)
		discarded[played.owner_side] += played.card_id
	for(var/side in list(CCG_SIDE_ONE, CCG_SIDE_TWO))
		for(var/row in list(CCG_ROW_INFANTRY, CCG_ROW_ARCHERS, CCG_ROW_SIEGE))
			for(var/datum/ccg_played_card/played in row_effects[side][row])
				discarded[played.owner_side] += played.card_id
	if(round_wins[CCG_SIDE_ONE] >= 2 || round_wins[CCG_SIDE_TWO] >= 2)
		var/winner = round_wins[CCG_SIDE_ONE] >= 2 ? CCG_SIDE_ONE : CCG_SIDE_TWO
		result_text = "[player_names[winner]] wins the match."
		play_cue(CCG_SOUND_GAME_END)
		stop_soundtracks()
		return
	round_number++
	start_round(FALSE)

/datum/ccg_match/proc/prepare_faction_carryover(side)
	carryover_cards[side] = list()
	if(!faction_has_effect(side, CCG_FACTION_EFFECT_KEEP_UNIT))
		return
	var/list/candidates = list()
	for(var/row in list(CCG_ROW_INFANTRY, CCG_ROW_ARCHERS, CCG_ROW_SIEGE))
		for(var/datum/ccg_played_card/played in board[side][row])
			var/datum/ccg_card/card = ccg_card(played.card_id)
			if(is_unit_card(card) && !card.hero)
				candidates += played.card_id
	if(length(candidates))
		carryover_cards[side] += pick(candidates)

/datum/ccg_match/proc/revive_random_discard(side)
	var/list/choices = revive_choices(side)
	if(!length(choices))
		return FALSE
	return revive_discard(side, pick(choices))

/datum/ccg_match/proc/ui_data_for(mob/user, obj/item/ccg_deck/deck_context)
	var/list/data = list()
	var/my_side = side_for_user(user, deck_context)
	data["mySide"] = my_side
	data["isSpectator"] = !my_side && user?.ckey && (user.ckey in spectator_ckeys)
	data["spectatorCount"] = length(spectator_ckeys)
	data["inMulligan"] = in_mulligan
	data["mulligansLeft"] = my_side ? mulligans_left[my_side] : 0
	data["mulliganReady"] = my_side ? mulligan_ready[my_side] : FALSE
	data["turn"] = turn
	data["players"] = player_names
	data["wins"] = round_wins
	data["passed"] = passed
	data["scores"] = list(CCG_SIDE_ONE = score(CCG_SIDE_ONE), CCG_SIDE_TWO = score(CCG_SIDE_TWO))
	data["round"] = round_number
	data["result"] = result_text
	data["message"] = last_message
	data["weather"] = weather
	data["weatherCards"] = build_weather_data()
	data["rowEffects"] = build_row_effect_data()
	data["leader"] = my_side ? build_leader_data(my_side) : null
	data["faction"] = my_side ? build_faction_data(my_side) : null
	data["hand"] = build_hand_data(my_side)
	data["discard"] = build_discard_data(my_side)
	data["targets"] = build_target_data(my_side)
	data["deckCount"] = my_side ? length(decks[my_side]) : 0
	data["discardCount"] = my_side ? length(discarded[my_side]) : 0
	data["opponentHandCount"] = my_side ? length(hands[opposite(my_side)]) : 0
	data["soundtrackEnabled"] = user?.client?.prefs?.ccg_soundtrack_enabled ? TRUE : FALSE
	data["soundtrackTitle"] = soundtrack_title_for(user)
	data["board"] = build_board_data()
	return data

/datum/ccg_match/proc/build_hand_data(side)
	var/list/out = list()
	if(!side)
		return out
	for(var/card_id in hands[side])
		var/datum/ccg_card/card = ccg_card(card_id)
		if(card)
			out += list(card.as_ui_data(TRUE, FALSE))
	return out

/datum/ccg_match/proc/build_leader_data(side)
	var/datum/ccg_leader/leader = ccg_leader(leader_ids[side])
	if(!leader)
		return null
	return leader.as_ui_data(leader_used[side])

/datum/ccg_match/proc/build_faction_data(side)
	var/datum/ccg_faction/faction = ccg_faction(faction_ids[side])
	if(!faction)
		return null
	return faction.as_ui_data()

/datum/ccg_match/proc/build_discard_data(side)
	var/list/out = list()
	if(!side)
		return out
	for(var/id in discarded[side])
		var/datum/ccg_card/card = ccg_card(id)
		if(card)
			out += list(card.as_ui_data(TRUE, FALSE))
	return out

/datum/ccg_match/proc/build_target_data(side)
	var/list/out = list()
	if(!side)
		return out
	out["revive"] = list()
	for(var/id in revive_choices(side))
		var/datum/ccg_card/card = ccg_card(id)
		if(card)
			out["revive"] += list(card.as_ui_data(TRUE, FALSE))
	out["decoy"] = list()
	for(var/row in list(CCG_ROW_INFANTRY, CCG_ROW_ARCHERS, CCG_ROW_SIEGE))
		for(var/datum/ccg_played_card/played in board[side][row])
			var/datum/ccg_card/card = ccg_card(played.card_id)
			if(!is_unit_card(card) || card.hero)
				continue
			var/list/card_data = card.as_ui_data(TRUE, FALSE)
			card_data["playId"] = played.play_id
			card_data["row"] = row
			card_data["currentPower"] = played.current_power
			out["decoy"] += list(card_data)
	return out

/datum/ccg_match/proc/build_board_data()
	var/list/out = list()
	for(var/side in list(CCG_SIDE_ONE, CCG_SIDE_TWO))
		out[side] = list()
		for(var/row in list(CCG_ROW_INFANTRY, CCG_ROW_ARCHERS, CCG_ROW_SIEGE))
			out[side][row] = list()
			for(var/datum/ccg_played_card/played in board[side][row])
				var/datum/ccg_card/card = ccg_card(played.card_id)
				if(card)
					var/list/card_data = card.as_ui_data(TRUE, FALSE)
					card_data["currentPower"] = played.current_power
					card_data["playId"] = played.play_id
					out[side][row] += list(card_data)
	return out

/datum/ccg_match/proc/build_weather_data()
	var/list/out = list()
	for(var/datum/ccg_played_card/played in weather_board)
		var/datum/ccg_card/card = ccg_card(played.card_id)
		if(card)
			out += list(card.as_ui_data(TRUE, FALSE))
	return out

/datum/ccg_match/proc/build_row_effect_data()
	var/list/out = list()
	for(var/side in list(CCG_SIDE_ONE, CCG_SIDE_TWO))
		out[side] = list()
		for(var/row in list(CCG_ROW_INFANTRY, CCG_ROW_ARCHERS, CCG_ROW_SIEGE))
			out[side][row] = list()
			for(var/datum/ccg_played_card/played in row_effects[side][row])
				var/datum/ccg_card/card = ccg_card(played.card_id)
				if(card)
					out[side][row] += list(card.as_ui_data(TRUE, FALSE))
	return out

#undef CCG_SIDE_ONE
#undef CHANNEL_GWYNT_MUSIC
#undef CCG_SIDE_TWO
#undef CCG_HAND_SIZE
#undef CCG_MULLIGAN_COUNT
#undef CCG_SOUND_MULLIGAN
#undef CCG_SOUND_ROUND_START
#undef CCG_SOUND_CARD_PLAY
#undef CCG_SOUND_WEATHER
#undef CCG_SOUND_SPECIAL
#undef CCG_SOUND_HORN
#undef CCG_SOUND_GAME_END
#undef CCG_SOUNDTRACK_VOLUME
#undef CCG_SOUNDTRACK_DEFAULT
#undef CCG_SOUNDTRACK_HARD_CARDS
#undef CCG_SOUNDTRACK_BANDIT_CONFRONTATION
#undef CCG_SOUNDTRACK_VAMPIRE_NEGOTIATIONS
#undef CCG_SOUNDTRACK_LAST_SIEGE
#undef CCG_SOUNDTRACK_DEFAULT_LENGTH
#undef CCG_SOUNDTRACK_HARD_CARDS_LENGTH
#undef CCG_SOUNDTRACK_BANDIT_CONFRONTATION_LENGTH
#undef CCG_SOUNDTRACK_VAMPIRE_NEGOTIATIONS_LENGTH
#undef CCG_SOUNDTRACK_LAST_SIEGE_LENGTH
