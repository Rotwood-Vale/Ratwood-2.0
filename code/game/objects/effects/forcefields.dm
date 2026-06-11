/obj/effect/forcefield
	desc = ""
	name = "力场墙"
	icon_state = "m_shield"
	anchored = TRUE
	opacity = 0
	density = TRUE
	CanAtmosPass = ATMOS_PASS_DENSITY
	var/timeleft = 300 //Set to 0 for permanent forcefields (ugh)

/obj/effect/forcefield/Initialize(mapload)
	. = ..()
	if(timeleft)
		QDEL_IN(src, timeleft)

/obj/effect/forcefield/cult
	desc = ""
	name = "发光墙壁"
	icon = 'icons/effects/cult_effects.dmi'
	icon_state = "cultshield"
	CanAtmosPass = ATMOS_PASS_NO
	timeleft = 200

///////////Mimewalls///////////

/obj/effect/forcefield/mime
	icon_state = "nothing"
	name = "隐形墙"
	desc = ""
	alpha = 0

/obj/effect/forcefield/mime/advanced
	name = "隐形屏障"
	desc = ""
	timeleft = 600
