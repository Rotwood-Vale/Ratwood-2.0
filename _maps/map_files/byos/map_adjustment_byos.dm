/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/byos
	map_file_name = "byos.dmm"
	realm_name = "New Kingsfield"
	slot_adjust = list(
		// /datum/job/roguetown/villager = 42,
		// /datum/job/roguetown/adventurer = 69
	)
	title_adjust = list(
		// Noble Court
		/datum/job/roguetown/lord = list(display_title = "Grand Viceroy", f_title = "Grand Vicereine"),
		// /datum/job/roguetown/hand = list(display_title = "Adjutant", f_title = "Adjutant"),
		// /datum/job/roguetown/steward = list(display_title = "Seneschal", f_title = "Seneschal"),
		// /datum/job/roguetown/butler = list(display_title = "Majordomo", f_title = "Majordomo"),
		// /datum/job/roguetown/councillor = list(display_title = "Adviser", f_title = "Adviser"),
		// /datum/job/roguetown/prince = list(display_title = "Scion", f_title = "Scion"),

		// Military & Guards
		// /datum/job/roguetown/marshal = list(display_title = "Sheriff", f_title = "Sheriff"),
		// /datum/job/roguetown/warden = list(display_title = "Vanguard", f_title = "Vanguard"),
		// /datum/job/roguetown/sergeant = list(display_title = "Watch Sergeant", f_title = "Watch Sergeant"),
		// /datum/job/roguetown/manorguard = list(display_title = "House Guard", f_title = "House Guard"),
		// /datum/job/roguetown/guardsman = list(display_title = "Watchman", f_title = "Watchwoman"),

		// Clergy
		// /datum/job/roguetown/priest = list(display_title = "Abbot", f_title = "Abbess"),
		// /datum/job/roguetown/martyr = list(display_title = "Zealot", f_title = "Zealot"),

		// Court Specialists
		// /datum/job/roguetown/jester = list(display_title = "Fool", f_title = "Fool"),
		// /datum/job/roguetown/physician = list(display_title = "Island Physician", f_title = "Island Physician"),

		// Merchants & Crafters
		// /datum/job/roguetown/merchant = list(display_title = "Trader", f_title = "Trader"),
		// /datum/job/roguetown/guildmaster = list(display_title = "Guild Master", f_title = "Guild Mistress"),
		// /datum/job/roguetown/guildsman = list(display_title = "Guildsman", f_title = "Guildswoman"),
		// /datum/job/roguetown/archivist = list(display_title = "Scribe", f_title = "Scribe"),

		// Common Folk
		/datum/job/roguetown/villager = list(display_title = "Colonist", f_title = "Colonist"),
		// /datum/job/roguetown/farmer = list(display_title = "Settler", f_title = "Settler"),
		// /datum/job/roguetown/servant = list(display_title = "Servant", f_title = "Servant"),
		// /datum/job/roguetown/lunatic = list(display_title = "Madman", f_title = "Madwoman"),

		// Outcasts & Misc
		/datum/job/roguetown/bandit = list(display_title = "Pirate", f_title = "Pirate"),
		/datum/job/roguetown/orphan = list(display_title = "Stowaway", f_title = "Stowaway"),
		/datum/job/roguetown/beggar = list(display_title = "Stowaway", f_title = "Stowaway"),
	)
	tutorial_adjust = list(
		/datum/job/roguetown/lord = "You have been sent by the queen to oversee the colony of New Kingsfield. CHANGE THIS LATER.",
		/datum/job/roguetown/bandit = "At some point in your lyfe, you'd fallen to the wrong side of the PIRATESHIP!. Whether by butchery or finesse, you're known throughout the SEVEN SEAS. Yet one of many faces in a SALTY PORT tavern, hung up on a wall. A tale told by the locals. Now, you lyve in a PIRATES COVE with your fellows, to avoid an unpleasant end."
		// /datum/job/roguetown/orphan = "CHANGE THIS LATER!",

	)
	/// Jobs that this map won't use
	blacklist = list(
		/datum/job/roguetown/cataphract,
		/datum/job/roguetown/headslave,
		/datum/job/roguetown/janissary,
		/datum/job/roguetown/janissarysergeant,
		/datum/job/roguetown/azeb,
		/datum/job/roguetown/azebagha,
		/datum/job/roguetown/slavemaster,
		/datum/job/roguetown/slave,
		/datum/job/roguetown/adventurer/courtslave,
		
		// /datum/job/roguetown/adventurer//Adventurers
		// /datum/job/roguetown/wretch,
		// /datum/job/roguetown/bandit,
		/datum/job/roguetown/pilgrim,//everyone came on the boat so no real difference with towner
		// /datum/job/roguetown/trader,
		// /datum/job/roguetown/assassin,

		// /datum/job/roguetown/lord,
		// /datum/job/roguetown/knight,
		// /datum/job/roguetown/hand,
		// /datum/job/roguetown/suitor, //long walks on the beach?
		/datum/job/roguetown/steward,
		// /datum/job/roguetown/consort,
		// /datum/job/roguetown/captain,
		/datum/job/roguetown/marshal, //nyeah fuck you

		//church. 
		/datum/job/roguetown/keeper, //no beast
		// /datum/job/roguetown/monk,
		// /datum/job/roguetown/templar,
		// /datum/job/roguetown/priest,
		// /datum/job/roguetown/martyr,
		// /datum/job/roguetown/druid,

		// /datum/job/roguetown/butler,
		// /datum/job/roguetown/councillor,
		// /datum/job/roguetown/magician,
		// /datum/job/roguetown/jester,
		// /datum/job/roguetown/physician,

		// /datum/job/roguetown/manorguard,
		// /datum/job/roguetown/guardsman,
		// /datum/job/roguetown/warden,
		// /datum/job/roguetown/wardenmaster,//Probably the best possible place for 'em!
		/datum/job/roguetown/dungeoneer,
		// /datum/job/roguetown/sergeant,
		// /datum/job/roguetown/squire,
		// /datum/job/roguetown/veteran,
		// /datum/job/roguetown/vanguard,//eh probably fine
		/datum/job/roguetown/guardsman,//Not a city map
		/datum/job/roguetown/watchcaptain,//Not a city map

		//trader (probably fine to keep as it is)

		/datum/job/roguetown/crier,
		// /datum/job/roguetown/archivist,//idk they can study the island
		// /datum/job/roguetown/barkeep,//there IS a bar I guess?
		// /datum/job/roguetown/guildmaster,
		// /datum/job/roguetown/guildsman,
		// /datum/job/roguetown/merchant,//important
		/datum/job/roguetown/niteman,
		// /datum/job/roguetown/tailor,
		// /datum/job/roguetown/elder,
		
		// /datum/job/roguetown/villager,
		// /datum/job/roguetown/farmer,
		// /datum/job/roguetown/prisonerb,
		// /datum/job/roguetown/prisonerr,
		// /datum/job/roguetown/hostage,
		/datum/job/roguetown/nightmaiden,
		// /datum/job/roguetown/cook,
		/datum/job/roguetown/knavewench,
		// /datum/job/roguetown/lunatic,


		//inquisition. Fine as is?

		//mercenaries. Fine as is?
		
		// /datum/job/roguetown/servant,
		// /datum/job/roguetown/apothecary,
		// /datum/job/roguetown/churchling,
		/datum/job/roguetown/clerk,
		// /datum/job/roguetown/wapprentice,
		// /datum/job/roguetown/orphan,
		// /datum/job/roguetown/prince,
		// /datum/job/roguetown/shophand,
		
	)

	threat_regions = list(
		THREAT_REGION_JUNGLE,
		THREAT_REGION_ISLAND,
	)
