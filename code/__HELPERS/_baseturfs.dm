/proc/baseturfs_string_list(list/values, turf/baseturf_holder)
	if(!islist(values))
		return values //baseturf things
	// return values
	if(length(values) > 10)
		stack_trace("The baseturfs list of [baseturf_holder] at [baseturf_holder.x], [baseturf_holder.y], [baseturf_holder.z] is [length(values)], it should never be this long, investigate. I've set baseturfs to a flashing wall as a visual queue")
		baseturf_holder.ChangeTurf(/turf/closed/indestructible/baseturfs_ded, list(/turf/closed/indestructible/baseturfs_ded), flags = CHANGETURF_FORCEOP)
		return string_list(list(/turf/closed/indestructible/baseturfs_ded)) //I want this reported god damn it

	return string_list(values)

/turf/closed/indestructible/baseturfs_ded
	name = "Report this"
	desc = "It looks like base turfs went to the fucking moon, TELL YOUR LOCAL CODER TODAY"
	icon = 'icons/turf/debug.dmi'
	icon_state = "debug_turf"
