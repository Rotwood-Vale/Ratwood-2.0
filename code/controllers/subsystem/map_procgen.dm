SUBSYSTEM_DEF(map_procgen)
	name = "Map Generators"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_MAPGEN

	/// Queued generators created by landmarks.
	var/list/datum/mapGenerator/generators_to_run = list()

/datum/controller/subsystem/map_procgen/proc/queue_map_generator(datum/mapGenerator/to_queue)
	if(Master.current_runlevel)
		message_admins("HEY CLOWNASS, DO NOT FUCKING SPAWN THESE.")
		CRASH("Admin attempted to spawn mapgen landmark post-init.")
	generators_to_run.Add(to_queue)

/datum/controller/subsystem/map_procgen/Initialize(start_timeofday)
	var/count = length(generators_to_run)
	to_chat_immediate(GLOB.admins, span_admin("PROCGEN: Running [count] queued generators."))
	log_world("Running [count] queued generators.")

	for(var/datum/mapGenerator/map_gen as anything in generators_to_run)
		map_gen.generate()
		CHECK_TICK
		to_chat_immediate(GLOB.admins, span_admin("Finished generator [map_gen.type]"))
		log_world("Finished generator [map_gen.type]")
	. = ..()
