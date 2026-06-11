
SUBSYSTEM_DEF(humannpc)
	name = "humannpc"
	wait = 1 SECONDS
	flags = SS_KEEP_TIMING
	priority = 50
	var/list/processing = list()
	var/list/currentrun = list()
	processing_flag = PROCESSING_HUMANNPC

/datum/controller/subsystem/humannpc/fire(resumed = 0)
	if (!currentrun.len)
		currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/current = src.currentrun
	while(current.len)
		var/mob/living/carbon/human/thing = current[current.len]
		current.len--
		if (!thing || QDELETED(thing))
			STOP_PROCESSING(src, thing)
			if (MC_TICK_CHECK)
				return
			continue
		try_process_ai(thing)
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/humannpc/proc/try_process_ai(mob/living/carbon/human/thing)
	set waitfor = FALSE
	if(thing.ai_currently_active)
		return // Already running from another tick, don't do another action!
	var/list/active_z = SSmobs.active_z_map
	if(active_z && !thing.client && !thing.ckey && thing.can_hibernate())
		var/turf/thing_turf = get_turf(thing)
		if(thing_turf && thing_turf.z <= active_z.len && !active_z[thing_turf.z])
			return
	thing.ai_currently_active = TRUE
	. = thing.process_ai()
	thing.ai_currently_active = FALSE
	if(.)
		STOP_PROCESSING(src, thing)
