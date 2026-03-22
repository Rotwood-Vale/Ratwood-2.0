/obj/structure/wooden_horse
	name = "wooden saiga"
	desc = "This tireless steed promises a less than pleasant journey, should you dare to ride it."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "whorse"
	base_pixel_x = 0
	pixel_x = 0
	attacked_sound = "woodimpact"
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	blade_dulling = DULLING_BASHCHOP

	anchored = TRUE
	density = TRUE
	layer = OBJ_LAYER
	plane = GAME_PLANE

	can_buckle = TRUE
	max_buckled_mobs = 1
	buckle_lying = 0
	buckle_prevents_pull = TRUE

	max_integrity = 250
	resistance_flags = NONE
	debris = list(/obj/item/natural/wood/plank = 1)

	var/damage_per_tick = 0.2
	var/damage_cap = 75
	var/next_flavor_time = 0
	var/buckle_offset_x = 0
	var/buckle_offset_y = 14

/obj/structure/wooden_horse/Initialize(mapload)
	. = ..()
	LAZYINITLIST(buckled_mobs)
	handle_layer()

/obj/structure/wooden_horse/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation, ROTATION_ALTCLICK | ROTATION_CLOCKWISE, CALLBACK(src, PROC_REF(can_user_rotate)), CALLBACK(src, PROC_REF(can_be_rotated)), null)

/obj/structure/wooden_horse/proc/can_be_rotated(mob/user)
	return TRUE

/obj/structure/wooden_horse/proc/can_user_rotate(mob/user)
	var/mob/living/L = user
	if(istype(L))
		if(!user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
			return FALSE
		return TRUE
	else if(isobserver(user) && CONFIG_GET(flag/ghost_interaction))
		return TRUE
	return FALSE

/obj/structure/wooden_horse/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/wooden_horse/setDir(newdir)
	. = ..()
	handle_rotation(newdir)

/obj/structure/wooden_horse/proc/handle_rotation(direction)
	handle_layer()
	if(has_buckled_mobs())
		for(var/m in buckled_mobs)
			var/mob/living/buckled_mob = m
			buckled_mob.setDir(direction)

/obj/structure/wooden_horse/proc/handle_layer()
	// Mob goes behind the object
	if(dir == NORTH || dir == SOUTH)
		layer = ABOVE_MOB_LAYER
		plane = GAME_PLANE_UPPER
	// Mob sits on top of the object
	else
		layer = OBJ_LAYER
		plane = GAME_PLANE

/obj/structure/wooden_horse/buckle_mob(mob/living/M, force = FALSE, check_loc = TRUE)
	if(!anchored && !istype(src, /obj/structure/wooden_horse/mobile))
		return FALSE

	if(force)
		return ..()

	if(!istype(M, /mob/living/carbon/human))
		to_chat(usr, span_warning("It doesn't look like [M.p_they()] can fit onto this properly!"))
		return FALSE

	// If we are NOT buckling ourselves, we need restraints (chains/grabs)
	if(M != usr)
		var/valid_restraint = FALSE
		var/mob/living/carbon/carbon = M

		if(carbon.handcuffed)
			valid_restraint = TRUE

		if(!valid_restraint)
			for(var/obj/item/grabbing/G in M.grabbedby)
				if(G.grab_state >= GRAB_AGGRESSIVE)
					valid_restraint = TRUE
					break

		if(!valid_restraint)
			to_chat(usr, span_warning("I must grab them more forcefully or handcuff them to put them on [src]."))
			return FALSE

		M.visible_message(span_danger("[usr] starts strapping [M] onto [src]!"), \
			span_userdanger("[usr] starts strapping you onto [src]!"))

		if(!do_after(usr, 5 SECONDS, src))
			return FALSE
	else
		// If we ARE buckling ourselves, we skip restraint checks
		M.visible_message(span_notice("[usr] starts climbing onto [src]..."), \
			span_notice("You start climbing onto [src]..."))
		if(!do_after(usr, 3 SECONDS, src))
			return FALSE

	return ..(M, force, FALSE)

/obj/structure/wooden_horse/post_buckle_mob(mob/living/M)
	. = ..()
	handle_layer()
	M.set_mob_offsets("bed_buckle", _x = buckle_offset_x, _y = buckle_offset_y)
	START_PROCESSING(SSobj, src)

/obj/structure/wooden_horse/post_unbuckle_mob(mob/living/M)
	. = ..()
	if(!buckled_mobs.len)
		STOP_PROCESSING(SSobj, src)

	handle_layer()
	M.regenerate_icons()
	M.reset_offsets("bed_buckle")

/obj/structure/wooden_horse/user_unbuckle_mob(mob/living/buckled_mob, mob/living/user)
	// Someone else is unbuckling the victim
	if(user != buckled_mob)
		user.visible_message(span_notice("[user] starts unstrapping [buckled_mob] from [src]..."), \
			span_notice("You start unstrapping [buckled_mob] from [src]..."))
		if(do_after(user, 3 SECONDS, src))
			return ..()
		return

	// Victim trying to unbuckle self
	to_chat(user, span_warning("You struggle against the tight straps..."))

	// Delay to self-unbuckle
	if(do_after(user, 10 SECONDS, src))
		user.visible_message(span_warning("[user] manages to unstrap [user.p_them()]self from [src]!"), \
			span_notice("You manage to unstrap yourself from [src]!"))
		return ..()

/obj/structure/wooden_horse/process(delta_time)
	if(!buckled_mobs.len)
		STOP_PROCESSING(SSobj, src)
		return

	for(var/mob/living/M in buckled_mobs)
		if(M.resting)
			M.set_resting(FALSE, TRUE)

		// Force offset check
		if(M.pixel_y != buckle_offset_y)
			M.pixel_y = buckle_offset_y

		if(M.stat == DEAD)
			continue

		// Torture logic
		if(iscarbon(M))
			var/mob/living/carbon/victim = M
			// Target the chest
			var/obj/item/bodypart/chest = victim.get_bodypart(BODY_ZONE_CHEST)

			// Sanity check: Ensure they actually have a chest to damage
			if(!chest)
				continue

			// Apply damage if they haven't hit the cap yet
			if(chest.brute_dam < damage_cap)
				victim.apply_damage(damage_per_tick * delta_time, BRUTE, BODY_ZONE_CHEST)

			// Flavor
			if(world.time >= next_flavor_time)
				next_flavor_time = world.time + 2 MINUTES
				to_chat(victim, span_warning("The sharp edge of the [name] digs agonizingly into your nethers!"))

/obj/structure/wooden_horse/mobile
	name = "wooden horse"
	desc = "An affordable means of transportation for all walks of life, though few wish to ride. Watching the galloping of unlucky riders is one of the favorite pastimes of local nobility."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "whorse_2"
	anchored = FALSE
	drag_slowdown = 0.4
	facepull = FALSE
	throw_range = 1

//	var/move_sound = 'sound/wooden_wheels.ogg'
//	var/last_move_sound = 0
//	var/sound_delay = 5

/obj/structure/wooden_horse/mobile/handle_layer()
	// Mob goes behind the object
	if(dir == SOUTH)
		layer = ABOVE_MOB_LAYER
		plane = GAME_PLANE_UPPER
	// Mob sits on top of the object
	else
		layer = OBJ_LAYER
		plane = GAME_PLANE

// /obj/structure/wooden_horse/mobile/Moved(atom/OldLoc, Dir)
//	. = ..()
//	// Play sound on movement
//	if(loc != OldLoc)
//		if(world.time > last_move_sound + sound_delay)
//			playsound(src, move_sound, 50, 1)
//			last_move_sound = world.time
