/mob
	/// If we are in the shifting setting.
	var/shifting = FALSE
	/// Cosmetic angle, independent of posture and facing.
	var/pixel_rotation = 0

	/// Takes the four cardinal direction defines. Any atoms moving into this atom's tile will be allowed to from the added directions.
	var/passthroughable = NONE

/datum/keybinding/mob/pixel_shift
	hotkey_keys = list() // purposefully left blank
	hold_binding = TRUE
	name = "pixel_shift"
	full_name = "Pixel Shift"
	description = "Hold: movement keys shift and Q/E rotate. Use your empty hand with a grab in the other hand to pose the grabbed person."

/datum/keybinding/mob/pixel_shift/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/M = user.mob
	M.shifting = TRUE
	return TRUE

/datum/keybinding/mob/pixel_shift/up(client/user)
	. = ..()
	if(.)
		return
	var/mob/M = user.mob
	M.shifting = FALSE
	return TRUE

/mob/proc/unpixel_shift()
	return

/mob/living/unpixel_shift()
	. = ..()
	reset_pixel_rotation()
	passthroughable = NONE
	if(is_shifted)
		is_shifted = FALSE
		pixel_x = get_standard_pixel_x_offset() + base_pixel_x
		pixel_y = get_standard_pixel_y_offset() + base_pixel_y

/mob/proc/pixel_shift(direction)
	return

/mob/living/set_pull_offsets(mob/living/pull_target, grab_state)
	pull_target.unpixel_shift()
	return ..()

/mob/living/reset_pull_offsets(mob/living/pull_target, override)
	pull_target.unpixel_shift()
	return ..()

/mob/living/pixel_shift(direction)
	passthroughable = NONE
	if(CHECK_BITFIELD(direction, NORTH))
		if(pixel_y <= PIXEL_SHIFT_MAXIMUM + base_pixel_y)
			pixel_y++
			is_shifted = TRUE
	if(CHECK_BITFIELD(direction, EAST))
		if(pixel_x <= PIXEL_SHIFT_MAXIMUM + base_pixel_x)
			pixel_x++
			is_shifted = TRUE
	if(CHECK_BITFIELD(direction, SOUTH))
		if(pixel_y >= -PIXEL_SHIFT_MAXIMUM + base_pixel_y)
			pixel_y--
			is_shifted = TRUE
	if(CHECK_BITFIELD(direction, WEST))
		if(pixel_x >= -PIXEL_SHIFT_MAXIMUM + base_pixel_x)
			pixel_x--
			is_shifted = TRUE

	// Yes, I know this sets it to true for everything if more than one is matched.
	// Movement doesn't check diagonals, and instead just checks EAST or WEST, depending on where you are for those.
	if(pixel_y > PIXEL_SHIFT_PASSABLE_THRESHOLD)
		passthroughable |= EAST | SOUTH | WEST
	if(pixel_x > PIXEL_SHIFT_PASSABLE_THRESHOLD)
		passthroughable |= NORTH | SOUTH | WEST
	if(pixel_y < -PIXEL_SHIFT_PASSABLE_THRESHOLD)
		passthroughable |= NORTH | EAST | WEST
	if(pixel_x < -PIXEL_SHIFT_PASSABLE_THRESHOLD)
		passthroughable |= NORTH | EAST | SOUTH

/mob/living/CanPass(atom/movable/mover, turf/target)
	if(!mover)	//On rare occasions, there isn't a mover present.
		return ..()
	// Make sure to not allow projectiles of any kind past where they normally wouldn't.
	if(!istype(mover, /obj/projectile) && !mover?.throwing && passthroughable & get_dir(src, mover))
		return TRUE
	return ..()

/datum/keybinding/mob/pixel_rotate_reset
	hotkey_keys = list()
	name = "pixel_rotate_reset"
	full_name = "Pixel Rotate: Reset"
	description = "Reset cosmetic rotation while keeping your pixel position."

/datum/keybinding/mob/pixel_rotate_reset/down(client/user)
	var/mob/living/target = user.mob.get_pixel_shift_target()
	if(isliving(target))
		target.reset_pixel_rotation()
		if(target != user.mob)
			user.mob.update_vision_cone()
	return TRUE

/mob/proc/pixel_rotate(angle)
	return

/mob/living/carbon/pixel_rotate(angle)
	if(notransform || !isturf(loc))
		return
	if(buckled && (!isliving(buckled) || !buckled.GetComponent(/datum/component/riding)))
		return
	if(mobility_flags & MOBILITY_STAND)
		// Stored angles wrap through 360; standing limits are relative to upright.
		var/current_lean = pixel_rotation > 180 ? pixel_rotation - 360 : pixel_rotation
		var/new_lean = clamp(current_lean + angle, -PIXEL_ROTATION_STANDING_LIMIT, PIXEL_ROTATION_STANDING_LIMIT)
		angle = new_lean - current_lean
	if(!angle)
		return
	var/matrix/new_transform = matrix(transform)
	new_transform.Turn(angle)
	transform = new_transform
	// Refresh the cached self-image used by the field-of-view system.
	update_vision_cone()
	pixel_rotation = ((pixel_rotation + angle) % 360 + 360) % 360
	is_shifted = TRUE

/mob/living/proc/reset_pixel_rotation()
	if(!pixel_rotation)
		return
	var/matrix/new_transform = matrix(transform)
	new_transform.Turn(-pixel_rotation)
	transform = new_transform
	// Refresh the cached self-image used by the field-of-view system.
	update_vision_cone()
	pixel_rotation = 0

/client
	/// Share one rotation step per tick between initial presses and held input.
	var/next_pixel_rotation = 0

/client/proc/pixel_rotation_key_angle(key)
	switch(key)
		if("Q")
			return -5
		if("E")
			return 5
	return 0

/// Repeat held rotations and return the directions still available for pixel movement.
/client/proc/process_pixel_shift_input()
	var/angle = 0
	var/movement_dir = NONE
	for(var/key in keys_held)
		var/key_angle = pixel_rotation_key_angle(key)
		if(key_angle)
			angle += key_angle
		else
			movement_dir |= movement_keys[key]
	if(angle)
		step_pixel_rotation(clamp(angle, -5, 5))
	return movement_dir

/client/proc/step_pixel_rotation(angle)
	if(world.time < next_pixel_rotation)
		return
	next_pixel_rotation = world.time + world.tick_lag
	var/mob/target = mob.get_pixel_shift_target()
	target?.pixel_rotate(angle)
	if(target && target != mob)
		mob.update_vision_cone()

/// Resolve the pose target afresh so hand swaps and released grabs take effect immediately.
/mob/proc/get_pixel_shift_target()
	return src

/mob/living/carbon/get_pixel_shift_target()
	if(stat != CONSCIOUS || notransform)
		return
	if(get_active_held_item() || !has_active_hand())
		return src
	var/obj/item/grabbing/grab = get_inactive_held_item()
	if(!istype(grab))
		return src
	if(QDELETED(grab) || grab.grabbee != src || !isliving(grab.grabbed))
		return
	var/mob/living/target = grab.grabbed
	if(QDELETED(target) || !Adjacent(target) || target.notransform || target.buckled || !isturf(target.loc))
		return
	return target
