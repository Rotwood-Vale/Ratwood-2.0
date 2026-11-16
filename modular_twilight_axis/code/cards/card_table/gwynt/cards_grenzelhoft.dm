// Faction cards: grenzelhoft.

/datum/ccg_card/rare_grenzelhoft_doppelsoldner
	id = "rare_grenzelhoft_doppelsoldner"
	name = "Doppelsoldner"
	desc = "A Grenzelhoft shock infantryman paid to break the line."
	row = CCG_ROW_INFANTRY
	power = 6
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRENZELHOFT
	effect = CCG_EFFECT_BOND
	art = "ccg_cards/grenzelhoft_doppelsoldner.png"

/datum/ccg_card/rare_grenzelhoft_halberdier
	id = "rare_grenzelhoft_halberdier"
	name = "Halberdier"
	desc = "Polearm infantry from the mercenary guild's core."
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_BASE
	faction = CCG_FACTION_GRENZELHOFT
	effect = CCG_EFFECT_MORALE
	limited = TRUE
	art = "ccg_cards/grenzelhoft_halberdier.png"

/datum/ccg_card/rare_grenzelhoft_crossbowman
	id = "rare_grenzelhoft_crossbowman"
	name = "Grenzelhoft Crossbowman"
	desc = "A disciplined crossbow line. Bonds with other Grenzelhoft Crossbowmen."
	row = CCG_ROW_ARCHERS
	power = 4
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRENZELHOFT
	effect = CCG_EFFECT_BOND
	art = "ccg_cards/grenzelhoft_crossbowman.png"

/datum/ccg_card/rare_grenzelhoft_jager
	id = "rare_grenzelhoft_jager"
	name = "Grenzelhoft Jager"
	desc = "Imperial woodsman and marksman attached to a black company."
	row = CCG_ROW_ARCHERS
	power = 4
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRENZELHOFT
	effect = CCG_EFFECT_SCORCH_INFANTRY
	art = "ccg_cards/grenzelhoft_jager.png"

/datum/ccg_card/rare_grenzelhoft_freifechter
	id = "rare_grenzelhoft_freifechter"
	name = "Freifechter Fencer"
	desc = "Free fencer from the Grenzelhoft border schools."
	row = CCG_ROW_INFANTRY
	power = 4
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRENZELHOFT
	effect = CCG_EFFECT_AGILE
	art = "ccg_cards/grenzelhoft_freifechter.png"

/datum/ccg_card/rare_grenzelhoft_foreign_fencer
	id = "rare_grenzelhoft_foreign_fencer"
	name = "Foreign Fencer"
	desc = "Itinerant weapons expert trained in a Grenzelhoftian fencing school."
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRENZELHOFT
	effect = CCG_EFFECT_AGILE
	art = "ccg_cards/grenzelhoft_foreign_fencer.png"

/datum/ccg_card/rare_grenzelhoft_condottiero
	id = "rare_grenzelhoft_condottiero"
	name = "Condottiero Ringleader"
	desc = "Contract captain whose coin binds crossbows and pikes."
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRENZELHOFT
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/grenzelhoft_condottiero.png"

/datum/ccg_card/rare_grenzelhoft_siege_mage
	id = "rare_grenzelhoft_siege_mage"
	name = "Gefechtsgelehrter"
	desc = "A Grenzelhoft battle-scholar attached to siege works."
	row = CCG_ROW_SIEGE
	power = 3
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRENZELHOFT
	effect = CCG_EFFECT_HORN
	target_row = CCG_ROW_SIEGE
	art = "ccg_cards/grenzelhoft_siege_mage.png"

/datum/ccg_card/unique_grenzelhoft_iron_captain
	id = "unique_grenzelhoft_iron_captain"
	name = "Iron Captain"
	desc = "Hero. A mercenary commander who knows when to burn the strongest piece."
	row = CCG_ROW_INFANTRY
	power = 7
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_GRENZELHOFT
	effect = CCG_EFFECT_SCORCH_GLOBAL
	art = "ccg_cards/grenzelhoft_iron_captain.png"
	hero = TRUE
