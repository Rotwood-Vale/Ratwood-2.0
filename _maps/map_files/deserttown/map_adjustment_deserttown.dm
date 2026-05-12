/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/deserttown
	map_file_name = "deserttown.dmm"
	realm_name = "Al-Ashur"
	slot_adjust = list(
		// /datum/job/roguetown/mercenary = 7, //haha fuck you one less slot!!
		// /datum/job/roguetown/apothecary = 1, //remodelled the building for more room
		/datum/job/roguetown/gnoll = 3,//hyenas just belong here!
	)
	title_adjust = list(
		/datum/job/roguetown/lord = list(display_title = "Sultan", f_title = "Sultana"),
		/datum/job/roguetown/prince = list(display_title = "Amir", f_title = "Amira"),
		// /datum/job/roguetown/marshal = list(display_title = "Mayor"),
		/datum/job/roguetown/priest =  list(display_title = "High Priest", f_title = "High Priestess"),
		/datum/job/roguetown/captain = list(display_title = "Cataphract Captain"),
		/datum/job/roguetown/physician = list(display_title = "Palace Physician"),
		/datum/job/roguetown/villager = list(display_title = "Villager"),
		/datum/job/roguetown/magician = list(display_title = "Palace Magician"),
		/datum/job/roguetown/pilgrim = list(display_title = "Nomad"),
		/datum/job/roguetown/councillor = list(display_title = "Sheikh"),
		/datum/job/roguetown/hand = list(display_title = "Vizier"),
	)
	tutorial_adjust = list(
		// /datum/job/roguetown/marshal = "CHANGE THIS LATER. Manage the town outside of the palace. Hang out in the mayor building!!!",
		/datum/job/roguetown/marshal = "CHANGE THIS LATER. You are entrusted as the highest military authority by the Sultan. Hang out in your fancy house. Act as the primary go-between and coordinator between the main pillars of might - The Cataphract Captain (and their Cataphracts), the Janissary Sergeant (and their Janissaries) and the Azeb Agha (and the Azebs)",
		/datum/job/roguetown/physician = "You are a master physician, trusted by the Sultan themself to administer expert care to the Royal family, the court, \
		its protectors and its subjects. While primarily a resident of the keep in the palace medical wing, you also have access \
		 to the local clinic in the bazaar, where lesser licensed apothecaries ply their trade under your occasional passing tutelage.",
		/datum/job/roguetown/magician = "Your creed is one dedicated to the conquering of the arcane arts and the constant thrill of knowledge. \
		You owe your life to the Sultan, for it was his coin that allowed you to continue your studies in these dark times. \
		In return, you have proven time and time again as justicar and trusted advisor to their reign.",
		/datum/job/roguetown/shophand = "You work the largest store in Al-Ashur by grace of the Merchant who has shackled you to this drudgery. The work of stocking shelves and taking inventory for your employer is mind-numbing and repetitive--but at least you have a roof over your head and comfortable surroundings. With time, perhaps you will one day be more than a glorified servant.",
		/datum/job/roguetown/councillor = "You may have inherited this role, bought your way into it, or were appointed by the Royal Family themselves; \
			Regardless of origin, you now serve as an assistant, planner, and juror for the Vizier. \
			You help him oversee the taxation, construction, and planning of new laws. \
			Your main focus is to assist the Vizier with their duties, answering only to them and the Sultan.",
		/datum/job/roguetown/hand = "You are one of the most important men within the realm itself. \
			You have played spymaster and confidant to the Noble-Family for so long that you are a vault of intrigue, something you exploit with potent conviction.\
			Let no man ever forget whose ear you whisper into. You've killed more men with those lips than any blademaster could ever claim to.\
			ALSO (rewrite this) YOU MANAGE FINANCES TOO!!",
	)
	/// Jobs that this map won't use
	blacklist = list(
		// /datum/job/roguetown/adventurer//Adventurers (Could rename which are 'foreigners but who cares)'
		// /datum/job/roguetown/wretch,
		// /datum/job/roguetown/bandit,
		// /datum/job/roguetown/pilgrim, //I have Nomads in the dtvillager.dm //actually this makes sense as a non-zyb foreigner!
		// /datum/job/roguetown/trader,
		// /datum/job/roguetown/assassin,

		// /datum/job/roguetown/lord,// sultan//moved to an if-map-then-outfit
		/datum/job/roguetown/knight,// cataphract
		// /datum/job/roguetown/hand,// vizier
		// /datum/job/roguetown/suitor,
		// /datum/job/roguetown/steward, //gonna try merging this role with Vizier EDIT: with the higher pop we can afford to keep em separate now
		// /datum/job/roguetown/consort,
		// /datum/job/roguetown/captain,
		// /datum/job/roguetown/bailiff,

		//church. Fine as is

		/datum/job/roguetown/butler,// headslave
		// /datum/job/roguetown/councillor,// sheikh
		// /datum/job/roguetown/magician,// moved to an if-map-then-outfit statement in the baseblock
		/datum/job/roguetown/jester, //are jesters really a desert thing? Maybe ought to push people into playing slaves instead..?
		// /datum/job/roguetown/physician,

		/datum/job/roguetown/manorguard,//  mamaluk
		// /datum/job/roguetown/rookie,//  mamalukrookie!
		/datum/job/roguetown/guardsman,//  mamaluk
		/datum/job/roguetown/vanguard,//  jannissary
		/datum/job/roguetown/warden,//  jannissary
		/datum/job/roguetown/dungeoneer,// Slavemaster. Okay it's a bit different but it's nice to cut bloat y'know!
		/datum/job/roguetown/sergeant,//janissary sergeant
		// /datum/job/roguetown/squire,
		// /datum/job/roguetown/veteran,
		/datum/job/roguetown/watchcaptain,
		/datum/job/roguetown/wardenmaster,

		//trader (probably fine to keep as it is)

		/datum/job/roguetown/crier, //would be fun to integrate in with the arena? Reimplement when building is added
		// /datum/job/roguetown/archivist,
		// /datum/job/roguetown/barkeep,
		// /datum/job/roguetown/guildmaster,
		// /datum/job/roguetown/guildsman,
		// /datum/job/roguetown/merchant,
		// /datum/job/roguetown/niteman,
		// /datum/job/roguetown/tailor,
		// /datum/job/roguetown/elder,
		
		// /datum/job/roguetown/villager,
		// /datum/job/roguetown/farmer,
		// /datum/job/roguetown/prisonerb,
		// /datum/job/roguetown/prisonerr,
		// /datum/job/roguetown/hostage,
		// /datum/job/roguetown/nightmaiden, // Current ones are probably fine?
		// /datum/job/roguetown/cook,
		/datum/job/roguetown/knavewench, //maybe after expanding the tavern for it
		// /datum/job/roguetown/lunatic,


		//inquisition. Fine as is

		//mercenaries. Fine as is
		
		/datum/job/roguetown/servant,//slave
		// /datum/job/roguetown/apothecary,
		// /datum/job/roguetown/churchling,
		// /datum/job/roguetown/clerk, //gonna try merging this with Sheikh - EDIT with higher pop we can afford to keep this role around
		// /datum/job/roguetown/wapprentice,
		// /datum/job/roguetown/orphan,
		// /datum/job/roguetown/prince,//dtprince
		// /datum/job/roguetown/shophand,
		
	)

//list to blacklist for other maps (update as new replacements are added)
		// /datum/job/roguetown/cataphract,
		// /datum/job/roguetown/vizier,
		// /datum/job/roguetown/headslave,
		// /datum/job/roguetown/sheikh,
		// /datum/job/roguetown/janissary,
		// /datum/job/roguetown/janissarysergeant,
		// /datum/job/roguetown/azeb,
		// /datum/job/roguetown/azebagha,
		// /datum/job/roguetown/slavemaster,
		// /datum/job/roguetown/dtslave,

	threat_regions = list(
		THREAT_REGION_DESERT_NEAR,
		THREAT_REGION_DESERT_DEEP,
	)
