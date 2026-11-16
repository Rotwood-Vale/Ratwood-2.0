// Faction cards: naledi.

/datum/ccg_card/rare_naledi_hierophant
	id = "rare_naledi_hierophant"
	name = "Naledi Hierophant"
	desc = "A scholar-priest whose rite clears weather from the field."
	row = CCG_ROW_ARCHERS
	power = 4
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_NALEDI
	effect = CCG_EFFECT_CLEAR_WEATHER
	art = "ccg_cards/naledi_hierophant.png"

/datum/ccg_card/rare_naledi_vizier
	id = "rare_naledi_vizier"
	name = "Naledi Vizier"
	desc = "A court mage-spy placed on the enemy side to draw two cards."
	row = CCG_ROW_ARCHERS
	power = 2
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_NALEDI
	effect = CCG_EFFECT_SPY
	art = "ccg_cards/naledi_vizier.png"

/datum/ccg_card/rare_naledi_sojourner
	id = "rare_naledi_sojourner"
	name = "Sojourner"
	desc = "A wandering desert mystic with agile placement."
	row = CCG_ROW_ARCHERS
	power = 5
	rarity = CCG_RARITY_BASE
	faction = CCG_FACTION_NALEDI
	effect = CCG_EFFECT_AGILE
	limited = TRUE
	art = "ccg_cards/naledi_sojourner.png"

/datum/ccg_card/rare_naledi_zybantu_envoy
	id = "rare_naledi_zybantu_envoy"
	name = "Zybantu Envoy"
	desc = "A Zibantian provincial envoy binding Naledi rite and desert law."
	row = CCG_ROW_ARCHERS
	power = 3
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_NALEDI
	effect = CCG_EFFECT_MEDIC
	art = "ccg_cards/naledi_zybantu_envoy.png"

/datum/ccg_card/rare_naledi_yogi
	id = "rare_naledi_yogi"
	name = "Wandering Yogi"
	desc = "A desert ascetic whose rite strips weather from the field."
	row = CCG_ROW_ARCHERS
	power = 2
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_NALEDI
	effect = CCG_EFFECT_CLEAR_WEATHER
	art = "ccg_cards/naledi_yogi.png"

/datum/ccg_card/rare_naledi_refugee
	id = "rare_naledi_refugee"
	name = "Naledi Refugee"
	desc = "A war-torn seminary survivor carrying fragments of desert doctrine."
	row = CCG_ROW_ARCHERS
	power = 3
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_NALEDI
	effect = CCG_EFFECT_MEDIC
	art = "ccg_cards/naledi_refugee.png"

/datum/ccg_card/unique_naledi_pontifex
	id = "unique_naledi_pontifex"
	name = "Naledi Pontifex"
	desc = "Hero. A high-fantasy scholar of rites and stars."
	row = CCG_ROW_ARCHERS
	power = 8
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_NALEDI
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/naledi_pontifex.png"
	hero = TRUE

/datum/ccg_card/unique_naledian_psydon_mage
	id = "unique_naledian_psydon_mage"
	name = "Naledian Psydon Mage"
	desc = "Hero. Elemental arcyne sealed under church doctrine."
	row = CCG_ROW_ARCHERS
	power = 7
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_NALEDI
	effect = CCG_EFFECT_SCORCH_GLOBAL
	art = "ccg_cards/naledian_psydon_mage.png"
	hero = TRUE
