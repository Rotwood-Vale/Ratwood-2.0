/obj/effect/proc_holder/spell/invoked/repulse
	name = "震退术"
	desc = "唤出一道能量波，将你周围的一切向外震开。"
	cost = 3
	xp_gain = TRUE
	releasedrain = 50
	chargedrain = 1
	chargetime = 5
	recharge_time = 30 SECONDS
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
	invocations = list("统统退开！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_DISPLACEMENT
	glow_intensity = GLOW_INTENSITY_MEDIUM
	gesture_required = TRUE // Offensive spell. Don't blast guards while chained.
	var/maxthrow = 3
	var/sparkle_path = /obj/effect/temp_visual/gravpush
	var/repulse_force = MOVE_FORCE_EXTREMELY_STRONG
	var/push_range = 1

/obj/effect/proc_holder/spell/invoked/repulse/cast(list/targets, mob/user, stun_amt = 5)
	var/list/thrownatoms = list()
	var/atom/throwtarget
	var/distfromcaster
	playsound(user, 'sound/magic/repulse.ogg', 80, TRUE)
	for(var/turf/T in view(push_range, user))
		new /obj/effect/temp_visual/kinetic_blast(T)
		for(var/atom/movable/AM in T)
			thrownatoms += AM

	for(var/am in thrownatoms)
		var/atom/movable/AM = am
		if(AM == user || AM.anchored)
			continue

		if(ismob(AM))
			var/mob/M = AM
			if(M.anti_magic_check())
				continue

		throwtarget = get_edge_target_turf(user, get_dir(user, get_step_away(AM, user)))
		distfromcaster = get_dist(user, AM)
		if(distfromcaster == 0)
			if(isliving(AM))
				var/mob/living/M = AM
				M.set_resting(TRUE, TRUE)
				M.adjustBruteLoss(20)
				to_chat(M, "<span class='danger'>我被 [user] 猛地砸向了地面！</span>")
		else
			new sparkle_path(get_turf(AM), get_dir(user, AM)) //created sparkles will disappear on their own
			if(isliving(AM))
				var/mob/living/M = AM
				M.set_resting(TRUE, TRUE)
				to_chat(M, "<span class='danger'>我被 [user] 的力量猛地震飞了出去！</span>")
			AM.safe_throw_at(throwtarget, ((CLAMP((maxthrow - (CLAMP(distfromcaster - 2, 0, distfromcaster))), 3, maxthrow))), 1,user, force = repulse_force)//So stuff gets tossed around at the same time.
	return TRUE
