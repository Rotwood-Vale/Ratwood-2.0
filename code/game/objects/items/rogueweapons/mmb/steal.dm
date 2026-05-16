/datum/intent/steal
	name = "steal"
	candodge = FALSE
	canparry = FALSE
	chargedrain = 0
	chargetime = 0
	noaa = TRUE

/datum/intent/steal/on_mmb(mob/living/carbon/human/victim, mob/living/carbon/human/thief, params)
	if(!ishuman(victim) || !ishuman(thief))
		return
	var/list/stealmods = list("chance_add" = 0, "range_add" = 0)
	SEND_SIGNAL(thief, COMSIG_HUMAN_PRE_STEAL, stealmods)
	var/range_add = stealmods["range_add"]
	if(!isnum(range_add))
		range_add = 0
	var/steal_radius = 1 + range_add
	var/list/stealablezones = list("chest", "neck", "groin", "r_hand", "l_hand")
	// Pickpocketting checks
	if(get_dist(thief, victim) > steal_radius)
		to_chat(thief, span_warning("[victim] is too far away."))
		return
	if(thief.get_active_held_item())
		to_chat(thief, span_warning("I can't pickpocket while my hand is full!"))
		return
	if(victim.cmode)
		to_chat(thief, "<span class='warning'>[victim] is alert. I can't pickpocket them like this.</span>")
		return
	if(!(thief.zone_selected in stealablezones))
		to_chat(thief, span_warning("What am I going to steal from there?"))
		return

	var/thiefskill = thief.get_skill_level(/datum/skill/misc/stealing) + (has_world_trait(/datum/world_trait/matthios_fingers) ? 1 : 0)
	var/stealroll = roll("[thiefskill]d6")
	var/targetperception = (victim.STAPER)
	var/chance_add = stealmods["chance_add"]
	if(!isnum(chance_add))
		chance_add = 0
	var/effective_targetperception = targetperception
	if(chance_add > 0)
		effective_targetperception = max(0, round(targetperception * (100 - chance_add) / 100))
	var/list/stealpos = list()
	var/list/mobsbehind = list()
	var/exp_to_gain = thief.STAINT
	to_chat(thief, span_notice("I try to steal from [victim]..."))	
	if(!do_after(thief, 5, target = victim, progress = 0))
		return
	// Pickpocketting checks after the channel in case something changed
	if(get_dist(thief, victim) > steal_radius)
		to_chat(thief, span_warning("[victim] is too far away."))
		return
	if(thief.get_active_held_item())
		to_chat(thief, span_warning("I can't pickpocket while my hand is full!"))
		return
	if(victim.cmode)
		to_chat(thief, "<span class='warning'>[victim] is alert. I can't pickpocket them like this.</span>")
		return
	if(!(thief.zone_selected in stealablezones))
		to_chat(thief, span_warning("What am I going to steal from there?"))
		return
	if(stealroll > effective_targetperception)
		mobsbehind |= cone(victim, list(turn(victim.dir, 180)), list(thief))
		if(mobsbehind.Find(thief) || victim.IsUnconscious() || victim.eyesclosed || victim.eye_blind || victim.eye_blurry || !(victim.mobility_flags & MOBILITY_STAND))
			switch(thief.zone_selected)
				if("chest")
					if (victim.get_item_by_slot(SLOT_BACK_L))
						stealpos.Add(victim.get_item_by_slot(SLOT_BACK_L))
					if (victim.get_item_by_slot(SLOT_BACK_R))
						stealpos.Add(victim.get_item_by_slot(SLOT_BACK_R))
				if("neck")
					if (victim.get_item_by_slot(SLOT_NECK))
						stealpos.Add(victim.get_item_by_slot(SLOT_NECK))
				if("groin")
					if (victim.get_item_by_slot(SLOT_BELT_R))
						stealpos.Add(victim.get_item_by_slot(SLOT_BELT_R))
					if (victim.get_item_by_slot(SLOT_BELT_L))
						stealpos.Add(victim.get_item_by_slot(SLOT_BELT_L))
				if("r_hand", "l_hand")
					if (victim.get_item_by_slot(SLOT_RING))
						stealpos.Add(victim.get_item_by_slot(SLOT_RING))
			if(length(stealpos) > 0)
				var/obj/item/picked = pick(stealpos)
				victim.dropItemToGround(picked)
				thief.put_in_active_hand(picked)
				to_chat(thief, span_green("I stole [picked]!"))
				victim.log_message("has had \the [picked] stolen by [key_name(thief)]", LOG_ATTACK, color="white")
				thief.log_message("has stolen \the [picked] from [key_name(victim)]", LOG_ATTACK, color="white")
				if(victim.client && victim.stat != DEAD)
					SEND_SIGNAL(thief, COMSIG_ITEM_STOLEN, victim)
					record_featured_stat(FEATURED_STATS_THIEVES, thief)
					record_featured_stat(FEATURED_STATS_CRIMINALS, thief)
					GLOB.azure_round_stats[STATS_ITEMS_PICKPOCKETED]++
				if(thief.has_flaw(/datum/charflaw/addiction/kleptomaniac))
					thief.sate_addiction(/datum/charflaw/addiction/kleptomaniac)
			else
				exp_to_gain /= 2 // these can be removed or changed on reviewer's discretion
				to_chat(thief, span_warning("I didn't find anything there. Perhaps I should look elsewhere."))
		else
			to_chat(thief, "<span class='warning'>They can see me!")
	if(stealroll <= 5)
		victim.log_message("has had an attempted pickpocket by [key_name(thief)]", LOG_ATTACK, color="white")
		thief.log_message("has attempted to pickpocket [key_name(victim)]", LOG_ATTACK, color="white")
		thief.visible_message(span_danger("[thief] failed to pickpocket [victim]!"))
		to_chat(victim, span_danger("[thief] tried pickpocketing me!"))
	if(stealroll < effective_targetperception)
		victim.log_message("has had an attempted pickpocket by [key_name(thief)]", LOG_ATTACK, color="white")
		thief.log_message("has attempted to pickpocket [key_name(victim)]", LOG_ATTACK, color="white")
		to_chat(thief, span_danger("I failed to pick the pocket!"))
		to_chat(victim, span_danger("Someone tried pickpocketing me!"))
		exp_to_gain /= 5 // these can be removed or changed on reviewer's discretion
	// If we're pickpocketing someone else, and that person is conscious, grant XP
	if(thief != victim && victim.stat == CONSCIOUS)
		thief.mind.add_sleep_experience(/datum/skill/misc/stealing, exp_to_gain, FALSE)
	thief.changeNext_move(clickcd)
