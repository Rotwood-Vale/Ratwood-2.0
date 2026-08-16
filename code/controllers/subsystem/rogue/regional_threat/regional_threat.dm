

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
	THREAT_REGION_ROCKHILL_WOODS_SOUTH = /datum/threat_region/rockhill_woods_south,

	//Desertmap
	THREAT_REGION_DESERT_NEAR = /datum/threat_region/desert_near,
	THREAT_REGION_DESERT_DEEP = /datum/threat_region/desert_deep,

	//BYOS
	THREAT_REGION_JUNGLE = /datum/threat_region/byos_jungle,
	THREAT_REGION_ISLAND = /datum/threat_region/byos_island,
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

/// Weighted pick of a region that allows the given quest type, weighted by fill ratio
/// (latent_ambush / max_ambush). Regions with more relative threat are picked more often, so
/// as adventurers clear a region its quest share naturally drops. Returns null if no region
/// allows the type.
/datum/controller/subsystem/regionthreat/proc/pick_region_for_quest(quest_type)
	var/list/weights = list()
	for(var/T in threat_regions)
		var/datum/threat_region/TR = T
		if(!TR.allows_quest_type(quest_type))
			continue
		var/weight = TR.get_threat_weight()
		if(weight <= 0)
			continue
		// get_threat_weight() is a fractional 0-1 fill ratio; scale to a positive integer so the
		// summed weight is always >= 1 (stock pickweight() does rand(1, total) and returns null when
		// the total is < 1). max(1, ...) keeps every eligible region selectable after the floor.
		weights[TR] = max(1, round(weight * 1000))
	if(!length(weights))
		// Fall back: any region that allows the type, ignoring fill ratio.
		for(var/T in threat_regions)
			var/datum/threat_region/TR = T
			if(TR.allows_quest_type(quest_type))
				weights[TR] = 1
		if(!length(weights))
			return null
	return pickweight(weights)

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

	// Swap any trade region whose default identity clashes with this map. Must run before the
	// route map below, which writes threat_region_id onto the instance being replaced.
	if(map.trade_region_swaps)
		for(var/trade_id in map.trade_region_swaps)
			var/datum/economic_region/replacement = map.trade_region_swaps[trade_id]
			if(!ispath(replacement, /datum/economic_region))
				stack_trace("RegionThreat: trade_region_swaps entry for [trade_id] is not an economic_region path")
				continue
			var/datum/economic_region/swapped = new replacement()
			if(swapped.region_id != trade_id)
				stack_trace("RegionThreat: swap for [trade_id] declares region_id [swapped.region_id]")
				continue
			GLOB.economic_regions[trade_id] = swapped

	// Re-point the trade roads' blockade regions at this map's wilderness. Runs here rather
	// than in SSeconomy so the remap is in place before anything reads threat_region_id.
	if(map.blockade_route_map)
		for(var/trade_id in map.blockade_route_map)
			var/datum/economic_region/ER = GLOB.economic_regions[trade_id]
			if(!ER)
				stack_trace("RegionThreat: blockade_route_map names unknown trade region [trade_id]")
				continue
			ER.threat_region_id = map.blockade_route_map[trade_id]
