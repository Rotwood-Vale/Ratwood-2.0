/*
 * The two ends of a fractal mutant's life.
 *
 * Kept apart from fractal_mutant.dm because none of this is what the mutant
 * *is* - it is how one arrives and how one leaves, and both are almost entirely
 * presentation. The infection turns its host into a mutant when it finally
 * kills them, and the host keeps playing as the thing they became.
 */

/// How long the body spends coming apart before the mutant appears.
#define FRACTAL_TRANSFORM_BUILDUP 4 SECONDS
/// How long the mutant takes to resolve into place afterwards.
#define FRACTAL_TRANSFORM_EMERGE 1.5 SECONDS
/// How long a dying mutant takes to fold up and go.
#define FRACTAL_DEATH_COLLAPSE 3 SECONDS

/// Guards against a body being transformed twice - death can fire more than once.
/mob/living
	var/fractal_transforming = FALSE

/**
 * Wipes the slate and gives the mutant its own kit back.
 *
 * mind.transfer_to() calls transfer_actions() and transfer_mindbound_actions(),
 * so everything the host was carrying follows them into the mutant. A cleric's
 * miracles have no business surviving being eaten.
 *
 * Rather than filter that against a list of what to keep, this takes every
 * action off and re-grants the mutant's own from inntacte_actions - the same
 * call its Initialize makes. That way there is no second copy of "what a mutant
 * has" to fall out of step with the real one, and an ability added to the mob
 * later is picked up here for free.
 */
/proc/fractal_strip_foreign_powers(mob/living/simple_animal/hostile/fractal_mutant/born, datum/mind/passenger)
	if(!istype(born))
		return

	// Mind spells travel with the mind rather than the body, so they have to be
	// taken off the mind itself. This also disposes of their action buttons.
	passenger?.RemoveAllSpells()

	// Everything goes, including what Initialize already granted - it comes
	// straight back below. Copied because Remove() mutates the list.
	for(var/datum/action/carried as anything in born.actions.Copy())
		carried.Remove(born)

	born.grant_actions_by_list(born.inntacte_actions)

/*
 * ---------------------------------------------------------------------------
 * Infection: the host becomes the thing
 * ---------------------------------------------------------------------------
 */

/datum/status_effect/fractal_infection
	/// Lowest stage that still leaves a mutant behind. Raise it if early
	/// infections should just kill.
	var/transform_min_stage = 4

/datum/status_effect/fractal_infection/on_creation(mob/living/new_owner, ...)
	. = ..()
	// on_apply is already taken further up this type, so the death hook is
	// registered here instead. Both run once, at the same point in the effect's
	// life, so it makes no practical difference which one carries it.
	if(owner)
		RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(on_owner_death))

/datum/status_effect/fractal_infection/proc/on_owner_death(mob/living/source, gibbed)
	SIGNAL_HANDLER

	if(gibbed || infection_stage < transform_min_stage)
		return
	// Handed to a global proc rather than run on the datum: this effect is
	// removed partway through, when the old body goes, and the sequence has to
	// outlive it.
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(fractal_transform), source)

/**
 * Turns a corpse into a fractal mutant, over a few seconds of coming apart.
 *
 * Deliberately not instant. The body distorts, folds in on itself and bursts
 * before anything new is there, so it reads as one thing becoming another
 * rather than a swap. If the body had someone in it, they wake up in the mutant.
 */
/proc/fractal_transform(mob/living/victim)
	set waitfor = FALSE

	if(QDELETED(victim) || victim.fractal_transforming)
		return
	var/turf/ground = get_turf(victim)
	if(!ground)
		return
	victim.fractal_transforming = TRUE

	victim.visible_message(
		span_userdanger("[victim]'s body begins to fold into shapes that hurt to follow!"),
		span_userdanger("Something vast unfolds itself through me..."),
	)
	playsound(ground, 'modular_fenysha_events/sound/fractal_scream1.ogg', 90, TRUE)

	// The same wave the mutant carries, wound up from nothing so the body looks
	// like it is being pulled into the mutant's geometry.
	victim.add_filter("fractal_becoming", 2, list("type" = "wave", "size" = 1, "x" = 6, "y" = 6, "offset" = 0))
	var/becoming = victim.get_filter("fractal_becoming")
	if(becoming)
		animate(becoming, size = 6, offset = 60, time = FRACTAL_TRANSFORM_BUILDUP, flags = ANIMATION_PARALLEL)

	var/matrix/swelling = matrix(victim.transform)
	swelling.Scale(1.35, 0.6)
	animate(victim, transform = swelling, color = COLOR_ASSEMBLY_PURPLE, time = FRACTAL_TRANSFORM_BUILDUP, easing = SINE_EASING, flags = ANIMATION_PARALLEL)

	// Afterimages while it comes apart, so the shape smears instead of stretching.
	for(var/i in 1 to 5)
		if(QDELETED(victim))
			return
		new /obj/effect/temp_visual/decoy/fading/halfsecond(get_turf(victim), victim)
		sleep(FRACTAL_TRANSFORM_BUILDUP / 5)

	if(QDELETED(victim))
		return
	ground = get_turf(victim) || ground

	playsound(ground, 'modular_fenysha_events/sound/fractal_scream2.ogg', 100, TRUE)
	new /obj/effect/gibspawner/human(ground)

	var/mob/living/simple_animal/hostile/fractal_mutant/born = new(ground)
	born.alpha = 0
	var/matrix/folded = matrix(born.transform)
	folded.Scale(0.35, 1.6)
	born.transform = folded
	animate(born, alpha = 255, transform = matrix(), time = FRACTAL_TRANSFORM_EMERGE, easing = BACK_EASING)

	// Carry the player across before the old body goes, so nobody is dropped
	// into observer limbo on the way.
	var/datum/mind/passenger = victim.mind
	if(passenger)
		passenger.transfer_to(born)
		fractal_strip_foreign_powers(born, passenger)
		to_chat(born, span_userdanger("Your mind is not your own."))
		to_chat(born, span_boldannounce("The thoughts you are thinking arrive in a shape you have no word for, \
			and they are not translated for you - you simply understand them, the way you understand falling. \
			Whatever was using your name has finished with it."))

	qdel(victim)

/*
 * ---------------------------------------------------------------------------
 * Mutant: the thing stops
 * ---------------------------------------------------------------------------
 */

/mob/living/simple_animal/hostile/fractal_mutant
	/*
	 * The icon carries a single state, so the inherited death() - which assigns
	 * icon_state = icon_dead - was blanking the sprite outright and the corpse
	 * vanished on the spot. Pointing it back at the living state keeps something
	 * on screen for collapse() to animate away.
	 */
	icon_dead = "fractal_mutant"

/mob/living/simple_animal/hostile/fractal_mutant/death(gibbed)
	. = ..()
	if(gibbed || QDELETED(src))
		return
	INVOKE_ASYNC(src, PROC_REF(collapse))

/// Folds the mutant up and takes it away, rather than leaving a blank tile.
/mob/living/simple_animal/hostile/fractal_mutant/proc/collapse()
	set waitfor = FALSE

	playsound(get_turf(src), pick(scream_sounds), 100, TRUE)

	// Wind the idle wave up as it goes, so it comes apart along the same lines
	// it was always made of.
	var/unravelling = get_filter("fractal_wave")
	if(unravelling)
		animate(unravelling, size = 12, offset = 200, time = FRACTAL_DEATH_COLLAPSE, flags = ANIMATION_PARALLEL)

	// Not parallel: this replaces the idle pulse rather than fighting it.
	var/matrix/folding = matrix()
	folding.Scale(1.4, 0.05)
	animate(src, transform = folding, alpha = 0, color = "#000000", time = FRACTAL_DEATH_COLLAPSE, easing = CIRCULAR_EASING)

	for(var/i in 1 to 4)
		if(QDELETED(src))
			return
		new /obj/effect/temp_visual/decoy/fading/halfsecond(get_turf(src), src)
		sleep(FRACTAL_DEATH_COLLAPSE / 4)

	if(QDELETED(src))
		return
	new /obj/effect/gibspawner/human(get_turf(src))
	qdel(src)

#undef FRACTAL_TRANSFORM_BUILDUP
#undef FRACTAL_TRANSFORM_EMERGE
#undef FRACTAL_DEATH_COLLAPSE
