// Faction cards: enigma.

/datum/ccg_card/rare_saboteur
	id = "rare_saboteur"
	name = "Saboteur"
	desc = "Destroys the strongest enemy unit."
	row = CCG_ROW_ARCHERS
	power = 2
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_ENIGMA
	effect = CCG_EFFECT_SCORCH_GLOBAL
	art = "ccg_cards/enigma_saboteur.png"

/datum/ccg_card/unique_avenger
	id = "unique_avenger"
	name = "Avenger"
	desc = "When the round ends, calls a stronger warrior before leaving."
	row = CCG_ROW_INFANTRY
	power = 6
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_ENIGMA
	effect = CCG_EFFECT_AVENGER
	avenger_card = "unique_enigma_revenant"
	art = "ccg_cards/enigma_avenger.png"
	hero = TRUE

/datum/ccg_card/unique_enigma_revenant
	id = "unique_enigma_revenant"
	name = "Avenger Revenant"
	desc = "A called Enigma champion."
	row = CCG_ROW_INFANTRY
	power = 10
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_ENIGMA
	art = "ccg_cards/enigma_revenant.png"
	hero = TRUE

/datum/ccg_card/rare_enigma_royal_guard
	id = "rare_enigma_royal_guard"
	name = "Royal Guard"
	desc = "Disciplined Enigma retinue infantry. Bonds with other Royal Guards."
	row = CCG_ROW_INFANTRY
	power = 3
	rarity = CCG_RARITY_BASE
	faction = CCG_FACTION_ENIGMA
	effect = CCG_EFFECT_BOND
	limited = TRUE
	art = "ccg_cards/enigma_royal_guard.png"

/datum/ccg_card/rare_enigma_vanguard_archer
	id = "rare_enigma_vanguard_archer"
	name = "Vanguard Archer"
	desc = "Frontier archer trained to break enemy pushes."
	row = CCG_ROW_ARCHERS
	power = 4
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_ENIGMA
	effect = CCG_EFFECT_SCORCH_INFANTRY
	art = "ccg_cards/enigma_vanguard_archer.png"

/datum/ccg_card/rare_enigma_standard_bearer
	id = "rare_enigma_standard_bearer"
	name = "Vanguard Standard Bearer"
	desc = "A standard-bearer that doubles the infantry row."
	row = CCG_ROW_INFANTRY
	power = 0
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_ENIGMA
	effect = CCG_EFFECT_HORN
	target_row = CCG_ROW_INFANTRY
	art = "ccg_cards/enigma_standard_bearer.png"

/datum/ccg_card/unique_enigma_overseer
	id = "unique_enigma_overseer"
	name = "Overseer"
	desc = "Hero. An Enigma field commander who preserves order with iron discipline."
	row = CCG_ROW_INFANTRY
	power = 7
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_ENIGMA
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/enigma_overseer.png"
	hero = TRUE

/datum/ccg_card/unique_enigma_court_physician
	id = "unique_enigma_court_physician"
	name = "Court Physician"
	desc = "Hero. Restores a fallen unit from the discard."
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_ENIGMA
	effect = CCG_EFFECT_MEDIC
	art = "ccg_cards/enigma_court_physician.png"
	hero = TRUE
