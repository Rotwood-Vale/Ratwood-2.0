/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/smollhill
	map_file_name = "smollhill.dmm"
	realm_name = "Rockhill"
	blacklist = list(
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
		/datum/job/roguetown/dtchaplain,

		/datum/job/roguetown/tribalchieftain,
		/datum/job/roguetown/tribalshaman,
		/datum/job/roguetown/tribalguard,
		/datum/job/roguetown/tribalrabble,
		/datum/job/roguetown/tribalvillager,

		/datum/job/roguetown/jester,
		/datum/job/roguetown/steward,
		/datum/job/roguetown/clerk,
		/datum/job/roguetown/wapprentice,
		/datum/job/roguetown/butler,
		/datum/job/roguetown/chaplain,
		/datum/job/roguetown/magician,

		/datum/job/roguetown/prince,
		/datum/job/roguetown/hand,
		/datum/job/roguetown/lady,
		/datum/job/roguetown/baron,

		/datum/job/roguetown/captain,
		/datum/job/roguetown/manorguard,
		/datum/job/roguetown/marshal,
		/datum/job/roguetown/rookie,
		/datum/job/roguetown/knight,
		/datum/job/roguetown/watchcaptain,
		/datum/job/roguetown/sergeant,
		/datum/job/roguetown/veteran,
		/datum/job/roguetown/dungeoneer,
		/datum/job/roguetown/guardsman,
		/datum/job/roguetown/squire,

		/datum/job/roguetown/nightmaiden,
		/datum/job/roguetown/cook,
		/datum/job/roguetown/shophand,
		/datum/job/roguetown/gapprentice,
		/datum/job/roguetown/prisonerr,
		/datum/job/roguetown/crier,
		/datum/job/roguetown/niteman,
		/datum/job/roguetown/archivist,
		/datum/job/roguetown/barkeep,
		/datum/job/roguetown/guildsman,
		/datum/job/roguetown/guildmaster,
		/datum/job/roguetown/tailor,
		/datum/job/roguetown/knavewench,
		/datum/job/roguetown/adventurer/courtagent,

		/datum/job/roguetown/orthodoxist,
		/datum/job/roguetown/absolver,
		/datum/job/roguetown/keeper,
		/datum/job/roguetown/martyr,

		)
	slot_adjust = list(
		/datum/job/roguetown/councillor = 1,
		/datum/job/roguetown/warden = 6,
		/datum/job/roguetown/templar = 2,
		/datum/job/roguetown/servant = 1,
		/datum/job/roguetown/rockhillslave = 6,
	)
	title_adjust = list(
		/datum/job/roguetown/lord = list(display_title = "Baron", f_title = "Baroness"),
	)
	tutorial_adjust = list(
		/datum/job/roguetown/warden = "Having proven yourself through years of scouting, skirmishing and survival in the vanguard, you have been initiated into the Wardens - an elite fraternity of ranger types who keep a vigil over the untamed wilderness. Trusted to venture deep into the uncivilised darkness south of lowtown, you act as a scout, soldier, sentinel and guide, performing long-range reconnaissance, culling dangerous wildlife, and protecting lowtown alongside the vanguard. You are subordinate to the Master Warden, whom in turn serves the baron and may be called upon as members of the garrison by the Marshal and Crown. Serve the baron's will as the first line of defence from threats beyond the borders of civilisation, keep the roads safe, and hold the vanguard fortress. The Crown is counting on you.",

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
		THREAT_REGION_ROCKHILL_WOODS_SOUTH,
	)
	// The realm is Rockhill here, so the Rockhill trade county becomes Vespermill, its
	// noble seat. Same region_id and goods; only the identity changes.
	trade_region_swaps = list(
		TRADE_REGION_ROCKHILL = /datum/economic_region/vespermill,
	)
	// Towner postings: the caravan runs the wooded roads (highwaymen in the faction
	// tables), the miner's lead strikes the deep bogs. Both target regions carry hard
	// spawners and allow the towner types.
	towner_quest_regions = list(
		QUEST_TOWNER_SMITH_CARAVAN = list(THREAT_REGION_ROCKHILL_WOODS_NORTH, THREAT_REGION_ROCKHILL_WOODS_SOUTH),
		QUEST_TOWNER_MINER_OREVEIN = list(THREAT_REGION_ROCKHILL_BOG_SUNKMIRE, THREAT_REGION_ROCKHILL_BOG_WEST),
	)
	// Blockade routes. Tiers mirror dun_world's: grove-tier roads (no travel fee)
	// through the woods, coast-tier (75) through the outer bogs, mountain-tier (150)
	// through Sunkmire. Every target region carries hard quest spawners - a road
	// mapped to a region without one can never host its defense.
	blockade_route_map = list(
		TRADE_REGION_KINGSFIELD = THREAT_REGION_ROCKHILL_WOODS_SOUTH,
		TRADE_REGION_ROSAWOOD = THREAT_REGION_ROCKHILL_WOODS_NORTH,
		TRADE_REGION_BLACKHOLT = THREAT_REGION_ROCKHILL_WOODS_SOUTH,
		TRADE_REGION_HEARTFELT = THREAT_REGION_ROCKHILL_WOODS_NORTH,
		TRADE_REGION_ROCKHILL = THREAT_REGION_ROCKHILL_BOG_NORTH,
		TRADE_REGION_SALTWICK = THREAT_REGION_ROCKHILL_BOG_WEST,
		TRADE_REGION_BLEAKCOAST = THREAT_REGION_ROCKHILL_BOG_SOUTH,
		TRADE_REGION_NORTHFORT = THREAT_REGION_ROCKHILL_BOG_SUNKMIRE,
		TRADE_REGION_HAGENWALD = THREAT_REGION_ROCKHILL_BOG_SUNKMIRE,
		TRADE_REGION_DAFTSMARCH = THREAT_REGION_ROCKHILL_BOG_SUNKMIRE,
	)

/datum/map_adjustment/template/smollhill/job_change()
	. = ..()
	var/datum/job/baron = SSjob.GetJobType(/datum/job/roguetown/baron)
	baron.always_show_on_latechoices = FALSE
