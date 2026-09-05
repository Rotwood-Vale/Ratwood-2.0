/obj/structure/void_capsule
	name = "???"
	desc = "A strange metallic capsule lies half-buried in the earth. Its dark, seamless shell is covered in irregular patterns, with no hinges, locks, or markings that resemble anything made by human hands."

	icon = 'modular_fenysha_events/icons/obj/capsule.dmi'
	icon_state = "capsule_closed"
	pixel_x = -120

	resistance_flags = INDESTRUCTIBLE|FIRE_PROOF|FREEZE_PROOF
	layer =  MASSIVE_OBJ_LAYER
	plane = GAME_PLANE_HIGHEST

	var/open_time = 10 MINUTES
	var/effect_time = 3 SECONDS
	var/open_sound = 'modular_fenysha_events/sound/capsule_open.ogg'
	var/open_desc

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
	if(open_sound)
		playsound(get_turf(src), open_sound, 80, FALSE, 12)

	if(open_desc)
		desc = open_desc

	if(open_timer)
		deltimer(open_timer)

	addtimer(CALLBACK(src, PROC_REF(do_effect)), effect_time)
	return TRUE

/obj/structure/void_capsule/proc/open_all()
	if(!all_capsules)
		return FALSE
	var/list/other = all_capsules[type] ? all_capsules[type] : list()
	for(var/obj/structure/void_capsule/capsule as anything in other)
		if(!capsule.opened)
			capsule.open()
	return TRUE


/obj/structure/void_capsule/proc/do_effect()
	return TRUE

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



/datum/looping_sound/void_capsule_gas
	mid_sounds = list('modular_fenysha_events/sound/capsule_gas_loop.ogg')
	mid_length = 5 SECONDS
	extra_range = 8

/obj/structure/void_capsule/gas
	open_desc = "The capsule's shell has split open, revealing a hollow interior lined with strange, dark material. Whatever once rested inside is gone, leaving behind only faint traces of an unfamiliar residue."
	var/spread_radius = 24

	var/datum/looping_sound/void_capsule_gas/looping_sound
	var/stopgas_timer = null

/obj/structure/void_capsule/gas/Destroy()
	qdel(looping_sound)
	. = ..()

/obj/structure/void_capsule/gas/do_effect()
	var/datum/effect_system/smoke_spread/fractal/S = new
	S.set_up(spread_radius, get_turf(src))
	S.start()
	
	looping_sound = new(src, TRUE)
	stopgas_timer = addtimer(CALLBACK(src, PROC_REF(stop_gas)), 20 MINUTES)
	return TRUE

/obj/structure/void_capsule/gas/proc/stop_gas()
	qdel(looping_sound) 

	return TRUE
