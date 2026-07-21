SUBSYSTEM_DEF(lighting)
	name = "Lighting"
	wait = 0
	init_order = INIT_ORDER_LIGHTING
	flags = SS_TICKER
	priority = FIRE_PRIORITY_DEFAULT
	var/static/list/sources_queue = list() // List of lighting sources queued for update.
	var/static/list/corners_queue = list() // List of lighting corners queued for update.
	var/static/list/objects_queue = list() // List of lighting objects queued for update.
	processing_flag = PROCESSING_LIGHTING

/datum/controller/subsystem/lighting/stat_entry()
	..("L:[length(sources_queue)]|C:[length(corners_queue)]|O:[length(objects_queue)]")


/datum/controller/subsystem/lighting/Initialize(timeofday)
	if(!initialized)
		if (CONFIG_GET(flag/starlight))
			for(var/I in GLOB.sortedAreas)
				var/area/A = I
				if (A.dynamic_lighting == DYNAMIC_LIGHTING_IFSTARLIGHT)
					A.luminosity = 0

		create_all_lighting_objects()
		initialized = TRUE

	fire(FALSE, TRUE)

	return ..()

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
		var/atom/movable/lighting_object/lighting_object = queue[current_index]
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
