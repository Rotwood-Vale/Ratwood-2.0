
/obj/item/organ/eyes/night_vision/vampire
	lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
	var/datum/vampire_sight/vampire_sight
	var/redboost_gain = 1.5
	var/redboost_selectivity = 1.5
	var/list/sight_greyscale = VAMPIRE_SIGHT_GREYSCALE
	var/list/sight_redboost
	var/sight_anchor = VAMPIRE_SIGHT_ANCHOR
	var/edge_drain = 0

/obj/item/organ/eyes/night_vision/vampire/proc/drain_matrix()
	var/kept = 1 - edge_drain
	return list(
		0.299 + (0.701 * kept), 0.299 - (0.299 * kept), 0.299 - (0.299 * kept), 0,
		0.587 - (0.587 * kept), 0.587 + (0.413 * kept), 0.587 - (0.587 * kept), 0,
		0.114 - (0.114 * kept), 0.114 - (0.114 * kept), 0.114 + (0.886 * kept), 0,
		0, 0, 0, 1,
		0, 0, 0, 0,
	)

/obj/item/organ/eyes/night_vision/vampire/proc/sight_owns_planes()
	return vampire_sight?.active

/obj/item/organ/eyes/night_vision/vampire/proc/set_edge_drain(amount)
	amount = round(clamp(amount, 0, 1), 0.1)
	if(amount == edge_drain)
		return
	edge_drain = amount
	var/mob/living/wearer = owner
	if(istype(wearer))
		wearer.refresh_world_planes()

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

/datum/atom_hud/vampire_blood
	hud_icons = list(VAMPIRE_BLOOD_HUD)

GLOBAL_DATUM_INIT(vampire_blood_hud, /datum/atom_hud/vampire_blood, new)

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

/image/vampire_blood_glow
	var/pulsing = FALSE
	var/pulse_time = 0
	var/peak = 0
	var/last_dir = 0
	var/last_pulled = FALSE
	var/last_appearance

/mob/living/carbon/proc/refresh_blood_glow(pulse_time = VAMPIRE_SIGHT_PULSE_TIME, peak = VAMPIRE_SIGHT_PULSE_PEAK)
	var/image/vampire_blood_glow/glow = hud_list?[VAMPIRE_BLOOD_HUD]
	if(!istype(glow))
		return
	if(!length(GLOB.vampire_blood_hud?.hudusers) || !can_be_blood_drunk())
		if(glow.pulsing)
			glow.pulsing = FALSE
			animate(glow, alpha = 0, time = 2)
		return
	var/pulled = (pulledby != null)
	if(glow.pulsing && pulse_time == glow.pulse_time && peak == glow.peak && dir == glow.last_dir && pulled == glow.last_pulled && appearance == glow.last_appearance)
		return
	glow.last_dir = dir
	glow.last_pulled = pulled
	glow.last_appearance = appearance
	glow.pulse_time = pulse_time
	glow.peak = peak
	glow.appearance = appearance
	glow.override = FALSE
	glow.dir = dir
	glow.transform = pulled ? transform : matrix()
	glow.pixel_x = 0
	glow.pixel_y = 0
	glow.pixel_z = 0
	glow.layer = ABOVE_MOB_LAYER
	glow.color = VAMPIRE_SIGHT_BODY_COLOR
	glow.blend_mode = BLEND_ADD
	glow.appearance_flags = KEEP_TOGETHER | RESET_COLOR | RESET_ALPHA | NO_CLIENT_COLOR
	glow.filters = list(filter(type = "blur", size = 1), filter(type = "drop_shadow", x = 0, y = 0, size = VAMPIRE_SIGHT_GLOW_SIZE, color = VAMPIRE_SIGHT_GLOW_COLOR))
	glow.pulsing = TRUE
	glow.alpha = 90
	animate(glow, alpha = peak, time = pulse_time, loop = -1, flags = ANIMATION_PARALLEL, easing = SINE_EASING)
	animate(alpha = 90, time = pulse_time)

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
	var/tunnel_severity = 0
	var/beat_timer

/datum/vampire_sight/New(obj/item/organ/eyes/night_vision/vampire/_eyes)
	eyes = _eyes
	relays = list()
	boost_relays = list()

/datum/vampire_sight/Destroy()
	disable()
	eyes = null
	return ..()

/datum/vampire_sight/proc/enable()
	if(active)
		return
	owner = eyes?.owner
	if(!istype(owner))
		return
	active = TRUE
	refresh_planes()
	build_relays()
	GLOB.vampire_blood_hud.add_hud_to(owner)
	GLOB.vampire_blood_hud.hide_single_atomhud_from(owner, owner)
	var/pt = pulse_time_for(owner)
	var/peak = peak_for(owner)
	for(var/mob/living/carbon/body in view(owner))
		body.refresh_blood_glow(pt, peak)
	START_PROCESSING(SSfastprocess, src)

/datum/vampire_sight/proc/disable()
	if(!active)
		return
	active = FALSE
	tunnel_severity = 0
	stop_beat()
	STOP_PROCESSING(SSfastprocess, src)
	clear_relays()
	if(owner)
		GLOB.vampire_blood_hud.remove_hud_from(owner)
		GLOB.vampire_blood_hud.unhide_single_atomhud_from(owner, owner)
		refresh_planes()
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
		owner.client.screen += grey
		owner.client.screen += boost
		relays += grey
		relays += boost
		boost_relays += boost

/datum/vampire_sight/proc/rebuild_relays()
	if(!active)
		return
	clear_relays()
	build_relays()

/datum/vampire_sight/proc/clear_relays()
	if(owner?.client)
		for(var/relay in relays)
			owner.client.screen -= relay
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
	var/hunger = clamp((VITAE_LEVEL_HUNGRY - owner.bloodpool) / VITAE_LEVEL_HUNGRY, 0, 1)
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

/datum/vampire_sight/proc/update_prey_lock()
	var/severity = owner.frenzy_target ? 9 : 7
	if(severity == tunnel_severity)
		return
	tunnel_severity = severity
	owner.overlay_fullscreen("frenzy", /atom/movable/screen/fullscreen/frenzy, severity)

/datum/vampire_sight/proc/pulse_time_for(mob/living/vamp)
	var/hunger = clamp(1 - (vamp.bloodpool / max(1, vamp.maxbloodpool)), 0, 1)
	var/curve = hunger * hunger * hunger
	if(HAS_TRAIT(vamp, TRAIT_IN_FRENZY))
		curve = max(curve, 0.95)
	return max(3, round(LERP(24, 4, curve)))

/datum/vampire_sight/proc/peak_for(mob/living/vamp)
	return HAS_TRAIT(vamp, TRAIT_IN_FRENZY) ? VAMPIRE_SIGHT_PULSE_PEAK_FRENZY : VAMPIRE_SIGHT_PULSE_PEAK

/datum/vampire_sight/process()
	if(QDELETED(owner) || !active)
		return PROCESS_KILL
	if(isnull(owner.client))
		disable()
		return
	var/pt = pulse_time_for(owner)
	var/peak = peak_for(owner)
	for(var/mob/living/carbon/body in view(owner))
		body.refresh_blood_glow(pt, peak)
	if(HAS_TRAIT(owner, TRAIT_IN_FRENZY))
		update_prey_lock()

/atom/movable/screen/fullscreen/frenzy
	icon_state = "passage"
	layer = CRIT_LAYER
	plane = FULLSCREEN_PLANE
	color = "#8a0000"
	alpha = 0

/atom/movable/screen/fullscreen/frenzy/New()
	. = ..()
	animate(src, alpha = VAMPIRE_SIGHT_VIGNETTE_ALPHA, time = 6, easing = SINE_EASING)

/atom/movable/screen/fullscreen/frenzy/update_for_view(client_view)
	. = ..()
	transform = transform.Scale(1.4)

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
	eyes.set_edge_drain(0)
	eyes.vampire_sight?.update_prey_lock()
	eyes.vampire_sight?.start_beat()

/mob/living/proc/beast_release()
	var/obj/item/organ/eyes/night_vision/vampire/eyes = getorganslot(ORGAN_SLOT_EYES)
	eyes?.vampire_sight?.stop_beat()
	clear_fullscreen("frenzy", 25)
	update_vampire_sight()

/mob/living/proc/beast_feed_pulse()
	var/atom/movable/screen/fullscreen/vignette = screens["frenzy"]
	if(vignette)
		animate(vignette, alpha = 60, time = 4, easing = SINE_EASING)
		animate(alpha = VAMPIRE_SIGHT_VIGNETTE_ALPHA, time = 9)
	var/obj/item/organ/eyes/night_vision/vampire/eyes = getorganslot(ORGAN_SLOT_EYES)
	eyes?.vampire_sight?.feed_surge()

/mob/living/proc/beast_world_swell(scale = 1.12, time = 2)
	if(isnull(client) || !hud_used)
		return
	for(var/planekey in GLOB.vampire_sight_capture_planes)
		var/atom/movable/screen/plane_master/PM = hud_used.plane_masters?[planekey]
		if(!PM)
			continue
		animate(PM, transform = matrix() * scale, time = time, easing = SINE_EASING, flags = ANIMATION_PARALLEL)
		animate(transform = matrix(), time = time * 3, easing = SINE_EASING)

/mob/living/proc/beast_heartbeat_pulse()
	if(isnull(client))
		return
	playsound_local(src, 'sound/health/heartbeat.ogg', 100, FALSE)
	beast_world_swell()

/mob/living/proc/beast_edge_update()
	var/obj/item/organ/eyes/night_vision/vampire/eyes = getorganslot(ORGAN_SLOT_EYES)
	if(!eyes)
		return
	if(HAS_TRAIT(src, TRAIT_IN_FRENZY) || eyes.sight_owns_planes() || isnull(client))
		eyes.set_edge_drain(0)
		return
	var/hunger = clamp((VITAE_LEVEL_HUNGRY - bloodpool) / VITAE_LEVEL_HUNGRY, 0, 1)
	var/tension = clamp((frenzy_hardness - 3) / 7, 0, 1)
	eyes.set_edge_drain(max(hunger, tension))
