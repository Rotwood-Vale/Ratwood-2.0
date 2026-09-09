/proc/create_all_lighting_objects()
	for(var/area/A in world)
		if(!IS_DYNAMIC_LIGHTING(A))
			continue

		for(var/turf/T in A)

			if(!IS_DYNAMIC_LIGHTING(T))
				continue

			T.underlays += GLOB.lighting_underlay_dark
			T.luminosity = 0
			CHECK_TICK
		CHECK_TICK
