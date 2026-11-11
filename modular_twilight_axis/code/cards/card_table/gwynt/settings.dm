// Arlette (Gwynt) is fully physical on Ratwood: a deck is an item that holds its own cards,
// cards are items you find, trade and slot into decks, and nothing is saved between rounds.

#define CCG_DECK_SIZE 30
#define CCG_MIN_DECK_SIZE 12

/datum/preferences
	/// Whether this player hears the Arlette soundtrack during matches. Only lasts for the round.
	var/ccg_soundtrack_enabled = FALSE

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

/proc/ccg_card_count_in_list(list/card_ids, card_id)
	var/count = 0
	if(!islist(card_ids))
		return 0
	for(var/selected_id in card_ids)
		if(selected_id == card_id)
			count++
	return count

/// The common card each faction's starter deck leads with.
/proc/ccg_faction_starter_card(faction_id)
	switch(faction_id)
		if(CCG_FACTION_AZURIA)
			return "rare_azuria_squire"
		if(CCG_FACTION_ENIGMA)
			return "rare_enigma_royal_guard"
		if(CCG_FACTION_NALEDI)
			return "rare_naledi_sojourner"
		if(CCG_FACTION_GRENZELHOFT)
			return "rare_grenzelhoft_halberdier"
		if(CCG_FACTION_RANESHI)
			return "rare_raneshi_azeb_guard"
		if(CCG_FACTION_GRONN)
			return "rare_berserker"
		if(CCG_FACTION_KAZENGUN)
			return "rare_kazengun_ronin"
	return null

/// A playable 27 card deck of common cards for the given faction.
/proc/ccg_starter_deck_cards(faction_id)
	var/list/recipe = list(
		"base_scout" = 3,
		"base_militia" = 3,
		"base_swordsman" = 2,
		"base_archer" = 2,
		"base_catapult" = 2,
		"base_mangonel" = 2,
		"base_field_medic" = 2,
		"base_shieldman" = 1,
		"base_blacksmith" = 1,
		"base_frost" = 1,
		"base_fog" = 1,
		"base_rain" = 1,
		"base_clear" = 1,
		"base_scorch" = 1,
		"base_decoy" = 1,
	)
	var/list/cards = list()
	var/faction_card = ccg_faction_starter_card(faction_id)
	if(faction_card)
		for(var/i in 1 to 3)
			cards += faction_card
	for(var/card_id in recipe)
		for(var/i in 1 to recipe[card_id])
			cards += card_id
	return cards

/// One line per distinct card, e.g. "3x Scout (Archers, 4)".
/proc/ccg_describe_card_list(list/card_ids)
	var/list/counts = list()
	for(var/card_id in card_ids)
		counts[card_id] = (counts[card_id] || 0) + 1
	var/list/lines = list()
	for(var/card_id in counts)
		var/datum/ccg_card/card = ccg_card(card_id)
		if(!card)
			continue
		var/power_text = (card.row == CCG_ROW_WEATHER || card.row == CCG_ROW_SPECIAL) ? "" : ", [card.power]"
		lines += "[counts[card_id]]x [card.name] ([ccg_row_label(card.row)][power_text])"
	return lines

/proc/ccg_row_label(row)
	switch(row)
		if(CCG_ROW_INFANTRY)
			return "Infantry"
		if(CCG_ROW_ARCHERS)
			return "Archers"
		if(CCG_ROW_SIEGE)
			return "Siege"
		if(CCG_ROW_WEATHER)
			return "Weather"
		if(CCG_ROW_SPECIAL)
			return "Special"
	return capitalize(row)

/proc/ccg_rarity_label(rarity)
	switch(rarity)
		if(CCG_RARITY_RARE)
			return "Rare"
		if(CCG_RARITY_UNIQUE)
			return "Unique"
	return "Common"

/proc/ccg_find_mob_by_ckey(ckey)
	if(!ckey)
		return null
	for(var/client/C)
		if(C.ckey == ckey)
			return C.mob
	return null
