/obj/effect/proc_holder/spell/invoked/minion_order
	name = "号令仆从"
	desc = "对地面施放可令仆从无视其他事物朝该方向前进。\
	对仆从施放可切换其攻击姿态，对自己施放可令其被动跟随，对目标施放可令其集火该目标。\
	对高阶骷髅无效。"
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "ZIZO"
	range = 12
	associated_skill = /datum/skill/misc/athletics
	chargedrain = 1
	chargetime = 0 SECONDS
	releasedrain = 0
	recharge_time = 3 SECONDS
	var/order_range = 12
	var/faction_ordering = FALSE ///this sets whether it orders mobs the user is aligned with in range or just mobs who are the character's 'friends' (ie, their summons)

/obj/effect/proc_holder/spell/invoked/minion_order/lich //as an example, this should allow the lich to command the entire undead faction
	faction_ordering = TRUE

/obj/effect/proc_holder/spell/invoked/minion_order/cast(list/targets, mob/user)
	var/mob/caster = user
	var/target = targets[1]
	var/faction_tag = "[caster.mind.current.real_name]_faction"

	// Target is one of our own minions
	if(ismob(target) && istype(target, /mob/living/simple_animal))
		var/mob/living/simple_animal/minion = target
		if(faction_tag in minion.faction)
			src.process_minions(order_type = "toggle_stance", target = minion, faction_tag = faction_tag)
			return

	// Minions goto turf
	if(isturf(target))
		src.process_minions(order_type = "goto", target_location = target, faction_tag = faction_tag)
		return

	// Target is the caster (set minions to passive and follow)
	else if(target == caster)
		src.process_minions(order_type = "follow", target = caster, faction_tag = faction_tag)
		return

	// Target is another mob
	else if(ismob(target))
		var/mob/living/mob_target = target
		if(faction_tag in mob_target.faction)//We're only checking for faction tagged individuals. Potential issue may arise with commanded mobs attacking mobs with same faction leading to cheese circumstances, but most mobs are retaliatory.
			src.process_minions(order_type = "aggressive", target = target, faction_tag = faction_tag)
			return
		else
			// Set all minions to focus on the enemy target
			src.process_minions(order_type = "attack", target = target, faction_tag = faction_tag)
			return
	else
		revert_cast()
		return

/obj/effect/proc_holder/spell/invoked/minion_order/proc/process_minions(order_type, turf/target_location = null, mob/living/target = null, faction_tag = null)
	var/mob/caster = usr
	var/count = 0
	var/msg = ""

	for (var/mob/other_mob in oview(src.order_range, caster))
		if (istype(other_mob, /mob/living/simple_animal) && !other_mob.client) // Only simple_mobs for now
			var/mob/living/simple_animal/minion = other_mob

			if ((faction_ordering && caster.faction_check_mob(minion)) || (!faction_ordering && faction_tag && (faction_tag in minion.faction)))
				minion.ai_controller.CancelActions()	//this should immediately halt present actions/orders given.
				minion.ai_controller.clear_blackboard_key(BB_FOLLOW_TARGET)
				minion.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
				minion.ai_controller.clear_blackboard_key(BB_TRAVEL_DESTINATION)
				minion.ai_controller.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
				count += 1
				switch (order_type)
					if ("goto")
						minion.ai_controller.set_blackboard_key(BB_TRAVEL_DESTINATION, target_location)
						msg = "前往[target_location]"
					if ("follow")
						minion.ai_controller.set_blackboard_key(BB_FOLLOW_TARGET, target)
						msg = "跟随你。"
					if ("aggressive")
						msg = "自由游荡。"
					if ("attack")
						minion.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
						msg = "攻击[target.name]"
					if("toggle_stance")
						if(minion == target) // single minion clicked
							if("neutral" in minion.faction) // currently passive → switch to aggressive
								minion.faction -= "neutral"
								msg = "[minion.name]开始敌视附近的陌生人。"
							else
								minion.faction += "neutral"
								msg = "[minion.name]平静了下来。"
	if(count>0)
		to_chat(caster, "已命令[count]个仆从" + msg)
	else
		to_chat(caster, "我们没能命令任何人。")
