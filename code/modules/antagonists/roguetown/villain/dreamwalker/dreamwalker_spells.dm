
/obj/effect/proc_holder/spell/invoked/mark_target
	name = "标记目标"
	desc = "随机标记一名追猎目标。追踪他们，用你获得的追踪法术从其心智中抽取金属以完成你的愿景。再用梦境武器击中他们，稍后就能将其召唤到你身边。"
	releasedrain = 75
	chargedrain = 1
	chargetime = 1.5 SECONDS
	recharge_time = 25 MINUTES
	overlay_state = "dream_mark"
	invocations = list("梦境……显现我的愿景，顺从我的意志。")
	invocation_type = "whisper"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 1
	associated_skill = /datum/skill/magic/arcane

	// Define roles that are considered valid targets
	// Generally combat ready roles connected to a larger faction.
	var/static/list/valid_target_roles = list(
		"Orthodoxist",
		"Absolver",
		"Templar",
		"Dungeoneer",
		"Sergeant",
		"Man at Arms",
		"Knight",
		"Squire",
		"Mercenary",
		"Warden",
	)

	var/mob/living/marked_target = null
	var/obj/effect/proc_holder/spell/invoked/track_mark/tracking_spell = null

/obj/effect/proc_holder/spell/invoked/mark_target/Destroy()
	remove_mark()
	return ..()

/obj/effect/proc_holder/spell/invoked/mark_target/cast(list/targets, mob/user)
	var/mob/living/target = targets[1]

	var/datum/component/dreamwalker_mark/mark_component = user.GetComponent(/datum/component/dreamwalker_mark)
	if(!mark_component)
		mark_component = user.AddComponent(/datum/component/dreamwalker_mark)

	// Uncomment below for debugging purposes.
	// if(target == user || ishuman(target))
	// 	to_chat(user, span_warning("You mark [target] for testing purposes!"))
	// 	if(marked_target)
	// 		remove_mark()
	// 	// Apply new mark
	// 	marked_target = target
	// 	tracking_spell = new()
	// 	tracking_spell.marked_target = marked_target
	// 	tracking_spell.parent_spell = src
	// 	user.mind.AddSpell(tracking_spell)
	// 	mark_component.set_marked_target(marked_target)
	// 	return TRUE

	var/list/valid_targets = get_valid_targets(user)
	if(!length(valid_targets))
		to_chat(user, span_warning("没有找到有效目标。"))
		revert_cast()
		return
	target = pick(valid_targets)
	to_chat(user, span_notice("法术正在搜寻一个值得追猎的目标……"))

	// Remove previous mark if it exists
	if(marked_target)
		remove_mark()
	// Apply new mark
	marked_target = target
	tracking_spell = new()
	tracking_spell.marked_target = marked_target
	tracking_spell.parent_spell = src
	user.mind.AddSpell(tracking_spell)
	mark_component.set_marked_target(marked_target)

	if(marked_target != user)
		to_chat(user, span_warning("[user] 在空中划出一道发光符号，将 [marked_target.real_name] 标记下来。"), 
							span_notice("你已将 [marked_target.real_name] 标记为追猎目标。"))

	return TRUE

/obj/effect/proc_holder/spell/invoked/mark_target/proc/get_valid_targets(mob/user)
	var/list/valid_targets = list()
	
	for(var/mob/living/carbon/human/player in GLOB.player_list)
		if(player == user || player.stat == DEAD || !player.mind || !player.client || player == marked_target)
			continue
		if(player.mind.assigned_role in valid_target_roles)
			valid_targets += player
	return valid_targets

/obj/effect/proc_holder/spell/invoked/mark_target/proc/is_valid_target(mob/living/target)
	if(!ishuman(target) || target.stat == DEAD || !target.mind || !target.client)
		return FALSE
	return (target.mind.assigned_role in valid_target_roles)

/obj/effect/proc_holder/spell/invoked/mark_target/proc/remove_mark()
	if(marked_target)
		marked_target = null
	if(tracking_spell && usr && usr.mind)
		usr.mind.RemoveSpell(tracking_spell)
		tracking_spell = null

/obj/effect/proc_holder/spell/invoked/track_mark
	name = "追踪标记者"
	desc = "追踪你的标记目标。你必须先将其放倒，才能抽取金属；贴身施放此法术即可进行抽取。"
	recharge_time = 2 SECONDS
	var/mob/living/marked_target = null
	var/obj/effect/proc_holder/spell/invoked/mark_target/parent_spell = null
	releasedrain = 75
	chargedrain = 1
	chargetime = 0
	overlay_state = "dream_track"
	invocations = list("梦境……找到他们。")
	invocation_type = "whisper"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 1
	associated_skill = /datum/skill/magic/arcane

/obj/effect/proc_holder/spell/invoked/track_mark/cast(list/targets, mob/user)
	if(!marked_target)
		to_chat(user, span_warning("标记已经消散了！"))
		user.mind.RemoveSpell(src)
		return

	var/turf/user_turf = get_turf(user)
	var/turf/target_turf = get_turf(marked_target)

	if(user_turf.z != target_turf.z)
		// Different z-level
		var/z_direction = "未知"
		if(user_turf.z > target_turf.z)
			z_direction = "下方"
		else
			z_direction = "上方"

		to_chat(user, span_notice("目标位于你的 [z_direction] 层。"))
	else
		// Same z-level
		var/distance = get_dist(user, marked_target)
		var/direction = get_dir(user, marked_target)

		if(distance == 0)
			to_chat(user, span_notice("目标就在这里！"))
		else
			var/direction_text = dir2text(direction)
			to_chat(user, span_notice("目标位于你 [direction_text] 方向 [distance] 格之外。"))

	// Check if the target is downed and adjacent
	if(user.Adjacent(marked_target) && !(marked_target.mobility_flags & MOBILITY_STAND) && !marked_target.buckled)
		to_chat(user, span_notice("目标已经脆弱可乘。你开始从其心智中抽取金属……"))

		if(do_after(user, 1 SECONDS, target = marked_target))
			// Small stun to stop our target from messing with the ingot
			marked_target.Stun(10)
			// Create an ingot
			new /obj/item/ingot/sylveric(get_turf(user))
			marked_target.apply_status_effect(/datum/status_effect/debuff/dreamfiend_curse)
			to_chat(user, span_notice("你成功借由目标的心灵具现出了一块诡异金属锭。"))

			// Remove the mark
			if(parent_spell)
				parent_spell.remove_mark()
			user.mind.RemoveSpell(src)
		else
			to_chat(user, span_warning("你被打断了。"))

/obj/effect/proc_holder/spell/invoked/jaunt
	name = "梦行跃迁"
	desc = "短暂引导后将你传送到随机海岸区域，并在原地留下一道临时传送门。别人可能会跟上来。"
	chargedrain = 0
	chargetime = 2 SECONDS
	recharge_time = 15 MINUTES
	invocation_type = "whisper"
	invocations = list("梦境的低语……")
	movement_interrupt = FALSE
	charging_slowdown = 1
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "dream_jaunt"

/obj/effect/proc_holder/spell/invoked/jaunt/cast(list/targets, mob/user)
	var/turf/original_turf = get_turf(user)
	if(!original_turf)
		revert_cast()
		return

	// Find destination area
	var/static/list/possible_areas = list(
		/area/rogue/outdoors/beach,
		/area/rogue/outdoors/beach/north,
		/area/rogue/outdoors/beach/south,
		/area/rogue/outdoors/beach/harbor,
		/area/rogue/outdoors/bograt/sunken,
		/area/rogue/under/cavewet/river,
	)
	var/area/destination_area = GLOB.areas_by_type[pick(possible_areas)]
	if(!destination_area)
		revert_cast()
		return

	// Find safe turfs in destination area
	var/list/safe_turfs = list()
	for(var/turf/T in get_area_turfs(destination_area))
		if(istype(T, /turf/open/water/ocean/deep))
			continue
		if(T.density)
			continue
		var/valid = TRUE
		for(var/atom/movable/AM in T)
			if(AM.density && AM.anchored)
				valid = FALSE
				break
		if(valid)
			safe_turfs += T

	if(!safe_turfs.len)
		revert_cast()
		return

	var/turf/destination = pick(safe_turfs)
	
	// Create portal at origin
	var/obj/structure/portal_jaunt/portal = new(original_turf)
	portal.linked_turf = destination

	// Teleport user
	if(do_teleport(user, destination))
		// Create return portal at destination
		return TRUE

	qdel(portal)
	revert_cast()
	return FALSE

// Summon marked target spell
/obj/effect/proc_holder/spell/invoked/summon_marked
	name = "召来标记者"
	desc = "将你标记的目标召唤到你所在的位置，并在原地留下临时传送门。要求目标至少被标记 10 分钟。"
	chargedrain = 0
	chargetime = 1.5 SECONDS
	recharge_time = 30 SECONDS
	invocation_type = "whisper"
	invocations = list("我呼唤梦境之链，来到我身边！")
	movement_interrupt = FALSE
	charging_slowdown = 1
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "dream_summon"

/obj/effect/proc_holder/spell/invoked/summon_marked/cast(list/targets, mob/user)
	var/datum/component/dreamwalker_mark/mark_component = user.GetComponent(/datum/component/dreamwalker_mark)
	if(!mark_component || !mark_component.marked_target)
		to_chat(user, span_warning("你没有任何可供召唤的已标记目标！"))
		revert_cast()
		return

	// Check if we can summon (10 minutes have passed)
	if(!mark_component.can_summon())
		revert_cast()
		return

	var/mob/living/target = mark_component.marked_target

	if(!target.has_status_effect(/datum/status_effect/dream_mark))
		to_chat(user, span_warning("你与 [target] 之间的联系已经消散！"))
		revert_cast()
		return

	if(target.stat == DEAD)
		to_chat(user, span_warning("[target] 已经死了，无法被召唤！"))
		revert_cast()
		return

	to_chat(target, span_userdanger("你能感觉到梦行者正开始强行召唤你。"))
	if(!do_after(user, 20 SECONDS, FALSE, user))
		to_chat(user, span_warning("你必须站着不动才能召唤你的目标！"))
		// Counts as a finished spellcast to make it impossible to spam your target with messages...
		return TRUE

	var/turf/original_turf = get_turf(target)
	var/turf/destination = get_turf(user)

	if(!original_turf || !destination)
		revert_cast()
		return

	// Create portal at target's original location
	var/obj/structure/portal_jaunt/portal = new(original_turf)
	portal.linked_turf = destination

	// Teleport target
	if(do_teleport(target, destination))
		to_chat(user, span_warning("你将 [target] 召唤到了自己身边！"))
		to_chat(target, span_userdanger("你被粗暴地拖过梦境领域，强行拉到了 [user] 的位置！"))
		// Reset mark after teleport.
		target.remove_status_effect(/datum/status_effect/dream_mark)
		mark_component.marked_target = null
		return TRUE

	qdel(portal)
	revert_cast()
	return FALSE


/obj/effect/proc_holder/spell/invoked/dream_bind
	name = "梦缚"
	desc = "将一件梦境物品绑定到你的灵魂上，使你能随意召唤它。对梦境物品施放可进行绑定，对其他东西施放则会召唤已绑定物品。"
	chargedrain = 0
	chargetime = 0.5 SECONDS
	recharge_time = 10 SECONDS
	invocation_type = "whisper"
	invocations = list("自梦境归于我手……")
	movement_interrupt = FALSE
	charging_slowdown = 0
	associated_skill = /datum/skill/magic/arcane
	var/obj/item/bound_item = null
	overlay_state = "dream_bind"

/obj/effect/proc_holder/spell/invoked/dream_bind/cast(list/targets, mob/user)
	var/atom/target = targets[1]

	// If targeting a dream item, bind it
	if(istype(target, /obj/item))
		var/obj/item/dream_item = target
		if(dream_item.item_flags & DREAM_ITEM)
			bound_item = dream_item
			to_chat(user, span_notice("你将 [bound_item] 绑定到了自己的灵魂上。现在你可以随意召唤它了。"))
			return TRUE

	// If not targeting a dream item, try to summon the bound item
	if(!bound_item)
		to_chat(user, span_warning("你还没有绑定任何梦境物品！"))
		revert_cast()
		return

	if(bound_item.loc == user) // Already in inventory
		to_chat(user, span_notice("[bound_item] 已经在你身上了。"))
		return

	// Check if the item still exists
	if(QDELETED(bound_item))
		to_chat(user, span_warning("你绑定的物品已经被毁掉了！"))
		bound_item = null
		revert_cast()
		return

	// Summon the item to the user's hand
	bound_item.forceMove(get_turf(user))
	user.put_in_hands(bound_item)
	to_chat(user, span_notice("你将 [bound_item] 召唤到了手中。"))
	return TRUE

//Dream meditation
/obj/effect/proc_holder/spell/invoked/dream_trance
	name = "梦境冥思"
	desc = "将梦之能量引入体内，以驱散一切疲惫。"
	chargedrain = 0
	chargetime = 0
	recharge_time = 10 SECONDS
	invocation_type = "whisper"
	invocations = list("嗯……")
	movement_interrupt = TRUE
	charging_slowdown = 0
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "dream_lotus"

/obj/effect/proc_holder/spell/invoked/dream_trance/cast(list/targets, mob/user)
	var/mob/living/carbon/human/H = user

	to_chat(user, span_info("我开始冥想。"))
	while(TRUE)
		if(do_after(H, 15 SECONDS, FALSE, H))
			H.energy_add(0.2 * H.max_energy)
			H.apply_status_effect(/datum/status_effect/buff/healing, 5)
		else
			to_chat(user, span_info("我必须保持静止，才能专注能量并恢复自身。"))
			break
