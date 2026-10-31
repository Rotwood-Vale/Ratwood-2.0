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
		update_dynamic_shadows(custom_glide = 0)

/mob/proc/pixel_shift(direction)
	return

/mob/living/set_pull_offsets(mob/living/pull_target, grab_state)
	pull_target.unpixel_shift()
	return ..()

/mob/living/reset_pull_offsets(mob/living/pull_target, override)
	pull_target.unpixel_shift()
	return ..()

/mob/living/pixel_shift(direction)
	var/old_px = pixel_x
	var/old_py = pixel_y
	passthroughable = NONE
	var/max_n = PIXEL_SHIFT_MAXIMUM
	var/max_s = -PIXEL_SHIFT_MAXIMUM
	var/max_e = PIXEL_SHIFT_MAXIMUM
	var/max_w = -PIXEL_SHIFT_MAXIMUM
	var/wall_limit = 10 

	var/turf/TN = get_step(src, NORTH)
	var/turf/TS = get_step(src, SOUTH)
	var/turf/TE = get_step(src, EAST)
	var/turf/TW = get_step(src, WEST)

	if(is_wall_tile(TN) || get_round_occluder(TN)) max_n = min(max_n, wall_limit)
	if(is_wall_tile(TS) || get_round_occluder(TS)) max_s = max(max_s, -wall_limit)
	if(is_wall_tile(TE) || get_round_occluder(TE)) max_e = min(max_e, wall_limit)
	if(is_wall_tile(TW) || get_round_occluder(TW)) max_w = max(max_w, -wall_limit)

	if(CHECK_BITFIELD(direction, NORTH))
		if(pixel_y < max_n + base_pixel_y)
			pixel_y++
			is_shifted = TRUE
	if(CHECK_BITFIELD(direction, EAST))
		if(pixel_x < max_e + base_pixel_x)
			pixel_x++
			is_shifted = TRUE
	if(CHECK_BITFIELD(direction, SOUTH))
		if(pixel_y > max_s + base_pixel_y)
			pixel_y--
			is_shifted = TRUE
	if(CHECK_BITFIELD(direction, WEST))
		if(pixel_x > max_w + base_pixel_x)
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

	if(pixel_x != old_px || pixel_y != old_py)
		update_dynamic_shadows(custom_glide = 0)

/mob/living/CanPass(atom/movable/mover, turf/target)
	if(!mover)	//On rare occasions, there isn't a mover present.
		return ..()
	// Make sure to not allow projectiles of any kind past where they normally wouldn't.
	if(!istype(mover, /obj/projectile) && !mover?.throwing && passthroughable & get_dir(src, mover))
		return TRUE
	return ..()
