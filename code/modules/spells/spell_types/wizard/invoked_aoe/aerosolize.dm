/obj/effect/proc_holder/spell/invoked/aerosolize
	name = "Aerosolize" //once again renamed to fit better :)
	desc = "Turns a container of liquid into a smoke containing the reagents of that liquid."
	overlay_state = "aerosolize"
	releasedrain = 50
	chargetime = 3
	recharge_time = 30 SECONDS
	range = 6
	warnie = "spellwarning"
	movement_interrupt = FALSE
	no_early_release = FALSE
	chargedloop = null
	sound = 'sound/magic/whiteflame.ogg'
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	invocations = list("Converti in Nebulam!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	gesture_required = TRUE // Spell w/ offensive potential, but don't matter cuz you have no hands. Still, consistency
	cost = 2 // it's kinda shittier now
	xp_gain = TRUE
	miracle = FALSE

/obj/effect/proc_holder/spell/invoked/aerosolize/proc/get_container(mob/living/user, target)
	var/obj/item/reagent_containers/con = target
	if(!istype(con))
		to_chat(user, span_warning("This must be cast on a container."))
		return null
	if(!con.spillable)
		to_chat(user, span_warning("[con] is not an open container."))
		return null
	if(con.reagents.total_volume <= 0)
		to_chat(user, span_warning("[con] is empty."))
		return null
	return con

/obj/effect/proc_holder/spell/invoked/aerosolize/cast(list/targets, mob/living/user)
	var/turf/T = get_turf(targets[1])
	var/obj/item/reagent_containers/con = get_container(user, targets[1])
	if(!T || !con)
		revert_cast()
		return
	var/datum/effect_system/smoke_spread/chem/smoke = new
	smoke.set_up(con.reagents, 1, T, FALSE)
	smoke.start()
	con.reagents.clear_reagents()
	playsound(user, 'sound/magic/webspin.ogg', 100)

/obj/effect/proc_holder/spell/invoked/aerosolize/wave
	name = "Aerosol Wave"
	desc = "Turns the reagents of a container into a wave of odious smoke traveling in the direction the caster is facing."
	overlay_state = "aerosol_wave"
	chargetime = 6
	spell_tier = 3 // technically an AOE (?)
	cost = 3 // this ones a bit better
	invocations = list("Nebulam Abiecit!")

/obj/effect/proc_holder/spell/invoked/aerosolize/wave/cast(list/targets, mob/living/user)
	var/obj/item/reagent_containers/con = get_container(user, targets[1])
	if(!con)
		revert_cast()
		return
	var/datum/reagents/R = con.reagents
	var/cloud_color = mix_color_from_reagents(R.reagent_list)
	var/turf/front = get_turf(targets[1])
	var/list/affected_turfs = list()

	affected_turfs += front
	if(user.dir == SOUTH || user.dir == NORTH)
		affected_turfs += get_step(front, WEST)
		affected_turfs += get_step(front, EAST)
	else
		affected_turfs += get_step(front, NORTH)
		affected_turfs += get_step(front, SOUTH)

	for(var/turf/affected_turf in affected_turfs)
		var/obj/effect/aerosol_cloud/C = new(affected_turf, user.dir, cloud_color)
		R.copy_to(C.payload, R.total_volume)
	con.reagents.clear_reagents()
	playsound(user, 'sound/magic/whiteflame.ogg', 100)

/obj/effect/aerosol_cloud
	name = "cloud of gas"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	anchored = TRUE
	density = FALSE
	alpha = 200
	var/datum/reagents/payload
	var/travel_dir = SOUTH
	var/start_delay = 0

/obj/effect/aerosol_cloud/Initialize(mapload, newdir, cloud_color)
	. = ..()
	travel_dir = newdir
	dir = newdir
	color = cloud_color
	payload = new /datum/reagents(1000)
	INVOKE_ASYNC(src, PROC_REF(travel))

/obj/effect/aerosol_cloud/Destroy()
	QDEL_NULL(payload)
	return ..()

/obj/effect/aerosol_cloud/proc/travel()
	sleep(6) // it won't turn Green unless this is here
	for(var/i in 1 to 4)
		if(QDELETED(src))
			return
		var/datum/effect_system/smoke_spread/chem/smoke = new
		smoke.set_up(payload, 0, get_turf(src), TRUE)
		smoke.start()
		var/turf/next = get_step(src, travel_dir)
		if(!next || next.density)
			break
		sleep(6)
		forceMove(next)
	if(!QDELETED(src))
		var/datum/effect_system/smoke_spread/chem/smoke = new
		smoke.set_up(payload, 0, get_turf(src), TRUE)
		smoke.start()
		qdel(src)
