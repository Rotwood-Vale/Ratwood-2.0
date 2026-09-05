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
	/// Purely visual, so no HUD alert - the base alert would show "Curse of Mundanity".
	alert_type = null

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

	/// Minimum gap between escalations, per examiner. Kept under
	/// examine_escalation_time so a player looking at the honest pace still climbs.
	var/examine_effect_cooldown = 3 SECONDS

	var/list/examine_cooldowns = list()
	var/list/examine_counts = list()
	var/list/screen_cooldowns = list()
	var/list/effect_cooldowns = list()

	/// Per-examiner layout seed. See seed_pattern().
	var/list/examine_seeds = list()

	/// Line effect class -> the examine count that unlocks it. Drawn without
	/// replacement, so a single block never shows the same distortion twice.
	var/static/list/line_effects = list(
		"fractal_echo" = 1,
		"fractal_depth" = 2,
		"fractal_anaglyph" = 3,
		"fractal_echo_sym" = 4,
		"fractal_depth_grow" = 4,
		"fractal_squeeze" = 5,
		"fractal_anaglyph_live" = 5,
		"fractal_noise" = 6,
		"fractal_noise_hard" = 7
	)

	/// Effects that paint through attr(data-text). They cannot wrap a line
	/// containing markup, so they only ever land on lines this component wrote.
	var/static/list/plaintext_effects = list(
		"fractal_noise",
		"fractal_noise_hard"
	)

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

	/// Fires from two sites and lands in userdanger, so it needs the depth to not
	/// repeat inside one encounter. Runs through format_fractal_text().
	var/static/list/critical_messages = list(
		"YOUR MIND CANNOT RESOLVE ITS SHAPE.",
		"STOP LOOKING.",
		"THE PATTERN HAS NO TERMINATION.",
		"THERE IS NO CORRECT WAY TO PERCEIVE THIS.",
		"YOU ARE COUNTING SOMETHING THAT DOES NOT END.",
		"%OWNER% WAS NEVER ONE OBJECT.",
		"EVERY EDGE IN THIS ROOM LEADS BACK TO IT.",
		"THERE IS NO ANGLE THAT MAKES THIS CORRECT.",
		"YOUR EYES HAVE AGREED ON SOMETHING FALSE.",
		"IT HAS ALREADY FINISHED LOOKING AT YOU.",
		"THE GEOMETRY HAS YOUR NAME IN IT.",
		"%OWNER% IS NOT WHERE YOU ARE LOOKING.",
		"YOU HAVE BEEN LOOKING LONGER THAN YOU THINK.",
		"THE INSIDE IS LARGER AND YOU ARE IN IT.",
		"SOMETHING HAS COUNTED YOU.",
		"THIS IS THE PART YOU WILL FORGET.",
		"YOU WILL NOT REMEMBER LOOKING AWAY.",
		"IT IS STILL UNFOLDING BEHIND YOUR EYES.",
		"NOTHING HERE HAS AGREED TO HAVE A SHAPE.",
		"YOU CANNOT PUT IT DOWN. YOU NEVER PICKED IT UP."
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
	effect_cooldowns.Cut()
	examine_seeds.Cut()



/datum/component/alien_examine/proc/format_fractal_text(text)
	return replacetext(text, "%OWNER%", atom_owner.name)



/datum/component/alien_examine/proc/on_owner_examine(atom/source, mob/living/carbon/human/examiner, list/examine_text)
	SIGNAL_HANDLER

	if(!ishuman(examiner) || isobserver(examiner) || examiner.stat == DEAD)
		return

	var/ref_id = REF(examiner)
	var/last_time = examine_cooldowns[ref_id] || 0
	var/last_effect = effect_cooldowns[ref_id]
	var/current_count = examine_counts[ref_id] || 0

	// Re-examining inside the cooldown still returns a distorted description, but it
	// neither climbs the counter nor fires anything at the examiner - clicking faster
	// must not buy a faster escalation.
	var/rate_limited = last_effect && (world.time - last_effect < examine_effect_cooldown)

	if(world.time - last_time <= examine_escalation_time)
		if(!rate_limited)
			current_count++
	else
		current_count = max(1, current_count - 1)

	current_count = min(current_count, 8)

	examine_cooldowns[ref_id] = world.time
	examine_counts[ref_id] = current_count

	apply_examine_distortion(examine_text, current_count, examiner)

	if(rate_limited)
		return

	effect_cooldowns[ref_id] = world.time

	INVOKE_ASYNC(src, PROC_REF(apply_fractal_effects), examiner, current_count)



/**
 * Rebuilds the examine as a layered composition rather than a pile of independent
 * rolls. Four passes, in order:
 *
 * 1. Content - the intrusive lines are written into the description.
 * 2. Grammar - at most one visual effect per line, drawn without replacement, so a
 *    single block never shows the same distortion twice.
 * 3. Focus - depth of field assigned by line position rather than by chance.
 * 4. Frame - wrapper classes on the box itself.
 *
 * Lines this component wrote are tracked against their unstyled text, because the
 * effects that render through attr(data-text) cannot wrap a line containing markup.
 */
/datum/component/alien_examine/proc/apply_examine_distortion(list/examine_text, count, mob/living/carbon/human/examiner)
	if(!length(examine_text))
		return

	var/seeded = seed_pattern(examiner, count)

	var/list/authored = list()
	var/list/effected = list()

	insert_fractal_content(examine_text, count, authored)
	compose_lines(examine_text, count, authored, effected)
	apply_depth_of_field(examine_text, count, effected)
	wrap_fractal_block(examine_text, count, examiner)

	if(seeded)
		rand_seed(world.timeofday + world.time)



/**
 * Below count 4 the layout is generated from a seed stored per examiner, so looking
 * again renders a byte-identical block - the object has not changed, and the component's
 * own "YOU HAVE SEEN THIS BEFORE" is literally true. From count 4 the seed is dropped
 * and every look composes differently, which is the point at which the object stops
 * being a fixed thing. Returns TRUE if the global RNG needs restoring afterwards.
 */
/datum/component/alien_examine/proc/seed_pattern(mob/examiner, count)
	if(count >= 4)
		return FALSE

	var/ref_id = REF(examiner)

	if(!examine_seeds[ref_id])
		examine_seeds[ref_id] = rand(1, 32767)

	rand_seed(examine_seeds[ref_id])
	return TRUE



/// Writes the intrusive lines. Each is recorded against its unstyled text in `authored`,
/// marking it safe for the effects that need a plain copy of the line.
/datum/component/alien_examine/proc/insert_fractal_content(list/examine_text, count, list/authored)
	var/list/queued = list()

	// Body lines all share one voice, chosen per block. Mixing phobia red, notice
	// yellow and warning orange inside a single examine is a colour pile, not dread.
	var/body_voice = prob(50) ? "phobia" : "notice"
	var/body_budget = count >= 5 ? 2 : 1

	var/list/body_pool = fractal_messages.Copy()

	switch(count)
		if(1 to 2)
			body_pool += low_effect_messages
		if(3 to 4)
			body_pool += mid_effect_messages
		else
			body_pool += high_effect_messages
			body_pool += "The description continues somewhere beyond the visible text."

	for(var/i in 1 to body_budget)
		if(!length(body_pool))
			break

		var/picked = pick(body_pool)
		body_pool -= picked

		var/text = format_fractal_text(picked)
		queued[apply_voice(text, body_voice)] = text

	// Exactly one accent line on top of the body, never two. A critical outranks the
	// hypnotic intrusion rather than stacking with it.
	if(count >= 6)
		var/text = format_fractal_text(pick(critical_messages))
		queued[span_userdanger(text)] = text

	else if(count >= 3 && prob(45))
		var/text = count >= 5 && prob(30) ? generate_fractal_noise() : pick(fractal_intrusions)
		queued[span_hypnophrase(text)] = text

	for(var/line in queued)
		authored[line] = queued[line]

		if(length(examine_text) > 1 && prob(50))
			examine_text.Insert(rand(2, length(examine_text)), line)
		else
			examine_text += line



/// Assigns effects against a deliberately small budget: one distorted line below
/// count 5 and two above it, plus at most two lines taking the quieter alphabet
/// degrade. Never more, however high the count climbs - a block where every line is
/// doing something reads as noise, and the reader stops hunting for what changed.
/// Escalation past this point is carried by the frame and by which effects unlock,
/// not by how many fire at once. Effects are drawn without replacement, and no line
/// ever takes two.
/datum/component/alien_examine/proc/compose_lines(list/examine_text, count, list/authored, list/effected)
	var/list/pool = build_effect_pool(count)
	var/list/spent = list()

	var/effect_budget = count >= 5 ? 2 : 1
	var/degrade_budget = clamp(round(count / 3), 0, 2)

	for(var/i in 1 to effect_budget)
		if(!length(pool))
			break

		var/index = pick_unused_line(examine_text, spent)
		if(!index)
			break

		var/line = examine_text[index]
		var/plain = authored[line]
		var/effect = pick(pool)

		if(!plain && (effect in plaintext_effects))
			var/list/safe = pool - plaintext_effects
			if(!length(safe))
				continue
			effect = pick(safe)

		pool -= effect
		spent += index
		effected += index
		examine_text[index] = wrap_effect(line, effect, plain)

	for(var/i in 1 to degrade_budget)
		var/index = pick_unused_line(examine_text, spent)
		if(!index)
			break

		spent += index
		examine_text[index] = degrade_line(examine_text[index], count)



/// The body voice is picked once per block, so every body line shares it.
/datum/component/alien_examine/proc/apply_voice(text, voice)
	if(voice == "notice")
		return span_notice(text)

	return span_phobia(text)



/// Effect classes unlocked at this count.
/datum/component/alien_examine/proc/build_effect_pool(count)
	var/list/pool = list()

	for(var/effect in line_effects)
		if(count >= line_effects[effect])
			pool += effect

	return pool



/// A line index nothing has claimed yet, or null if the block is full.
/datum/component/alien_examine/proc/pick_unused_line(list/examine_text, list/spent)
	var/list/free = list()

	for(var/index in 1 to length(examine_text))
		if(index in spent)
			continue

		if(istext(examine_text[index]))
			free += index

	if(!length(free))
		return null

	return pick(free)



/// The interference effects paint clipped copies of the line through attr(data-text),
/// so they need the text a second time with the markup stripped back out.
/datum/component/alien_examine/proc/wrap_effect(text, effect, plain)
	if(plain && (effect in plaintext_effects))
		return "<span class='[effect]' data-text='[html_encode(plain)]'>[text]</span>"

	return "<span class='[effect]'>[text]</span>"



/// Focus is positional, never random: the outer lines of the block sit off the focal
/// plane and the middle stays sharp, so the examine reads as having depth instead of
/// being a flat list. Skips interference lines, which want to stay crisp.
/datum/component/alien_examine/proc/apply_depth_of_field(list/examine_text, count, list/effected)
	if(count < 3)
		return

	var/last = length(examine_text)

	if(last < 4)
		return

	blur_line(examine_text, 1, "fractal_far", effected)
	blur_line(examine_text, last, "fractal_far", effected)

	if(count < 5)
		return

	blur_line(examine_text, 2, "fractal_near", effected)
	blur_line(examine_text, last - 1, "fractal_near", effected)



/// Never blurs a line that already carries an effect - softening an anaglyph or an
/// extrusion just makes both illegible.
/datum/component/alien_examine/proc/blur_line(list/examine_text, index, class, list/effected)
	var/line = examine_text[index]

	if(!istext(line) || (index in effected))
		return

	examine_text[index] = "<span class='[class]'>[line]</span>"



/// Swaps whole words into the abyssal alphabet. Word length, spacing and punctuation
/// all survive, so the sentence stays visibly a sentence and the reader can see exactly
/// how much is being withheld - which character substitution destroys.
/datum/component/alien_examine/proc/degrade_line(text, count)
	if(!text || count < 2)
		return text

	var/chance = min(count * 3, 22)
	var/list/words = splittext(text, " ")
	var/degraded = FALSE

	for(var/i in 1 to length(words))
		var/word = words[i]

		if(!length(word) || findtext(word, "<") || findtext(word, ">"))
			continue

		if(!prob(chance))
			continue

		words[i] = "<span class='fractal_glyph'>[word]</span>"
		degraded = TRUE

	return degraded ? jointext(words, " ") : text



/// The frame escalates on its own track: tilt, then a drifting ground, then corner
/// glyphs, scanlines, and finally a doubled border that will not hold still. The box
/// is core's .examine_block, restyled through :has() on these classes rather than by
/// touching the core stylesheet.
///
/// Skipped for players who turned examine blocks off - there is no box to line up with,
/// and the wrapper's negative margins assume the block's padding is there to cancel.
/datum/component/alien_examine/proc/wrap_fractal_block(list/examine_text, count, mob/examiner)
	if(count < 2 || examiner?.client?.prefs?.no_examine_blocks)
		return

	var/list/classes = list("fractal_examine", "fractal_askew")

	if(count >= 3)
		classes += "fractal_drift"

	if(count >= 4)
		classes += "fractal_corners"

	if(count >= 5)
		classes += "fractal_scan"

	if(count >= 6)
		classes += "fractal_deep"

	examine_text.Insert(1, "<div class='[jointext(classes, " ")]'>")
	examine_text += "</div>"



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
	SEND_SOUND(H, pick(list('modular_fenysha_events/sound/fractal_glitch1.ogg', 'modular_fenysha_events/sound/fractal_glitch2.ogg')))

	if(count >= 1 && prob(50))
		shake_camera(H, min(2 + count, 10), 1)

		H.hallucination = max(H.hallucination, 5 * intensity_multiplier)

	if(count >= 2 && prob(35 + min(count * 5, 30)))
		H.blur_eyes(2 + round(count / 2))

	if(count >= 3)
		var/damage = count * 5 * intensity
		H.adjustStaminaLoss(damage * 1.5)

		if(prob(40 + min(count * 5, 30)))
			H.set_disgust(max(H.disgust, 10 + count * 2))

			var/eye_message = format_fractal_text(pick(eye_messages))
			to_chat(H, span_userdanger(eye_message))

	if(count >= 5)
		H.Paralyze(20)
		H.Knockdown(10)

		var/critical_message = format_fractal_text(pick(critical_messages))
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




/datum/component/alien_examine/Destroy(force)
	examine_cooldowns.Cut()
	examine_counts.Cut()
	screen_cooldowns.Cut()
	effect_cooldowns.Cut()
	examine_seeds.Cut()
	atom_owner = null

	return ..()
