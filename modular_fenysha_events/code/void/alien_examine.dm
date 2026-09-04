/datum/component/alien_examine
	var/intensity = 1
	var/atom/atom_owner = null
	
	var/list/examine_cooldowns = list()
	var/list/examine_counts = list()

/datum/component/alien_examine/Initialize(effects_intensity = 1)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	atom_owner = parent
	intensity = effects_intensity

/datum/component/alien_examine/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_owner_examine))

/datum/component/alien_examine/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ATOM_EXAMINE)
	examine_cooldowns.Cut()
	examine_counts.Cut()

/datum/component/alien_examine/proc/on_owner_examine(atom/source, mob/living/carbon/human/examiner, list/examine_text)
	SIGNAL_HANDLER

	if(!ishuman(examiner) || isobserver(examiner))
		return

	var/ref_id = REF(examiner)
	var/last_time = examine_cooldowns[ref_id] || 0
	var/current_count = examine_counts[ref_id] || 0

	if(world.time - last_time < 5 SECONDS)
		current_count++
	else
		current_count = max(1, current_count - 1)

	examine_cooldowns[ref_id] = world.time
	examine_counts[ref_id] = current_count
	INVOKE_ASYNC(src, PROC_REF(apply_fractal_effects), examiner, current_count, examine_text)

/datum/component/alien_examine/proc/apply_fractal_effects(mob/living/carbon/human/H, count, list/examine_text)
	if(count >= 1)
		examine_text += span_phobia("The geometry of [atom_owner.name] defies human comprehension...")
	
	if(H.client)
		shake_camera(H, 2 * count, 1)
		H.hallucination = max(H.hallucination, 20 * count * intensity)
		to_chat(H, span_userdanger("[pick("A fractal ringing echoes in your ears...", "The space around the object strains your eyes!", "Your thoughts twist into non-Euclidean knots...")]"))


	if(count >= 3)
		var/damage = (count * 5) * intensity
		H.adjust_blindness(damage)
		H.adjustStaminaLoss(damage * 1.5)

		if(prob(40))
			H.blur_eyes(3)
			H.adjust_disgust(max(H.disgust, 10))
			to_chat(H, span_userdanger("Staring at [atom_owner] triggers a piercing migraine!"))

	if(count >= 5)
		H.Paralyze(20)
		H.Knockdown(10)
		to_chat(H, span_userdanger("YOUR MIND CANNOT COMPREHEND THIS!"))
