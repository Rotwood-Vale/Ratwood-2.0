/**
 * Switches mode, silencing what the old one had playing and starting what the new one needs.
 *
 * The index keeps updating in every mode, so switching back is immediate.
 *
 * Arguments:
 * * new_mode - POINT_AMBIENCE_LIVE, POINT_AMBIENCE_FALLBACK or POINT_AMBIENCE_OFF
 */
/datum/controller/subsystem/point_ambience/proc/set_mode(new_mode)
	if(new_mode == mode)
		return
	clear_tile_cache()
	var/old_mode = mode
	mode = new_mode
	if(old_mode == POINT_AMBIENCE_LIVE)
		finish_fades()
		for(var/client/listener_client as anything in GLOB.clients)
			stop_all_for(listener_client)
		dirty_clients.Cut()
	if(old_mode == POINT_AMBIENCE_FALLBACK)
		for(var/atom/source as anything in fallback_loops)
			qdel(fallback_loops[source])
		fallback_loops = list()
	if(mode == POINT_AMBIENCE_FALLBACK)
		for(var/atom/source as anything in source_categories)
			start_fallback(source)

/// The plain loop a source runs in fallback mode, configured from its category so it sounds as
/// the live path would. Cannot native-repeat without a token, so it replays every file length
/datum/looping_sound/point_ambience_fallback

/// Gives one source its fallback loop, if its category takes one and it has none already
/datum/controller/subsystem/point_ambience/proc/start_fallback(atom/source)
	PRIVATE_PROC(TRUE)
	var/datum/point_ambience_category/category = source_categories[source]
	if(!category?.fallback || fallback_loops[source])
		return
	// A category with a set of clips gets one of them. The plain loop cannot advance through a set
	var/sound_file = category.source_sounds[source] || (category.files ? pick(category.files) : category.sound_file)
	var/datum/looping_sound/point_ambience_fallback/loop = new(source)
	loop.mid_sounds = sound_file
	loop.volume = category.volume * (category.source_volumes[source] || 1)
	loop.vary = category.vary_pitch
	// playsound's reach is SOUND_RANGE + extra_range
	loop.extra_range = category.range - SOUND_RANGE
	loop.mid_length = SSsounds.get_sound_length(sound_file) || 35
	fallback_loops[source] = loop
	loop.start()

/// Ends and forgets one source's fallback loop
/datum/controller/subsystem/point_ambience/proc/stop_fallback(atom/source)
	PRIVATE_PROC(TRUE)
	var/datum/looping_sound/loop = fallback_loops[source]
	if(!loop)
		return
	fallback_loops -= source
	qdel(loop)

/**
 * Flips every knob the curve work touched, so hearing the before and after is one prompt rather
 * than four. The original is the band power curve with no cutoff. The floors are the same either
 * way, being what they always were
 */
/datum/controller/subsystem/point_ambience/proc/set_original_sound(original)
	original_sound = original
	falloff_hardness = original ? 0 : initial(falloff_hardness)
	for(var/datum/point_ambience_category/category as anything in categories)
		category.falloff_hardness = original ? 0 : initial(category.falloff_hardness)
		category.resolve_derived()
	// Last, since it also drops every listener's answer and re-classes them under the cutoff
	set_send_cutoff(original ? 0 : initial(send_cutoff))

/**
 * Sets the volume under which a send is refused, for everyone. Every listener's cached answer was
 * priced under the old cutoff, so all are dropped, and each listener is re-classed, since a slider
 * the new cutoff cannot clear at distance 0 mutes them and one it can clear unmutes them
 */
/datum/controller/subsystem/point_ambience/proc/set_send_cutoff(value)
	send_cutoff = clamp(value, 0, 100)
	invalidate_listener_cache()
	for(var/client/listener_client as anything in GLOB.clients)
		listener_prefs_changed(listener_client)

/**
 * Sets the hard decay exponent on every category whose curve is not pinned, null restoring each
 * category's own default. Written into the categories rather than read through the subsystem per
 * send, so the curve costs a plain var read. Takes effect on the next send to each listener
 */
/datum/controller/subsystem/point_ambience/proc/set_falloff_hardness(value)
	falloff_hardness = value
	for(var/datum/point_ambience_category/category as anything in categories)
		if(category.hardness_pinned)
			continue
		category.falloff_hardness = isnull(value) ? initial(category.falloff_hardness) : value
		category.resolve_derived()
	invalidate_listener_cache()
