#define CTAG_HAMMERHOLD_JARL "hammerhold_jarl"
#define CTAG_HAMMERHOLD_TIDEWEAVER "hammerhold_tideweaver"
#define CTAG_HAMMERHOLD_VOLFSKIN "hammerhold_volfskin"
#define CTAG_HAMMERHOLD_HUSCARL "hammerhold_huscarl"
#define CTAG_HAMMERHOLD_THRALL "hammerhold_thrall"

//Abyssor for the whole warband, same shape as the Gronn. Thralls and Volfskins override this in their own files.
/datum/outfit/job/roguetown/hammerhold
	allowed_patrons = list(/datum/patron/divine/abyssor)

//Jarl. Heavy armour guy with a greataxe and a sidearm mace.
/datum/migrant_role/hammerhold/jarl
	name = "Hammerholdian Jarl"
	greet_text = "You are a warrior-lord from Hammerhold and the leader of your warband. Guide them to glory and wealth or try to survive."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/human/northern, /datum/species/halforc, /datum/species/goblinp, /datum/species/tieberian, /datum/species/lizardfolk, /datum/species/lupian, /datum/species/anthromorph, /datum/species/demihuman, /datum/species/dwarf/mountain, /datum/species/dracon, /datum/species/tabaxi, /datum/species/akula) //Same racelocks as Gronnic Chieftain, subject to change
	show_wanderer_examine = FALSE
	advjob_examine = FALSE
	advclass_cat_rolls = list(CTAG_HAMMERHOLD_JARL = 20)

//Tideweaver. T4 miraclist (capped) and some minor magics.
/datum/migrant_role/hammerhold/tideweaver
	name = "Hammerholdian Tideweaver"
	greet_text = "You are a cleric of the Lord of Abyss, devoted to him in prayer and arcyne. You have minor magical spells and medical knowledge in addition to your miracles."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/human/northern, /datum/species/halforc, /datum/species/goblinp, /datum/species/tieberian, /datum/species/lizardfolk, /datum/species/lupian, /datum/species/anthromorph, /datum/species/demihuman, /datum/species/dwarf/mountain, /datum/species/dracon, /datum/species/tabaxi, /datum/species/akula)
	show_wanderer_examine = FALSE
	advjob_examine = FALSE
	advclass_cat_rolls = list(CTAG_HAMMERHOLD_TIDEWEAVER = 20)

//Volfskin. CritResist+Enduring guy with two axes.
/datum/migrant_role/hammerhold/volfskin
	name = "Hammerholdian Volfskin"
	greet_text = "You are a volfskin, one of the legendary Hammerholdian warriors who are said to be possessed by raging volf spirits in battles. Distrusted due to your less than savoury religious practices, but well-respected for your combat prowess."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/human/northern, /datum/species/halforc, /datum/species/goblinp, /datum/species/tieberian, /datum/species/lizardfolk, /datum/species/lupian, /datum/species/anthromorph, /datum/species/demihuman, /datum/species/dwarf/mountain, /datum/species/dracon, /datum/species/tabaxi, /datum/species/akula)
	show_wanderer_examine = FALSE
	advjob_examine = FALSE
	advclass_cat_rolls = list(CTAG_HAMMERHOLD_VOLFSKIN = 20)

//Tribal
/datum/migrant_role/hammerhold/huscarl
	name = "Hammerholdian Huscarl"
	greet_text = "You are a loyal and skilled bodyguard to your jarl, specialising in pillaging and kidnapping. Whether holding the shield wall or loosing from behind it, you fight with good Hammerhold steel."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/human/northern, /datum/species/halforc, /datum/species/goblinp, /datum/species/tieberian, /datum/species/lizardfolk, /datum/species/lupian, /datum/species/anthromorph, /datum/species/demihuman, /datum/species/dwarf/mountain, /datum/species/dracon, /datum/species/tabaxi, /datum/species/akula)
	show_wanderer_examine = FALSE
	advjob_examine = FALSE
	advclass_cat_rolls = list(CTAG_HAMMERHOLD_HUSCARL = 20)

//Thrall. Same as Gronn Wave's Slave, just with better clothes. Not required to be an Abyssorite like the rest of them.
/datum/migrant_role/hammerhold/thrall
	name = "Hammerhold Thrall"
	greet_text = "An unlucky soul. Perhaps caught in a pillaging raid, or alone in the wilderness, you have been enslaved by the warband. Work hard to appease your new masters."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	show_wanderer_examine = FALSE
	advclass_cat_rolls = list(CTAG_HAMMERHOLD_THRALL = 20)
