/area/rogue/under/scum
	name = "THE DEADWATER DOCKS"
	icon_state = "under"
	first_time_text = "THE DEADWATER DOCKS"
	outdoors = TRUE
	droning_sound = 'modular_underbelly/sound/scum_day.ogg'
	droning_sound_dusk = 'modular_underbelly/sound/scum_dawn.ogg'
	droning_sound_night = 'modular_underbelly/sound/scum_night.ogg'
	soundenv = 16

/area/rogue/under/scum/Entered(mob/living/carbon/human/guy)
	. = ..()
	if(!ishuman(guy))
		return
	if(HAS_TRAIT(guy, TRAIT_UNDERBELLY_SCUM) && !guy.has_status_effect(/datum/status_effect/buff/home_turf_advantage))
		guy.apply_status_effect(/datum/status_effect/buff/home_turf_advantage)

/area/rogue/under/scum/lounge
	name = "THE SALTY MAIDEN"
	plane = INDOOR_PLANE
	droning_sound = 'modular_underbelly/sound/scum_day.ogg'
	droning_sound_dusk = 'modular_underbelly/sound/scum_dawn.ogg'
	droning_sound_night = 'modular_underbelly/sound/scum_night.ogg'
