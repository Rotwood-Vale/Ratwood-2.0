/client/proc/debug_mob_performance()
	set category = "Debug"
	set name = "Mob Performance Debug"

	var/players = 0
	var/npcs_off = 0
	var/npcs_sleep = 0
	var/npcs_idle = 0
	var/npcs_hunt = 0
	var/npcs_other = 0
	var/with_flaws = 0
	var/with_vices = 0
	var/total_wounds = 0
	var/total_bodyparts = 0
	var/total_organs = 0
	var/processing_bodyparts = 0
	var/high_priority = 0
	var/medium_priority = 0
	var/low_priority = 0
	
	for(var/mob/living/carbon/human/H in GLOB.mob_living_list)
		if(H.client)
			players++
		else
			switch(H.mode)
				if(NPC_AI_OFF)
					npcs_off++
				if(NPC_AI_SLEEP)
					npcs_sleep++
				if(NPC_AI_IDLE)
					npcs_idle++
				if(NPC_AI_HUNT)
					npcs_hunt++
				else
					npcs_other++
			
			// Count bucket priorities
			switch(H.ai_priority)
				if("high")
					high_priority++
				if("medium")
					medium_priority++
				if("low")
					low_priority++
		
		if(H.charflaw)
			with_flaws++
		if(length(H.vices))
			with_vices += length(H.vices)
		
		total_wounds += length(H.get_wounds())
		total_bodyparts += length(H.bodyparts)
		total_organs += length(H.internal_organs)
		
		for(var/obj/item/bodypart/BP in H.bodyparts)
			if(BP.needs_processing)
				processing_bodyparts++
	
	var/msg = "=== MOB PERFORMANCE DEBUG ===\n"
	msg += "Total Living Mobs: [GLOB.mob_living_list.len]\n"
	msg += "\n--- HUMANS ---\n"
	msg += "Players: [players]\n"
	msg += "NPCs OFF: [npcs_off]\n"
	msg += "NPCs SLEEP: [npcs_sleep]\n"
	msg += "NPCs IDLE: [npcs_idle]\n"
	msg += "NPCs HUNTING: [npcs_hunt]\n"
	msg += "NPCs Other: [npcs_other]\n"
	msg += "\n--- SMART BUCKET SYSTEM ---\n"
	msg += "HIGH Priority (every tick): [high_priority]\n"
	msg += "MEDIUM Priority (every 2 ticks): [medium_priority]\n"
	msg += "LOW Priority (every 8 ticks): [low_priority]\n"
	msg += "Actual Processing Per Tick: ~[high_priority + (medium_priority/2) + (low_priority/8)]\n"
	msg += "\n--- EXPENSIVE FEATURES ---\n"
	msg += "Mobs with Charflaws: [with_flaws]\n"
	msg += "Total Vice Instances: [with_vices]\n"
	msg += "Total Wounds: [total_wounds]\n"
	msg += "Total Bodyparts: [total_bodyparts]\n"
	msg += "Processing Bodyparts: [processing_bodyparts]\n"
	msg += "Total Organs: [total_organs]\n"
	msg += "\n--- RECOMMENDATIONS ---\n"
	
	var/estimated_processing = high_priority + (medium_priority/2) + (low_priority/8)
	if(estimated_processing > 200)
		msg += "⚠️ Estimated [estimated_processing] NPCs processing per tick - may cause lag!\n"
	if(with_vices > players * 2)
		msg += "⚠️ NPCs have vices but shouldn't need them!\n"
	if(processing_bodyparts > players * 8)
		msg += "⚠️ Too many bodyparts processing on NPCs\n"
	if(high_priority > 100)
		msg += "⚠️ [high_priority] NPCs in combat - consider spawning fewer combat NPCs\n"
	
	to_chat(src, "<pre>[msg]</pre>")
	log_admin("[key] ran mob performance debug: [players] players, [high_priority] high priority, [medium_priority] medium, [low_priority] low")

