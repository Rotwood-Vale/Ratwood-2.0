SUBSYSTEM_DEF(icon_smooth)
	name = "Icon Smoothing"
	wait = 1
	priority = FIRE_PRIORITY_SMOOTHING
	flags = SS_TICKER
	var/list/smooth_queue = list()
	var/list/deferred = list()
	var/list/deferred_by_source = list()
	/// atoms from loads that finished while another load was still going, they wait here until nothing is loading
	var/list/held_pools

/datum/controller/subsystem/icon_smooth/fire()
	// nothing's loading anymore, so everything next to the held atoms is initialized
	if(held_pools && !SSatoms.initializing_something() && !Master.map_loading)
		smooth_queue += held_pools
		held_pools = null

	var/list/smooth_queue_cache = smooth_queue
	while(length(smooth_queue_cache))
		var/atom/smoothing_atom = smooth_queue_cache[length(smooth_queue_cache)]
		smooth_queue_cache.len--
		if(QDELETED(smoothing_atom) || !(smoothing_atom.smooth & SMOOTH_QUEUED))
			continue
		if(smoothing_atom.flags_1 & INITIALIZED_1)
			smooth_icon(smoothing_atom)
		else
			deferred += smoothing_atom
		if (MC_TICK_CHECK)
			return

	if (!length(smooth_queue_cache))
		if (deferred.len)
			smooth_queue = deferred
			deferred = smooth_queue_cache
		else if (!held_pools)
			can_fire = FALSE

/datum/controller/subsystem/icon_smooth/Initialize()
	var/list/queue = smooth_queue
	smooth_queue = list()
	while(length(queue))
		var/atom/smoothing_atom = queue[length(queue)]
		queue.len--
		if(QDELETED(smoothing_atom) || !(smoothing_atom.smooth & SMOOTH_QUEUED) || !smoothing_atom.z)
			continue
		smooth_icon(smoothing_atom)
		CHECK_TICK
	return SS_INIT_SUCCESS

/// Releases a pool of delayed smooth attempts from a particular source, or holds it while anything else is loading
/datum/controller/subsystem/icon_smooth/proc/free_deferred(source_to_free)
	var/list/pool = deferred_by_source[source_to_free]
	deferred_by_source -= source_to_free
	if(!pool)
		return
	// a map that loads inside another one can finish first, while the outer map around it still isn't initialized
	if(SSatoms.initializing_something() || Master.map_loading)
		LAZYADD(held_pools, pool)
	else
		smooth_queue += pool
	can_fire = TRUE

/datum/controller/subsystem/icon_smooth/proc/add_to_queue(atom/thing)
	if(thing.smooth & SMOOTH_QUEUED)
		return
	thing.smooth |= SMOOTH_QUEUED
	// If we're currently locked into mapload BY something
	// Then put us in a deferred list that we release when this mapload run is finished
	if(initialized && length(SSatoms.initialized_state) && SSatoms.initialized == INITIALIZATION_INNEW_MAPLOAD)
		var/source = SSatoms.get_initialized_source()
		LAZYADD(deferred_by_source[source], thing)
		return
	smooth_queue += thing
	if(!can_fire)
		can_fire = TRUE

/datum/controller/subsystem/icon_smooth/proc/remove_from_queues(atom/thing)
	// Lack of removal from deferred_by_source is safe because the lack of SMOOTH_QUEUED will just free it anyway
	// Hopefully this'll never cause a harddel (dies)
	thing.smooth &= ~SMOOTH_QUEUED
	smooth_queue -= thing
	deferred -= thing
	LAZYREMOVE(held_pools, thing)
