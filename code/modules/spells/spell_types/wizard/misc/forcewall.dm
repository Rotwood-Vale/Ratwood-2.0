//forcewall
/obj/effect/proc_holder/spell/invoked/forcewall
	name = "力场墙"
	desc = "召出一道 `3x1` 的奥术力场墙，除你之外，任何人或物都无法穿过它。"
	school = "transmutation"
	releasedrain = 30
	chargedrain = 1
	chargetime = 10
	recharge_time = 30 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	clothes_req = FALSE
	active = FALSE
	sound = 'sound/blank.ogg'
	overlay_state = "forcewall"
	spell_tier = 2
	invocations = list("墙起！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	var/wall_type = /obj/structure/forcefield_weak
	cost = 3

//adapted from forcefields.dm, this needs to be destructible
/obj/structure/forcefield_weak
	desc = "一堵由纯粹奥术力场构成的墙。"
	name = "奥术墙"
	icon = 'icons/effects/effects.dmi'
	icon_state = "arcynewall"
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	opacity = 0
	density = TRUE
	max_integrity = 150
	CanAtmosPass = ATMOS_PASS_DENSITY
	var/timeleft = 20 SECONDS

/obj/structure/forcefield_weak/Initialize(mapload)
	. = ..()
	if(timeleft)
		QDEL_IN(src, timeleft) //delete after it runs out

/obj/effect/proc_holder/spell/invoked/forcewall/cast(list/targets,mob/user = usr)
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
		new /obj/effect/temp_visual/trap_wall(affected_turf)
		addtimer(CALLBACK(src, PROC_REF(new_wall), affected_turf, user), wait = 1 SECONDS)

	user.visible_message("[user] 低声念诵咒文，一道奥术力场墙凭空显现！")
	return TRUE

/obj/effect/proc_holder/spell/invoked/forcewall/proc/new_wall(turf/target, mob/user)
	new wall_type(target, user)

/obj/structure/forcefield_weak
	var/mob/caster

/obj/structure/forcefield_weak/Initialize(mapload, mob/summoner)
	. = ..()
	caster = summoner

/obj/structure/forcefield_weak/CanPass(atom/movable/mover, turf/target)	//only the caster can move through this freely
	if(mover == caster)
		return TRUE
	if(ismob(mover))
		var/mob/M = mover
		if(M.anti_magic_check(chargecost = 0))
			return TRUE
	return FALSE

/obj/effect/temp_visual/trap_wall
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	light_outer_range = 2
	duration = 1 SECONDS
	layer = MASSIVE_OBJ_LAYER
