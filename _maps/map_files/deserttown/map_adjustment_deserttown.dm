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
		/datum/job/roguetown/lord = list(display_title = "苏丹", f_title = "苏丹娜"),
		/datum/job/roguetown/prince = list(display_title = "埃米尔", f_title = "阿米拉"),
		// /datum/job/roguetown/marshal = list(display_title = "Mayor"),
		/datum/job/roguetown/priest =  list(display_title = "大祭司", f_title = "大祭司"),
		/datum/job/roguetown/captain = list(display_title = "铁甲骑兵队长"),
		/datum/job/roguetown/physician = list(display_title = "宫廷医师"),
		/datum/job/roguetown/villager = list(display_title = "村民"),
		/datum/job/roguetown/magician = list(display_title = "宫廷法师"),
		/datum/job/roguetown/pilgrim = list(display_title = "游牧民"),
		/datum/job/roguetown/councillor = list(display_title = "谢赫"),
		/datum/job/roguetown/hand = list(display_title = "维齐尔"),
	)
	tutorial_adjust = list(
		// /datum/job/roguetown/marshal = "CHANGE THIS LATER. Manage the town outside of the palace. Hang out in the mayor building!!!",
		/datum/job/roguetown/marshal = "此文本待修改。你被苏丹委任为最高军事权威。在你的豪宅中坐镇，担任各主要武力支柱——铁甲骑兵队长（及其铁甲骑兵）、耶尼切里军士长（及其耶尼切里）和精锐兵队长（及其精锐兵）之间的主要协调联络人。",
		/datum/job/roguetown/physician = "你是一位医学大师，深得苏丹本人信赖，负责为王室宗亲、宫廷朝臣、\
	其护卫及其臣民提供专业医护。你主要在宫殿医疗翼的城堡内居住，但也同样可以出入 \
	 集市中的地方诊所，那里有资历较浅的持证药剂师在你的偶尔路过指点下行医。",
		/datum/job/roguetown/magician = "你的信条致力于征服奥术艺术并追寻知识带来的永恒悸动。 \
	你欠苏丹一条命，因为正是他的金币让你在这黑暗时代中得以继续学业。 \
	作为回报，你一次又一次以公正裁决和可信顾问的身份证明了自己的价值，辅佐着苏丹的统治。",
		/datum/job/roguetown/shophand = "你靠着那位将你绑在这苦差上的商人，得以在阿尔-阿舒尔最大的店铺里工作。为雇主补货上架和盘点库存的工作令人麻木而重复——但至少你头顶上有片屋檐，身边环境也舒适。假以时日，或许有一天你会比一个光鲜的仆役更有出息。",
		/datum/job/roguetown/councillor = "你可能继承了这个职位，花钱买来的，或是被王室亲自任命； \
	无论出身如何，你现在作为维齐尔的助理、规划师和陪审官为其效力。 \
	你协助他监督税收、建设以及新法律的规划。 \
	你的主要职责是辅佐维齐尔完成其职务，只对他们和苏丹负责。",
		/datum/job/roguetown/hand = "你是国内最重要的人物之一。 \
	你长期扮演着贵族家族的间谍头子和知心密友，以至于你本身就是一座阴谋的宝库，而你也以坚定的信念利用着这一点。\
	让所有人永远不要忘记你是在谁的耳边低语。你用那双唇杀掉的人比任何剑术大师敢宣称的都多。\
	另外（请重写此段）你还负责财务管理！！",
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
		/datum/job/roguetown/chaplain,//ought have a psydonite alternative

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
		
		/datum/job/roguetown/tribalchieftain,
		/datum/job/roguetown/tribalshaman,
		/datum/job/roguetown/tribalguard,
		/datum/job/roguetown/tribalrabble,
		/datum/job/roguetown/tribalvillager,
		
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
