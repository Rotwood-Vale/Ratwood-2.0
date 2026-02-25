SUBSYSTEM_DEF(mobs)
	name = "Mobs"
	priority = FIRE_PRIORITY_MOBS
	flags = SS_KEEP_TIMING | SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	var/list/currentrun = list()
	var/static/list/clients_by_zlevel[][]
	var/static/list/dead_players_by_zlevel[][] = list(list())
	var/static/list/cubemonkeys = list()
	var/alive_mobs = 0
	
	// Bucket system for performance optimization
	var/current_bucket = 0  // Rotates 0-7 for staggered processing
	var/list/high_priority_mobs = list()    // Process every tick (players, combat mobs, nearby NPCs)
	var/list/medium_priority_mobs = list()  // Process every 2 ticks (moderate distance)
	var/list/low_priority_mobs = list()     // Process every 4 ticks (far from players)
	var/list/minimal_priority_mobs = list() // Process every 8 ticks (very far, sleeping NPCs)
	var/next_bucket_update = 0              // When to recalculate bucket assignments

/datum/controller/subsystem/mobs/stat_entry()
	..("P:[GLOB.mob_living_list.len]|H:[high_priority_mobs.len]|M:[medium_priority_mobs.len]|L:[low_priority_mobs.len]|X:[minimal_priority_mobs.len]")

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
	
	// Update bucket assignments every 10 seconds
	if(!resumed && world.time >= next_bucket_update)
		recalculate_mob_buckets()
		next_bucket_update = world.time + 100 // 10 seconds

	current_bucket = (current_bucket + 1) % 8 // Rotate 0-7

	if (!resumed)
		// Build list of mobs to process this tick based on bucket priority
		src.currentrun = list()
		alive_mobs = 0
		
		// HIGH priority: Always process (players, combat, nearby NPCs)
		for(var/mob/living/L in high_priority_mobs)
			if(L && !QDELETED(L))
				src.currentrun += L
		
		// MEDIUM priority: Process every 2 ticks (buckets 0,2,4,6)
		if(current_bucket % 2 == 0)
			for(var/mob/living/L in medium_priority_mobs)
				if(L && !QDELETED(L))
					src.currentrun += L
		
		// LOW priority: Process every 4 ticks (buckets 0,4)
		if(current_bucket % 4 == 0)
			for(var/mob/living/L in low_priority_mobs)
				if(L && !QDELETED(L))
					src.currentrun += L
		
		// MINIMAL priority: Process every 8 ticks (bucket 0 only)
		if(current_bucket == 0)
			for(var/mob/living/L in minimal_priority_mobs)
				if(L && !QDELETED(L))
					src.currentrun += L
	
	var/list/currentrun = src.currentrun
	var/times_fired = src.times_fired

	while(currentrun.len)
		var/mob/living/L = currentrun[currentrun.len]
		currentrun.len--

		if(!L || QDELETED(L))
			GLOB.mob_living_list.Remove(L)
			remove_from_all_buckets(L)
			continue

		if(L.stat == DEAD)
			L.DeadLife()
		else
			L.Life(seconds, times_fired)
			alive_mobs++

		if (MC_TICK_CHECK)
			return

// Bucket system helper procs for performance optimization

/datum/controller/subsystem/mobs/proc/remove_from_all_buckets(mob/living/L)
	high_priority_mobs -= L
	medium_priority_mobs -= L
	low_priority_mobs -= L
	minimal_priority_mobs -= L

/datum/controller/subsystem/mobs/proc/recalculate_mob_buckets()
	// Clear all buckets
	high_priority_mobs.Cut()
	medium_priority_mobs.Cut()
	low_priority_mobs.Cut()
	minimal_priority_mobs.Cut()
	
	// Cache player positions for distance calculations
	var/list/player_positions = list()
	for(var/client/C in GLOB.clients)
		if(C.mob && isliving(C.mob))
			player_positions += C.mob
	
	// Assign each living mob to appropriate bucket
	for(var/mob/living/L in GLOB.mob_living_list)
		if(!L || QDELETED(L))
			continue
		
		// Players and client-controlled mobs always get HIGH priority
		if(L.client)
			high_priority_mobs += L
			continue
		
		// Dead mobs get MINIMAL priority
		if(L.stat == DEAD)
			minimal_priority_mobs += L
			continue
		
		// Calculate distance to nearest player
		var/min_distance = 9999
		var/turf/L_turf = get_turf(L)
		if(!L_turf)
			minimal_priority_mobs += L
			continue
		
		for(var/mob/living/player in player_positions)
			var/turf/P_turf = get_turf(player)
			if(!P_turf || P_turf.z != L_turf.z)
				continue
			
			var/distance = get_dist(L_turf, P_turf)
			if(distance < min_distance)
				min_distance = distance
		
		// Assign priority based on distance and mob type
		if(min_distance < 15) // Close to players
			high_priority_mobs += L
		else if(min_distance < 30) // Medium distance
			medium_priority_mobs += L
		else if(min_distance < 50) // Far but still relevant
			low_priority_mobs += L
		else // Very far away
			minimal_priority_mobs += L
		
		// Special cases: hostile mobs in combat get HIGH priority
		if(ishostile(L))
			var/mob/living/simple_animal/hostile/H = L
			if(H.target && min_distance < 30) // In combat or hunting
				remove_from_all_buckets(L)
				high_priority_mobs += L

/datum/controller/subsystem/mobs/proc/promote_mob_priority(mob/living/L)
	// Called when a mob enters combat or becomes important
	remove_from_all_buckets(L)
	high_priority_mobs += L

/datum/controller/subsystem/mobs/proc/demote_mob_priority(mob/living/L)
	// Called when a mob should return to normal priority calculation
	// Will be recalculated on next bucket update
	if(L.client)
		return // Never demote players
	
	var/turf/L_turf = get_turf(L)
	if(!L_turf)
		remove_from_all_buckets(L)
		minimal_priority_mobs += L
		return
	
	// Quick distance check to nearest player
	var/min_distance = 9999
	for(var/client/C in GLOB.clients)
		if(!C.mob)
			continue
		var/turf/P_turf = get_turf(C.mob)
		if(!P_turf || P_turf.z != L_turf.z)
			continue
		var/distance = get_dist(L_turf, P_turf)
		if(distance < min_distance)
			min_distance = distance
	
	remove_from_all_buckets(L)
	
	if(min_distance < 15)
		high_priority_mobs += L
	else if(min_distance < 30)
		medium_priority_mobs += L
	else if(min_distance < 50)
		low_priority_mobs += L
	else
		minimal_priority_mobs += L
