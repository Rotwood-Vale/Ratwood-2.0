#define CTAG_GRONN_CHIEFTAIN "gronn_chieftain"
#define CTAG_GRONN_SHAMAN "gronn_shaman"
#define CTAG_GRONN_WARRIOR "gronn_warrior"
#define CTAG_GRONN_TRIBAL "gronn_tribal"
#define CTAG_GRONN_SLAVE "gronn_slave"

//The six gods of the Gronn, same list the Gronnic Itinerant and the Atgervi use. Slaves are locals rather than tribe, so they clear this in slaves.dm.
/datum/outfit/job/roguetown/gronn
	allowed_patrons = ALL_GRONNIC_PATRONS //Subvariant of the 'ALL_INHUMEN_PATRONS' tag, with Abyssor and Dendor as situational additions. Do not add any more to this, no matter what.

/datum/migrant_role/gronn/chieftain
	name = "Gronnic Chieftain"
	greet_text = "You are the leader of your tribe. Guide them to glory or try to survive."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/human/northern, /datum/species/halforc, /datum/species/goblinp, /datum/species/tieberian, /datum/species/lizardfolk, /datum/species/lupian, /datum/species/anthromorph, /datum/species/demihuman, /datum/species/dwarf/mountain, /datum/species/dracon, /datum/species/tabaxi) //we'll see how this goes. Carl/Chocobo can shoot this shit down.
	show_wanderer_examine = FALSE
	advjob_examine = FALSE
	advclass_cat_rolls = list(CTAG_GRONN_CHIEFTAIN = 20)

//Shaman
/datum/migrant_role/gronn/shaman
	name = "Gronnic Shaman"
	greet_text = "The wisest and likely oldest of the tribe. You commune with the Beast Spirits and unleash powers of the divine. Tending to the spiritual needs of the tribe."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/human/northern, /datum/species/halforc, /datum/species/goblinp, /datum/species/tieberian, /datum/species/lizardfolk, /datum/species/lupian, /datum/species/anthromorph, /datum/species/demihuman, /datum/species/dwarf/mountain, /datum/species/dracon, /datum/species/tabaxi)
	show_wanderer_examine = FALSE
	advjob_examine = FALSE
	advclass_cat_rolls = list(CTAG_GRONN_SHAMAN = 20)

//Warrior
/datum/migrant_role/gronn/warrior
	name = "Gronnic Fighter"
	greet_text = "You are the elite, the best fighters of your tribe. Whether breaking the enemy line or loosing arrows from Saiga back, you fight at the Chieftain's side and ensure their survival."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/human/northern, /datum/species/halforc, /datum/species/goblinp, /datum/species/tieberian, /datum/species/lizardfolk, /datum/species/lupian, /datum/species/anthromorph, /datum/species/demihuman, /datum/species/dwarf/mountain, /datum/species/dracon, /datum/species/tabaxi)
	show_wanderer_examine = FALSE
	advjob_examine = FALSE
	advclass_cat_rolls = list(CTAG_GRONN_WARRIOR = 20)

//Tribal
/datum/migrant_role/gronn/tribal
	name = "Gronnic Tribal"
	greet_text = "You are the bulk of the tribe. No warrior, but the Horde goes nowhere without you. Tracking game, carving bows, or keeping the camp standing, you are well adapted to surviving off the land."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/human/northern, /datum/species/halforc, /datum/species/goblinp, /datum/species/tieberian, /datum/species/lizardfolk, /datum/species/lupian, /datum/species/anthromorph, /datum/species/demihuman, /datum/species/dwarf/mountain, /datum/species/dracon, /datum/species/tabaxi)
	show_wanderer_examine = FALSE
	advjob_examine = FALSE
	advclass_cat_rolls = list(CTAG_GRONN_TRIBAL = 20)

//Slave
/datum/migrant_role/gronn/slave
	name = "Gronn Slave"
	greet_text = "An unlucky soul. Perhaps caught in a pillaging raid, or alone in the wilderness. You have been enslaved by the tribe. Work hard to appease your new masters."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	show_wanderer_examine = FALSE
	advclass_cat_rolls = list(CTAG_GRONN_SLAVE = 20)
