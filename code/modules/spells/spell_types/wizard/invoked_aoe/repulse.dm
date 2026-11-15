/obj/effect/proc_holder/spell/invoked/repulse
	name = "Repulse"
	desc = "Conjure forth a wave of energy, repelling anyone around you."
	cost = 3
	xp_gain = TRUE
	releasedrain = 50
	chargedrain = 1
	chargetime = 5
	recharge_time = 35 SECONDS
	human_req = TRUE
	ignore_los = TRUE
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "repulse"
	spell_tier = 2
	invocations = list("Obmolior!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_DISPLACEMENT
	glow_intensity = GLOW_INTENSITY_MEDIUM
	gesture_required = TRUE // Offensive spell. Don't blast guards while chained.
	var/maxthrow = 3
	var/sparkle_path = /obj/effect/temp_visual/gravpush
	var/repulse_force = MOVE_FORCE_EXTREMELY_STRONG
	var/push_range = 1

/obj/effect/proc_holder/spell/invoked/repulse/cast(list/targets, mob/user, stun_amt = 5)
	var/turf/origin = get_turf(user)
	if(!origin)
		return FALSE
	var/list/thrownatoms = list()
	var/atom/throwtarget
	var/distfromcaster
	playsound(user, 'sound/magic/repulse.ogg', 80, TRUE)
	for(var/turf/T in view(push_range, origin))
		new /obj/effect/temp_visual/kinetic_blast(T)
		for(var/atom/movable/AM in T)
			thrownatoms[AM] = T

	for(var/am in thrownatoms)
		var/atom/movable/AM = am
		if(QDELETED(AM) || AM == user || AM.anchored)
			continue

		if(ismob(AM))
			var/mob/M = AM
			if(M.anti_magic_check())
				continue

		// Earlier knockbacks may drag the caster or another target. Keep the original geometry.
		var/turf/start_turf = thrownatoms[AM]
		throwtarget = get_edge_target_turf(origin, get_dir(origin, get_step_away(start_turf, origin)))
		distfromcaster = start_turf == origin ? 0 : get_dist(origin, start_turf)
		if(distfromcaster == 0)
			if(isliving(AM))
				var/mob/living/M = AM
				M.set_resting(TRUE, TRUE)
				M.adjustBruteLoss(20)
				to_chat(M, "<span class='danger'>You're slammed into the floor by [user]!</span>")
		else
			new sparkle_path(get_turf(AM), get_dir(origin, start_turf)) //created sparkles will disappear on their own
			if(isliving(AM))
				var/mob/living/M = AM
				M.set_resting(TRUE, TRUE)
				to_chat(M, "<span class='danger'>You're thrown back by [user]!</span>")
			AM.safe_throw_at(throwtarget, ((CLAMP((maxthrow - (CLAMP(distfromcaster - 2, 0, distfromcaster))), 3, maxthrow))), 1,user, force = repulse_force, preserve_pull = isliving(user) ? user : null)//So stuff gets tossed around at the same time.
	return TRUE
