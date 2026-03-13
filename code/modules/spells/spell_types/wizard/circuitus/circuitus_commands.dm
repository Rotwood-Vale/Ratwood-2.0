/datum/spell_command
	var/word = ""
	var/fatiguecost = 20
	var/obj/effect/proc_holder/spell/needs_spell = null

/datum/spell_command/proc/activate(datum/incantation_data/data)
	var/tired_left = data.caster.max_stamina - data.caster.stamina
	if(tired_left < fatiguecost)
		to_chat(data.caster, span_warning("Too tired!"))
		return FALSE
	return do_spell(data)

/datum/spell_command/proc/do_spell(datum/incantation_data/data)
	return FALSE

/datum/spell_command/flames
	word = "ignis"
	fatiguecost = 25
	needs_spell = /obj/effect/proc_holder/spell/invoked/projectile/fireball

/datum/spell_command/flames/do_spell(datum/incantation_data/data)
	var/list/spots = list()

	if(!data.current_iota)
		return FALSE

	if(data.current_iota.value_type == "coords")
		var/datum/spell_value/position/pos = data.current_iota
		var/turf/T = locate(pos.x_pos, pos.y_pos, pos.z_pos)
		if(T) spots = list(T)
	else
		return FALSE

	if(!length(spots))
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)
	for(var/turf/T in spots)
		if(get_dist(caster_spot, T) > 14)
			to_chat(data.caster, span_warning("Too far away!"))
			return FALSE
		if(!data.can_see_through(caster_spot, T))
			to_chat(data.caster, span_warning("Cannot see through walls!"))
			return FALSE

	var/strength = data.get_staff_power()

	data.caster.stamina_add(fatiguecost)

	for(var/turf/T in spots)
		new /obj/effect/temp_visual/spell_visual/fire_warning(T)

	addtimer(CALLBACK(src, PROC_REF(do_fire_damage), spots, strength), 1.5 SECONDS)
	return TRUE

/datum/spell_command/flames/proc/do_fire_damage(list/turfs, strength)
	var/flame_strength = min(strength, 2)
	for(var/turf/T in turfs)
		explosion(T, -1, 0, strength, strength + 1, 0, flame_range = flame_strength)

		for(var/mob/living/L in T.contents)
			if(L.anti_magic_check())
				continue
			L.adjust_fire_stacks(1 + strength)
			if(L.fire_stacks > 0)
				L.fire_act(1, 5)
			L.adjustFireLoss(15 + (strength * 10))

/datum/spell_command/lightning
	word = "fulmen"
	fatiguecost = 20
	needs_spell = /obj/effect/proc_holder/spell/invoked/thunderstrike

/datum/spell_command/lightning/do_spell(datum/incantation_data/data)
	var/list/spots = list()

	if(!data.current_iota)
		return FALSE

	if(data.current_iota.value_type == "coords")
		var/datum/spell_value/position/pos = data.current_iota
		var/turf/T = locate(pos.x_pos, pos.y_pos, pos.z_pos)
		if(T) spots = list(T)
	else
		return FALSE

	if(!length(spots))
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)
	for(var/turf/T in spots)
		if(get_dist(caster_spot, T) > 14)
			to_chat(data.caster, span_warning("Too far away!"))
			return FALSE
		if(!data.can_see_through(caster_spot, T))
			to_chat(data.caster, span_warning("Cannot see through walls!"))
			return FALSE

	var/strength = data.get_staff_power()

	data.caster.stamina_add(fatiguecost)

	for(var/turf/T in spots)
		new /obj/effect/temp_visual/spell_visual/lightning_warning(T)

	addtimer(CALLBACK(src, PROC_REF(do_zap_damage), spots, strength), 1 SECONDS)
	return TRUE

/datum/spell_command/lightning/proc/do_zap_damage(list/turfs, strength)
	for(var/turf/T in turfs)
		new /obj/effect/temp_visual/spell_visual/lightning_strike(T)
		playsound(T, 'sound/magic/lightning.ogg', 100)

		for(var/mob/living/L in T.contents)
			if(L.anti_magic_check())
				continue
			L.electrocute_act(30 + (strength * 20), L, 1, SHOCK_NOSTUN)

/datum/spell_command/teleport
	word = "teleporto"
	fatiguecost = 20
	needs_spell = /obj/effect/proc_holder/spell/invoked/blink

/datum/spell_command/teleport/do_spell(datum/incantation_data/data)
	var/datum/spell_value/position/end_pos = data.current_iota
	var/datum/spell_value/position/start_pos = data.pop_iota()

	if(!start_pos || start_pos.value_type != "coords" || !end_pos || end_pos.value_type != "coords")
		to_chat(data.caster, span_warning("Need two coordinates!"))
		return FALSE

	var/turf/start_spot = locate(start_pos.x_pos, start_pos.y_pos, start_pos.z_pos)
	var/turf/end_spot = locate(end_pos.x_pos, end_pos.y_pos, end_pos.z_pos)

	if(!start_spot || !end_spot)
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)
	if(get_dist(caster_spot, start_spot) > 14 || get_dist(caster_spot, end_spot) > 14)
		to_chat(data.caster, span_warning("Too far away!"))
		return FALSE

	if(get_dist(start_spot, end_spot) > 14)
		to_chat(data.caster, span_warning("Teleport distance too far!"))
		return FALSE

	if(!data.can_see_through(caster_spot, start_spot) || !data.can_see_through(caster_spot, end_spot))
		to_chat(data.caster, span_warning("Cannot see through walls!"))
		return FALSE

	for(var/obj/structure/roguewindow/W in end_spot.contents)
		to_chat(data.caster, span_warning("Cannot teleport into a window!"))
		return FALSE
	for(var/obj/structure/bars/B in end_spot.contents)
		to_chat(data.caster, span_warning("Cannot teleport into bars!"))
		return FALSE
	for(var/obj/structure/gate/G in end_spot.contents)
		to_chat(data.caster, span_warning("Cannot teleport into a gate!"))
		return FALSE

	data.caster.stamina_add(fatiguecost)

	new /obj/effect/temp_visual/spell_visual/blink_warning(start_spot)
	new /obj/effect/temp_visual/spell_visual/blink_warning(end_spot)

	addtimer(CALLBACK(src, PROC_REF(perform_teleport), start_spot, end_spot, data.caster.dir), 1 SECONDS)
	return TRUE

/datum/spell_command/teleport/proc/perform_teleport(turf/start_spot, turf/end_spot, caster_dir)
	var/obj/spot_one = new /obj/effect/temp_visual/blink_phase(start_spot, caster_dir)
	var/obj/spot_two = new /obj/effect/temp_visual/blink_phase(end_spot, caster_dir)

	spot_one.Beam(spot_two, "purple_lightning", time = 1.5 SECONDS)
	playsound(start_spot, 'sound/magic/blink.ogg', 100)
	playsound(end_spot, 'sound/magic/blink.ogg', 100)

	for(var/mob/M in start_spot.contents)
		if(M.buckled)
			M.buckled.unbuckle_mob(M, TRUE)
		do_teleport(M, end_spot, channel = TELEPORT_CHANNEL_MAGIC)

	for(var/obj/item/I in start_spot.contents)
		I.forceMove(end_spot)

/datum/spell_command/crush
	word = "pondus"
	fatiguecost = 20
	needs_spell = /obj/effect/proc_holder/spell/invoked/gravity

/datum/spell_command/crush/do_spell(datum/incantation_data/data)
	var/list/spots = list()

	if(!data.current_iota)
		return FALSE

	if(data.current_iota.value_type == "coords")
		var/datum/spell_value/position/pos = data.current_iota
		var/turf/T = locate(pos.x_pos, pos.y_pos, pos.z_pos)
		if(T) spots = list(T)
	else
		return FALSE

	if(!length(spots))
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)
	for(var/turf/T in spots)
		if(get_dist(caster_spot, T) > 14)
			to_chat(data.caster, span_warning("Too far away!"))
			return FALSE
		if(!data.can_see_through(caster_spot, T))
			to_chat(data.caster, span_warning("Cannot see through walls!"))
			return FALSE

	var/strength = data.get_staff_power()

	data.caster.stamina_add(fatiguecost)

	for(var/turf/T in spots)
		new /obj/effect/temp_visual/spell_visual/gravity_warning(T)

	addtimer(CALLBACK(src, PROC_REF(do_gravity_damage), spots, strength), 1 SECONDS)
	return TRUE

/datum/spell_command/crush/proc/do_gravity_damage(list/turfs, strength)
	for(var/turf/T in turfs)
		new /obj/effect/temp_visual/spell_visual/gravity_crush(T)
		playsound(T, 'sound/magic/gravity.ogg', 100)

		for(var/mob/living/L in T.contents)
			if(L.anti_magic_check())
				continue
			if(L.STASTR <= 15)
				L.adjustBruteLoss(30 + (strength * 15))
				L.Knockdown(2 + strength)
			else
				L.adjustBruteLoss(10 + (strength * 5))
				L.OffBalance(5 + (strength * 2))

/datum/spell_command/fix_item
	word = "reficio"
	fatiguecost = 10
	needs_spell = /obj/effect/proc_holder/spell/invoked/mending

/datum/spell_command/fix_item/do_spell(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.value_type != "item")
		return FALSE

	var/datum/spell_value/item_thing/item_val = data.current_iota
	var/obj/item/target_item = item_val.the_item

	if(!target_item)
		return FALSE

	var/turf/item_spot = get_turf(target_item)
	var/turf/caster_spot = get_turf(data.caster)

	if(get_dist(caster_spot, item_spot) > 14)
		to_chat(data.caster, span_warning("Too far away!"))
		return FALSE

	if(!data.can_see_through(caster_spot, item_spot))
		to_chat(data.caster, span_warning("Cannot see through walls!"))
		return FALSE

	if(!target_item.anvilrepair && !target_item.sewrepair)
		return FALSE

	if(target_item.obj_integrity >= target_item.max_integrity)
		return FALSE

	var/strength = max(1, data.get_staff_power())

	data.caster.stamina_add(fatiguecost)

	var/heal_amount = target_item.max_integrity * (0.2 * strength)
	target_item.obj_integrity = min(target_item.obj_integrity + heal_amount, target_item.max_integrity)

	if(target_item.obj_integrity >= target_item.max_integrity && target_item.obj_broken)
		target_item.obj_fix()

	playsound(target_item, 'sound/foley/sewflesh.ogg', 50)
	return TRUE

/datum/spell_command/store_iota
	word = "scribo"
	fatiguecost = 5
	needs_spell = null

/datum/spell_command/store_iota/do_spell(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.value_type != "item")
		return FALSE

	var/datum/spell_value/item_thing/item_iota = data.current_iota
	if(!istype(item_iota.the_item, /obj/item/memory_string))
		return FALSE

	var/obj/item/memory_string/memory = item_iota.the_item
	var/datum/spell_value/value_to_store = data.pop_iota()
	if(!value_to_store)
		return FALSE

	var/turf/item_spot = get_turf(memory)
	var/turf/caster_spot = get_turf(data.caster)

	if(get_dist(caster_spot, item_spot) > 14)
		to_chat(data.caster, span_warning("Too far away!"))
		return FALSE

	if(!data.can_see_through(caster_spot, item_spot))
		to_chat(data.caster, span_warning("Cannot see through walls!"))
		return FALSE

	data.caster.stamina_add(fatiguecost)

	memory.iota = value_to_store
	data.current_iota = item_iota
	return TRUE

/datum/spell_command/push_away
	word = "obmolior"
	fatiguecost = 10
	needs_spell = /obj/effect/proc_holder/spell/invoked/repulse

/datum/spell_command/push_away/do_spell(datum/incantation_data/data)
	var/list/spots = list()

	if(!data.current_iota)
		return FALSE

	if(data.current_iota.value_type == "coords")
		var/datum/spell_value/position/pos = data.current_iota
		var/turf/T = locate(pos.x_pos, pos.y_pos, pos.z_pos)
		if(T) spots = list(T)
	else
		return FALSE

	if(!length(spots))
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)

	for(var/turf/T in spots)
		if(get_dist(caster_spot, T) > 14)
			to_chat(data.caster, span_warning("Too far away!"))
			return FALSE
		if(!data.can_see_through(caster_spot, T))
			to_chat(data.caster, span_warning("Cannot see through walls!"))
			return FALSE

	var/push_range = 1
	var/datum/spell_value/number/distance_iota = data.peek_stack(0)
	if(distance_iota && distance_iota.value_type == "number")
		push_range = min(max(distance_iota.num, 1), 5)
		data.pop_iota()

	data.caster.stamina_add(fatiguecost)

	for(var/turf/T in spots)
		new /obj/effect/temp_visual/spell_visual/push_warning(T)

	addtimer(CALLBACK(src, PROC_REF(do_push), spots, push_range, data.caster), 1 SECONDS)
	return TRUE

/datum/spell_command/push_away/proc/do_push(list/spots, push_range, mob/living/caster)
	playsound(caster, 'sound/magic/repulse.ogg', 80)
	for(var/turf/T in spots)
		var/atom/throw_spot = get_edge_target_turf(caster, get_dir(caster, get_step_away(T, caster)))
		for(var/mob/living/M in T.contents)
			M.set_resting(TRUE, TRUE)
			M.safe_throw_at(throw_spot, push_range, 1, caster, force = MOVE_FORCE_EXTREMELY_STRONG)
		for(var/obj/item/I in T.contents)
			I.safe_throw_at(throw_spot, push_range, 1, caster, force = MOVE_FORCE_EXTREMELY_STRONG)

/datum/spell_command/pull_close
	word = "recolligere"
	fatiguecost = 10
	needs_spell = /obj/effect/proc_holder/spell/invoked/projectile/fetch

/datum/spell_command/pull_close/do_spell(datum/incantation_data/data)
	var/list/spots = list()

	if(!data.current_iota)
		return FALSE

	if(data.current_iota.value_type == "coords")
		var/datum/spell_value/position/pos = data.current_iota
		var/turf/T = locate(pos.x_pos, pos.y_pos, pos.z_pos)
		if(T) spots = list(T)
	else
		return FALSE

	if(!length(spots))
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)

	for(var/turf/T in spots)
		if(get_dist(caster_spot, T) > 14)
			to_chat(data.caster, span_warning("Too far away!"))
			return FALSE
		if(!data.can_see_through(caster_spot, T))
			to_chat(data.caster, span_warning("Cannot see through walls!"))
			return FALSE

	var/push_range = 1
	var/datum/spell_value/number/distance_iota = data.peek_stack(0)
	if(distance_iota && distance_iota.value_type == "number")
		push_range = min(max(distance_iota.num, 1), 5)
		data.pop_iota()

	data.caster.stamina_add(fatiguecost)

	for(var/turf/T in spots)
		new /obj/effect/temp_visual/spell_visual/pull_warning(T)

	addtimer(CALLBACK(src, PROC_REF(do_pull), spots, push_range, data.caster), 1 SECONDS)
	return TRUE

/datum/spell_command/pull_close/proc/do_pull(list/spots, push_range, mob/living/caster)
	playsound(caster, 'sound/magic/repulse.ogg', 80)
	for(var/turf/T in spots)
		var/atom/throw_spot = get_step_towards(caster, T)
		for(var/mob/living/M in T.contents)
			M.set_resting(TRUE, TRUE)
			M.safe_throw_at(throw_spot, push_range, 1, caster, force = MOVE_FORCE_EXTREMELY_STRONG)
		for(var/obj/item/I in T.contents)
			I.safe_throw_at(throw_spot, push_range, 1, caster, force = MOVE_FORCE_EXTREMELY_STRONG)

/datum/spell_command/make_wall
	word = "murus"
	fatiguecost = 10
	needs_spell = /obj/effect/proc_holder/spell/invoked/forcewall

/datum/spell_command/make_wall/do_spell(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.value_type != "coords")
		return FALSE

	var/datum/spell_value/position/pos = data.current_iota
	var/turf/wall_spot = locate(pos.x_pos, pos.y_pos, pos.z_pos)

	if(!wall_spot)
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)
	if(get_dist(caster_spot, wall_spot) > 14)
		to_chat(data.caster, span_warning("Too far away!"))
		return FALSE

	if(!data.can_see_through(caster_spot, wall_spot))
		to_chat(data.caster, span_warning("Cannot see through walls!"))
		return FALSE

	data.caster.stamina_add(fatiguecost)

	var/list/wall_turfs = list(wall_spot)
/*
	if(data.caster.dir == SOUTH || data.caster.dir == NORTH)
		wall_turfs += get_step(wall_spot, WEST)
		wall_turfs += get_step(wall_spot, EAST)
	else
		wall_turfs += get_step(wall_spot, NORTH)
		wall_turfs += get_step(wall_spot, SOUTH)
*/

	for(var/turf/T in wall_turfs)
		new /obj/effect/temp_visual/spell_visual/wall_warning(T)
		addtimer(CALLBACK(src, PROC_REF(make_wall_piece), T, data.caster), 1 SECONDS)

	return TRUE

/datum/spell_command/make_wall/proc/make_wall_piece(turf/T, mob/caster)
	new /obj/structure/forcefield_weak(T, caster)

/datum/spell_command/buff_strength
	word = "vis"
	fatiguecost = 20
	needs_spell = /obj/effect/proc_holder/spell/invoked/giants_strength

/datum/spell_command/buff_strength/do_spell(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.value_type != "mob")
		return FALSE

	var/datum/spell_value/mob/mob_iota = data.current_iota
	var/mob/living/target = mob_iota.the_mob

	if(!target)
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)
	var/turf/target_spot = get_turf(target)
	if(get_dist(caster_spot, target_spot) > 14)
		to_chat(data.caster, span_warning("Too far away!"))
		return FALSE

	var/bonus = max(1, (data.get_staff_power() + 1))

	data.caster.stamina_add(fatiguecost)

	playsound(target_spot, 'sound/magic/haste.ogg', 80, TRUE)
	target.apply_status_effect(/datum/status_effect/buff/circuitus_strength, bonus)
	return TRUE

/datum/spell_command/buff_constitution
	word = "saxum"
	fatiguecost = 20
	needs_spell = /obj/effect/proc_holder/spell/invoked/stoneskin

/datum/spell_command/buff_constitution/do_spell(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.value_type != "mob")
		return FALSE

	var/datum/spell_value/mob/mob_iota = data.current_iota
	var/mob/living/target = mob_iota.the_mob

	if(!target)
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)
	var/turf/target_spot = get_turf(target)
	if(get_dist(caster_spot, target_spot) > 14)
		to_chat(data.caster, span_warning("Too far away!"))
		return FALSE

	var/bonus = max(1, (data.get_staff_power() + 1))

	data.caster.stamina_add(fatiguecost)

	playsound(target_spot, 'sound/magic/haste.ogg', 80, TRUE)
	target.apply_status_effect(/datum/status_effect/buff/circuitus_constitution, bonus)
	return TRUE

/datum/spell_command/buff_speed
	word = "festinatio"
	fatiguecost = 20
	needs_spell = /obj/effect/proc_holder/spell/invoked/haste

/datum/spell_command/buff_speed/do_spell(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.value_type != "mob")
		return FALSE

	var/datum/spell_value/mob/mob_iota = data.current_iota
	var/mob/living/target = mob_iota.the_mob

	if(!target)
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)
	var/turf/target_spot = get_turf(target)
	if(get_dist(caster_spot, target_spot) > 14)
		to_chat(data.caster, span_warning("Too far away!"))
		return FALSE

	var/bonus = max(1, (data.get_staff_power() + 1))

	data.caster.stamina_add(fatiguecost)

	playsound(target_spot, 'sound/magic/haste.ogg', 80, TRUE)
	target.apply_status_effect(/datum/status_effect/buff/circuitus_speed, bonus)
	return TRUE

/datum/spell_command/buff_perception
	word = "oculi"
	fatiguecost = 20
	needs_spell = /obj/effect/proc_holder/spell/invoked/hawks_eyes

/datum/spell_command/buff_perception/do_spell(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.value_type != "mob")
		return FALSE

	var/datum/spell_value/mob/mob_iota = data.current_iota
	var/mob/living/target = mob_iota.the_mob

	if(!target)
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)
	var/turf/target_spot = get_turf(target)
	if(get_dist(caster_spot, target_spot) > 14)
		to_chat(data.caster, span_warning("Too far away!"))
		return FALSE

	var/bonus = max(1, (data.get_staff_power() + 1))

	data.caster.stamina_add(fatiguecost)

	playsound(target_spot, 'sound/magic/haste.ogg', 80, TRUE)
	target.apply_status_effect(/datum/status_effect/buff/circuitus_perception, bonus)
	return TRUE

/datum/spell_command/buff_endurance
	word = "tenax"
	fatiguecost = 20
	needs_spell = /obj/effect/proc_holder/spell/invoked/fortitude

/datum/spell_command/buff_endurance/do_spell(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.value_type != "mob")
		return FALSE

	var/datum/spell_value/mob/mob_iota = data.current_iota
	var/mob/living/target = mob_iota.the_mob

	if(!target)
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)
	var/turf/target_spot = get_turf(target)
	if(get_dist(caster_spot, target_spot) > 14)
		to_chat(data.caster, span_warning("Too far away!"))
		return FALSE

	var/bonus = max(1, (data.get_staff_power() + 1))

	data.caster.stamina_add(fatiguecost)

	playsound(target_spot, 'sound/magic/haste.ogg', 80, TRUE)
	target.apply_status_effect(/datum/status_effect/buff/circuitus_endurance, bonus)
	return TRUE

/obj/effect/temp_visual/spell_visual
	layer = MASSIVE_OBJ_LAYER

/obj/effect/temp_visual/spell_visual/fire_warning
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	light_outer_range = 2
	light_color = "#f8af07"
	duration = 1.5 SECONDS

/obj/effect/temp_visual/spell_visual/lightning_warning
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	light_outer_range = 2
	light_color = "#a8d3ff"
	duration = 1 SECONDS

/obj/effect/temp_visual/spell_visual/lightning_strike
	icon = 'icons/effects/32x96.dmi'
	icon_state = "lightning"
	light_outer_range = 3
	duration = 0.5 SECONDS

/obj/effect/temp_visual/spell_visual/gravity_warning
	icon = 'icons/effects/effects.dmi'
	icon_state = "hierophant_blast"
	light_outer_range = 2
	light_color = "#a090c0"
	duration = 1 SECONDS

/obj/effect/temp_visual/spell_visual/gravity_crush
	icon = 'icons/effects/effects.dmi'
	icon_state = "hierophant_squares"
	duration = 1 SECONDS

/obj/effect/temp_visual/spell_visual/wall_warning
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-flash"
	light_outer_range = 2
	duration = 1 SECONDS

/obj/effect/temp_visual/spell_visual/push_warning
	icon = 'icons/effects/effects.dmi'
	icon_state = "at_shield2"
	light_outer_range = 2
	light_color = "#ff6666"
	duration = 1 SECONDS

/obj/effect/temp_visual/spell_visual/pull_warning
	icon = 'icons/effects/effects.dmi'
	icon_state = "at_shield2"
	light_outer_range = 2
	light_color = "#6666ff"
	duration = 1 SECONDS

/obj/effect/temp_visual/spell_visual/blink_warning
	icon = 'icons/effects/effects.dmi'
	icon_state = "hierophant_blast"
	light_outer_range = 2
	light_color = COLOR_PALE_PURPLE_GRAY
	duration = 1 SECONDS

/obj/effect/temp_visual/blink_phase
	icon = 'icons/effects/effects.dmi'
	icon_state = "hierophant_blast"
	light_outer_range = 2
	light_color = COLOR_PALE_PURPLE_GRAY
	duration = 1.5 SECONDS
	layer = MASSIVE_OBJ_LAYER


/datum/status_effect/buff/circuitus_strength
	id = "circuitus_strength"
	alert_type = /atom/movable/screen/alert/status_effect/buff/circuitus_strength
	duration = 20 SECONDS

/datum/status_effect/buff/circuitus_strength/on_creation(mob/living/new_owner, bonus = 1)
	effectedstats = list(STATKEY_STR = bonus)
	return ..()

/atom/movable/screen/alert/status_effect/buff/circuitus_strength
	name = "Giant's Strength"
	desc = "My muscles are strengthened."
	icon_state = "buff"

/datum/status_effect/buff/circuitus_constitution
	id = "circuitus_constitution"
	alert_type = /atom/movable/screen/alert/status_effect/buff/circuitus_constitution
	duration = 20 SECONDS

/datum/status_effect/buff/circuitus_constitution/on_creation(mob/living/new_owner, bonus = 1)
	effectedstats = list(STATKEY_CON = bonus)
	return ..()

/atom/movable/screen/alert/status_effect/buff/circuitus_constitution
	name = "Stoneskin"
	desc = "My skin is hardened like stone."
	icon_state = "buff"

/datum/status_effect/buff/circuitus_speed
	id = "circuitus_speed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/circuitus_speed
	duration = 20 SECONDS

/datum/status_effect/buff/circuitus_speed/on_creation(mob/living/new_owner, bonus = 1)
	effectedstats = list(STATKEY_SPD = bonus)
	return ..()

/atom/movable/screen/alert/status_effect/buff/circuitus_speed
	name = "Haste"
	desc = "I am magically hastened."
	icon_state = "buff"

/datum/status_effect/buff/circuitus_perception
	id = "circuitus_perception"
	alert_type = /atom/movable/screen/alert/status_effect/buff/circuitus_perception
	duration = 20 SECONDS

/datum/status_effect/buff/circuitus_perception/on_creation(mob/living/new_owner, bonus = 1)
	effectedstats = list(STATKEY_PER = bonus)
	return ..()

/atom/movable/screen/alert/status_effect/buff/circuitus_perception
	name = "Hawk's Eyes"
	desc = "My vision is sharpened."
	icon_state = "buff"

/datum/status_effect/buff/circuitus_endurance
	id = "circuitus_endurance"
	alert_type = /atom/movable/screen/alert/status_effect/buff/circuitus_endurance
	duration = 20 SECONDS

/datum/status_effect/buff/circuitus_endurance/on_creation(mob/living/new_owner, bonus = 1)
	effectedstats = list(STATKEY_END = bonus)
	return ..()

/atom/movable/screen/alert/status_effect/buff/circuitus_endurance
	name = "Fortitude"
	desc = "My humors has been hardened to the fatigues of the body."
	icon_state = "buff"

/datum/spell_command/projectile
	var/projectile_type = /obj/projectile/energy/arcynebolt
	var/projectile_warning = /obj/effect/temp_visual/spell_visual/blink_warning

/datum/spell_command/projectile/do_spell(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.value_type != "coords")
		return FALSE

	var/datum/spell_value/position/target_pos = data.current_iota
	var/datum/spell_value/position/origin_pos = data.pop_iota()

	if(!origin_pos || origin_pos.value_type != "coords")
		return FALSE

	var/turf/origin = locate(origin_pos.x_pos, origin_pos.y_pos, origin_pos.z_pos)
	var/turf/target = locate(target_pos.x_pos, target_pos.y_pos, target_pos.z_pos)

	if(!origin || !target)
		return FALSE

	var/turf/caster_turf = get_turf(data.caster)
	if(get_dist(caster_turf, origin) > 14)
		to_chat(data.caster, span_warning("Too far away!"))
		return FALSE

	data.caster.stamina_add(fatiguecost)

	var/strength = data.get_staff_power()
	var/at_caster = (origin == caster_turf)
	if(!at_caster)
		new projectile_warning(origin)
		addtimer(CALLBACK(src, PROC_REF(fire_proj), origin, target, data.caster, strength), 1 SECONDS)
	else
		fire_proj(origin, target, data.caster, strength)
	return TRUE

/datum/spell_command/projectile/proc/fire_proj(turf/origin, turf/target, mob/living/caster, strength = 0)
	var/obj/projectile/P = new projectile_type(origin)
	P.firer = caster
	if(caster.mind)
		P.bonus_accuracy += (caster.get_skill_level(/datum/skill/magic/arcane) * 5)
	P.damage = round(P.damage * ((strength + 1) * 0.25))
	P.preparePixelProjectile(target, origin)
	P.fire()

/datum/spell_command/projectile/arcyne
	word = "sagitta"
	needs_spell = /obj/effect/proc_holder/spell/invoked/projectile/arcynebolt
	projectile_type = /obj/projectile/energy/arcynebolt
	projectile_warning = /obj/effect/temp_visual/spell_visual/blink_warning

/datum/spell_command/projectile/fire
	word = "flammas"
	needs_spell = /obj/effect/proc_holder/spell/invoked/projectile/spitfire
	projectile_type = /obj/projectile/magic/aoe/fireball/spitfire
	projectile_warning = /obj/effect/temp_visual/spell_visual/fire_warning

/datum/spell_command/projectile/acid
	word = "tabificus"
	needs_spell = /obj/effect/proc_holder/spell/invoked/projectile/acidsplash
	projectile_type = /obj/projectile/magic/acidsplash
	projectile_warning = /obj/effect/temp_visual/spell_visual/blink_warning

/datum/spell_command/snap_freeze
	word = "glacies"
	needs_spell = /obj/effect/proc_holder/spell/invoked/snap_freeze
	fatiguecost = 10

/datum/spell_command/snap_freeze/do_spell(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.value_type != "coords")
		return FALSE

	var/datum/spell_value/position/pos = data.current_iota
	var/turf/T = locate(pos.x_pos, pos.y_pos, pos.z_pos)
	if(!T)
		return FALSE

	var/turf/caster_turf = get_turf(data.caster)
	if(get_dist(caster_turf, T) > 14)
		to_chat(data.caster, span_warning("Too far away!"))
		return FALSE

	var/strength = data.get_staff_power()
	var/damage = 15 + (strength * 10)
	var/aoe = 1

	data.caster.stamina_add(fatiguecost)

	for(var/turf/affected in view(aoe, T))
		new /obj/effect/temp_visual/trapice(affected)
	playsound(T, 'sound/combat/wooshes/blunt/wooshhuge (2).ogg', 80, TRUE, soundping = TRUE)

	addtimer(CALLBACK(src, PROC_REF(do_freeze), T, caster_turf, damage, aoe), 10)
	return TRUE

/datum/spell_command/snap_freeze/proc/do_freeze(turf/T, turf/source_turf, damage, aoe)
	var/play_cleave = FALSE
	for(var/turf/affected in view(aoe, T))
		new /obj/effect/temp_visual/snap_freeze(affected)
		if(!(affected in view(source_turf)))
			continue
		for(var/mob/living/L in affected.contents)
			if(L.anti_magic_check())
				playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
				continue
			play_cleave = TRUE
			if(ishuman(L))
				L.adjustFireLoss(damage)
			else
				L.adjustFireLoss(damage + 15)
			if(L.has_status_effect(/datum/status_effect/buff/frostbite))
				continue
			if(L.has_status_effect(/datum/status_effect/buff/frost))
				playsound(T, 'sound/combat/fracture/fracturedry (1).ogg', 80, TRUE, soundping = TRUE)
				L.remove_status_effect(/datum/status_effect/buff/frost)
				L.apply_status_effect(/datum/status_effect/buff/frostbite)
			else
				L.apply_status_effect(/datum/status_effect/buff/frost)
			playsound(affected, "genslash", 80, TRUE)
			to_chat(L, "<span class='userdanger'>The air chills your bones!</span>")
	if(play_cleave)
		playsound(T, 'sound/combat/newstuck.ogg', 80, TRUE, soundping = TRUE)

/datum/spell_command/projectile/frost
	word = "glaciei"
	needs_spell = /obj/effect/proc_holder/spell/invoked/projectile/frostbolt
	projectile_type = /obj/projectile/magic/frostbolt
	projectile_warning = /obj/effect/temp_visual/spell_visual/blink_warning
