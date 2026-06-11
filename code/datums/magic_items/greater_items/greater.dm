///T3 Enchantmentsdatum
/datum/magic_item/greater/lifesteal
	name = "生命汲取"
	description = "它似乎渴望鲜血。"
	var/last_used
	var/flat_heal = 10
	var/static/list/damage_heal_order = list(BRUTE, BURN, OXY)
	var/warned = FALSE

/datum/magic_item/greater/lifesteal/projectile_hit(atom/fired_from, atom/movable/firer, atom/target, Angle)
	if(world.time < src.last_used + 100)
		to_chat(firer, span_notice("[fired_from] 还没饿到能再吞噬生命！"))
		return
	if(isliving(firer) && isliving(target))
		var/mob/living/healing = firer
		var/mob/living/damaging = target
		if(damaging.stat != DEAD)
			healing.heal_ordered_damage(flat_heal, damage_heal_order)
			firer.visible_message(span_danger("[fired_from] 汲取了 [target] 的生命！"))
			src.last_used = world.time

/datum/magic_item/greater/lifesteal/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(world.time < src.last_used + 100)
		if(!warned)
			to_chat(user, span_notice("[source] 还没饿到能再吞噬生命！"))
			warned = TRUE
		return
	if(isliving(user) && isliving(target))
		var/mob/living/healing = user
		var/mob/living/damaging = target
		if(damaging.stat != DEAD)
			healing.heal_ordered_damage(flat_heal, damage_heal_order)
			user.visible_message(span_danger("[source] 汲取了 [target] 的生命！"))
			warned = FALSE
			src.last_used = world.time

/datum/magic_item/greater/lightning
	name = "闪电"
	description = "其上跃动着细小的电弧。"
	var/list/last_used = list()

/datum/magic_item/greater/lightning/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(world.time < (src.last_used[source] + (40 SECONDS)))
		return

	if(isliving(target))
		var/mob/living/L = target
		L.Immobilize(0.5 SECONDS)
		L.apply_status_effect(/datum/status_effect/debuff/clickcd, 6 SECONDS)
		L.electrocute_act(1, src, 1, SHOCK_NOSTUN)
		L.apply_status_effect(/datum/status_effect/buff/lightningstruck, 6 SECONDS)

		for(var/mob/living/nearby in range(2, target))
			if(nearby == target || nearby == user)
				continue
			if(prob(30))
				nearby.Immobilize(0.5 SECONDS)
				nearby.apply_status_effect(/datum/status_effect/debuff/clickcd, 6 SECONDS)
				nearby.electrocute_act(1, src, 1, SHOCK_NOSTUN)
				nearby.apply_status_effect(/datum/status_effect/buff/lightningstruck, 6 SECONDS)
				new /obj/effect/temp_visual/lightning(get_turf(target), get_turf(nearby))
	last_used[source] = world.time

/datum/magic_item/greater/frostveil
	name = "霜幕"
	description = "它摸起来相当冰冷。"
	var/last_used

/datum/magic_item/greater/frostveil/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(world.time < src.last_used + 20 SECONDS)
		return
	if(isliving(target))
		var/mob/living/targeted = target
		targeted.apply_status_effect(/datum/status_effect/debuff/cold)
		targeted.visible_message(span_danger("[source] 冻得 [targeted] 发寒！"))
		src.last_used = world.time

/datum/magic_item/greater/frostveil/on_hit_response(obj/item/I, mob/living/carbon/human/owner, mob/living/carbon/human/attacker)
	if(world.time < src.last_used + 20 SECONDS)
		return
	if(isliving(attacker) && attacker != owner)
		attacker.apply_status_effect(/datum/status_effect/debuff/cold)
		attacker.visible_message(span_danger("[I] 冻得 [attacker] 发寒！"))
		src.last_used = world.time

/datum/magic_item/greater/phoenixguard
	name = "凤凰守护"
	description = "它散发着炽烈的热量。"
	var/last_used

/datum/magic_item/greater/phoenixguard/on_hit_response(obj/item/I, mob/living/carbon/human/owner, mob/living/carbon/human/attacker)
	if(world.time < src.last_used + 20 SECONDS)
		return
	if(isliving(attacker) && attacker != owner)
		attacker.adjust_fire_stacks(5)
		attacker.ignite_mob()
		attacker.visible_message(span_danger("[I] 点燃了 [attacker]！"))
		src.last_used = world.time

/datum/magic_item/greater/woundclosing
	name = "伤口闭合"
	description = "它脉动着治愈魔力。"
	var/active_item = FALSE

/datum/magic_item/greater/woundclosing/on_equip(obj/item/i, mob/living/user, slot)
	if(slot == ITEM_SLOT_HANDS)
		return
	if(active_item)
		return
	else
		user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/wound_closure)
		to_chat(user, span_notice("[i] 在指间泛起温热。"))
		active_item = TRUE

/datum/magic_item/greater/woundclosing/on_drop(obj/item/i, mob/living/user)
	if(active_item)
		active_item = FALSE
		user.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/wound_closure)
		to_chat(user, span_notice("[i] 的温热逐渐消散了。"))

/datum/magic_item/greater/returningweapon
	name = "归返武器"
	description = "它闪烁着奥术符印。"
	var/active_item = FALSE

/datum/magic_item/greater/returningweapon/on_equip(obj/item/i, mob/living/user, slot)
	if(slot == ITEM_SLOT_HANDS)
		return
	if(active_item)
		return
	else
		active_item = TRUE
		user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/summonweapon)
		to_chat(user, span_notice("我感觉 [i] 中的魔力与我自身产生了共鸣。"))

/datum/magic_item/greater/returningweapon/on_drop(obj/item/i, mob/living/user)
	if(active_item)
		user.mind.RemoveSpell(/obj/effect/proc_holder/spell/targeted/summonweapon)
		to_chat(user, span_notice("[i] 的温热逐渐消散了。"))
		active_item = FALSE

/datum/magic_item/greater/archery
	name = "箭术"
	description = "它留有弓弦的印痕。"
	var/active_item = FALSE
	var/masterbow = FALSE
	var/legendbow = FALSE
	var/mastercrossbow = FALSE
	var/legendcrossbow = FALSE
	var/mastersling = FALSE
	var/legendsling = FALSE

/datum/magic_item/greater/archery/on_equip(obj/item/i, mob/living/user, slot)
	if(slot == ITEM_SLOT_HANDS)
		return
	if(active_item)
		return
	else
		//stat boost
		user.change_stat(STATKEY_PER, 2)

		//Bow boost
		if (user.get_skill_level(/datum/skill/combat/bows) == 6)
			legendbow = TRUE
			masterbow = FALSE
		else
			if (user.get_skill_level(/datum/skill/combat/bows) == 5)
				user.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
				masterbow = TRUE
			else
				user.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE)

		//crossbow boost
		if (user.get_skill_level(/datum/skill/combat/crossbows) == 6)
			legendcrossbow = TRUE
			mastercrossbow = FALSE
		else
			if (user.get_skill_level(/datum/skill/combat/crossbows) == 5)
				user.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)
				mastercrossbow = TRUE
			else
				user.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)

		//sling boost
		if (user.get_skill_level(/datum/skill/combat/slings) == 6)
			legendsling = TRUE
			mastersling = FALSE
		else
			if (user.get_skill_level(/datum/skill/combat/slings) == 5)
				user.adjust_skillrank(/datum/skill/combat/slings, 1, TRUE)
				mastersling = TRUE
			else
				user.adjust_skillrank(/datum/skill/combat/slings, 2, TRUE)

		to_chat(user, span_notice("我感觉自己更灵巧了！"))
		active_item = TRUE

/datum/magic_item/greater/archery/on_drop(obj/item/i, mob/living/user)
	if(active_item)
		active_item = FALSE
		user.change_stat(STATKEY_PER, -2)
		//correct bows
		if (!legendbow)
			if (masterbow)
				user.adjust_skillrank(/datum/skill/combat/bows -1, TRUE)
			else
				user.adjust_skillrank(/datum/skill/combat/bows, -2, TRUE)

		//correct crossbows
		if (!legendcrossbow)
			if (mastercrossbow)
				user.adjust_skillrank(/datum/skill/combat/crossbows -1, TRUE)
			else
				user.adjust_skillrank(/datum/skill/combat/crossbows, -2, TRUE)

		//correct slings
		if (!legendsling)
			if (mastersling)
				user.adjust_skillrank(/datum/skill/combat/slings -1, TRUE)
			else
				user.adjust_skillrank(/datum/skill/combat/slings, -2, TRUE)

		to_chat(user, span_notice("我又恢复平凡了。"))

/datum/magic_item/greater/void
	name = "虚空之触"
	description = "它似乎在吞噬周围的光，仿佛有一部分存在于现实之外。"
	var/list/last_used = list()

/datum/magic_item/greater/void/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(world.time < (src.last_used[source] + 10 SECONDS))
		return

	if(isliving(target) && target != user) //self teleporting might be scary actually
		var/mob/living/L = target
		to_chat(L, span_warning("你感觉周围的现实发生了扭曲！"))
		var/list/possible_turfs = list()
		for(var/turf/T in range(3, L))
			if(T.density)
				continue
			possible_turfs += T
		if(possible_turfs.len)
			L.forceMove(pick(possible_turfs))
		last_used[source] = world.time
