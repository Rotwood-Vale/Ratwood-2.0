/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/dunworld
	map_file_name = "dun_world.dmm"
	realm_name = "Rotwood Vale"
	blacklist = list()
	// slot_adjust = list(
	// 	/datum/job/roguetown/villager = 42,
	// // 	/datum/job/roguetown/adventurer = 69
	// )
	title_adjust = list(
	)
	tutorial_adjust = list(
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