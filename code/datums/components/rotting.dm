// DEAD_TO_ZOMBIE_TIME lives in __DEFINES/mobs.dm, the ghost lock in observer.dm uses it too

/datum/component/rot
	var/amount = 0
	var/last_process = 0
	/// Whether this corpse has flies. Heard only while it lies on a turf, see place_flies()
	var/flies_playing = FALSE

/datum/component/rot/Initialize(new_amount)
	..()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	if(new_amount)
		amount = new_amount

	START_PROCESSING(SSroguerot, src)

/datum/component/rot/Destroy()
	set_flies(FALSE)
	. = ..()

/**
 * Registers or drops this corpse as the buzzing-flies ambience source.
 *
 * POINT AMBIENCE, not a sound token. A token re-sends every listener for every source whenever
 * either moves, so ten bodies at a battle site with ten people among them is a hundred pairs per
 * step, measured at ~30x this and landing on the ticks a fight already loads. Point ambience serves
 * only the nearest, so ten corpses are one send and nine range rejects.
 *
 * Gated on SIZE, not biotype: a rat earns flies and a butterfly does not. `rot_type` defaults to
 * /rot/simple on every /mob/living that does not set its own, so without that gate every dead
 * cockroach becomes a registered source. A non-mob parent falls through, though nothing attaches
 * rot to one.
 *
 * Arguments:
 * * state - TRUE registers the source, FALSE drops it. TRUE is downgraded to FALSE for a mob at or
 *   under MOB_SIZE_TINY, so a caller cannot force flies onto a butterfly.
 */
/datum/component/rot/proc/set_flies(state)
	if(state)
		var/mob/living/rotting_mob = parent
		if(istype(rotting_mob) && rotting_mob.mob_size <= MOB_SIZE_TINY)
			state = FALSE
	// The rot poll asks every process, so only a change of state does anything here
	if(!state == !flies_playing)
		return
	flies_playing = state
	if(!state)
		UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
		SSpoint_ambience.unregister_source(parent, /datum/point_ambience_category/rot)
		return
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_body_moved))
	place_flies()

/datum/component/rot/proc/on_body_moved(datum/source)
	SIGNAL_HANDLER
	place_flies()

/**
 * Where the flies are heard, from the body's own moves.
 *
 * A body lying on a turf is heard from it, and the step it is dragged or carried moves the sound
 * with it.
 *
 * A body inside something, a cart or a sack, is silent. Moving the container fires no Moved on the
 * body, so its position could not be kept, and a sealed container is a fair reason for no flies.
 * The body's own Moved fires on the way in and on the way out, so it is heard again once it lies on
 * a turf, with nothing polled in between
 */
/datum/component/rot/proc/place_flies()
	var/atom/movable/body = parent
	if(isturf(body.loc))
		SSpoint_ambience.register_source(parent, /datum/point_ambience_category/rot)
	else
		SSpoint_ambience.unregister_source(parent, /datum/point_ambience_category/rot)

/datum/component/rot/process()

	var/amt2add = 10 // 1 Second. Base increment.
	var/current_time = world.time

	// time elapsed since the last rot/process
	var/elapsed_time = last_process ? (current_time - last_process) : 0
	last_process = current_time

	// Add amount based on the time elapsed. This is used to calculate when to wake/decompose
	amount += (elapsed_time / 10) * amt2add

	return

/datum/component/rot/corpse/Initialize()
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
/*
	ZOMBIFICATION
*/
/datum/component/rot/corpse/process()
	var/time_elapsed = last_process ? (world.time - last_process)/10 : 1
	..()
	if(has_world_trait(/datum/world_trait/pestra_mercy))
		amount -= 5 * time_elapsed

	var/mob/living/carbon/C = parent
	var/is_zombie
	if(HAS_TRAIT(C, TRAIT_DNR) || isconstruct(C))
		return
	if(C.mind)
		if(C.mind.has_antag_datum(/datum/antagonist/zombie))
			is_zombie = TRUE
	if(!is_zombie)
		if(C.stat != DEAD)
			qdel(src)
			return

	var/area/A = get_area(C)
	if(istype(A, /area/rogue/indoors/town) || istype(A, /area/rogue/indoors/deathsedge))
		return



	if(!(C.mob_biotypes & (MOB_ORGANIC|MOB_UNDEAD)))
		qdel(src)
		return

	if(amount > DEAD_TO_ZOMBIE_TIME)
		if(is_zombie)
			var/datum/antagonist/zombie/Z = C.mind.has_antag_datum(/datum/antagonist/zombie)
			if(Z && !Z.has_turned && !Z.revived && C.stat == DEAD)
				C.infected = TRUE
				wake_zombie(C, infected_wake = TRUE, converted = FALSE)

	var/findonerotten = FALSE
	var/shouldupdate = FALSE
	var/dustme = FALSE
	for(var/obj/item/bodypart/B in C.bodyparts)
		if(!B.skeletonized && B.is_organic_limb())
			if(!B.rotted)
				if(amount > 20 MINUTES)
					B.rotted = TRUE
					findonerotten = TRUE
					shouldupdate = TRUE
					C.apply_status_effect(/datum/status_effect/debuff/rotted_zombie)	//-8 con to rotting zombie corpse.
			else
				if(amount > 40 MINUTES)
					if(!is_zombie)
						B.skeletonize()
						if(C.dna && C.dna.species)
							C.dna.species.species_traits |= NOBLOOD
						C.apply_status_effect(/datum/status_effect/debuff/rotted_zombie)	//-8 con to rotting zombie corpse - duplicate as a failsafe.
						shouldupdate = TRUE
				else
					findonerotten = TRUE
		if(amount > 35 MINUTES)  // Code to delete a corpse after 35 minutes if it's not a zombie and not skeletonized. Possible failsafe.
			if(!is_zombie)
				if(!C.client)	// We want to dust NPC bodies, not player bodies.
					if(B.skeletonized)
						dustme = TRUE

	if(dustme)
		qdel(src)
		return C.dust(drop_items=TRUE)

	if(findonerotten)
		var/turf/open/T = C.loc
		if(istype(T))
			T.pollute_turf(/datum/pollutant/rot, 5)
			set_flies(!is_zombie)
		else
			set_flies(FALSE)
	else
		set_flies(FALSE)
	if(shouldupdate)
		if(findonerotten)
			if(ishuman(C))
				var/mob/living/carbon/human/H = C
				H.skin_tone = "878f79" //elf ears
			set_flies(!is_zombie)
		C.update_body()

/datum/component/rot/simple/process()
	..()
	var/mob/living/L = parent
	if(L.stat != DEAD)
		qdel(src)
		return
	if(amount > 15 MINUTES)
		var/turf/open/T = get_turf(L)
		// Gated on an open turf like /rot/corpse, since nothing else in this branch turns the flies off
		set_flies(istype(T))
		if(istype(T))
			T.pollute_turf(/datum/pollutant/rot, 5)
	if(amount > 25 MINUTES)
		qdel(src)
		return L.dust(drop_items=TRUE)

/datum/component/rot/gibs
	amount = MIASMA_GIBS_MOLES
