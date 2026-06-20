

/mob/living/simple_animal/proc/try_pull_secondary_rider(mob/living/carbon/human/M)
	if(!can_buckle)
		return FALSE
	if(!GetComponent(/datum/component/riding))
		return FALSE
	if(M.buckled != src)
		return FALSE

	var/mob/living/grab_target = null
	if(M.r_grab)
		if(M.r_grab.grab_state >= GRAB_AGGRESSIVE)
			var/atom/movable/right_grabbed = M.r_grab.grabbed
			if(ismob(right_grabbed))
				grab_target = right_grabbed
	if(!grab_target)
		if(M.l_grab)
			if(M.l_grab.grab_state >= GRAB_AGGRESSIVE)
				var/atom/movable/left_grabbed = M.l_grab.grabbed
				if(ismob(left_grabbed))
					grab_target = left_grabbed

	if(!grab_target)
		return FALSE
	if(!buckled_mobs)
		return FALSE
	if(buckled_mobs.len >= max_buckled_mobs)
		return FALSE
	if(buckled_mobs.Find(grab_target))
		return TRUE

	grab_target.forceMove(get_turf(src))
	buckle_mob(grab_target, TRUE, FALSE)
	M.stop_pulling()

	var/datum/component/riding/riding_datum = GetComponent(/datum/component/riding)
	if(riding_datum)
		riding_datum.driver = M
		riding_datum.handle_vehicle_offsets()

	visible_message(span_notice("[M]将[grab_target]拉到[src]身上。"), span_notice("[M]将[grab_target]拉到我身上。"))
	return TRUE

/mob/living/simple_animal/attack_hand(mob/living/carbon/human/M)
	if(try_pull_secondary_rider(M))
		return TRUE
	..()
	switch(M.used_intent.type)
		if(INTENT_HELP)
			if (health > 0)
				visible_message(span_notice("[M] [response_help_continuous] [src]。"), \
								span_notice("[M] [response_help_continuous] 我。"), null, null, M)
				to_chat(M, span_notice("我[response_help_simple]了[src]。"))
				playsound(loc, 'sound/blank.ogg', 50, TRUE, -1)
			return TRUE

		if(INTENT_GRAB)
			if(!M.has_hand_for_held_index(M.active_hand_index, TRUE)) //we obviously have a hadn, but we need to check for fingers/prosthetics
				to_chat(M, span_warning("我的手指动不了。"))
				return
			grabbedby(M)
			return TRUE

		if(INTENT_HARM)
			var/atk_verb = pick(M.used_intent.attack_verb)
			if(HAS_TRAIT(M, TRAIT_PACIFISM))
				to_chat(M, span_warning("我不想伤害[src]！"))
				return
			M.do_attack_animation(src, M.used_intent.animname)
			playsound(loc, attacked_sound, 25, TRUE, -1)
			var/damage = M.get_punch_dmg()
			next_attack_msg.Cut()
			attack_threshold_check(damage)
			log_combat(M, src, "attacked")
			updatehealth()
			var/hitlim = simple_limb_hit(M.zone_selected)
			simple_woundcritroll(M.used_intent.blade_class, damage, M, hitlim)
			visible_message(span_danger("[M] [atk_verb]了[src]![next_attack_msg.Join()]"),\
							span_danger("[M] [atk_verb]了我![next_attack_msg.Join()]"), null, COMBAT_MESSAGE_RANGE)
			next_attack_msg.Cut()
			return TRUE

		if(INTENT_DISARM)
			var/mob/living/carbon/human/user = M
			var/mob/living/simple_animal/target = src
			if(!(user.mobility_flags & MOBILITY_STAND) || user.IsKnockdown())
				return FALSE
			if(user == target)
				return FALSE
			if(user.loc == target.loc)
				return FALSE
			else
				user.do_attack_animation(target, ATTACK_EFFECT_DISARM)
				playsound(target, 'sound/combat/shove.ogg', 100, TRUE, -1)

				var/turf/target_oldturf = target.loc
				var/shove_dir = get_dir(user.loc, target_oldturf)
				var/turf/target_shove_turf = get_step(target.loc, shove_dir)
				var/mob/living/target_collateral_mob
				var/obj/structure/table/target_table
				var/shove_blocked = FALSE //Used to check if a shove is blocked so that if it is knockdown logic can be applied
				if(prob(30 + generic_stat_comparison(user.STASTR, target.STACON) ))//check if we actually shove them
					target_collateral_mob = locate(/mob/living) in target_shove_turf.contents
					if(target_collateral_mob)
						shove_blocked = TRUE
					else
						target.Move(target_shove_turf, shove_dir)
						if(get_turf(target) == target_oldturf)
							target_table = locate(/obj/structure/table) in target_shove_turf.contents
							if(target_table)
								shove_blocked = TRUE

				if(shove_blocked && !target.buckled)
					var/directional_blocked = FALSE
					if(shove_dir in GLOB.cardinals) //Directional checks to make sure that we're not shoving through a windoor or something like that
						var/target_turf = get_turf(target)
						for(var/obj/O in target_turf)
							if(O.flags_1 & ON_BORDER_1 && O.dir == shove_dir && O.density)
								directional_blocked = TRUE
								break
						if(target_turf != target_shove_turf) //Make sure that we don't run the exact same check twice on the same tile
							for(var/obj/O in target_shove_turf)
								if(O.flags_1 & ON_BORDER_1 && O.dir == turn(shove_dir, 180) && O.density)
									directional_blocked = TRUE
									break
					if((!target_table && !target_collateral_mob) || directional_blocked)
						target.Stun(10)
						target.visible_message(span_danger("[user.name]推搡了[target.name]！"),
									span_danger("我被[user.name]推搡了！"), span_hear("你听到激烈的推搡声，随后是一声闷响！"), COMBAT_MESSAGE_RANGE, user)
						to_chat(user, span_danger("我推搡了[target.name]！"))
						log_combat(user, target, "shoved", "knocking them down")
					else if(target_table)
						target.Stun(10)
						target.visible_message(span_danger("[user.name]把[target.name]推搡到\the [target_table]上！"),
									span_danger("我被[user.name]推搡到\the [target_table]上了！"), span_hear("你听到激烈的推搡声，随后是一声闷响！"), COMBAT_MESSAGE_RANGE, user)
						to_chat(user, span_danger("我把[target.name]推搡到\the [target_table]上了！"))
						target.throw_at(target_table, 1, 1, null, FALSE) //1 speed throws with no spin are basically just forcemoves with a hard collision check
						log_combat(user, target, "shoved", "onto [target_table] (table)")
					else if(target_collateral_mob)
						target.Stun(10)
						target_collateral_mob.Stun(SHOVE_KNOCKDOWN_COLLATERAL)
						target.visible_message(span_danger("[user.name]把[target.name]推搡到[target_collateral_mob.name]身上！"),
						span_danger("我被[user.name]推搡到[target_collateral_mob.name]身上！"), span_hear("你听到激烈的推搡声，随后是一声闷响！"), COMBAT_MESSAGE_RANGE, user)
						to_chat(user, span_danger("我把[target.name]推搡到[target_collateral_mob.name]身上！"))
						log_combat(user, target, "shoved", "into [target_collateral_mob.name]")
				else
					target.visible_message(span_danger("[user.name]推搡了[target.name]！"),
								span_danger("我被[user.name]推搡了！"), span_hear("你听到激烈的推搡声！"), COMBAT_MESSAGE_RANGE, user)
					to_chat(user, span_danger("我推搡了[target.name]！"))
					log_combat(user, target, "shoved")
			return TRUE

	if(M.used_intent.unarmed)
		var/atk_verb = pick(M.used_intent.attack_verb)
		if(HAS_TRAIT(M, TRAIT_PACIFISM))
			to_chat(M, span_warning("我不想伤害[src]！"))
			return
		M.do_attack_animation(src, M.used_intent.animname)
		playsound(loc, attacked_sound, 25, TRUE, -1)
		var/damage = M.get_punch_dmg()
		next_attack_msg.Cut()
		attack_threshold_check(damage)
		log_combat(M, src, "attacked")
		updatehealth()
		var/hitlim = simple_limb_hit(M.zone_selected)
		simple_woundcritroll(M.used_intent.blade_class, damage, M, hitlim)
		visible_message(span_danger("[M] [atk_verb]了[src]![next_attack_msg.Join()]"),\
						span_danger("[M] [atk_verb]了我![next_attack_msg.Join()]"), null, COMBAT_MESSAGE_RANGE)
		next_attack_msg.Cut()
		return TRUE

/mob/living/simple_animal/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(.)
		next_attack_msg.Cut()
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		var/hitlim = simple_limb_hit(M.zone_selected)
		attack_threshold_check(damage, M.melee_damage_type)
		simple_woundcritroll(M.a_intent.blade_class, damage, M, hitlim)
		visible_message(span_danger("\The [M] [pick(M.a_intent.attack_verb)]了[src]![next_attack_msg.Join()]"), \
					span_danger("\The [M] [pick(M.a_intent.attack_verb)]了我![next_attack_msg.Join()]"), null, COMBAT_MESSAGE_RANGE)
		next_attack_msg.Cut()

/mob/living/simple_animal/onbite(mob/living/carbon/human/user)
	var/damage = 10*(user.STASTR/20)
	if(HAS_TRAIT(user, TRAIT_STRONGBITE))
		damage = damage*2
	playsound(user.loc, "smallslash", 100, FALSE, -1)
	user.next_attack_msg.Cut()
	if(stat == DEAD)
		if(user.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder))
			to_chat(user, span_notice("我的力量被削弱了，我无法治疗！"))
			return
		if(user.mind && istype(user, /mob/living/carbon/human/species/werewolf))
			visible_message(span_danger("狼人贪婪地吞噬了[src]！"))
			to_chat(src, span_warning("我啃食着鲜美的肉。我感到精神焕发。"))
			user.reagents.add_reagent(/datum/reagent/medicine/healthpot, 30)
			gib()
		if(user.mind && istype(user, /mob/living/carbon/human/species/wildshape/volf))
			visible_message(span_danger("沃尔夫贪婪地吞噬了[src]！"))
			to_chat(src, span_warning("我啃食着鲜美的肉。我感到饱足了。"))
			user.reagents.add_reagent(/datum/reagent/consumable/nutriment, 15)
			gib()
		return
	if(src.apply_damage(damage, BRUTE))
		if(istype(user, /mob/living/carbon/human/species/werewolf))
			visible_message(span_danger("狼人咬住[src]猛甩！"))
		else
			visible_message(span_danger("[user]咬了[src]！他们怎么了？"))

/mob/living/simple_animal/onkick(mob/M)
	var/mob/living/simple_animal/target = src
	var/mob/living/carbon/human/user = M
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("我不想伤害[target]！"))
		return FALSE
	if(user.IsKnockdown())
		return FALSE
	if(user == target)
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_GARROTED))	
		if(user.check_leg_grabbed(1) || user.check_leg_grabbed(2))
			to_chat(user, span_notice("我的腿动不了！"))
			return
	if(user.stamina >= user.max_stamina)
		return FALSE
	if(user.loc == target.loc)
		to_chat(user, span_warning("我离得太近，没法好好踢一脚。"))
		return FALSE
	else
		user.do_attack_animation(target, ATTACK_EFFECT_DISARM)
		playsound(target, 'sound/combat/hits/kick/kick.ogg', 100, TRUE, -1)

		var/shove_dir = get_dir(user.loc, target.loc)
		var/turf/target_shove_turf = get_step(target.loc, shove_dir)

		target.Move(target_shove_turf, shove_dir)

		target.visible_message(span_danger("[user.name]踢了[target.name]！"),
						span_danger("我被[user.name]踢了！"), span_hear("你听到激烈的推搡声！"), COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_danger("我踢了[target.name]！"))
		log_combat(user, target, "kicked")
		playsound(target, 'sound/combat/hits/kick/kick.ogg', 100, TRUE, -1)
		target.lastattacker = user.real_name
		target.lastattackerckey = user.ckey
		target.lastattacker_weakref = WEAKREF(user)
		if(target.mind)
			target.mind.attackedme[user.real_name] = world.time
		user.stamina_add(15)

/mob/living/simple_animal/proc/attack_threshold_check(damage, damagetype = BRUTE, armorcheck = d_type)
	var/temp_damage = damage
	if(!damage_coeff[damagetype])
		temp_damage = 0
	else
		temp_damage *= damage_coeff[damagetype]

	if(temp_damage >= 0 && temp_damage <= force_threshold)
		visible_message(span_warning("[src]看起来毫发无伤！"))
		return FALSE
	else
		apply_damage(damage, damagetype, null, getarmor(null, armorcheck))
		return TRUE

/mob/living/simple_animal/ex_act(severity, target, epicenter, devastation_range, heavy_impact_range, light_impact_range, flame_range)
	..()
	if(!severity || !epicenter)
		return
	var/ddist = devastation_range || 0
	var/hdist = heavy_impact_range || 0
	var/ldist = light_impact_range || 0
	var/fdist = flame_range || 0
	var/fodist = get_dist(src, epicenter)
	var/brute_loss = 0
	var/burn_loss = 0
	var/dmgmod = round(rand(0.5, 1.5), 0.1)

	if(fdist)
		var/stacks = ((fdist - fodist) * 2)
		fire_act(stacks)

	switch(severity)
		if(EXPLODE_DEVASTATE)
			brute_loss = ((120 * ddist) - (120 * fodist) * dmgmod)
			burn_loss = ((60 * ddist) - (60 * fodist) * dmgmod)
			Unconscious((50 * ddist) - (15 * fodist))
			Knockdown((30 * ddist) - (30 * fodist))

		if(EXPLODE_HEAVY)
			brute_loss = ((40 * hdist) - (40 * fodist) * dmgmod)
			burn_loss = ((20 * hdist) - (20 * fodist) * dmgmod)
			Unconscious((10 * hdist) - (5 * fodist))
			Knockdown((30 * hdist) - (30 * fodist))

		if(EXPLODE_LIGHT)
			brute_loss = ((10 * ldist) - (10 * fodist) * dmgmod)

	take_overall_damage(brute_loss,burn_loss)

/mob/living/simple_animal/do_attack_animation(atom/A, visual_effect_icon, used_item, no_effect, item_animation_override = null, used_intent = null, simplified = TRUE)
	if(!no_effect && !visual_effect_icon && melee_damage_upper)
		if(melee_damage_upper < 10)
			visual_effect_icon = ATTACK_EFFECT_PUNCH
		else
			visual_effect_icon = ATTACK_EFFECT_SMASH
	..()
