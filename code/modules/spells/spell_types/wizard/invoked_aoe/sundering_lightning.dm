/obj/effect/proc_holder/spell/invoked/sundering_lightning
	name = "裂空雷击"
	desc = "召下危险而迅疾的连环雷击。"
	overlay_state = "lightning_sunder"
	cost = 9
	spell_tier = 4 // Highest tier AOE
	releasedrain = 50
	chargedrain = 1
	chargetime = 50
	recharge_time = 30 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = TRUE
	charging_slowdown = 2
	glow_color = GLOW_COLOR_LIGHTNING
	glow_intensity = GLOW_INTENSITY_HIGH
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	range = 4

/obj/effect/proc_holder/spell/invoked/sundering_lightning/cast(list/targets, mob/user = usr)
	var/turf/T = get_turf(targets[1])
//	var/list/affected_turfs = list()
	playsound(T,'sound/weather/rain/thunder_1.ogg', 80, TRUE)
	T.visible_message(span_boldwarning("空气中满是噼啪作响的电荷！"))
	sleep(30)
	create_lightning(T)

//meteor storm and lightstorm.
/obj/effect/proc_holder/spell/invoked/sundering_lightning/proc/create_lightning(atom/target)
	if(!target)
		return
	var/turf/targetturf = get_turf(target)
	var/last_dist = 0
	for(var/t in spiral_range_turfs(range, targetturf))
		var/turf/T = t
		if(!T)
			continue
		var/dist = get_dist(targetturf, T)
		if(dist > last_dist)
			last_dist = dist
			sleep(2 + min(range - last_dist, 12) * 0.5) //gets faster
		new /obj/effect/temp_visual/targetlightning(T)


/obj/effect/temp_visual/lightning
	icon = 'icons/effects/32x96.dmi'
	icon_state = "lightning"
	name = "雷击"
	desc = "噼啪作响！！"
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	randomdir = FALSE
	duration = 7

/obj/effect/temp_visual/lightning/Initialize(mapload)
	. = ..()

/obj/effect/temp_visual/targetlightning
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	layer = BELOW_MOB_LAYER
	plane = GAME_PLANE
	light_outer_range = 2
	duration =15
	var/explode_sound = list('sound/misc/explode/incendiary (1).ogg','sound/misc/explode/incendiary (2).ogg')

/obj/effect/temp_visual/targetlightning/Initialize(mapload, list/flame_hit)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(storm), flame_hit)

/obj/effect/temp_visual/targetlightning/proc/storm(list/flame_hit)	//electroshocktherapy
	var/turf/T = get_turf(src)
	sleep(duration)
	playsound(T,'sound/magic/lightning.ogg', 80, TRUE)
	new /obj/effect/temp_visual/lightning(T)

	for(var/mob/living/L in T.contents)
		if(L.anti_magic_check())
			continue
		L.electrocute_act(65)	//a little over half the damage of thunderstrike, but doesn't degrade on each subsequent ring.
		to_chat(L, span_userdanger("我被雷霆击中了！！！"))
