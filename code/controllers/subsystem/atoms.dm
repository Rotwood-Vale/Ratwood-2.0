#define BAD_INIT_QDEL_BEFORE 1
#define BAD_INIT_DIDNT_INIT 2
#define BAD_INIT_SLEPT 4
#define BAD_INIT_NO_HINT 8

// how many atoms to init between RSS samples for per-type memory attribution
// procfs reads are cheap; windows shells out per sample so it gets a much coarser window
#define INIT_MEM_SAMPLE_INTERVAL ((world.system_type == UNIX) ? 2048 : 131072)

SUBSYSTEM_DEF(atoms)
	name = "Atoms"
	init_order = INIT_ORDER_ATOMS
	flags = SS_NO_FIRE

	var/old_initialized

	var/list/late_loaders = list()

	var/list/BadInitializeCalls = list()

	/// Whether InitAtom accumulates per-type timing into type_init_profile (mapload batches only)
	var/init_profiling = FALSE
	/// type -> list(count, total_ms, est_bytes) for the current mapload batch
	var/list/type_init_profile = list()
	/// atoms initialized since the last RSS sample
	var/init_mem_counter = 0
	/// RSS at the last sample
	var/init_mem_last_rss
	/// type -> count initialized in the current sampling window
	var/list/init_mem_window = list()

/datum/controller/subsystem/atoms/Initialize(timeofday)
	GLOB.fire_overlay.appearance_flags = RESET_COLOR
	initialized = INITIALIZATION_INNEW_MAPLOAD
	InitializeAtoms()
	return ..()

/datum/controller/subsystem/atoms/proc/InitializeAtoms(list/atoms)
	if(initialized == INITIALIZATION_INSSATOMS)
		return

	initialized = INITIALIZATION_INNEW_MAPLOAD

	init_profiling = !CONFIG_GET(flag/disable_memory_stats)
	if(init_profiling)
		init_mem_counter = 0
		init_mem_window.Cut()
		init_mem_last_rss = get_process_rss_bytes()

	var/count
	var/list/mapload_arg = list(TRUE)
	var/sort_by_type = init_profiling && CONFIG_GET(flag/memory_stats_sorted_init)
	if(sort_by_type)
		// bucket by type so each memory sampling window covers a single type,
		// making per-type attribution exact instead of statistical
		var/list/buckets = list()
		if(atoms)
			for(var/I in atoms)
				var/atom/A = I
				if(!(A.flags_1 & INITIALIZED_1))
					var/list/bucket = buckets[A.type]
					if(!bucket)
						buckets[A.type] = bucket = list()
					bucket += A
				CHECK_TICK
		else
			for(var/atom/A in world)
				if(!(A.flags_1 & INITIALIZED_1))
					var/list/bucket = buckets[A.type]
					if(!bucket)
						buckets[A.type] = bucket = list()
					bucket += A
				CHECK_TICK
		count = 0
		for(var/bucket_type in buckets)
			var/list/bucket = buckets[bucket_type]
			for(var/atom/A as anything in bucket)
				if(!(A.flags_1 & INITIALIZED_1)) // something else's Initialize may have gotten to it
					InitAtom(A, mapload_arg)
					++count
					CHECK_TICK
			// procfs samples are free; windows shells out per sample, so only pay for buckets big enough to matter
			if(world.system_type == UNIX || length(bucket) >= 10000)
				sample_init_memory_window()
	else if(atoms)
		count = atoms.len
		for(var/I in atoms)
			var/atom/A = I
			if(!(A.flags_1 & INITIALIZED_1))
				InitAtom(I, mapload_arg)
				CHECK_TICK
	else
		count = 0
		for(var/atom/A in world)
			if(!(A.flags_1 & INITIALIZED_1))
				InitAtom(A, mapload_arg)
				++count
				CHECK_TICK

	testing("Initialized [count] atoms")
	pass(count)

	if(init_profiling)
		init_profiling = FALSE
		dump_init_profile()

	initialized = INITIALIZATION_INNEW_REGULAR

	if(late_loaders.len)
		for(var/I in late_loaders)
			var/atom/A = I
			A.LateInitialize()
		testing("Late initialized [late_loaders.len] atoms")
		late_loaders.Cut()

/datum/controller/subsystem/atoms/proc/InitAtom(atom/A, list/arguments)
	var/the_type = A.type
	if(QDELING(A))
		BadInitializeCalls[the_type] |= BAD_INIT_QDEL_BEFORE
		return TRUE

	var/start_tick = world.time
	var/profile_start
	if(init_profiling)
		profile_start = TICK_USAGE

	var/result = A.Initialize(arglist(arguments))

	if(init_profiling)
		var/usage_delta = TICK_USAGE - profile_start
		if(usage_delta >= 0) // negative = tick rolled over mid-init, unusable sample
			var/list/entry = type_init_profile[the_type]
			if(!entry)
				type_init_profile[the_type] = entry = list(0, 0, 0)
			entry[1]++
			entry[2] += usage_delta * world.tick_lag
		init_mem_window[the_type] = (init_mem_window[the_type] || 0) + 1
		if(++init_mem_counter >= INIT_MEM_SAMPLE_INTERVAL)
			INVOKE_ASYNC(src, PROC_REF(sample_init_memory_window), null)

	if(start_tick != world.time)
		BadInitializeCalls[the_type] |= BAD_INIT_SLEPT

	var/qdeleted = FALSE

	if(result != INITIALIZE_HINT_NORMAL)
		switch(result)
			if(INITIALIZE_HINT_LATELOAD)
				if(arguments[1])	//mapload
					late_loaders += A
				else
					A.LateInitialize()
			if(INITIALIZE_HINT_QDEL)
				qdel(A)
				qdeleted = TRUE
			else
				BadInitializeCalls[the_type] |= BAD_INIT_NO_HINT

	if(!A)	//possible harddel
		qdeleted = TRUE
	else if(!(A.flags_1 & INITIALIZED_1))
		BadInitializeCalls[the_type] |= BAD_INIT_DIDNT_INIT
	else
		SEND_SIGNAL(A, COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZE)
		var/atom/location = A.loc
		if(location)
			/// Sends a signal that the new atom `src`, has been created at `loc`
			SEND_SIGNAL(location, COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON, A, arguments[1])

	return qdeleted || QDELING(A)

/// Attributes RSS growth since the last sample to the types initialized in the window, by count
/datum/controller/subsystem/atoms/proc/sample_init_memory_window()
	init_mem_counter = 0
	var/rss = get_process_rss_bytes()
	if(isnull(rss) || isnull(init_mem_last_rss))
		init_mem_last_rss = isnull(rss) ? init_mem_last_rss : rss
		init_mem_window.Cut()
		return
	var/window_total = 0
	for(var/init_type in init_mem_window)
		window_total += init_mem_window[init_type]
	var/delta = rss - init_mem_last_rss
	if(window_total && delta > 0)
		var/per_atom = delta / window_total
		for(var/init_type in init_mem_window)
			var/list/entry = type_init_profile[init_type]
			if(!entry)
				type_init_profile[init_type] = entry = list(0, 0, 0)
			entry[3] += per_atom * init_mem_window[init_type]
	init_mem_last_rss = rss
	init_mem_window.Cut()

/// Writes the init cost of every type from the last mapload batch to the memory stats log,
/// sorted by estimated memory (falls back to init time if sampling failed)
/datum/controller/subsystem/atoms/proc/dump_init_profile()
	if(!length(type_init_profile))
		return
	sample_init_memory_window() // flush the tail window
	var/have_mem_data = FALSE
	var/list/by_cost = list()
	for(var/init_type in type_init_profile)
		var/list/entry = type_init_profile[init_type]
		if(entry[3] > 0)
			have_mem_data = TRUE
		by_cost[init_type] = entry[3]
	if(!have_mem_data)
		for(var/init_type in type_init_profile)
			var/list/entry = type_init_profile[init_type]
			by_cost[init_type] = entry[2]
	sortTim(by_cost, GLOBAL_PROC_REF(cmp_numeric_dsc), associative = TRUE)
	for(var/init_type in by_cost)
		var/list/entry = type_init_profile[init_type]
		WRITE_LOG(GLOB.world_mem_log, "MEMTYPES: [init_type] count=[entry[1]] total_ms=[round(entry[2], 0.1)] est_mb=[round(entry[3] / (1024 * 1024), 0.01)]")
	if(!isnull(init_mem_last_rss))
		WRITE_LOG(GLOB.world_mem_log, "MEMTYPES: dump complete, [length(type_init_profile)] types total, rss_mb=[round(init_mem_last_rss / (1024 * 1024), 0.1)]")
	type_init_profile.Cut()

/datum/controller/subsystem/atoms/proc/map_loader_begin()
	old_initialized = initialized
	initialized = INITIALIZATION_INSSATOMS

/datum/controller/subsystem/atoms/proc/map_loader_stop()
	initialized = old_initialized

/datum/controller/subsystem/atoms/Recover()
	initialized = SSatoms.initialized
	if(initialized == INITIALIZATION_INNEW_MAPLOAD)
		InitializeAtoms()
	old_initialized = SSatoms.old_initialized
	BadInitializeCalls = SSatoms.BadInitializeCalls

/datum/controller/subsystem/atoms/proc/InitLog()
	. = ""
	for(var/path in BadInitializeCalls)
		. += "Path : [path] \n"
		var/fails = BadInitializeCalls[path]
		if(fails & BAD_INIT_DIDNT_INIT)
			. += "- Didn't call atom/Initialize()\n"
		if(fails & BAD_INIT_NO_HINT)
			. += "- Didn't return an Initialize hint\n"
		if(fails & BAD_INIT_QDEL_BEFORE)
			. += "- Qdel'd in New()\n"
		if(fails & BAD_INIT_SLEPT)
			. += "- Slept during Initialize()\n"

/datum/controller/subsystem/atoms/Shutdown()
	var/initlog = InitLog()
	if(initlog)
		text2file(initlog, "[GLOB.log_directory]/initialize.log")
