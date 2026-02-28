/mob
	/// If we are in the shifting setting.
	var/shifting = FALSE

	/// Takes the four cardinal direction defines. Any atoms moving into this atom's tile will be allowed to from the added directions.
	var/passthroughable = NONE

/datum/keybinding/mob/pixel_shift
	hotkey_keys = list() // purposefully left blank
	name = "pixel_shift"
	full_name = "Pixel Shift"
	description = "Shift your characters offset."

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
	set_pixel_passthrough()

/mob/proc/set_pixel_passthrough(pixel_shift_passable_threshold = PIXEL_SHIFT_PASSABLE_THRESHOLD)
	passthroughable = NONE
	// Yes, I know this sets it to true for everything if more than one is matched.
	// Movement doesn't check diagonals, and instead just checks EAST or WEST, depending on where you are for those.
	if(pixel_y > pixel_shift_passable_threshold)
		passthroughable |= EAST | SOUTH | WEST
	if(pixel_x > pixel_shift_passable_threshold)
		passthroughable |= NORTH | SOUTH | WEST
	if(pixel_y < -pixel_shift_passable_threshold)
		passthroughable |= NORTH | EAST | WEST
	if(pixel_x < -pixel_shift_passable_threshold)
		passthroughable |= NORTH | EAST | SOUTH

/mob/living/CanPass(atom/movable/mover, turf/target)
	if(!mover)	//On rare occasions, there isn't a mover present.
		return ..()
	// Make sure to not allow projectiles of any kind past where they normally wouldn't.
	if(!istype(mover, /obj/projectile) && !mover?.throwing && passthroughable & get_dir(src, mover))
		return TRUE
	return ..()

/// Sets pixel shift based on which side we are handholding
/mob/proc/handholding_pixel_shift(handholding)
	return

/mob/living/carbon/handholding_pixel_shift(handholding)
	if(handholding == 0)
		return FALSE
	var/pixel_offset
	if(handholding == 1)
		pixel_offset = -6
	if(handholding == 2)
		pixel_offset = 6
	if(CHECK_BITFIELD(dir, NORTH))
		pixel_x = base_pixel_x + pixel_offset
		pixel_y = base_pixel_y
		is_shifted = TRUE
	if(CHECK_BITFIELD(dir, EAST))
		pixel_y = base_pixel_y + pixel_offset
		pixel_x = base_pixel_x
		is_shifted = TRUE
	if(CHECK_BITFIELD(dir, SOUTH))
		pixel_x = base_pixel_x - pixel_offset
		pixel_y = base_pixel_y
		is_shifted = TRUE
	if(CHECK_BITFIELD(dir, WEST))
		pixel_y = base_pixel_y - pixel_offset
		pixel_x = base_pixel_x
		is_shifted = TRUE
	set_pixel_passthrough(5)
