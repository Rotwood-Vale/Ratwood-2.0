// Faction cards: gronn.

/datum/ccg_card/rare_berserker
	id = "rare_berserker"
	name = "Berserker"
	desc = "Turns into a bear under Mardroeme."
	row = CCG_ROW_INFANTRY
	power = 4
	rarity = CCG_RARITY_BASE
	faction = CCG_FACTION_GRONN
	effect = CCG_EFFECT_BERSERK
	limited = TRUE
	art = "ccg_cards/gronn_berserker.png"

/datum/ccg_card/unique_gronn_war_bear
	id = "unique_gronn_war_bear"
	name = "War Bear"
	desc = "Hero. A Gronn war beast roused by berserker rites."
	row = CCG_ROW_INFANTRY
	power = 10
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_GRONN
	art = "ccg_cards/gronn_war_bear.png"
	hero = TRUE

/datum/ccg_card/rare_gronn_privateer
	id = "rare_gronn_privateer"
	name = "Gronnic Privateer"
	desc = "A northern raider with hard-won discipline."
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRONN
	effect = CCG_EFFECT_BOND
	art = "ccg_cards/gronn_privateer.png"

/datum/ccg_card/rare_gronn_heavy
	id = "rare_gronn_heavy"
	name = "Fjall Jarnklaeddur"
	desc = "Heavy Gronn infantry in iron and fur."
	row = CCG_ROW_INFANTRY
	power = 6
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRONN
	effect = CCG_EFFECT_BERSERK
	art = "ccg_cards/gronn_heavy.png"

/datum/ccg_card/rare_gronn_bone_shaman
	id = "rare_gronn_bone_shaman"
	name = "Gronn Bone Shaman"
	desc = "A rite-speaker who turns fury into bears under Mardroeme."
	row = CCG_ROW_INFANTRY
	power = 3
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRONN
	effect = CCG_EFFECT_MARDROEME
	target_row = CCG_ROW_INFANTRY
	art = "ccg_cards/gronn_bone_shaman.png"

/datum/ccg_card/rare_gronn_atgervi
	id = "rare_gronn_atgervi"
	name = "Atgervi"
	desc = "Gronn Varangian warrior-trader hardened by far campaigns."
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRONN
	effect = CCG_EFFECT_BOND
	art = "ccg_cards/gronn_atgervi.png"

/datum/ccg_card/rare_gronn_atgervi_shaman
	id = "rare_gronn_atgervi_shaman"
	name = "Atgervi Shaman"
	desc = "Northern rite-speaker who wakes the berserkers."
	row = CCG_ROW_INFANTRY
	power = 3
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRONN
	effect = CCG_EFFECT_MARDROEME
	target_row = CCG_ROW_INFANTRY
	art = "ccg_cards/gronn_atgervi_shaman.png"

/datum/ccg_card/unique_gronn_trollslayer
	id = "unique_gronn_trollslayer"
	name = "Trollslayer"
	desc = "Hero. A bare-skinned axe oath with no road back."
	row = CCG_ROW_INFANTRY
	power = 7
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_GRONN
	effect = CCG_EFFECT_BERSERK
	art = "ccg_cards/gronn_trollslayer.png"
	hero = TRUE

/datum/ccg_card/unique_gronn_guds_klor
	id = "unique_gronn_guds_klor"
	name = "Guds Klor"
	desc = "Hero. A northern shaman whose claws carry old rites."
	row = CCG_ROW_INFANTRY
	power = 8
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_GRONN
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/gronn_guds_klor.png"
	hero = TRUE

/datum/ccg_card/unique_gronn_norsian_griddar
	id = "unique_gronn_norsian_griddar"
	name = "Norsian Griddar"
	desc = "Hero. A foreign warrior seeking a new home or a glorious death."
	row = CCG_ROW_INFANTRY
	power = 7
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_GRONN
	effect = CCG_EFFECT_SCORCH_INFANTRY
	art = "ccg_cards/gronn_norsian_griddar.png"
	hero = TRUE
