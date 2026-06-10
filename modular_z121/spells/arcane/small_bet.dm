/obj/effect/proc_holder/spell/invoked/small_bet
	name = "小赌怡情"
	desc = "让施法者与目标各押上一件手中之物，任由运气决定它们落入谁手。"
	cost = 1
	xp_gain = TRUE
	releasedrain = 10
	chargedrain = 1
	chargetime = 1 SECONDS
	recharge_time = 5 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	spell_tier = 1
	invocations = list("就赌这一手。")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_DISPLACEMENT
	glow_intensity = GLOW_INTENSITY_LOW
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	range = 2
	miracle = FALSE
	gesture_required = TRUE

/obj/effect/proc_holder/spell/invoked/small_bet/cast(list/targets, mob/living/user = usr)
	var/atom/target_atom = targets[1]
	if(!isliving(target_atom))
		to_chat(user, span_warning("小赌怡情只能对活物施放。"))
		revert_cast()
		return FALSE

	var/mob/living/target = target_atom
	if(target == user)
		to_chat(user, span_warning("我不能和自己赌这一手。"))
		revert_cast()
		return FALSE

	var/obj/item/user_item = get_bet_item(user)
	if(!user_item)
		to_chat(user, span_warning("我手上必须拿着一件物品，才能施放小赌怡情。"))
		revert_cast()
		return FALSE

	var/obj/item/target_item = get_bet_item(target)
	if(!target_item)
		to_chat(user, span_warning("[target] 手上没有可拿来下注的物品。"))
		revert_cast()
		return FALSE

	if((user_item.item_flags & ABSTRACT) || (target_item.item_flags & ABSTRACT))
		to_chat(user, span_warning("抽象物品无法参与这场小赌。"))
		revert_cast()
		return FALSE

	var/user_hand = user.get_held_index_of_item(user_item)
	var/target_hand = target.get_held_index_of_item(target_item)
	if(!user_hand || !target_hand)
		revert_cast()
		return FALSE

	var/caster_loses_item = prob(50)
	playsound(get_turf(target), 'sound/magic/swap.ogg', 100, TRUE)
	if(caster_loses_item)
		if(!user.dropItemToGround(user_item, TRUE))
			to_chat(user, span_warning("我手中的赌注仿佛被什么力量卡住了。"))
			revert_cast()
			return FALSE
		if(!target.put_in_hand(user_item, target_hand, TRUE))
			user_item.forceMove(target.drop_location())
		user.visible_message(span_notice("[user] 手中的 [user_item] 被一阵戏法般的赌运卷走，转眼落进了 [target] 手中！"))
		to_chat(user, span_warning("手气不佳，我的 [user_item] 输给了 [target]。"))
		to_chat(target, span_notice("赌运朝我一笑，[user] 手中的 [user_item] 落进了我的手里。"))
		return TRUE

	if(!target.dropItemToGround(target_item, TRUE))
		to_chat(user, span_warning("[target] 手中的赌注仿佛被什么力量卡住了。"))
		revert_cast()
		return FALSE
	if(!user.put_in_hand(target_item, user_hand, TRUE))
		target_item.forceMove(user.drop_location())
	user.visible_message(span_notice("[target] 手中的 [target_item] 被一阵戏法般的赌运卷走，转眼落进了 [user] 手中！"))
	to_chat(user, span_notice("运气站在我这边，[target_item] 落进了我的手里。"))
	to_chat(target, span_warning("赌运一偏，我手中的 [target_item] 转眼落进了 [user] 手中！"))
	return TRUE

/obj/effect/proc_holder/spell/invoked/small_bet/proc/get_bet_item(mob/living/user)
	var/obj/item/active_item = user.get_active_held_item()
	if(active_item)
		return active_item
	return user.get_inactive_held_item()
