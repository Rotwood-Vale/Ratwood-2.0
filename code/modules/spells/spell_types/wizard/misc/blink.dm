/obj/effect/proc_holder/spell/invoked/blink
	name = "Blink"
	desc = "Teleport to a targeted location within your field of view. Limited to a range of 5 tiles. Only works on the same plane as the caster."
	school = "conjuration"
	cost = 3
	releasedrain = 30
	chargedrain = 1
	chargetime = 5
	recharge_time = 24 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	gesture_required = TRUE // Mobility spell
	spell_tier = 2
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "rune6"
	xp_gain = TRUE
	invocations = list("Nictare Teleporto!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	var/max_range = 5
	var/phase = /obj/effect/temp_visual/blink
	var/phase_sound = 'sound/magic/blink.ogg'
	var/phase_beam = "purple_lightning"

/obj/effect/temp_visual/blink
	icon = 'icons/effects/effects.dmi'
	icon_state = "hierophant_blast"
	name = "teleportation magic"
	desc = "Get out of the way!"
	randomdir = FALSE
	duration = 4 SECONDS
	layer = MASSIVE_OBJ_LAYER
	light_outer_range = 2
	light_color = COLOR_PALE_PURPLE_GRAY

/obj/effect/temp_visual/blink/Initialize(mapload, new_caster)
	. = ..()

/obj/effect/proc_holder/spell/invoked/blink/cast(list/targets, mob/user = usr)
	var/turf/T = get_turf(targets[1])
	var/turf/start = get_turf(user)

	var/error = arcyne_validate_blink_dest(T, user)
	if(!error && get_dist(start, T) > max_range)
		error = "That location is too far away! I can only blink up to [max_range] tiles."
	if(!error)
		error = arcyne_validate_blink_path(start, T)
	var/area/dest_area = get_area(T)
	var/area/start_area = get_area(start)
	if(!error && (dest_area.noteleport || start_area.noteleport))
		error = "This area won't let me teleport!"
	if(error)
		to_chat(user, span_warning(error))
		revert_cast()
		return

	user.visible_message(span_warning("<b>[user]'s body begins to shimmer with arcane energy as [user.p_they()] prepare[user.p_s()] to blink!</b>"),
						span_notice("<b>I focus my arcane energy, preparing to blink across space!</b>"))

	var/obj/spot_one = new phase(start, user.dir)
	var/obj/spot_two = new phase(T, user.dir)

	if(phase_beam)
		spot_one.Beam(spot_two, phase_beam, time = 1.5 SECONDS)
	playsound(start, phase_sound, 65, TRUE)
	playsound(T, phase_sound, 25, TRUE)

	if(user.buckled) // don't stay remote-buckled to the guillotine/pillory
		user.buckled.unbuckle_mob(user, TRUE)

	var/obj/effect/after_image/img = new(start, 0, 0, 0, 0, 0.5 SECONDS, 2 SECONDS, 0)
	img.name = user.name
	img.appearance = user.appearance
	img.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	img.alpha = 120
	animate(img, alpha = 0, time = 1.5 SECONDS, easing = LINEAR_EASING)
	QDEL_IN(img, 1.5 SECONDS)

	do_teleport(user, T, channel = TELEPORT_CHANNEL_MAGIC)

	user.visible_message(span_danger("<b>[user] vanishes in a mysterious purple flash!</b>"), span_notice("<b>I blink through space in an instant!</b>"))
	return TRUE

/proc/arcyne_validate_blink_path(turf/start, turf/dest)
	var/list/turf_list = getline(start, dest)
	if(length(turf_list) > 0)
		turf_list.len--
	for(var/turf/T in turf_list)
		if(T == start)
			continue
		if(T.density)
			return "I cannot teleport through walls!"
		for(var/obj/structure/mineral_door/door in T.contents)
			if(door.density)
				return "I cannot teleport through doors!"
		for(var/obj/structure/roguewindow/window in T.contents)
			if(window.density && !window.climbable)
				return "I cannot teleport through windows!"
		for(var/obj/structure/bars/B in T.contents)
			if(B.density)
				return "I cannot teleport through bars!"
		for(var/obj/structure/gate/G in T.contents)
			if(G.density)
				return "I cannot teleport through gates!"
	return null
