/datum/lighting_object
	var/mutable_appearance/current_underlay

	var/needs_update = FALSE

	var/turf/affected_turf

/proc/create_lighting_underlay()
	var/mutable_appearance/underlay = new()
	underlay.icon = LIGHTING_ICON
	underlay.icon_state = "transparent"
	underlay.plane = LIGHTING_PLANE
	underlay.layer = LIGHTING_LAYER
	underlay.invisibility = INVISIBILITY_LIGHTING
	underlay.appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	return underlay

/datum/lighting_object/New(turf/source)
	if(!isturf(source))
		qdel(src, force = TRUE)
		stack_trace("a lighting object was assigned to [source], a non turf!")
		return

	. = ..()

	current_underlay = create_lighting_underlay()

	affected_turf = source
	if(affected_turf.lighting_object)
		qdel(affected_turf.lighting_object, force = TRUE)
		stack_trace("a lighting object was assigned to a turf that already had a lighting object!")

	affected_turf.lighting_object = src
	affected_turf.luminosity = 1

	needs_update = TRUE
	SSlighting.objects_queue += src

/datum/lighting_object/Destroy(force)
	if(!force)
		return QDEL_HINT_LETMELIVE

	SSlighting.objects_queue -= src
	if(isturf(affected_turf))
		affected_turf.lighting_object = null
		affected_turf.luminosity = 1
		affected_turf.underlays -= current_underlay
	affected_turf = null

	return ..()

/datum/lighting_object/proc/update()
	// To the future coder who sees this and thinks
	// "Why didn't he just use a loop?"
	// Well my man, it's because the loop performed like shit.
	// And there's no way to improve it because
	// without a loop you can make the list all at once which is the fastest you're gonna get.
	// Oh it's also shorter line wise.
	// Including with these comments.

	// See LIGHTING_CORNER_DIAGONAL in lighting_corner.dm for why these values are what they are.
	var/static/datum/lighting_corner/dummy/dummy_lighting_corner = new

	var/turf/affected_turf = src.affected_turf

	var/list/corners = affected_turf.corners
	var/datum/lighting_corner/cr = dummy_lighting_corner
	var/datum/lighting_corner/cg = dummy_lighting_corner
	var/datum/lighting_corner/cb = dummy_lighting_corner
	var/datum/lighting_corner/ca = dummy_lighting_corner
	if (corners) //done this way for speed
		cr = corners[3] || dummy_lighting_corner
		cg = corners[2] || dummy_lighting_corner
		cb = corners[4] || dummy_lighting_corner
		ca = corners[1] || dummy_lighting_corner

	var/max = max(cr.cache_mx, cg.cache_mx, cb.cache_mx, ca.cache_mx)

	var/rr = cr.cache_r
	var/rg = cr.cache_g
	var/rb = cr.cache_b

	var/gr = cg.cache_r
	var/gg = cg.cache_g
	var/gb = cg.cache_b

	var/br = cb.cache_r
	var/bg = cb.cache_g
	var/bb = cb.cache_b

	var/ar = ca.cache_r
	var/ag = ca.cache_g
	var/ab = ca.cache_b

	#if LIGHTING_SOFT_THRESHOLD != 0
	var/set_luminosity = max > LIGHTING_SOFT_THRESHOLD
	#else
	// Because of floating points™?, it won't even be a flat 0.
	// This number is mostly arbitrary.
	var/set_luminosity = max > 1e-6
	#endif

	if(affected_turf.outdoor_effect?.sunlight_overlay?.luminosity)
		set_luminosity = max(set_luminosity, affected_turf.outdoor_effect.sunlight_overlay.luminosity)

	var/mutable_appearance/current_underlay = src.current_underlay
	affected_turf.underlays -= current_underlay

	if((rr & gr & br & ar) && (rg + gg + bg + ag + rb + gb + bb + ab == 8))
	//anything that passes the first case is very likely to pass the second, and addition is a little faster in this case
		current_underlay.icon_state = "transparent"
		current_underlay.color = null
	else if(!set_luminosity)
		current_underlay.icon_state = "dark"
		current_underlay.color = null
	else
		current_underlay.icon_state = null
		current_underlay.color = list(
			rr, rg, rb, 00,
			gr, gg, gb, 00,
			br, bg, bb, 00,
			ar, ag, ab, 00,
			00, 00, 00, 01
		)

	affected_turf.underlays += current_underlay
	affected_turf.luminosity = set_luminosity
