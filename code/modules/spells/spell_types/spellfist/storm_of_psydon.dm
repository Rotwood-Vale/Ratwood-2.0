/obj/effect/proc_holder/spell/invoked/spellfist/storm_of_psydon
	name = "Storm of Psydon"
	desc = "Channel mana into your legs to leap toward a target from a distance, closing the gap rapidly. \
		Then, channel the mana into your fists to unleash a storm of blows. \
		Requires 7 Momentum: 3 punches + 1 kick (20 damage each). \
		Overcharged at 10 Momentum: 9 punches + 1 kick (20 damage each). \
		Cannot be parried or dodged - only Defend stance can interrupt. \
		Consumes all momentum only on a successful hit. If you miss, your momentum is kept and half cooldown is applied.\n\n\
		'Temper the storm within, and unleash it only upon those who stray from His ways.'"
	overlay_state = "storm_of_psydon"
	overlay_icon = 'icons/mob/actions/classuniquespells/spellfist.dmi'
	action_icon = 'icons/mob/actions/classuniquespells/spellfist.dmi'
	action_icon_state = "storm_of_psydon"
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_HIGH
	releasedrain = 40
	chargedrain = 1
	chargetime = 10
	charging_slowdown = 0
	recharge_time = 60 SECONDS
	range = 7
	spell_tier = 3
	invocations = list("INTAQAM PSYDON!", "EN TARO PSYDON!")
	sound = 'sound/magic/charged.ogg'
	
	var/min_momentum_cost = 7
	var/overcharge_cost = 10
	var/punch_damage = 20
	var/kick_damage = 20
	var/punch_sets_full = 3
	var/punches_per_set = 3
	var/punch_count_lame = 3
	var/step_delay = 1

/obj/effect/proc_holder/spell/invoked/spellfist/storm_of_psydon/can_cast(mob/user = usr)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum_cost)
		to_chat(H, span_warning("Not enough momentum! I need at least [min_momentum_cost] stacks!"))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/invoked/spellfist/storm_of_psydon/cast(list/targets, mob/living/carbon/human/user)
	if(prob(0.05))
		invocations = list("EN TARO PSYDON!") // FOR THOSE WHO KNOW
	else
		invocations = list("INTAQAM PSYDON!")

	. = ..()
	
	var/atom/cast_on = targets[1]
	if(!istype(user))
		return FALSE

	var/datum/status_effect/buff/arcyne_momentum/M = user.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum_cost)
		revert_cast()
		return FALSE

	var/stacks = M.stacks
	var/is_full = stacks >= overcharge_cost

	var/mob/living/preferred_target
	if(isliving(cast_on))
		preferred_target = cast_on
	else
		var/turf/clicked_turf = get_turf(cast_on)
		if(clicked_turf)
			for(var/mob/living/L in clicked_turf)
				if(L != user && L.stat != DEAD)
					preferred_target = L
					break

	if(!preferred_target)
		to_chat(user, span_warning("I need a target to focus my storm on!"))
		revert_cast()
		return FALSE

	var/turf/start = get_turf(user)
	var/facing = get_dir(start, get_turf(preferred_target)) || user.dir
	user.dir = facing

	if(get_dist(user, preferred_target) <= 1)
		if(preferred_target.anti_magic_check())
			preferred_target.visible_message(span_warning("The storm dissipates on contact with [preferred_target]!"))
			revert_cast()
			return TRUE
		user.visible_message(span_danger("<b>[user] latches onto [preferred_target], unleashing a flurry of blows!</b>"))
		release_momentum(user, M, stacks)
		if(is_full)
			oraora(user, preferred_target)
		else
			oraora_lame(user, preferred_target)
		return TRUE

	user.visible_message(span_danger("<b>[user] launches toward [preferred_target] with storming intent!</b>"))

	var/old_pass = user.pass_flags
	var/old_throwing = user.throwing
	user.pass_flags |= PASSMOB
	user.throwing = TRUE
	var/prev_pixel_z = user.pixel_z
	var/prev_transform = user.transform

	animate(user, pixel_z = prev_pixel_z + 18, time = 1, easing = EASE_OUT)

	var/mob/living/hit_target
	for(var/i in 1 to range)
		if(user.stat != CONSCIOUS || user.IsParalyzed() || user.IsStun() || QDELETED(user))
			break

		if(get_dist(user, preferred_target) <= 1)
			hit_target = preferred_target
			break

		facing = get_dir(get_turf(user), get_turf(preferred_target))
		if(!facing)
			break
		user.dir = facing

		var/turf/next = get_step(get_turf(user), facing)
		if(!next || next.density)
			break

		var/blocked = FALSE
		for(var/obj/structure/S in next.contents)
			if(S.density && !S.climbable)
				blocked = TRUE
				break
		if(blocked)
			break

		step(user, facing)

		if(i < range)
			sleep(step_delay)

	var/land_angle = pick(-20, -15, 15, 20)
	animate(user, pixel_z = prev_pixel_z, transform = turn(prev_transform, land_angle), time = 1, easing = EASE_IN)
	animate(transform = prev_transform, time = 2)

	user.pass_flags = old_pass
	user.throwing = old_throwing

	if(!hit_target && get_dist(user, preferred_target) <= 1)
		hit_target = preferred_target

	if(!hit_target)
		to_chat(user, span_warning("My storm finds no purchase!"))
		revert_cast()
		return TRUE

	if(hit_target.anti_magic_check())
		hit_target.visible_message(span_warning("The storm dissipates on contact with [hit_target]!"))
		revert_cast()
		return TRUE

	release_momentum(user, M, stacks)
	if(is_full)
		oraora(user, hit_target)
	else
		oraora_lame(user, hit_target)
	return TRUE

/obj/effect/proc_holder/spell/invoked/spellfist/storm_of_psydon/proc/release_momentum(mob/living/carbon/human/H, datum/status_effect/buff/arcyne_momentum/M, stacks)
	if(M)
		M.consume_all_stacks()
	to_chat(H, span_notice("All [stacks] momentum released into the storm!"))

/obj/effect/proc_holder/spell/invoked/spellfist/storm_of_psydon/proc/combo_valid(mob/living/carbon/human/user, mob/living/target)
	if(QDELETED(user) || QDELETED(target))
		return FALSE
	if(user.stat != CONSCIOUS)
		return FALSE
	if(get_dist(user, target) > 1)
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/invoked/spellfist/storm_of_psydon/proc/cling(mob/living/carbon/human/user, mob/living/target)
	if(get_dist(user, target) <= 1)
		return TRUE
	var/turf/user_turf = get_turf(user)
	var/turf/target_turf = get_turf(target)
	if(!user_turf || !target_turf || user_turf.z != target_turf.z)
		return FALSE
	var/dir_to = get_dir(user, target)
	if(!dir_to)
		return FALSE
	user.dir = dir_to
	step(user, dir_to)
	return get_dist(user, target) <= 1

/obj/effect/proc_holder/spell/invoked/spellfist/storm_of_psydon/proc/combo_cleanup(obj/effect/after_image/shadow_left, obj/effect/after_image/shadow_right)
	QDEL_NULL(shadow_left)
	QDEL_NULL(shadow_right)

/obj/effect/proc_holder/spell/invoked/spellfist/storm_of_psydon/proc/create_shadows(mob/living/carbon/human/user, mob/living/target)
	var/turf/user_turf = get_turf(user)

	var/obj/effect/after_image/shadow_left = new(user_turf, 0, 0, 0, 0, 0, 0, 0)
	shadow_left.appearance = user.appearance
	shadow_left.pixel_x = -10
	shadow_left.pixel_y = 4
	shadow_left.alpha = 120
	shadow_left.color = "#EDAF6D"
	shadow_left.dir = user.dir
	shadow_left.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	shadow_left.name = ""

	var/obj/effect/after_image/shadow_right = new(user_turf, 0, 0, 0, 0, 0, 0, 0)
	shadow_right.appearance = user.appearance
	shadow_right.pixel_x = 10
	shadow_right.pixel_y = 4
	shadow_right.alpha = 120
	shadow_right.color = "#EDAF6D"
	shadow_right.dir = user.dir
	shadow_right.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	shadow_right.name = ""

	return list(shadow_left, shadow_right)

/obj/effect/proc_holder/spell/invoked/spellfist/storm_of_psydon/proc/oraora(mob/living/carbon/human/user, mob/living/target)
	user.changeNext_move(CLICK_CD_MELEE * 3)

	var/target_zone = user.zone_selected || BODY_ZONE_CHEST
	var/list/shadows = create_shadows(user, target)
	var/obj/effect/after_image/shadow_left = shadows[1]
	var/obj/effect/after_image/shadow_right = shadows[2]

	var/combo_broken = FALSE
	var/hit_num = 0
	for(var/set_i in 1 to punch_sets_full)
		if(combo_broken)
			break
		if(!cling(user, target))
			combo_broken = TRUE
			break
		user.emote("attack", forced = TRUE)
		var/turf/new_turf = get_turf(user)
		shadow_left.forceMove(new_turf)
		shadow_right.forceMove(new_turf)
		var/punch_dir = get_dir(user, target)
		var/lunge_px = 0
		var/lunge_py = 0
		if(punch_dir & NORTH)
			lunge_py = 6
		if(punch_dir & SOUTH)
			lunge_py = -6
		if(punch_dir & EAST)
			lunge_px = 6
		if(punch_dir & WEST)
			lunge_px = -6
		for(var/punch_i in 1 to punches_per_set)
			if(!combo_valid(user, target))
				combo_broken = TRUE
				break
			hit_num++
			target.visible_message(span_danger("[user] hits [target] with Storm of Psydon (Punch [hit_num])!"))
			psydon_strike(user, target, punch_damage, target_zone)
			playsound(get_turf(target), pick('sound/combat/hits/punch/punch_hard (1).ogg','sound/combat/hits/punch/punch_hard (2).ogg','sound/combat/hits/punch/punch_hard (3).ogg'), 80, TRUE)
			animate(shadow_left, pixel_x = -10 + lunge_px, pixel_y = 4 + lunge_py, time = 0.5, easing = EASE_OUT)
			animate(pixel_x = -10, pixel_y = 4, time = 0.5, easing = EASE_IN)
			animate(shadow_right, pixel_x = 10 + lunge_px, pixel_y = 4 + lunge_py, time = 0.5, easing = EASE_OUT)
			animate(pixel_x = 10, pixel_y = 4, time = 0.5, easing = EASE_IN)
		sleep(3)

	sleep(3)
	if(!combo_broken && cling(user, target) && combo_valid(user, target))
		user.emote("attack", forced = TRUE)
		target.visible_message(span_danger("[user] hits [target] with Storm of Psydon (Kick)!"))
		psydon_strike(user, target, kick_damage, target_zone)
		playsound(get_turf(target), pick('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg'), 100, TRUE)
		var/atom/throw_target = get_edge_target_turf(user, get_dir(user, target))
		target.safe_throw_at(throw_target, 3, 4, user)
		target.Knockdown(2 SECONDS)

	combo_cleanup(shadow_left, shadow_right)
	log_combat(user, target, "used Storm of Psydon (full)")

/obj/effect/proc_holder/spell/invoked/spellfist/storm_of_psydon/proc/oraora_lame(mob/living/carbon/human/user, mob/living/target)
	user.changeNext_move(CLICK_CD_MELEE * 2)

	var/target_zone = user.zone_selected || BODY_ZONE_CHEST
	var/combo_broken = FALSE
	user.emote("attack", forced = TRUE)

	for(var/i in 1 to punch_count_lame)
		if(!combo_valid(user, target))
			combo_broken = TRUE
			break
		target.visible_message(span_danger("[user] hits [target] with Storm of Psydon (Punch [i])!"))
		psydon_strike(user, target, punch_damage, target_zone)
		playsound(get_turf(target), pick('sound/combat/hits/punch/punch_hard (1).ogg','sound/combat/hits/punch/punch_hard (2).ogg','sound/combat/hits/punch/punch_hard (3).ogg'), 80, TRUE)
		sleep(1)

	sleep(1)
	if(!combo_broken && cling(user, target) && combo_valid(user, target))
		user.emote("attack", forced = TRUE)
		target.visible_message(span_danger("[user] hits [target] with Storm of Psydon (Kick)!"))
		psydon_strike(user, target, kick_damage, target_zone)
		playsound(get_turf(target), pick('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg'), 100, TRUE)
		var/atom/throw_target = get_edge_target_turf(user, get_dir(user, target))
		target.safe_throw_at(throw_target, 3, 4, user)
		target.Knockdown(2 SECONDS)

	log_combat(user, target, "used Storm of Psydon (lame)")
