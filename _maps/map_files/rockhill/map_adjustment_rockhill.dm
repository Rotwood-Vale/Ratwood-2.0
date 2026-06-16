/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/rockhill
	map_file_name = "rockhill.dmm"
	realm_name = "Rockhill"
	blacklist = list(//I had wanted the map variable in the roles themselves to bar them from non-desert maps but it still shows up in the Latejoin menu so I'm doing this just to keep it clear)
		/datum/job/roguetown/cataphract,
		// /datum/job/roguetown/vizier,
		/datum/job/roguetown/headslave,
		// /datum/job/roguetown/sheikh,
		/datum/job/roguetown/janissary,
		/datum/job/roguetown/janissarysergeant,
		/datum/job/roguetown/azeb,
		/datum/job/roguetown/azebagha,
		/datum/job/roguetown/slavemaster,
		/datum/job/roguetown/slave,
		/datum/job/roguetown/adventurer/courtslave,
		/datum/job/roguetown/dtchaplain,
		
		/datum/job/roguetown/tribalchieftain,
		/datum/job/roguetown/tribalshaman,
		/datum/job/roguetown/tribalguard,
		/datum/job/roguetown/tribalrabble,
		/datum/job/roguetown/tribalvillager,
		
		/datum/job/roguetown/sergeant,
		)
	slot_adjust = list(
		/datum/job/roguetown/manorguard = 4,//split with watchmen
		/datum/job/roguetown/warden = 4,//split with vanguard
	)
	title_adjust = list(
		/datum/job/roguetown/physician = list(display_title = "宫廷医师"),
		/datum/job/roguetown/niteman = list(display_title = "夜主", f_title = "夜主"),
		/datum/job/roguetown/nightmaiden = list(display_title = "夜侍", f_title = "夜侍女"),
		// /datum/job/roguetown/marshal = list(display_title = "Mayor"),
	)
	tutorial_adjust = list(
		/datum/job/roguetown/captain = "你的血脉高贵，几代强大忠诚的骑士和兵士在你之前诞生。你曾在皇家陛下麾下优雅地担任骑士，如今已成长为无数人只能梦想成为的角色。 \
				作为骑士中的老手，你带领王室的骑士和忠诚兵士奔赴战场，并组织训练侍从。只听从执法官和王室的命令。 \
				率领你的部下走向胜利——并管住他们——你将看到这个国度在万千太阳之下的繁荣昌盛。",
		/datum/job/roguetown/physician = "你是一位医学大师，深得公爵本人信赖，负责为王室宗亲、宫廷朝臣、\
			其护卫及其臣民提供专业医护。你主要在庄园医疗翼的城堡内居住，但也同样可以出入 \
			上城区的本地诊所，那里有资历较浅的持证药剂师在你的偶尔路过指点下行医。",
		// /datum/job/roguetown/archivist = "CHANGE THIS!! - Teach people skills, whether DIRECTLY or by writing SKILLBOOKS. You and the Veteran next door teach people shit."
		/datum/job/roguetown/warden = "通过在先锋队中多年的侦察、散兵作战和生存历练，你已被接纳加入守林人——一支精英游侠团体，常年监视着未驯化荒野的动静。 \
				你受信赖深入下城南方的蛮荒黑暗之中，担任侦察兵、战士、哨兵和向导，执行远程侦察、铲除危险野兽、与先锋队一起保卫下城。 \
				你隶属于守林总长，执法官和王室也可随时调你充任卫戍成员。\
				作为对抗文明边疆之外威胁的第一道防线，履行职责，保障道路安全，坚守先锋堡垒。王室在指望你。",
		/datum/job/roguetown/manorguard = "你已证明了自己的忠诚和能力，被委以保卫城堡并在全市和公国内贯彻其意志的重任。 \
				定期接受战斗和攻城训练，你负责应对来自内部和外部的威胁。 \
				服从你的执法官、骑士队长和王室。对贵族和骑士保持尊敬，这样你才能赢得他们的尊重。不是作为平民，而是作为一名兵士..",
		/datum/job/roguetown/marshal = "你是王室在律法和军事事务上的代理人，确保法律得到推行、验证，并由随从队伍对全国臣民予以施行。 \
				作为军事事务的最高权威，你的大部分工作在案牍之后完成，在骑士队长、守望队长和守林总长之间分派任务，担任主要的 \
				协调人，确保公爵的意志——通过你——在战场上得以贯彻。",
		/datum/job/roguetown/rookie = "杂活跑腿、传递消息、修补缺漏、与当地人攀谈；城市守望队总需要多一双耳目、多一双手。协助同伴守望队员应对来自内部和外部的威胁。 \
				在武器与守卫勤务方面只受过简短介绍，其余的训练得靠边干边学。 \
				服从你的上级（除你之外的每一个人），对贵族保持尊敬。多留心观察，尽量学点东西，总有一天你或许能活成一个像样的兵。"
	
	)
	// species_adjust = list()
	// sexes_adjust = list()
	//Threat regions is used for displaying specific regions on notice boards
	threat_regions = list(
		THREAT_REGION_ROCKHILL_BASIN,
		THREAT_REGION_ROCKHILL_BOG_NORTH,
		THREAT_REGION_ROCKHILL_BOG_WEST,
		THREAT_REGION_ROCKHILL_BOG_SOUTH,
		THREAT_REGION_ROCKHILL_BOG_SUNKMIRE,
		THREAT_REGION_ROCKHILL_WOODS_NORTH,
		THREAT_REGION_ROCKHILL_WOODS_SOUTH
	)
d
