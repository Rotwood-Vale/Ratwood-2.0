/obj/item/barometer
	name = "barometer"
	desc = "a primitive instrument to track incoming weather"
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

	visible_message(span_notice("[src] gives a faint *click* as the fluid inside shifts."))

/obj/item/barometer/attack_self(mob/user)
	var/datum/controller/subsystem/ParticleWeather/PW = SSParticleWeather
	visible_message(span_notice("[user] starts reading the [src]."))
	if(do_after(user, 5 SECONDS, target = src))
		if(PW.runningWeather)
			to_chat(user,span_notice("The fluid trembles steadily. The scale indicates the weather is currently [PW.runningWeather.name]."))
			return

		if(PW.queued_weather)
			to_chat(user,span_notice("The fluid jitters uneasily. The scale indicates a [PW.queued_weather.name] is coming."))
			return

		to_chat(user,span_notice("The fluid rests calm and unmoving."))
