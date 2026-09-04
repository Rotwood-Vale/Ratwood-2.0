/obj/structure/void_capsule
	name = "???"

	icon = 'modular_fenysha_events/icons/obj/capsule.dmi'
	icon_state = "capsule_closed"
	pixel_x = -120

	resistance_flags = INDESTRUCTIBLE|FIRE_PROOF|FREEZE_PROOF
	layer =  MASSIVE_OBJ_LAYER
	plane = GAME_PLANE_HIGHEST

	var/open_time = 10 MINUTES
	
	var/open_postfix = "gas"
	var/open_prefix = "capsule_open_"
	var/opened = FALSE

	var/open_timer = null
	var/static/list/all_capsules


/obj/structure/void_capsule/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/alien_examine)
	if(!all_capsules)
		all_capsules = list()
	all_capsules[type] |= src

	open_timer = addtimer(CALLBACK(src, PROC_REF(open)), open_time)

/obj/structure/void_capsule/Destroy()
	. = ..()
	if(all_capsules && all_capsules[type])
		all_capsules[type] -= src

	if(open_timer)
		deltimer(open_timer)

/obj/structure/void_capsule/proc/open()
	icon_state = "[open_prefix][open_postfix]" 
	opened =  TRUE
	update_icon()
	return


/obj/effect/particle_effect/smoke/fractal 
	icon_state = "smoke-static-lowtrans"
	opacity = FALSE
	density = FALSE
	alpha = 130
	color = COLOR_ASSEMBLY_PURPLE
	opaque = FALSE

	lifetime = 20 MINUTES

/obj/effect/particle_effect/smoke/fractal/smoke_mob(mob/living/carbon/C)
	. = ..()

	if(!ishuman(C))
		return
	
	var/mob/living/carbon/human/H = C
	H.emote_cough()
	if(prob(5))
		H.apply_status_effect(/datum/status_effect/fractal_infection)

/datum/effect_system/smoke_spread/fractal
	effect_type = /obj/effect/particle_effect/smoke/fractal

/obj/structure/void_capsule/gas

/obj/structure/void_capsule/gas/open()
	. = ..()
	var/datum/effect_system/smoke_spread/fractal/S = new
	S.set_up(32, get_turf(src))
	S.start()
