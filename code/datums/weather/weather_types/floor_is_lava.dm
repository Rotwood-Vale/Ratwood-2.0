//Causes fire damage to anyone not standing on a dense object.
/datum/weather/floor_is_lava
	name = "地板变成熔岩"
	desc = ""

	telegraph_message = span_warning("我感觉脚下的地面正变得滚烫，热浪让空气都扭曲了。")
	telegraph_duration = 150

	weather_message = span_danger("地板变成熔岩了！快站到什么东西上面去！")
	weather_duration_lower = 300
	weather_duration_upper = 600
	weather_overlay = "lava"

	end_message = span_danger("地面冷却下来，恢复了原本的模样。")
	end_duration = 0

	area_type = /area
	protected_areas = list(/area/space)
	target_trait = ZTRAIT_STATION

	overlay_layer = ABOVE_OPEN_TURF_LAYER //Covers floors only
	overlay_plane = FLOOR_PLANE
	immunity_type = "lava"


/datum/weather/floor_is_lava/weather_act(mob/living/L)
	if(istype(L.buckled, /obj/structure/bed))
		return
	for(var/obj/structure/O in L.loc)
		if(O.density)
			return
	if(L.loc.density)
		return
	if(!L.client) //Only sentient people are going along with it!
		return
	if(L.movement_type & FLYING)
		return
	L.adjustFireLoss(3)
	return ..()
