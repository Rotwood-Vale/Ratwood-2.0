/// Prints the area facts that decide how sound leaves where you are standing.
///
/// The soundproof line is the exact expression playsound_erp branches on, read at runtime rather
/// than from the area's definition, so a converted area or a var edited after mapload shows its
/// real value here.
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
	msg += "soundproof: <b>[A.soundproof ? "TRUE, ERP audio and speech are line of sight only here" : "FALSE, sound leaves normally"]</b>"
	msg += "soundenv: [A.soundenv][A.soundenv ? "" : " (unset, so positional sounds get SOUND_DEFAULT_ENVIRONMENT [SOUND_DEFAULT_ENVIRONMENT])"]"
	msg += "turf ([here.x],[here.y],[here.z]) | converted_type [A.converted_type || "none"]"

	var/turf/above = GET_TURF_ABOVE(here)
	var/turf/below = GET_TURF_BELOW(here)
	for(var/turf/T in list(above, below))
		var/area/other = get_area(T)
		msg += "[T == above ? "above" : "below"]: [other ? "[other.name], soundproof [other.soundproof]" : "nothing"]"

	// What point ambience is actually sending YOU here, which nothing above covers. A category is one
	// voice, so this list is the whole of it. The volume is the last one sent rather than one
	// recomputed for the readout, so it is what your client is playing right now.
	var/list/playing = list()
	for(var/datum/point_ambience_category/category as anything in SSpoint_ambience.categories)
		var/atom/source = point_ambience_sources[category]
		if(!source)
			continue
		var/list/slot = (length(point_ambience_slots) >= category.index) ? point_ambience_slots[category.index] : null
		var/vol = slot ? slot[POINT_AMBIENCE_SLOT_LAST_VOLUME] : null
		var/turf/source_turf = SSpoint_ambience.source_turfs[source] || get_turf(source)
		var/where = "position unknown"
		if(source_turf)
			var/dx = source_turf.x - here.x
			var/dy = source_turf.y - here.y
			var/distsq = dx * dx + dy * dy
			where = "[round(sqrt(distsq), 0.1)] tiles"
			// Nothing should ever be playing from outside its own range, so say so loudly here
			// rather than leaving it to be read off the distance.
			if(distsq > category.range_sq)
				where += ", PAST its range of [category.range], which is a BUG"
			if(source_turf.z != here.z)
				where += ", [abs(source_turf.z - here.z)] floor away"
			// What a volume figure cannot show. A muffled send carries a dead-room environment and
			// the occlusion low-pass as well as its quarter off, so two sources reading the same
			// number are not equally audible.
			switch(SSpoint_ambience.source_occluded(source_turf, here, category))
				if(OCCLUSION_MUFFLED)
					where += ", <b>MUFFLED</b> (dead room + occlusion low-pass, not just quieter)"
				if(OCCLUSION_SOLID)
					where += ", occlusion says SOLID while it is playing, which is a BUG"
		playing += "&nbsp;&nbsp;[category.config_name]: <b>[isnull(vol) ? "unknown" : round(vol, 0.1)]</b>/100, [where]"
	msg += "point ambience on your channels: [length(playing) ? "" : "<b>nothing</b>"]"
	msg += playing

	to_chat(usr, jointext(msg, "<br>"))
