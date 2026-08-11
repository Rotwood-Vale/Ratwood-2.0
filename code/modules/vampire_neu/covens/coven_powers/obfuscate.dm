#define COMBAT_COOLDOWN_LENGTH 45 SECONDS
#define REVEAL_COOLDOWN_LENGTH 15 SECONDS
#define OBFUSCATE_ALPHA 10
#define OBFUSCATE_FADE_TIME 0.5 SECONDS

/datum/coven/obfuscate
	name = "Obfuscate"
	desc = "Makes you less noticeable to living and unliving beings."
	icon_state = "obfuscate"
	power_type = /datum/coven_power/obfuscate

/datum/coven_power/obfuscate
	name = "Obfuscate power name"
	desc = "Obfuscate power description"
	duration_length = 0.5 MINUTES

	var/static/list/aggressive_signals = list(
		COMSIG_MOB_ATTACK_HAND,
		COMSIG_ATOM_HITBY,
		COMSIG_ATOM_ATTACK_HAND,
		COMSIG_ATOM_ATTACKBY,
	)

/datum/coven_power/obfuscate/proc/on_combat_signal(datum/source)
	SIGNAL_HANDLER

	to_chat(owner, span_danger("Your Obfuscate falls away as you reveal yourself!"))
	try_deactivate(direct = TRUE)

	deltimer(cooldown_timer)
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), COMBAT_COOLDOWN_LENGTH, TIMER_STOPPABLE)

/datum/coven_power/obfuscate/proc/conceal(mob/living/target)
	if (!target)
		return

	RegisterSignal(target, COMSIG_LIVING_DEATH, PROC_REF(on_concealed_death), override = TRUE)
	animate(target, alpha = OBFUSCATE_ALPHA, time = OBFUSCATE_FADE_TIME)

/datum/coven_power/obfuscate/proc/unconceal(mob/living/target)
	if (!target)
		return

	UnregisterSignal(target, COMSIG_LIVING_DEATH)
	animate(target, alpha = initial(target.alpha), time = OBFUSCATE_FADE_TIME)

/datum/coven_power/obfuscate/proc/on_concealed_death(mob/living/source)
	SIGNAL_HANDLER

	if (source == owner)
		try_deactivate(direct = TRUE)
	else
		unconceal(source)

/datum/coven_power/obfuscate/proc/is_seen_check()
	for (var/mob/living/viewer in oviewers(7, owner))
		//cats cannot stop you from Obfuscating
		if (!istype(viewer, /mob/living/carbon) && !viewer.client)
			continue

		//the corpses are not watching you
		if (HAS_TRAIT(viewer, TRAIT_BLIND) || viewer.stat >= UNCONSCIOUS)
			continue

		if (owner.is_clanmate(viewer))
			continue

		to_chat(owner, span_warning("You cannot use [src] while you're being observed!"))
		return FALSE

	return TRUE

//CLOAK OF SHADOWS - Basic stealth, broken by movement
/datum/coven_power/obfuscate/cloak_of_shadows
	name = "Cloak of Shadows"
	desc = "Meld into the shadows and stay unnoticed so long as you draw no attention. Broken by any movement."

	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_CAPABLE
	vitae_cost = 25
	research_cost = 0

	toggled = TRUE

/datum/coven_power/obfuscate/cloak_of_shadows/pre_activation_checks()
	. = ..()
	if(!.)
		return FALSE
	return is_seen_check()

/datum/coven_power/obfuscate/cloak_of_shadows/activate()
	. = ..()
	RegisterSignal(owner, aggressive_signals, PROC_REF(on_combat_signal), override = TRUE)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))

	conceal(owner)

/datum/coven_power/obfuscate/cloak_of_shadows/deactivate()
	. = ..()
	UnregisterSignal(owner, aggressive_signals)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	unconceal(owner)

/datum/coven_power/obfuscate/cloak_of_shadows/proc/handle_move(datum/source, atom/moving_thing, dir)
	SIGNAL_HANDLER

	to_chat(owner, span_danger("Your [src] falls away as you move from your position!"))
	try_deactivate(direct = TRUE)

	deltimer(cooldown_timer)
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), REVEAL_COOLDOWN_LENGTH, TIMER_STOPPABLE)

//UNSEEN PRESENCE - Can move while stealthed, but only walking speed
/datum/coven_power/obfuscate/unseen_presence
	name = "Unseen Presence"
	desc = "Move among the crowds without ever being noticed. Achieve invisibility while walking."

	level = 2
	research_cost = 1
	check_flags = COVEN_CHECK_CAPABLE
	vitae_cost = 25

	toggled = TRUE

/datum/coven_power/obfuscate/unseen_presence/activate()
	. = ..()
	RegisterSignal(owner, aggressive_signals, PROC_REF(on_combat_signal), override = TRUE)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))

	conceal(owner)

/datum/coven_power/obfuscate/unseen_presence/deactivate()
	. = ..()
	UnregisterSignal(owner, aggressive_signals)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	unconceal(owner)

/datum/coven_power/obfuscate/unseen_presence/proc/handle_move(datum/source, atom/moving_thing, dir)
	SIGNAL_HANDLER

	if (owner.m_intent == MOVE_INTENT_RUN)
		to_chat(owner, span_danger("Your [src] falls away as you move too quickly!"))
		try_deactivate(direct = TRUE)

		deltimer(cooldown_timer)
		cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), REVEAL_COOLDOWN_LENGTH, TIMER_STOPPABLE)

//VANISH FROM THE MIND'S EYE - Instant stealth activation + memory wipe
/datum/coven_power/obfuscate/vanish_from_the_minds_eye
	name = "Vanish from the Mind's Eye"
	desc = "Disappear from plain view instantly, and wipe your presence from recent memory."

	level = 3
	research_cost = 2
	vitae_cost = 100
	check_flags = COVEN_CHECK_CAPABLE

	toggled = TRUE

/datum/coven_power/obfuscate/vanish_from_the_minds_eye/activate()
	. = ..()
	RegisterSignal(owner, aggressive_signals, PROC_REF(on_combat_signal), override = TRUE)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))

	conceal(owner)

	// Memory wipe effect - make nearby people forget they saw you
	for(var/mob/living/carbon/human/viewer in oviewers(7, owner))
		if(viewer.client && viewer.stat < UNCONSCIOUS)
			to_chat(viewer, span_hypnophrase("Wait... wasn't someone just here? No, must be my imagination..."))
			// Could add more memory effects here like removing recent chat logs mentioning the user

/datum/coven_power/obfuscate/vanish_from_the_minds_eye/deactivate()
	. = ..()
	UnregisterSignal(owner, aggressive_signals)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	unconceal(owner)

/datum/coven_power/obfuscate/vanish_from_the_minds_eye/proc/handle_move(datum/source, atom/moving_thing, dir)
	SIGNAL_HANDLER

	if (owner.m_intent == MOVE_INTENT_RUN)
		to_chat(owner, span_danger("Your [src] falls away as you move too quickly!"))
		try_deactivate(direct = TRUE)

		deltimer(cooldown_timer)
		cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), REVEAL_COOLDOWN_LENGTH, TIMER_STOPPABLE)

//CLOAK THE GATHERING - Group stealth for multiple people
/datum/coven_power/obfuscate/cloak_the_gathering
	name = "Cloak the Gathering"
	desc = "Hide yourself and others in a small area. All nearby allies become invisible."

	level = 4
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE
	vitae_cost = 150

	toggled = TRUE

	var/list/cloaked_mobs = list()

/datum/coven_power/obfuscate/cloak_the_gathering/pre_activation_checks()
	. = ..()
	if(!.)
		return FALSE
	return is_seen_check()

/datum/coven_power/obfuscate/cloak_the_gathering/activate()
	. = ..()
	RegisterSignal(owner, aggressive_signals, PROC_REF(on_combat_signal), override = TRUE)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))

	conceal(owner)
	cloaked_mobs = list(owner)

	// Cloak nearby Clan - the veil is not extended to cattle or rivals
	for(var/mob/living/target in oviewers(3, owner))
		if(target.stat >= UNCONSCIOUS)
			continue
		if(!target.is_clanmate(owner))
			continue

		conceal(target)
		cloaked_mobs += target
		to_chat(target, span_notice("You feel a supernatural veil fall over you..."))
		RegisterSignal(target, aggressive_signals, PROC_REF(on_ally_combat_signal), override = TRUE)

	to_chat(owner, span_notice("You extend your cloak to [length(cloaked_mobs) - 1] nearby allies."))

/datum/coven_power/obfuscate/cloak_the_gathering/deactivate()
	. = ..()
	UnregisterSignal(owner, aggressive_signals)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	// Restore visibility to all cloaked mobs
	for(var/mob/living/target in cloaked_mobs)
		unconceal(target)
		UnregisterSignal(target, aggressive_signals)
		if(target != owner)
			to_chat(target, span_warning("The supernatural veil fades away..."))

	cloaked_mobs.Cut()

/datum/coven_power/obfuscate/cloak_the_gathering/proc/handle_move(datum/source, atom/moving_thing, dir)
	SIGNAL_HANDLER

	to_chat(owner, span_danger("Your [src] falls away as you move from your position!"))
	try_deactivate(direct = TRUE)

	deltimer(cooldown_timer)
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), REVEAL_COOLDOWN_LENGTH, TIMER_STOPPABLE)

/datum/coven_power/obfuscate/cloak_the_gathering/proc/on_ally_combat_signal(datum/source)
	SIGNAL_HANDLER

	var/mob/living/ally = source
	to_chat(ally, span_danger("Your actions break the supernatural veil!"))

	// Remove this ally from the cloak
	unconceal(ally)
	UnregisterSignal(ally, aggressive_signals)
	cloaked_mobs -= ally

/datum/coven_power/obfuscate/cloak_the_gathering/on_concealed_death(mob/living/source)

	cloaked_mobs -= source
	return ..()

#undef COMBAT_COOLDOWN_LENGTH
#undef REVEAL_COOLDOWN_LENGTH
#undef OBFUSCATE_ALPHA
#undef OBFUSCATE_FADE_TIME
