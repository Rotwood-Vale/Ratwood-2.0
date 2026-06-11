/obj/effect/proc_holder/spell/invoked/forcewall/greater
	name = "强力力场墙"
	desc = "召出一道 `5x1` 的奥术力场墙，除你之外，任何人或物都无法穿过它。"
	overlay_state = "forcewall"
	spell_tier = 3 // Full Mage only.
	invocations = list("更高之墙，起！") // Make a greater barrier
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_HIGH
	wall_type = /obj/structure/forcefield_weak
	cost = 4 // Forcewall is 3, this is 4 since it doesn't offer that much more

/obj/effect/proc_holder/spell/invoked/forcewall/greater/cast(list/targets,mob/user = usr)
	var/turf/front = get_turf(targets[1])
	var/list/affected_turfs = list()

	affected_turfs += front
	if(user.dir == SOUTH || user.dir == NORTH)
		affected_turfs += get_step(front, WEST)
		affected_turfs += get_step(get_step(front, WEST), WEST) // There Surely Must Be A Better Way To Do This??
		affected_turfs += get_step(front, EAST)
		affected_turfs += get_step(get_step(front, EAST), EAST)
	else
		affected_turfs += get_step(front, NORTH)
		affected_turfs += get_step(get_step(front, NORTH), NORTH)
		affected_turfs += get_step(front, SOUTH)
		affected_turfs += get_step(get_step(front, SOUTH), SOUTH)

	for(var/turf/affected_turf in affected_turfs)
		new /obj/effect/temp_visual/trap_wall(affected_turf)
		addtimer(CALLBACK(src, PROC_REF(new_wall), affected_turf, user), wait = 1 SECONDS)

	user.visible_message("[user] 低声念诵咒文，一道更宽阔的奥术力场墙凭空显现！")
	return TRUE
