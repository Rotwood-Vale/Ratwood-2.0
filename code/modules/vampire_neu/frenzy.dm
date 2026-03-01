/mob/proc/dice_roll(dices_num = 1, hardness = 1, atom/rollviewer)
	var/wins = 0
	var/crits = 0
	var/brokes = 0
	for(var/i in 1 to dices_num)
		var/roll = rand(1, 10)
		if(roll == 10)
			crits += 1
		if(roll == 1)
			brokes += 1
		else if(roll >= hardness)
			wins += 1
	if(crits > brokes)
		if(rollviewer)
			to_chat(rollviewer, "<b>Critical [span_nicegreen("hit")]!</b>")
			return DICE_CRIT_WIN
	if(crits < brokes)
		if(rollviewer)
			to_chat(rollviewer, "<b>Critical [span_danger("failure")]!</b>")
			return DICE_CRIT_FAILURE
	if(crits == brokes && !wins)
		if(rollviewer)
			to_chat(rollviewer, span_danger("Failed"))
			return DICE_FAILURE
	if(wins)
		switch(wins)
			if(1)
				to_chat(rollviewer, span_tinynotice("Maybe"))
				return DICE_WIN
			if(2)
				to_chat(rollviewer, span_smallnotice("Okay"))
				return DICE_WIN
			if(3)
				to_chat(rollviewer, span_notice("Good"))
				return DICE_WIN
			if(4)
				to_chat(rollviewer, span_notice("Lucky"))
				return DICE_WIN
			else
				to_chat(rollviewer, span_boldnotice("Phenomenal"))
				return DICE_WIN

/mob/living/carbon/proc/rollfrenzy()
	if(client)
		// Message for non-clan cursed beings
		if(!clan && (HAS_TRAIT(src, TRAIT_ASTRATA_SCORCHED) || HAS_TRAIT(src, TRAIT_NOC_SCORCHED)))
			if(HAS_TRAIT(src, TRAIT_ASTRATA_SCORCHED))
				to_chat(src, span_userdanger("The blood-thirst overwhelms me!"))
			if(HAS_TRAIT(src, TRAIT_NOC_SCORCHED))
				to_chat(src, span_userdanger("The beast takes control!"))
		else if(clan)
			clan.frenzy_message(src)
		
		var/check = dice_roll(max(1, round(humanity/2)), min(frenzy_chance_boost, frenzy_hardness), src)

		// Modifier for frenzy duration
		var/length_modifier = 1

		switch(check)
			if (DICE_CRIT_FAILURE)
				enter_frenzymod()
				addtimer(CALLBACK(src, PROC_REF(exit_frenzymod)), 20 SECONDS * length_modifier)
				frenzy_hardness = 1
			if (DICE_FAILURE)
				enter_frenzymod()
				addtimer(CALLBACK(src, PROC_REF(exit_frenzymod)), 10 SECONDS * length_modifier)
				frenzy_hardness = 1
			if (DICE_CRIT_WIN)
				frenzy_hardness = max(1, frenzy_hardness - 1)
			else
				frenzy_hardness = min(10, frenzy_hardness + 1)

/mob/living/carbon/proc/enter_frenzymod()
	if(HAS_TRAIT(src, TRAIT_IN_FRENZY))
		return
	ADD_TRAIT(src, TRAIT_IN_FRENZY, MAGIC_TRAIT)
	log_combat(src, src, "enters frenzy!")
	add_client_colour(/datum/client_colour/glass_colour/red)
	GLOB.frenzy_list += src

/mob/living/carbon/proc/exit_frenzymod()
	if (!HAS_TRAIT(src, TRAIT_IN_FRENZY))
		return

	REMOVE_TRAIT(src, TRAIT_IN_FRENZY, MAGIC_TRAIT)
	remove_client_colour(/datum/client_colour/glass_colour/red)
	log_combat(src, src, "exits frenzy!")
	GLOB.frenzy_list -= src
	clear_frenzy_cache()
	last_frenzy_check = world.time

/mob/living/carbon/proc/can_frenzy_move()
	if(stat >= SOFT_CRIT)
		return FALSE
	if(IsSleeping())
		return FALSE
	if(IsUnconscious())
		return FALSE
	if(IsParalyzed())
		return FALSE
	if(IsKnockdown())
		return FALSE
	if(IsStun())
		return FALSE
	if(restrained())
		return FALSE

	return TRUE

/mob/living/carbon/proc/handle_fear(atom/fear)
	if(!fear)
		return FALSE
	// Check for non-vampire curse fears
	if(!clan)
		// Astrata-Scorched and Noc-Scorched fear being on fire
		if(HAS_TRAIT(src, TRAIT_ASTRATA_SCORCHED) || HAS_TRAIT(src, TRAIT_NOC_SCORCHED))
			if(on_fire)
				resist() // Try to extinguish
				if(prob(50))
					emote("scream")
				return TRUE
		return FALSE
	if(!clan.handle_fear(src, fear))
		return FALSE
	step_away(src,fear,99)
	if(prob(25))
		emote("scream")
	return TRUE

/mob/living/carbon/proc/frenzystep()
	if(!isturf(loc) || !can_frenzy_move() || !frenzy_target || !HAS_TRAIT(src, TRAIT_IN_FRENZY))
		return
	if(m_intent == MOVE_INTENT_WALK)
		toggle_move_intent(src)
	set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))
	// Check if cursed beings are on fire FIRST (panic takes priority)
	if(!clan && (HAS_TRAIT(src, TRAIT_ASTRATA_SCORCHED) || HAS_TRAIT(src, TRAIT_NOC_SCORCHED)))
		if(on_fire)
			handle_fear(src) // Pass self as fear object to trigger resist()
			return
	var/atom/fear = clan?.return_fear(src)
	if(clan)
		if(!handle_fear(fear))
			var/mob/living/carbon/human/H = src
			if(get_dist(frenzy_target, src) <= 1)
				if(isliving(frenzy_target))
					var/mob/living/carbon/L = frenzy_target
					var/obj/item/grabbing/bite/bite = H.mouth
					if(istype(bite))
						qdel(bite)
					// Respect cooldowns
					if(L.bloodpool && L.stat != DEAD && last_drinkblood_use + 9.5 SECONDS <= world.time && world.time >= next_move)
						if(!H.mouth) // Only bite if mouth is free
							if(L.pulledby != src)
								L.grabbedby(src)
							L.visible_message("<span class='warning'><b>[src] bites [L]'s neck!</b></span>", "<span class='warning'><b>[src] bites your neck!</b></span>")
							face_atom(L)
							H.drinksomeblood(L, BODY_ZONE_PRECISE_NECK)
							if(CheckEyewitness(L, src, 7, FALSE))
								H.AdjustMasquerade(-1)
						else
							emote("scream")
			else
				frenzy_pathfind_to_target()
				face_atom(frenzy_target)
	else
		// Non-vampire frenzy (for cursed vices)
		if(get_dist(frenzy_target, src) <= 1)
			if(isliving(frenzy_target))
				var/mob/living/L = frenzy_target
				if(L.stat != DEAD)
					// Astrata-Scorched tries to drink blood
					if(HAS_TRAIT(src, TRAIT_ASTRATA_SCORCHED) && ishuman(src))
						var/mob/living/carbon/human/H = src
						if(ishuman(L))
							var/mob/living/carbon/human/human_target = L
							// Respect cooldowns
							if(human_target.blood_volume > 0 && last_drinkblood_use + 9.5 SECONDS <= world.time && world.time >= next_move)
								if(!H.mouth)
									if(L.pulledby != src)
										L.grabbedby(src)
									L.visible_message(span_warning("[src] desperately bites [L]'s neck!"), \
										span_warning("[src] bites your neck in a feral frenzy!"))
									face_atom(L)
									H.drinksomeblood(L, BODY_ZONE_PRECISE_NECK)
								else
									emote("scream")
							else if(world.time >= next_move)
								a_intent = INTENT_HARM
								if(last_rage_hit+5 < world.time)
									last_rage_hit = world.time
									UnarmedAttack(L)
									changeNext_move(CLICK_CD_MELEE)
						else if(world.time >= next_move)
							a_intent = INTENT_HARM
							if(last_rage_hit+5 < world.time)
								last_rage_hit = world.time
								UnarmedAttack(L)
								changeNext_move(CLICK_CD_MELEE)
					// Noc-Scorched or other frenzied beings just attack
					else if(world.time >= next_move)
						a_intent = INTENT_HARM
						if(last_rage_hit+5 < world.time)
							last_rage_hit = world.time
							UnarmedAttack(L)
							changeNext_move(CLICK_CD_MELEE)
		else
			frenzy_pathfind_to_target()
			face_atom(frenzy_target)

	// Continue the frenzy loop with a minimum 1 second delay
	var/frenzy_delay = max(10, total_multiplicative_slowdown()) // Minimum 1 second (10 deciseconds)
	addtimer(CALLBACK(src, PROC_REF(frenzystep)), frenzy_delay)

/mob/living/carbon/proc/get_frenzy_targets()
	var/list/targets = list()
	if(clan)
		for(var/mob/living/L in oviewers(7, src))
			if(L.bloodpool > 50 && L.stat != DEAD)
				targets += L
				if(L == frenzy_target)
					return L
	else
		for(var/mob/living/L in oviewers(7, src))
			if(L.stat != DEAD)
				targets += L
				if(L == frenzy_target)
					return L
	if(length(targets) > 0)
		return pick(targets)
	else
		return null


/mob/living/carbon/proc/handle_automated_frenzy()
	if(isturf(loc))
		frenzy_target = get_frenzy_targets()
		if(frenzy_target)
			frenzystep() // Start the frenzy stepping process
		else
			if(can_frenzy_move())
				if(isturf(loc))
					var/turf/T = get_step(loc, pick(NORTH, SOUTH, WEST, EAST))
					face_atom(T)
					Move(T)

/mob/living/carbon/proc/frenzy_pathfind_to_target()
	if(!frenzy_target)
		return

	var/turf/current_pos = get_turf(src)
	var/turf/target_pos = get_turf(frenzy_target)

	// Only regenerate path if we've moved to a different position or don't have a cached path
	if(!frenzy_cached_path || frenzy_last_pos != current_pos)
		frenzy_cached_path = get_path_to(src, target_pos, TYPE_PROC_REF(/turf, Heuristic_cardinal_3d), 33, 250, 1)
		frenzy_last_pos = current_pos

	if(length(frenzy_cached_path))
		walk(src, 0) // Stop any existing walk
		step_to(src, frenzy_cached_path[1], 0)
		frenzy_cached_path.Cut(1, 2)
	else
		// Fallback to direct pathfinding if cached path fails
		step_to(src, frenzy_target, 0)

/mob/living/carbon/proc/clear_frenzy_cache()
	frenzy_cached_path = null
	frenzy_last_pos = null
