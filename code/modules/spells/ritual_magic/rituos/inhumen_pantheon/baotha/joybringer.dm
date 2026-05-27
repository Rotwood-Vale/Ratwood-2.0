

/////////////////////////
/// Status-Effects /////
///////////////////////


#define JOYBRINGER_FILTER "joybringer"

/datum/status_effect/joybringer
	id = "joybringer"
	var/outline_colour = "#a529e8"
	duration = -1
	tick_interval = -1
	examine_text = span_love("SUBJECTPRONOUN is bathed in Baotha's blessings!")
	alert_type = null

/datum/status_effect/joybringer/on_apply()
	. = ..()

	owner.visible_message(span_userdanger("A tide of vibrant purple mist surges from [owner], carrying the heavy scent of sweet intoxication!"))

	var/filter = owner.get_filter(JOYBRINGER_FILTER)
	if(!filter)
		owner.add_filter(JOYBRINGER_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 2))

	var/mutable_appearance/effect = mutable_appearance('icons/effects/effects.dmi', "mist", -JOYBRINGER_LAYER, alpha = 128)
	effect.appearance_flags = RESET_COLOR
	effect.blend_mode = BLEND_ADD
	effect.color = "#a529e8"

	owner.overlays_standing[JOYBRINGER_LAYER] = effect
	owner.apply_overlay(JOYBRINGER_LAYER)

	RegisterSignal(owner, COMSIG_LIVING_LIFE, PROC_REF(on_life))

/datum/status_effect/joybringer/on_remove()
	. = ..()

	owner.remove_filter(JOYBRINGER_FILTER)
	owner.remove_overlay(JOYBRINGER_LAYER)

	UnregisterSignal(owner, COMSIG_LIVING_LIFE)

/datum/status_effect/joybringer/proc/on_life()
	SIGNAL_HANDLER

	for(var/mob/living/mob in get_hearers_in_view(2, owner))
		if(HAS_TRAIT(mob, TRAIT_CRACKHEAD) || HAS_TRAIT(mob, TRAIT_PSYDONITE))
			continue

		mob.apply_status_effect(/datum/status_effect/debuff/joybringer_druqks)

#undef JOYBRINGER_FILTER

/datum/status_effect/debuff/joybringer_druqks
	id = "joybringer_druqks"
	effectedstats = list(STATKEY_LCK = -2)
	duration = 3 SECONDS
	alert_type = null

/datum/status_effect/debuff/joybringer_druqks/on_apply()
	. = ..()
	owner.overlay_fullscreen("joybringer_weeds", /atom/movable/screen/fullscreen/weedsm)
	owner.overlay_fullscreen("joybringer_druqks", /atom/movable/screen/fullscreen/druqks)

	ADD_TRAIT(owner, TRAIT_DRUQK, src)

	if(owner.client)
		SSdroning.play_area_sound(get_area(owner), owner.client)

/datum/status_effect/debuff/joybringer_druqks/on_remove()
	. = ..()
	owner.clear_fullscreen("joybringer_druqks")
	owner.clear_fullscreen("joybringer_weeds")

	REMOVE_TRAIT(owner, TRAIT_DRUQK, src)

	if(owner.client)
		SSdroning.play_area_sound(get_area(owner), owner.client)

/datum/status_effect/debuff/joybringer_druqks/tick()
	if(owner.hallucination < 30) // this can stack up INFINITELY if you dont cap it like this
		owner.hallucination += 3 // and it doesnt decay *that* fast.
	owner.Jitter(1)

	if(!prob(10))
		return

	owner.emote(pick("chuckle", "giggle"))


