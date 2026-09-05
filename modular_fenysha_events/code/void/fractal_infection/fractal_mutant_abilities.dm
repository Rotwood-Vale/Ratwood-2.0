/*
 * What a fractal mutant can do.
 *
 * Split out of fractal_mutant.dm. These are the mob's own cooldown actions -
 * granted from inntacte_actions on the mob types and fired either by the player
 * or by the subtrees in fractal_mutant_ai.dm, which reach them through the
 * blackboard keys those lists set.
 *
 * Not to be confused with fractal_abilities.dm, which holds the spells the
 * infection hands an infected human.
 *
 * BB_FRACTAL_FATALITY_ACTIVE is defined in fractal_mutant.dm, which the .dme
 * includes ahead of this file.
 */

/datum/action/cooldown/mob_cooldown/simple_charge
	name = "Charge"
	desc = "Charge towards a targeted location, dealing heavy damage on impact."
	cooldown_time = 10 SECONDS
	melee_cooldown_time = 0
	shared_cooldown = NONE

	button_icon = 'icons/obj/magic.dmi'
	button_icon_state = "3"

	var/max_range = 10
	var/charge_sound = 'modular_fenysha_events/sound/fractal_scream1.ogg'
	var/charge_delay = 5

/datum/action/cooldown/mob_cooldown/simple_charge/PreActivate(atom/target)
	target = get_turf(target)
	if (get_dist(owner, target) > max_range)
		return FALSE
	return ..()

/datum/action/cooldown/mob_cooldown/simple_charge/Activate(atom/target)
	var/dist = get_dist(owner, target) - 1
	if(dist <= 1)
		owner.balloon_alert(owner, "To close!")
		return
	INVOKE_ASYNC(src, PROC_REF(do_charge), get_turf(target))
	StartCooldown()
	return TRUE

/datum/action/cooldown/mob_cooldown/simple_charge/proc/do_charge(turf/target)
	owner.visible_message(span_danger("[owner] charges towards [target]!"))
	if(charge_delay)
		if(!do_after(owner, charge_delay))
			owner.balloon_alert(owner, "Interupted!")
	if(charge_sound)
		playsound(owner, charge_sound, 40)
	var/dist = get_dist(owner, target) - 1
	for(var/i = 1 to dist)
		if(get_dist(owner, target) <= 1)
			break
		new /obj/effect/temp_visual/decoy/fading/halfsecond(owner.loc, owner)
		owner.forceMove(get_step_towards(owner, target))
		sleep(2)

	for(var/mob/living/living_target in range(1, owner))
		if(living_target == owner)
			continue
		var/damage = rand(20, 30)
		living_target.take_bodypart_damage(damage)
		living_target.Knockdown(10)
		shake_camera(living_target)
	playsound(owner, 'modular_fenysha_events/sound/fractal_glitch2.ogg', 100, TRUE)



/datum/action/cooldown/mob_cooldown/fractal_fatality
	name = "Fractal Fatality"
	desc = "Charge towards a nearby victim, seize them, and tear them apart."
	cooldown_time = 2 MINUTES
	melee_cooldown_time = 0
	shared_cooldown = NONE

	button_icon = 'icons/obj/magic.dmi'
	button_icon_state = "2"

	var/fatality_range = 2
	var/charge_range = 5

	var/preparation_time = 2 SECONDS
	var/lift_time = 1.5 SECONDS
	var/flip_time = 2 SECONDS
	var/kill_time = 3 SECONDS

	var/charge_delay = 5
	var/charge_speed = 2

	var/charge_sound = 'modular_fenysha_events/sound/fractal_scream1.ogg'
	var/grab_sound = 'modular_fenysha_events/sound/fractal_scream2.ogg'
	var/kill_sound = 'modular_fenysha_events/sound/fractal_glitch2.ogg'


/datum/action/cooldown/mob_cooldown/fractal_fatality/PreActivate(atom/target)
	target = get_turf(target)

	if(!target)
		return FALSE

	if(get_dist(owner, target) > charge_range)
		return FALSE

	var/mob/living/victim = locate() in target.contents

	if(!victim || victim == owner)
		return FALSE

	if(victim.stat == DEAD)
		return FALSE

	return ..()


/datum/action/cooldown/mob_cooldown/fractal_fatality/Activate(atom/target)
	var/turf/T = get_turf(target)

	if(!T)
		return FALSE

	var/mob/living/victim

	for(var/mob/living/M in T.contents)
		if(M != owner && M.stat != DEAD)
			victim = M
			break

	if(!victim)
		return FALSE

	if(get_dist(owner, victim) > charge_range)
		return FALSE

	var/datum/ai_controller/controller = owner.ai_controller

	if(controller?.blackboard[BB_FRACTAL_FATALITY_ACTIVE])
		return FALSE

	controller?.set_blackboard_key(BB_FRACTAL_FATALITY_ACTIVE, TRUE)

	StartCooldown()

	INVOKE_ASYNC(src, PROC_REF(do_fatality), victim)

	return TRUE


/datum/action/cooldown/mob_cooldown/fractal_fatality/proc/do_fatality(mob/living/victim)
	if(!victim || QDELETED(victim) || victim.stat == DEAD)
		end_fatality()
		return

	var/dist = get_dist(owner, victim) - 1

	if(dist > 0)
		owner.visible_message(
			span_danger("[owner] suddenly charges towards [victim]!")
		)

		if(charge_delay)
			if(!do_after(owner, charge_delay))
				owner.balloon_alert(owner, "Interrupted!")
				return

		if(charge_sound)
			playsound(owner, charge_sound, 50, TRUE)

		for(var/i = 1 to dist)
			if(!victim || QDELETED(victim) || victim.stat == DEAD)
				end_fatality()
				return

			if(get_dist(owner, victim) <= 1)
				break

			// The victim can move while the mutant is charging.
			var/turf/victim_turf = get_turf(victim)

			if(!victim_turf)
				end_fatality()
				return

			new /obj/effect/temp_visual/decoy/fading/halfsecond(owner.loc, owner)

			owner.forceMove(get_step_towards(owner, victim_turf))

			sleep(charge_speed)

	// The charge must have brought us close enough.
	if(!victim || QDELETED(victim))
		end_fatality()
		return

	if(get_dist(owner, victim) > fatality_range)
		end_fatality()
		return


	victim.Stun(1 MINUTES)
	victim.Knockdown(1 MINUTES)

	// We only stun the owner after the charge.
	var/mob/living/living_owner = owner
	living_owner.Stun(12 SECONDS)

	owner.face_atom(victim)
	victim.face_atom(owner)

	owner.visible_message(
		span_userdanger("[owner] suddenly grabs [victim]!")
	)

	if(grab_sound)
		playsound(owner, grab_sound, 80, TRUE)

	if(!do_after(owner, preparation_time, target = victim))
		end_fatality()
		return

	if(!victim || QDELETED(victim))
		end_fatality()
		return

	if(get_dist(owner, victim) > fatality_range)
		end_fatality()
		return

	owner.visible_message(
		span_userdanger("[owner] lifts [victim] off the ground!")
	)

	animate(
		victim,
		pixel_y = victim.pixel_y + 12,
		time = lift_time,
		easing = QUAD_EASING
	)

	animate(
		owner,
		pixel_y = owner.pixel_y + 2,
		time = lift_time,
		easing = QUAD_EASING
	)

	sleep(lift_time)

	if(!victim || QDELETED(victim))
		end_fatality()
		return

	if(get_dist(owner, victim) > fatality_range)
		end_fatality()
		return

	owner.visible_message(
		span_userdanger("[victim] hangs helplessly above the ground in [owner]'s grasp.")
	)

	sleep(6)

	if(!victim || QDELETED(victim))
		end_fatality()
		return

	if(get_dist(owner, victim) > fatality_range)
		end_fatality()
		return

	owner.visible_message(
		span_userdanger("[owner] violently twists [victim] upside down!")
	)

	animate(
		victim,
		transform = victim.transform.Turn(180),
		time = flip_time,
		easing = QUAD_EASING
	)

	sleep(flip_time)

	if(!victim || QDELETED(victim))
		end_fatality()
		return

	if(get_dist(owner, victim) > fatality_range)
		end_fatality()
		return

	playsound(owner, kill_sound, 100, TRUE)

	owner.visible_message(
		span_userdanger("[owner] tears [victim] apart!")
	)

	animate(
		owner,
		pixel_x = owner.pixel_x + 2,
		time = 2
	)

	animate(
		victim,
		transform = victim.transform.Scale(1, 1.3),
		time = 4,
		easing = QUAD_EASING
	)

	sleep(kill_time)

	if(!victim || QDELETED(victim))
		end_fatality()
		return

	if(get_dist(owner, victim) > fatality_range)
		end_fatality()
		return

	var/turf/kill_turf = get_turf(victim)

	if(!kill_turf)
		end_fatality()
		return

	animate(
		owner,
		pixel_x = owner.pixel_x - 3,
		time = 2,
		easing = QUAD_EASING
	)

	animate(
		victim,
		pixel_y = victim.pixel_y + 3,
		transform = victim.transform.Scale(1, 1.45),
		time = 3,
		easing = QUAD_EASING
	)

	shake_camera(victim, 6, 2)

	playsound(kill_turf, kill_sound, 100, TRUE)

	victim.visible_message(
		span_userdanger("[owner] violently tears [victim] apart!")
	)

	sleep(3)

	if(!victim || QDELETED(victim))
		end_fatality()
		return

	if(iscarbon(victim))
		var/mob/living/carbon/C = victim

		C.death(TRUE)

		C.spill_organs()

		var/list/parts_to_remove = list()

		for(var/obj/item/bodypart/part as anything in C.bodyparts)
			if(istype(part, /obj/item/bodypart/l_leg) || \
				istype(part, /obj/item/bodypart/r_leg))
				parts_to_remove += part

		for(var/obj/item/bodypart/part as anything in parts_to_remove)
			if(!part || QDELETED(part))
				continue

			if(!part.drop_limb())
				continue

			var/direction = get_dir(owner, C)

			if(!direction)
				direction = pick(GLOB.alldirs)

			part.throw_at(
				get_edge_target_turf(kill_turf, direction),
				rand(2, 4),
				5
			)

		new /obj/effect/gibspawner/human(kill_turf)

		playsound(
			kill_turf,
			pick(list(
				'sound/combat/gib (1).ogg',
				'sound/combat/gib (2).ogg'
			)),
			100,
			TRUE
		)

	else
		victim.adjustBruteLoss(200)

		if(victim.stat != DEAD)
			victim.death()
	end_fatality()
	animate(
		owner,
		pixel_y = 0,
		time = 4
	)

/datum/action/cooldown/mob_cooldown/fractal_fatality/proc/end_fatality()
	var/datum/ai_controller/controller = owner?.ai_controller

	if(controller)
		controller.clear_blackboard_key(BB_FRACTAL_FATALITY_ACTIVE)






/datum/action/cooldown/mob_cooldown/fractal_finish
	name = "Fractal Finish"
	desc = "Finish off an incapacitated victim."
	cooldown_time = 3 SECONDS
	melee_cooldown_time = 0
	shared_cooldown = NONE

	button_icon = 'icons/obj/magic.dmi'
	button_icon_state = "2"

	var/finish_range = 1
	var/finish_delay = 1
	var/finish_sound = 'modular_fenysha_events/sound/fractal_glitch2.ogg'


/datum/action/cooldown/mob_cooldown/fractal_finish/PreActivate(atom/target)
	target = get_turf(target)

	if(!target)
		return FALSE

	if(get_dist(owner, target) > finish_range)
		return FALSE

	var/mob/living/victim = locate() in target.contents

	if(!victim || victim == owner)
		return FALSE

	if(victim.stat != UNCONSCIOUS)
		return FALSE

	return ..()


/datum/action/cooldown/mob_cooldown/fractal_finish/Activate(atom/target)
	var/turf/T = get_turf(target)

	if(!T)
		return FALSE

	var/mob/living/victim

	for(var/mob/living/M in T.contents)
		if(M != owner && M.stat == UNCONSCIOUS)
			victim = M
			break

	if(!victim)
		return FALSE

	if(get_dist(owner, victim) > finish_range)
		return FALSE

	StartCooldown()

	INVOKE_ASYNC(src, PROC_REF(do_finish), victim)

	return TRUE


/datum/action/cooldown/mob_cooldown/fractal_finish/proc/do_finish(mob/living/victim)
	if(!victim || QDELETED(victim))
		return

	if(victim.stat != UNCONSCIOUS)
		return

	if(get_dist(owner, victim) > finish_range)
		return

	owner.face_atom(victim)
	victim.face_atom(owner)

	owner.visible_message(
		span_danger("[owner] crouches over [victim].")
	)

	if(finish_sound)
		playsound(owner, finish_sound, 80, TRUE)

	if(finish_delay)
		sleep(finish_delay)

	if(!victim || QDELETED(victim))
		return

	if(victim.stat != UNCONSCIOUS)
		return

	if(get_dist(owner, victim) > finish_range)
		return

	var/turf/T = get_turf(victim)

	if(!T)
		return

	owner.visible_message(
		span_userdanger("[owner] tears [victim] apart!")
	)

	shake_camera(victim, 6, 2)

	if(iscarbon(victim))
		var/mob/living/carbon/C = victim

		C.death(TRUE)

		// Spill the contents of the chest.
		C.spill_organs()

		var/list/parts = list()

		for(var/obj/item/bodypart/part as anything in C.bodyparts)
			if(
				istype(part, /obj/item/bodypart/l_arm) || \
				istype(part, /obj/item/bodypart/r_arm) || \
				istype(part, /obj/item/bodypart/l_leg) || \
				istype(part, /obj/item/bodypart/r_leg)
			)
				parts += part

		for(var/obj/item/bodypart/part as anything in parts)
			if(QDELETED(part))
				continue

			if(!part.drop_limb())
				continue

			part.throw_at(
				get_edge_target_turf(T, pick(GLOB.alldirs)),
				1,
				3
			)

		new /obj/effect/gibspawner/human(T)

		playsound(
			T,
			pick(list(
				'sound/combat/gib (1).ogg',
				'sound/combat/gib (2).ogg'
			)),
			90,
			TRUE
		)

	else
		victim.death()


/datum/action/cooldown/mob_cooldown/fractal_roar
	name = "Fractal Roar"
	desc = "Release a violent shock through your surroundings, knocking nearby creatures from their feet."
	cooldown_time = 12 SECONDS
	melee_cooldown_time = 0
	shared_cooldown = NONE

	button_icon = 'icons/obj/magic.dmi'
	button_icon_state = "4"

	var/range = 2
	var/knockdown_time = 15
	var/charge_time = 3

	var/sound = 'modular_fenysha_events/sound/fractal_scream3.ogg'


/datum/action/cooldown/mob_cooldown/fractal_roar/Activate(atom/target)
	if(!owner)
		return FALSE

	INVOKE_ASYNC(src, PROC_REF(do_roar))

	StartCooldown()
	return TRUE


/datum/action/cooldown/mob_cooldown/fractal_roar/proc/do_roar()
	owner.visible_message(
		span_danger("[owner] releases a violent pulse of force!")
	)

	// Small wind-up.
	animate(
		owner,
		transform = owner.transform.Scale(1.15, 0.9),
		time = charge_time,
		easing = QUAD_EASING
	)

	sleep(charge_time)

	if(!owner || QDELETED(owner))
		return

	animate(
		owner,
		transform = matrix(),
		time = 2,
		easing = QUAD_EASING
	)

	playsound(owner, sound, 90, TRUE)

	// Simple visual ring around the monster.
	for(var/direction in GLOB.alldirs)
		var/turf/T = get_step(get_turf(owner), direction)

		if(!T)
			continue

		new /obj/effect/temp_visual/decoy/fading/halfsecond(T, owner)

	// Hit everything nearby.
	for(var/mob/living/victim in range(range, owner))
		if(victim == owner)
			continue

		if(victim.stat == DEAD)
			continue

		victim.Knockdown(knockdown_time)
		shake_camera(victim, 4, 1)



/datum/action/cooldown/mob_cooldown/fractal_repulse
	name = "Fractal Repulse"
	desc = "Blast nearby creatures away from you."
	cooldown_time = 9 SECONDS
	melee_cooldown_time = 0
	shared_cooldown = NONE

	button_icon = 'icons/obj/magic.dmi'
	button_icon_state = "1"

	var/range = 2
	var/throw_distance = 3
	var/throw_speed = 4

	var/sound = 'modular_fenysha_events/sound/fractal_glitch2.ogg'


/datum/action/cooldown/mob_cooldown/fractal_repulse/Activate(atom/target)
	if(!owner)
		return FALSE

	INVOKE_ASYNC(src, PROC_REF(do_repulse))

	StartCooldown()
	return TRUE


/datum/action/cooldown/mob_cooldown/fractal_repulse/proc/do_repulse()
	owner.visible_message(
		span_danger("[owner] releases a violent burst of force!")
	)

	// Brief anticipation.
	animate(
		owner,
		transform = owner.transform.Scale(0.9, 1.1),
		time = 3,
		easing = QUAD_EASING
	)

	sleep(3)

	if(!owner || QDELETED(owner))
		return

	animate(
		owner,
		transform = matrix(),
		time = 2,
		easing = QUAD_EASING
	)

	playsound(owner, sound, 100, TRUE)

	var/turf/origin = get_turf(owner)

	if(!origin)
		return

	for(var/mob/living/victim in range(range, origin))
		if(victim == owner)
			continue

		if(victim.stat == DEAD)
			continue

		var/turf/victim_turf = get_turf(victim)

		if(!victim_turf)
			continue

		var/direction = get_dir(origin, victim_turf)

		if(!direction)
			direction = pick(GLOB.alldirs)

		var/turf/destination = get_ranged_target_turf(
			victim_turf,
			direction,
			throw_distance
		)

		if(destination)
			victim.throw_at(
				destination,
				throw_distance,
				throw_speed
			)

		shake_camera(victim, 5, 1)


