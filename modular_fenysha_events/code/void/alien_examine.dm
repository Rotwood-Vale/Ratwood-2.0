/atom/movable/screen/fullscreen/fractal_text
	var/mob/living/carbon/human/owner
	var/lifetime = 2 SECONDS

/atom/movable/screen/fullscreen/fractal_text/proc/setup(mob/living/carbon/human/new_owner, text, x, y, width, height, alpha_value, font_size)
	owner = new_owner

	maptext_width = width
	maptext_height = height
	maptext_x = x
	maptext_y = y

	alpha = alpha_value

	maptext = "<font face='Verdana' size='[10 * font_size]' color='#C8B8FF'>[text]</font>"

	return src



/datum/status_effect/fractal_maptext
	id = "fractal_maptext"

	duration = 12 SECONDS

	var/intensity = 1
	var/list/active_texts = list()

	var/text_spawn_cooldown = 8
	var/last_spawn = 0

	var/static/list/disturbing_messages = list(
		"LOOK AGAIN",
		"DO YOU SEE THE PATTERN?",
		"YOU ARE ALREADY TOO DEEP",
		"THERE IS NO CENTER",
		"THE SHAPE IS LOOKING BACK",
		"STOP TRYING TO UNDERSTAND",
		"IT KNOWS YOU ARE HERE",
		"YOU HAVE SEEN THIS BEFORE",
		"YOU WILL SEE THIS AGAIN",
		"THIS IS NOT THE SAME PLACE",
		"YOUR EYES ARE WRONG",
		"DO NOT FOLLOW THE EDGES",
		"IT CONTINUES BEYOND THE SCREEN",
		"THERE IS SOMETHING INSIDE THE SHAPE",
		"YOU ARE PART OF THE PATTERN",
		"COUNT THE EDGES",
		"THERE ARE MORE OF THEM NOW",
		"THE PATTERN HAS NO END",
		"WHY ARE YOU STILL LOOKING",
		"IT DOES NOT HAVE A FRONT",
		"IT DOES NOT HAVE A BACK",
		"YOU CANNOT LOOK AWAY",
		"THE GEOMETRY REMEMBERS YOU",
		"THE SHAPE IS NOT FINISHED",
		"THIS IS ONLY THE OUTSIDE"
	)

	var/static/list/fractal_symbols = list(
		"∞",
		"∴",
		"∵",
		"⟐",
		"⟁",
		"◌",
		"◉",
		"⊙",
		"⋮",
		"∷",
		"⟟"
	)



/datum/status_effect/fractal_maptext/on_apply()
	. = ..()

	if(!owner || !owner.client)
		return FALSE

	return TRUE



/datum/status_effect/fractal_maptext/tick()
	. = ..()

	if(!owner || !owner.client)
		return

	if(world.time < last_spawn + text_spawn_cooldown)
		return

	last_spawn = world.time

	var/spawn_count = 6

	if(intensity >= 2)
		spawn_count = rand(6, 11)

	if(intensity >= 4)
		spawn_count = rand(11, 20)

	for(var/i in 1 to spawn_count)
		spawn_fractal_text()



/datum/status_effect/fractal_maptext/proc/spawn_fractal_text()
	if(!owner || !owner.client)
		return

	var/atom/movable/screen/fullscreen/fractal_text/text_holder = new

	var/style = rand(1, 5)

	var/text
	var/x
	var/y
	var/width
	var/height
	var/text_alpha
	var/font_size

	switch(style)
		if(1)
			text = pick(disturbing_messages)
			x = rand(-100, world.view * 32)
			y = rand(-50, world.view * 32)
			width = rand(150, 300)
			height = 40
			text_alpha = rand(90, 180)
			font_size = 2

		if(2)
			text = generate_fractal_line()
			x = rand(-100, world.view * 32)
			y = rand(-50, world.view * 32)
			width = rand(200, 400)
			height = 100
			text_alpha = rand(70, 150)
			font_size = 2

		if(3)
			text = generate_fractal_cluster()
			x = rand(-100, world.view * 32)
			y = rand(-50, world.view * 32)
			width = rand(200, 350)
			height = rand(100, 200)
			text_alpha = rand(80, 160)
			font_size = 2

		if(4)
			text = generate_repeating_message()
			x = rand(-50, world.view * 32)
			y = rand(-50, world.view * 32)
			width = rand(250, 500)
			height = rand(50, 100)
			text_alpha = rand(100, 190)
			font_size = 3

		if(5)
			text = generate_center_pattern()
			x = rand(-50, world.view * 32)
			y = rand(-50, world.view * 32)
			width = rand(200, 400)
			height = rand(200, 400)
			text_alpha = rand(80, 170)
			font_size = 2

	text_holder.setup(owner, text, x, y, width, height, text_alpha, font_size)

	owner.client.screen += text_holder
	active_texts += text_holder

	animate(text_holder, alpha = 0, time = text_holder.lifetime, flags = ANIMATION_PARALLEL)
	addtimer(CALLBACK(src, PROC_REF(remove_text), text_holder), text_holder.lifetime)



/datum/status_effect/fractal_maptext/proc/remove_text(atom/movable/screen/fullscreen/fractal_text/text_holder)
	if(!text_holder)
		return

	if(owner?.client)
		owner.client.screen -= text_holder

	active_texts -= text_holder
	qdel(text_holder)



/datum/status_effect/fractal_maptext/proc/generate_fractal_line()
	var/list/parts = list()

	var/line_count = rand(2, 5)

	for(var/i in 1 to line_count)
		var/message = pick(disturbing_messages)
		var/repetitions = rand(1, 3)

		for(var/j in 1 to repetitions)
			parts += message

	return jointext(parts, "    ")



/datum/status_effect/fractal_maptext/proc/generate_fractal_cluster()
	var/list/lines = list()
	var/size = rand(3, 7)

	for(var/y in 1 to size)
		var/list/line = list()

		for(var/x in 1 to size)
			if(prob(55))
				line += pick(fractal_symbols)
			else
				line += " "

		lines += jointext(line, " ")

	return jointext(lines, "<br>")



/datum/status_effect/fractal_maptext/proc/generate_repeating_message()
	var/message = pick(disturbing_messages)
	var/repetitions = rand(3, 6)

	var/list/parts = list()

	for(var/i in 1 to repetitions)
		parts += message

	return jointext(parts, "   ")



/datum/status_effect/fractal_maptext/proc/generate_center_pattern()
	var/list/lines = list()
	var/size = rand(3, 5)

	for(var/y in -size to size)
		var/list/line = list()

		for(var/x in -size to size)
			var/distance = sqrt(x * x + y * y)

			if(round(distance) % 2 == 0)
				line += pick(fractal_symbols)
			else
				line += " "

		lines += jointext(line, " ")

	return jointext(lines, "<br>")



/datum/status_effect/fractal_maptext/on_remove()
	for(var/atom/movable/screen/fullscreen/fractal_text/text_holder in active_texts)
		if(owner?.client)
			owner.client.screen -= text_holder

		qdel(text_holder)

	active_texts.Cut()

	return ..()


/datum/component/alien_examine
	var/intensity = 1
	var/atom/atom_owner = null

	var/examine_escalation_time = 5 SECONDS
	var/screen_effect_cooldown = 8 SECONDS

	var/list/examine_cooldowns = list()
	var/list/examine_counts = list()
	var/list/screen_cooldowns = list()

	var/static/list/fractal_messages = list(
		"The geometry of %OWNER% defies human comprehension.",
		"Something about %OWNER% appears fundamentally incorrect.",
		"Your eyes refuse to agree on the shape of %OWNER%.",
		"The object seems to occupy more space than it should.",
		"You briefly perceive %OWNER% from an impossible angle.",
		"The edges of %OWNER% do not meet where they are supposed to.",
		"You are certain %OWNER% was shaped differently a moment ago.",
		"The shape of %OWNER% repeats somewhere behind your vision.",
		"You cannot determine where %OWNER% begins.",
		"The geometry appears to continue somewhere it cannot possibly continue.",
		"Your mind attempts to simplify %OWNER%. It fails.",
		"The object seems to contain a pattern which your eyes cannot finish.",
		"For a moment, %OWNER% appears infinitely more complex.",
		"Your perception of %OWNER% slips for a fraction of a second.",
		"Something about %OWNER%'s shape feels recursively wrong."
	)

	var/static/list/fractal_intrusions = list(
		"You are looking at it.",
		"Look again.",
		"There is no center.",
		"It continues.",
		"You have already seen this.",
		"This shape is not finished.",
		"Do not follow the pattern.",
		"There is something behind it.",
		"Your eyes are lying to you.",
		"You should not be able to see this.",
		"It is looking back.",
		"The pattern is looking through you."
	)

	var/static/list/fractal_observations = list(
		"The description feels incomplete.",
		"The object appears slightly different each time you look at it.",
		"You notice a pattern you cannot describe.",
		"Your eyes momentarily lose track of its edges.",
		"The object's proportions seem subtly incorrect.",
		"You cannot tell whether the object is closer or farther away.",
		"Something about the perspective is wrong.",
		"The longer you look, the less certain its shape becomes."
	)

	var/static/list/fractal_corruption = list(
		"∞",
		"∴",
		"∵",
		"⟟",
		"⋮",
		"⟐",
		"⦿",
		"∷",
		"◌",
		"⟁",
		"̷",
		"̸",
		"̶",
		"͟",
		"͢",
		"҂"
	)

	var/static/list/low_effect_messages = list(
		"The geometry seems to shift slightly as you read it.",
		"You notice a pattern you cannot quite describe.",
		"The edges seem less certain than they should be.",
		"You feel strangely compelled to look again."
	)

	var/static/list/mid_effect_messages = list(
		"The shape seems to repeat at the edge of your vision.",
		"You are no longer entirely certain you are looking at the same object.",
		"Something about it feels familiar in a way it should not.",
		"The longer you stare, the less meaningful its shape becomes."
	)

	var/static/list/high_effect_messages = list(
		"The pattern repeats somewhere behind your thoughts.",
		"The object appears to contain more geometry than its surface permits.",
		"Your perception attempts to simplify the shape and repeatedly fails.",
		"You can no longer tell whether the object has one shape or many."
	)

	var/static/list/critical_messages = list(
		"YOUR MIND CANNOT RESOLVE ITS SHAPE.",
		"STOP LOOKING.",
		"THE PATTERN HAS NO TERMINATION.",
		"THERE IS NO CORRECT WAY TO PERCEIVE THIS."
	)

	var/static/list/extreme_messages = list(
		"The world briefly loses the distinction between inside and outside.",
		"For a moment, your perception no longer agrees with reality.",
		"You suddenly cannot tell whether you are observing the object or it is observing you."
	)

	var/static/list/eye_messages = list(
		"A piercing pressure blooms behind your eyes.",
		"The geometry suddenly becomes unbearably difficult to perceive.",
		"Your vision folds inward around %OWNER%.",
		"For a moment, every edge in the room points toward %OWNER%."
	)



/datum/component/alien_examine/Initialize(effects_intensity = 1)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	atom_owner = parent
	intensity = max(1, effects_intensity)



/datum/component/alien_examine/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_owner_examine))



/datum/component/alien_examine/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ATOM_EXAMINE)
	examine_cooldowns.Cut()
	examine_counts.Cut()
	screen_cooldowns.Cut()



/datum/component/alien_examine/proc/format_fractal_text(text)
	return replacetext(text, "%OWNER%", atom_owner.name)



/datum/component/alien_examine/proc/on_owner_examine(atom/source, mob/living/carbon/human/examiner, list/examine_text)
	SIGNAL_HANDLER

	if(!ishuman(examiner) || isobserver(examiner) || examiner.stat == DEAD)
		return

	var/ref_id = REF(examiner)
	var/last_time = examine_cooldowns[ref_id] || 0
	var/current_count = examine_counts[ref_id] || 0

	if(world.time - last_time <= examine_escalation_time)
		current_count++
	else
		current_count = max(1, current_count - 1)

	current_count = min(current_count, 8)

	examine_cooldowns[ref_id] = world.time
	examine_counts[ref_id] = current_count

	apply_examine_distortion(examine_text, current_count)

	INVOKE_ASYNC(src, PROC_REF(apply_fractal_effects), examiner, current_count)



/datum/component/alien_examine/proc/apply_examine_distortion(list/examine_text, count)
	if(!examine_text || !examine_text.len)
		return

	var/text

	if(count >= 1 && prob(55))
		text = format_fractal_text(pick(fractal_messages))
		examine_text += span_phobia(text)

	if(count == 1 && prob(30))
		text = pick(low_effect_messages)
		examine_text += span_notice(text)

	if(count >= 2 && prob(35))
		text = pick(fractal_intrusions)
		examine_text.Insert(rand(1, examine_text.len), span_hypnophrase(text))

	if(count >= 2 && prob(30))
		text = pick(mid_effect_messages)
		examine_text += span_phobia(text)

	if(count >= 3 && prob(40))
		text = format_fractal_text(pick(list(
			"%OWNER% does not appear to have a single shape.",
			"You cannot reconcile the different shapes of %OWNER%.",
			"%OWNER% seems to continue beyond its visible boundaries."
		)))
		examine_text.Insert(rand(1, examine_text.len), span_hypnophrase(text))

	if(count >= 3 && prob(30))
		text = pick("...", "Wait.", "No.", "That is not right.")
		examine_text.Insert(rand(1, examine_text.len), span_userdanger(text))

	if(count >= 4 && prob(40))
		var/index = rand(1, examine_text.len)
		var/line = examine_text[index]

		if(istext(line))
			examine_text[index] = corrupt_examine_line(line)

	if(count >= 4 && prob(40))
		text = format_fractal_text(pick(list(
			"The geometry of %OWNER% appears to change when you try to describe it.",
			"You feel as though %OWNER% is becoming more complex as you observe it.",
			"Your thoughts simplify %OWNER%, then immediately lose the result."
		)))
		examine_text += span_hypnophrase(text)

	if(count >= 5 && prob(50))
		text = generate_fractal_noise()
		examine_text.Insert(rand(1, examine_text.len), span_userdanger(text))

	if(count >= 5 && prob(45))
		text = "The description continues somewhere beyond the visible text."
		examine_text += span_warning(text)

	if(count >= 6 && prob(45))
		text = pick(critical_messages)
		examine_text += span_userdanger(text)

	if(count >= 6 && prob(40))
		text = generate_fractal_noise()
		examine_text.Insert(rand(1, examine_text.len), span_hypnophrase(text))

	if(count >= 7 && prob(55))
		text = format_fractal_text(pick(list(
			"%OWNER% %OWNER% %OWNER%.",
			"THE SHAPE IS REPEATING.",
			"YOU HAVE SEEN THIS BEFORE.",
			"YOU WILL SEE THIS AGAIN."
		)))
		examine_text += span_userdanger(text)

	if(count >= 7 && prob(35))
		text = generate_fractal_noise()
		examine_text.Insert(rand(1, examine_text.len), span_danger(text))



/datum/component/alien_examine/proc/corrupt_examine_line(text)
	if(!text)
		return text

	var/list/characters = splittext(text, "")
	var/corruption_count = max(1, round(characters.len * 0.06))

	for(var/i in 1 to corruption_count)
		var/index = rand(1, characters.len)
		characters[index] = pick(fractal_corruption)

	return jointext(characters, "")



/datum/component/alien_examine/proc/generate_fractal_noise()
	var/list/noise = list()
	var/length = rand(4, 10)

	for(var/i in 1 to length)
		noise += pick(fractal_corruption)

	return jointext(noise, " ")



/datum/component/alien_examine/proc/apply_fractal_effects(mob/living/carbon/human/H, count)
	if(!H || !atom_owner || !H.client)
		return

	var/intensity_multiplier = count * intensity

	if(count >= 1 && prob(50))
		shake_camera(H, min(2 + count, 10), 1)

		H.hallucination = max(H.hallucination, 20 * intensity_multiplier)

	if(count >= 2 && prob(35 + min(count * 5, 30)))
		H.blur_eyes(2 + round(count / 2))

	if(count >= 3)
		var/damage = count * 5 * intensity
		H.adjustStaminaLoss(damage * 1.5)

		if(prob(40 + min(count * 5, 30)))
			H.adjust_disgust(max(H.disgust, 10 + count * 2))

			var/eye_message = format_fractal_text(pick(eye_messages))
			to_chat(H, span_userdanger(eye_message))

	if(count >= 5)
		H.Paralyze(20)
		H.Knockdown(10)

		var/critical_message = pick(critical_messages)
		to_chat(H, span_userdanger(critical_message))

	if(count >= 7)
		if(prob(30))
			H.Stun(20)

		if(prob(25))
			H.Paralyze(30)

		var/extreme_message = pick(extreme_messages)
		to_chat(H, span_danger(extreme_message))

	apply_screen_effect(H, count)
	apply_maptext_effect(H, count)

/datum/component/alien_examine/proc/apply_maptext_effect(mob/living/carbon/human/H, count)
	if(!H || !H.client)
		return

	var/datum/status_effect/fractal_maptext/effect = H.has_status_effect(/datum/status_effect/fractal_maptext)

	if(!effect)
		effect = H.apply_status_effect(/datum/status_effect/fractal_maptext)

	if(!effect)
		return

	effect.intensity = clamp(count * 3, 1, 5)
	effect.duration = max(effect.duration, 6 SECONDS)


/datum/component/alien_examine/proc/apply_screen_effect(mob/living/carbon/human/H, count)
	if(!H || !H.client)
		return

	var/ref_id = REF(H)
	var/last_effect = screen_cooldowns[ref_id] || 0

	if(world.time - last_effect < screen_effect_cooldown)
		return

	screen_cooldowns[ref_id] = world.time

	var/datum/status_effect/fractal_screen/effect = H.has_status_effect(/datum/status_effect/fractal_screen)

	if(!effect)
		effect = H.apply_status_effect(/datum/status_effect/fractal_screen)

	if(!effect)
		return

	effect.infection_stage = clamp(ceil(count / 2), 1, 5)
	effect.play_effect()



/datum/component/alien_examine/Destroy(force)
	examine_cooldowns.Cut()
	examine_counts.Cut()
	screen_cooldowns.Cut()
	atom_owner = null

	return ..()
