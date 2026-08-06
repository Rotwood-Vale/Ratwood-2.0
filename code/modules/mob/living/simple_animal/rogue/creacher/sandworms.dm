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
	move_to_delay = 8

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
	var/burrow_anim_time = 12 // deciseconds - match to your animation length
	var/burrowed = FALSE
	var/next_burrow = 0
	var/burrow_cooldown = 8 SECONDS
	var/burrow_move_to_delay = 2 // fast "swim" speed while submerged and approaching
	var/emerge_range = 1 // distance from target before it surfaces to strike
	var/burrow_giveup_time = 15 SECONDS
	var/burrow_started = 0
	var/burrow_fx_state = "leave-hatchling"
	var/emerge_fx_state = "invade-hatchling"

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/proc/can_burrow()
	var/turf/T = get_turf(src)
	if(!isturf(T))
		return FALSE
	if(!WORM_BURROWABLE(T))
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/proc/burrow()
	if(burrowed)
		return
	if(!can_burrow())
		return
	burrowed = TRUE
	burrow_started = world.time
	next_burrow = world.time + burrow_cooldown
	visible_message(span_warning("[src] dives beneath the sand!"))

	var/image/fx = image(icon, loc = src, icon_state = burrow_fx_state)
	fx.layer = ABOVE_MOB_LAYER
	fx.plane = GAME_PLANE
	flick_overlay(fx, viewers(src), burrow_anim_time)

	addtimer(CALLBACK(src, PROC_REF(finish_burrow)), burrow_anim_time)

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/proc/finish_burrow()
	if(!burrowed)
		return
	alpha = 0
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/proc/emerge()
	if(!burrowed)
		return
	burrowed = FALSE
	density = TRUE
	mouse_opacity = initial(mouse_opacity)
	visible_message(span_danger("[src] erupts from beneath the sand!"))

	var/image/fx = image(icon, loc = src, icon_state = emerge_fx_state)
	fx.layer = ABOVE_MOB_LAYER
	fx.plane = GAME_PLANE
	flick_overlay(fx, viewers(src), burrow_anim_time)
	alpha = 255

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/handle_automated_action()
	if(burrowed && !can_burrow())
		emerge()

	if(burrowed)
		move_to_delay = burrow_move_to_delay
		handle_burrowed_approach()
		return // skip normal chase/attack AI entirely while submerged

	move_to_delay = initial(move_to_delay)

	if(!target && world.time >= next_burrow && can_burrow())
		burrow()

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

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/proc/get_flank_turf(atom/A)
	if(!isliving(A))
		return get_turf(A)
	var/mob/living/L = A
	var/behind_dir = turn(L.dir, 180)
	var/turf/behind = get_step(L, behind_dir)
	if(behind && WORM_BURROWABLE(behind))
		return behind
	return get_turf(L) // can't get behind them, just close in directly

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/wormling

	name = "sand wormling"

	icon_state = "hatchling"
	icon_living = "hatchling"
	icon_dead = "hatchling-dead"

	health = 65
	maxHealth = 65

	melee_damage_lower = 8
	melee_damage_upper = 14

	move_to_delay = 1

	STASPD = 15
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

	health = 140
	maxHealth = 140

	melee_damage_lower = 22
	melee_damage_upper = 32

	move_to_delay = 1.4

	STASTR = 9
	STASPD = 13
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

	health = 420
	maxHealth = 420

	melee_damage_lower = 35
	melee_damage_upper = 55

	move_to_delay = 2

	STASTR = 15
	STACON = 12
	STASPD = 8
	burrow_anim_time = 12 // deciseconds animation length
	burrow_cooldown = 12 SECONDS

	var/charge_ready = TRUE
	burrow_fx_state = "leave-adult"
	emerge_fx_state = "invade-juvenile"

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/elder/AttackingTarget()

	if(charge_ready && isliving(target))
		var/mob/living/L = target
		charge_ready = FALSE
		L.Knockdown(30)
		visible_message(span_danger("[src] slams into [L]!"))
		addtimer(VARSET_CALLBACK(src, charge_ready, TRUE), 12 SECONDS)
	. = ..()

