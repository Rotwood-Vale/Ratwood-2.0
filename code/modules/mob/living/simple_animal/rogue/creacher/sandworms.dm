/// Override this on maps if needed.
#define WORM_BURROWABLE(type) (istype(type, /turf/open/floor/rogue/dunes) || \
							   istype(type, /turf/open/floor/rogue/AzureSand))

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm
	name = "sandworm"
	desc = "A monstrous worm that swims effortlessly through the desert."

	icon = 'icons/roguetown/mob/monster/sandworm.dmi'
	icon_state = "worm"
	icon_living = "worm"
	icon_dead = "worm_dead"

	see_in_dark = 8
	vision_range = 8
	aggro_vision_range = 8
	base_intents = list(/datum/intent/simple/bite, /datum/intent/simple/claw)
	move_to_delay = 15

	environment_smash = ENVIRONMENT_SMASH_NONE

	footstep_type = null
	pooptype = null

	faction = list("sandworm")

	mob_biotypes = MOB_ORGANIC|MOB_BEAST

	retreat_distance = 0
	minimum_distance = 0

	aggressive = TRUE

	food = 0

	del_on_deaggro = 120 SECONDS
	var/burrow_move_to_delay = 2 // fast "swim" speed while submerged and approaching
	var/emerge_range = 1 // distance from target before it surfaces to strike
	var/burrow_giveup_time = 15 SECONDS
	var/burrow_started = 0
	var/burrow_anim_time = 12 // deciseconds - length of the dive/emerge overlay, worm is still visible+tangible during this
	var/burrow_travel_time = 15 // deciseconds - how long it's fully gone (godmode+invisible) before reappearing
	var/burrowed = FALSE
	var/next_burrow = 0
	var/burrow_cooldown = 8 SECONDS
	var/burrow_ambush_chance = 20 // % chance per check to re-burrow and flank while it has a target
	var/burrow_retry_delay = 3 SECONDS // gap between ambush chance rolls if one fails
	var/burrow_fx_state = "leave-hatchling"
	var/emerge_fx_state = "invade-hatchling"

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/proc/can_burrow(turf/Turf)
	if(!Turf)
		Turf = get_turf(src)
	if(!isturf(Turf))
		return FALSE
	if(!WORM_BURROWABLE(Turf))
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/proc/burrow()
	if(burrowed)
		return
	if(!can_burrow())
		return
	burrowed = TRUE
	next_burrow = world.time + burrow_cooldown
	visible_message(span_warning("[src] dives beneath the sand!"))
	play_burrow_fx(burrow_fx_state)
	addtimer(CALLBACK(src, PROC_REF(go_underground)), burrow_anim_time)

/// Worm is done diving - now fully hidden and safe while it travels.
/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/proc/go_underground()
	if(!burrowed)
		return
	status_flags |= GODMODE
	invisibility = INVISIBILITY_MAXIMUM
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	addtimer(CALLBACK(src, PROC_REF(travel_and_emerge)), burrow_travel_time)

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/proc/emerge()
	if(!burrowed)
		return
	burrowed = FALSE
	status_flags &= ~GODMODE
	invisibility = 0
	density = TRUE
	mouse_opacity = initial(mouse_opacity)
	visible_message(span_danger("[src] erupts from beneath the sand!"))
	play_burrow_fx(emerge_fx_state)
	if(target)
		AttackingTarget()

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/proc/travel_and_emerge()
	if(!burrowed)
		return
	var/turf/dest = target ? get_flank_turf(target) : get_turf(src)
	if(!dest || !can_burrow(dest))
		dest = get_turf(src)
	forceMove(dest)
	emerge()

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/proc/play_burrow_fx(state)
	var/image/fx = image(icon, loc = src, icon_state = state)
	fx.layer = FLY_LAYER
	fx.plane = plane

	var/list/client/show_to = list()
	for(var/mob/M as anything in viewers(src))
		if(M.client)
			show_to += M.client

	flick_overlay(fx, show_to, burrow_anim_time)

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/proc/get_flank_turf(atom/A)
	if(!isliving(A))
		return get_turf(A)
	var/mob/living/Living = A
	var/behind_dir = turn(Living.dir, 180)
	var/turf/behind = get_step(Living, behind_dir)
	if(behind && can_burrow(behind))
		return behind
	return get_turf(Living)

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/handle_automated_action()
	if(burrowed)
		return // mid-teleport - fully handled by timers, skip normal AI
	move_to_delay = initial(move_to_delay)
	if(world.time >= next_burrow && can_burrow())
		if(!target)
			burrow()
		else if(prob(burrow_ambush_chance))
			burrow()
		else
			next_burrow = world.time + burrow_retry_delay
	..()

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/proc/handle_burrowed_approach()
	if(!target || !can_burrow())
		emerge()
		return
	if(world.time >= burrow_started + burrow_giveup_time)
		emerge() // don't stay hidden forever if it can't line up
		return
	if(get_dist(src, target) <= emerge_range)
		emerge()
		if(target)
			AttackingTarget()
		return
	var/turf/dest = get_flank_turf(target)
	step_to(src, dest, 0, move_to_delay)

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/wormling

	name = "sand wormling"

	icon_state = "hatchling"
	icon_living = "hatchling"
	icon_dead = "hatchling-dead"

	health = 65
	maxHealth = 65

	melee_damage_lower = 8
	melee_damage_upper = 14

	move_to_delay = 8

	STASPD = 11
	STASTR = 6
	STACON = 5
	burrow_anim_time = 8 // deciseconds animation length
	burrow_cooldown = 5 SECONDS

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/wormling/AttackingTarget()
	if(burrowed)
		emerge()
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/stalker

	name = "sand stalker"
	icon_living = "juvenile"
	icon_state = "juvenile"
	icon_dead = "juvenile-dead"

	health = 400
	maxHealth = 400

	melee_damage_lower = 22
	melee_damage_upper = 32

	move_to_delay = 10

	STASTR = 12
	STACON = 11
	STASPD = 10
	burrow_anim_time = 12 // deciseconds animation length
	burrow_cooldown = 4 SECONDS
	burrow_fx_state = "leave-juvenile"
	emerge_fx_state = "invade-juvenile"

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/stalker/AttackingTarget()
	. = ..()
	if(prob(40))
		addtimer(CALLBACK(src, PROC_REF(burrow)), 1 SECONDS)

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/elder

	name = "elder sandworm"
	icon_living = "adult"
	icon_state = "adult"
	icon_dead = "adult-dead"

	icon = 'icons/roguetown/mob/monster/adultsandworm.dmi'

	health = 620
	maxHealth = 620

	melee_damage_lower = 35
	melee_damage_upper = 55

	move_to_delay = 12

	STASTR = 15
	STACON = 12
	STASPD = 8
	burrow_anim_time = 12 // deciseconds animation length
	burrow_cooldown = 12 SECONDS

	var/charge_ready = TRUE
	burrow_fx_state = "leave-adult"
	emerge_fx_state = "invade-adult"
	var/slam_ready = TRUE
	var/slam_cooldown = 12 SECONDS
	var/slam_cast_time = 1 SECONDS
	var/slam_range = 2
	var/slam_damage = 25
	var/slam_knockdown_time = 30 // deciseconds

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/elder/AttackingTarget()
	if(slam_ready && isliving(target))
		slam_ready = FALSE
		addtimer(VARSET_CALLBACK(src, slam_ready, TRUE), slam_cooldown)
		try_slam(target)
		return TRUE
	. = ..()

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/elder/proc/try_slam(atom/target_atom)
	var/dist = get_dist(src, target_atom)
	if(!can_see(src, target_atom, slam_range) || dist >= slam_range || dist > 1)
		return
	visible_message(span_boldwarning("[src] rears up, sand cascading off its coils!"))
	var/turf/warn_turf = get_turf(target_atom)
	new /obj/effect/temp_visual/paw_swipe(warn_turf)
	addtimer(CALLBACK(src, PROC_REF(do_slam), target_atom), slam_cast_time)

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/elder/proc/do_slam(atom/target_atom)
	var/dist = get_dist(src, target_atom)
	if(!can_see(src, target_atom, slam_range) || dist >= slam_range || dist > 1)
		visible_message(span_alert("[src] slams into empty sand as [target_atom.p_they()] dodge clear!"))
		return
	playsound(loc, 'sound/combat/shieldraise.ogg', 100)
	if(isliving(target_atom))
		var/mob/living/victim = target_atom
		var/def_zone = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_CHEST)
		var/blocked = victim.run_armor_check(def_zone, "stab", damage = slam_damage)
		victim.apply_damage(slam_damage, BRUTE, def_zone, blocked)
		if(blocked < 100)
			victim.Knockdown(slam_knockdown_time)
		var/turf/target_turf = get_turf(target_atom)
		new /obj/effect/temp_visual/paw_swipe(target_turf)
		to_chat(victim, span_userdanger("[src] slams down on top of you!"))
		playsound(victim, 'sound/combat/hits/punch/punch (1).ogg', 100, TRUE)
