#define SHADOW_IMAGE_POOL_SIZE 500
#define SHADOW_OPACITY         255
GLOBAL_LIST_EMPTY(fov_cutout_objects)
GLOBAL_VAR_INIT(fov_box_uid, 0)

/client
	var/list/image/shadow_images_pool = list()
	var/list/image/active_shadows = list()

/client/proc/init_shadow_pool()
	if(shadow_images_pool.len || active_shadows.len)
		return

	for(var/i in 1 to SHADOW_IMAGE_POOL_SIZE)
		var/image/I = image('icons/effects/shadow_geom.dmi', icon_state = "triangle")
		I.plane = RAW_WALL_SHADOW_PLANE
		I.blend_mode = BLEND_ADD
		I.color = "#ffffff"
		I.alpha = SHADOW_OPACITY
		I.appearance_flags = NO_CLIENT_COLOR | RESET_COLOR
		shadow_images_pool += I
		images += I

/client/proc/alloc_shadow_image()
	if(shadow_images_pool.len)
		var/image/I = shadow_images_pool[shadow_images_pool.len]
		shadow_images_pool.len--
		return I

	var/image/I = image('icons/effects/shadow_geom.dmi', icon_state = "triangle")
	I.plane = RAW_WALL_SHADOW_PLANE
	I.blend_mode = BLEND_ADD
	I.color = "#ffffff"
	I.alpha = SHADOW_OPACITY
	I.appearance_flags = NO_CLIENT_COLOR | RESET_COLOR
	images += I
	return I

/client/proc/clear_unused_shadows(list/used_keys)
	var/list/keys_to_remove = list()

	for(var/key in active_shadows)
		if(!used_keys || !used_keys[key])
			var/image/I = active_shadows[key]
			if(I)
				I.loc = null
				animate(I)
				I.transform = matrix()
				shadow_images_pool += I
			keys_to_remove += key

	if(keys_to_remove.len)
		active_shadows -= keys_to_remove

/client/proc/init_shadow_images()
	init_shadow_pool()

/proc/is_wall_tile(turf/T)
	if(!T) return FALSE
	if(T.density && T.opacity) return TRUE
	if(istype(T, /turf/closed)) return TRUE
	return FALSE

/proc/get_round_occluder(turf/T)
	if(!T) return null
	for(var/atom/A in T.contents)
		if(istype(A, /obj/structure/flora/newtree))
			if(A.density && A.opacity)
				return A
	return null

/mob/living
	var/shadow_glide_id = 0
	var/shadow_curr_px = null
	var/shadow_curr_py = null
	var/turf/last_shadow_turf
	var/is_looking_afar = FALSE
	var/shadow_glide_time = 0  

/proc/notify_shadows_map_changed(atom/A, custom_range = 18, mob/living/skip_mob = null)
	if(!SSmapping || !SSmapping.initialized)
		return

	for(var/mob/living/L in range(custom_range, A))
		if(!L.client || L == skip_mob)
			continue
		L.update_dynamic_shadows(custom_glide = 0)

/mob/living/proc/update_dynamic_shadows(custom_px = null, custom_py = null, custom_radius = null, custom_glide = 0)
	if(!client)
		return
	client.init_shadow_pool()

	var/turf/my_turf = get_turf(src)
	if(!my_turf)
		return

	var/px
	var/py
	if(custom_px != null && custom_py != null)
		px = custom_px
		py = custom_py
	else
		var/total_px = (isnum(src.step_x) ? src.step_x : 0) + src.pixel_x
		var/total_py = (isnum(src.step_y) ? src.step_y : 0) + src.pixel_y
		px = my_turf.x + 0.5 + (total_px / 32.0)
		py = my_turf.y + 0.5 + (total_py / 32.0)

	shadow_curr_px = px
	shadow_curr_py = py

	var/my_z = my_turf.z
	var/radius = custom_radius ? custom_radius : (is_looking_afar ? 18 : 8)

	var/list/quad_data = call_ext(RUST_G, "byond:calculate_shadows_fast")(px, py, my_z, radius)

	var/list/used_keys_this_frame = list()

	if(quad_data && islist(quad_data))
		var/total_len = quad_data.len
		var/last_ax = -1
		var/last_ay = -1
		var/turf/cached_turf = null

		for(var/i = 1; i <= total_len; i += 9)
			var/key = quad_data[i + 8]
			used_keys_this_frame[key] = TRUE
			var/ax = quad_data[i]
			var/ay = quad_data[i + 1]

			if(ax != last_ax || ay != last_ay)
				cached_turf = locate(ax, ay, my_z)
				last_ax = ax
				last_ay = ay

			var/image/I = client.active_shadows[key]
			if(!I)
				I = client.alloc_shadow_image()
				if(!I)
					continue
				client.active_shadows[key] = I
				I.loc = cached_turf
			else if(I.loc != cached_turf)
				I.loc = cached_turf

			var/matrix/M = matrix(
				quad_data[i + 2], quad_data[i + 3], quad_data[i + 4],
				quad_data[i + 5], quad_data[i + 6], quad_data[i + 7]
			)

			if(I.transform != M)
				I.transform = M

	client.clear_unused_shadows(used_keys_this_frame)
	
	var/list/visible_ids = call_ext(RUST_G, "byond:get_visible_boxes")(px, py, my_z, radius)
	var/list/visible_map = list()
	if(islist(visible_ids))
		for(var/vid in visible_ids)
			visible_map["[round(vid)]"] = TRUE

	for(var/obj/O in GLOB.fov_cutout_objects)
		if(O.z != my_z || !O.cutout_atom)
			continue
			
		var/str_id = "[round(O.fov_box_id)]"
		
		if(visible_map[str_id])
			O.cutout_atom.alpha = 255
		else
			O.cutout_atom.alpha = 0

/client/proc/reset_shadow_pool()
	for(var/key in active_shadows)
		var/image/I = active_shadows[key]
		if(I)
			I.loc = null
			animate(I)
			I.transform = matrix()
			shadow_images_pool += I
	active_shadows.Cut()


/obj/effect/shadow_cutout
	name = "shadow cutout"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = SHADOW_CUTOUT_PLANE
	vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_ID

/obj
	var/fov_shadow_cutout = TRUE
	var/obj/effect/shadow_cutout/cutout_atom = null

/obj/proc/add_shadow_cutout()
	if(cutout_atom)
		vis_contents -= cutout_atom
		qdel(cutout_atom)
		cutout_atom = null

	var/obj/effect/shadow_cutout/C = new(null)
	
	C.icon = src.icon
	C.icon_state = src.icon_state
	C.dir = src.dir
	C.color = src.color
	C.transform = src.transform
	if(src.overlays.len)
		C.overlays = src.overlays.Copy()
	
	C.pixel_x = 0
	C.pixel_y = 0
	C.vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_ID
	
	C.plane = SHADOW_CUTOUT_PLANE
	C.layer = FLOAT_LAYER
	C.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	C.blend_mode = BLEND_DEFAULT
	C.alpha = 0 
	
	cutout_atom = C
	vis_contents += C
	GLOB.fov_cutout_objects |= src

/obj/proc/remove_shadow_cutout()
	if(cutout_atom)
		vis_contents -= cutout_atom
		qdel(cutout_atom)
		cutout_atom = null
	GLOB.fov_cutout_objects -= src


/obj/proc/on_fov_moved(datum/source, atom/OldLoc, Dir, Forced)
	SIGNAL_HANDLER
	if(!fov_shadow_box || !fov_box_id)
		return

	var/turf/old_turf = get_turf(OldLoc)
	var/turf/new_turf = get_turf(src)

	if(!old_turf || !new_turf || (old_turf == new_turf))
		return

	var/total_ticks = 1
	if(glide_size > 0)
		total_ticks = max(1, round(world.icon_size / glide_size))

	if(total_ticks <= 1 || Forced)
		register_fov_boxes(new_turf.x, new_turf.y)
		notify_shadows_map_changed(new_turf, custom_range = 7)
		return

	glide_shadow_by_pixels(old_turf, new_turf, total_ticks)

/obj/proc/glide_shadow_by_pixels(turf/old_turf, turf/new_turf, total_ticks)
	set waitfor = FALSE
	var/this_id = ++fov_glide_id
	var/sleep_delay = world.tick_lag

	for(var/i in 1 to total_ticks)
		if(this_id != fov_glide_id || QDELETED(src))
			return

		var/progress = i / total_ticks
		var/curr_x = old_turf.x + (new_turf.x - old_turf.x) * progress
		var/curr_y = old_turf.y + (new_turf.y - old_turf.y) * progress

		register_fov_boxes(curr_x, curr_y)
		notify_shadows_map_changed(new_turf, custom_range = 7)

		if(i < total_ticks)
			sleep(sleep_delay)
		
/obj/proc/glide_shadow_box(turf/old_turf, turf/new_turf, total_points)
	set waitfor = FALSE
	var/this_id = ++fov_glide_id
	var/sleep_delay = world.tick_lag

	for(var/i in 1 to total_points)
		if(this_id != fov_glide_id || QDELETED(src))
			return
		var/progress = i / total_points
		var/curr_x = old_turf.x + (new_turf.x - old_turf.x) * progress
		var/curr_y = old_turf.y + (new_turf.y - old_turf.y) * progress

		register_fov_boxes(curr_x, curr_y)
		notify_shadows_map_changed(new_turf)

		if(i < total_points)
			sleep(sleep_delay)

/obj/proc/register_fov_boxes(custom_wx = null, custom_wy = null)
	var/turf/T = get_turf(src)
	if(!T || !fov_shadow_box || !fov_box_id)
		return

	var/wx
	var/wy
	if(custom_wx != null && custom_wy != null)
		wx = custom_wx
		wy = custom_wy
	else
		var/total_px = (isnum(src.step_x) ? src.step_x : 0) + src.pixel_x
		var/total_py = (isnum(src.step_y) ? src.step_y : 0) + src.pixel_y
		wx = T.x + (total_px / 32.0)
		wy = T.y + (total_py / 32.0)

	var/wz = T.z

	if(isnum(fov_shadow_box[1]))
		call_ext(RUST_G, "byond:set_box_world")(fov_box_id, wz, wx, wy, fov_shadow_box[1], fov_shadow_box[2], fov_shadow_box[3], fov_shadow_box[4])
	else
		var/sub_id = 0
		for(var/list/B in fov_shadow_box)
			call_ext(RUST_G, "byond:set_box_world")(fov_box_id + (sub_id++ * 100000), wz, wx, wy, B[1], B[2], B[3], B[4])

/obj/proc/update_fov_shadow_pixel_shift()
	if(!fov_shadow_box || !fov_box_id)
		return
	register_fov_boxes()
	notify_shadows_map_changed(src, custom_range = 7)

/obj/proc/unregister_fov_boxes()
	if(!fov_box_id)
		return
	if(isnum(fov_shadow_box[1]))
		call_ext(RUST_G, "byond:remove_box_by_id")(fov_box_id)
	else
		var/sub_id = 0
		for(var/list/B in fov_shadow_box)
			call_ext(RUST_G, "byond:remove_box_by_id")(fov_box_id + (sub_id++ * 100000))

	notify_shadows_map_changed(src, custom_range = 7)

/client/proc/destroy_shadow_pool()
	for(var/key in active_shadows)
		var/image/I = active_shadows[key]
		if(I)
			images -= I
	
	for(var/image/I in shadow_images_pool)
		if(I)
			images -= I
			
	active_shadows.Cut()
	shadow_images_pool.Cut()
