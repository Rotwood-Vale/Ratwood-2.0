// Artifact repair system for enchanted weapons
/datum/component/hag_artifact_repair
	/// List of hag items currently being tended to
	var/list/tended_items = list()
	/// Whether this component is currently registered with SSprocessing.
	var/processing_active = FALSE
	/// Timers for items currently in the 'shattered' recovery state
	var/list/reconstruction_timers = list()
	/// How often we tick (5 seconds is a good balance)
	var/process_interval = 5 SECONDS
	var/last_process = 0
	/// Valid soil types for the Mossmother's touch
	var/static/list/natural_turfs = list(
		/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/snow,
		/turf/open/floor/rogue/grass, /turf/open/floor/rogue/grassyel, 
		/turf/open/floor/rogue/grassred, /turf/open/floor/rogue/grasscold,
		/turf/open/water/swamp
	)

/datum/component/hag_artifact_repair/Initialize()
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_owner_move))
	on_owner_move()

/datum/component/hag_artifact_repair/proc/set_processing(enabled)
	if(enabled)
		if(processing_active)
			return
		processing_active = TRUE
		START_PROCESSING(SSprocessing, src)
		return
	if(!processing_active)
		return
	processing_active = FALSE
	STOP_PROCESSING(SSprocessing, src)

/datum/component/hag_artifact_repair/Destroy()
	set_processing(FALSE)
	tended_items.Cut()
	for(var/id in reconstruction_timers)
		deltimer(reconstruction_timers[id])
	reconstruction_timers.Cut()
	return ..()

/datum/component/hag_artifact_repair/process()
	if(world.time < last_process + process_interval)
		return
	last_process = world.time

	if(!length(tended_items))
		set_processing(FALSE)
		return

	var/mob/living/L = parent
	var/turf/current_turf = get_turf(L)

	if(!is_type_in_list(current_turf, natural_turfs))
		set_processing(FALSE)
		return

	// Repair items in hand/worn on natural turf
	for(var/obj/item/I in tended_items)
		if(!I || QDELING(I))
			tended_items -= I
			continue

		// Restore integrity
		if(I.obj_integrity < I.max_integrity)
			I.obj_integrity = min(I.obj_integrity + 2, I.max_integrity)

/datum/component/hag_artifact_repair/proc/on_owner_move()
	SIGNAL_HANDLER

	var/mob/living/L = parent
	var/turf/current_turf = get_turf(L)

	// Stop tending if we move off natural turf
	if(!is_type_in_list(current_turf, natural_turfs))
		set_processing(FALSE)
		return

	// Add all currently equipped items to be tended
	if(L.get_item_by_slot(ITEM_SLOT_ARMOR))
		var/obj/item/I = L.get_item_by_slot(ITEM_SLOT_ARMOR)
		if(I && !(I in tended_items))
			tended_items += I
	
	if(L.get_item_by_slot(ITEM_SLOT_OCLOTHING))
		var/obj/item/I2 = L.get_item_by_slot(ITEM_SLOT_OCLOTHING)
		if(I2 && !(I2 in tended_items))
			tended_items += I2

	if(length(tended_items))
		set_processing(TRUE)
