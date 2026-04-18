// =============================================
// VOID WALK - Incorporeal invisible movement
// =============================================
/obj/effect/proc_holder/spell/self/shadekin_voidwalk
	name = "Void Walk"
	desc = "Step into the space between worlds. You become invisible and can pass through any obstacle. Drains energy while active. If energy runs out, you collapse into sleep."
	action_icon_state = "jaunt"
	action_icon = 'icons/mob/actions/actions.dmi'
	recharge_time = 5 SECONDS
	selection_type = "range"
	human_req = TRUE

	var/active = FALSE

/obj/effect/proc_holder/spell/self/shadekin_voidwalk/cast(list/targets, mob/living/user)
	if(!ishuman(user))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = user

	// Get the energy component for void walk state tracking
	var/datum/component/shadekin_energy/energy_comp = H.GetComponent(/datum/component/shadekin_energy)
	if(!energy_comp)
		to_chat(H, span_warning("I lack the shadow essence to draw upon."))
		revert_cast()
		return FALSE

	if(active)
		exit_voidwalk(H, energy_comp)
		return TRUE
	else
		return enter_voidwalk(H, energy_comp)

/obj/effect/proc_holder/spell/self/shadekin_voidwalk/proc/enter_voidwalk(mob/living/carbon/human/H, datum/component/shadekin_energy/energy_comp)
	if(!energy_comp.enter_void_walk(H))
		revert_cast()
		return FALSE

	// Check if in a container or being grabbed
	if(H.buckled || H.has_buckled_mobs())
		to_chat(H, span_warning("I cannot enter the void while restrained!"))
		energy_comp.exit_void_walk(H)
		revert_cast()
		return FALSE

	active = TRUE

	// Make invisible and incorporeal
	H.incorporeal_move = INCORPOREAL_MOVE_SHADOW
	animate(H, alpha = 0, time = 1 SECONDS, easing = EASE_IN)
	H.visible_message(span_warning("[H] dissolves into shadow, vanishing from sight!"), \
		span_notice("I step into the void between worlds. The shadows embrace me."))

	var/energy_pct = round((H.energy / max(H.max_energy, 1)) * 100)
	to_chat(H, span_boldnotice("Void Walk active. Energy: [energy_pct]%. Use this ability again to return."))

	return TRUE

/obj/effect/proc_holder/spell/self/shadekin_voidwalk/proc/exit_voidwalk(mob/living/carbon/human/H, datum/component/shadekin_energy/energy_comp)
	active = FALSE
	energy_comp.exit_void_walk(H)

	// Check if we're inside a dense turf or blocked by dense objects - if so, find a safe spot
	var/turf/T = get_turf(H)
	var/need_relocation = T.density
	if(!need_relocation)
		for(var/obj/O in T)
			if(O.density)
				need_relocation = TRUE
				break
	if(need_relocation)
		// Try to find an adjacent non-blocked turf
		var/relocated = FALSE
		for(var/dir in GLOB.cardinals)
			var/turf/adj = get_step(T, dir)
			if(adj && !adj.density)
				var/blocked = FALSE
				for(var/obj/O in adj)
					if(O.density)
						blocked = TRUE
						break
				if(!blocked)
					H.forceMove(adj)
					relocated = TRUE
					break
		if(!relocated)
			// Fallback - just force move to current turf anyway
			to_chat(H, span_warning("I materialize in a tight space!"))

	// Restore visibility and corporeality
	H.incorporeal_move = FALSE
	animate(H, alpha = 255, time = 1 SECONDS, easing = EASE_OUT)
	H.visible_message(span_warning("[H] materializes from the shadows!"), \
		span_notice("I return from the void. The mortal world solidifies around me."))

// =============================================
// SHADOW REST - Instant sleep to regen energy
// =============================================
/obj/effect/proc_holder/spell/self/shadekin_shadowrest
	name = "Shadow Rest"
	desc = "Embrace the shadows and fall into a deep sleep. Your energy regenerates much faster while sleeping in darkness. Use again to attempt to wake."
	action_icon_state = "heal"
	action_icon = 'icons/mob/actions/actions.dmi'
	recharge_time = 3 SECONDS
	selection_type = "range"
	human_req = TRUE

/obj/effect/proc_holder/spell/self/shadekin_shadowrest/cast(list/targets, mob/living/user)
	if(!ishuman(user))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = user
	var/datum/component/shadekin_energy/energy_comp = H.GetComponent(/datum/component/shadekin_energy)
	if(!energy_comp)
		to_chat(H, span_warning("I lack the shadow essence to draw upon."))
		revert_cast()
		return FALSE

	if(H.IsSleeping() || H.stat == UNCONSCIOUS)
		// Try to wake up - only works if not force-slept with depleted energy
		if(energy_comp.forced_sleep)
			to_chat(H, span_warning("The shadows hold me too tightly... I must wait until my energy recovers."))
			revert_cast()
			return FALSE
		H.SetSleeping(0)
		to_chat(H, span_notice("I stir from my shadow rest."))
		return TRUE

	// Fall asleep
	to_chat(H, span_notice("I embrace the shadows and drift into slumber... My energy will regenerate faster in darkness."))
	H.visible_message(span_warning("[H] curls up and falls into a deep sleep, shadows swirling around them."), \
		span_notice("The shadows wrap around me like a blanket as I drift off..."))
	H.Sleeping(600) // 60 seconds of sleep, can be woken by Shadow Rest again
	H.SetSleeping(600)
	var/energy_pct = round((H.energy / max(H.max_energy, 1)) * 100)
	to_chat(H, span_info("Energy: [energy_pct]%. Use Shadow Rest again to wake up."))
	return TRUE

// =============================================
// SHROUD OF DARKNESS - Create temporary dark cloud
// =============================================
/obj/effect/proc_holder/spell/self/shadekin_shroud
	name = "Shroud of Darkness"
	desc = "Call forth a cloud of pure shadow that engulfs the area in darkness. The shroud lasts for a short time and blocks vision for those without dark sight."
	action_icon_state = "yourlivingend"
	action_icon = 'icons/mob/actions/actions.dmi'
	recharge_time = 60 SECONDS
	selection_type = "range"
	human_req = TRUE

	/// Energy cost to create the shroud (fraction of max energy)
	var/energy_cost_fraction = 0.2
	/// Duration of the darkness cloud in deciseconds
	var/shroud_duration = 30 SECONDS
	/// Radius of the darkness effect
	var/shroud_radius = 3

/obj/effect/proc_holder/spell/self/shadekin_shroud/cast(list/targets, mob/living/user)
	if(!ishuman(user))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = user
	var/datum/component/shadekin_energy/energy_comp = H.GetComponent(/datum/component/shadekin_energy)
	if(!energy_comp)
		to_chat(H, span_warning("I lack the shadow essence to draw upon."))
		revert_cast()
		return FALSE

	var/energy_cost = round(H.max_energy * energy_cost_fraction)
	if(H.energy < energy_cost)
		to_chat(H, span_warning("Not enough energy! I need at least [energy_cost]. Current: [round(H.energy)]."))
		revert_cast()
		return FALSE

	// Spend energy from native bar
	H.energy_add(-energy_cost)
	if(H.energy <= 0)
		energy_comp.force_sleep(H)
		return TRUE

	// Create the darkness cloud
	var/turf/center = get_turf(H)
	H.visible_message(span_warning("Shadows erupt from [H], engulfing the area in darkness!"), \
		span_notice("I release the shadows within me, cloaking the area in darkness."))

	for(var/turf/T in range(shroud_radius, center))
		var/obj/effect/shadekin_darkness/dark = new(T)
		dark.duration = shroud_duration

	var/energy_pct = round((H.energy / max(H.max_energy, 1)) * 100)
	to_chat(H, span_info("Energy: [energy_pct]%"))
	return TRUE

/// Temporary darkness effect object that blocks light and vision
/obj/effect/shadekin_darkness
	name = "shroud of darkness"
	desc = "An impenetrable cloud of shadow."
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	anchored = TRUE
	opacity = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_MOB_LAYER
	color = "#1a0a2e"
	alpha = 200

	/// How long this darkness lasts in deciseconds
	var/duration = 30 SECONDS

/obj/effect/shadekin_darkness/Initialize(mapload)
	. = ..()
	// Fade in
	var/matrix/M = matrix()
	transform = M
	// Schedule removal
	QDEL_IN(src, duration)
	// Start fading out near the end
	addtimer(CALLBACK(src, PROC_REF(fade_out)), duration - 5 SECONDS)

/obj/effect/shadekin_darkness/proc/fade_out()
	animate(src, alpha = 0, time = 5 SECONDS)

/obj/effect/shadekin_darkness/Destroy()
	var/turf/T = get_turf(src)
	. = ..()
	if(T)
		T.recalc_atom_opacity()

// =============================================
// SNUFF LIGHTS - Shadekin innate version (non-miracle, no devotion cost)
// =============================================
/obj/effect/proc_holder/spell/self/zizo_snuff/shadekin
	name = "Snuff Lights"
	desc = "Channel the darkness within to extinguish all nearby light sources."
	miracle = FALSE
	devotion_cost = 0
	associated_skill = null
	invocations = list()
	invocation_type = "none"
	recharge_time = 30 SECONDS
	/// Energy cost as fraction of max_energy
	var/energy_cost_fraction = 0.1

/obj/effect/proc_holder/spell/self/zizo_snuff/shadekin/cast(list/targets, mob/user = usr)
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	// Spend native energy
	var/energy_cost = round(H.max_energy * energy_cost_fraction)
	if(H.energy < energy_cost)
		to_chat(H, span_warning("Not enough energy to snuff out the lights. I need at least [energy_cost]."))
		revert_cast()
		return FALSE
	H.energy_add(-energy_cost)
	var/checkrange = 10
	for(var/obj/O in range(checkrange, user))
		O.extinguish()
	for(var/mob/M in range(checkrange, user))
		for(var/obj/O in M.contents)
			O.extinguish()
	playsound(get_turf(user), 'sound/magic/zizo_snuff.ogg', 80, TRUE)
	H.visible_message(span_warning("The shadows around [H] surge outward, swallowing the light!"), \
		span_notice("I reach into the darkness within and snuff out the lights around me."))
	// Check for force sleep if energy depleted
	var/datum/component/shadekin_energy/energy_comp = H.GetComponent(/datum/component/shadekin_energy)
	if(energy_comp && H.energy <= 0)
		energy_comp.force_sleep(H)
	return TRUE
