// Faction cards: azuria (shown in-game as Rockhill).

/datum/ccg_card/rare_captain
	id = "rare_captain"
	name = "Field Captain"
	desc = "Morale boost for the row."
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_AZURIA
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/azuria_field_captain.png"

/datum/ccg_card/unique_spy
	id = "unique_spy"
	name = "Court Spy"
	desc = "Played on the enemy side; draws two cards."
	row = CCG_ROW_INFANTRY
	power = 1
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_AZURIA
	effect = CCG_EFFECT_SPY
	art = "ccg_cards/azuria_court_spy.png"

/datum/ccg_card/rare_azuria_knight
	id = "rare_azuria_knight"
	name = "Ducal Knight"
	desc = "High-fantasy Gwent-style Rockhillian heavy cavalry. Bonds with other Ducal Knights."
	row = CCG_ROW_INFANTRY
	power = 6
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_AZURIA
	effect = CCG_EFFECT_BOND
	art = "ccg_cards/azuria_knight.png"

/datum/ccg_card/rare_azuria_squire
	id = "rare_azuria_squire"
	name = "Squire at Arms"
	desc = "A young retinue fighter holding the line for the court."
	row = CCG_ROW_INFANTRY
	power = 4
	rarity = CCG_RARITY_BASE
	faction = CCG_FACTION_AZURIA
	limited = TRUE
	art = "ccg_cards/azuria_squire.png"

/datum/ccg_card/rare_azuria_court_magician
	id = "rare_azuria_court_magician"
	name = "Court Magician"
	desc = "Rockhillian arcyne support that clears the skies for the host."
	row = CCG_ROW_ARCHERS
	power = 3
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_AZURIA
	effect = CCG_EFFECT_CLEAR_WEATHER
	art = "ccg_cards/azuria_court_magician.png"

/datum/ccg_card/rare_azuria_azurcaephan
	id = "rare_azuria_azurcaephan"
	name = "Rockhillian Caephan"
	desc = "Rockhillian spellblade tradition, channeling arcyne momentum through the melee."
	row = CCG_ROW_INFANTRY
	power = 6
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_AZURIA
	effect = CCG_EFFECT_AGILE
	art = "ccg_cards/azuria_azurcaephan.png"

/datum/ccg_card/rare_azuria_grovewalker
	id = "rare_azuria_grovewalker"
	name = "Rockhillian Grovewalker"
	desc = "Black Oak guardian-errant moving with autumn grace through the wilds."
	row = CCG_ROW_ARCHERS
	power = 4
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_AZURIA
	effect = CCG_EFFECT_CLEAR_WEATHER
	art = "ccg_cards/azuria_grovewalker.png"

/datum/ccg_card/unique_azuria_grand_duke
	id = "unique_azuria_grand_duke"
	name = "Grand Duke"
	desc = "Hero. The ducal banner gathers the infantry line."
	row = CCG_ROW_INFANTRY
	power = 8
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_AZURIA
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/azuria_grand_duke.png"
	hero = TRUE

/datum/ccg_card/unique_azuria_imperial_spellblade
	id = "unique_azuria_imperial_spellblade"
	name = "Imperial Spellblade"
	desc = "Hero. A high-fantasy bladecaster from the Rockhill tradition."
	row = CCG_ROW_INFANTRY
	power = 7
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_AZURIA
	effect = CCG_EFFECT_AGILE
	art = "ccg_cards/azuria_imperial_spellblade.png"
	hero = TRUE
