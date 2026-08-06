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

	move_to_delay = 1.8

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

	var/burrowed = FALSE
	var/next_burrow = 0
	var/burrow_cooldown = 8 SECONDS

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
	alpha = 40
	density = FALSE
	visible_message(span_warning("[src] dives beneath the sand!"))

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/proc/emerge()
	if(!burrowed)
		return
	burrowed = FALSE
	alpha = 255
	density = TRUE
	visible_message(span_danger("[src] erupts from beneath the sand!"))

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/handle_automated_action()
	// Can't stay underground on rock.
	if(burrowed && !can_burrow())
		emerge()
	// Lose the movement bonus while on rock.
	if(can_burrow())
		move_to_delay = initial(move_to_delay)
	else
		move_to_delay = initial(move_to_delay) * 1.6
	if(target && burrowed)
		emerge()
	if(!target && !burrowed && world.time >= next_burrow && can_burrow())
		burrow()
		next_burrow = world.time + burrow_cooldown
	..()

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/wormling

	name = "sand wormling"

	icon_state = "hatchling"
	icon_state = "hatchling_dead"

	health = 65
	maxHealth = 65

	melee_damage_lower = 8
	melee_damage_upper = 14

	move_to_delay = 1

	STASPD = 15
	STASTR = 6
	STACON = 5

	burrow_cooldown = 5 SECONDS

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/wormling/AttackingTarget()
	if(burrowed)
		emerge()
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/stalker

	name = "sand stalker"

	icon_state = "juvenile"
	icon_state = "juvenile_dead"

	health = 140
	maxHealth = 140

	melee_damage_lower = 22
	melee_damage_upper = 32

	move_to_delay = 1.4

	STASTR = 9
	STASPD = 13

	burrow_cooldown = 4 SECONDS

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/stalker/AttackingTarget()
	. = ..()
	if(prob(40))
		addtimer(CALLBACK(src, PROC_REF(burrow)), 1 SECONDS)

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/elder

	name = "elder sandworm"

	icon_state = "adult"
	icon = 'icons/roguetown/mob/monster/adultsandworm.dmi'

	health = 420
	maxHealth = 420

	melee_damage_lower = 35
	melee_damage_upper = 55

	move_to_delay = 2

	STASTR = 15
	STACON = 12
	STASPD = 8

	burrow_cooldown = 12 SECONDS

	var/charge_ready = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/elder/AttackingTarget()

	. = ..()
	if(charge_ready && isliving(target))
		var/mob/living/L = target
		charge_ready = FALSE
		L.Knockdown(30)
		visible_message(span_danger("[src] slams into [L]!"))
		addtimer(VARSET_CALLBACK(src, charge_ready, TRUE), 12 SECONDS)
