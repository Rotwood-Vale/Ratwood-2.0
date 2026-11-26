SUBSYSTEM_DEF(map_procgen)
	name = "Map Generators"
	dependencies = list(
		/datum/controller/subsystem/treesetup,
	)
	dependents = list(
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
	flags = SS_NO_FIRE

	/// Queued generators created by landmarks.
	var/list/datum/mapGenerator/generators_to_run = list()

/datum/controller/subsystem/map_procgen/proc/queue_map_generator(datum/mapGenerator/to_queue)
	if(initialized)
		message_admins("HEY CLOWNASS, DO NOT FUCKING SPAWN THESE.")
		CRASH("Admin attempted to spawn mapgen landmark post-init.")
	generators_to_run.Add(to_queue)

/datum/controller/subsystem/map_procgen/Initialize()
	var/count = length(generators_to_run)
	to_chat_immediate(GLOB.admins, type = MESSAGE_TYPE_DEBUG, html = span_admin("PROCGEN: Running [count] queued generators."))
	log_world("Running [count] queued generators.")

	for(var/datum/mapGenerator/map_gen as anything in generators_to_run)
		map_gen.generate()
		CHECK_TICK
		to_chat_immediate(GLOB.admins, type = MESSAGE_TYPE_DEBUG, html = span_admin("Finished generator [map_gen.type]"))
		log_world("Finished generator [map_gen.type]")
	return SS_INIT_SUCCESS
