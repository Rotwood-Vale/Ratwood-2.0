/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/dunworld
	map_file_name = "dun_world.dmm"
	realm_name = "Rotwood Vale"
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
		
		/datum/job/roguetown/vanguard,//more wardens
		/datum/job/roguetown/guardsman,//MAA do double duty here
		/datum/job/roguetown/watchcaptain,//sergeant does the job here
		/datum/job/roguetown/wardenmaster,//wardens get to be more independent here!
	)
	slot_adjust = list(
		/datum/job/roguetown/warden = 6,
	)
	title_adjust = list(
	)
	tutorial_adjust = list(
		/datum/job/roguetown/rookie = "杂活跑腿、传递消息、修补缺漏、与当地人攀谈；守卫们总需要多一双耳目、多一双手。协助同伴守卫应对来自内部和外部的威胁。 \
				在武器与守卫勤务方面只受过简短介绍，其余的训练得靠边干边学。 \
				服从你的上级（除你之外的每一个人），对贵族保持尊敬。多留心观察，尽量学点东西，总有一天你或许能活成一个像样的兵。"
	)
	species_adjust = list()
	sexes_adjust = list()

	//Threat regions is used for displaying specific regions on notice boards
	threat_regions = list(
		THREAT_REGION_AZURE_BASIN,
		THREAT_REGION_AZURE_GROVE,
		THREAT_REGION_TERRORBOG,
		THREAT_REGION_AZUREAN_COAST,
		THREAT_REGION_MOUNT_DECAP
	)
