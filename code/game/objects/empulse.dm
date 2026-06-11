/proc/empulse(turf/epicenter, heavy_range, light_range, log=0)
	if(!epicenter)
		return

	if(!isturf(epicenter))
		epicenter = get_turf(epicenter.loc)

	if(log)
		message_admins("[epicenter.loc.name]区域发生了范围为([heavy_range], [light_range])的EMP")
		log_game("[epicenter.loc.name]区域发生了范围为([heavy_range], [light_range])的EMP")

	if(heavy_range > 1)
		new /obj/effect/temp_visual/emp/pulse(epicenter)

	if(heavy_range > light_range)
		light_range = heavy_range

	for(var/A in spiral_range(light_range, epicenter))
		var/atom/T = A
		var/distance = get_dist(epicenter, T)
		if(distance < 0)
			distance = 0
		if(distance < heavy_range)
			T.emp_act(EMP_HEAVY)
		else if(distance == heavy_range)
			if(prob(50))
				T.emp_act(EMP_HEAVY)
			else
				T.emp_act(EMP_LIGHT)
		else if(distance <= light_range)
			T.emp_act(EMP_LIGHT)
	return 1
