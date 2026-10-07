// DEAD_TO_ZOMBIE_TIME lives in __DEFINES/mobs.dm, the ghost lock in observer.dm uses it too

#define SIMPLE_CORPSE_ROT_START 15 MINUTES
#define SIMPLE_CORPSE_DUST_TIME 25 MINUTES
#define HUNT_CORPSE_ROT_START 20 MINUTES
#define HUNT_CORPSE_DUST_TIME 35 MINUTES

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
 * Enables or removes this corpse's point ambience source.
 *
 * Mobs at or below MOB_SIZE_TINY cannot produce flies. Source placement is handled by place_flies()
 * so corpses inside containers remain silent.
 *
 * Arguments:
 * * state - TRUE enables flies for an eligible parent. FALSE removes them.
 */
/datum/component/rot/proc/set_flies(state)
	if(state)
		var/mob/living/rotting_mob = parent
		if(istype(rotting_mob) && rotting_mob.mob_size <= MOB_SIZE_TINY)
			state = FALSE
	// The rot process polls this state repeatedly. Only transitions need registration work
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
 * Updates fly ambience when the corpse moves.
 *
 * Only corpses directly on a turf produce sound. Container movement does not move the corpse
 * itself, so contained corpses are unregistered until placed back on a turf.
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

/datum/component/rot/simple
	var/rot_start = SIMPLE_CORPSE_ROT_START
	var/dust_time = SIMPLE_CORPSE_DUST_TIME

/datum/component/rot/simple/process()
	..()
	var/mob/living/L = parent
	if(L.stat != DEAD)
		qdel(src)
		return
	if(amount > rot_start)
		var/turf/open/T = get_turf(L)
		// Gated on an open turf like /rot/corpse, since nothing else in this branch turns the flies off
		set_flies(istype(T))
		if(istype(T))
			T.pollute_turf(/datum/pollutant/rot, 5)
	if(amount > dust_time)
		qdel(src)
		return L.dust(drop_items=TRUE)

/datum/component/rot/simple/hunt
	rot_start = HUNT_CORPSE_ROT_START
	dust_time = HUNT_CORPSE_DUST_TIME

/datum/component/rot/gibs
	amount = MIASMA_GIBS_MOLES

#undef SIMPLE_CORPSE_ROT_START
#undef SIMPLE_CORPSE_DUST_TIME
#undef HUNT_CORPSE_ROT_START
#undef HUNT_CORPSE_DUST_TIME
