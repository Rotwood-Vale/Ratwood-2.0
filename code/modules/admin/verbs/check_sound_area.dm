/**
 * Reports the current area's sound settings and the listener's active point ambience.
 *
 * Reads runtime area values, including soundproofing changed after map initialization.
 */
/client/proc/check_sound_area()
	set category = "Debug"
	set name = "Check Sound Area"
	if(!check_rights(R_DEBUG))
		return
	// The ear, not the body: a headless dullahan's sound is decided where the head is
	var/turf/here = get_turf(point_ambience.ear || mob)
	if(!here)
		to_chat(usr, span_warning("You are not standing anywhere."))
		return
	var/area/A = get_area(here)
	if(!A)
		to_chat(usr, span_warning("No area here at all."))
		return

	var/list/msg = list("<b>[A.name]</b>  <span class='notice'>[A.type]</span>")
	msg += "soundproof: <b>[A.soundproof ? "TRUE, speech is line of sight only and ERP audio stays in the room here" : "FALSE, sound leaves normally"]</b>"
	msg += "soundenv: [A.soundenv][A.soundenv ? "" : " (unset, so positional sounds get SOUND_DEFAULT_ENVIRONMENT [SOUND_DEFAULT_ENVIRONMENT])"]"
	msg += "turf ([here.x],[here.y],[here.z]) | converted_type [A.converted_type || "none"]"

	var/turf/above = GET_TURF_ABOVE(here)
	var/turf/below = GET_TURF_BELOW(here)
	for(var/turf/T in list(above, below))
		var/area/other = get_area(T)
		msg += "[T == above ? "above" : "below"]: [other ? "[other.name], soundproof [other.soundproof]" : "nothing"]"

	var/river_mark = SSpoint_ambience.river_fill.marks[here]
	var/fill_state = "unmarked, no river reach"
	if(!isnull(river_mark))
		fill_state = RIVER_FILL_AUDIBLE(river_mark) ? "reachable, [RIVER_FILL_COST(river_mark) * 0.5] tiles by path" : "blocked, silent"
	msg += "river fill: [SSpoint_ambience.river_fill.done ? fill_state : "pending initial fill"] | area river_ambience [A.river_ambience ? "TRUE" : "FALSE"]"

	// Report the last sent volume rather than recomputing playback for the diagnostic
	var/list/playing = list()
	for(var/datum/point_ambience_category/category as anything in SSpoint_ambience.categories)
		var/atom/source = point_ambience.sources[category]
		if(!source)
			continue
		var/datum/point_ambience_slot/slot = LAZYACCESS(point_ambience.slots, category.index)
		var/vol = slot ? slot.last_volume : null
		var/turf/source_turf = SSpoint_ambience.source_turfs[source] || get_turf(source)
		var/where = "position unknown"
		if(category == SSpoint_ambience.river_category)
			where = "fill: [fill_state]"
		else if(source_turf)
			var/dx = source_turf.x - here.x
			var/dy = source_turf.y - here.y
			var/distsq = dx * dx + dy * dy
			where = "[round(sqrt(distsq), 0.1)] tiles"
			if(distsq > category.range_sq)
				where += ", PAST its range of [category.range], which is a BUG"
			if(source_turf.z != here.z)
				where += ", [abs(source_turf.z - here.z)] floor away"
			// Muffling also changes filtering and environment, so equal volumes can sound
			// different
			switch(SSpoint_ambience.source_occluded(source_turf, here, category))
				if(OCCLUSION_MUFFLED)
					where += ", <b>MUFFLED</b> (dead room + occlusion low-pass, not just quieter)"
				if(OCCLUSION_SOLID)
					where += ", occlusion says SOLID while it is playing, which is a BUG"
		playing += "&nbsp;&nbsp;[category.config_name]: <b>[isnull(vol) ? "unknown" : round(vol, 0.1)]</b>/100, [where]"
	msg += "point ambience on your channels: [length(playing) ? "" : "<b>nothing</b>"]"
	msg += playing

	to_chat(usr, jointext(msg, "<br>"))
