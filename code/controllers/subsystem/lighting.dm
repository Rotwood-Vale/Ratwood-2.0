SUBSYSTEM_DEF(lighting)
	name = "Lighting"
	dependencies = list(
		/datum/controller/subsystem/atoms,
		/datum/controller/subsystem/mapping,
		/datum/controller/subsystem/treesetup,
		//Can we possibly move this to BEFORE atom init in some way? I sure fuckin hope so.
		/datum/controller/subsystem/map_procgen,
		/datum/controller/subsystem/language,
		/datum/controller/subsystem/machines,
		/datum/controller/subsystem/skills,
		/datum/controller/subsystem/adjacent_air,
		/datum/controller/subsystem/processing/tracks,
		/datum/controller/subsystem/elastic,
		/datum/controller/subsystem/familytree,
		/datum/controller/subsystem/map_vote,
		/datum/controller/subsystem/memory_stats,
		/datum/controller/subsystem/migrants,
		/datum/controller/subsystem/nightshift,
		/datum/controller/subsystem/parallax,
		/datum/controller/subsystem/ParticleWeather,
		/datum/controller/subsystem/traumas,
		/datum/controller/subsystem/weather,
		/datum/controller/subsystem/cooking,
		/datum/controller/subsystem/chimeric_tech,
		/datum/controller/subsystem/hunting,
		/datum/controller/subsystem/treasury,
		/datum/controller/subsystem/city_assembly,
		/datum/controller/subsystem/questpool,
		/datum/controller/subsystem/pollution,
		/datum/controller/subsystem/economy,
		/datum/controller/subsystem/assets,
		/datum/controller/subsystem/icon_smooth,
		/datum/controller/subsystem/ipintel,
		/datum/controller/subsystem/stickyban,
	)
	dependents = list(
		/datum/controller/subsystem/outdoor_effects,
		/datum/controller/subsystem/merchant,
		/datum/controller/subsystem/merchant_trade,
		/datum/controller/subsystem/minor_mapping,
		/datum/controller/subsystem/point_ambience,
		/datum/controller/subsystem/pathfinder,
		/datum/controller/subsystem/persistence,
	)
	wait = 0
	ss_flags = SS_TICKER
	priority = FIRE_PRIORITY_DEFAULT
	var/static/list/sources_queue = list() // List of lighting sources queued for update.
	var/static/list/corners_queue = list() // List of lighting corners queued for update.
	var/static/list/objects_queue = list() // List of lighting objects queued for update.
	processing_flag = PROCESSING_LIGHTING

/datum/controller/subsystem/lighting/stat_entry()
	..("L:[length(sources_queue)]|C:[length(corners_queue)]|O:[length(objects_queue)]")


/datum/controller/subsystem/lighting/Initialize()
	if(!initialized)
		if (CONFIG_GET(flag/starlight))
			for(var/I in GLOB.sortedAreas)
				var/area/A = I
				if (A.dynamic_lighting == DYNAMIC_LIGHTING_IFSTARLIGHT)
					A.luminosity = 0

		create_all_lighting_objects()
		initialized = TRUE

	fire(FALSE, TRUE)

	return SS_INIT_SUCCESS

/datum/controller/subsystem/lighting/fire(resumed, init_tick_checks)
	MC_SPLIT_TICK_INIT(3)
	if(!init_tick_checks)
		MC_SPLIT_TICK
	var/list/queue = sources_queue
	// anything added while processing gets deferred to the next tick
	var/current_index = 0
	while(current_index < length(queue))
		current_index += 1
		var/datum/light_source/source = queue[current_index]
		source.update_corners()
		// source.update_corners() can qdel(source) in certain conditions,
		// and we don't include them in the count to cut because they're already removed
		if(!QDELING(source))
			source.needs_update = LIGHTING_NO_UPDATE
		else
			current_index -= 1
		if(init_tick_checks)
			if(!TICK_CHECK)
				continue
			queue.Cut(1, current_index + 1)
			current_index = 0
			stoplag()
		else if (MC_TICK_CHECK)
			break
	if(current_index)
		queue.Cut(1, current_index + 1)
		current_index = 0

	if(!init_tick_checks)
		MC_SPLIT_TICK

	queue = corners_queue
	while(current_index < length(queue))
		current_index += 1
		var/datum/lighting_corner/corner = queue[current_index]
		corner.update_objects()
		corner.needs_update = FALSE //update_objects() can call qdel if the corner is storing no data
		if(QDELING(corner))
			current_index -= 1

		if(init_tick_checks)
			if(!TICK_CHECK)
				continue
			queue.Cut(1, current_index + 1)
			current_index = 0
			stoplag()
		else if (MC_TICK_CHECK)
			break
	if(current_index)
		queue.Cut(1, current_index + 1)
		current_index = 0

	if(!init_tick_checks)
		MC_SPLIT_TICK

	queue = objects_queue
	while(current_index < length(queue))
		current_index += 1
		var/datum/lighting_object/lighting_object = queue[current_index]
		// these can't delete themselves in update() and so nothing in this should be qdeleted
		ASSERT(!QDELETED(lighting_object))
		lighting_object.update()
		lighting_object.needs_update = FALSE
		if(init_tick_checks)
			if(!TICK_CHECK)
				continue
			queue.Cut(1, current_index + 1)
			current_index = 0
			stoplag()
		else if (MC_TICK_CHECK)
			break
	if(current_index)
		queue.Cut(1, current_index + 1)
		current_index = 0
	if(!init_tick_checks)
		MC_SPLIT_TICK


/datum/controller/subsystem/lighting/Recover()
	initialized = SSlighting.initialized
	..()
