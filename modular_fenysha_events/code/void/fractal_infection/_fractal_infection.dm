
/*
 * Temporary status effect responsible for one fractal screen event.
 *
 * The infection calls this effect from do_onscreen_effect().
 * The effect performs one randomized visual event and then removes itself.
 */
/datum/status_effect/fractal_screen
	id = "fractal_screen"
	alert_type = null

	duration = 6 SECONDS

	var/infection_stage = 1

/datum/status_effect/fractal_screen/on_apply()
	. = ..()

	if(!owner)
		return FALSE

	play_effect()

	/*
	 * This status effect is only a temporary event.
	 * All actual visual cleanup is handled by the individual event.
	 */
	addtimer(CALLBACK(src, PROC_REF(remove_effect)), duration)

	return TRUE



/datum/status_effect/fractal_screen/proc/remove_effect()
	qdel(src)



/datum/status_effect/fractal_screen/proc/play_effect()
	/*
	 * Higher stages unlock more violent effects.
	 */
	var/list/effects = list(
		"flash",
		"pulse",
		"zoom"
	)

	if(infection_stage >= 3)
		effects += "additive"
		effects += "surge"

	if(infection_stage >= 4)
		effects += "violent_zoom"
		effects += "flicker"

	if(infection_stage >= 5)
		effects += "collapse"

	switch(pick(effects))
		if("flash")
			effect_flash()

		if("pulse")
			effect_pulse()

		if("zoom")
			effect_zoom()

		if("additive")
			effect_additive()

		if("surge")
			effect_surge()

		if("violent_zoom")
			effect_violent_zoom()

		if("flicker")
			effect_flicker()

		if("collapse")
			effect_collapse()



/datum/status_effect/fractal_screen/proc/get_screen()
	var/atom/movable/screen/fullscreen/mandelbrot/screen = owner.overlay_fullscreen(
		MANDELBROT_FULLSCREEN,
		/atom/movable/screen/fullscreen/mandelbrot
	)

	if(!istype(screen))
		return null

	return screen



/*
 * Very short appearance flash.
 */

/datum/status_effect/fractal_screen/proc/effect_flash()
	var/atom/movable/screen/fullscreen/mandelbrot/screen = get_screen()

	if(!screen)
		return

	screen.blend_mode = BLEND_DEFAULT
	screen.alpha = 0

	animate(screen, alpha = 180, time = 4)
	animate(alpha = 60, time = 4)
	animate(alpha = 140, time = 3)
	animate(alpha = 0, time = 8)



/*
 * Calm breathing/pulsation.
 */

/datum/status_effect/fractal_screen/proc/effect_pulse()
	var/atom/movable/screen/fullscreen/mandelbrot/screen = get_screen()

	if(!screen)
		return

	screen.blend_mode = BLEND_DEFAULT
	screen.alpha = 110

	var/matrix/base = matrix(screen.transform)
	var/matrix/swelled = matrix(screen.transform)

	swelled.Scale(1.06)

	animate(screen, transform = swelled, time = 12, easing = SINE_EASING)
	animate(transform = base, time = 12, easing = SINE_EASING)
	animate(transform = swelled, time = 12, easing = SINE_EASING)
	animate(transform = base, time = 12, easing = SINE_EASING)

	animate(screen, alpha = 0, time = 12)



/*
 * Slow zoom into the fractal.
 */

/datum/status_effect/fractal_screen/proc/effect_zoom()
	var/atom/movable/screen/fullscreen/mandelbrot/screen = get_screen()

	if(!screen)
		return

	screen.blend_mode = BLEND_DEFAULT
	screen.alpha = 100

	var/matrix/base = matrix(screen.transform)
	var/matrix/zoom = matrix(screen.transform)

	zoom.Scale(1.18)

	animate(screen, transform = zoom, time = 30, easing = SINE_EASING)
	animate(transform = base, time = 8, easing = SINE_EASING)
	animate(screen, alpha = 0, time = 10)



/*
 * Additive glow.
 */

/datum/status_effect/fractal_screen/proc/effect_additive()
	var/atom/movable/screen/fullscreen/mandelbrot/screen = get_screen()

	if(!screen)
		return

	screen.blend_mode = BLEND_ADD
	screen.alpha = 0

	animate(screen, alpha = 100, time = 8)
	animate(alpha = 170, time = 10)
	animate(alpha = 0, time = 15)



/*
 * Sudden energy surge.
 */

/datum/status_effect/fractal_screen/proc/effect_surge()
	var/atom/movable/screen/fullscreen/mandelbrot/screen = get_screen()

	if(!screen)
		return

	screen.blend_mode = BLEND_ADD
	screen.alpha = 0

	var/matrix/base = matrix(screen.transform)
	var/matrix/swelled = matrix(screen.transform)

	swelled.Scale(1.12)

	animate(screen, alpha = 180, transform = swelled, time = 5, easing = JUMP_EASING)
	animate(alpha = 70, transform = base, time = 8, easing = SINE_EASING)
	animate(alpha = 150, transform = swelled, time = 4, easing = JUMP_EASING)
	animate(alpha = 0, transform = base, time = 12)



/*
 * Much more aggressive zoom.
 */

/datum/status_effect/fractal_screen/proc/effect_violent_zoom()
	var/atom/movable/screen/fullscreen/mandelbrot/screen = get_screen()

	if(!screen)
		return

	screen.blend_mode = BLEND_DEFAULT
	screen.alpha = 120

	var/matrix/base = matrix(screen.transform)
	var/matrix/zoom = matrix(screen.transform)

	zoom.Scale(1.35)

	animate(screen, transform = zoom, alpha = 180, time = 10, easing = JUMP_EASING)
	animate(transform = base, alpha = 80, time = 4, easing = JUMP_EASING)
	animate(transform = zoom, alpha = 150, time = 6, easing = JUMP_EASING)
	animate(transform = base, alpha = 0, time = 12)



/*
 * Rapid flickering.
 */

/datum/status_effect/fractal_screen/proc/effect_flicker()
	var/atom/movable/screen/fullscreen/mandelbrot/screen = get_screen()

	if(!screen)
		return

	screen.blend_mode = BLEND_DEFAULT
	screen.alpha = 0

	animate(screen, alpha = 160, time = 2)
	animate(alpha = 30, time = 3)
	animate(alpha = 190, time = 2)
	animate(alpha = 50, time = 2)
	animate(alpha = 140, time = 3)
	animate(alpha = 0, time = 8)



/*
 * Terminal-stage effect.
 *
 * The screen appears to collapse inward before disappearing.
 */

/datum/status_effect/fractal_screen/proc/effect_collapse()
	var/atom/movable/screen/fullscreen/mandelbrot/screen = get_screen()

	if(!screen)
		return

	screen.blend_mode = BLEND_ADD
	screen.alpha = 0

	var/matrix/base = matrix(screen.transform)
	var/matrix/collapse = matrix(screen.transform)

	collapse.Scale(0.72)

	animate(screen, alpha = 180, transform = collapse, time = 8, easing = JUMP_EASING)
	animate(alpha = 220, transform = base, time = 4, easing = JUMP_EASING)
	animate(alpha = 0, transform = collapse, time = 12, easing = SINE_EASING)



/datum/status_effect/fractal_infection
	id = "fractal_infection"
	alert_type = null

	var/infection_stage = 0
	var/max_stage = 5

	/// Base duration of a single infection stage.
	var/infection_stage_duration = 8 MINUTES

	/// 1.0 = normal speed
	/// 2.0 = twice as fast
	/// 0.5 = twice as slow
	var/infection_stage_speed = 1.0

	/// Time at which current stage ends.
	COOLDOWN_DECLARE(next_stage)

	/*
	 * Currently applied visual mutations.
	 *
	 * Key:
	 *	BODY_ZONE_*
	 *
	 * Value:
	 *	/datum/bodypart_feature/fractal_mutation
	 */
	var/list/datum/bodypart_feature/fractal_mutation/body_effects

	/*
	 * Already mutated bodyparts.
	 *
	 * Key:
	 *	BODY_ZONE_*
	 *
	 * Value:
	 *	stage at which the mutation appeared
	 */
	var/list/mutated_bodyparts

	var/fractal_message_cd = 80 SECONDS
	var/body_mutation_cd = 5 MINUTES
	var/body_mutation_message_cd = 3 MINUTES
	var/onscreen_effect_cd = 7 MINUTES
	var/hallucination_cd = 4 MINUTES
	var/body_effect_cd = 2 MINUTES

	COOLDOWN_DECLARE(next_fractal_message)
	COOLDOWN_DECLARE(next_body_mutation)
	COOLDOWN_DECLARE(next_body_mutation_message)
	COOLDOWN_DECLARE(next_onscreen_effect)
	COOLDOWN_DECLARE(next_hallucination)
	COOLDOWN_DECLARE(next_body_effect)

	/// 0.25 = cooldown may vary by ±25%
	var/default_variance = 0.25

	var/static/list/possible_fractal_messages = list(
		"You feel your flesh tear and reform into shapes it was never meant to take.",
		"Your thoughts begin to fracture, slipping into patterns you cannot follow.",
		"You see strange patterns where none should exist.",
		"Something beneath your skin shifts in perfect, repeating patterns.",
		"You feel as though your body is folding in on itself.",
		"For a moment, you swear your fingers have more joints than they should.",
		"Your skin seems to ripple in geometric patterns.",
		"You feel something moving through your body. It does not seem to have a direction.",
		"Your flesh twitches, then settles into an unfamiliar shape.",
		"You suddenly become aware of patterns repeating beneath your skin.",
		"Your reflection moves a fraction of a second too late.",
		"The room seems to repeat itself at the edges of your vision.",
		"You catch a glimpse of something impossible in the corner of your eye.",
		"The shapes around you seem to fit together in ways they shouldn't.",
		"Your surroundings briefly appear to fold into an endless pattern.",
		"You feel like you have seen this exact moment before. Countless times.",
		"A thought enters your mind, repeats itself, and becomes something else.",
		"Your thoughts echo strangely, as if they are coming from somewhere else.",
		"You struggle to remember where one thought ends and another begins.",
		"Something about your own body suddenly feels unfamiliar.",
		"You have the unsettling feeling that your body is only an approximation of itself.",
		"Your heartbeat falls into a strange, repeating rhythm.",
		"Your muscles move before you consciously tell them to.",
		"You feel an invisible pattern pulling your body into place.",
		"Something is trying to make you symmetrical.",
		"You feel yourself changing, but cannot tell what is changing.",
		"Your body feels wrong. Not injured. Just... wrong.",
		"For a fleeting moment, you cannot tell where your body ends.",
		"You feel as though something is looking through your eyes."
	)



/datum/status_effect/fractal_infection/on_apply()
	. = ..()

	body_effects = list()
	mutated_bodyparts = list()

	start_stage(0)
	reset_event_cooldowns()

	return TRUE



/datum/status_effect/fractal_infection/tick()
	. = ..()

	update_stage()

	if(COOLDOWN_FINISHED(src, next_fractal_message) && can_do_fractal_message())
		do_fractal_message()

	if(COOLDOWN_FINISHED(src, next_body_mutation) && can_do_body_mutation())
		do_body_mutation()

	if(COOLDOWN_FINISHED(src, next_body_mutation_message) && can_do_body_mutation_message())
		do_body_mutation_message()

	if(COOLDOWN_FINISHED(src, next_onscreen_effect) && can_do_onscreen_effect())
		do_onscreen_effect()

	if(COOLDOWN_FINISHED(src, next_hallucination) && can_do_hallucination())
		do_hallucination()

	if(COOLDOWN_FINISHED(src, next_body_effect) && can_do_body_effect())
		do_body_effect()



/datum/status_effect/fractal_infection/proc/update_stage()
	if(infection_stage >= max_stage)
		return

	if(!COOLDOWN_FINISHED(src, next_stage))
		return

	start_stage(infection_stage + 1)



/datum/status_effect/fractal_infection/proc/start_stage(new_stage)
	if(new_stage < 0 || new_stage > max_stage)
		return

	infection_stage = new_stage

	/// Stage 5 is the terminal stage.
	if(infection_stage >= max_stage)
		COOLDOWN_RESET(src, next_stage)
	else
		var/stage_duration = get_stage_duration(infection_stage)
		stage_duration /= max(infection_stage_speed, 0.01)

		COOLDOWN_START(src, next_stage, stage_duration)

	on_stage_changed(infection_stage)



/datum/status_effect/fractal_infection/proc/get_stage_duration(stage)
	switch(stage)
		if(0)
			return 8 MINUTES

		if(1)
			return 8 MINUTES

		if(2)
			return 8 MINUTES

		if(3)
			return 8 MINUTES

		if(4)
			return 8 MINUTES

		if(5)
			return 0

	return infection_stage_duration



/datum/status_effect/fractal_infection/proc/on_stage_changed(new_stage)
	switch(new_stage)
		if(0)
			return

		if(1)
			return

		if(2)
			return

		if(3)
			return

		if(4)
			// The lance may or may not appear; see update_fractal_abilities.
			update_fractal_abilities(new_stage)
			return

		if(5)
			update_fractal_abilities(new_stage)
			return



/*
 * EVENT CONDITIONS
 */

/datum/status_effect/fractal_infection/proc/can_do_fractal_message()
	return TRUE



/datum/status_effect/fractal_infection/proc/can_do_body_effect()
	return infection_stage >= 1



/datum/status_effect/fractal_infection/proc/can_do_onscreen_effect()
	return infection_stage >= 2



/datum/status_effect/fractal_infection/proc/can_do_hallucination()
	return infection_stage >= 2



/datum/status_effect/fractal_infection/proc/can_do_body_mutation_message()
	return infection_stage >= 3



/datum/status_effect/fractal_infection/proc/can_do_body_mutation()
	return infection_stage >= 1



/*
 * COOLDOWNS
 */

/datum/status_effect/fractal_infection/proc/get_randomized_cooldown(base_cooldown)
	var/min_multiplier = max(0, 1 - default_variance)
	var/max_multiplier = 1 + default_variance

	return round(base_cooldown * rand(
		round(min_multiplier * 100),
		round(max_multiplier * 100)
	) / 100)



/datum/status_effect/fractal_infection/proc/reset_event_cooldowns()
	COOLDOWN_START(src, next_fractal_message, get_randomized_cooldown(fractal_message_cd))
	COOLDOWN_START(src, next_body_mutation, get_randomized_cooldown(body_mutation_cd))
	COOLDOWN_START(src, next_body_mutation_message, get_randomized_cooldown(body_mutation_message_cd))
	COOLDOWN_START(src, next_onscreen_effect, get_randomized_cooldown(onscreen_effect_cd))
	COOLDOWN_START(src, next_hallucination, get_randomized_cooldown(hallucination_cd))
	COOLDOWN_START(src, next_body_effect, get_randomized_cooldown(body_effect_cd))



/datum/status_effect/fractal_infection/proc/reset_fractal_message_cooldown()
	COOLDOWN_START(src, next_fractal_message, get_randomized_cooldown(fractal_message_cd))



/datum/status_effect/fractal_infection/proc/reset_body_mutation_cooldown()
	COOLDOWN_START(src, next_body_mutation, get_randomized_cooldown(body_mutation_cd))



/datum/status_effect/fractal_infection/proc/reset_body_mutation_message_cooldown()
	COOLDOWN_START(src, next_body_mutation_message, get_randomized_cooldown(body_mutation_message_cd))



/datum/status_effect/fractal_infection/proc/reset_onscreen_effect_cooldown()
	COOLDOWN_START(src, next_onscreen_effect, get_randomized_cooldown(onscreen_effect_cd))



/datum/status_effect/fractal_infection/proc/reset_hallucination_cooldown()
	COOLDOWN_START(src, next_hallucination, get_randomized_cooldown(hallucination_cd))



/datum/status_effect/fractal_infection/proc/reset_body_effect_cooldown()
	COOLDOWN_START(src, next_body_effect, get_randomized_cooldown(body_effect_cd))



/*
 * BODY PART MUTATION
 */

/datum/status_effect/fractal_infection/proc/get_mutatable_body_zones()
	var/list/zones = list(
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
		BODY_ZONE_HEAD,
		BODY_ZONE_CHEST
	)

	for(var/zone in zones.Copy())
		if(!owner.get_bodypart(zone))
			zones -= zone

	return zones



/datum/status_effect/fractal_infection/proc/get_zone_name(zone)
	switch(zone)
		if(BODY_ZONE_L_ARM)
			return "left arm"

		if(BODY_ZONE_R_ARM)
			return "right arm"

		if(BODY_ZONE_L_LEG)
			return "left leg"

		if(BODY_ZONE_R_LEG)
			return "right leg"

		if(BODY_ZONE_HEAD)
			return "head"

		if(BODY_ZONE_CHEST)
			return "chest"

	return null



/datum/status_effect/fractal_infection/proc/get_mutation_icon_state(zone)
	switch(zone)
		if(BODY_ZONE_L_ARM)
			return "arm_l"

		if(BODY_ZONE_R_ARM)
			return "arm_r"

		if(BODY_ZONE_L_LEG)
			return "leg_l"

		if(BODY_ZONE_R_LEG)
			return "leg_r"

		if(BODY_ZONE_HEAD)
			return "head"

		if(BODY_ZONE_CHEST)
			return "chest"

	return null



/datum/status_effect/fractal_infection/proc/get_preferred_mutation_zones()
	switch(infection_stage)
		if(1)
			return list(
				BODY_ZONE_L_ARM,
				BODY_ZONE_R_ARM,
				BODY_ZONE_L_LEG,
				BODY_ZONE_R_LEG
			)

		if(2)
			return list(
				BODY_ZONE_L_ARM,
				BODY_ZONE_R_ARM,
				BODY_ZONE_L_LEG,
				BODY_ZONE_R_LEG
			)

		if(3)
			return list(
				BODY_ZONE_L_ARM,
				BODY_ZONE_R_ARM,
				BODY_ZONE_L_LEG,
				BODY_ZONE_R_LEG,
				BODY_ZONE_CHEST
			)

		if(4)
			return list(
				BODY_ZONE_L_ARM,
				BODY_ZONE_R_ARM,
				BODY_ZONE_L_LEG,
				BODY_ZONE_R_LEG,
				BODY_ZONE_CHEST,
				BODY_ZONE_HEAD
			)

		if(5)
			return list(
				BODY_ZONE_L_ARM,
				BODY_ZONE_R_ARM,
				BODY_ZONE_L_LEG,
				BODY_ZONE_R_LEG,
				BODY_ZONE_CHEST,
				BODY_ZONE_HEAD
			)

	return list()



/datum/status_effect/fractal_infection/proc/select_mutation_zone()
	var/list/possible_zones = get_mutatable_body_zones()

	if(!possible_zones.len)
		return null

	/*
	 * Never mutate the same bodypart twice.
	 */
	for(var/zone in possible_zones.Copy())
		if(mutated_bodyparts[zone])
			possible_zones -= zone

	if(!possible_zones.len)
		return null

	var/list/preferred_zones = get_preferred_mutation_zones()

	/*
	 * Prefer zones associated with the current infection stage,
	 * but keep an element of randomness.
	 */
	for(var/zone in preferred_zones)
		if(zone in possible_zones)
			if(prob(70))
				return zone

	return pick(possible_zones)



/*
 * Bodypart features are drawn as part of the limb's own icon stack, so the
 * mutation inherits the body sprite's dir. Every overlays_standing entry ends
 * up in the mob's own overlays, so BODY_FRONT_LAYER sorts the mutation above
 * all worn equipment.
 */
/datum/bodypart_feature/fractal_mutation
	name = "fractal mutation"
	feature_slot = BODYPART_FEATURE_FRACTAL_MUTATION

	/// Icon state on fractal_mutation.dmi, one per body zone.
	var/mutation_icon_state

/*
 * Limb appearances are shared between mobs through limb_icon_cache, so the key
 * has to describe the mutation.
 */
/datum/bodypart_feature/fractal_mutation/get_icon_cache_key(obj/item/bodypart/bodypart)
	return "fractalmutation-[mutation_icon_state]"



/datum/bodypart_feature/fractal_mutation/get_bodypart_overlay(obj/item/bodypart/bodypart)
	if(!mutation_icon_state)
		return null

	return mutable_appearance(
		'modular_fenysha_events/icons/effects/fractal_mutation.dmi',
		mutation_icon_state,
		layer = -BODY_FRONT_LAYER
	)



/datum/status_effect/fractal_infection/proc/mutate_bodypart(zone)
	if(!zone)
		return FALSE

	if(mutated_bodyparts[zone])
		return FALSE

	var/obj/item/bodypart/part = owner.get_bodypart(zone)
	if(!part)
		return FALSE

	var/icon_state = get_mutation_icon_state(zone)
	if(!icon_state)
		return FALSE

	var/datum/bodypart_feature/fractal_mutation/mutation = new
	mutation.body_zone = part.body_zone
	mutation.mutation_icon_state = icon_state

	if(!part.add_bodypart_feature(mutation))
		qdel(mutation)
		return FALSE

	/*
	 * Store mutation state.
	 */
	mutated_bodyparts[zone] = infection_stage
	body_effects[zone] = mutation

	/*
	 * Apply gameplay impairment.
	 */
	apply_mutation_impairment(part, zone, infection_stage)
	update_examine_text()

	return TRUE



/datum/status_effect/fractal_infection/proc/apply_mutation_impairment(obj/item/bodypart/part, zone, stage)
	if(!part)
		return



/datum/status_effect/fractal_infection/proc/remove_bodypart_mutation(zone)
	var/datum/bodypart_feature/fractal_mutation/mutation = body_effects[zone]

	body_effects -= zone
	mutated_bodyparts -= zone

	if(!mutation)
		return

	var/obj/item/bodypart/part = owner?.get_bodypart(zone)
	part?.remove_bodypart_feature(mutation)

	qdel(mutation)
	update_examine_text()



/*
 * status_effect_examines() reads examine_text off the effect at examine time,
 * so it only has to be rebuilt when the mutated bodyparts change.
 */
/datum/status_effect/fractal_infection/proc/update_examine_text()
	var/list/part_names = list()

	for(var/zone in mutated_bodyparts)
		var/part_name = get_zone_name(zone)

		if(part_name)
			part_names += part_name

	if(!part_names.len)
		examine_text = null
		return

	/// "SUBJECTPRONOUN is" must stay contiguous - status_effect_examines() fixes verb agreement by matching that pair.
	examine_text = span_boldwarning("<span class='fractal_growth'>SUBJECTPRONOUN is covered in <span class='fractal_glyph'>warped, endlessly repeating</span> growths across the [english_list(part_names)].</span>")



/datum/status_effect/fractal_infection/proc/remove_all_bodypart_mutations()
	if(!body_effects)
		return

	for(var/zone in body_effects.Copy())
		remove_bodypart_mutation(zone)



/*
 * EVENT EFFECTS
 */

/**
 * Applies at most one subtle treatment to an infection line, scaled by stage.
 *
 * Most messages are left completely alone on purpose. The infection talks for five
 * stages of eight minutes; a distortion the player sees on every line stops
 * registering long before the end, whereas an occasional wrong one keeps working.
 *
 * Nothing here sets or animates colour - the hypnophrase voice already cycles its
 * own, and a second colour animation on top of it just reads as mud.
 */
/datum/status_effect/fractal_infection/proc/distort_message(text)
	if(infection_stage < 2 || !prob(infection_stage * 12))
		return text

	var/list/treatments = list("fractal_whisper")

	if(infection_stage >= 3)
		treatments += "fractal_faint_echo"

	if(infection_stage >= 4)
		treatments += "fractal_faint_blur"

	return "<span class='[pick(treatments)]'>[degrade_words(text)]</span>"



/// One or two words slipping into the abyssal alphabet. Font only, so it composes
/// with whatever voice the line is about to be wrapped in.
/datum/status_effect/fractal_infection/proc/degrade_words(text)
	if(infection_stage < 3)
		return text

	var/list/words = splittext(text, " ")

	if(!length(words))
		return text

	for(var/i in 1 to (infection_stage >= 5 ? 2 : 1))
		var/index = rand(1, length(words))
		var/word = words[index]

		if(!length(word) || findtext(word, "<"))
			continue

		words[index] = "<span class='fractal_glyph'>[word]</span>"

	return jointext(words, " ")



/datum/status_effect/fractal_infection/proc/do_fractal_message()
	to_chat(
		owner,
		span_hypnophrase(distort_message(pick(possible_fractal_messages)))
	)

	if(ishuman(owner) && prob(15))
		var/mob/living/carbon/human/H = owner
		H.emote_cough()
		H.Shake()

	reset_fractal_message_cooldown()



/datum/status_effect/fractal_infection/proc/do_body_mutation()
	var/zone = select_mutation_zone()

	if(zone)
		mutate_bodypart(zone)

	reset_body_mutation_cooldown()



/datum/status_effect/fractal_infection/proc/do_body_mutation_message()
	/*
	 * Pick only from bodyparts that are actually available
	 * for mutation.
	 */
	var/zone = select_mutation_zone()

	if(!zone)
		reset_body_mutation_message_cooldown()
		return

	var/part_name = get_zone_name(zone)

	if(part_name)
		to_chat(owner, span_warning(distort_message("Something feels deeply wrong with your [part_name].")))
	reset_body_mutation_message_cooldown()



/datum/status_effect/fractal_infection/proc/do_onscreen_effect()
	var/datum/status_effect/fractal_screen/effect = owner.has_status_effect(
		/datum/status_effect/fractal_screen
	)

	if(!effect)
		effect = owner.apply_status_effect(
			/datum/status_effect/fractal_screen
		)

	if(effect)
		effect.infection_stage = infection_stage
		effect.play_effect()

	reset_onscreen_effect_cooldown()



/datum/status_effect/fractal_infection/proc/do_hallucination()
	/*
	 * Hallucination logic goes here.
	 */

	reset_hallucination_cooldown()



/datum/status_effect/fractal_infection/proc/do_body_effect()
	/*
	 * Generic body effect logic goes here.
	 */

	reset_body_effect_cooldown()



/*
 * CLEANUP
 */

/datum/status_effect/fractal_infection/on_remove()
	remove_all_bodypart_mutations()
	clear_fractal_abilities()

	return ..()

