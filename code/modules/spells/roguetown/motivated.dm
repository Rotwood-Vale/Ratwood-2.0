
/obj/effect/proc_holder/spell/invoked/motivated_slash
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
	spell_type = SPELL_TYPE_INVOKED
	invocation_type = "shout"
	glow_color = GLOW_COLOR_RED
	glow_intensity = GLOW_INTENSITY_HIGH
	gesture_required = FALSE
	ignore_los = FALSE
	sound = 'sound/motivation/hm1.ogg'
	var/delay = 2
	var/damage = 150 // High damage for a single target attack
	var/area_of_effect = 3 // 3 tiles in a line


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


/obj/effect/proc_holder/spell/invoked/motivated_slash/cast(list/targets, mob/user)
	var/turf/source_turf = get_turf(user)
	var/turf/T = get_turf(targets[1])
	var/dir = get_dir(source_turf, T)
	var/turf/current_turf = source_turf
	var/list/slash_turfs = list()
	for(var/i = 0; i < area_of_effect; i++)
		current_turf = get_step(current_turf, dir)
		if(!current_turf)
			break
		if(current_turf.density)
			break
		new /obj/effect/temp_visual/trap(current_turf)
		slash_turfs += current_turf
	playsound(T, 'sound/motivation/swordswing.ogg', 75, TRUE, soundping = TRUE)

	// Immediately apply effects to all valid turfs
	for(var/turf/target_turf in slash_turfs)
		do_motivated_slash_effect(target_turf, damage)

// Handles damage logic for motivated slash
/obj/effect/proc_holder/spell/invoked/motivated_slash/proc/do_motivated_slash_effect(turf/target_turf, damage)
	if(!target_turf || target_turf.density)
		return
	new /obj/effect/temp_visual/motivated_slash(target_turf)
	for(var/mob/living/L in target_turf.contents)
		play_cleave = TRUE
		L.adjustBruteLoss(damage)
		playsound(target_turf, "genslash", 80, TRUE)
		to_chat(L, "<span class='userdanger'>You're cut by the sword!</span>")

/obj/effect/proc_holder/spell/invoked/motivated_omnislash
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
	spell_type = SPELL_TYPE_INVOKED
	invocation_type = "shout"
	glow_color = GLOW_COLOR_RED
	glow_intensity = GLOW_INTENSITY_HIGH
	gesture_required = FALSE
	ignore_los = FALSE
	sound = 'sound/motivation/pathetic.ogg'
	var/delay = 2
	var/slashing = FALSE
	var/damage = 100 // Moderate damage for a multi-target attack
	var/area_of_effect = 1

/obj/effect/proc_holder/spell/invoked/motivated_omnislash/cast(list/targets, mob/user)
	var/turf/T = get_turf(targets[1])
	var/turf/source_turf = get_turf(user)
	if(T.z > user.z)
		source_turf = get_step_multiz(source_turf, UP)
	if(T.z < user.z)
		source_turf = get_step_multiz(source_turf, DOWN)


	src.slashing = TRUE
	var/list/all_turfs = list()
	for(var/radius = 1; radius <= 3; radius++)
		var/grunt_sound
		if(radius == 1 || radius == 2)
			grunt_sound = pick('sound/motivation/grunt1.ogg', 'sound/motivation/grunt2.ogg')
		else if(radius == 3)
			grunt_sound = pick('sound/motivation/gruntbig1.ogg', 'sound/motivation/gruntbig2.ogg', 'sound/motivation/gruntbig3.ogg')
		playsound(user, grunt_sound, 75, TRUE)

		for(var/turf/affected_turf in circle(radius, source_turf))
			if(!affected_turf)
				continue
			if(affected_turf.density)
				continue
			new /obj/effect/temp_visual/trap(affected_turf)
			all_turfs += affected_turf
		playsound(T, 'sound/motivation/swordswing.ogg', 55, TRUE, soundping = TRUE)

	// Block movement for the total duration
	var/total_delay = delay * all_turfs.len
	user.do_after(total_delay, CALLBACK(src, PROC_REF(end_omnislash), user))

	// Schedule each slash effect
	for(var/i = 1, i <= all_turfs.len, i++)
		var/turf/current_turf = all_turfs[i]
		addtimer(CALLBACK(src, PROC_REF(do_omnislash_effect), current_turf, user, damage), delay * (i - 1))

/obj/effect/proc_holder/spell/invoked/motivated_omnislash/proc/do_omnislash_effect(turf/affected_turf, mob/user, damage, initial_loc)
	if(!src.slashing)
		return
	if(!affected_turf || affected_turf.density)
		return
	new /obj/effect/temp_visual/blade_burst(affected_turf)
	for(var/mob/living/L in affected_turf.contents)
		play_cleave = TRUE
		L.adjustBruteLoss(damage)
		playsound(affected_turf, "genslash", 80, TRUE)
		to_chat(L, "<span class='userdanger'>You're cut by the sword!</span>")
		var/knock_dir = get_dir(user, L)
		if(knock_dir)
			step(L, knock_dir)
			to_chat(L, "<span class='userdanger'>You're knocked back by the force of the slash!</span>")

/obj/effect/proc_holder/spell/invoked/motivated_omnislash/proc/end_omnislash(mob/user)
	src.slashing = FALSE
	if(!isnull(user.do_after))
		user.do_after = FALSE


/obj/effect/proc_holder/spell/self/motivated_power
	name = "Power Surge"
	desc = "I need MORE POWER!"
	chargetime = 0
	no_early_release = FALSE
	movement_interrupt = FALSE
	charging_slowdown = 1
	invocations = list("I need MORE POWER!")
	spell_type = SPELL_TYPE_SELF
	invocation_type = "shout"
	sound = "sound/motivation/ineedpower.ogg"

/obj/effect/proc_holder/spell/self/motivated_power/cast(mob/user)

	to_chat(user, "<span class='userdanger'>You feel a surge of power coursing through your body!</span>")
	// Apply the healing buff to the user
	user.add_status_effect(/datum/status_effect/buff/healing, user, 5)

/datum/status_effect/buff/healing
	id = "healing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing
	duration = 10 SECONDS
	examine_text = "SUBJECTPRONOUN is bathed in a MOTIVATED aura!"
	var/healing_on_tick = 5
	var/outline_colour = "#c42424"

/datum/status_effect/buff/healing/on_creation(mob/living/new_owner, new_healing_on_tick)
	healing_on_tick = new_healing_on_tick
	return ..()

/datum/status_effect/buff/healing/on_apply()
	SEND_SIGNAL(owner, COMSIG_LIVING_MIRACLE_HEAL_APPLY, healing_on_tick, src)
	var/filter = owner.get_filter(MIRACLE_HEALING_FILTER)
	if (!filter)
		owner.add_filter(MIRACLE_HEALING_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	return TRUE

	/datum/status_effect/buff/healing/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = "#FF0000"
	var/list/wCount = owner.get_wounds()
	if(!owner.construct)
		if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
			owner.blood_volume = min(owner.blood_volume+healing_on_tick, BLOOD_VOLUME_NORMAL)
		if(wCount.len > 0)
			owner.heal_wounds(healing_on_tick)
			owner.update_damage_overlays()
		owner.adjustBruteLoss(-healing_on_tick, 0)
		owner.adjustFireLoss(-healing_on_tick, 0)
		owner.adjustOxyLoss(-healing_on_tick, 0)
		owner.adjustToxLoss(-healing_on_tick, 0)
		owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
		owner.adjustCloneLoss(-healing_on_tick, 0)

// yes i shamelessly stole this from the miracle heal spell thingy..


