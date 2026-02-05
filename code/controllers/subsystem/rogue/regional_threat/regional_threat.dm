

GLOBAL_LIST_INIT(threat_region_templates, list(
	//Dunworld
	THREAT_REGION_AZURE_BASIN = /datum/threat_region/azure_basin,
	THREAT_REGION_AZURE_GROVE = /datum/threat_region/azure_grove,
	THREAT_REGION_TERRORBOG = /datum/threat_region/terrorbog,
	THREAT_REGION_AZUREAN_COAST = /datum/threat_region/azure_coast,
	THREAT_REGION_MOUNT_DECAP = /datum/threat_region/mount_decap,

	// Rockhill
	THREAT_REGION_ROCKHILL_BASIN = /datum/threat_region/rockhill_basin,
	THREAT_REGION_ROCKHILL_BOG_NORTH = /datum/threat_region/rockhill_bog_north,
	THREAT_REGION_ROCKHILL_BOG_WEST = /datum/threat_region/rockhill_bog_west,
	THREAT_REGION_ROCKHILL_BOG_SOUTH = /datum/threat_region/rockhill_bog_south,
	THREAT_REGION_ROCKHILL_BOG_SUNKMIRE = /datum/threat_region/rockhill_bog_sunkmire,
	THREAT_REGION_ROCKHILL_WOODS_NORTH = /datum/threat_region/rockhill_woods_north,
	THREAT_REGION_ROCKHILL_WOODS_SOUTH = /datum/threat_region/rockhill_woods_south
))


// Subsystem meant to handle regional threat level

SUBSYSTEM_DEF(regionthreat)
	name = "Regional Threat"
	wait = 15 MINUTES
	flags = SS_KEEP_TIMING | SS_BACKGROUND
	runlevels = RUNLEVEL_GAME
	// The first four regions are meant to be "tameable" for towner purposes
	var/list/threat_regions

/datum/controller/subsystem/regionthreat/fire(resumed)
	var/player_count = GLOB.player_list.len
	var/ishighpop = player_count >= LOWPOP_THRESHOLD
	for(var/T in threat_regions)
		var/datum/threat_region/TR = T
		if(ishighpop)
			TR.increase_latent_ambush(TR.highpop_tick)
		else
			TR.increase_latent_ambush(TR.lowpop_tick)

/datum/controller/subsystem/regionthreat/proc/get_region(region_name)
	for(var/T in threat_regions)
		var/datum/threat_region/TR = T
		if(TR.region_name == region_name)
			return TR
	return null

/datum/threat_region_display
	var/region_name
	var/danger_level
	var/danger_color

/datum/controller/subsystem/regionthreat/proc/get_threat_regions_for_display()
	var/list/threat_region_displays = list()
	for(var/T in threat_regions)
		var/datum/threat_region/TR = T
		var/datum/threat_region_display/TRS = new /datum/threat_region_display
		TRS.region_name = TR.region_name
		TRS.danger_level = TR.get_danger_level()
		TRS.danger_color = TR.get_danger_color()
		threat_region_displays += TRS
	return threat_region_displays

/datum/controller/subsystem/regionthreat/proc/on_map_ready()
	threat_regions = list()
	var/datum/map_adjustment/template/map = SSmapping.map_adjustment
	if(!map)
		stack_trace("RegionThreat: map_adjustment missing in on_map_ready()")
		return

	if(!map.threat_regions)
		log_world("RegionThreat: No threat regions defined for [map.map_file_name]")
		return

	for(var/region_name in map.threat_regions)
		var/path = GLOB.threat_region_templates[region_name]
		if(!path)
			stack_trace("RegionThreat: Missing threat template for [region_name]")
			continue
		threat_regions += new path()

	log_world("RegionThreat: Loaded [threat_regions.len] threat regions for [map.realm_name]")