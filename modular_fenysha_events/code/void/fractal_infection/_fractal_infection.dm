/datum/status_effect/fractal_infection
	id = "fractal_infection"
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


	var/list/mutable_appearance/body_effects

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
	/// 0.75 = cooldown may vary by ±75%
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

	// Stage 5 is the terminal stage.
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
			sleep(10)

		if(1)
			sleep(10)

		if(2)
			sleep(10)

		if(3)
			sleep(10)

		if(4)
			sleep(10)

		if(5)
			sleep(10)


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
	return infection_stage >= 3


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

/datum/status_effect/fractal_infection/proc/do_fractal_message()
	// Message logic goes here.
	to_chat(owner, span_hypnophrase(pick(possible_fractal_messages)))
	if(ishuman(owner) && prob(15))
		var/mob/living/carbon/human/H = owner
		H.emote_cough()
		H.Shake()
	reset_fractal_message_cooldown()


/datum/status_effect/fractal_infection/proc/do_body_mutation()
	// Body mutation logic goes here.

	reset_body_mutation_cooldown()


/datum/status_effect/fractal_infection/proc/do_body_mutation_message()
	// Mutation message logic goes here.

	reset_body_mutation_message_cooldown()


/datum/status_effect/fractal_infection/proc/do_onscreen_effect()
	


	reset_onscreen_effect_cooldown()


/datum/status_effect/fractal_infection/proc/do_hallucination()
	// Hallucination logic goes here.

	reset_hallucination_cooldown()


/datum/status_effect/fractal_infection/proc/do_body_effect()
	// Generic body effect logic goes here.

	reset_body_effect_cooldown()



/atom/movable/screen/fullscreen/fractal
	icon = 'modular_fenysha_events/icons/onscreen/onscreen_fractal.dmi'
	icon_state = "mandelbrot"

/atom/movable/screen/fullscreen/fractal/zoom
	icon_state = "mandelbrot_zoom"
