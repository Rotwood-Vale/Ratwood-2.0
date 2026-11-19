// Faction cards: raneshi.

/datum/ccg_card/rare_raneshi_desert_janissary
	id = "rare_raneshi_desert_janissary"
	name = "Desert Rider Janissary"
	desc = "Raneshi Desert Town cavalry in high-fantasy Gwent styling."
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_AGILE
	art = "ccg_cards/raneshi_desert_janissary.png"

/datum/ccg_card/rare_raneshi_zeybek
	id = "rare_raneshi_zeybek"
	name = "Desert Rider Zeybek"
	desc = "A swift Raneshi skirmisher who can join either line."
	row = CCG_ROW_ARCHERS
	power = 4
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_AGILE
	art = "ccg_cards/raneshi_zeybek.png"

/datum/ccg_card/rare_raneshi_sahir
	id = "rare_raneshi_sahir"
	name = "Desert Rider Sahir"
	desc = "A mirage-caster who strips weather from the field."
	row = CCG_ROW_ARCHERS
	power = 3
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_CLEAR_WEATHER
	art = "ccg_cards/raneshi_sahir.png"

/datum/ccg_card/rare_raneshi_miragefen_rogue
	id = "rare_raneshi_miragefen_rogue"
	name = "Miragefen Rogue"
	desc = "A masked Raneshi rogue; played as a spy for two cards."
	row = CCG_ROW_INFANTRY
	power = 2
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_SPY
	art = "ccg_cards/raneshi_miragefen_rogue.png"

/datum/ccg_card/rare_raneshi_azeb_guard
	id = "rare_raneshi_azeb_guard"
	name = "Raneshi Azeb Guard"
	desc = "Provincial desert infantry holding the line for the Sultanate."
	row = CCG_ROW_INFANTRY
	power = 2
	rarity = CCG_RARITY_BASE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_BOND
	limited = TRUE
	art = "ccg_cards/raneshi_azeb_guard.png"

/datum/ccg_card/rare_raneshi_slaver
	id = "rare_raneshi_slaver"
	name = "Ranesheni Slaver"
	desc = "A brutal catcher who removes the strongest unit on the field."
	row = CCG_ROW_INFANTRY
	power = 3
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_SCORCH_GLOBAL
	art = "ccg_cards/raneshi_slaver.png"

/datum/ccg_card/rare_raneshi_forlorn_hope
	id = "rare_raneshi_forlorn_hope"
	name = "Forlorn Hope"
	desc = "Ranesheni slave-revolt mercenaries who trade pain for freedom."
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_SCORCH_INFANTRY
	art = "ccg_cards/raneshi_forlorn_hope.png"

/datum/ccg_card/rare_raneshi_bronzeclad
	id = "rare_raneshi_bronzeclad"
	name = "Raneshen Bronzeclad"
	desc = "Arena-born bronze warrior from the curtain courts."
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/raneshi_bronzeclad.png"

/datum/ccg_card/rare_raneshi_thespian_errant
	id = "rare_raneshi_thespian_errant"
	name = "Thespian-Errant"
	desc = "Arena reenactor and curtain-court wanderer from the Raneshen circuit."
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/raneshi_thespian_errant.png"

/datum/ccg_card/rare_raneshi_mushir
	id = "rare_raneshi_mushir"
	name = "Mushir"
	desc = "Desert Town marshal title. Doubles the siege row with command discipline."
	row = CCG_ROW_SIEGE
	power = 3
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_HORN
	target_row = CCG_ROW_SIEGE
	art = "ccg_cards/raneshi_mushir.png"

/datum/ccg_card/unique_raneshi_almah
	id = "unique_raneshi_almah"
	name = "Desert Rider Almah"
	desc = "Hero. A Raneshi elite rider from the Desert Town legends."
	row = CCG_ROW_INFANTRY
	power = 8
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/raneshi_almah.png"
	hero = TRUE

/datum/ccg_card/unique_raneshi_amir
	id = "unique_raneshi_amir"
	name = "Amir of Desert Town"
	desc = "Hero. The desert court's sovereign hand and banner."
	row = CCG_ROW_INFANTRY
	power = 8
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/raneshi_amir.png"
	hero = TRUE

/datum/ccg_card/unique_raneshi_spice_prince
	id = "unique_raneshi_spice_prince"
	name = "Spice Prince"
	desc = "Hero. A silk-veiled patron whose coin moves armies."
	row = CCG_ROW_ARCHERS
	power = 7
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_MEDIC
	art = "ccg_cards/raneshi_spice_prince.png"
	hero = TRUE
