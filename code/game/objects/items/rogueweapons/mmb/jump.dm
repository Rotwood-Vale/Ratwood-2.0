/datum/intent/jump
	name = "jump"
	candodge = FALSE
	canparry = FALSE
	chargedrain = 0
	chargetime = 0
	noaa = TRUE
	pointer = 'icons/effects/mousemice/human_jump.dmi'

/datum/intent/jump/on_mmb(atom/target, mob/living/user, params)
	user.jump_action(target)

/mob/living/proc/jump_action(atom/A)
	if(istype(get_turf(src), /turf/open/water))
		to_chat(src, span_warning("I can't jump while floating."))
		return FALSE

	if(!A || QDELETED(A) || !A.loc)
		return FALSE

	if(A == src || A == loc)
		return FALSE

	if(src.get_num_legs() < 2)
		return FALSE

	if(pulledby && pulledby != src)
		to_chat(src, span_warning("I'm unable to jump while grabbed."))
		return FALSE

	if(IsOffBalanced())
		to_chat(src, span_warning("I haven't regained my balance yet."))
		return FALSE

	if(!(mobility_flags & MOBILITY_STAND))
		if(!HAS_TRAIT(src, TRAIT_LEAPER))// The Jester cares not for such social convention.
			to_chat(src, span_warning("I should stand up first."))
			return FALSE

	if(!isatom(A))
		return FALSE

	if(A.z != z)
		if(!HAS_TRAIT(src, TRAIT_ZJUMP))
			to_chat(src, span_warning("That's too high for me..."))
			return FALSE

	var/mob/living/simple_animal/animal_mount = get_buckled_animal_mount()
	if(animal_mount && animal_mount.has_buckled_mobs() && animal_mount.buckled_mobs.len > 1)
		to_chat(src, span_warning("[animal_mount] is carrying too much weight to jump."))
		return FALSE

	SEND_SIGNAL(src, COMSIG_LIVING_ONJUMP, A)

	changeNext_move(mmb_intent.clickcd)

	face_atom(A)

	var/jadded
	var/jrange
	var/jextra = FALSE

	if(m_intent == MOVE_INTENT_RUN)
		if(animal_mount)
			animal_mount.emote("leap", forced = TRUE)
		else
			emote("leap", forced = TRUE)
		OffBalance(30)
		jadded = 45
		jrange = 3

		if(!HAS_TRAIT(src, TRAIT_LEAPER))// The Jester lands where the Jester wants.
			jextra = TRUE
	else
		if(animal_mount)
			animal_mount.emote("jump", forced = TRUE)
		emote("jump", forced = TRUE)
		OffBalance(20)
		jadded = 20
		jrange = 2

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		jadded += H.get_complex_pain()/50
		if(!H.check_armor_skill() || H.legcuffed)
			jadded += 50
			jrange = 1

	jump_action_resolve(A, jadded, jrange, jextra)
	return TRUE

#define FLIP_DIRECTION_CLOCKWISE 1
#define FLIP_DIRECTION_ANTICLOCKWISE 0

/mob/living/proc/jump_action_resolve(atom/A, jadded, jrange, jextra)
	var/atom/movable/jump_movable = src
	var/mob/living/simple_animal/animal_mount = get_buckled_animal_mount()
	var/was_mounted = FALSE
	var/mount_prev_pixel_z
	var/prev_layer
	if(animal_mount)
		mount_prev_pixel_z = animal_mount.pixel_z
		prev_layer = layer
		layer = animal_mount.layer + 0.1
		var/datum/component/riding/mount_riding = animal_mount.GetComponent(/datum/component/riding)
		if(mount_riding && mount_riding.driver == src)
			mount_riding.driver = null
		animal_mount.unbuckle_mob(src, TRUE)
		was_mounted = TRUE

	var/do_a_flip
	var/flip_direction = FLIP_DIRECTION_CLOCKWISE
	var/prev_pixel_z = pixel_z
	var/prev_transform = transform
	if(get_skill_level(/datum/skill/misc/athletics) > 4)
		do_a_flip = TRUE
		if((dir & SOUTH) || (dir & WEST))
			flip_direction = FLIP_DIRECTION_ANTICLOCKWISE

	if(was_mounted || stamina_add(min(jadded,100)))
		if(do_a_flip)
			var/flip_angle = flip_direction ? 120 : -120
			if(was_mounted && animal_mount && !QDELETED(animal_mount))
				animate(animal_mount, pixel_z = animal_mount.pixel_z + 6, time = 1)
				animate(pixel_z = mount_prev_pixel_z, time = 2)
			animate(src, pixel_z = pixel_z + (was_mounted ? 10 : 6), transform = turn(transform, flip_angle), time = 1)
			animate(transform = turn(transform, flip_angle), time=1)
			animate(pixel_z = prev_pixel_z, transform = turn(transform, flip_angle), time=1)
			animate(transform = prev_transform, time = 0)
		else
			if(was_mounted && animal_mount && !QDELETED(animal_mount))
				animate(animal_mount, pixel_z = animal_mount.pixel_z + 6, time = 1)
				animate(pixel_z = mount_prev_pixel_z, time = 2)
			animate(src, pixel_z = pixel_z + (was_mounted ? 10 : 6), time = 1)
			animate(pixel_z = prev_pixel_z, transform = turn(transform, pick(-12, 0, 12)), time=2)
			animate(transform = prev_transform, time = 0)

		if(jextra)
			jump_movable.throw_at(A, jrange, 1, jump_movable, spin = FALSE)
			while(jump_movable.throwing)
				if(was_mounted && animal_mount && !QDELETED(animal_mount) && isturf(src.loc))
					animal_mount.forceMove(get_turf(src))
				sleep(1)
			jump_movable.throw_at(get_step(jump_movable, jump_movable.dir), 1, 1, jump_movable, spin = FALSE)
			while(jump_movable.throwing)
				if(was_mounted && animal_mount && !QDELETED(animal_mount) && isturf(src.loc))
					animal_mount.forceMove(get_turf(src))
				sleep(1)
		else
			jump_movable.throw_at(A, jrange, 1, jump_movable, spin = FALSE)
			while(jump_movable.throwing)
				if(was_mounted && animal_mount && !QDELETED(animal_mount) && isturf(src.loc))
					animal_mount.forceMove(get_turf(src))
				sleep(1)
		if(!HAS_TRAIT(src, TRAIT_ZJUMP) && (m_intent == MOVE_INTENT_RUN))	//Jesters and werewolves don't get immobilized at all
			Immobilize((HAS_TRAIT(src, TRAIT_LEAPER) ? 5 : 10))	//Acrobatics get half the time
		if(isopenturf(jump_movable.loc))
			var/turf/open/T = jump_movable.loc
			if(T.landsound)
				playsound(T, T.landsound, 100, FALSE)
			T.Entered(jump_movable)
	else
		animate(src, pixel_z = pixel_z + 6, time = 1)
		animate(pixel_z = prev_pixel_z, transform = turn(transform, pick(-12, 0, 12)), time=2)
		animate(transform = prev_transform, time = 0)
		jump_movable.throw_at(A, 1, 1, jump_movable, spin = FALSE)

	if(mob_offsets)
		for(var/o in mob_offsets)
			if(mob_offsets[o])
				reset_offsets(o)

	if(was_mounted && !isnull(prev_layer))
		layer = prev_layer

	if(was_mounted && animal_mount && !QDELETED(animal_mount) && isturf(src.loc))
		animal_mount.forceMove(get_turf(src))
		animal_mount.buckle_mob(src, TRUE, FALSE)
		var/datum/component/riding/mount_riding_after = animal_mount.GetComponent(/datum/component/riding)
		if(mount_riding_after)
			mount_riding_after.driver = src
			mount_riding_after.handle_vehicle_layer()
			mount_riding_after.handle_vehicle_offsets()

#undef FLIP_DIRECTION_CLOCKWISE
#undef FLIP_DIRECTION_ANTICLOCKWISE

/mob/living/proc/get_jump_range()
	if(!check_armor_skill() || get_item_by_slot(SLOT_LEGCUFFED))
		return 1
	if(m_intent == MOVE_INTENT_RUN)
		return 3
	return 2

/// Returns the stamina cost to jump. Will never use more than 100 stam.
/mob/living/proc/get_jump_stam_cost()
	. = 10
	if(m_intent == MOVE_INTENT_RUN)
		. = 15
	var/mob/living/carbon/human/H = src
	if(istype(H))
		. += H.get_complex_pain()/50
	if(!check_armor_skill() || get_item_by_slot(SLOT_LEGCUFFED))
		. += 50
	return clamp(., 0, 100)

/mob/living/proc/get_jump_offbalance_time()
	if(m_intent == MOVE_INTENT_RUN)
		return 3 SECONDS
	return 2 SECONDS

/// Performs a jump. Used by the jump MMB intent. Returns TRUE if a jump was performed.
/mob/living/proc/can_jump(atom/A)
	var/turf/our_turf = get_turf(src)
	if(istype(our_turf, /turf/open/water))
		to_chat(src, span_warning("I'm floating in [our_turf]."))
		return FALSE
	if(!A || QDELETED(A) || !A.loc)
		return FALSE
	if(A == src || A == src.loc)
		return FALSE
	if(get_num_legs() < 2)
		return FALSE
	if(pulledby && pulledby != src)
		to_chat(src, span_warning("I'm being grabbed."))
		return FALSE
	if(IsOffBalanced())
		to_chat(src, span_warning("I haven't regained my balance yet."))
		return FALSE
	if(!(mobility_flags & MOBILITY_STAND) && !HAS_TRAIT(src, TRAIT_LEAPER))// The Jester cares not for such social convention.
		to_chat(src, span_warning("I should stand up first."))
		return FALSE
	if(A.z != z && !HAS_TRAIT(src, TRAIT_ZJUMP))
		return FALSE
	return TRUE
