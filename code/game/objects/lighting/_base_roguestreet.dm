/obj/machinery/light/roguestreet
	name = "街灯" // Crafted through metalizing brazier(/obj/machinery/light/rogue/firebowl) and Standing Fire (/obj/machinery/light/rogue/firebowl/standing)
	desc = "一座铸铁方尖碑，上面附着一盏发出诡异光芒的灯。这是新时代曙光中新技术的前景。"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "slamp1"
	base_state = "slamp"
	brightness = 10.9
	nightshift_allowed = FALSE
	plane = GAME_PLANE_UPPER
	layer = 4.81
	fueluse = 0
	bulb_colour = "#58dd90"
	bulb_power = 0.95
	destroy_sound = "sound/foley/machinebreak.ogg" // A nice zappy noise for electric lights.
	destroy_message = "灯被砸碎时迸出火花！" // Some flavor for when it's destroyed.
	blade_dulling = DULLING_BASH
	max_integrity = 250
	pass_flags = LETPASSTHROW
	resistance_flags = INDESTRUCTIBLE // This item is not craftable yet, setting for anti-grief

/obj/machinery/light/roguestreet/midlamp
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "midlamp1"
	base_state = "midlamp"
	pixel_x = -16
	density = TRUE
	resistance_flags = INDESTRUCTIBLE // This item is not craftable yet, setting for anti-grief

/obj/machinery/light/roguestreet/walllamp
	name = "壁灯" // Crafted through metalizing sconce.
	desc = "一盏通过铸铁支架固定在墙上的诡异发光壁灯。它预示着新时代黎明中新技术的到来。"
	icon_state = "wlamp1"
	base_state = "wlamp"
	brightness = 7.8
	max_integrity = 125
	density = FALSE

/obj/machinery/light/roguestreet/orange
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "o_slamp1"
	base_state = "o_slamp"
	brightness = 10.9
	bulb_colour = "#da8c45"
	bulb_power = 1
	resistance_flags = null // This one is craftable.

/obj/machinery/light/roguestreet/orange/midlamp
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "o_midlamp1"
	base_state = "o_midlamp"
	pixel_x = -16
	density = TRUE
	resistance_flags = INDESTRUCTIBLE // This item is not craftable yet, setting for anti-grief

/obj/machinery/light/roguestreet/orange/walllamp
	name = "壁灯"
	desc = "一盏通过铸铁支架固定在墙上的诡异发光壁灯。它预示着新时代黎明中新技术的到来。"
	icon_state = "o_wlamp1"
	base_state = "o_wlamp"
	brightness = 7.8
	max_integrity = 125
	density = FALSE
	resistance_flags = null // This one is craftable.

/obj/machinery/light/roguestreet/proc/lights_out()
	on = FALSE
	set_light(0)
	update_icon()
	addtimer(CALLBACK(src, PROC_REF(lights_on)), 5 MINUTES)

/obj/machinery/light/roguestreet/proc/lights_on()
	on = TRUE
	update()
	update_icon()

/obj/machinery/light/roguestreet/update_icon()
	if(on)
		icon_state = "[base_state]1"
	else
		icon_state = "[base_state]0"

/obj/machinery/light/roguestreet/update()
	. = ..()
	if(on)
		GLOB.fires_list |= src
	else
		GLOB.fires_list -= src

/obj/machinery/light/roguestreet/Initialize(mapload)
	GLOB.streetlamp_list += src
	lights_on()
	update_icon()
	. = ..()





/obj/machinery/light/oldlight
	name = "远古光条灯"
	desc = "两个截锥体托举着刺目的死光，坚固而不可撼动。"
	icon = 'icons/obj/lighting.dmi'
	icon_state = "celestial_light"
	brightness = 10
	bulb_power = 1
	bulb_colour = "#fcd294"
	light_color = "#75021d"
	max_integrity = 0
	fueluse = 0
	light_on = 1
	light_outer_range = 4
	light_power = 2

/obj/machinery/light/oldlight/proc/lights_out()
	on = FALSE
	set_light(0)
	update_icon()
	addtimer(CALLBACK(src, PROC_REF(lights_on)), 5 MINUTES)

/obj/machinery/light/oldlight/proc/lights_on()
	on = TRUE
	update()
	update_icon()

/obj/machinery/light/oldlight/update_icon()
	if(on)
		icon_state = "celestial_light"
	else
		icon_state = "celestial_light"

/obj/machinery/light/oldlight/update()
	. = ..()
	if(on)
		GLOB.fires_list |= src
	else
		GLOB.fires_list -= src

/obj/machinery/light/oldlight/Initialize(mapload)
	lights_on()
	GLOB.streetlamp_list += src
	update_icon()
	. = ..()

/obj/machinery/light/roguestreet/update_icon()
	if(on)
		icon_state = "[base_state]1"
	else
		icon_state = "[base_state]0"
