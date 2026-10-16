// ============================================================================
// DREAMWALKER ASCENSION
// Five rites performed at a drowned altar. Each rite feeds a storm that grows
// omen -> rain -> rainstorm -> gale -> hurricane (the ascension).
// Sylveric ingots (pulled from marked targets) pay for most of the rites, the
// rites must be spoken in particular places, and the gale rite tears crystal
// spires out of the ground at premarked haunt locations. The final rite needs
// those spires to still stand. Kill the altar, break the spires, or kill the
// Chosen, and the storm unravels.
// ============================================================================

#define DW_STAGE_NONE 0
#define DW_STAGE_OMEN 1      // clouds + warning only
#define DW_STAGE_RAIN 2      // /datum/particle_weather/rain_gentle
#define DW_STAGE_STORM 3     // /datum/particle_weather/rain_storm
#define DW_STAGE_GALE 4      // rain_storm, tornadoes + lightning cranked up
#define DW_STAGE_ASCENDED 5  // /datum/particle_weather/hurricane

// Where rites may be spoken.
#define DW_AREAS_OUTDOORS list(/area/rogue/outdoors)
#define DW_AREAS_TOWN list(/area/rogue/outdoors/town)
#define DW_AREAS_CHURCH list(/area/rogue/indoors/town/church)

// How long an interrupted rite waits before it unravels and loses its progress.
#define DW_RITE_RESUME_WINDOW (40 SECONDS)

// Dream crystals: the dreamwalker attunes a registered spire (see bottom of file).
#define DW_SPIRE_FRESH 0
#define DW_SPIRE_ATTUNING 1
#define DW_SPIRE_SPENT 2
#define DW_SPIRE_ATTUNE_TIME (60 SECONDS)
#define DW_SPIRE_NOISE_RANGE 28
// Brine pulse from spent spires.
#define DW_BRINE_INTERVAL (3 SECONDS)
/// Oxyloss is only applied to targets still at or above this fraction of their max health.
#define DW_BRINE_OXY_MIN_HEALTH 0.6

GLOBAL_DATUM_INIT(dreamwalker_storm, /datum/dreamwalker_storm, new)

/// Server-wide message + sting. Used by every rite.
/proc/dreamwalker_announce(message, sfx)
	for(var/mob/M in GLOB.player_list)
		to_chat(M, message)
		if(sfx)
			SEND_SOUND(M, sound(sfx, volume = 70))

/proc/get_dreamwalker_datum(mob/M)
	if(!M || !M.mind)
		return null
	return M.mind.has_antag_datum(/datum/antagonist/dreamwalker)

/// The thinner the dream, the faster the dreamwalker's tools recharge.
/proc/dreamwalker_scale_cooldown(base)
	var/mult = 1
	switch(GLOB.dreamwalker_storm.stage)
		if(DW_STAGE_RAIN)
			mult = 0.8
		if(DW_STAGE_STORM)
			mult = 0.6
		if(DW_STAGE_GALE)
			mult = 0.45
		if(DW_STAGE_ASCENDED)
			mult = 0.3
	return round(base * mult)

// ----------------------------------------------------------------------------
// STORM CONTROLLER
// Owns the weather the rites have summoned. Re-runs it if it times out naturally.
// ----------------------------------------------------------------------------
/datum/dreamwalker_storm
	var/stage = DW_STAGE_NONE
	var/weather_forced = FALSE
	var/mob/living/carbon/human/chosen = null
	/// Crystal spires planted by dreamwalker shards or the gale rite. Only live ones are kept.
	var/list/spires = list()

/// Stages only ratchet upward (matters if there is more than one dreamwalker).
/datum/dreamwalker_storm/proc/raise_stage(new_stage)
	if(new_stage > stage)
		set_stage(new_stage)

/datum/dreamwalker_storm/proc/set_stage(new_stage)
	stage = new_stage
	if(stage > DW_STAGE_NONE)
		START_PROCESSING(SSprocessing, src)
	else
		STOP_PROCESSING(SSprocessing, src)
	sync_weather(TRUE)

/datum/dreamwalker_storm/process()
	sync_weather(FALSE)

/datum/dreamwalker_storm/proc/register_spire(obj/structure/crystal_spire/S)
	if(!S || (S in spires))
		return
	spires += S
	RegisterSignal(S, COMSIG_QDELETING, PROC_REF(on_spire_qdel))

/datum/dreamwalker_storm/proc/on_spire_qdel(datum/source)
	SIGNAL_HANDLER
	spires -= source

/datum/dreamwalker_storm/proc/count_spires()
	return length(spires)

/datum/dreamwalker_storm/proc/desired_weather()
	switch(stage)
		if(DW_STAGE_RAIN)
			return /datum/particle_weather/rain_gentle
		if(DW_STAGE_STORM, DW_STAGE_GALE)
			return /datum/particle_weather/rain_storm
		if(DW_STAGE_ASCENDED)
			return /datum/particle_weather/hurricane
	return null

/datum/dreamwalker_storm/proc/sync_weather(force = FALSE)
	var/wanted = desired_weather()
	if(!wanted)
		// Omen stage runs no precipitation; a collapse clears what we started.
		if(weather_forced && stage == DW_STAGE_NONE)
			SSParticleWeather.stopWeather()
			weather_forced = FALSE
		return
	var/datum/particle_weather/current = SSParticleWeather.runningWeather
	if(current && current.type == wanted && !force)
		return
	SSParticleWeather.run_weather(wanted, TRUE)
	weather_forced = TRUE
	tune_weather()

/datum/dreamwalker_storm/proc/tune_weather()
	var/datum/particle_weather/current = SSParticleWeather.runningWeather
	if(!istype(current, /datum/particle_weather/rain_storm))
		return
	var/datum/particle_weather/rain_storm/S = current
	if(stage >= DW_STAGE_GALE)
		S.tornado_prob = 20
		S.lightning_strikes = 10

/// The DW died.
/datum/dreamwalker_storm/proc/collapse()
	chosen = null
	set_stage(DW_STAGE_NONE)
	dreamwalker_announce(span_greenannounce("The great wheel of cloud shudders and tears open. The sea exhales, and the dreaming deep goes quiet once more."), 'sound/weather/rain/thunder_1.ogg')

// ----------------------------------------------------------------------------
// RITES
// Data-driven.
// ----------------------------------------------------------------------------
/datum/dreamwalker_ritual
	var/name = "ritual"
	var/desc = ""
	/// Storm stage this rite sets when completed.
	var/stage = DW_STAGE_NONE
	var/channel_time = 30 SECONDS
	/// Blood (blood_volume units) the dreamwalker bleeds onto the altar.
	var/blood_toll = 0
	/// typepath = amount, laid on the altar's tile.
	var/list/offerings = list()
	/// The altar must stand in one of these areas (subtypes match) for the rite to begin.
	var/list/allowed_areas = DW_AREAS_OUTDOORS
	/// Player-facing wording for allowed_areas ("outdoors", "in town", "in the church").
	var/area_desc = "outdoors"
	/// On completion, lay this many spire runes at premarked haunt locations (planted shards count toward it).
	var/spires_to_seed = 0
	/// To begin and to finish, at least this many registered spires must stand.
	var/spires_required = 0
	var/spire_min_spacing = 15
	var/spire_min_origin_dist = 10
	var/start_message = null
	var/complete_message = null
	var/fail_message = null
	var/sfx = 'sound/weather/rain/thunder_1.ogg'
	var/lightning_on_tick = FALSE
	/// Spell given to the dreamwalker when this rite completes.
	var/grants_spell = null
	/// Completed 10 second channel ticks. Survives interruptions.
	var/progress = 0
	/// TRUE from the first channel until the rite completes or unravels.
	var/started = FALSE
	var/obj/structure/table/dreamwalker_altar/progress_altar = null
	var/resume_timer = null
	/// Spires raised around the altar on completion (random between min and max).
	var/nearby_spires_min = 0
	var/nearby_spires_max = 0
	var/nearby_spire_range = 7
	var/nearby_spire_min_dist = 2
	var/nearby_spire_spacing = 3

/datum/dreamwalker_ritual/proc/describe_offerings()
	var/list/parts = list()
	for(var/path in offerings)
		var/atom/A = path
		parts += "[offerings[path]]x [initial(A.name)]"
	return length(parts) ? parts.Join(", ") : "nothing but blood"

/datum/dreamwalker_ritual/proc/area_ok(atom/where)
	var/area/A = get_area(where)
	if(!A)
		return FALSE
	for(var/path in allowed_areas)
		if(istype(A, path))
			return TRUE
	return FALSE

/datum/dreamwalker_ritual/proc/describe_areas()
	return area_desc

/datum/dreamwalker_ritual/proc/total_ticks()
	return max(1, round(channel_time / (10 SECONDS)))

/datum/dreamwalker_ritual/proc/cancel_resume_timer()
	if(resume_timer)
		deltimer(resume_timer)
	resume_timer = null

/// Wipes saved progress. Silent; callers decide what to announce.
/datum/dreamwalker_ritual/proc/reset_progress()
	cancel_resume_timer()
	progress = 0
	started = FALSE
	progress_altar = null

/// The channel was interrupted: keep progress, start the countdown. No failure message.
/datum/dreamwalker_ritual/proc/pause_progress(mob/living/carbon/human/user)
	cancel_resume_timer()
	resume_timer = addtimer(CALLBACK(src, PROC_REF(expire_progress), user), DW_RITE_RESUME_WINDOW, TIMER_STOPPABLE)
	to_chat(user, span_warning("My concentration breaks, but the rite is not lost. If I do not return to the altar within [DW_RITE_RESUME_WINDOW / (1 SECONDS)] seconds, it will unravel."))

/// The gap ran too long (or the altar fell). This is the actual failure.
/datum/dreamwalker_ritual/proc/expire_progress(mob/user)
	resume_timer = null
	if(!started)
		return
	reset_progress()
	if(user && !QDELETED(user))
		to_chat(user, span_danger("The rite unravels. Everything I had channeled is lost."))
	on_fail(user)

/datum/dreamwalker_ritual/proc/on_channel_resume(mob/living/carbon/human/user, obj/structure/table/dreamwalker_altar/altar)
	to_chat(user, span_notice("I lay my hands back on the altar and take up the [name] where I left off."))

/// Returns the reason this rite cannot begin at this altar right now, or null if it can.
/datum/dreamwalker_ritual/proc/start_block(mob/living/carbon/human/user, obj/structure/table/dreamwalker_altar/altar)
	if(!area_ok(altar))
		return "This ground is wrong for the rite. It must be spoken [describe_areas()]."
	if(spires_required)
		var/standing = GLOB.dreamwalker_storm.count_spires()
		if(standing < spires_required)
			return "The dream has no anchors. [spires_required] crystal spires must stand across the realm, and only [standing] do."
	return null

/// Returns a list of the items to consume, or FALSE if the altar isn't satisfied.
/datum/dreamwalker_ritual/proc/gather_offerings(turf/T)
	var/list/found = list()
	for(var/path in offerings)
		var/remaining = offerings[path]
		for(var/obj/item/I in T)
			if(remaining <= 0)
				break
			if(!istype(I, path) || (I in found))
				continue
			found += I
			remaining--
		if(remaining > 0)
			return FALSE
	return found

/datum/dreamwalker_ritual/proc/on_channel_start(mob/living/carbon/human/user, obj/structure/table/dreamwalker_altar/altar)
	to_chat(user, span_notice("I lay my hands on the altar and begin the [name]..."))
	if(start_message)
		dreamwalker_announce(start_message, sfx)

/datum/dreamwalker_ritual/proc/on_channel_tick(mob/living/carbon/human/user, obj/structure/table/dreamwalker_altar/altar, tick, total_ticks)
	if(lightning_on_tick && prob(60))
		var/turf/T = locate(altar.x + rand(-5, 5), altar.y + rand(-5, 5), altar.z)
		if(T && T.outdoor_effect && !T.outdoor_effect.weatherproof)
			new /obj/effect/temp_visual/lightning/storm(T)

/datum/dreamwalker_ritual/proc/on_fail(mob/living/carbon/human/user)
	if(fail_message)
		dreamwalker_announce(fail_message, sfx)

/// Last chance for a rite to refuse completion (offerings are not spent if it does, but the blood is).
/datum/dreamwalker_ritual/proc/can_complete(mob/living/carbon/human/user)
	if(spires_required)
		var/standing = GLOB.dreamwalker_storm.count_spires()
		if(standing < spires_required)
			user.adjust_blood_volume(-blood_toll)
			to_chat(user, span_userdanger("The spires have been shattered! Only [standing] of the [spires_required] I needed still stand, and the dream will not break. The blood I bled is wasted."))
			return FALSE
	return TRUE

/datum/dreamwalker_ritual/proc/on_complete(mob/living/carbon/human/user, datum/antagonist/dreamwalker/D)
	GLOB.dreamwalker_storm.raise_stage(stage)
	if(complete_message)
		dreamwalker_announce(complete_message, sfx)
	if(grants_spell && user.mind)
		var/obj/effect/proc_holder/spell/S = new grants_spell
		user.mind.AddSpell(S)
		to_chat(user, span_notice("The rite leaves something behind in my mind: [S.name]."))
	if(spires_to_seed)
		var/laid = seed_spires(get_turf(user))
		if(laid)
			dreamwalker_announce("<span class='userdanger'>Violet light splits the earth in [laid] places across the realm, and crystal spires begin to rise from the cracks. The deep is raising anchors for what comes next. Shatter them.</span>", sfx)

/// Opens spire runes at premarked haunt locations (the same markers the goblin invasion uses).
/// Only falls back to random exposed ground if the map has too few usable markers.
/datum/dreamwalker_ritual/proc/seed_spires(turf/origin)
	var/to_seed = spires_to_seed - GLOB.dreamwalker_storm.count_spires()
	if(to_seed <= 0 || !origin)
		return 0
	var/list/placed = list()
	if(LAZYLEN(GLOB.hauntstart))
		var/list/candidates = GLOB.hauntstart.Copy()
		while(length(candidates) && length(placed) < to_seed)
			var/turf/T = pick_n_take(candidates)
			if(!valid_spire_turf(T, origin, placed))
				continue
			placed += T
			new /obj/structure/active_abyssor_rune/dreamwalker(T)
	var/list/pool = SSParticleWeather.weathered_turfs
	if(length(placed) < to_seed && length(pool))
		for(var/attempt in 1 to 300)
			if(length(placed) >= to_seed)
				break
			var/turf/T = pick(pool)
			if(!valid_spire_turf(T, origin, placed))
				continue
			placed += T
			new /obj/structure/active_abyssor_rune/dreamwalker(T)
	return length(placed)

/datum/dreamwalker_ritual/proc/valid_spire_turf(turf/T, turf/origin, list/placed, min_spacing, min_origin_dist)
	if(isnull(min_spacing))
		min_spacing = spire_min_spacing
	if(isnull(min_origin_dist))
		min_origin_dist = spire_min_origin_dist
	if(!T || T.z != origin.z || !istype(T, /turf/open) || istype(T, /turf/open/water) || T.density || T.teleport_restricted)
		return FALSE
	if(T.x < 6 || T.y < 6 || T.x > world.maxx - 6 || T.y > world.maxy - 6)
		return FALSE
	if(get_dist(T, origin) < min_origin_dist)
		return FALSE
	for(var/atom/movable/AM in T)
		if(AM.density || istype(AM, /obj/structure/active_abyssor_rune))
			return FALSE
	for(var/turf/P in placed)
		if(get_dist(T, P) < min_spacing)
			return FALSE
	for(var/obj/structure/crystal_spire/S in GLOB.dreamwalker_storm.spires)
		if(S.z == T.z && get_dist(T, S) < min_spacing)
			return FALSE
	return TRUE

/// Raises a handful of spire runes in sight of the origin. Unlike seed_spires(), this always lays the full amount.
/datum/dreamwalker_ritual/proc/seed_nearby_spires(turf/origin)
	var/to_seed = rand(nearby_spires_min, nearby_spires_max)
	if(to_seed <= 0 || !origin)
		return 0
	var/list/candidates = list()
	for(var/turf/open/T in view(nearby_spire_range, origin))
		candidates += T
	var/list/placed = list()
	while(length(candidates) && length(placed) < to_seed)
		var/turf/T = pick_n_take(candidates)
		if(!valid_spire_turf(T, origin, placed, nearby_spire_spacing, nearby_spire_min_dist))
			continue
		placed += T
		new /obj/structure/active_abyssor_rune/dreamwalker(T)
	return length(placed)

/// Returns TRUE if the channel finished. Resumes from saved progress.
/datum/dreamwalker_ritual/proc/channel(mob/living/carbon/human/user, obj/structure/table/dreamwalker_altar/altar)
	var/total = total_ticks()
	while(progress < total)
		if(!do_after(user, 10 SECONDS, target = altar))
			return FALSE
		if(QDELETED(altar))
			return FALSE
		progress++
		on_channel_tick(user, altar, progress, total)
	return TRUE

// --- I: omen (no ingot, an easy first step) ---------------------------------
/datum/dreamwalker_ritual/murmur
	name = "Rite of the First Murmur"
	desc = "Whisper the deep's name to the shore. The sky begins to listen, and the dream lends you a splinter of itself."
	stage = DW_STAGE_OMEN
	channel_time = 30 SECONDS
	blood_toll = 60
	offerings = list()
	allowed_areas = DW_AREAS_OUTDOORS
	area_desc = "outdoors"
	grants_spell = /obj/effect/proc_holder/spell/invoked/dream_shard
	complete_message = "<span class='greenannounce'>A heavy hush settles over the realm. Far out to sea the horizon bruises purple-black, and the tide drags itself out too far, as though the world were drawing breath.</span>"

// --- II: rain ---------------------------------------------------------------
/datum/dreamwalker_ritual/weeping
	name = "Rite of the Weeping Sky"
	desc = "Salt the clouds with metal pulled from a waking mind."
	stage = DW_STAGE_RAIN
	channel_time = 45 SECONDS
	blood_toll = 60
	offerings = list(/obj/item/ingot/sylveric = 1, /obj/item/dream_crystal = 1)
	allowed_areas = DW_AREAS_OUTDOORS
	area_desc = "outdoors"
	grants_spell = /obj/effect/proc_holder/spell/invoked/call_dreamfiend/dreamwalker/minor
	complete_message = "<span class='greenannounce'>Grey clouds gather up above the realm and the first cold drops begin to fall. Somewhere beneath the waves, something turns over in its sleep.</span>"
	
// --- III: rainstorm ---------------------------------------------------------
/datum/dreamwalker_ritual/swelling
	name = "Rite of the Swelling Tide"
	desc = "Pay the deep again, and speak it in the open streets of the town."
	stage = DW_STAGE_STORM
	channel_time = 60 SECONDS
	blood_toll = 100
	offerings = list(/obj/item/ingot/sylveric = 1, /obj/item/dream_crystal = 1)
	allowed_areas = DW_AREAS_TOWN
	area_desc = "in town"
	spires_to_seed = 3
	lightning_on_tick = TRUE
	grants_spell = /obj/effect/proc_holder/spell/invoked/call_dreamfiend/dreamwalker
	complete_message = "<span class='danger'>Thunder splits the sky. The rain becomes a roaring wall and the rivers climb their banks. Abyssor's dreaming is no longer quiet.</span>"

// --- IV: gale (last warning, lays the spires) -------------------------------
/datum/dreamwalker_ritual/gale
	name = "Rite of the Turning Wheel"
	desc = "Wind the storm tight, and drive anchors into the world."
	stage = DW_STAGE_GALE
	channel_time = 90 SECONDS
	blood_toll = 150
	offerings = list(/obj/item/ingot/sylveric = 1, /obj/item/dream_crystal = 2)
	allowed_areas = DW_AREAS_TOWN
	area_desc = "in town"
	lightning_on_tick = TRUE
	spires_to_seed = 10
	nearby_spires_min = 2
	nearby_spires_max = 2
	start_message = "<span class='danger'>The wind changes. Something vast is beginning to turn above the water, and the sea answers it.</span>"
	complete_message = "<span class='danger'>The storm bends toward a single point. A great wheel of cloud spins up out of the dark, and tornadoes stalk the land beneath it. Only one rite stands between the realm and the thing beneath the sea.</span>"
	fail_message = "<span class='greenannounce'>The turning wheel stutters and slackens. The storm holds, but the wind has lost its purpose, for now.</span>"

// --- V: ascension -----------------------------------------------------------
/datum/dreamwalker_ritual/ascension
	name = "Rite of the Waking Deep"
	desc = "Break the dream. Wake the Drowned God, within the church. The spires must still stand."
	stage = DW_STAGE_ASCENDED
	channel_time = 180 SECONDS
	blood_toll = 200
	offerings = list(/obj/item/ingot/sylveric = 2, /obj/item/dream_crystal = 2)
	allowed_areas = DW_AREAS_CHURCH
	area_desc = "in the church"
	lightning_on_tick = TRUE
	spires_required = 2
	nearby_spires_min = 3
	nearby_spires_max = 4
	grants_spell = /obj/effect/proc_holder/spell/invoked/call_dreamfiend/dreamwalker/ancient
	start_message = "<span class='userdanger'>THE DREAMER STIRS. A deep tolling rolls up from the sea floor and the ground hums with a hymn of drowning. The world warps and starts to fracture- A dreamwalker is calling Abyssor out of his sleep at a drowned altar. STOP THEM BEFORE THE RITE IS DONE.</span>"
	fail_message = "<span class='greenannounce'>The tolling from the deep falters and falls silent. The dreamer sleeps on, for now.</span>"

/datum/dreamwalker_ritual/ascension/on_channel_tick(mob/living/carbon/human/user, obj/structure/dreamwalker_altar/altar, tick, total_ticks)
	..()
	if(tick % 6 == 0 && tick < total_ticks)
		var/minutes_left = round((total_ticks - tick) / 6)
		to_chat(user, span_notice("[GLOB.dreamwalker_storm.count_spires()] spires stand across the realm. I need [spires_required] when the tolling ends."))
		dreamwalker_announce("<span class='userdanger'>The tolling grows louder. [minutes_left] minute[minutes_left == 1 ? "" : "s"] remain until the Drowned God wakes.</span>", sfx)

/datum/dreamwalker_ritual/ascension/on_complete(mob/living/carbon/human/user, datum/antagonist/dreamwalker/D)
	..()
	D.ascend()
	dreamwalker_announce("<span class='userdanger'>ABYSSOR AWAKES. The sea rises to meet the sky and the hurricane breaks over the realm. This land will not survive it's wake. [user.real_name] is his Chosen. End the Chosen, and the storm ends with them.</span>", sfx)

// ----------------------------------------------------------------------------
// ALTAR
// ----------------------------------------------------------------------------
/obj/structure/table/dreamwalker_altar
	name = "drowned altar"
	desc = "A slab of salt-crusted crystal that is somehow always wet. Seawater beads and runs from it, though the sea is nowhere near."
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "abyssal_altar"
	anchored = TRUE
	density = TRUE
	smooth = 0
	max_integrity = 400
	var/channeling = FALSE
	var/datum/antagonist/dreamwalker/cult = null

/obj/structure/table/dreamwalker_altar/Destroy()
	if(cult)
		for(var/datum/dreamwalker_ritual/R in cult.rituals)
			if(R.started && R.progress_altar == src)
				R.expire_progress(cult.owner?.current)
		if(cult.altar == src)
			cult.altar = null
	cult = null
	return ..()

/obj/structure/table/dreamwalker_altar/examine(mob/user)
	. = ..()
	var/datum/antagonist/dreamwalker/D = get_dreamwalker_datum(user)
	if(!D)
		return
	var/datum/dreamwalker_ritual/R = D.get_next_ritual()
	if(!R)
		. += span_notice("Every rite is done. Abyssor is awake.")
		return
	. += span_notice("Rite [D.rituals_done + 1] of [length(D.rituals)]: [R.name]. [R.desc]")
	. += span_notice("It demands, laid upon the stone: [R.describe_offerings()]. And blood.")
	. += span_notice("It must be spoken [R.describe_areas()].")
	if(R.started)
		. += span_notice("The rite is partly spoken ([R.progress]/[R.total_ticks()]). It will unravel if left alone too long.")
/obj/structure/table/dreamwalker_altar/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	var/datum/antagonist/dreamwalker/D = get_dreamwalker_datum(user)
	if(!D || !ishuman(user))
		to_chat(user, span_warning("Cold seawater runs over my fingers. It means nothing to me."))
		return
	if(channeling)
		return
	var/datum/dreamwalker_ritual/R = D.get_next_ritual()
	if(!R)
		to_chat(user, span_notice("There is nothing left to offer. He is awake."))
		return
	begin_ritual(user, D, R)

/obj/structure/table/dreamwalker_altar/proc/begin_ritual(mob/living/carbon/human/user, datum/antagonist/dreamwalker/D, datum/dreamwalker_ritual/R)
	var/turf/T = get_turf(src)
	// Progress belongs to one altar. Starting at a different one begins the rite anew.
	if(R.started && R.progress_altar != src)
		R.reset_progress()

	// These do not cancel the countdown: a blocked resume keeps ticking toward failure.
	var/block = R.start_block(user, src)
	if(block)
		to_chat(user, span_warning(block))
		return
	if(!islist(R.gather_offerings(T)))
		to_chat(user, span_warning("The altar is not satisfied. It demands: [R.describe_offerings()]."))
		return
	if(user.blood_volume < BLOOD_VOLUME_OKAY + R.blood_toll)
		to_chat(user, span_warning("I am too drained to bleed for this rite. I must recover first."))
		return

	channeling = TRUE
	if(R.started)
		R.cancel_resume_timer()
		R.on_channel_resume(user, src)
	else
		R.started = TRUE
		R.progress_altar = src
		R.on_channel_start(user, src)
	var/finished = R.channel(user, src)
	channeling = FALSE

	if(!finished)
		if(QDELETED(src))
			R.expire_progress(user)
		else if(R.started) // not started means the altar's destruction already unravelled it
			R.pause_progress(user)
		return

	if(!R.can_complete(user))
		R.reset_progress()
		R.on_fail(user)
		return

	// Offerings must still be on the stone when the rite ends.
	var/list/items = R.gather_offerings(T)
	if(!islist(items))
		to_chat(user, span_warning("The offerings are gone. The rite collapses."))
		R.reset_progress()
		R.on_fail(user)
		return
	for(var/obj/item/I in items)
		qdel(I)

	R.reset_progress()
	user.blood_volume = max(user.blood_volume - R.blood_toll, BLOOD_VOLUME_SURVIVE)
	to_chat(user, span_danger("The altar drinks deep of my blood."))
	D.complete_ritual(R, user)

// ----------------------------------------------------------------------------
// ANTAGONIST HOOKS
// ----------------------------------------------------------------------------
/datum/antagonist/dreamwalker/proc/setup_rituals()
	var/static/list/ritual_paths = list(
		/datum/dreamwalker_ritual/murmur,
		/datum/dreamwalker_ritual/weeping,
		/datum/dreamwalker_ritual/swelling,
		/datum/dreamwalker_ritual/gale,
		/datum/dreamwalker_ritual/ascension,
	)
	rituals = list()
	for(var/path in ritual_paths)
		rituals += new path
	var/datum/objective/dreamwalker_ascend/O = new
	O.owner = owner
	objectives += O

/datum/antagonist/dreamwalker/proc/get_next_ritual()
	if(rituals_done >= length(rituals))
		return null
	return rituals[rituals_done + 1]

/datum/antagonist/dreamwalker/proc/complete_ritual(datum/dreamwalker_ritual/R, mob/living/carbon/human/user)
	rituals_done++
	R.on_complete(user, src)
	var/datum/dreamwalker_ritual/next = get_next_ritual()
	if(next)
		to_chat(user, span_notice("[R.name] is done. ([rituals_done]/[length(rituals)]) The next: [next.name]. It will demand [next.describe_offerings()], and blood, spoken [next.describe_areas()]."))

/datum/antagonist/dreamwalker/proc/ascend()
	var/mob/living/carbon/human/body = owner.current
	if(!istype(body))
		return
	ascended = TRUE
	ADD_TRAIT(body, TRAIT_RAINSTORM_IMMUNE, "[type]")
	body.change_stat(STATKEY_STR, 3)
	body.change_stat(STATKEY_CON, 3)
	body.change_stat(STATKEY_WIL, 3)
	GLOB.dreamwalker_storm.chosen = body
	RegisterSignal(body, COMSIG_LIVING_DEATH, PROC_REF(on_ascended_death))
	to_chat(body, span_userdanger("THE DREAM BREAKS. The deep is awake, and I am its voice. The storm will not touch me, and it will not outlive me."))
	for(var/mob/connected_player in GLOB.player_list)
		if(!connected_player.client)
			continue
		SEND_SOUND(connected_player, sound(null))
		SEND_SOUND(connected_player, 'sound/villain/dreamer_win.ogg')
		
/datum/antagonist/dreamwalker/proc/on_ascended_death(datum/source, gibbed)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_LIVING_DEATH)
	GLOB.dreamwalker_storm.collapse()

// ----------------------------------------------------------------------------
// SPIRES + VOLATILE SHARDS
// Built on the abyssal marker / active rune / crystal spire code in ritualcircles.dm.
// Anything planted through these subtypes is tracked by the storm controller so the
// final rite can demand that spires still stand.
// ----------------------------------------------------------------------------

/// Anchor rune: matures into a regular crystal spire and registers it.
/obj/structure/active_abyssor_rune/dreamwalker

/obj/structure/active_abyssor_rune/dreamwalker/spawn_spire()
	var/obj/structure/crystal_spire/S = new spire_type(get_turf(src))
	GLOB.dreamwalker_storm.register_spire(S)

/obj/structure/active_abyssor_rune/dreamwalker/greater
	spire_type = /obj/structure/crystal_spire/greater

/// Volatile marker conjured by the dreamwalker. Throw it to plant a spire rune.
/obj/item/abyssal_marker/volatile/dreamwalker
	desc = "A shard of dream torn loose from the deep. It sings, and it will not last."
	rune_type = /obj/structure/active_abyssor_rune/dreamwalker
	upgraded_rune_type = /obj/structure/active_abyssor_rune/dreamwalker/greater
	var/fizzle_time = 5 MINUTES

/obj/item/abyssal_marker/volatile/dreamwalker/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(fizzle)), fizzle_time)

/obj/item/abyssal_marker/volatile/dreamwalker/proc/fizzle()
	if(QDELETED(src))
		return
	visible_message(span_warning("[src] cracks and dissolves into brine."))
	qdel(src)


// ----------------------------------------------------------------------------
// DREAM CRYSTALS
// A dreamwalker who touches one of their own spires starts a 30 second change:
// the spire glows violet and keeps announcing itself, then goes dark red and
// yields one dream crystal. A spent spire stops growing and spawning fiends and
// is much easier to break, but it still stands for the final rite's condition,
// and it pulses at anyone who comes near (stronger as the storm grows).
// Anyone can attack the spire while it changes; if it falls, there is no crystal.
// ----------------------------------------------------------------------------
/obj/item/dream_crystal
	name = "dream crystal"
	desc = "A sliver of a dream, cold and faintly singing. It smells of brine and sleep."
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "abyssal_marker" // TODO: placeholder, give it a real item sprite
	w_class = WEIGHT_CLASS_SMALL
	color = "#a259ff"

/obj/structure/crystal_spire/var/dream_state = DW_SPIRE_FRESH
/obj/structure/crystal_spire/var/mob/living/dream_attuner = null
/// Fraction of its integrity a spire keeps once spent.
/obj/structure/crystal_spire/var/spent_integrity_mult = 0.5

/obj/structure/crystal_spire/attack_hand(mob/living/user)
	if(!(src in GLOB.dreamwalker_storm.spires) || !get_dreamwalker_datum(user))
		return ..()
	switch(dream_state)
		if(DW_SPIRE_ATTUNING)
			to_chat(user, span_warning("The spire is already changing. I must let it finish."))
		if(DW_SPIRE_SPENT)
			to_chat(user, span_warning("This spire has given all it will. It is only a dark red husk now."))
		else
			begin_attunement(user)

/obj/structure/crystal_spire/proc/begin_attunement(mob/living/user)
	if(!awakened || converting)
		to_chat(user, span_warning("The spire is still tearing the dream open. It will not be touched yet."))
		return
	dream_state = DW_SPIRE_ATTUNING
	dream_attuner = user
	user.visible_message(span_warning("[user] lays a hand on [src], and the crystal begins to shift color!"), span_notice("I lay my palm on the spire. It answers, and the dream begins to pour through it."))
	animate(src, color = "#a259ff", time = 3 SECONDS)
	set_light(5, 3, "#a259ff")
	attune_pulse(1)
	max_fiends = 6	//Large wave while converting
	addtimer(CALLBACK(src, PROC_REF(attune_pulse), 2), 20 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(attune_pulse), 3), 40 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(finish_attunement)), DW_SPIRE_ATTUNE_TIME)

/obj/structure/crystal_spire/proc/attune_pulse(pulse)
	if(QDELETED(src) || dream_state != DW_SPIRE_ATTUNING)
		return
	var/static/list/pulse_messages = list(
		"A violet light blooms in the distance, and faint, ethereal voices murmur just beyond hearing",
		"The purple glow swells. Something sings, high and wordless, beneath the sound of the wind",
		"The violet light flares blinding bright. An ethereal chorus rises, and then cuts off all at once",
	)
	set_light(4 + pulse * 2, 3, 1 * pulse, l_color = "#a259ff")
	loud_message(pulse_messages[pulse], hearing_distance = DW_SPIRE_NOISE_RANGE)

/obj/structure/crystal_spire/proc/finish_attunement()
	if(QDELETED(src) || dream_state != DW_SPIRE_ATTUNING)
		return
	dream_state = DW_SPIRE_SPENT
	animate(src, color = "#5a0a14", time = 3 SECONDS)
	set_light(3, 1, 1, l_color = "#7a0c18")

	// The cost: the spire stops growing, stops birthing fiends (those already out stay), and is easier to break.
	max_fiends = 0
	max_radius = current_radius
	max_integrity = round(max_integrity * spent_integrity_mult)
	obj_integrity = min(obj_integrity, max_integrity)
	visible_message(span_danger("The spire drains to a dark, bloody red and falls silent."))

	var/obj/item/dream_crystal/C = new(get_turf(src))
	var/mob/living/user = dream_attuner
	dream_attuner = null
	if(user && !QDELETED(user) && user.stat != DEAD && get_dist(user, src) <= 2)
		user.put_in_hands(C)
		to_chat(user, span_notice("A dream crystal slips free of the spire and into my hand."))
	addtimer(CALLBACK(src, PROC_REF(brine_pulse)), DW_BRINE_INTERVAL)

// Spent spires choke the air around them. Scales with storm stage. Oxyloss is deliberately gentle:
// it ignores armor and can drop people into crit, so it only starts at the rainstorm stage, is hard-capped
// as a fraction of max health, and never touches anyone who is already hurt or down.
/obj/structure/crystal_spire/proc/brine_pulse()
	if(QDELETED(src) || dream_state != DW_SPIRE_SPENT)
		return
	addtimer(CALLBACK(src, PROC_REF(brine_pulse)), DW_BRINE_INTERVAL)

	var/range = 4
	var/slow = 2 SECONDS
	var/oxy = 0
	var/oxy_cap = 0
	switch(GLOB.dreamwalker_storm.stage)
		if(DW_STAGE_RAIN)
			range = 5
			slow = 3 SECONDS
		if(DW_STAGE_STORM)
			range = 6
			slow = 4 SECONDS
			oxy = 3
			oxy_cap = 0.40
		if(DW_STAGE_GALE)
			range = 7
			slow = 5 SECONDS
			oxy = 5
			oxy_cap = 0.55
		if(DW_STAGE_ASCENDED)
			range = 8
			slow = 6 SECONDS
			oxy = 8
			oxy_cap = 0.70

	for(var/mob/living/carbon/human/L in view(range, src))
		if(L.stat == DEAD || get_dreamwalker_datum(L) || HAS_TRAIT(L, TRAIT_RAINSTORM_IMMUNE))
			continue
		L.apply_status_effect(/datum/status_effect/debuff/clickcd, slow)
		var/choked = FALSE
		if(oxy && L.stat == CONSCIOUS && L.health >= L.maxHealth * DW_BRINE_OXY_MIN_HEALTH)
			var/room = L.maxHealth * oxy_cap - L.getOxyLoss()
			if(room > 0)
				L.adjustOxyLoss(min(oxy, room))
				choked = TRUE
		if(choked)
			to_chat(L, span_userdanger("Brine rises in my throat. I cannot draw a full breath!"))
		else
			to_chat(L, span_warning("Salt water seems to fill the air. It tastes of rust and the deep."))
