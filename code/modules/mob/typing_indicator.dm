#define LOOC_TYPING_COLOR "#6699cc"
#define EMOTE_TYPING_COLOR "#66cc66"

/// state = overlay/image/object/type/whatever add_overlay will accept
GLOBAL_LIST_EMPTY(typing_indicator_overlays)

/// Fetches the typing indicator we'll use from GLOB.typing_indicator_overlays
/mob/proc/get_indicator_overlay(state)
	. = GLOB.typing_indicator_overlays[state]
	if(.)
		return
	// doesn't exist, make it and cache it
	if(ispath(state))
		. = GLOB.typing_indicator_overlays[state] = state
	// We only support paths for now because anything else isn't necessary yet.


/// Gets the state we will use for typing indicators. Defaults to src.typing_indicator_state
/mob/proc/get_typing_indicator_icon_state()
	return typing_indicator_state

/// Generates the mutable appearance for typing indicator. Should prevent stuck overlays.
/mob/proc/generate_typing_indicator()
	var/state = get_typing_indicator_icon_state()
	if(ispath(state))
		var/atom/thing = new state(null)
		var/mutable_appearance/generated = new(thing)
		generated.plane = FULLSCREEN_PLANE
		qdel(thing)
		return generated
	else
		CRASH("Unsupported typing indicator state: [state]")

/**
 * Displays typing indicator.
 * @param timeout_override - Sets how long until this will disappear on its own without the user finishing their message or logging out. Defaults to src.typing_indicator_timeout
 * @param state_override - Sets the state that we will fetch. Defaults to src.get_typing_indicator_icon_state()
 * @param force - shows even if src.typing_indcator_enabled is FALSE.
 */
/mob/proc/display_typing_indicator(timeout_override = TYPING_INDICATOR_TIMEOUT, state_override = generate_typing_indicator(), force = FALSE)
	if(((!typing_indicator_enabled || (stat != CONSCIOUS)) && !force) || typing_indicator_current)
		return
	typing_indicator_current = state_override
	// panel context only, like its stop below. On disk it would bury the combat an admin is grepping for
	log_message("started typing", LOG_ATTACK, log_globally = FALSE)
	add_overlay(state_override)
	var/image/blind_indicator = image(loc = src)
	blind_indicator.appearance = state_override
	blind_indicator.plane = HUD_PLANE
	blind_indicator.appearance_flags |= KEEP_APART
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/blind_typing, "blind_typing", blind_indicator, NONE)
	update_vision_cone()
	typing_indicator_timerid = addtimer(CALLBACK(src, PROC_REF(clear_typing_indicator), "timed out"), timeout_override, TIMER_STOPPABLE)

/**
 * Removes typing indicator. reason, if given, is appended to the stopped typing log entry.
 */
/mob/proc/clear_typing_indicator(reason)
	remove_alt_appearance("blind_typing")
	if(typing_indicator_current)
		log_message("stopped typing[reason ? " ([reason])" : ""]", LOG_ATTACK, log_globally = FALSE)
	cut_overlay(typing_indicator_current)
	update_vision_cone()
	typing_indicator_current = null
	if(typing_indicator_timerid)
		deltimer(typing_indicator_timerid)
		typing_indicator_timerid = null

/// Default typing indicator
/obj/effect/overlay/typing_indicator
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	icon = 'icons/mob/typing_indicator.dmi'
	icon_state = "default0"
	appearance_flags = RESET_COLOR | TILE_BOUND | PIXEL_SCALE
	layer = HUD_LAYER
	plane = FULLSCREEN_PLANE
	alpha = 175

/// Only Blindness vice holders receive the copy above their fullscreen restriction.
/datum/atom_hud/alternate_appearance/basic/blind_typing/New(key, image/I, options = NONE)
	..()
	for(var/mob/viewer in GLOB.player_list)
		onNewMob(viewer)

/datum/atom_hud/alternate_appearance/basic/blind_typing/mobShouldSee(mob/viewer)
	if(!ishuman(viewer) || !HAS_TRAIT_FROM(viewer, TRAIT_BLIND_NITE_VISION, "[/datum/charflaw/noeyeall]"))
		return FALSE
	var/mob/living/carbon/human/human_viewer = viewer
	return human_viewer.stat < UNCONSCIOUS && !human_viewer.eyesclosed && !human_viewer.IsSleeping()

/datum/atom_hud/alternate_appearance/basic/blind_typing/onNewMob(mob/viewer)
	if(mobShouldSee(viewer))
		if(!hudusers[viewer])
			next_time_allowed[viewer] = 0
			add_hud_to(viewer)
		else
			add_to_single_hud(viewer, target)
	else if(hudusers[viewer])
		remove_hud_from(viewer)

/mob/proc/refresh_blind_typing_indicators()
	for(var/datum/atom_hud/alternate_appearance/basic/blind_typing/indicator in GLOB.active_alternate_appearances)
		indicator.onNewMob(src)

/// Reuse the current blue appearance instead of allocating one on each keystroke.
/mob/proc/display_looc_typing_indicator()
	if(typing_indicator_current?.color == LOOC_TYPING_COLOR)
		return typing_indicator_current
	clear_typing_indicator("LOOC input")
	var/mutable_appearance/indicator = generate_typing_indicator()
	indicator.color = LOOC_TYPING_COLOR
	display_typing_indicator(state_override = indicator)
	return typing_indicator_current

/mob/proc/clear_looc_typing_indicator(reason)
	if(typing_indicator_current?.color == LOOC_TYPING_COLOR)
		clear_typing_indicator(reason)

/// Only replace the appearance when changing channels; keep the existing timeout otherwise.
/mob/proc/display_emote_typing_indicator()
	if(typing_indicator_current?.color == EMOTE_TYPING_COLOR)
		return typing_indicator_current
	clear_typing_indicator("emote input")
	var/mutable_appearance/indicator = generate_typing_indicator()
	indicator.color = EMOTE_TYPING_COLOR
	display_typing_indicator(state_override = indicator)
	return typing_indicator_current

/mob/proc/clear_emote_typing_indicator(reason)
	if(typing_indicator_current?.color == EMOTE_TYPING_COLOR)
		clear_typing_indicator(reason)

#undef EMOTE_TYPING_COLOR
#undef LOOC_TYPING_COLOR
