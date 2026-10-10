/obj/effect/spell_rune_under
	icon = 'icons/effects/spell_cast.dmi'
	icon_state = "rune"
	vis_flags = NONE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pixel_x = -8
	pixel_y = -8
	var/datum/weakref/mob_ref

/obj/effect/spell_rune_under/Initialize(mapload, mob/target_mob, spell_color)
	. = ..()
	color = spell_color
	mob_ref = WEAKREF(target_mob)

/obj/effect/spell_rune_under/Destroy(force)
	var/mob/holder = mob_ref?.resolve()
	holder?.vis_contents -= src
	return ..()

/obj/effect/temp_visual/wave_up
	icon = 'icons/effects/spell_cast.dmi'
	icon_state = "wave_up"
	vis_flags = NONE
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER
	pixel_x = -8
	pixel_y = -8
	duration = 1.8 SECONDS
	randomdir = FALSE
	var/datum/weakref/mob_ref

/obj/effect/temp_visual/wave_up/Initialize(mapload, mob/target_mob)
	. = ..()
	mob_ref = WEAKREF(target_mob)

/obj/effect/temp_visual/wave_up/Destroy(force)
	var/mob/holder = mob_ref?.resolve()
	holder?.vis_contents -= src
	return ..()

/obj/effect/temp_visual/particle_up
	icon = 'icons/effects/spell_cast.dmi'
	icon_state = "particle_up"
	vis_flags = NONE
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER
	pixel_y = -8
	duration = 3.8 SECONDS
	randomdir = FALSE
	var/datum/weakref/mob_ref

/obj/effect/temp_visual/particle_up/Initialize(mapload, mob/target_mob, obj/effect/spell_rune_under/rune)
	. = ..()
	mob_ref = WEAKREF(target_mob)
	if(rune)
		RegisterSignal(rune, COMSIG_QDELETING, PROC_REF(clean_up))

/obj/effect/temp_visual/particle_up/Destroy(force)
	var/mob/holder = mob_ref?.resolve()
	holder?.vis_contents -= src
	return ..()

/obj/effect/temp_visual/particle_up/proc/clean_up()
	SIGNAL_HANDLER
	qdel(src)

/mob/proc/start_spell_visual_effects(spell_color)
	cancel_spell_visual_effects()
	spell_rune = new /obj/effect/spell_rune_under(null, src, spell_color)
	vis_contents |= spell_rune
	start_spell_particles(spell_color)

/mob/proc/start_spell_particles(spell_color)
	if(QDELETED(spell_rune))
		return
	var/obj/effect/temp_visual/particle_up/particles = new(null, src, spell_rune)
	vis_contents |= particles
	particles.color = spell_color
	addtimer(CALLBACK(src, PROC_REF(start_spell_particles), spell_color), 3.6 SECONDS)

/mob/proc/cancel_spell_visual_effects()
	QDEL_NULL(spell_rune)

/mob/proc/finish_spell_visual_effects(spell_color)
	cancel_spell_visual_effects()
	var/obj/effect/temp_visual/wave_up/wave = new(null, src)
	vis_contents |= wave
	wave.color = spell_color
