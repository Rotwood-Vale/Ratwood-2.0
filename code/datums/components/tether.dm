/datum/component/tether
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/atom/tether_target
	var/max_dist
	var/tether_name

/datum/component/tether/Initialize(atom/tether_target, max_dist = 4, tether_name)
	if(!isliving(parent) || !istype(tether_target) || !tether_target.loc)
		return COMPONENT_INCOMPATIBLE
	src.tether_target = tether_target
	src.max_dist = max_dist
	if (ispath(tether_name, /atom))
		var/atom/tmp = tether_name
		src.tether_name = initial(tmp.name)
	else
		src.tether_name = tether_name
	RegisterSignal(parent, list(COMSIG_MOVABLE_PRE_MOVE), PROC_REF(checkTether))

/datum/component/tether/proc/checkTether(mob/mover, newloc)
	if (get_dist(mover,newloc) > max_dist)
		to_chat(mover, span_danger("[tether_name]已经绷紧，拦住了我的去路！"))
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

	var/atom/blocker
	out:
		for(var/turf/T in getline(tether_target,newloc))
			if (T.density)
				blocker = T
				break out
			for(var/a in T)
				var/atom/A = a
				if(A.density && A != mover && A != tether_target)
					blocker = A
					break out
	if (blocker)
		to_chat(mover, span_danger("[tether_name]被[blocker]挂住了，害我动弹不得！"))
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE
