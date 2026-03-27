/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/dunworld
	map_file_name = "dun_world.dmm"
	realm_name = "Rotwood Vale"
	blacklist = list(
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
		/datum/job/roguetown/rookie = "Odd-jobs, running messages, fixing dents and talking to locals; the Men at Arms can always use a spare pair of hands, eyes and ears. Assist your fellow guards in dealing with threats - both within and without. \
				Given a brief introduction in weapons and guardwork, the rest of your training is to be picked up on the job. \
				Obey your superiors (everyone who isn't you) and show the nobles your respect. Keep an eye out, try to learn a thing or two, then one day you might live to make an adequate soldier."
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
