/obj/effect/temp_visual/trap
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	light_outer_range = 2
	duration = 8
	layer = MASSIVE_OBJ_LAYER

/obj/effect/temp_visual/motivated_slash
	icon = 'icons/effects/effects.dmi'
	icon_state = "cut"
	dir = EAST
	name = "a motivated slash"
	desc = "A powerful slash of energy."
	randomdir = FALSE
	duration = 1 SECONDS
	layer = MASSIVE_OBJ_LAYER

// Finale indicator visual that can be created with a specific lifetime
/obj/effect/temp_visual/finale_indicator
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	light_outer_range = 2
	layer = MASSIVE_OBJ_LAYER
	// Allow passing a custom lifetime in seconds via New(loc, lifetime)
	New(loc, lifetime)
		// Make indicators red for high-visibility warning
		color = "#ff2a2a"
		if(lifetime)
			duration = lifetime
		..()

/datum/slash_stage
	var/delay = 0
	var/list/turf/slash_turfs = list()
	var/turf/sound_turf
	var/pre_slash_visual = /obj/effect/temp_visual/trap
	var/pre_slash_sound
	var/slash_sound = 'sound/motivation/swordswing.ogg'
	var/extra_slash_sound // optional second sound to play at slash moment
	var/damage = 150

/obj/effect/proc_holder/spell/invoked/slash
	name = "slash"
	desc = "Slash abstract. You shouldn't be able to learn this."
	warnie = "spellwarning"
	cost = 0
	range = 1
	chargetime = 0
	no_early_release = FALSE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	gesture_required = FALSE

/obj/effect/proc_holder/spell/invoked/slash/proc/get_slash_stages(targets, mob/user)
	return

/obj/effect/proc_holder/spell/invoked/slash/proc/execute_stage(datum/slash_stage/stage, mob/user)
	if(!stage.slash_turfs?.len)
		return TRUE

	if(stage.pre_slash_sound)
		playsound(stage.sound_turf, stage.pre_slash_sound, 75, TRUE, soundping = TRUE)
	for(var/turf/T in stage.slash_turfs)
		new stage.pre_slash_visual(T)

	if(!do_after(user, stage.delay, user))
		return FALSE
	
	if(stage.slash_sound)
		playsound(stage.sound_turf, stage.slash_sound, 75, TRUE, soundping = TRUE)
	if(stage.extra_slash_sound)
		// Play the extra slash sound from the caster's location instead of the slash turf cluster
		playsound(user, stage.extra_slash_sound, 80, TRUE, soundping = TRUE)
	for(var/turf/T in stage.slash_turfs)
		do_slash(T, user, stage.damage)
	
	return TRUE

/obj/effect/proc_holder/spell/invoked/slash/proc/do_slash(turf/T, mob/user, damage)
	if(!istype(T))
		return
	new /obj/effect/temp_visual/motivated_slash(T)
	for(var/mob/living/L in T.contents)
		L.adjustBruteLoss(damage)
		playsound(T, "genslash", 80, TRUE)
		to_chat(L, "<span class='userdanger'>You're cut by the sword!</span>")

/obj/effect/proc_holder/spell/invoked/slash/cast(list/targets, mob/user)
	var/hm_sound = pick('sound/motivation/hm1.ogg', 'sound/motivation/hm2.ogg', 'sound/motivation/hm3.ogg', 'sound/motivation/hm4.ogg')
	playsound(user, hm_sound, 75, TRUE)
	var/list/slash_stages = get_slash_stages(targets, user)

	if(!slash_stages)
		return

	for(var/stage in slash_stages)
		if(!execute_stage(stage, user))
			break

/obj/effect/proc_holder/spell/invoked/slash/motivated_slash
	name = "Motivated Slash"
	desc = "A powerful line slash. Is three tiles long and is unblockable."
	warnie = "spellwarning"
	cost = 1
	range = 1
	chargetime = 0
	no_early_release = FALSE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	invocations = list("Hmph!")
	invocation_type = "shout"
	gesture_required = FALSE
	sound = 'sound/motivation/hm1.ogg'
	var/initial_delay = 1 SECONDS
	var/damage = 150 
	var/area_of_effect = 3 

/obj/effect/proc_holder/spell/invoked/slash/motivated_slash/get_slash_stages(targets, mob/user)
	var/list/datum/slash_stage/stages = list()

	if(!area_of_effect)
		return

	var/turf/target_turf = get_turf(targets[1])
	var/turf/source_turf = get_turf(user)
	var/dir = get_dir(source_turf, target_turf)
	var/turf/current_turf = get_step(source_turf, dir)

	var/datum/slash_stage/S = new
	S.delay = initial_delay
	S.damage = damage
	S.sound_turf = current_turf 
	S.slash_turfs += current_turf
	
	for(var/i in 1 to area_of_effect)
		if(!inLineOfTravel(user, current_turf))
			break
		S.slash_turfs += current_turf
		current_turf = get_step(current_turf, dir)

	stages += S
	return stages

/obj/effect/proc_holder/spell/invoked/slash/motivated_omnislash
	name = "Motivated Omni Slash"
	desc = "A powerful omni slash, swings three times, once one tile around you, then two tiles around you, then three tiles around you. Is unblockable."
	warnie = "spellwarning"
	cost = 2
	range = 1
	chargetime = 0
	no_early_release = FALSE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	invocations = list("Pathetic.")
	invocation_type = "shout"
	sound = 'sound/motivation/pathetic.ogg'
	var/initial_delay = 1.5 SECONDS
	var/stage_delay = 0.75 SECONDS
	var/damage = 100

/obj/effect/proc_holder/spell/invoked/slash/motivated_omnislash/get_slash_stages(targets, mob/user)
	var/list/datum/slash_stage/stages = list()


	var/turf/source_turf = get_turf(user)


	for(var/radius in 1 to 3)
		var/datum/slash_stage/S = new
		if(radius == 1 || radius == 2)
			S.pre_slash_sound = pick('sound/motivation/grunt1.ogg', 'sound/motivation/grunt2.ogg')
		else if(radius == 3)
			S.pre_slash_sound = pick('sound/motivation/gruntbig1.ogg', 'sound/motivation/gruntbig2.ogg', 'sound/motivation/gruntbig3.ogg')

		S.delay = (radius==1) ? initial_delay : stage_delay
		S.damage = damage
		S.sound_turf = source_turf
		S.slash_turfs += circlerangeturfs(center=source_turf, radius=(radius+0.45)) - source_turf
		for(var/turf/T in S.slash_turfs)	
			if(!inLineOfTravel(user, T))
				S.slash_turfs -= T
		stages += S

	return stages

/obj/effect/proc_holder/spell/invoked/slash/motivated_omnislash/do_slash(turf/T, mob/user, damage)
	new /obj/effect/temp_visual/motivated_slash(T)
	for(var/mob/living/L in T.contents)
		L.adjustBruteLoss(damage)
		playsound(T, "genslash", 80, TRUE)
		to_chat(L, "<span class='userdanger'>You're cut by the sword!</span>")
		var/knock_dir = get_dir(user, L)
		if(knock_dir)
			step(L, knock_dir)
			to_chat(L, "<span class='userdanger'>You're knocked back by the force of the slash!</span>")



/obj/effect/proc_holder/spell/invoked/slash/motivated_xslash
	name = "Motivated X Slash"
	desc = "A powerful X slash, slashe in an X pattern centered on the target. Is unblockable."
	warnie = "spellwarning"
	cost = 3
	range = 3
	chargetime = 0
	no_early_release = FALSE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	invocations = list("Cut off!")
	invocation_type = "shout"
	sound = 'sound/motivation/cutoff.ogg'
	var/initial_delay = 1.5 SECONDS
	var/damage = 150
	var/area_of_effect = 3


/obj/effect/proc_holder/spell/invoked/slash/motivated_xslash/get_slash_stages(targets, mob/user)
	var/list/datum/slash_stage/stages = list()
	if(!area_of_effect)
		return
	var/turf/center = get_turf(targets[1])
	var/list/x_turfs = list()
	var/dirs = list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
	for(var/dir in dirs)
		var/turf/current = center
		for(var/i = 1 to area_of_effect)
			current = get_step(current, dir)
			if(!current)
				break
			if(!inLineOfTravel(user, current))
				break
			x_turfs += current
	var/datum/slash_stage/S = new
	S.delay = initial_delay
	S.damage = damage
	S.sound_turf = center
	S.slash_turfs = x_turfs
	stages += S
	return stages

/obj/effect/proc_holder/spell/invoked/slash/judgement_cut/
	name = "Judgement Cut"
	desc = "You already know what this is."
	warnie = "spellwarning"
	cost = 3
	range = 5
	chargetime = 0
	no_early_release = FALSE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	var/initial_delay = 2 SECONDS
	var/stage_delay = 1 SECONDS
	var/damage = 150
	var/area_of_effect = 5


/obj/effect/proc_holder/spell/invoked/slash/judgement_cut/get_slash_stages(targets, mob/user)
	var/list/datum/slash_stage/stages = list()
	var/turf/center = get_turf(targets[1])
	var/list/radii = list(1, 2) // 3x3 then 6x6
	var/list/sizes = list(1.5, 3.0) // radii for circle proc
	for(var/i = 1 to 2)
		var/datum/slash_stage/S = new
		S.delay = (i == 1) ? initial_delay : stage_delay
		S.damage = damage
		S.sound_turf = center
		S.slash_sound = 'sound/motivation/judgement.ogg'
		var/list/slash_turfs = list()
		// Circle
		for(var/turf/T in circlerangeturfs(center=center, radius=sizes[i]))
			if(T != center && inLineOfTravel(user, T))
				slash_turfs += T
		// X pattern
		var/dirs = list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
		for(var/dir in dirs)
			var/turf/current = center
			for(var/j = 1 to radii[i])
				current = get_step(current, dir)
				if(!current)
					break
				if(inLineOfTravel(user, current))
					slash_turfs += current
		S.slash_turfs = slash_turfs
		stages += S
	return stages


/obj/effect/proc_holder/spell/invoked/slash/motivated_blink
	name = "Motivated Blink"
	desc = "A short-range teleport that leaves a damaging slash at your starting location."
	warnie = "spellwarning"
	cost = 2
	range = 5
	chargetime = 0
	no_early_release = FALSE
	gesture_required = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	var/initial_delay = 1 SECONDS
	var/stage_delay = 1 SECONDS
	var/damage = 65
	var/area_of_effect = 2

/obj/effect/proc_holder/spell/invoked/slash/motivated_blink/cast(list/targets, mob/user)
	var/hm_sound = pick('sound/motivation/hm1.ogg', 'sound/motivation/hm2.ogg', 'sound/motivation/hm3.ogg', 'sound/motivation/hm4.ogg')
	playsound(user, hm_sound, 75, TRUE)
	var/turf/source_turf = get_turf(user)
	var/turf/target_turf = get_turf(targets[1])
	if(!inLineOfTravel(user, target_turf))
		to_chat(user, "<span class='warning'>You can't blink there!</span>")
		return
	if(source_turf == target_turf)
		to_chat(user, "<span class='warning'>You can't blink to the same spot!</span>")
		return
	if(target_turf.density || !inLineOfTravel(user, target_turf))
		to_chat(user, "<span class='warning'>You can't blink there!</span>")
		return
	if(!do_after(user, initial_delay, user))
		return
	user.loc = target_turf
	playsound(user, 'sound/motivation/judgement.ogg', 75, TRUE)
	var/list/datum/slash_stage/stages = list()
	if(area_of_effect)
		var/datum/slash_stage/S = new
		S.delay = stage_delay
		S.damage = damage
		S.sound_turf = source_turf
		S.slash_sound = 'sound/motivation/swordswing.ogg'
		var/list/slash_turfs = list()
		for(var/turf/T in circlerangeturfs(center=source_turf, radius=(area_of_effect+0.45)) - source_turf)
			if(!T.density && inLineOfTravel(user, T))
				slash_turfs += T
		S.slash_turfs = slash_turfs
		stages += S

	for(var/stage in stages)
		if(!execute_stage(stage, user))
			break


/obj/effect/proc_holder/spell/self/motivated_deviltrigger
	name = "Devil Trigger"
	desc = "Show them who you truly are."
	warnie = "spellwarning"
	cost = 3
	range = 0
	chargetime = 0
	no_early_release = FALSE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen

/obj/effect/proc_holder/spell/self/motivated_deviltrigger/cast(list/targets, mob/user)
	if(!istype(user, /mob/living))
		return
	playsound(user, 'sound/motivation/ineedpower.ogg', 75, TRUE)
	var/mob/living/L = user
	// Heal brute and oxygen damage by 300 each (clamped by current damage values). It works I think.
	if(istype(L, /mob/living))
		var/brute = L.bruteloss
		if(brute)
			L.adjustBruteLoss(-min(300, brute))
	if(istype(L, /mob/living))
		var/oxy = L.oxyloss
		if(oxy)
			L.adjustOxyLoss(-min(300, oxy))
	if(isliving(L) && L.blood_volume)
		var/max_blood = L:vars["max_blood_volume"] ? L:vars["max_blood_volume"] : 0
		var/needed = max_blood - L.blood_volume
		if(needed > 0)
			L.blood_volume = max_blood
	to_chat(L, "<span class='notice'>You feel demonic power surging through you!</span>")

/obj/effect/proc_holder/spell/invoked/slash/motivated_slash_ex
	name = "Motivated Slash EX"
	desc = "An enhanced version of Motivated Slash that reaches 10 tiles long. Is unblockable."
	warnie = "spellwarning"
	cost = 2
	range = 1
	chargetime = 0
	no_early_release = FALSE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	var/initial_delay = 1 SECONDS
	var/damage = 125
	var/area_of_effect = 10


/obj/effect/proc_holder/spell/invoked/slash/motivated_slash_ex/get_slash_stages(targets, mob/user)
	var/list/datum/slash_stage/stages = list()

	if(!area_of_effect)
		return

	var/turf/target_turf = get_turf(targets[1])
	var/turf/source_turf = get_turf(user)
	var/dir = get_dir(source_turf, target_turf)
	var/turf/current_turf = get_step(source_turf, dir)

	var/datum/slash_stage/S = new
	S.delay = initial_delay
	S.damage = damage
	S.sound_turf = current_turf 
	S.slash_turfs += current_turf
	
	for(var/i in 1 to area_of_effect)
		if(!inLineOfTravel(user, current_turf))
			break
		S.slash_turfs += current_turf
		current_turf = get_step(current_turf, dir)

	stages += S
	return stages


/obj/effect/proc_holder/spell/invoked/slash/motivated_omnislash_ex
	name = "Motivated Omni Slash EX"
	desc = "An enhanced version of Motivated Omni Slash, swings four times, once one tile around you, then two tiles around you, then three tiles around you, then four tiles around you. Is unblockable."
	warnie = "spellwarning"
	cost = 4
	range = 1
	chargetime = 0
	no_early_release = FALSE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	var/initial_delay = 1.2 SECONDS
	var/stage_delay = 0.75 SECONDS
	var/damage = 100
	var/area_of_effect = 4

/obj/effect/proc_holder/spell/invoked/slash/motivated_omnislash_ex/get_slash_stages(targets, mob/user)
	var/list/datum/slash_stage/stages = list()
	var/turf/source_turf = get_turf(user)
	// Radii 1 through 4
	for(var/radius in 1 to 4)
		var/datum/slash_stage/S = new
		if(radius < 4)
			S.pre_slash_sound = pick('sound/motivation/hmdt1.ogg', 'sound/motivation/hmdt2.ogg', 'sound/motivation/hmdt3.ogg', 'sound/motivation/hmdt4.ogg', 'sound/motivation/hmdt5.ogg')
		else
			S.pre_slash_sound = pick('sound/motivation/biggruntdt1.ogg', 'sound/motivation/biggruntdt2.ogg', 'sound/motivation/biggruntdt3.ogg')
		S.delay = (radius==1) ? initial_delay : stage_delay
		S.damage = damage
		S.sound_turf = source_turf
		S.slash_turfs += circlerangeturfs(center=source_turf, radius=(radius+0.45)) - source_turf
		for(var/turf/T in S.slash_turfs)
			if(!inLineOfTravel(user, T))
				S.slash_turfs -= T
		stages += S

	// Spiral final stage (treated as additional slash stage), sampled along a polar spiral for a circular appearance
	var/datum/slash_stage/Spiral = new
	Spiral.delay = stage_delay
	Spiral.damage = damage
	Spiral.sound_turf = source_turf
	Spiral.pre_slash_sound = pick('sound/motivation/biggruntdt1.ogg', 'sound/motivation/biggruntdt2.ogg', 'sound/motivation/biggruntdt3.ogg')
	Spiral.slash_sound = 'sound/motivation/judgement.ogg'
	Spiral.extra_slash_sound = 'sound/motivation/begonedt.ogg'
	var/max_radius = 14 // big....
	var/total_steps = max_radius * 12 // density of spiral samples
	var/angle_step = 20 // degrees per sample
	var/list/seen = list()
	for(var/s = 1 to total_steps)
		var/angle = s * angle_step
		var/radius = (max_radius * s) / total_steps
		var/nx = round(source_turf.x + radius * cos(angle))
		var/ny = round(source_turf.y + radius * sin(angle))
		var/turf/NT = locate(nx, ny, source_turf.z)
		if(!isturf(NT) || NT == source_turf)
			continue
		if(NT in seen)
			continue
		if(!inLineOfTravel(user, NT))
			continue
		seen[NT] = TRUE
		Spiral.slash_turfs += NT
	stages += Spiral
	return stages

/obj/effect/proc_holder/spell/invoked/slash/motivated_omnislash_ex/do_slash(turf/T, mob/user, damage)
	// Same as motivated_omnislash with knockback
	if(!istype(T))
		return
	new /obj/effect/temp_visual/motivated_slash(T)
	for(var/mob/living/L in T.contents)
		L.adjustBruteLoss(damage)
		playsound(T, "genslash", 80, TRUE)
		to_chat(L, "<span class='userdanger'>You're cut by the sword!</span>")
		var/knock_dir = get_dir(user, L)
		if(knock_dir)
			step(L, knock_dir)
			to_chat(L, "<span class='userdanger'>You're knocked back by the force of the slash!</span>")

/obj/effect/proc_holder/spell/invoked/slash/judgement_cut_ex
	name = "Judgement Cut EX"
	desc = "An enhanced version of Judgement Cut that adds a third, spiral slash stage after the first two stages."
	warnie = "spellwarning"
	cost = 4
	range = 5
	chargetime = 0
	no_early_release = FALSE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	var/initial_delay = 0.5 SECONDS
	var/stage_delay = 0.5 SECONDS
	var/damage = 125
	var/area_of_effect = 5

/obj/effect/proc_holder/spell/invoked/slash/judgement_cut_ex/get_slash_stages(targets, mob/user)
	var/list/datum/slash_stage/stages = list()
	if(!area_of_effect || !targets || !(islist(targets) && length(targets)))
		return
	var/turf/center = get_turf(targets[1])
	if(!isturf(center))
		return

	// identical to original judgement cut for first two stages
	var/list/radii = list(1, 2)
	var/list/sizes = list(1.5, 3.0)
	for(var/i = 1 to 2)
		var/datum/slash_stage/S = new
		S.delay = (i == 1) ? initial_delay : stage_delay
		S.damage = damage
		S.sound_turf = center
		S.slash_sound = 'sound/motivation/judgement.ogg'
		var/list/slash_turfs = list()
		// ciiircle.
		for(var/turf/T in circlerangeturfs(center=center, radius=sizes[i]))
			if(T != center && inLineOfTravel(user, T))
				slash_turfs += T
		// X pattern
		var/dirs = list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
		for(var/dir in dirs)
			var/turf/current = center
			for(var/j = 1 to radii[i])
				current = get_step(current, dir)
				if(!current)
					break
				if(inLineOfTravel(user, current))
					slash_turfs += current
		S.slash_turfs = slash_turfs
		stages += S

	// This is actually getting fun to code!
	var/datum/slash_stage/Spiral = new
	Spiral.delay = stage_delay
	Spiral.damage = damage
	Spiral.sound_turf = center
	Spiral.pre_slash_sound = pick('sound/motivation/biggruntdt1.ogg', 'sound/motivation/biggruntdt2.ogg', 'sound/motivation/biggruntdt3.ogg')
	Spiral.slash_sound = 'sound/motivation/judgement.ogg'
	Spiral.extra_slash_sound = 'sound/motivation/urfinisheddt.ogg'
	var/max_radius = 6
	var/total_steps = max_radius * 12
	var/angle_step = 20
	var/list/seen = list()
	for(var/s = 1 to total_steps)
		var/angle = s * angle_step
		var/radius = (max_radius * s) / total_steps
		var/nx = round(center.x + radius * cos(angle))
		var/ny = round(center.y + radius * sin(angle))
		var/turf/NT = locate(nx, ny, center.z)
		if(!isturf(NT) || NT == center)
			continue
		if(NT in seen)
			continue
		if(!inLineOfTravel(user, NT))
			continue
		seen[NT] = TRUE
		Spiral.slash_turfs += NT
	stages += Spiral

	return stages


/obj/effect/proc_holder/spell/invoked/slash/motivated_blink_ex
	name = "Motivated Blink EX"
	desc = "An enhanced version of Motivated Blink that leaves a larger damaging slash at your starting location, but also one where you arrive."
	warnie = "spellwarning"
	cost = 3
	range = 7
	chargetime = 0
	no_early_release = FALSE
	gesture_required = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	var/initial_delay = 0.15 SECONDS
	var/stage_delay = 0.15 SECONDS
	var/damage = 110
	var/area_of_effect = 3

/obj/effect/proc_holder/spell/invoked/slash/motivated_blink_ex/cast(list/targets, mob/user)
	var/hm_sound = pick('sound/motivation/hmdt1.ogg', 'sound/motivation/hmdt2.ogg', 'sound/motivation/hmdt3.ogg', 'sound/motivation/hmdt4.ogg')
	playsound(user, hm_sound, 75, TRUE)
	var/turf/source_turf = get_turf(user)
	var/turf/target_turf = get_turf(targets[1])
	if(!inLineOfTravel(user, target_turf))
		to_chat(user, "<span class='warning'>You can't blink there!</span>")
		return
	if(source_turf == target_turf)
		to_chat(user, "<span class='warning'>You can't blink to the same spot!</span>")
		return
	if(target_turf.density || !inLineOfTravel(user, target_turf))
		to_chat(user, "<span class='warning'>You can't blink there!</span>")
		return
	if(!do_after(user, initial_delay, user))
		return
	// first stage
	var/list/datum/slash_stage/stages = list()
	if(area_of_effect)
		var/datum/slash_stage/S1 = new
		S1.delay = stage_delay
		S1.damage = damage
		S1.sound_turf = source_turf
		S1.slash_sound = 'sound/motivation/swordswing.ogg'
		var/list/slash_turfs1 = list()
		for(var/turf/T in circlerangeturfs(center=source_turf, radius=(area_of_effect+0.45)) - source_turf)
			if(!T.density && inLineOfTravel(user, T))
				slash_turfs1 += T
		S1.slash_turfs = slash_turfs1
		stages += S1

	// Teleport and then build second stage at new location
	user.loc = target_turf
	playsound(user, 'sound/motivation/judgement.ogg', 75, TRUE)
	if(area_of_effect)
		var/datum/slash_stage/S2 = new
		S2.delay = stage_delay
		S2.damage = damage
		S2.sound_turf = target_turf
		S2.slash_sound = 'sound/motivation/swordswing.ogg'
		S2.extra_slash_sound = 'sound/motivation/standasidedt.ogg'
		var/list/slash_turfs2 = list()
		for(var/turf/T in circlerangeturfs(center=target_turf, radius=(area_of_effect+0.45)) - target_turf)
			if(!T.density && inLineOfTravel(user, T))
				slash_turfs2 += T
		S2.slash_turfs = slash_turfs2
		stages += S2

	for(var/stage in stages)
		if(!execute_stage(stage, user))
			break

/obj/effect/proc_holder/spell/invoked/slash/motivated_grandfinale
	name = "The Grand Finale"
	desc = "You are the storm that is approaching. Teleport to target location, and unleash the end."
	warnie = "spellwarning"
	cost = 5
	range = 7
	chargetime = 0
	no_early_release = FALSE
	gesture_required = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	var/initial_delay = 0.15 SECONDS
	var/stage_delay = 0.15 SECONDS
	var/damage = 150
	var/area_of_effect = 20
	// Total time until final slash drop (buildup + telegraph padding). Re-tuned for 13.5s total.
	var/finale_delay = 14.5 SECONDS
	var/finale_damage = 1000
	var/finale_area_of_effect = 50
	// Song audio to play during buildup; set by adding a valid file path later.
	var/song = 'sound/motivation/finale.ogg'
	var/beat_interval = 0.6 SECONDS // interval between buildup slashes (cardinals)
	// Retuned timeline: 13.5s slashing buildup, 2.5s grace (no slashes), 7.5s indicators, then detonation
	var/buildup_duration = 13.5 SECONDS
	var/grace_duration = 2.5 SECONDS
	var/indicator_duration = 7.5 SECONDS
	var/telegraph_visual = /obj/effect/temp_visual/trap
	var/finale_pre_sound = 'sound/motivation/judgement.ogg'
	var/finale_slash_sound = 'sound/motivation/judgement.ogg'
	var/finale_extra_sound // optional secondary sound user may set later
	// Buildup strike distance progression (tiles from caster)
	var/buildup_start_range = 2
	var/buildup_end_range = 13


/obj/effect/proc_holder/spell/invoked/slash/motivated_grandfinale/cast(list/targets, mob/user)
	if(!targets?.len)
		return
	var/turf/target_turf = get_turf(targets[1])
	if(!inLineOfTravel(user, target_turf))
		to_chat(user, "<span class='warning'>You can't manifest the finale there!</span>")
		return
	if(!do_after(user, initial_delay, user))
		return
	// Teleport user to target center (dramatic reposition)
	user.loc = target_turf
	// Start song (non-positional from caster)
	if(song)
		playsound(user, song, 80, TRUE)

	// Enable temporary GODMODE for the duration of the finale sequence
	if(isliving(user))
		var/mob/living/L = user
		L.status_flags |= GODMODE
		// Local narration so nearby players notice the barrier
		user.visible_message(span_reallybigboldnotice("[user] is veiled by a magical barrier — they cannot be hurt! Start dodging!"))

	// Schedule randomized, telegraphed strikes during the buildup period.
	// Each tick schedules a small pattern whose indicators linger for a randomized delay (1.5–3.0s) before slashing.
	var/elapsed = 0
	var/delay_ds = 0
	while(elapsed < buildup_duration && user)
		delay_ds = rand(15, 30) // 1.5s to 3.0s in deciseconds
		if(elapsed + delay_ds > buildup_duration)
			// Not enough time left in buildup to telegraph and strike; stop scheduling.
			break
		// Linearly scale distance from start to end over buildup using integer math
		var/delta = buildup_end_range - buildup_start_range
		var/den = (buildup_duration > 0) ? buildup_duration : 1
		var/distance = buildup_start_range + round((delta * elapsed) / den)
		var/pattern = pick("cardinal", "x", "spiral")
		var/list/strike_turfs = list()
		if(pattern == "cardinal")
			// One tile at the chosen distance in each cardinal direction
			for(var/dir in list(NORTH, SOUTH, EAST, WEST))
				var/turf/T = get_turf(user)
				for(var/i = 1 to distance)
					T = get_step(T, dir)
					if(!T)
						break
				if(T && inLineOfTravel(user, T))
					strike_turfs += T
		else if(pattern == "x")
			// Diagonals at the chosen distance
			for(var/dir in list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
				var/turf/T = get_turf(user)
				for(var/i = 1 to distance)
					T = get_step(T, dir)
					if(!T)
						break
				if(T && inLineOfTravel(user, T))
					strike_turfs += T
		else
			// Small spiral arc around the chosen radius
			var/turf/center = get_turf(user)
			var/steps = 12
			var/start_angle = rand(0, 359)
			for(var/s = 1 to steps)
				var/angle = start_angle + s * (360 / steps)
				var/r = (distance - 1) + (s / steps) * 2 // sweep ~[distance-1, distance+1]
				var/nx = round(center.x + r * cos(angle))
				var/ny = round(center.y + r * sin(angle))
				var/turf/NT = locate(nx, ny, center.z)
				if(!isturf(NT) || NT == center)
					continue
				if(!inLineOfTravel(user, NT))
					continue
				if(!(NT in strike_turfs))
					strike_turfs += NT

		// Telegraph indicators for the randomized delay, then detonate this micro-strike
		if(strike_turfs.len)
			for(var/turf/T in strike_turfs)
				new /obj/effect/temp_visual/finale_indicator(T, delay_ds)
			// After delay, execute the slashes and play swing sound
			spawn(delay_ds)
				playsound(user, 'sound/motivation/swordswing.ogg', 70, TRUE)
				for(var/turf/T in strike_turfs)
					do_slash(T, user, damage)

		// Also apply an immediate protective ring of slashes around the user each beat
		for(var/turf/RT in range(1, user))
			if(RT == user.loc)
				continue
			if(get_dist(RT, user) == 1 && inLineOfTravel(user, RT))
				do_slash(RT, user, damage)

		sleep(beat_interval)
		elapsed += beat_interval

	// Grace phase: dramatic pause with the song
	sleep(grace_duration)

	// Build spiral telegraph points (safe/unsafe) for the finale
	var/turf/finale_center = get_turf(user)
	var/list/finale_turfs = list()
	var/max_radius = finale_area_of_effect
	var/total_steps = max_radius * 16
	var/angle_step = 15
	var/list/seen = list()
	for(var/s = 1 to total_steps)
		var/angle = s * angle_step
		var/radius = (max_radius * s) / total_steps
		var/nx = round(finale_center.x + radius * cos(angle))
		var/ny = round(finale_center.y + radius * sin(angle))
		var/turf/NT = locate(nx, ny, finale_center.z)
		if(!isturf(NT) || NT == finale_center)
			continue
		if(NT in seen)
			continue
		if(!inLineOfTravel(user, NT))
			continue
		seen[NT] = TRUE
		finale_turfs += NT

	// Start indicator visuals for indicator_duration using a dedicated indicator effect
	for(var/turf/T in finale_turfs)
		new /obj/effect/temp_visual/finale_indicator(T, indicator_duration)

	// Play the drop now as indicators appear
	if(finale_slash_sound)
		playsound(finale_center, finale_slash_sound, 90, TRUE, soundping = TRUE)
	if(finale_extra_sound)
		playsound(user, finale_extra_sound, 80, TRUE)

	// Let indicators linger before detonation
	sleep(indicator_duration)

	// Detonate the finale: apply damage along the spiral
	for(var/turf/T in finale_turfs)
		spawn() do_slash(T, user, finale_damage)

	to_chat(user, "<span class='notice'>The Grand Finale is complete.</span>")

	// Disable GODMODE now that the finale sequence has concluded
	if(isliving(user))
		var/mob/living/L2 = user
		L2.status_flags &= ~GODMODE
		user.visible_message(span_boldnotice("The magical barrier around [user] dissipates."))


