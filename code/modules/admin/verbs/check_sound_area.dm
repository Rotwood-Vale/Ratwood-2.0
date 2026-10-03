/**
 * Prints the area facts that decide how sound leaves where you are standing.
 *
 * The soundproof line reads the area at runtime, the test playsound() makes for ERP audio, rather
 * than the area's definition, so a converted area or a var edited after mapload shows its real value.
 */
/client/proc/check_sound_area()
	set category = "Debug"
	set name = "Check Sound Area"
	if(!check_rights(R_DEBUG))
		return
	// The ear, not the body: a headless dullahan's sound is decided where the head is
	var/turf/here = get_turf(point_ambience_ear || mob)
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

	var/river_mark = SSpoint_ambience.river_fill_marks[here]
	var/fill_state = "unmarked, no river reach"
	if(!isnull(river_mark))
		fill_state = RIVER_FILL_AUDIBLE(river_mark) ? "reachable, [RIVER_FILL_COST(river_mark) * 0.5] tiles by path" : "blocked, silent"
	msg += "river fill: [SSpoint_ambience.river_fill_done ? fill_state : "pending initial fill"] | area river_ambience [A.river_ambience ? "TRUE" : "FALSE"]"

	// What point ambience is sending you, one voice per category. The volume is the last one sent
	// rather than one recomputed for the readout, so it is what your client plays now
	var/list/playing = list()
	for(var/datum/point_ambience_category/category as anything in SSpoint_ambience.categories)
		var/atom/source = point_ambience_sources[category]
		if(!source)
			continue
		var/list/slot = (length(point_ambience_slots) >= category.index) ? point_ambience_slots[category.index] : null
		var/vol = slot ? slot[POINT_AMBIENCE_SLOT_LAST_VOLUME] : null
		var/turf/source_turf = SSpoint_ambience.source_turfs[source] || get_turf(source)
		var/where = "position unknown"
		if(category == SSpoint_ambience.river_category)
			where = "fill: [fill_state]"
		else if(source_turf)
			var/dx = source_turf.x - here.x
			var/dy = source_turf.y - here.y
			var/distsq = dx * dx + dy * dy
			where = "[round(sqrt(distsq), 0.1)] tiles"
			// Nothing should ever be playing from outside its own range, so say so loudly here
			// rather than leaving it to be read off the distance
			if(distsq > category.range_sq)
				where += ", PAST its range of [category.range], which is a BUG"
			if(source_turf.z != here.z)
				where += ", [abs(source_turf.z - here.z)] floor away"
			// A muffled send also carries a dead-room environment and the occlusion low-pass, so two
			// sources reading the same volume are not equally audible
			switch(SSpoint_ambience.source_occluded(source_turf, here, category))
				if(OCCLUSION_MUFFLED)
					where += ", <b>MUFFLED</b> (dead room + occlusion low-pass, not just quieter)"
				if(OCCLUSION_SOLID)
					where += ", occlusion says SOLID while it is playing, which is a BUG"
		playing += "&nbsp;&nbsp;[category.config_name]: <b>[isnull(vol) ? "unknown" : round(vol, 0.1)]</b>/100, [where]"
	msg += "point ambience on your channels: [length(playing) ? "" : "<b>nothing</b>"]"
	msg += playing

	to_chat(usr, jointext(msg, "<br>"))
