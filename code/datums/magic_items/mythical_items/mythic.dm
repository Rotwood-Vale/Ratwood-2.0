#define INFERNAL_FLAME_COOLDOWN 20 SECONDS
#define FREEZING_COOLDOWN 20 SECONDS
#define REWIND_COOLDOWN 20 SECONDS

//T4 Enchantments
/datum/magic_item/mythic/infernalflame
	name = "炼狱之焰"
	description = "它泛着白炽般的热光。"
	var/last_used
	var/warned

/datum/magic_item/mythic/infernalflame/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(world.time < last_used + INFERNAL_FLAME_COOLDOWN)
		return
	if(isliving(target))
		var/mob/living/targeted = target
		targeted.adjust_fire_stacks(10)
		targeted.ignite_mob()
		targeted.visible_message(span_danger("[source] 点燃了 [targeted]！"))
		last_used = world.time

/datum/magic_item/mythic/infernalflame/projectile_hit(atom/fired_from, atom/movable/firer, atom/target, Angle)
	if(world.time < last_used + INFERNAL_FLAME_COOLDOWN)
		if(!warned)
			to_chat(firer, span_notice("[fired_from] 还没准备好焚灭一切！"))
			warned = TRUE
	if(isliving(firer) && isliving(target))
		var/mob/living/damaging = target
		if(damaging.stat != DEAD)
			damaging.adjust_fire_stacks(10)
			damaging.ignite_mob()
			damaging.visible_message(span_danger("[fired_from]点燃了[damaging]！"))
			last_used = world.time

/datum/magic_item/mythic/infernalflame/on_hit_response(obj/item/I, mob/living/carbon/human/owner, mob/living/carbon/human/attacker)
	if(world.time < last_used + INFERNAL_FLAME_COOLDOWN)
		return
	if(isliving(attacker) && attacker != owner)
		attacker.adjust_fire_stacks(10)
		attacker.ignite_mob()
		attacker.visible_message(span_danger("[I]点燃了[attacker]！"))
		last_used = world.time

/datum/magic_item/mythic/freezing
	name = "极寒"
	description = "它摸起来冰冷刺骨。"
	var/last_used
	var/warned
/datum/magic_item/mythic/freezing/on_hit_response(obj/item/I, mob/living/carbon/human/owner, mob/living/carbon/human/attacker)
	if(world.time < last_used + FREEZING_COOLDOWN)
		return
	if(isliving(attacker) && attacker != owner)
		attacker.apply_status_effect(/datum/status_effect/freon/freezing)
		attacker.visible_message(span_danger("[I]将[attacker]冻得结结实实！"))
		last_used = world.time

/datum/magic_item/mythic/freezing/projectile_hit(atom/fired_from, atom/movable/firer, atom/target, Angle)
	if(world.time < last_used + FREEZING_COOLDOWN)
		if(!warned)
			to_chat(firer, span_notice("[fired_from] 还没准备好将目标彻底冰封！"))
			warned = TRUE
	if(isliving(firer) && isliving(target))
		var/mob/living/damaging = target
		if(damaging.stat != DEAD)
			damaging.apply_status_effect(/datum/status_effect/freon/freezing)
			damaging.visible_message(span_danger("[fired_from]将[damaging]冻得结结实实！"))
			last_used = world.time

/datum/magic_item/mythic/freezing/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(world.time < last_used + FREEZING_COOLDOWN)
		return
	if(isliving(target))
		var/mob/living/targeted = target
		targeted.apply_status_effect(/datum/status_effect/freon/freezing)
		targeted.visible_message(span_danger("[source]将[targeted]冻得结结实实！"))
		last_used = world.time

/datum/magic_item/mythic/briarcurse
	name = "Briar 的诅咒"
	description = "它的握柄似乎满是荆刺。用起来一定很痛。"
	var/last_used

/datum/magic_item/mythic/briarcurse/on_apply(obj/item/i)
	.=..()
	i.force = i.force + 10
	i.force_wielded = i.force_wielded + 10

/datum/magic_item/mythic/briarcurse/on_hit(obj/item/source, atom/target, mob/living/user, proximity_flag, click_parameters)
	.=..()
	if(isliving(target))
		var/mob/living/carbon/H = user
		H.adjustBruteLoss(10)
		to_chat(user, span_notice("[source]用它锋利的边缘划伤了你！"))

/datum/magic_item/mythic/rewind
	name = "时序回溯"
	description = "它看起来仿佛同时既古老又崭新。"
	var/last_used
	var/active_item = FALSE
	var/warned = FALSE

/datum/magic_item/mythic/rewind/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	.=..()
	if(world.time < last_used + REWIND_COOLDOWN)
		return
	else
		var/turf/target_turf = get_turf(user)
		active_item = TRUE
		last_used = world.time
		sleep(5 SECONDS)
		to_chat(user, span_notice("[source] 将你送回了过去的时刻！"))
		do_teleport(user, target_turf, channel = TELEPORT_CHANNEL_QUANTUM)

/datum/magic_item/mythic/rewind/on_hit_response(obj/item/I, mob/living/carbon/human/owner, mob/living/carbon/human/attacker)
	if(world.time < last_used + REWIND_COOLDOWN)
		return
	if(!active_item)
		var/turf/target_turf = get_turf(owner)
		active_item = TRUE
		last_used = world.time
		sleep(5 SECONDS)
		to_chat(owner, span_notice("[I] 将你送回了过去的时刻！"))
		do_teleport(owner, target_turf, channel = TELEPORT_CHANNEL_QUANTUM)
		active_item = FALSE


/datum/magic_item/mythic/chaos_storm
	name = "混沌风暴"
	description = "它噼啪作响，涌动着难以预测的混沌能量。"
	var/last_used

/datum/magic_item/mythic/chaos_storm/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(world.time < last_used + 10 SECONDS)
		return
	if(isliving(target))
		var/mob/living/targeted = target
		switch(rand(1,5))
			if(1)
				targeted.apply_damage(15, BURN)
				targeted.adjust_fire_stacks(5)
				targeted.ignite_mob()
				to_chat(targeted, span_warning("混沌火焰吞没了你！"))
			if(2)
				targeted.apply_damage(10, BRUTE)
				targeted.Knockdown(20)
				to_chat(targeted, span_warning("混沌之力猛击着你！"))
			if(3)
				targeted.electrocute_act(12, source, 1)
				to_chat(targeted, span_warning("混沌闪电窜过了你的全身！"))
			if(4)
				targeted.OffBalance(2.5 SECONDS)
				to_chat(targeted, span_warning("混沌能量扰乱了你的协调性！"))
			if(5)
				targeted.confused += 2 SECONDS
				to_chat(targeted, span_warning("混沌能量搅乱了你的思绪！"))
	last_used = world.time
