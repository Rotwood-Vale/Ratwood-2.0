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

/datum/slash_stage
	var/delay = 0
	var/list/turf/slash_turfs = list()
	var/turf/sound_turf
	var/pre_slash_visual = /obj/effect/temp_visual/trap
	var/pre_slash_sound
	var/slash_sound = 'sound/motivation/swordswing.ogg'
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
	for(var/turf/T in stage.slash_turfs)
		do_slash(T, user, stage.damage)
	
	return TRUE

/obj/effect/proc_holder/spell/invoked/slash/proc/do_slash(turf/T, mob/user, damage)
	if(!istype(T) || T.density)
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
			if(!current || current.density)
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
			if(T != center && !T.density && inLineOfTravel(user, T))
				slash_turfs += T
		// X pattern
		var/dirs = list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
		for(var/dir in dirs)
			var/turf/current = center
			for(var/j = 1 to radii[i])
				current = get_step(current, dir)
				if(!current || current.density)
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
