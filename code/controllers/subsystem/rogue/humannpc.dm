
SUBSYSTEM_DEF(humannpc)
	name = "humannpc"
	wait = 1 SECONDS
	flags = SS_KEEP_TIMING
	priority = 50
	var/list/processing = list()
	var/list/currentrun = list()
	processing_flag = PROCESSING_HUMANNPC
	
	// Performance: Bucket system for staggered processing
	var/list/high_priority = list()    // Combat/hunting NPCs - process every tick
	var/list/medium_priority = list()  // Idle NPCs near players - process every 2 ticks
	var/list/low_priority = list()     // Idle NPCs far from players - process every 8 ticks
	var/current_bucket = 0             // Rotates 0-7 for staggered processing
	var/list/bucket_currentrun = list()

/datum/controller/subsystem/humannpc/fire(resumed = 0)
	current_bucket = (current_bucket + 1) % 8 // Rotate bucket 0,1,2,3,4,5,6,7
	
	if (!resumed && !bucket_currentrun.len)
		// Build the list of NPCs to process this tick based on buckets
		bucket_currentrun = list()
		
		// HIGH priority: Always process (combat/hunting NPCs)
		for(var/mob/living/carbon/human/H in high_priority)
			bucket_currentrun += H
		
		// MEDIUM priority: Process every 2 ticks (buckets 0, 2, 4, 6)
		if(current_bucket % 2 == 0)
			for(var/mob/living/carbon/human/H in medium_priority)
				bucket_currentrun += H
		
		// LOW priority: Process every 8 ticks (bucket 0 only)
		if(current_bucket == 0)
			for(var/mob/living/carbon/human/H in low_priority)
				bucket_currentrun += H
	
	var/list/current = src.bucket_currentrun
	while(current.len)
		var/mob/living/carbon/human/thing = current[current.len]
		current.len--
		
		if (!thing || QDELETED(thing))
			remove_from_all_buckets(thing)
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
	thing.ai_currently_active = TRUE
	. = thing.process_ai()
	thing.ai_currently_active = FALSE
	if(.)
		remove_from_all_buckets(thing)

/datum/controller/subsystem/humannpc/proc/remove_from_all_buckets(mob/living/carbon/human/H)
	processing -= H
	high_priority -= H
	medium_priority -= H
	low_priority -= H

/datum/controller/subsystem/humannpc/proc/add_to_processing(mob/living/carbon/human/H, priority = "medium")
	if(H in processing)
		return // Already processing
	
	processing += H
	
	switch(priority)
		if("high")
			high_priority += H
		if("medium")
			medium_priority += H
		if("low")
			low_priority += H
		else
			medium_priority += H // Default to medium

/datum/controller/subsystem/humannpc/proc/update_npc_priority(mob/living/carbon/human/H, new_priority)
	if(!(H in processing))
		return
	
	// Remove from old bucket
	high_priority -= H
	medium_priority -= H
	low_priority -= H
	
	// Add to new bucket
	switch(new_priority)
		if("high")
			high_priority += H
		if("medium")
			medium_priority += H
		if("low")
			low_priority += H
		else
			medium_priority += H
