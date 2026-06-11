/obj/effect/proc_holder/spell/invoked/bonechill
	name = "蚀骨寒侵"
	desc = "以死灵之力冻结目标。会大幅降低速度并削弱肉体能力。"
	cost = 3
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "bone_chill"
	releasedrain = 30
	chargetime = 5
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = null
	sound = 'sound/magic/whiteflame.ogg'
	spell_tier = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	gesture_required = TRUE // Potential offensive use, need a target
	antimagic_allowed = TRUE
	recharge_time = 15 SECONDS
	human_req = TRUE
	miracle = FALSE
	zizo_spell = TRUE

/obj/effect/proc_holder/spell/invoked/bonechill/cast(list/targets, mob/living/user)
	..()
	if(!isliving(targets[1]))
		return FALSE

	var/mob/living/target = targets[1]
	if(target.mob_biotypes & MOB_UNDEAD) //positive energy harms the undead
		var/obj/item/bodypart/affecting = target.get_bodypart(check_zone(user.zone_selected))
		if(affecting && (affecting.heal_damage(50, 50) || affecting.heal_wounds(50)))
			target.update_damage_overlays()
		target.visible_message(span_danger("[target] 在邪异能量中重新塑成！"), span_notice("我被黑暗魔法重新塑造了！"))
		return TRUE

	target.visible_message(span_info("死灵能量漫涌过 [target]！"), span_userdanger("黑暗能量灌入体内，我只觉得愈发寒冷！"))
	if(iscarbon(target))
		target.apply_status_effect(/datum/status_effect/debuff/chilled)
	else
		target.adjustBruteLoss(20)

	return TRUE

/obj/effect/proc_holder/spell/invoked/eyebite
	name = "噬目术"
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "eye_bite"
	releasedrain = 30
	chargetime = 15
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = null
	sound = 'sound/items/beartrap.ogg'
	associated_skill = /datum/skill/magic/arcane
	gesture_required = TRUE // Offensive spell
	antimagic_allowed = TRUE
	recharge_time = 15 SECONDS
	miracle = FALSE
	hide_charge_effect = TRUE

/obj/effect/proc_holder/spell/invoked/eyebite/cast(list/targets, mob/living/user)
	..()
	if(!isliving(targets[1]))
		return FALSE
	var/mob/living/carbon/target = targets[1]
	target.visible_message(span_info("[target] 身上传来一声响亮的咬碎声！"), span_userdanger("我感觉有奥术獠牙正啃咬我的双眼！"))
	target.adjustBruteLoss(30)
	target.blind_eyes(2)
	target.blur_eyes(10)
	return TRUE


/obj/effect/proc_holder/spell/invoked/raise_undead_guard
	name = "召来不死守卫"
	desc = "唤起一名受你驱使的不死守卫。"
	clothes_req = FALSE
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "skeleton"
	range = 7
	sound = list('sound/magic/magnet.ogg')
	releasedrain = 40
	chargetime = 3 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	gesture_required = TRUE
	associated_skill = /datum/skill/magic/arcane
	recharge_time = 30 SECONDS
	hide_charge_effect = TRUE
	var/cabal_affine = FALSE
	var/is_summoned = FALSE

/obj/effect/proc_holder/spell/invoked/raise_undead_guard/cast(list/targets, mob/living/user)
	..()

	var/turf/T = get_turf(targets[1])
	if(!isopenturf(T))
		to_chat(user, span_warning("目标位置被阻挡了。召唤未能显现。"))
		return FALSE

	// Find bones or bone bundle in user's hands
	var/obj/item/sacrifice
	for(var/obj/item/I in user.held_items)
		if(istype(I, /obj/item/natural/bundle/bone) || istype(I, /obj/item/natural/bone))
			sacrifice = I
			break

	if(!sacrifice)
		to_chat(user, span_warning("我需要在空着的手里拿着骨头。"))
		revert_cast()
		return FALSE

	// Handle bone bundles (stacked bones)
	if(istype(sacrifice, /obj/item/natural/bundle/bone))
		var/obj/item/natural/bundle/bone/B = sacrifice
		if(B.amount < 4)
			to_chat(user, span_warning("你至少需要 4 根骨头才能唤起一具骷髅。"))
			revert_cast()
			return FALSE

		B.amount -= 4
		if(B.amount <= 0)
			qdel(B)

	// Handle single loose bones
	else if(istype(sacrifice, /obj/item/natural/bone))
		to_chat(user, span_warning("单独一根骨头不足以唤起骷髅！你需要至少四根捆成一束。"))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/species/skeleton/npc/summoned/S = new /mob/living/carbon/human/species/skeleton/npc/summoned(T)

	qdel(sacrifice)
	S.caster = user
	if(user.faction)
		S.faction |= list("[user.mind.current.real_name]_faction")
	S.set_command("follow", user)

	T.visible_message(span_notice("<b>[user]</b> 从地里唤起了一具骷髅！"))
	S.receive_command_text("起身后向自己的主人低头致意。")
	return TRUE


/obj/effect/proc_holder/spell/invoked/raise_undead_formation
	name = "Raise Lesser Undead Formation"
	desc = "Raises a formation of simple minded undead skeletons. Inferior shamblers. Husks in everything but zeal."
	clothes_req = FALSE
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "skeleton_formation"
	range = 7
	sound = list('sound/magic/magnet.ogg')
	releasedrain = 40
	chargetime = 6 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	gesture_required = TRUE // Summon spell
	associated_skill = /datum/skill/magic/arcane
	recharge_time = 20 SECONDS
	var/cabal_affine = FALSE
	var/is_summoned = FALSE
	var/to_spawn = 4
	hide_charge_effect = TRUE

/obj/effect/proc_holder/spell/invoked/raise_undead_formation/cast(list/targets, mob/living/user)
	..()

	var/turf/T = get_turf(targets[1])
	if(!isopenturf(T))
		to_chat(user, span_warning("The targeted location is blocked. My summon fails to come forth."))
		return FALSE


	var/skeleton_roll

	var/list/turf/target_turfs = list(T)
	if(usr.dir == NORTH || usr.dir == SOUTH)
		target_turfs += get_step(T, EAST)
		target_turfs += get_step(T, WEST)
	else
		target_turfs += get_step(T, NORTH)
		target_turfs += get_step(T, SOUTH)

	for(var/i = 1 to to_spawn)
		if(i > to_spawn)
			i = 1

		var/t_turf = target_turfs[i]

		if(!isopenturf(t_turf))
			continue

		new /obj/effect/temp_visual/bluespace_fissure(t_turf)
		skeleton_roll = rand(1,100)
		switch(skeleton_roll)
			if(1 to 20)
				new /mob/living/simple_animal/hostile/rogue/skeleton/axe(t_turf, user, cabal_affine, is_summoned)
			if(21 to 40)
				new /mob/living/simple_animal/hostile/rogue/skeleton/spear(t_turf, user, cabal_affine, is_summoned)
			if(41 to 60)
				new /mob/living/simple_animal/hostile/rogue/skeleton/guard(t_turf, user, cabal_affine, is_summoned)
			if(61 to 80)
				new /mob/living/simple_animal/hostile/rogue/skeleton/bow(t_turf, user, cabal_affine, is_summoned)
			if(81 to 100)
				new /mob/living/simple_animal/hostile/rogue/skeleton(t_turf, user, cabal_affine, is_summoned)
	return TRUE

/obj/effect/proc_holder/spell/invoked/raise_undead_formation/necromancer
	cabal_affine = TRUE
	is_summoned = TRUE
	recharge_time = 35 SECONDS
	to_spawn = 3


/obj/effect/proc_holder/spell/invoked/tame_undead
	name = "Tame Deadite"
	desc = "Oftentymes, husks and shamblers walk aimlessly - uncertain of their future. Befriends the undead \
	Requires the target to be within four tiles. Works on undead animals, too, and they will heed your command."
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "tame_deadite"
	range = 4
	warnie = "sydwarning"
	recharge_time = 60 SECONDS
	releasedrain = 40
	chargetime = 5 SECONDS
	charging_slowdown = 1
	gesture_required = TRUE
	chargedloop = /datum/looping_sound/invokegen
	no_early_release = TRUE

/obj/effect/proc_holder/spell/invoked/tame_undead/cast(list/targets, mob/living/user)
	..()

	if(!isliving(targets[1]))
		revert_cast()
		return FALSE

	var/mob/living/target = targets[1]

	if(!(target.mob_biotypes & MOB_UNDEAD))
		to_chat(user, span_warning("[target] 的灵魂尚未归于她。我现在无能为力。"))
		revert_cast()
		return FALSE

	if(target.mind)
		to_chat(user, span_warning("[target] 的心智抗拒着你的驱使。这行不通。"))
		revert_cast()
		return FALSE

	target.faction = list("[user.mind.current.real_name]_faction") //only user faction
	target.visible_message(span_notice("[target] 转过头来，开始听从 [user] 的召唤！"))
	if(issimple(target))
		var/mob/living/simple_animal/simple_target = target
		simple_target.tamed()
		if(!target.ai_controller)
			target.ai_controller = /datum/ai_controller/undead
			target.InitializeAIController()
	return TRUE


/obj/effect/proc_holder/spell/invoked/projectile/sickness
	name = "病蚀射线"
	desc = ""
	clothes_req = FALSE
	range = 15
	projectile_type = /obj/projectile/magic/sickness
	overlay_state = "raysickness"
	sound = list('sound/misc/portal_enter.ogg')
	active = FALSE
	releasedrain = 30
	chargetime = 1 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	recharge_time = 15 SECONDS

/obj/effect/proc_holder/spell/invoked/gravemark
	name = "墓印"
	desc = "将目标加入或移出你麾下不死者不会主动攻击的盟友名单。"
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "gravemark"
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = null
	antimagic_allowed = TRUE
	recharge_time = 15 SECONDS
	hide_charge_effect = TRUE

/obj/effect/proc_holder/spell/invoked/gravemark/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/faction_tag = "[user.mind.current.real_name]_faction"
		if (target == user)
			to_chat(user, span_warning("把自己的骷髅变成敌人可不是什么明智之举。"))
			return FALSE
		if(target.mind && target.mind.current)
			if (faction_tag in target.mind.current.faction)
				target.mind.current.faction -= faction_tag
				user.say("我已宣你为敌。")
			else
				target.mind.current.faction += faction_tag
				user.say("我已宣你为友。")
				target.notify_faction_change()
		else if(istype(target, /mob/living/simple_animal))
			if (faction_tag in target.faction)
				target.faction -= faction_tag
				user.say("Hostis declaratus es.")
			else
				target.faction |= faction_tag
				user.say("Amicus declaratus es.")
				target.notify_faction_change()
		return TRUE
	return FALSE

/obj/effect/proc_holder/spell/invoked/command_undead
	name = "号令不死者"
	desc = "命令骷髅行动。对地面施放会令其前往该处并无视其他事物；对自己施放会命其跟随；对目标施放会命其攻击；对低阶骷髅施放则可切换其待机攻击姿态。"
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "ZIZO"
	warnie = "sydwarning"
	range = 8
	associated_skill = /datum/skill/magic/arcane
	chargedrain = 1
	chargetime = 0 SECONDS
	releasedrain = 0
	recharge_time = 3 SECONDS
	chargedloop = /datum/looping_sound/invokegen
	var/list/summoned_minions = list() // You can reuse the one tracked by your summon spell
	var/faction_ordering = FALSE ///this sets whether it orders mobs the user is aligned with in range or just mobs who are the character's 'friends' (ie, their summons)

/obj/effect/proc_holder/spell/invoked/command_undead/cast(list/targets, mob/living/user)
	if(!user)
		return

	var/mob/living/summoner = user
	if(!summoner.mind || !summoner.mind.current)
		to_chat(user, "<span class='warning'>你的心神散乱，无法号令自己的仆从。</span>")
		return

	// Get the thing they clicked
	var/atom/target = targets[1]
	if(!target)
		to_chat(user, "你必须点选一个地点或生物，才能向不死者下令。")
		return
	var/faction_tag = "[user.mind.current.real_name]_faction"

	var/list/commandable_simple_mobs = list(
		/mob/living/simple_animal/hostile/rogue/skeleton,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead,
		/mob/living/simple_animal/hostile/retaliate/rogue/saiga/undead
	)

	var/list/carbon_minions = list()
	var/list/simple_minions = list()
	for(var/mob/living/carbon/human/species/skeleton/npc/summoned/M in view(15, user))
		if(M.caster == user)
			carbon_minions += M

	for(var/mob/living/simple_animal/M in view(15, user))
		for(var/type in commandable_simple_mobs)
			if(istype(M, type))
				simple_minions += M
				break

	if(!length(carbon_minions) && !length(simple_minions))
		to_chat(user, "<span class='warning'>你附近没有任何受你控制的不死者。</span>")
		return

	// Determine command type
	var/command_type
	if(ismob(target))
		var/mob/living/L = target
		if(L == user || (faction_tag in L.faction))
			command_type = "follow"
		else
			command_type = "attack"
	else if(isturf(target))
		command_type = "move"
	else
		to_chat(user, "你只能指定地点或生物作为目标。")
		return

	// Issue command
	for(var/mob/living/carbon/human/species/skeleton/npc/summoned/M in carbon_minions)
		M.set_command(command_type, target)
		switch(command_type)
			if("follow")
				M.receive_command_text("开始忠实地跟随 [target]。")
			if("move")
				M.receive_command_text("摇晃着朝指定地点前进。")
			if("attack")
				M.receive_command_text("发出低吼，朝 [target] 扑去。")


	// -----------------------------------------------------------------
	// Handle SIMPLE skeletons via AI controller and faction logic below
	// -----------------------------------------------------------------

	var/mob/caster = user
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
	to_chat(user, "<span class='notice'>你向自己的爪牙下达了命令。</span>")

//AI processing orders for simple mob undead
/obj/effect/proc_holder/spell/invoked/command_undead/proc/process_minions(order_type, turf/target_location = null, mob/living/target = null, faction_tag = null)
	var/mob/caster = usr
	var/count = 0

	for (var/mob/other_mob in oview(12, caster))
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
						minion.visible_message("[minion.name] 摇摇晃晃地朝指定地点走去。")
					if ("follow")
						minion.ai_controller.set_blackboard_key(BB_FOLLOW_TARGET, target)
						minion.visible_message("[minion.name] 开始忠实地跟随 [caster]。")
					if ("aggressive")
					if ("attack")
						minion.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
						minion.visible_message("[minion.name] 踉跄着向前扑去，准备攻击 [target]。")
					if("toggle_stance")
						if(minion == target) // single minion clicked
							if("neutral" in minion.faction) // currently passive → switch to aggressive
								minion.faction -= "neutral"
								to_chat(caster, "[minion.name] 开始对附近的陌生人显露敌意。")
							else
								minion.faction += "neutral"
								to_chat(caster, "[minion.name] 平静了下来。")
