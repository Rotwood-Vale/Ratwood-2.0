// Arcyne Prison, with warning
/obj/effect/proc_holder/spell/invoked/forcewall/arcyne_prison
	name = "奥术囚笼"
	desc = "在短暂延迟后，于 `5x5` 区域外围召出一圈脆弱的奥术力墙，将其中之人困住。你自己可以穿过它。"
	school = "transmutation"
	releasedrain = 50
	spell_tier = 4 // Trolling spell, CM only.
	invocations = list("囚笼，立起！") // Magical Prison of Mysterious Magic.
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_HIGH
	wall_type = /obj/structure/forcefield_weak/arcyne_prison
	cost = 6

/obj/effect/proc_holder/spell/invoked/forcewall/arcyne_prison/cast(list/targets,mob/user = usr)
	var/turf/target = get_turf(targets[1])

	for(var/turf/affected_turf in view(2, target))
		if(!(affected_turf in view(target)))
			continue
		if(get_dist(target, affected_turf) != 2)
			continue
		new /obj/effect/temp_visual/trap_wall(affected_turf)
		addtimer(CALLBACK(src, PROC_REF(new_wall), affected_turf, user), wait = 1 SECONDS)

	user.visible_message("[user] 低声念出咒文，一座奥术囚笼凭空显现！")
	return TRUE

/obj/structure/forcefield_weak/arcyne_prison
	desc = "一道由纯粹奥术之力构成的墙，看起来并不难打破。"
	name = "奥术囚笼"
	max_integrity = 50 // Ultra 
