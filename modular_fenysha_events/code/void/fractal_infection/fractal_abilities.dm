/*
 * Abilities the fractal gives an infected host.
 *
 * Built on /obj/effect/proc_holder/spell/invoked, which is this codebase's own
 * targeted cast: pressing the button arms the spell, and the next click in the
 * world is the target. spell.dm already does all of it - add_ranged_ability
 * sets the caster's click_intercept, InterceptClickOn feeds the clicked atom
 * back in, and cast() receives it as targets[1] - so nothing here reimplements
 * targeting.
 *
 * Infected humans only. The mutant mob has its own kit and does not take these.
 */

/// Stage at which the lance may show up, and the odds of it doing so.
#define FRACTAL_LANCE_STAGE 4
#define FRACTAL_LANCE_CHANCE 40
/// Stage at which the rest arrive.
#define FRACTAL_LATE_STAGE 5

/*
 * ---------------------------------------------------------------------------
 * Lance - a hitscan beam that breaks where it lands
 * ---------------------------------------------------------------------------
 */

/obj/projectile/beam/laser/hitscan/fractal_lance
	name = "fractal lance"
	damage = 25
	damage_type = BRUTE
	/*
	 * generate_tracer_between_points() is handed the projectile's own colour and
	 * tints the tracer with it - but colour is a multiply, so the sprite has to
	 * be greyscale for that to land anywhere near the intended hue. The
	 * inherited "beam" art is red (most pixels 255,13,0), and red times purple
	 * is just a darker red. wormhole_g is pure white, so it takes the tint
	 * exactly, and there are matching muzzle and impact sprites for it.
	 */
	color = COLOR_ASSEMBLY_PURPLE
	light_color = COLOR_ASSEMBLY_PURPLE
	hitscan_light_color_override = COLOR_ASSEMBLY_PURPLE
	tracer_type = /obj/effect/projectile/tracer/wormhole
	muzzle_type = /obj/effect/projectile/muzzle/wormhole
	impact_type = /obj/effect/projectile/impact/wormhole
	impact_effect_type = null
	/// Blast left where the beam stops.
	var/blast_radius = 5
	var/blast_power = 1.2
	var/blast_speed = 2

/obj/projectile/beam/laser/hitscan/fractal_lance/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/turf/landing = get_turf(target)
	if(!landing)
		return
	// Small and quick, so it reads as the beam breaking rather than a bomb.
	shockwave(landing, blast_radius, blast_power, blast_speed, FALSE, null, 0, list(
		"amplitude base" = 60,
		"amplitude gain" = 60,
		// Small blast, so give the ring long enough to actually be seen.
		"min duration ds" = 6,
	))

/// The projectile subtype already aims and fires; only the projectile is ours.
/obj/effect/proc_holder/spell/invoked/projectile/fractal_lance
	name = "Fractal Lance"
	desc = "Throw a lance of folded light. Where it stops, the world does too."
	// The frame states (spell/spell0/spell1) have to live in the same sheet as
	// the art, because ApplyIcon draws both from icon_icon. magic.dmi has no
	// frame states, which is why the button background went missing.
	action_icon = 'icons/mob/actions/roguespells.dmi'
	overlay_state = "force_dart"

	projectile_type = /obj/projectile/beam/laser/hitscan/fractal_lance
	range = 12
	recharge_time = 12 SECONDS
	chargetime = 0
	releasedrain = 20
	chargedrain = 0
	chargedloop = null
	movement_interrupt = FALSE
	sound = 'modular_fenysha_events/sound/beam_attack.ogg'
	// Nothing is spoken. This is not a prayer, and the host has no words for it.
	invocation_type = "none"
	antimagic_allowed = TRUE

/*
 * ---------------------------------------------------------------------------
 * Shockwave punch - short ranged, all of it delivered into the ground
 * ---------------------------------------------------------------------------
 */

/obj/effect/proc_holder/spell/invoked/fractal_punch
	name = "Sundering Blow"
	desc = "Drive a fist into the ground and let the shape of it travel outward."
	// The frame states (spell/spell0/spell1) have to live in the same sheet as
	// the art, because ApplyIcon draws both from icon_icon. magic.dmi has no
	// frame states, which is why the button background went missing.
	action_icon = 'icons/mob/actions/roguespells.dmi'
	overlay_state = "lightning_sunder"

	range = 5
	recharge_time = 25 SECONDS
	// Telegraphed on purpose: this is the heavy one, and it should be dodgeable.
	chargetime = 0.6 SECONDS
	releasedrain = 40
	chargedrain = 0
	chargedloop = null
	movement_interrupt = TRUE
	sound = 'modular_fenysha_events/sound/fractal_glitch2.ogg'
	invocation_type = "none"
	antimagic_allowed = TRUE

	var/blast_radius = 7
	var/blast_power = 1.4
	var/blast_speed = 2
	var/impact_damage = 35

/obj/effect/proc_holder/spell/invoked/fractal_punch/cast(list/targets, mob/user = usr)
	. = ..()
	var/turf/landing = get_turf(targets[1])
	if(!landing)
		return FALSE

	user.visible_message(span_userdanger("[user] drives a fist into [landing]!"))
	new /obj/effect/temp_visual/decoy/fading/halfsecond(get_turf(user), user)

	for(var/mob/living/caught in landing.contents)
		if(caught == user)
			continue
		caught.take_bodypart_damage(impact_damage)

	// The blow itself is the shockwave - a heavier ripple than a stray blast,
	// because the viewer is standing right on top of it.
	shockwave(landing, blast_radius, blast_power, blast_speed, FALSE, user, 0, list(
		"amplitude base" = 70,
		"amplitude gain" = 70,
	))
	return TRUE

/*
 * ---------------------------------------------------------------------------
 * Blink - going somewhere without crossing the space between
 * ---------------------------------------------------------------------------
 */

/obj/effect/proc_holder/spell/invoked/fractal_blink
	name = "Fold Through"
	desc = "Stop being here. Start being there. The distance is not consulted."
	// The frame states (spell/spell0/spell1) have to live in the same sheet as
	// the art, because ApplyIcon draws both from icon_icon. magic.dmi has no
	// frame states, which is why the button background went missing.
	action_icon = 'icons/mob/actions/roguespells.dmi'
	overlay_state = "shadowstep"

	// Meant to be spammed: short hop, short recharge, no wind up.
	range = 4
	recharge_time = 2 SECONDS
	chargetime = 0
	releasedrain = 100
	chargedrain = 0
	chargedloop = null
	movement_interrupt = FALSE
	sound = 'modular_fenysha_events/sound/fractal_glitch2.ogg'
	invocation_type = "none"
	antimagic_allowed = TRUE

	/// Ticks spent fading out before the move. Kept short - this is a hop.
	var/vanish_time = 1
	/// Ticks the fold takes to unwind afterwards. Not a fade - you are solid the
	/// moment you land.
	var/arrive_time = 1

/obj/effect/proc_holder/spell/invoked/fractal_blink/cast(list/targets, mob/user = usr)
	. = ..()
	var/turf/arrival = get_turf(targets[1])
	if(!arrival)
		return FALSE

	// Clicking a mob means landing on top of one. Step back toward ourselves
	// until the ground is free.
	if(arrival.density || (locate(/mob/living) in arrival))
		arrival = get_step_towards(arrival, user)
	if(!arrival || arrival.density)
		to_chat(user, span_warning("There is no room there."))
		return FALSE

	INVOKE_ASYNC(src, PROC_REF(do_blink), user, arrival)
	return TRUE

/**
 * The vanish, the move, and the arrival.
 *
 * Each sleep matches the animate it is waiting on, so the move lands exactly
 * when the fade finishes rather than part way through it. The afterimages are
 * spread across the vanish instead of being dropped all at once - three decoys
 * spawned in the same tick sit on top of each other and read as one.
 */
/obj/effect/proc_holder/spell/invoked/fractal_blink/proc/do_blink(mob/living/user, turf/arrival)
	var/turf/departure = get_turf(user)
	if(!departure)
		return

	// Captured rather than initial(): the caster may already be part faded by
	// something else, and initial() would hand back the type default instead.
	var/return_alpha = user.alpha

	// Wind the fold on while it fades out, both over the same span.
	user.add_filter("fractal_fold", 2, list("type" = "wave", "size" = 1, "x" = 8, "y" = 8, "offset" = 0))
	var/folding = user.get_filter("fractal_fold")
	if(folding)
		animate(folding, size = 8, offset = 80, time = vanish_time, flags = ANIMATION_PARALLEL)
	animate(user, alpha = 0, time = vanish_time, flags = ANIMATION_PARALLEL)

	// One per tick across the vanish, so the shape smears rather than blinking.
	for(var/i in 1 to vanish_time)
		if(QDELETED(user))
			return
		new /obj/effect/temp_visual/decoy/fading/halfsecond(get_turf(user), user)
		sleep(1)

	if(QDELETED(user))
		return
	user.forceMove(arrival)
	playsound(arrival, sound, 70, TRUE)

	/*
	 * Restored through animate(), not by assigning alpha directly.
	 *
	 * A plain assignment after an animate() has run leaves the client showing
	 * the animation's final value until something else refreshes the
	 * appearance - which is why this left people invisible until they took a
	 * step. The vampire obfuscate power restores the same way, with animate()
	 * rather than a write. time = 0 makes it instant while still registering.
	 */
	animate(user, alpha = return_alpha, time = 0)

	folding = user.get_filter("fractal_fold")
	if(folding)
		animate(folding, size = 1, offset = 0, time = arrive_time, flags = ANIMATION_PARALLEL)

	for(var/i in 1 to arrive_time)
		if(QDELETED(user))
			return
		new /obj/effect/temp_visual/decoy/fading/halfsecond(arrival, user)
		sleep(1)

	if(QDELETED(user))
		return
	// Only now, with the wave already animated back down to nothing, so removing
	// it is not a visible snap.
	user.remove_filter("fractal_fold")
	// Same reason as above: never a bare assignment after an animation.
	animate(user, alpha = return_alpha, time = 0)

/*
 * ---------------------------------------------------------------------------
 * Handing them out as the infection takes hold
 * ---------------------------------------------------------------------------
 */

/datum/status_effect/fractal_infection
	/// Spells already granted, so a stage change never doubles them up.
	var/list/obj/effect/proc_holder/spell/granted_abilities

/**
 * Grants whatever the current stage has earned.
 *
 * Called from on_stage_changed. Additive only - the infection never takes an
 * ability back, because it never gets better.
 *
 * Granted to the mob rather than the mind, so they belong to this body and do
 * not follow the host into whatever it becomes.
 */
/datum/status_effect/fractal_infection/proc/update_fractal_abilities(stage)
	// Infected humans only. The mutant mob has its own kit and is not meant to
	// carry these.
	if(!ishuman(owner))
		return

	var/list/earned = list()
	// A coin flip rather than a certainty, so two hosts at the same stage are
	// not the same fight.
	if(stage >= FRACTAL_LANCE_STAGE && prob(FRACTAL_LANCE_CHANCE))
		earned += /obj/effect/proc_holder/spell/invoked/projectile/fractal_lance
	if(stage >= FRACTAL_LATE_STAGE)
		if(prob(30))
			earned += /obj/effect/proc_holder/spell/invoked/fractal_punch
		if(prob(30))
			earned += /obj/effect/proc_holder/spell/invoked/fractal_blink

	for(var/path in earned)
		if(locate(path) in granted_abilities)
			continue
		var/obj/effect/proc_holder/spell/granted = new path()
		owner.AddSpell(granted)
		LAZYADD(granted_abilities, granted)
		to_chat(owner, span_userdanger("Something in you knows how to do this now."))

/datum/status_effect/fractal_infection/proc/clear_fractal_abilities()
	for(var/obj/effect/proc_holder/spell/granted as anything in granted_abilities)
		if(QDELETED(granted))
			continue
		// RemoveSpell takes it off mob_spell_list and disposes of it, which
		// takes the action button with it.
		if(owner)
			owner.RemoveSpell(granted)
		else
			qdel(granted)
	granted_abilities = null

#undef FRACTAL_LANCE_STAGE
#undef FRACTAL_LANCE_CHANCE
#undef FRACTAL_LATE_STAGE
