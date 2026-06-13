SUBSYSTEM_DEF(mobs)
	name = "Mobs (Alive)"
	priority = FIRE_PRIORITY_MOBS
	flags = SS_KEEP_TIMING | SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	var/list/currentrun = list()
	var/static/list/clients_by_zlevel[][]
	var/static/list/dead_players_by_zlevel[][] = list(list())
	var/static/list/cubemonkeys = list()
	var/alive_mobs = 0
	var/hibernating_mobs = 0
	var/list/active_z_map
	var/full_recheck = FALSE

/datum/controller/subsystem/mobs/stat_entry()
	..("A:[alive_mobs]/[GLOB.mob_living_active_list.len] H:[hibernating_mobs]")

/datum/controller/subsystem/mobs/proc/MaxZChanged()
	if (!islist(clients_by_zlevel))
		clients_by_zlevel = new /list(world.maxz,0)
		dead_players_by_zlevel = new /list(world.maxz,0)
	while (clients_by_zlevel.len < world.maxz)
		clients_by_zlevel.len++
		clients_by_zlevel[clients_by_zlevel.len] = list()
		dead_players_by_zlevel.len++
		dead_players_by_zlevel[dead_players_by_zlevel.len] = list()

/datum/controller/subsystem/mobs/proc/MaxZDec()
	if (!islist(clients_by_zlevel))
		clients_by_zlevel = new /list(world.maxz,0)
		dead_players_by_zlevel = new /list(world.maxz,0)
	while (clients_by_zlevel.len > world.maxz)
		clients_by_zlevel.len--
		dead_players_by_zlevel.len--

/datum/controller/subsystem/mobs/proc/build_active_z_map()
	if(!islist(clients_by_zlevel) || !world.maxz)
		return null
	var/list/active = new /list(world.maxz)
	for(var/z in 1 to min(clients_by_zlevel.len, world.maxz))
		if(!length(clients_by_zlevel[z]))
			continue
		active[z] = TRUE
		// Keep adjacent z-levels active to prevent mobs from freezing or behaving incorrectly during cross-z interactions.
		// This should eventually be replaced with a proper cross-z wake-up mechanism.
		// TODO: Ideally, mobs should wake when a character enters the relevant nearby area.
		if(z > 1)
			active[z - 1] = TRUE
		if(z < world.maxz)
			active[z + 1] = TRUE
	return active

/datum/controller/subsystem/mobs/fire(resumed = 0)
	var/seconds = wait * 0.1

	if (!resumed)
		src.currentrun = GLOB.mob_living_active_list.Copy()
		alive_mobs = 0
		hibernating_mobs = 0
		active_z_map = build_active_z_map()
		src.full_recheck = !(src.times_fired % max(round(HIBERNATION_REVALIDATE_TIME / wait), 1))
	var/list/currentrun = src.currentrun
	var/list/active_z = src.active_z_map
	var/full_recheck = src.full_recheck
	var/times_fired = src.times_fired

	while(currentrun.len)
		var/mob/living/L = currentrun[currentrun.len]
		currentrun.len--

		if(!L || QDELETED(L))
			GLOB.mob_living_active_list -= L
			continue

		if(L.stat == DEAD)
			continue

		if(L.hibernating)
			if(!full_recheck && !L.client && !L.ckey)
				if(ishuman(L))
					var/mob/living/carbon/human/sleeper = L
					if(!sleeper.clients_in_range)
						hibernating_mobs++
						continue
				else
					var/turf/sleeper_turf = L.loc
					if(isturf(sleeper_turf) && active_z && sleeper_turf.z <= active_z.len && !active_z[sleeper_turf.z])
						hibernating_mobs++
						continue
			L.hibernating = FALSE

		if(L.should_hibernate(active_z))
			L.hibernating = TRUE
			hibernating_mobs++
			continue

		L.Life(seconds, times_fired)
		alive_mobs++

		if (MC_TICK_CHECK)
			return

SUBSYSTEM_DEF(mobs_dead)
	name = "Mobs (Dead)"
	priority = FIRE_PRIORITY_MOBS_DEAD
	flags = SS_KEEP_TIMING | SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 6 SECONDS
	var/list/currentrun = list()
	var/dead_mobs = 0
	var/hibernating_mobs = 0
	var/list/active_z_map
	var/full_recheck = FALSE

/datum/controller/subsystem/mobs_dead/stat_entry()
	..("D:[dead_mobs]/[GLOB.mob_living_dead_list.len] H:[hibernating_mobs]")

/datum/controller/subsystem/mobs_dead/fire(resumed = 0)
	var/seconds = wait * 0.1

	if(!resumed)
		src.currentrun = GLOB.mob_living_dead_list.Copy()
		dead_mobs = 0
		hibernating_mobs = 0
		active_z_map = SSmobs.build_active_z_map()
		src.full_recheck = !(src.times_fired % max(round(HIBERNATION_REVALIDATE_TIME / wait), 1))

	var/list/currentrun = src.currentrun
	var/list/active_z = src.active_z_map
	var/full_recheck = src.full_recheck

	while(currentrun.len)
		var/mob/living/L = currentrun[currentrun.len]
		currentrun.len--

		if(!L || QDELETED(L))
			GLOB.mob_living_dead_list -= L
			continue

		if(L.stat != DEAD)
			continue

		if(L.hibernating)
			if(!full_recheck && !L.client && !L.ckey)
				var/turf/sleeper_turf = L.loc
				if(isturf(sleeper_turf) && active_z && sleeper_turf.z <= active_z.len && !active_z[sleeper_turf.z])
					hibernating_mobs++
					continue
			L.hibernating = FALSE

		if(L.should_hibernate(active_z))
			L.hibernating = TRUE
			hibernating_mobs++
			continue

		L.DeadLife(seconds)
		dead_mobs++

		if (MC_TICK_CHECK)
			return
