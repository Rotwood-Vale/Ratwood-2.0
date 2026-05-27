// Ancient Champion-exclusive: An evil variant of Repulse. Longer charge time and CD, but greater maxthrow, push range and the affected people lose 50 stamina. The undead are immune.
/obj/effect/proc_holder/spell/invoked/churnliving //Repulse variant.
	name = "Churn Living"
	desc = "Conjure forth a wave of necrotic energy, repelling non-undead around you and greatly damaging their stamina."
	xp_gain = FALSE
	zizo_spell = TRUE
	releasedrain = 50
	chargedrain = 1
	chargetime = 20 //Four times longer charge.
	recharge_time = 40 SECONDS //15 seconds longer CD.
	human_req = TRUE
	ignore_los = TRUE
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokeascendant
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "repulse"
	spell_tier = 2
	invocations = list("Irzkrat, nullak!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_VAMPIRIC
	glow_intensity = GLOW_INTENSITY_HIGH
	gesture_required = TRUE
	var/maxthrow = 4 //1 tile more.
	var/sparkle_path = /obj/effect/temp_visual/gravpush
	var/repulse_force = MOVE_FORCE_EXTREMELY_STRONG
	var/push_range = 2 //1 tile more.

/obj/effect/proc_holder/spell/invoked/churnliving/cast(list/targets, mob/user, stun_amt = 5)
	var/list/thrownatoms = list()
	var/atom/throwtarget
	var/distfromcaster
	playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
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

		if(isliving(AM))
			var/mob/living/M = AM
			if(M.mob_biotypes & MOB_UNDEAD)
				continue

		throwtarget = get_edge_target_turf(user, get_dir(user, get_step_away(AM, user)))
		distfromcaster = get_dist(user, AM)
		if(distfromcaster == 0)
			if(isliving(AM))
				var/mob/living/M = AM
				M.set_resting(TRUE, TRUE)
				M.adjustBruteLoss(20)
				M.stamina_add(50) //50 stamina drain, x2 of Frostbolt's. The spell is very telegraphed.
				to_chat(M, "<span class='danger'>You're slammed into the floor by [user]! You feel enfeebled!</span>")
		else
			new sparkle_path(get_turf(AM), get_dir(user, AM)) //created sparkles will disappear on their own
			if(isliving(AM))
				var/mob/living/M = AM
				M.set_resting(TRUE, TRUE)
				to_chat(M, "<span class='danger'>You're thrown back by [user]!</span>")
			AM.safe_throw_at(throwtarget, ((CLAMP((maxthrow - (CLAMP(distfromcaster - 2, 0, distfromcaster))), 3, maxthrow))), 1,user, force = repulse_force)//So stuff gets tossed around at the same time.
	return TRUE
