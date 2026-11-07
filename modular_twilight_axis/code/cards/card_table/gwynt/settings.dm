#define CCG_DECK_SIZE 30
#define CCG_MAX_SAVED_DECKS 10
#define CCG_VIEW_SETUP "setup"
#define CCG_VIEW_DECK "deck"
#define CCG_VIEW_POOL "pool"
#define CCG_STASH_DECK_KEY "ccg_deck_cards"
#define CCG_STASH_FACTION_KEY "ccg_deck_faction"
#define CCG_STASH_LEADER_KEY "ccg_deck_leader"
#define CCG_SQL_LOAD_FAILED 0
#define CCG_SQL_LOAD_EMPTY 1
#define CCG_SQL_LOAD_LOADED 2
#define CCG_STARTER_INFANTRY_CARD "rare_azuria_squire"
#define CCG_STARTER_ARCHER_CARD "base_scout"
#define CCG_STARTER_SIEGE_CARD "base_mangonel"
#define CCG_STARTER_BLACKSMITH_CARD "base_blacksmith"
#define CCG_STARTER_SCORCH_CARD "base_scorch"
#define CCG_BOOSTER_PROGRESS_REQUIRED 5

GLOBAL_LIST_EMPTY(ccg_round_win_progress_awarded)
GLOBAL_LIST_EMPTY(ccg_round_match_loss_progress_awarded)
GLOBAL_LIST_EMPTY(ccg_round_trade_loss_progress_awarded)

/datum/mind
	var/ccg_deck_requested = FALSE

/datum/preferences
	var/list/ccg_known_rare_cards = list()
	var/list/ccg_selected_deck = list()
	var/list/ccg_saved_deck_cards = list()
	var/ccg_saved_deck_faction = CCG_FACTION_AZURIA
	var/ccg_saved_deck_leader = "azuria_ducal_marshal"
	var/list/ccg_saved_decks = list()
	var/ccg_active_deck_index = 1
	var/ccg_deckbuilder_view_mode = CCG_VIEW_SETUP
	var/ccg_soundtrack_enabled = FALSE
	var/ccg_presets_are_virtual = FALSE
	var/ccg_win_progress = 0
	var/ccg_loss_progress = 0

/datum/preferences/proc/ccg_known_cards()
	var/list/cards = list()
	if(islist(ccg_known_rare_cards))
		for(var/card_id in ccg_known_rare_cards)
			var/count = ccg_known_rare_cards[card_id]
			if((isnum(count) && count > 0) || (!isnum(count) && (card_id in ccg_known_rare_cards)))
				cards |= card_id
	return cards

/datum/preferences/proc/ccg_booster_progress_required()
	var/unique_card_count = length(ccg_known_cards())
	if(unique_card_count < 10)
		return 1
	if(unique_card_count < 20)
		return 2
	if(unique_card_count < 30)
		return 3
	if(unique_card_count < 40)
		return 4
	return CCG_BOOSTER_PROGRESS_REQUIRED

/proc/ccg_card_is_limited(datum/ccg_card/card)
	return card ? TRUE : FALSE

/proc/ccg_card_deck_limit(datum/ccg_card/card)
	if(!card)
		return 0
	if(card.rarity == CCG_RARITY_UNIQUE)
		return 1
	if(card.rarity == CCG_RARITY_RARE)
		return 2
	if(card.row == CCG_ROW_WEATHER || card.row == CCG_ROW_SPECIAL)
		return 2
	if(card.limited)
		return 3
	return 5

/proc/ccg_card_pool_limit(datum/ccg_card/card)
	if(!card)
		return 0
	return ccg_card_deck_limit(card) + 2

/datum/preferences/proc/ccg_card_pool_count(card_id)
	var/datum/ccg_card/card = ccg_card(card_id)
	if(!card)
		return 0
	if(!islist(ccg_known_rare_cards))
		return 0
	return max(0, ccg_known_rare_cards[card_id])

/proc/ccg_card_count_in_list(list/card_ids, card_id)
	var/count = 0
	if(!islist(card_ids))
		return 0
	for(var/selected_id in card_ids)
		if(selected_id == card_id)
			count++
	return count

/datum/preferences/proc/ccg_selected_count(card_id)
	return ccg_card_count_in_list(ccg_selected_deck, card_id)

/datum/preferences/proc/ccg_can_select_card(card_id)
	var/datum/ccg_card/card = ccg_card(card_id)
	if(!card)
		return FALSE
	var/deck_limit = ccg_card_deck_limit(card)
	if(ccg_selected_count(card_id) >= deck_limit)
		return FALSE
	return ccg_selected_count(card_id) < ccg_card_pool_count(card_id)

/datum/preferences/proc/ccg_available_for_deck(list/deck_cards, card_id)
	var/datum/ccg_card/card = ccg_card(card_id)
	if(!card)
		return 0
	var/deck_limit = ccg_card_deck_limit(card)
	return min(deck_limit, ccg_card_pool_count(card_id))

/datum/preferences/proc/ccg_owned_deck_cards(list/card_ids)
	var/list/owned_cards = list()
	var/list/card_counts = list()
	if(!islist(card_ids))
		return owned_cards
	for(var/card_id in card_ids)
		if(card_counts[card_id] >= ccg_card_pool_count(card_id))
			continue
		card_counts[card_id] = (card_counts[card_id] || 0) + 1
		owned_cards += card_id
	return owned_cards

/datum/preferences/proc/ccg_default_deck_spec(index = 1)
	var/datum/ccg_faction/faction = ccg_faction(CCG_FACTION_AZURIA)
	return list(
		"name" = "Deck [index]",
		"cards" = list(),
		"faction" = faction ? faction.id : CCG_FACTION_AZURIA,
		"leader" = faction ? faction.default_leader : "azuria_ducal_marshal",
	)

/datum/preferences/proc/ccg_normalize_deck_spec(list/spec, index = 1)
	if(!islist(spec))
		spec = ccg_default_deck_spec(index)
	var/name = spec["name"]
	if(!istext(name) || !length(name))
		name = "Deck [index]"
	var/faction_id = spec["faction"]
	var/datum/ccg_faction/faction = ccg_faction(faction_id)
	if(!faction)
		faction = ccg_faction(CCG_FACTION_AZURIA)
	var/leader_id = spec["leader"]
	var/datum/ccg_leader/leader = ccg_leader(leader_id)
	if(!leader || leader.faction != faction.id)
		leader_id = faction.default_leader
	var/list/cards = islist(spec["cards"]) ? spec["cards"] : list()
	var/list/valid_cards = list()
	var/list/card_counts = list()
	for(var/card_id in cards)
		var/datum/ccg_card/card = ccg_card(card_id)
		if(!card || !ccg_card_allowed_for_faction(card_id, faction.id) || valid_cards.len >= CCG_DECK_SIZE)
			continue
		var/card_count = card_counts[card_id]
		if(!card_count)
			card_count = 0
		if(card_count >= ccg_card_deck_limit(card))
			continue
		card_counts[card_id] = card_count + 1
		valid_cards += card_id
	return list(
		"name" = name,
		"cards" = valid_cards,
		"faction" = faction.id,
		"leader" = leader_id,
	)

/datum/preferences/proc/ccg_normalize_saved_decks()
	if(!islist(ccg_saved_decks))
		ccg_saved_decks = list()
	if(!length(ccg_saved_decks))
		ccg_saved_decks += list(list(
			"name" = "Deck 1",
			"cards" = islist(ccg_saved_deck_cards) ? ccg_saved_deck_cards.Copy() : list(),
			"faction" = ccg_saved_deck_faction,
			"leader" = ccg_saved_deck_leader,
		))
	var/list/normalized = list()
	var/index = 1
	for(var/spec in ccg_saved_decks)
		if(index > CCG_MAX_SAVED_DECKS)
			break
		normalized += list(ccg_normalize_deck_spec(spec, index))
		index++
	while(!length(normalized))
		normalized += list(ccg_default_deck_spec(1))
	ccg_saved_decks = normalized
	ccg_active_deck_index = clamp(round(text2num("[ccg_active_deck_index]") || 1), 1, length(ccg_saved_decks))
	if(!(ccg_deckbuilder_view_mode in list(CCG_VIEW_SETUP, CCG_VIEW_DECK, CCG_VIEW_POOL)))
		ccg_deckbuilder_view_mode = CCG_VIEW_SETUP
	ccg_load_active_deck()

/datum/preferences/proc/ccg_active_deck_spec()
	ccg_normalize_saved_decks()
	return ccg_saved_decks[ccg_active_deck_index]

/datum/preferences/proc/ccg_load_active_deck()
	if(!islist(ccg_saved_decks) || !length(ccg_saved_decks))
		return FALSE
	var/list/spec = ccg_saved_decks[clamp(ccg_active_deck_index, 1, length(ccg_saved_decks))]
	var/list/cards = spec["cards"]
	ccg_saved_deck_cards = islist(cards) ? cards.Copy() : list()
	ccg_saved_deck_faction = spec["faction"]
	ccg_saved_deck_leader = spec["leader"]
	return TRUE

/datum/preferences/proc/ccg_store_active_deck(list/cards, faction_id, leader_id, name = null)
	ccg_normalize_saved_decks()
	var/list/spec = ccg_saved_decks[ccg_active_deck_index]
	if(name)
		spec["name"] = name
	spec["cards"] = islist(cards) ? cards.Copy() : list()
	spec["faction"] = faction_id
	spec["leader"] = leader_id
	ccg_saved_decks[ccg_active_deck_index] = ccg_normalize_deck_spec(spec, ccg_active_deck_index)
	ccg_load_active_deck()
	return TRUE

/datum/preferences/proc/ccg_clean_cards()
	if(!islist(ccg_known_rare_cards))
		ccg_known_rare_cards = list()
	if(!islist(ccg_selected_deck))
		ccg_selected_deck = list()
	if(!islist(ccg_saved_deck_cards))
		ccg_saved_deck_cards = list()
	if(!ccg_faction(ccg_saved_deck_faction))
		ccg_saved_deck_faction = CCG_FACTION_AZURIA
	var/datum/ccg_leader/saved_leader = ccg_leader(ccg_saved_deck_leader)
	var/datum/ccg_faction/saved_faction = ccg_faction(ccg_saved_deck_faction)
	if(!saved_faction)
		saved_faction = ccg_faction(CCG_FACTION_AZURIA)
		ccg_saved_deck_faction = saved_faction.id
	if(!saved_leader || saved_leader.faction != ccg_saved_deck_faction)
		ccg_saved_deck_leader = saved_faction.default_leader
	ccg_normalize_saved_decks()

	var/list/valid_rare = list()
	for(var/card_id in ccg_known_rare_cards)
		var/datum/ccg_card/card = ccg_card(card_id)
		if(ccg_card_is_limited(card))
			var/count = ccg_known_rare_cards[card_id]
			if(!isnum(count))
				count = 1
			count = clamp(round(count), 0, ccg_card_pool_limit(card))
			if(count > 0)
				valid_rare[card_id] = count
	ccg_known_rare_cards = valid_rare

	var/list/selected_counts = list()
	var/list/valid_deck = list()
	for(var/card_id in ccg_selected_deck)
		var/datum/ccg_card/card = ccg_card(card_id)
		if(!card || valid_deck.len >= CCG_DECK_SIZE)
			continue
		var/selected_count = selected_counts[card_id]
		if(!selected_count)
			selected_count = 0
		if(selected_count >= ccg_card_deck_limit(card))
			continue
		selected_counts[card_id] = selected_count + 1
		valid_deck += card_id
	ccg_selected_deck = valid_deck

	var/list/valid_saved_deck = list()
	var/list/saved_counts = list()
	for(var/card_id in ccg_saved_deck_cards)
		var/datum/ccg_card/saved_card = ccg_card(card_id)
		if(!saved_card || !ccg_card_allowed_for_faction(card_id, ccg_saved_deck_faction) || valid_saved_deck.len >= CCG_DECK_SIZE)
			continue
		var/saved_count = saved_counts[card_id]
		if(!saved_count)
			saved_count = 0
		if(saved_count >= ccg_card_deck_limit(saved_card))
			continue
		saved_counts[card_id] = saved_count + 1
		valid_saved_deck += card_id
	ccg_saved_deck_cards = valid_saved_deck
	ccg_store_active_deck(ccg_saved_deck_cards, ccg_saved_deck_faction, ccg_saved_deck_leader)

/datum/preferences/proc/ccg_virtualize_saved_deck_pool()
	if(ccg_presets_are_virtual)
		return FALSE
	if(islist(ccg_saved_decks))
		for(var/spec in ccg_saved_decks)
			if(!islist(spec))
				continue
			var/list/cards = spec["cards"]
			if(!islist(cards))
				continue
			for(var/card_id in cards)
				if(ccg_card(card_id))
					ccg_known_rare_cards[card_id] = (ccg_known_rare_cards[card_id] || 0) + 1
	ccg_presets_are_virtual = TRUE
	return TRUE

/datum/preferences/proc/ccg_account_ckey()
	return parent?.ckey

/datum/preferences/proc/ccg_has_legacy_savefile_data()
	return length(ccg_known_rare_cards) || length(ccg_selected_deck) || length(ccg_saved_deck_cards) || length(ccg_saved_decks)

/datum/preferences/proc/ccg_execute_sql(sql, list/arguments = null)
	var/datum/DBQuery/query = SSdbcore.NewQuery(sql, arguments)
	if(!query)
		return FALSE
	var/success = query.Execute(async = FALSE)
	qdel(query)
	return success

/datum/preferences/proc/ccg_load_or_migrate_sql()
	var/legacy_data = ccg_has_legacy_savefile_data()
	var/load_result = ccg_load_sql()
	if(load_result == CCG_SQL_LOAD_LOADED)
		ccg_clean_cards()
		var/changed = ccg_virtualize_saved_deck_pool()
		if(ccg_ensure_base_pool())
			ccg_clean_cards()
			changed = TRUE
		if(changed)
			ccg_save_sql()
		return TRUE
	ccg_clean_cards()
	if(legacy_data)
		if(ccg_virtualize_saved_deck_pool())
			ccg_clean_cards()
		if(load_result == CCG_SQL_LOAD_EMPTY)
			return ccg_save_sql()
	else if(load_result == CCG_SQL_LOAD_EMPTY)
		ccg_seed_base_pool()
		ccg_clean_cards()
		return ccg_save_sql()
	return FALSE

/datum/preferences/proc/ccg_require_sql(mob/user = null)
	if(ccg_load_or_migrate_sql())
		return TRUE
	if(user)
		to_chat(user, span_warning("The card collection database is unavailable. Try again later."))
	return FALSE

/datum/preferences/proc/ccg_load_sql()
	var/account_ckey = ccg_account_ckey()
	if(!account_ckey || !SSdbcore.Connect())
		return CCG_SQL_LOAD_FAILED
	var/loaded_data = FALSE

	var/list/settings = null
	var/datum/DBQuery/settings_query = SSdbcore.NewQuery({"
		SELECT active_deck_index, deckbuilder_view_mode, soundtrack_enabled, presets_are_virtual, win_progress, loss_progress
		FROM [format_table_name("ccg_settings")]
		WHERE ckey = :ckey
	"}, list("ckey" = account_ckey))
	if(!settings_query || !settings_query.Execute(async = FALSE, log_error = FALSE))
		if(settings_query)
			qdel(settings_query)
		return CCG_SQL_LOAD_FAILED
	if(settings_query.NextRow())
		settings = settings_query.item
		loaded_data = TRUE
	qdel(settings_query)

	var/list/collection = list()
	var/datum/DBQuery/collection_query = SSdbcore.NewQuery({"
		SELECT card_id, amount
		FROM [format_table_name("ccg_collection")]
		WHERE ckey = :ckey
	"}, list("ckey" = account_ckey))
	if(!collection_query || !collection_query.Execute(async = FALSE, log_error = FALSE))
		if(collection_query)
			qdel(collection_query)
		return CCG_SQL_LOAD_FAILED
	while(collection_query.NextRow())
		var/card_id = collection_query.item[1]
		var/amount = round(text2num("[collection_query.item[2]]") || 0)
		if(istext(card_id) && amount > 0)
			collection[card_id] = amount
			loaded_data = TRUE
	qdel(collection_query)

	var/list/loaded_decks = list()
	var/list/deck_by_slot = list()
	var/datum/DBQuery/deck_query = SSdbcore.NewQuery({"
		SELECT deck_slot, name, faction, leader
		FROM [format_table_name("ccg_decks")]
		WHERE ckey = :ckey
		ORDER BY deck_slot ASC
	"}, list("ckey" = account_ckey))
	if(!deck_query || !deck_query.Execute(async = FALSE, log_error = FALSE))
		if(deck_query)
			qdel(deck_query)
		return CCG_SQL_LOAD_FAILED
	while(deck_query.NextRow())
		var/slot = round(text2num("[deck_query.item[1]]") || 0)
		if(slot <= 0 || slot > CCG_MAX_SAVED_DECKS)
			continue
		var/list/spec = list(
			"name" = deck_query.item[2],
			"cards" = list(),
			"faction" = deck_query.item[3],
			"leader" = deck_query.item[4],
		)
		deck_by_slot["[slot]"] = spec
		loaded_decks += list(spec)
		loaded_data = TRUE
	qdel(deck_query)

	var/datum/DBQuery/card_query = SSdbcore.NewQuery({"
		SELECT deck_slot, card_id
		FROM [format_table_name("ccg_deck_cards")]
		WHERE ckey = :ckey
		ORDER BY deck_slot ASC, card_position ASC
	"}, list("ckey" = account_ckey))
	if(!card_query || !card_query.Execute(async = FALSE, log_error = FALSE))
		if(card_query)
			qdel(card_query)
		return CCG_SQL_LOAD_FAILED
	while(card_query.NextRow())
		var/slot = round(text2num("[card_query.item[1]]") || 0)
		var/list/spec = deck_by_slot["[slot]"]
		if(!islist(spec))
			continue
		var/list/cards = spec["cards"]
		cards += card_query.item[2]
		loaded_data = TRUE
	qdel(card_query)

	if(!loaded_data)
		return CCG_SQL_LOAD_EMPTY

	ccg_known_rare_cards = collection
	ccg_saved_decks = loaded_decks
	if(settings)
		ccg_active_deck_index = round(text2num("[settings[1]]") || 1)
		ccg_deckbuilder_view_mode = settings[2]
		ccg_soundtrack_enabled = text2num("[settings[3]]") ? TRUE : FALSE
		ccg_presets_are_virtual = text2num("[settings[4]]") ? TRUE : FALSE
		ccg_win_progress = max(0, round(text2num("[settings[5]]") || 0))
		ccg_loss_progress = max(0, round(text2num("[settings[6]]") || 0))
	return CCG_SQL_LOAD_LOADED

/datum/preferences/proc/ccg_save_sql(save_collection = TRUE, save_decks = TRUE, save_settings = TRUE)
	var/account_ckey = ccg_account_ckey()
	if(!account_ckey || !SSdbcore.Connect())
		return FALSE
	ccg_clean_cards()
	var/base_pool_changed = ccg_ensure_base_pool()
	if(base_pool_changed)
		save_collection = TRUE

	if(!ccg_execute_sql("START TRANSACTION"))
		return FALSE

	var/success = TRUE
	if(save_decks)
		success = success && ccg_execute_sql("DELETE FROM [format_table_name("ccg_deck_cards")] WHERE ckey = :ckey", list("ckey" = account_ckey))
		success = success && ccg_execute_sql("DELETE FROM [format_table_name("ccg_decks")] WHERE ckey = :ckey", list("ckey" = account_ckey))
	if(save_collection)
		success = success && ccg_execute_sql("DELETE FROM [format_table_name("ccg_collection")] WHERE ckey = :ckey", list("ckey" = account_ckey))
	if(save_settings)
		success = success && ccg_execute_sql({"
			INSERT INTO [format_table_name("ccg_settings")] (ckey, active_deck_index, deckbuilder_view_mode, soundtrack_enabled, presets_are_virtual, win_progress, loss_progress)
			VALUES (:ckey, :active_deck_index, :deckbuilder_view_mode, :soundtrack_enabled, :presets_are_virtual, :win_progress, :loss_progress)
			ON DUPLICATE KEY UPDATE
				active_deck_index = :active_deck_index,
				deckbuilder_view_mode = :deckbuilder_view_mode,
				soundtrack_enabled = :soundtrack_enabled,
				presets_are_virtual = :presets_are_virtual,
				win_progress = :win_progress,
				loss_progress = :loss_progress
		"}, list(
			"ckey" = account_ckey,
			"active_deck_index" = ccg_active_deck_index,
			"deckbuilder_view_mode" = ccg_deckbuilder_view_mode,
			"soundtrack_enabled" = ccg_soundtrack_enabled ? 1 : 0,
			"presets_are_virtual" = ccg_presets_are_virtual ? 1 : 0,
			"win_progress" = ccg_win_progress,
			"loss_progress" = ccg_loss_progress,
		))

	var/list/collection_rows = list()
	if(save_collection)
		for(var/card_id in ccg_known_rare_cards)
			var/amount = round(ccg_known_rare_cards[card_id] || 0)
			if(amount <= 0)
				continue
			collection_rows += list(list(
				"ckey" = account_ckey,
				"card_id" = card_id,
				"amount" = amount,
			))
	if(save_collection && success && length(collection_rows))
		success = SSdbcore.MassInsert(format_table_name("ccg_collection"), collection_rows, async = FALSE)

	var/list/deck_rows = list()
	var/list/card_rows = list()
	if(save_decks)
		var/deck_slot = 1
		for(var/spec in ccg_saved_decks)
			if(!islist(spec) || deck_slot > CCG_MAX_SAVED_DECKS)
				continue
			var/list/normalized = ccg_normalize_deck_spec(spec, deck_slot)
			deck_rows += list(list(
				"ckey" = account_ckey,
				"deck_slot" = deck_slot,
				"name" = normalized["name"],
				"faction" = normalized["faction"],
				"leader" = normalized["leader"],
			))
			var/card_position = 1
			var/list/cards = normalized["cards"]
			for(var/card_id in cards)
				card_rows += list(list(
					"ckey" = account_ckey,
					"deck_slot" = deck_slot,
					"card_position" = card_position,
					"card_id" = card_id,
				))
				card_position++
			deck_slot++
	if(save_decks && success && length(deck_rows))
		success = SSdbcore.MassInsert(format_table_name("ccg_decks"), deck_rows, async = FALSE)
	if(save_decks && success && length(card_rows))
		success = SSdbcore.MassInsert(format_table_name("ccg_deck_cards"), card_rows, async = FALSE)

	if(success)
		success = ccg_execute_sql("COMMIT")
	else
		ccg_execute_sql("ROLLBACK")
	return success

/datum/preferences/proc/ccg_save()
	ccg_clean_cards()
	return ccg_save_sql()

/datum/preferences/proc/ccg_save_decks_sql()
	ccg_clean_cards()
	return ccg_save_sql(FALSE, TRUE, TRUE)

/datum/preferences/proc/ccg_save_settings_sql()
	ccg_clean_cards()
	return ccg_save_sql(FALSE, FALSE, TRUE)

/datum/preferences/proc/ccg_save_collection_sql()
	ccg_clean_cards()
	return ccg_save_sql(TRUE, FALSE, FALSE)

/datum/preferences/proc/ccg_grant_booster(mob/living/user, premium = FALSE)
	if(!user)
		return FALSE
	var/obj/item/ccg_card_booster/booster
	if(premium)
		booster = new /obj/item/ccg_card_booster/premium(get_turf(user))
	else
		booster = new /obj/item/ccg_card_booster(get_turf(user))
	if(!booster)
		return FALSE
	user.put_in_hands(booster)
	if(premium)
		to_chat(user, span_notice("Xylix delights in your fortune and grants you a miracle: a pack of cards to reach new heights."))
	else
		to_chat(user, span_notice("Xylix delights in your misfortune and grants you a miracle: a pack of cards for fresh mockery."))
	return TRUE

/datum/preferences/proc/ccg_award_progress(mob/living/user, progress_type)
	if(!user || !ccg_account_ckey())
		return FALSE
	var/list/round_awards
	var/premium = FALSE
	switch(progress_type)
		if("win")
			round_awards = GLOB.ccg_round_win_progress_awarded
			premium = TRUE
		if("match_loss")
			round_awards = GLOB.ccg_round_match_loss_progress_awarded
		if("trade_loss")
			round_awards = GLOB.ccg_round_trade_loss_progress_awarded
		else
			return FALSE
	var/account_ckey = ccg_account_ckey()
	if(round_awards[account_ckey])
		return FALSE
	var/old_progress = premium ? ccg_win_progress : ccg_loss_progress
	var/new_progress = old_progress + 1
	var/grant_booster = new_progress >= ccg_booster_progress_required()
	if(grant_booster)
		new_progress = 0
	if(premium)
		ccg_win_progress = new_progress
	else
		ccg_loss_progress = new_progress
	if(!ccg_save_settings_sql())
		if(premium)
			ccg_win_progress = old_progress
		else
			ccg_loss_progress = old_progress
		return FALSE
	round_awards[account_ckey] = TRUE
	if(grant_booster)
		ccg_grant_booster(user, premium)
	return TRUE

/proc/ccg_award_match_progress(winner_ckey, loser_ckey)
	if(!winner_ckey || winner_ckey == loser_ckey)
		return FALSE
	var/mob/living/winner = ccg_find_mob_by_ckey(winner_ckey)
	var/mob/living/loser = ccg_find_mob_by_ckey(loser_ckey)
	if(winner?.client?.prefs)
		winner.client.prefs.ccg_award_progress(winner, "win")
	if(loser?.client?.prefs)
		loser.client.prefs.ccg_award_progress(loser, "match_loss")
	return TRUE

/proc/ccg_award_trade_progress(source_ckey, mob/living/recipient)
	if(!source_ckey || !recipient?.ckey || source_ckey == recipient.ckey)
		return FALSE
	var/mob/living/source = ccg_find_mob_by_ckey(source_ckey)
	if(!source)
		return FALSE
	var/source_awarded = source.client?.prefs?.ccg_award_progress(source, "trade_loss")
	var/recipient_awarded = recipient.client?.prefs?.ccg_award_progress(recipient, "trade_loss")
	return source_awarded || recipient_awarded

/datum/preferences/proc/ccg_seed_base_pool()
	if(!length(GLOB.ccg_base_card_ids))
		ccg_build_card_registry()
	. = FALSE
	. = ccg_add_seed_card(ccg_starter_infantry_card_id(), 4) || .
	. = ccg_add_seed_card(CCG_STARTER_ARCHER_CARD, 3) || .
	. = ccg_add_seed_card(CCG_STARTER_SIEGE_CARD, 2) || .
	. = ccg_add_seed_card(CCG_STARTER_BLACKSMITH_CARD, 1) || .
	. = ccg_add_seed_card("base_clear", 2) || .
	. = ccg_add_seed_card(CCG_STARTER_SCORCH_CARD, 1) || .
	for(var/card_id in list("base_frost", "base_fog", "base_rain"))
		. = ccg_add_seed_card(card_id, 1) || .

/datum/preferences/proc/ccg_ensure_base_pool()
	return ccg_seed_base_pool()

/datum/preferences/proc/ccg_add_seed_card(card_id, amount = 1)
	var/datum/ccg_card/card = ccg_card(card_id)
	if(!card)
		return FALSE
	amount = max(0, round(amount || 0))
	if(amount <= 0)
		return FALSE
	if((ccg_known_rare_cards[card_id] || 0) >= amount)
		return FALSE
	ccg_known_rare_cards[card_id] = max(ccg_known_rare_cards[card_id] || 0, amount)
	return TRUE

/datum/preferences/proc/ccg_starter_infantry_card_id()
	return CCG_STARTER_INFANTRY_CARD

/datum/preferences/proc/ccg_reset_collection(seed_base_pool = TRUE)
	ccg_known_rare_cards = list()
	ccg_selected_deck = list()
	ccg_saved_deck_cards = list()
	ccg_saved_deck_faction = CCG_FACTION_AZURIA
	ccg_saved_deck_leader = "azuria_ducal_marshal"
	ccg_saved_decks = list()
	ccg_active_deck_index = 1
	ccg_presets_are_virtual = TRUE
	if(seed_base_pool)
		ccg_seed_base_pool()
	ccg_normalize_saved_decks()
	return ccg_save()

/datum/preferences/proc/ccg_add_known_card(card_id)
	var/datum/ccg_card/card = ccg_card(card_id)
	if(!card)
		return FALSE
	ccg_clean_cards()
	var/count = ccg_known_rare_cards[card_id]
	if(!count)
		count = 0
	if(count >= ccg_card_pool_limit(card))
		return FALSE
	ccg_known_rare_cards[card_id] = count + 1
	if(!ccg_save_collection_sql())
		if(count > 0)
			ccg_known_rare_cards[card_id] = count
		else
			ccg_known_rare_cards -= card_id
		return FALSE
	return TRUE

/datum/preferences/proc/ccg_base_pool_required_count(card_id)
	if(card_id == ccg_starter_infantry_card_id())
		return 4
	if(card_id == CCG_STARTER_ARCHER_CARD)
		return 3
	if(card_id == CCG_STARTER_SIEGE_CARD || card_id == "base_clear")
		return 2
	if(card_id == CCG_STARTER_BLACKSMITH_CARD || card_id == CCG_STARTER_SCORCH_CARD || (card_id in list("base_frost", "base_fog", "base_rain")))
		return 1
	return 0

/datum/preferences/proc/ccg_export_known_card(card_id)
	var/current_count = ccg_card_pool_count(card_id)
	if(current_count <= ccg_base_pool_required_count(card_id))
		return FALSE
	ccg_known_rare_cards[card_id] = current_count - 1
	if(ccg_save_collection_sql())
		return TRUE
	ccg_known_rare_cards[card_id] = current_count
	return FALSE

/datum/preferences/proc/ccg_remove_known_cards_from_deck(list/card_ids)
	return TRUE

/datum/preferences/proc/ccg_take_pool_card(card_id)
	return TRUE

/datum/preferences/proc/ccg_return_pool_card(card_id)
	return TRUE

/datum/preferences/proc/ccg_sync_cards_from_inventory(mob/living/carbon/human/H)
	if(!H)
		return
	var/changed = FALSE
	for(var/atom/movable/thing in H.GetAllContents())
		if(istype(thing, /obj/item/ccg_card_single))
			var/obj/item/ccg_card_single/single = thing
			if(single.pooled)
				qdel(single)
				continue
			if(ccg_add_known_card(single.card_id))
				changed = TRUE
				qdel(single)
	if(changed)
		ccg_save_collection_sql()

/datum/preferences/proc/ccg_save_deck_snapshot(list/card_ids, faction_id = CCG_FACTION_AZURIA, leader_id = null)
	if(!islist(card_ids))
		return FALSE
	var/list/old_saved_deck_cards = islist(ccg_saved_deck_cards) ? ccg_saved_deck_cards.Copy() : list()
	var/old_saved_deck_faction = ccg_saved_deck_faction
	var/old_saved_deck_leader = ccg_saved_deck_leader
	var/list/old_saved_decks = islist(ccg_saved_decks) ? deepCopyList(ccg_saved_decks) : list()
	var/datum/ccg_faction/faction = ccg_faction(faction_id)
	if(!faction)
		faction = ccg_faction(CCG_FACTION_AZURIA)
	ccg_saved_deck_cards = list()
	var/list/saved_counts = list()
	for(var/card_id in card_ids)
		var/datum/ccg_card/card = ccg_card(card_id)
		if(!card || !ccg_card_allowed_for_faction(card_id, faction.id) || ccg_saved_deck_cards.len >= CCG_DECK_SIZE)
			continue
		var/saved_count = saved_counts[card_id]
		if(!saved_count)
			saved_count = 0
		if(saved_count >= ccg_card_deck_limit(card))
			continue
		saved_counts[card_id] = saved_count + 1
		ccg_saved_deck_cards += card_id
	ccg_saved_deck_faction = faction.id
	var/datum/ccg_leader/leader = ccg_leader(leader_id)
	ccg_saved_deck_leader = (leader && leader.faction == faction.id) ? leader.id : faction.default_leader
	ccg_store_active_deck(ccg_saved_deck_cards, ccg_saved_deck_faction, ccg_saved_deck_leader)
	if(!ccg_save_decks_sql())
		ccg_saved_deck_cards = old_saved_deck_cards
		ccg_saved_deck_faction = old_saved_deck_faction
		ccg_saved_deck_leader = old_saved_deck_leader
		ccg_saved_decks = old_saved_decks
		ccg_clean_cards()
		return FALSE
	return TRUE

/datum/preferences/proc/ccg_replace_active_deck_from_pool(list/card_ids, faction_id = CCG_FACTION_AZURIA, leader_id = null, deck_name = null)
	if(!islist(card_ids))
		return FALSE
	ccg_clean_cards()
	var/list/old_saved_deck_cards = islist(ccg_saved_deck_cards) ? ccg_saved_deck_cards.Copy() : list()
	var/old_saved_deck_faction = ccg_saved_deck_faction
	var/old_saved_deck_leader = ccg_saved_deck_leader
	var/list/old_saved_decks = islist(ccg_saved_decks) ? deepCopyList(ccg_saved_decks) : list()
	var/list/old_active_spec = ccg_saved_decks[ccg_active_deck_index]
	if(!istext(deck_name) || !length(deck_name))
		deck_name = islist(old_active_spec) ? old_active_spec["name"] : "Deck [ccg_active_deck_index]"
	var/list/spec = ccg_normalize_deck_spec(list(
		"name" = deck_name,
		"cards" = card_ids,
		"faction" = faction_id,
		"leader" = leader_id,
	), ccg_active_deck_index)
	var/list/import_cards = spec["cards"]
	var/list/needed_counts = list()
	for(var/card_id in import_cards)
		needed_counts[card_id] = (needed_counts[card_id] || 0) + 1
	for(var/card_id in needed_counts)
		if(needed_counts[card_id] > ccg_card_pool_count(card_id))
			ccg_saved_deck_cards = old_saved_deck_cards
			ccg_saved_deck_faction = old_saved_deck_faction
			ccg_saved_deck_leader = old_saved_deck_leader
			ccg_saved_decks = old_saved_decks
			return FALSE
	ccg_store_active_deck(import_cards, spec["faction"], spec["leader"], spec["name"])
	if(!ccg_save_decks_sql())
		ccg_saved_deck_cards = old_saved_deck_cards
		ccg_saved_deck_faction = old_saved_deck_faction
		ccg_saved_deck_leader = old_saved_deck_leader
		ccg_saved_decks = old_saved_decks
		ccg_clean_cards()
		return FALSE
	return TRUE

/datum/preferences/proc/ccg_set_active_deck(index)
	ccg_clean_cards()
	index = clamp(round(text2num("[index]") || 1), 1, length(ccg_saved_decks))
	ccg_active_deck_index = index
	ccg_load_active_deck()
	return ccg_save_decks_sql()

/datum/preferences/proc/ccg_create_deck()
	ccg_clean_cards()
	if(length(ccg_saved_decks) >= CCG_MAX_SAVED_DECKS)
		return FALSE
	ccg_saved_decks += list(ccg_default_deck_spec(length(ccg_saved_decks) + 1))
	ccg_active_deck_index = length(ccg_saved_decks)
	ccg_load_active_deck()
	return ccg_save_decks_sql()

/datum/preferences/proc/ccg_rename_active_deck(new_name)
	if(!istext(new_name))
		return FALSE
	new_name = trim(copytext(new_name, 1, 33))
	if(!length(new_name))
		return FALSE
	ccg_clean_cards()
	var/list/spec = ccg_saved_decks[ccg_active_deck_index]
	spec["name"] = new_name
	ccg_saved_decks[ccg_active_deck_index] = spec
	return ccg_save_decks_sql()

/datum/preferences/proc/ccg_set_view_mode(mode)
	if(!(mode in list(CCG_VIEW_SETUP, CCG_VIEW_DECK, CCG_VIEW_POOL)))
		return FALSE
	ccg_deckbuilder_view_mode = mode
	return ccg_save_decks_sql()

/datum/preferences/proc/ccg_first_deck_cards(faction_id = CCG_FACTION_AZURIA)
	ccg_clean_cards()
	var/datum/ccg_faction/faction = ccg_faction(faction_id)
	if(!faction)
		faction = ccg_faction(CCG_FACTION_AZURIA)
	var/list/deck_cards = list()
	var/list/pool_counts = islist(ccg_known_rare_cards) ? ccg_known_rare_cards.Copy() : list()
	for(var/card_id in GLOB.ccg_cards_by_id)
		if(deck_cards.len >= CCG_DECK_SIZE)
			break
		var/datum/ccg_card/card = ccg_card(card_id)
		if(!card || !ccg_card_allowed_for_faction(card_id, faction.id))
			continue
		var/available = min(ccg_card_deck_limit(card), max(0, pool_counts[card_id]))
		while(available > 0 && deck_cards.len < CCG_DECK_SIZE)
			deck_cards += card_id
			available--
	return deck_cards

/proc/ccg_sync_all_player_collections()
	for(var/client/C in GLOB.clients)
		var/mob/M = C.mob
		if(!istype(M, /mob/living/carbon/human) || !C.prefs)
			continue
		var/mob/living/carbon/human/H = M
		C.prefs.ccg_sync_cards_from_inventory(H)

/proc/ccg_is_stashed_deck(value)
	return value == /obj/item/ccg_deck/stashed || (islist(value) && islist(value[CCG_STASH_DECK_KEY]))

/proc/ccg_migrate_stashed_deck_specs(mob/user)
	if(!user?.mind?.special_items)
		return FALSE
	var/changed = FALSE
	for(var/item_name in user.mind.special_items)
		var/stash_value = user.mind.special_items[item_name]
		if(!islist(stash_value) || !islist(stash_value[CCG_STASH_DECK_KEY]))
			continue
		user.mind.special_items[item_name] = /obj/item/ccg_deck/stashed
		changed = TRUE
	return changed

/proc/ccg_mind_has_stashed_deck(datum/mind/mind)
	if(!mind?.special_items)
		return FALSE
	for(var/item_name in mind.special_items)
		if(ccg_is_stashed_deck(mind.special_items[item_name]))
			return TRUE
	return FALSE

/datum/preferences/proc/ccg_give_deck_item(mob/user)
	if(user?.stat == DEAD)
		to_chat(user, span_warning("The dead cannot take an Arlette deck."))
		return FALSE
	if(!ccg_require_sql(user))
		return FALSE
	ccg_clean_cards()
	if(!user?.mind)
		return FALSE
	if(user.mind.ccg_deck_requested)
		to_chat(user, span_warning("You have already taken an Arlette deck this round."))
		return FALSE
	var/list/deck_cards = length(ccg_saved_deck_cards) ? ccg_saved_deck_cards.Copy() : ccg_first_deck_cards(ccg_saved_deck_faction)
	while(deck_cards.len > CCG_DECK_SIZE)
		deck_cards.Cut(deck_cards.len, deck_cards.len + 1)
	if(!ccg_save_deck_snapshot(deck_cards, ccg_saved_deck_faction, ccg_saved_deck_leader))
		to_chat(user, span_warning("The Arlette deck failed to save. Try again."))
		return FALSE
	var/obj/item/ccg_deck/new_deck = new(get_turf(user))
	new_deck.set_faction(ccg_saved_deck_faction, ccg_saved_deck_leader)
	new_deck.set_cards(deck_cards)
	new_deck.owner_ckey = user.ckey
	var/owner_name = user.real_name || user.name
	if(owner_name)
		new_deck.name = "Card Deck of [owner_name]"
	new_deck.loaded_from_preferences = TRUE
	user.put_in_hands(new_deck)
	user.mind.ccg_deck_requested = TRUE
	to_chat(user, span_notice("You take an Arlette deck."))
	return TRUE

/datum/preferences/proc/ccg_open_preferences_deckbuilder(mob/user)
	if(!user?.client || !ccg_require_sql(user))
		return FALSE
	var/datum/ccg_deckbuilder_panel/panel = new()
	panel.ui_interact(user)
	return TRUE

/datum/preferences/proc/ccg_export_active_deck(mob/user)
	ccg_clean_cards()
	var/list/spec = ccg_active_deck_spec()
	var/export_json = json_encode(spec)
	var/export_text = input(user, "Copy this deck export.", "Arlette Deck Export", export_json) as null|message
	return !!export_text

/datum/preferences/proc/ccg_import_active_deck(mob/user)
	if(!user)
		return FALSE
	var/import_text = input(user, "Paste an Arlette deck export.", "Arlette Deck Import") as null|message
	if(!istext(import_text) || !length(import_text))
		return FALSE
	var/list/spec = safe_json_decode(import_text)
	if(!islist(spec))
		to_chat(user, span_warning("This is not a valid Arlette deck export."))
		return FALSE
	ccg_clean_cards()
	var/list/normalized = ccg_normalize_deck_spec(spec, ccg_active_deck_index)
	if(ccg_replace_active_deck_from_pool(normalized["cards"], normalized["faction"], normalized["leader"], normalized["name"]))
		to_chat(user, span_notice("The imported deck is saved into the active deck slot."))
		return TRUE
	to_chat(user, span_warning("Your pool is missing cards for this deck, or the imported deck failed to save."))
	return FALSE

/datum/ccg_deckbuilder_panel
	var/obj/item/ccg_deck/deck
	var/read_only = FALSE

/datum/ccg_deckbuilder_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/ccg_deckbuilder_panel/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/simple/ccg_cards))

/client/proc/ccg_migrate_saved_card_deck()
	ccg_migrate_stashed_deck_specs(mob)

/datum/ccg_deckbuilder_panel/ui_interact(mob/user, datum/tgui/ui)
	var/datum/preferences/P = user?.client?.prefs
	if(!P || !P.ccg_require_sql(user))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CardDeckBuilder", deck ? "Arlette Deck Builder" : "Arlette Decks")
		ui.open()

/datum/ccg_deckbuilder_panel/ui_data(mob/user)
	var/list/data = list()
	var/datum/preferences/P = user?.client?.prefs
	if(!P)
		return data
	if(!length(GLOB.ccg_cards_by_id))
		ccg_build_card_registry()
	P.ccg_clean_cards()
	if(!length(GLOB.ccg_factions_by_id))
		ccg_build_faction_registry()
	if(!length(GLOB.ccg_leaders_by_id))
		ccg_build_leader_registry()
	ccg_migrate_stashed_deck_specs(user)
	var/list/selected = deck ? deck.card_ids : P.ccg_saved_deck_cards
	var/current_faction_id = deck ? deck.faction_id : P.ccg_saved_deck_faction

	var/list/cards = list()
	var/list/known = P.ccg_known_cards()
	for(var/card_id in GLOB.ccg_cards_by_id)
		var/datum/ccg_card/card = ccg_card(card_id)
		if(!card)
			continue
		var/list/card_data = card.as_ui_data(card_id in known, card_id in selected)
		card_data["ownedCount"] = P.ccg_card_pool_count(card_id)
		card_data["deckCount"] = ccg_card_count_in_list(selected, card_id)
		card_data["deckLimit"] = ccg_card_deck_limit(card)
		card_data["poolLimit"] = ccg_card_pool_limit(card)
		card_data["factionAllowed"] = ccg_card_allowed_for_faction(card_id, current_faction_id)
		var/faction_name = "Common"
		var/datum/ccg_faction/card_faction
		if(card.faction == CCG_FACTION_NEUTRAL)
			faction_name = "Common"
		else
			card_faction = ccg_faction(card.faction)
			faction_name = card_faction ? card_faction.name : card.faction
		card_data["factionName"] = faction_name
		cards += list(card_data)

	data["mode"] = deck ? "build" : "pool"
	data["displayMode"] = read_only ? "deck" : P.ccg_deckbuilder_view_mode
	data["readOnly"] = read_only
	data["cards"] = cards
	data["selected"] = selected
	data["selectedCount"] = selected.len
	data["deckSize"] = CCG_DECK_SIZE
	data["faction"] = current_faction_id
	data["leader"] = deck ? deck.leader_id : P.ccg_saved_deck_leader
	data["activeDeckIndex"] = P.ccg_active_deck_index
	data["maxDecks"] = CCG_MAX_SAVED_DECKS
	var/list/saved_decks = list()
	var/deck_index = 1
	for(var/spec in P.ccg_saved_decks)
		var/list/cards_in_deck = islist(spec["cards"]) ? spec["cards"] : list()
		saved_decks += list(list(
			"index" = deck_index,
			"name" = spec["name"],
			"count" = cards_in_deck.len,
			"faction" = spec["faction"],
			"leader" = spec["leader"],
		))
		deck_index++
	data["decks"] = saved_decks
	var/list/factions = list()
	for(var/faction_id in GLOB.ccg_factions_by_id)
		var/datum/ccg_faction/faction = ccg_faction(faction_id)
		if(faction)
			factions += list(faction.as_ui_data())
	data["factions"] = factions
	var/list/leaders = list()
	for(var/leader_id in GLOB.ccg_leaders_by_id)
		var/datum/ccg_leader/leader = ccg_leader(leader_id)
		if(leader)
			leaders += list(leader.as_ui_data(FALSE))
	data["leaders"] = leaders
	var/known_rare_count = 0
	for(var/card_id in P.ccg_known_rare_cards)
		known_rare_count += P.ccg_known_rare_cards[card_id]
	data["knownRareCount"] = known_rare_count
	return data

/datum/ccg_deckbuilder_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = ui.user
	var/datum/preferences/P = user?.client?.prefs
	if(!P)
		return FALSE
	if(read_only || (deck && deck.owner_ckey != user?.ckey))
		return FALSE
	P.ccg_clean_cards()

	var/card_id = params["card"]
	var/list/target_cards = deck ? deck.card_ids : P.ccg_saved_deck_cards
	var/target_faction_id = deck ? deck.faction_id : P.ccg_saved_deck_faction
	var/target_leader_id = deck ? deck.leader_id : P.ccg_saved_deck_leader
	switch(action)
		if("add")
			if(!islist(target_cards) || target_cards.len >= CCG_DECK_SIZE)
				return TRUE
			var/datum/ccg_card/add_card = ccg_card(card_id)
			if(!add_card)
				return TRUE
			if(!ccg_card_allowed_for_faction(card_id, target_faction_id))
				return TRUE
			if(ccg_card_count_in_list(target_cards, card_id) >= P.ccg_available_for_deck(target_cards, card_id))
				return TRUE
			target_cards += card_id
			if(deck)
				deck.card_ids = target_cards
			if(!P.ccg_save_deck_snapshot(target_cards, target_faction_id, target_leader_id))
				target_cards.Cut(target_cards.len, target_cards.len + 1)
				if(deck)
					deck.card_ids = target_cards
				to_chat(user, span_warning("The card deck failed to save. The card was not added."))
			return TRUE
		if("remove")
			if(!islist(target_cards))
				return TRUE
			var/list/remove_old_cards = target_cards.Copy()
			while(card_id in target_cards)
				var/index = target_cards.Find(card_id)
				if(!index)
					break
				target_cards.Cut(index, index + 1)
			if(deck)
				deck.card_ids = target_cards
			if(!P.ccg_save_deck_snapshot(target_cards, target_faction_id, target_leader_id))
				target_cards = remove_old_cards
				if(deck)
					deck.card_ids = target_cards
				to_chat(user, span_warning("The card deck failed to save. The card was not removed."))
			return TRUE
		if("remove_one")
			if(!islist(target_cards))
				return TRUE
			var/index = target_cards.Find(card_id)
			if(index)
				var/list/remove_one_old_cards = target_cards.Copy()
				target_cards.Cut(index, index + 1)
				if(deck)
					deck.card_ids = target_cards
				if(!P.ccg_save_deck_snapshot(target_cards, target_faction_id, target_leader_id))
					target_cards = remove_one_old_cards
					if(deck)
						deck.card_ids = target_cards
					to_chat(user, span_warning("The card deck failed to save. The card was not removed."))
			return TRUE
		if("clear")
			if(!islist(target_cards))
				return TRUE
			var/list/clear_old_cards = target_cards.Copy()
			target_cards = list()
			if(deck)
				deck.card_ids = target_cards
			if(!P.ccg_save_deck_snapshot(target_cards, target_faction_id, target_leader_id))
				target_cards = clear_old_cards
				if(deck)
					deck.card_ids = target_cards
				to_chat(user, span_warning("The card deck failed to save. The deck was not cleared."))
			return TRUE
		if("set_faction")
			var/faction_id = params["faction"]
			var/datum/ccg_faction/faction = ccg_faction(faction_id)
			if(!faction)
				return TRUE
			var/old_faction_id = target_faction_id
			var/old_leader_id = target_leader_id
			var/list/old_card_ids = target_cards.Copy()
			var/list/kept_cards = list()
			for(var/checked_id in target_cards)
				if(ccg_card_allowed_for_faction(checked_id, faction.id))
					kept_cards += checked_id
			if(deck)
				deck.set_faction(faction.id, faction.default_leader)
				deck.card_ids = kept_cards
			if(!P.ccg_save_deck_snapshot(kept_cards, faction.id, faction.default_leader))
				if(deck)
					deck.set_faction(old_faction_id, old_leader_id)
					deck.card_ids = old_card_ids
				to_chat(user, span_warning("The card deck failed to save. The faction was not changed."))
			return TRUE
		if("set_leader")
			var/leader_id = params["leader"]
			var/old_leader_id = target_leader_id
			var/datum/ccg_leader/new_leader = ccg_leader(leader_id)
			if(!new_leader || new_leader.faction != target_faction_id)
				return TRUE
			if(deck)
				deck.set_faction(target_faction_id, leader_id)
			if(!P.ccg_save_deck_snapshot(target_cards, target_faction_id, leader_id))
				if(deck)
					deck.set_faction(target_faction_id, old_leader_id)
				to_chat(user, span_warning("The card deck failed to save. The leader was not changed."))
			return TRUE
		if("set_view")
			P.ccg_set_view_mode(params["view"])
			return TRUE
		if("select_deck")
			P.ccg_set_active_deck(params["index"])
			if(deck)
				deck.set_faction(P.ccg_saved_deck_faction, P.ccg_saved_deck_leader)
				deck.set_cards(P.ccg_saved_deck_cards)
			return TRUE
		if("create_deck")
			if(!P.ccg_create_deck())
				to_chat(user, span_warning("You cannot create another card deck."))
			return TRUE
		if("rename_deck")
			P.ccg_rename_active_deck(params["name"])
			return TRUE
		if("import_held_deck")
			var/obj/item/held_item = user.get_active_held_item()
			if(!istype(held_item, /obj/item/ccg_deck))
				held_item = user.get_inactive_held_item()
			if(!istype(held_item, /obj/item/ccg_deck))
				to_chat(user, span_warning("Hold an Arlette deck to import it."))
				return TRUE
			var/obj/item/ccg_deck/held_deck = held_item
			if(P.ccg_replace_active_deck_from_pool(held_deck.card_ids, held_deck.faction_id, held_deck.leader_id))
				to_chat(user, span_notice("The held card deck is imported into the active saved deck."))
			else
				to_chat(user, span_warning("The held card deck failed to import."))
			return TRUE
		if("export_deck")
			P.ccg_export_active_deck(user)
			return TRUE
		if("import_deck")
			P.ccg_import_active_deck(user)
			if(deck)
				deck.set_faction(P.ccg_saved_deck_faction, P.ccg_saved_deck_leader)
				deck.set_cards(P.ccg_saved_deck_cards)
			return TRUE
		if("load_saved_deck")
			if(deck)
				deck.set_faction(P.ccg_saved_deck_faction, P.ccg_saved_deck_leader)
				deck.set_cards(P.ccg_saved_deck_cards)
				to_chat(user, span_notice("The saved card deck is loaded into this deck."))
			return TRUE
		if("save_physical_deck")
			if(deck)
				P.ccg_save_deck_snapshot(deck.card_ids, deck.faction_id, deck.leader_id)
				to_chat(user, span_notice("This card deck is saved."))
			return TRUE
		if("take_card")
			if(!deck)
				return TRUE
			var/card_index = deck.card_ids.Find(card_id)
			if(!card_index)
				return TRUE
			if(!P.ccg_export_known_card(card_id))
				to_chat(user, span_warning("This card cannot be taken from your collection."))
				return TRUE
			deck.card_ids.Cut(card_index, card_index + 1)
			if(!P.ccg_save_deck_snapshot(deck.card_ids, deck.faction_id, deck.leader_id))
				deck.card_ids.Insert(card_index, card_id)
				P.ccg_add_known_card(card_id)
				to_chat(user, span_warning("The card deck failed to save. The card was not removed."))
				return TRUE
			var/obj/item/ccg_card_single/single = new(get_turf(user))
			single.set_card(card_id)
			single.source_ckey = user.ckey
			user.put_in_hands(single)
			return TRUE
	return FALSE

/proc/ccg_admin_execute_sql(sql, list/arguments = null)
	if(!SSdbcore.Connect())
		return FALSE
	var/datum/DBQuery/query = SSdbcore.NewQuery(sql, arguments)
	if(!query)
		return FALSE
	var/success = query.Execute(async = FALSE)
	qdel(query)
	return success

/proc/ccg_admin_online_preferences(target_ckey)
	var/mob/target = ccg_find_mob_by_ckey(target_ckey)
	var/datum/preferences/P = target?.client?.prefs
	if(P && !P.ccg_load_or_migrate_sql())
		return null
	return P

/proc/ccg_admin_change_card_amount(target_ckey, card_id, change)
	if(!target_ckey || !ccg_card(card_id) || !change || !SSdbcore.Connect())
		return null
	var/datum/preferences/P = ccg_admin_online_preferences(target_ckey)
	if(GLOB.directory[target_ckey] && !P)
		return null
	if(change > 0)
		if(!ccg_admin_execute_sql({"
			INSERT INTO [format_table_name("ccg_collection")] (ckey, card_id, amount)
			VALUES (:ckey, :card_id, :amount)
			ON DUPLICATE KEY UPDATE amount = amount + :amount
		"}, list("ckey" = target_ckey, "card_id" = card_id, "amount" = change)))
			return null
		if(P)
			P.ccg_known_rare_cards[card_id] = (P.ccg_known_rare_cards[card_id] || 0) + change
		return change
	var/datum/DBQuery/query = SSdbcore.NewQuery("SELECT amount FROM [format_table_name("ccg_collection")] WHERE ckey = :ckey AND card_id = :card_id", list("ckey" = target_ckey, "card_id" = card_id))
	if(!query || !query.Execute(async = FALSE) || !query.NextRow())
		qdel(query)
		return 0
	var/current_amount = round(text2num("[query.item[1]]") || 0)
	qdel(query)
	var/removed = min(abs(change), current_amount)
	if(!removed)
		return 0
	var/remaining_amount = current_amount - removed
	var/success
	if(remaining_amount)
		success = ccg_admin_execute_sql("UPDATE [format_table_name("ccg_collection")] SET amount = :amount WHERE ckey = :ckey AND card_id = :card_id", list("ckey" = target_ckey, "card_id" = card_id, "amount" = remaining_amount))
	else
		success = ccg_admin_execute_sql("DELETE FROM [format_table_name("ccg_collection")] WHERE ckey = :ckey AND card_id = :card_id", list("ckey" = target_ckey, "card_id" = card_id))
	if(!success)
		return null
	if(P)
		if(remaining_amount)
			P.ccg_known_rare_cards[card_id] = remaining_amount
		else
			P.ccg_known_rare_cards -= card_id
	return -removed

/client/proc/ccg_admin_management()
	set name = "Arlette Management"
	set category = "Admin.Admin"
	set desc = "Manage Arlette collections and saved decks."
	if(!check_rights(R_ADMIN))
		return
	holder?.ccg_management_panel()

/datum/admins/proc/ccg_management_panel(target_ckey = null)
	if(!check_rights(R_ADMIN))
		return
	if(!SSdbcore.Connect())
		to_chat(usr, span_warning("The card collection database is unavailable."))
		return
	var/list/html = list("<!DOCTYPE html><html><body><style>body{margin:14px;background:#15171d;color:#d9dce5;font-family:Verdana,sans-serif;font-size:12px}h2,h3{margin:0}header{display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;padding:10px 12px;background:#232834;border-left:4px solid #c39b55}table{border-collapse:collapse;width:100%;background:#1d212b}th{position:sticky;top:0;background:#303747;color:#fff;text-align:left}th,td{border:1px solid #3e4658;padding:7px}tr:nth-child(even){background:#202631}.count{font-weight:bold;text-align:center;width:64px}.actions{white-space:nowrap;width:135px}a{color:#e0b96c;text-decoration:none;margin-right:7px}.control{display:inline-block;min-width:20px;text-align:center;padding:2px 5px;border:1px solid #69758b;background:#2b3240}.danger{color:#ff9c9c}.muted{color:#a6adbc}.toolbar{margin:12px 0}</style>")
	if(target_ckey)
		html += "<header><div><h2>Arlette Management</h2><span class='muted'>Player collection</span></div><a href='?src=[REF(src)];[HrefToken()];ccg_manage=index'>Players</a></header>"
		html += "<h3>[html_encode(target_ckey)]</h3>"
		html += "<p class='toolbar'><a href='?src=[REF(src)];[HrefToken()];ccg_manage=clear_collection;ckey=[url_encode(target_ckey)]' class='danger'>Clear collection</a>"
		html += "<a href='?src=[REF(src)];[HrefToken()];ccg_manage=clear_decks;ckey=[url_encode(target_ckey)]' class='danger'>Clear saved decks</a></p>"
		var/datum/DBQuery/cards_query = SSdbcore.NewQuery("SELECT card_id, amount FROM [format_table_name("ccg_collection")] WHERE ckey = :ckey ORDER BY card_id ASC", list("ckey" = target_ckey))
		if(!cards_query || !cards_query.Execute(async = FALSE))
			qdel(cards_query)
			to_chat(usr, span_warning("The card collection query failed. Check the SQL log."))
			return
		var/list/card_amounts = list()
		while(cards_query.NextRow())
			card_amounts[cards_query.item[1]] = round(text2num("[cards_query.item[2]]") || 0)
		qdel(cards_query)
		if(!length(GLOB.ccg_cards_by_id))
			ccg_build_card_registry()
		var/list/card_ids = list()
		for(var/registered_card_id in GLOB.ccg_cards_by_id)
			card_ids += registered_card_id
		card_ids = sortList(card_ids)
		html += "<table><tr><th>Card</th><th class='count'>Amount</th><th class='actions'>Actions</th></tr>"
		for(var/card_id in card_ids)
			var/datum/ccg_card/card = ccg_card(card_id)
			if(!card)
				continue
			var/card_name = html_encode(card.name)
			var/amount = card_amounts[card_id] || 0
			html += "<tr><td>[card_name] <span class='muted'>([html_encode(card_id)])</span></td><td class='count'>[amount]</td>"
			html += "<td class='actions'><a class='control' href='?src=[REF(src)];[HrefToken()];ccg_manage=change;ckey=[url_encode(target_ckey)];card_id=[url_encode(card_id)];amount=-1'>-</a>"
			html += "<a class='control' href='?src=[REF(src)];[HrefToken()];ccg_manage=change;ckey=[url_encode(target_ckey)];card_id=[url_encode(card_id)];amount=1'>+</a></td></tr>"
		html += "</table>"
	else
		var/datum/DBQuery/players_query = SSdbcore.NewQuery({"
			SELECT ckey FROM [format_table_name("ccg_settings")]
			UNION SELECT ckey FROM [format_table_name("ccg_collection")]
			UNION SELECT ckey FROM [format_table_name("ccg_decks")]
			ORDER BY ckey ASC
		"})
		if(!players_query || !players_query.Execute(async = FALSE))
			qdel(players_query)
			to_chat(usr, span_warning("The card collection database is unavailable."))
			return
		html += "<header><div><h2>Arlette Management</h2><span class='muted'>Stored player collections</span></div></header><table><tr><th>Ckey</th><th class='actions'>Actions</th></tr>"
		while(players_query.NextRow())
			var/player_ckey = players_query.item[1]
			html += "<tr><td><a href='?src=[REF(src)];[HrefToken()];ccg_manage=view;ckey=[url_encode(player_ckey)]'>[html_encode(player_ckey)]</a></td>"
			html += "<td class='actions'><a class='danger' href='?src=[REF(src)];[HrefToken()];ccg_manage=clear_collection;ckey=[url_encode(player_ckey)]'>Clear collection</a></td></tr>"
		qdel(players_query)
		html += "</table>"
	html += "</body></html>"
	usr << browse(jointext(html, ""), "window=ccg_admin_management;size=800x650")

/datum/admins/proc/ccg_management_topic(list/href_list)
	if(!check_rights(R_ADMIN))
		return
	var/action = href_list["ccg_manage"]
	var/target_ckey = ckey(href_list["ckey"])
	if(action == "index")
		ccg_management_panel()
		return
	if(!target_ckey)
		return
	if(action == "view")
		ccg_management_panel(target_ckey)
		return
	if(action == "add")
		var/added_card_id = owner.ccg_admin_choose_card("Add Arlette Card")
		if(added_card_id && !isnull(ccg_admin_change_card_amount(target_ckey, added_card_id, 1)))
			log_admin("[key_name(usr)] added 1 x [added_card_id] to Arlette collection of [target_ckey].")
			message_admins("[key_name_admin(usr)] added 1 x [added_card_id] to Arlette collection of [target_ckey].")
		ccg_management_panel(target_ckey)
		return
	if(action == "change")
		var/changed_card_id = href_list["card_id"]
		var/change_amount = clamp(text2num(href_list["amount"]), -1, 1)
		var/changed = ccg_admin_change_card_amount(target_ckey, changed_card_id, change_amount)
		if(changed)
			log_admin("[key_name(usr)] changed Arlette card [changed_card_id] by [changed] for [target_ckey].")
			message_admins("[key_name_admin(usr)] changed Arlette card [changed_card_id] by [changed] for [target_ckey].")
		ccg_management_panel(target_ckey)
		return
	if(action == "clear_collection")
		if(alert(usr, "Delete every Arlette card for [target_ckey]? Starter cards will be restored on their next Arlette load.", "Clear Arlette Collection", "Delete", "Cancel") == "Delete")
			var/datum/preferences/collection_prefs = ccg_admin_online_preferences(target_ckey)
			if((!GLOB.directory[target_ckey] || collection_prefs) && ccg_admin_execute_sql("DELETE FROM [format_table_name("ccg_collection")] WHERE ckey = :ckey", list("ckey" = target_ckey)))
				if(collection_prefs)
					collection_prefs.ccg_known_rare_cards = list()
				log_admin("[key_name(usr)] cleared Arlette collection for [target_ckey].")
				message_admins("[key_name_admin(usr)] cleared Arlette collection for [target_ckey].")
		ccg_management_panel(target_ckey)
		return
	if(action == "clear_decks")
		if(alert(usr, "Delete all saved Arlette deck presets for [target_ckey]?", "Clear Arlette Decks", "Delete", "Cancel") == "Delete")
			var/datum/preferences/deck_prefs = ccg_admin_online_preferences(target_ckey)
			var/success = (!GLOB.directory[target_ckey] || deck_prefs) && ccg_admin_execute_sql("START TRANSACTION")
			success = success && ccg_admin_execute_sql("DELETE FROM [format_table_name("ccg_deck_cards")] WHERE ckey = :ckey", list("ckey" = target_ckey))
			success = success && ccg_admin_execute_sql("DELETE FROM [format_table_name("ccg_decks")] WHERE ckey = :ckey", list("ckey" = target_ckey))
			if(success)
				ccg_admin_execute_sql("COMMIT")
				if(deck_prefs)
					deck_prefs.ccg_saved_decks = list()
					deck_prefs.ccg_saved_deck_cards = list()
				log_admin("[key_name(usr)] cleared saved Arlette decks for [target_ckey].")
				message_admins("[key_name_admin(usr)] cleared saved Arlette decks for [target_ckey].")
			else
				ccg_admin_execute_sql("ROLLBACK")
		ccg_management_panel(target_ckey)

/client/proc/ccg_admin_target_ckey(prompt)
	var/target_ckey = ckey(input(src, "Enter the player's ckey.", prompt) as null|text)
	return target_ckey

/client/proc/ccg_admin_choose_card(prompt)
	if(!length(GLOB.ccg_cards_by_id))
		ccg_build_card_registry()
	var/list/card_choices = list()
	for(var/card_id in GLOB.ccg_cards_by_id)
		var/datum/ccg_card/card = ccg_card(card_id)
		if(card)
			card_choices["[card.name] ([card_id])"] = card_id
	var/choice = input(src, "Choose a card.", prompt) as null|anything in sortList(card_choices)
	return choice ? card_choices[choice] : null

/client/proc/ccg_admin_show_collection()
	set name = "Inspect Arlette Cards"
	set category = "Admin.Admin"
	set desc = "Show a player's Arlette card collection from SQL."
	if(!check_rights(R_ADMIN))
		return
	var/target_ckey = ccg_admin_target_ckey("Inspect Arlette Cards")
	if(!target_ckey || !SSdbcore.Connect())
		return
	var/datum/DBQuery/query = SSdbcore.NewQuery({"
		SELECT card_id, amount
		FROM [format_table_name("ccg_collection")]
		WHERE ckey = :ckey
		ORDER BY card_id ASC
	"}, list("ckey" = target_ckey))
	if(!query || !query.Execute(async = FALSE))
		qdel(query)
		to_chat(src, span_warning("The card collection database is unavailable."))
		return
	var/list/lines = list("Arlette collection for [target_ckey]:")
	while(query.NextRow())
		var/card_id = query.item[1]
		var/datum/ccg_card/card = ccg_card(card_id)
		lines += "[card ? card.name : card_id] ([card_id]): [query.item[2]]"
	qdel(query)
	if(lines.len == 1)
		lines += "No cards stored."
	src << browse("<pre>[jointext(lines, "\n")]</pre>", "window=ccg_admin_collection;size=500x600")
	log_admin("[key_name(usr)] inspected Arlette collection for [target_ckey].")

/client/proc/ccg_admin_give_card()
	set name = "Give Arlette Card"
	set category = "Admin.Admin"
	set desc = "Add a card to a player's Arlette collection in SQL."
	if(!check_rights(R_ADMIN))
		return
	var/target_ckey = ccg_admin_target_ckey("Give Arlette Card")
	if(!target_ckey)
		return
	var/card_id = ccg_admin_choose_card("Give Arlette Card")
	if(!card_id)
		return
	var/input_amount = input(src, "How many copies?", "Give Arlette Card", 1) as null|num
	if(isnull(input_amount))
		return
	var/amount = clamp(round(input_amount), 1, 100)
	var/datum/preferences/P = ccg_admin_online_preferences(target_ckey)
	if(GLOB.directory[target_ckey] && !P)
		to_chat(src, span_warning("The target's card state could not be loaded."))
		return
	if(!ccg_admin_execute_sql({"
		INSERT INTO [format_table_name("ccg_collection")] (ckey, card_id, amount)
		VALUES (:ckey, :card_id, :amount)
		ON DUPLICATE KEY UPDATE amount = amount + :amount
	"}, list("ckey" = target_ckey, "card_id" = card_id, "amount" = amount)))
		to_chat(src, span_warning("The card could not be written to SQL."))
		return
	if(P)
		P.ccg_known_rare_cards[card_id] = (P.ccg_known_rare_cards[card_id] || 0) + amount
	var/datum/ccg_card/card = ccg_card(card_id)
	to_chat(src, span_notice("Added [amount] x [card ? card.name : card_id] to [target_ckey]."))
	log_admin("[key_name(usr)] gave [amount] x [card_id] to Arlette collection of [target_ckey].")
	message_admins("[key_name_admin(usr)] gave [amount] x [card_id] to Arlette collection of [target_ckey].")

/client/proc/ccg_admin_take_card()
	set name = "Take Arlette Card"
	set category = "Admin.Admin"
	set desc = "Remove copies of a card from a player's Arlette collection in SQL."
	if(!check_rights(R_ADMIN))
		return
	var/target_ckey = ccg_admin_target_ckey("Take Arlette Card")
	if(!target_ckey)
		return
	var/card_id = ccg_admin_choose_card("Take Arlette Card")
	if(!card_id)
		return
	var/input_amount = input(src, "How many copies?", "Take Arlette Card", 1) as null|num
	if(isnull(input_amount) || !SSdbcore.Connect())
		return
	var/amount = clamp(round(input_amount), 1, 100)
	var/datum/preferences/P = ccg_admin_online_preferences(target_ckey)
	if(GLOB.directory[target_ckey] && !P)
		to_chat(src, span_warning("The target's card state could not be loaded."))
		return
	var/datum/DBQuery/load_query = SSdbcore.NewQuery("SELECT amount FROM [format_table_name("ccg_collection")] WHERE ckey = :ckey AND card_id = :card_id", list("ckey" = target_ckey, "card_id" = card_id))
	if(!load_query || !load_query.Execute(async = FALSE) || !load_query.NextRow())
		qdel(load_query)
		to_chat(src, span_warning("[target_ckey] does not have that card."))
		return
	var/current_amount = round(text2num("[load_query.item[1]]") || 0)
	qdel(load_query)
	var/taken_amount = min(amount, current_amount)
	var/remaining_amount = current_amount - taken_amount
	var/success
	if(remaining_amount)
		success = ccg_admin_execute_sql("UPDATE [format_table_name("ccg_collection")] SET amount = :amount WHERE ckey = :ckey AND card_id = :card_id", list("ckey" = target_ckey, "card_id" = card_id, "amount" = remaining_amount))
	else
		success = ccg_admin_execute_sql("DELETE FROM [format_table_name("ccg_collection")] WHERE ckey = :ckey AND card_id = :card_id", list("ckey" = target_ckey, "card_id" = card_id))
	if(!success)
		to_chat(src, span_warning("The card could not be removed from SQL."))
		return
	if(P)
		if(remaining_amount)
			P.ccg_known_rare_cards[card_id] = remaining_amount
		else
			P.ccg_known_rare_cards -= card_id
	var/datum/ccg_card/card = ccg_card(card_id)
	to_chat(src, span_notice("Removed [taken_amount] x [card ? card.name : card_id] from [target_ckey]."))
	log_admin("[key_name(usr)] took [taken_amount] x [card_id] from Arlette collection of [target_ckey].")
	message_admins("[key_name_admin(usr)] took [taken_amount] x [card_id] from Arlette collection of [target_ckey].")

/client/proc/ccg_admin_clear_collection()
	set name = "Clear Arlette Collection"
	set category = "Admin.Admin"
	set desc = "Delete every stored Arlette card for a player."
	if(!check_rights(R_ADMIN))
		return
	var/target_ckey = ccg_admin_target_ckey("Clear Arlette Collection")
	if(!target_ckey)
		return
	if(alert(src, "Delete every Arlette card for [target_ckey]? Starter cards will be restored on their next Arlette load.", "Clear Arlette Collection", "Delete", "Cancel") != "Delete")
		return
	var/datum/preferences/P = ccg_admin_online_preferences(target_ckey)
	if(GLOB.directory[target_ckey] && !P)
		to_chat(src, span_warning("The target's card state could not be loaded."))
		return
	if(!ccg_admin_execute_sql("DELETE FROM [format_table_name("ccg_collection")] WHERE ckey = :ckey", list("ckey" = target_ckey)))
		to_chat(src, span_warning("The collection could not be cleared in SQL."))
		return
	if(P)
		P.ccg_known_rare_cards = list()
	to_chat(src, span_notice("Cleared Arlette collection for [target_ckey]."))
	log_admin("[key_name(usr)] cleared Arlette collection for [target_ckey].")
	message_admins("[key_name_admin(usr)] cleared Arlette collection for [target_ckey].")

/client/proc/ccg_admin_clear_decks()
	set name = "Clear Arlette Decks"
	set category = "Admin.Admin"
	set desc = "Delete every saved Arlette deck preset for a player."
	if(!check_rights(R_ADMIN))
		return
	var/target_ckey = ccg_admin_target_ckey("Clear Arlette Decks")
	if(!target_ckey)
		return
	if(alert(src, "Delete all saved Arlette deck presets for [target_ckey]?", "Clear Arlette Decks", "Delete", "Cancel") != "Delete")
		return
	var/datum/preferences/P = ccg_admin_online_preferences(target_ckey)
	if(GLOB.directory[target_ckey] && !P)
		to_chat(src, span_warning("The target's card state could not be loaded."))
		return
	var/success = ccg_admin_execute_sql("START TRANSACTION")
	success = success && ccg_admin_execute_sql("DELETE FROM [format_table_name("ccg_deck_cards")] WHERE ckey = :ckey", list("ckey" = target_ckey))
	success = success && ccg_admin_execute_sql("DELETE FROM [format_table_name("ccg_decks")] WHERE ckey = :ckey", list("ckey" = target_ckey))
	if(success)
		success = ccg_admin_execute_sql("COMMIT")
	else
		ccg_admin_execute_sql("ROLLBACK")
	if(!success)
		to_chat(src, span_warning("The saved decks could not be cleared in SQL."))
		return
	if(P)
		P.ccg_saved_decks = list()
		P.ccg_saved_deck_cards = list()
	to_chat(src, span_notice("Cleared saved Arlette decks for [target_ckey]."))
	log_admin("[key_name(usr)] cleared saved Arlette decks for [target_ckey].")
	message_admins("[key_name_admin(usr)] cleared saved Arlette decks for [target_ckey].")

/mob/living/verb/open_ccg_deck()
	set name = "Arlette Deck"
	set category = "IC"
	if(!client)
		return
	if(stat == DEAD)
		to_chat(src, span_warning("The dead cannot take an Arlette deck."))
		return
	client.prefs?.ccg_give_deck_item(src)

/client/proc/ccg_open_deckbuilder(obj/item/ccg_deck/deck, mob/user = mob, read_only = FALSE)
	if(!user || !deck)
		return
	var/datum/preferences/P = prefs
	if(!P || !P.ccg_require_sql(user))
		return
	var/datum/ccg_deckbuilder_panel/panel = new()
	panel.deck = deck
	panel.read_only = read_only || deck.owner_ckey != user.ckey
	panel.ui_interact(user)

#undef CCG_STASH_DECK_KEY
#undef CCG_STASH_FACTION_KEY
#undef CCG_STASH_LEADER_KEY
#undef CCG_STARTER_INFANTRY_CARD
#undef CCG_STARTER_ARCHER_CARD
#undef CCG_STARTER_SIEGE_CARD
#undef CCG_STARTER_BLACKSMITH_CARD
#undef CCG_STARTER_SCORCH_CARD
