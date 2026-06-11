/obj/item/barometer
	name = "气压计"
	desc = "一种用来追踪即将到来天气的原始仪器。"
	icon_state = "barometer"
	icon = 'icons/roguetown/items/misc.dmi'
	grid_width = 32
	grid_height = 64

/obj/item/barometer/Initialize(mapload)
	. = ..()
	GLOB.weather_observers += src

/obj/item/barometer/Destroy()
	GLOB.weather_observers -= src
	return ..()

/obj/item/barometer/proc/on_weather_queued(datum/particle_weather/W)
	if(!W)
		return

	visible_message(span_notice("[src]内部液体晃动时，发出轻微的“咔哒”声。"))

/obj/item/barometer/attack_self(mob/user)
	var/datum/controller/subsystem/ParticleWeather/PW = SSParticleWeather
	visible_message(span_notice("[user]开始查看[src]。"))
	if(do_after(user, 5 SECONDS, target = src))
		if(PW.runningWeather)
			to_chat(user,span_notice("液体平稳颤动着。刻度显示当前天气为[PW.runningWeather.name]。"))
			return

		if(PW.queued_weather)
			to_chat(user,span_notice("液体不安地抖动。刻度显示[PW.queued_weather.name]即将到来。"))
			return

		to_chat(user,span_notice("液体平静无波，一动不动。"))
