

/datum/ai_planning_subtree/jitterskull/maintain_vendetta
/datum/ai_planning_subtree/jitterskull/maintain_vendetta/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/mob/living/simple_animal/hostile/rogue/jitterskull/J = controller.pawn
	if(!istype(J))
		return
	if(J.is_stalking || J.is_guarding || J.is_feasting)
		return
	var/mob/vt = null
	if(J.vendetta_ref)
		vt = J.vendetta_ref.resolve()
	if(vt && world.time < J.vendetta_until && !QDELETED(vt) && (!isliving(vt) || vt:stat != DEAD))
		controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, vt)
		return

/datum/ai_planning_subtree/jitterskull/guard_helpless
/datum/ai_planning_subtree/jitterskull/guard_helpless/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/mob/living/simple_animal/hostile/rogue/jitterskull/J = controller.pawn
	if(!istype(J))
		return
	if(J.is_stalking || J.is_guarding || J.is_feasting)
		return
	var/atom/cur = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(isliving(cur))
		var/mob/living/L = cur
		if((L.stat == UNCONSCIOUS || L.stat == DEAD) && !J.is_feasting && !J.is_guarding)
			if(get_dist(J, L) > 2)
				J.teleport_near_atom(L, 1, 2)
			J.begin_guarding(L)
			return SUBTREE_RETURN_FINISH_PLANNING
	return

/datum/ai_planning_subtree/jitterskull/anti_stuck_and_tether
	/// Minimum distance to snap-tether near the target
	var/tether_distance = 16
	/// Cooldown between tethers (in deciseconds)
	var/tether_cooldown = 25
	/// If stuck for this many ticks, snap-tether near target even if closer
	var/stuck_ticks_threshold = 20

/datum/ai_planning_subtree/jitterskull/anti_stuck_and_tether/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/mob/living/simple_animal/hostile/rogue/jitterskull/J = controller.pawn
	if(!istype(J))
		return
	if(J.is_stalking || J.is_guarding || J.is_feasting)
		return
	var/mob/living/T = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!T || QDELETED(T))
		// reset stuck tracking when target is missing
		J.last_stuck_x = J.x; J.last_stuck_y = J.y; J.stuck_ticks = 0
		return
	// Update stuck stats
	var/moved = (J.x != J.last_stuck_x || J.y != J.last_stuck_y)
	if(moved)
		J.stuck_ticks = 0
	else
		J.stuck_ticks++
	J.last_stuck_x = J.x; J.last_stuck_y = J.y
	// If far enough and off cooldown, snap tether near the target without entering stalk
	var/d = get_dist(J, T)
	if(d >= tether_distance && world.time >= J.next_tether_allowed)
		J.next_tether_allowed = world.time + tether_cooldown
		J.teleport_near_atom(T, 10, 14)
		var/df = get_dir(J, T)
		if(df)
			J.dir = df
		return SUBTREE_RETURN_FINISH_PLANNING
	// If not far but stuck for a while and not adjacent, blink closer and continue pressure
	if(d > 2 && J.stuck_ticks >= stuck_ticks_threshold)
		J.stuck_ticks = 0
		J.teleport_near_atom(T, 8, 12)
		var/df2 = get_dir(J, T)
		if(df2)
			J.dir = df2
		return SUBTREE_RETURN_FINISH_PLANNING
	return
