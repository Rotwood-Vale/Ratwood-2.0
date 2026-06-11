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

/datum/controller/subsystem/mobs/stat_entry()
	..("A:[alive_mobs]/[GLOB.mob_living_active_list.len]")

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

/datum/controller/subsystem/mobs/fire(resumed = 0)
	var/seconds = wait * 0.1

	if (!resumed)
		src.currentrun = GLOB.mob_living_active_list.Copy()
		alive_mobs = 0
	var/list/currentrun = src.currentrun
	var/times_fired = src.times_fired

	while(currentrun.len)
		var/mob/living/L = currentrun[currentrun.len]
		currentrun.len--

		if(!L || QDELETED(L))
			GLOB.mob_living_list -= L
			GLOB.mob_living_active_list -= L
			GLOB.mob_living_dead_list -= L
			GLOB.alive_mob_list -= L
			GLOB.dead_mob_list -= L
			continue

		if(L.stat == DEAD)
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
	var/mob/living/current_dead_mob
	var/remaining_dead_life_iterations = 0
	var/dead_mobs = 0

/datum/controller/subsystem/mobs_dead/stat_entry()
	..("D:[dead_mobs]/[GLOB.mob_living_dead_list.len]")

/datum/controller/subsystem/mobs_dead/fire(resumed = 0)
	if(!resumed)
		src.currentrun = GLOB.mob_living_dead_list.Copy()
		current_dead_mob = null
		remaining_dead_life_iterations = 0
		dead_mobs = 0

	var/list/currentrun = src.currentrun
	// Preserve the old two-second DeadLife cadence while scanning the dead list every six seconds.
	var/dead_life_iterations = max(round(wait / SSmobs.wait), 1)

	while(current_dead_mob || currentrun.len)
		if(!current_dead_mob)
			var/mob/living/next_mob = currentrun[currentrun.len]
			currentrun.len--

			if(!next_mob || QDELETED(next_mob))
				GLOB.mob_living_list -= next_mob
				GLOB.mob_living_active_list -= next_mob
				GLOB.mob_living_dead_list -= next_mob
				GLOB.alive_mob_list -= next_mob
				GLOB.dead_mob_list -= next_mob
				continue

			if(next_mob.stat != DEAD)
				continue

			current_dead_mob = next_mob
			remaining_dead_life_iterations = dead_life_iterations
			dead_mobs++

		if(QDELETED(current_dead_mob) || current_dead_mob.stat != DEAD)
			current_dead_mob = null
			remaining_dead_life_iterations = 0
			continue

		current_dead_mob.DeadLife()
		remaining_dead_life_iterations--
		if(remaining_dead_life_iterations <= 0 || QDELETED(current_dead_mob) || current_dead_mob.stat != DEAD)
			current_dead_mob = null
			remaining_dead_life_iterations = 0

		if (MC_TICK_CHECK)
			return
