
/obj/item/organ/eyes/night_vision/vampire
	lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
	var/datum/vampire_sight/vampire_sight
	var/redboost_gain = 1.5
	var/redboost_selectivity = 1.5
	var/list/sight_greyscale = VAMPIRE_SIGHT_GREYSCALE
	var/list/sight_redboost
	var/sight_anchor = VAMPIRE_SIGHT_ANCHOR

/obj/item/organ/eyes/night_vision/vampire/proc/sight_owns_planes()
	return vampire_sight?.active

/obj/item/organ/eyes/night_vision/vampire/proc/refresh_sight()
	vampire_sight?.rebuild_relays()

/obj/item/organ/eyes/night_vision/vampire/proc/redboost_matrix(gain_mult = 1)
	var/burn = redboost_gain * gain_mult
	return list(
		burn, 0, 0, 0,
		burn * -0.837 * redboost_selectivity, 0, 0, 0,
		burn * -0.163 * redboost_selectivity, 0, 0, 0,
		0, 0, 0, 1,
		0, 0, 0, 0,
	)

/obj/item/organ/eyes/night_vision/vampire/proc/current_redboost()
	return sight_redboost || redboost_matrix()

/obj/item/organ/eyes/night_vision/vampire/proc/apply_redboost()
	sight_redboost = redboost_matrix()
	refresh_sight()
	return sight_redboost

/obj/item/organ/eyes/night_vision/vampire/vv_edit_var(var_name, var_value)
	. = ..()
	if(!.)
		return
	switch(var_name)
		if(NAMEOF(src, redboost_gain), NAMEOF(src, redboost_selectivity))
			apply_redboost()
		if(NAMEOF(src, sight_redboost), NAMEOF(src, sight_greyscale), NAMEOF(src, sight_anchor))
			refresh_sight()

/obj/item/organ/eyes/night_vision/vampire/Destroy()
	QDEL_NULL(vampire_sight)
	return ..()

/obj/item/organ/eyes/night_vision/vampire/proc/sight_should_be_on()
	var/mob/living/wearer = owner
	if(!istype(wearer) || isnull(wearer.client))
		return FALSE
	if(HAS_TRAIT(wearer, TRAIT_IN_FRENZY))
		return TRUE
	return lighting_alpha != LIGHTING_PLANE_ALPHA_VISIBLE

/obj/item/organ/eyes/night_vision/vampire/proc/update_vampire_sight()
	if(sight_should_be_on())
		if(!vampire_sight)
			vampire_sight = new(src)
		vampire_sight.enable()
	else if(vampire_sight)
		vampire_sight.disable()

/mob/living/proc/update_vampire_sight()
	var/obj/item/organ/eyes/night_vision/vampire/eyes = getorganslot(ORGAN_SLOT_EYES)
	eyes?.update_vampire_sight()

GLOBAL_VAR_INIT(blood_sight_viewers, 0)

/mob/living/proc/can_be_blood_drunk()
	return FALSE

/mob/living/carbon/can_be_blood_drunk()
	if(stat == DEAD)
		return FALSE
	if(clan || mind?.has_antag_datum(/datum/antagonist/vampire))
		return FALSE
	if(dna?.species && (NOBLOOD in dna.species.species_traits))
		return FALSE
	return blood_volume > 0

/datum/component/blood_glow
	var/mutable_appearance/ma
	var/turf/watched_turf
	var/rebuild_scheduled = FALSE

/datum/component/blood_glow/Initialize()
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/blood_glow/RegisterWithParent()
	RegisterSignal(parent, COMSIG_LIVING_OVERLAYS_APPLIED, PROC_REF(on_overlays_changed))
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_state_changed))
	RegisterSignal(parent, COMSIG_LIVING_LIFE, PROC_REF(on_life))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	watch_turf(get_turf(parent))
	build(TRUE)

/datum/component/blood_glow/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_LIVING_OVERLAYS_APPLIED, COMSIG_LIVING_DEATH, COMSIG_LIVING_LIFE, COMSIG_MOVABLE_MOVED))
	watch_turf(null)

/datum/component/blood_glow/Destroy(force)
	var/atom/movable/carrier = parent
	if(ma && !QDELETED(carrier))
		carrier.cut_overlay(ma)
	ma = null
	return ..()

/datum/component/blood_glow/proc/watch_turf(turf/new_turf)
	if(watched_turf == new_turf)
		return
	if(watched_turf)
		UnregisterSignal(watched_turf, list(COMSIG_TURF_ENTERED, COMSIG_TURF_EXITED))
	watched_turf = new_turf
	if(watched_turf)
		RegisterSignal(watched_turf, list(COMSIG_TURF_ENTERED, COMSIG_TURF_EXITED), PROC_REF(on_turf_occupancy))

/datum/component/blood_glow/proc/is_vampire(atom/thing)
	if(!iscarbon(thing))
		return FALSE
	var/mob/living/carbon/carbon = thing
	return carbon.clan || carbon.mind?.has_antag_datum(/datum/antagonist/vampire)

/datum/component/blood_glow/proc/suppressed()
	var/turf/here = get_turf(parent)
	if(!here)
		return TRUE
	for(var/mob/living/living in here)
		if(is_vampire(living))
			return TRUE
	return FALSE

/datum/component/blood_glow/proc/on_overlays_changed(datum/source)
	SIGNAL_HANDLER
	if(rebuild_scheduled)
		return
	rebuild_scheduled = TRUE
	addtimer(CALLBACK(src, PROC_REF(do_rebuild)), 0)

/datum/component/blood_glow/proc/do_rebuild()
	rebuild_scheduled = FALSE
	build(TRUE)

/datum/component/blood_glow/proc/on_state_changed(datum/source)
	SIGNAL_HANDLER
	build(TRUE)

/datum/component/blood_glow/proc/on_life(datum/source)
	SIGNAL_HANDLER
	build(FALSE)

/datum/component/blood_glow/proc/on_moved(datum/source)
	SIGNAL_HANDLER
	watch_turf(get_turf(parent))
	build(FALSE)

/datum/component/blood_glow/proc/on_turf_occupancy(datum/source, atom/movable/thing)
	SIGNAL_HANDLER
	if(is_vampire(thing))
		build(FALSE)

/datum/component/blood_glow/proc/build(force)
	var/mob/living/carbon/carrier = parent
	if(QDELETED(carrier))
		return
	if(!carrier.can_be_blood_drunk() || suppressed())
		if(ma)
			carrier.cut_overlay(ma)
			ma = null
		return
	if(ma && !force)
		return
	if(ma)
		carrier.cut_overlay(ma)
		ma = null
	var/mutable_appearance/glow = new(carrier)
	// UI/effect overlays (typing bubble on FULLSCREEN_PLANE, KEEP_APART point bubbles/anims) don't flatten
	// into the glow and would leak red onto their own plane, so drop them from the copy
	var/list/leaky_overlays
	for(var/mutable_appearance/overlay as anything in glow.overlays)
		if((overlay.appearance_flags & KEEP_APART) || overlay.plane == FULLSCREEN_PLANE)
			LAZYADD(leaky_overlays, overlay)
	if(leaky_overlays)
		glow.overlays -= leaky_overlays
	glow.plane = BLOOD_GLOW_PLANE
	glow.transform = matrix()
	glow.pixel_x = 0
	glow.pixel_y = 0
	glow.pixel_z = 0
	glow.color = VAMPIRE_SIGHT_BODY_COLOR
	glow.blend_mode = BLEND_ADD
	glow.alpha = 255
	glow.appearance_flags = KEEP_TOGETHER | RESET_COLOR | RESET_ALPHA
	glow.filters = null
	ma = glow
	carrier.add_overlay(glow)

/atom/movable/vampire_sight_relay
	plane = GAME_PLANE_HIGHEST
	blend_mode = BLEND_DEFAULT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = PASS_MOUSE | NO_CLIENT_COLOR | KEEP_TOGETHER

/datum/vampire_sight
	var/obj/item/organ/eyes/night_vision/vampire/eyes
	var/mob/living/owner
	var/active = FALSE
	var/list/relays
	var/list/boost_relays
	var/beat_timer
	var/last_pt = 0
	var/last_peak = 0
	var/update_on_z_change = TRUE

/datum/vampire_sight/New(obj/item/organ/eyes/night_vision/vampire/_eyes)
	eyes = _eyes
	relays = list()
	boost_relays = list()

/datum/vampire_sight/Destroy()
	disable()
	eyes = null
	return ..()

/datum/vampire_sight/proc/blood_plane_master()
	return owner?.hud_used?.plane_masters?["[BLOOD_GLOW_PLANE]"]

/datum/vampire_sight/proc/pulse_blood_plane(pulse_time, peak)
	var/atom/movable/screen/plane_master/PM = blood_plane_master()
	if(!PM)
		return
	PM.alpha = 90
	animate(PM, alpha = peak, time = pulse_time, loop = -1, flags = ANIMATION_PARALLEL, easing = SINE_EASING)
	animate(alpha = 90, time = pulse_time)

/datum/vampire_sight/proc/refresh_pulse()
	if(!active || !owner)
		return
	last_pt = pulse_time_for(owner)
	last_peak = peak_for(owner)
	pulse_blood_plane(last_pt, last_peak)

/datum/vampire_sight/proc/enable()
	if(active)
		return
	owner = eyes?.owner
	if(!istype(owner))
		return
	active = TRUE
	GLOB.blood_sight_viewers++
	if(GLOB.blood_sight_viewers == 1)
		for(var/mob/living/carbon/body as anything in GLOB.carbon_list)
			body.AddComponent(/datum/component/blood_glow)
	refresh_planes()
	build_relays()
	last_pt = pulse_time_for(owner)
	last_peak = peak_for(owner)
	pulse_blood_plane(last_pt, last_peak)
	RegisterSignal(owner, COMSIG_HUMAN_LIFE, PROC_REF(on_owner_life))
	RegisterSignal(owner, COMSIG_MOB_LOGOUT, PROC_REF(on_owner_logout))
	RegisterSignal(owner, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(on_owner_z_change))

/datum/vampire_sight/proc/on_owner_z_change(datum/source, old_z, new_z)
	SIGNAL_HANDLER
	if(update_on_z_change)
		INVOKE_ASYNC(src, PROC_REF(reapply_planes))

/datum/vampire_sight/proc/reapply_planes()
	if(!active || QDELETED(owner) || isnull(owner.client))
		return
	refresh_planes()
	rebuild_relays()
	pulse_blood_plane(last_pt, last_peak)

/datum/vampire_sight/proc/on_owner_life(datum/source)
	SIGNAL_HANDLER
	var/pt = pulse_time_for(owner)
	var/peak = peak_for(owner)
	if(pt != last_pt || peak != last_peak)
		last_pt = pt
		last_peak = peak
		pulse_blood_plane(pt, peak)
	if(HAS_TRAIT(owner, TRAIT_IN_FRENZY))
		show_frenzy_tunnel()

/datum/vampire_sight/proc/on_owner_logout(datum/source)
	SIGNAL_HANDLER
	disable()

/datum/vampire_sight/proc/disable()
	if(!active)
		return
	active = FALSE
	stop_beat()
	clear_relays()
	GLOB.blood_sight_viewers = max(0, GLOB.blood_sight_viewers - 1)
	if(owner)
		owner.clear_fullscreen("frenzy")
		UnregisterSignal(owner, list(COMSIG_HUMAN_LIFE, COMSIG_MOB_LOGOUT, COMSIG_MOVABLE_Z_CHANGED))
		var/atom/movable/screen/plane_master/PM = blood_plane_master()
		if(PM)
			animate(PM)
			PM.alpha = 0
		refresh_planes()
	if(!GLOB.blood_sight_viewers)
		for(var/mob/living/carbon/body as anything in GLOB.carbon_list)
			qdel(body.GetComponent(/datum/component/blood_glow))
	owner = null

/mob/living/proc/refresh_world_planes()
	if(!hud_used)
		return
	for(var/planekey in GLOB.vampire_sight_capture_planes)
		var/atom/movable/screen/plane_master/PM = hud_used.plane_masters?[planekey]
		if(PM)
			PM.backdrop(src)

/datum/vampire_sight/proc/refresh_planes()
	owner?.refresh_world_planes()

/datum/vampire_sight/proc/build_relays()
	if(isnull(owner.client))
		return
	var/anchor = eyes.sight_anchor
	for(var/planekey in GLOB.vampire_sight_capture_planes)
		var/order = GLOB.vampire_sight_capture_planes[planekey]
		var/atom/movable/vampire_sight_relay/grey = new
		grey.screen_loc = anchor
		grey.render_source = VAMPIRE_SIGHT_TARGET(planekey)
		grey.layer = order * 0.1
		grey.color = eyes.sight_greyscale
		var/atom/movable/vampire_sight_relay/boost = new
		boost.screen_loc = anchor
		boost.render_source = VAMPIRE_SIGHT_TARGET(planekey)
		boost.layer = (order * 0.1) + 0.05
		boost.blend_mode = BLEND_ADD
		boost.color = eyes.current_redboost()
		owner.add_screen_object(grey) //Goes to our client and to any ghost watching us.
		owner.add_screen_object(boost)
		relays += grey
		relays += boost
		boost_relays += boost

/datum/vampire_sight/proc/rebuild_relays()
	if(!active)
		return
	clear_relays()
	build_relays()

/datum/vampire_sight/proc/clear_relays()
	if(owner)
		for(var/relay in relays)
			owner.remove_screen_object(relay)
	boost_relays = list()
	QDEL_LIST(relays)
	relays = list()

/datum/vampire_sight/proc/start_beat()
	stop_beat()
	pulse_beat()

/datum/vampire_sight/proc/stop_beat()
	if(beat_timer)
		deltimer(beat_timer)
		beat_timer = null

/datum/vampire_sight/proc/pulse_beat()
	beat_timer = null
	if(!active || QDELETED(owner) || isnull(owner.client) || !eyes || !HAS_TRAIT(owner, TRAIT_IN_FRENZY))
		return
	var/hunger = clamp((VITAE_LEVEL_HUNGRY - owner.get_bloodpool()) / VITAE_LEVEL_HUNGRY, 0, 1)
	var/beat = max(3, round(LERP(16, 6, hunger)))
	var/thump = max(1, round(beat * 0.25))
	var/list/surge = eyes.redboost_matrix(1.4)
	var/list/settled = eyes.current_redboost()
	for(var/atom/movable/vampire_sight_relay/boost as anything in boost_relays)
		animate(boost, color = surge, time = thump, flags = ANIMATION_PARALLEL, easing = SINE_EASING)
		animate(color = settled, time = beat - thump)
	beat_timer = addtimer(CALLBACK(src, PROC_REF(pulse_beat)), beat, TIMER_STOPPABLE)

/datum/vampire_sight/proc/feed_surge()
	if(!active || !eyes)
		return
	var/list/surge = eyes.redboost_matrix(2.6)
	var/list/settled = eyes.current_redboost()
	for(var/atom/movable/vampire_sight_relay/boost as anything in boost_relays)
		animate(boost, color = surge, time = 3, flags = ANIMATION_PARALLEL, easing = SINE_EASING)
		animate(color = settled, time = 10)

/datum/vampire_sight/proc/show_frenzy_tunnel()
	owner.overlay_fullscreen("frenzy", /atom/movable/screen/fullscreen/frenzy, 7)

/datum/vampire_sight/proc/pulse_time_for(mob/living/vamp)
	var/hunger = clamp(1 - (vamp.get_bloodpool() / max(1, vamp.get_maxbloodpool())), 0, 1)
	var/curve = hunger * hunger * hunger
	if(HAS_TRAIT(vamp, TRAIT_IN_FRENZY))
		curve = max(curve, 0.95)
	return max(3, round(LERP(24, 4, curve)))

/datum/vampire_sight/proc/peak_for(mob/living/vamp)
	return HAS_TRAIT(vamp, TRAIT_IN_FRENZY) ? VAMPIRE_SIGHT_PULSE_PEAK_FRENZY : VAMPIRE_SIGHT_PULSE_PEAK

/atom/movable/screen/fullscreen/frenzy
	icon_state = "passage"
	layer = CRIT_LAYER
	plane = FULLSCREEN_PLANE
	color = "#8a0000"

/mob/living/proc/beast_shake(strength = 1.5, shakes = 7)
	if(isnull(client) || !client.prefs?.shake)
		return
	var/client/screen_holder = client
	var/oldx = screen_holder.pixel_x
	var/oldy = screen_holder.pixel_y
	var/swing = strength * world.icon_size
	for(var/i in 1 to shakes)
		var/wrench = round(swing * (1 - ((i - 1) / shakes)))
		var/offset = oldx + ((i % 2) ? wrench : -wrench)
		if(i == 1)
			animate(screen_holder, pixel_x = offset, pixel_y = oldy, time = 1)
		else
			animate(pixel_x = offset, pixel_y = oldy, time = 1)
	animate(pixel_x = oldx, pixel_y = oldy, time = 1)

/mob/living/proc/beast_take_over()
	beast_shake()
	update_vampire_sight()
	var/obj/item/organ/eyes/night_vision/vampire/eyes = getorganslot(ORGAN_SLOT_EYES)
	if(!eyes)
		return
	eyes.vampire_sight?.show_frenzy_tunnel()
	eyes.vampire_sight?.refresh_pulse()
	eyes.vampire_sight?.start_beat()

/mob/living/proc/beast_release()
	var/obj/item/organ/eyes/night_vision/vampire/eyes = getorganslot(ORGAN_SLOT_EYES)
	eyes?.vampire_sight?.stop_beat()
	eyes?.vampire_sight?.refresh_pulse()
	clear_fullscreen("frenzy", 25)
	update_vampire_sight()

/mob/living/proc/beast_feed_pulse()
	var/atom/movable/screen/fullscreen/vignette = screens["frenzy"]
	if(vignette)
		animate(vignette, alpha = 60, time = 4, easing = SINE_EASING)
		animate(alpha = VAMPIRE_SIGHT_VIGNETTE_ALPHA, time = 9)
	var/obj/item/organ/eyes/night_vision/vampire/eyes = getorganslot(ORGAN_SLOT_EYES)
	eyes?.vampire_sight?.feed_surge()

/mob/living/proc/beast_world_shake(scale = 1.12, time = 2)
	if(isnull(client) || !hud_used)
		return
	if(!client.prefs?.shake)
		return
	for(var/planekey in GLOB.vampire_sight_capture_planes + list("[BLOOD_GLOW_PLANE]"))
		var/atom/movable/screen/plane_master/PM = hud_used.plane_masters?[planekey]
		if(!PM)
			continue
		animate(PM, transform = matrix() * scale, time = time, easing = SINE_EASING, flags = ANIMATION_PARALLEL)
		animate(transform = matrix(), time = time * 3, easing = SINE_EASING)

/mob/living/proc/beast_heartbeat_pulse()
	if(isnull(client))
		return
	playsound_local(src, 'sound/health/heartbeat.ogg', 100, FALSE)
	beast_world_shake()
