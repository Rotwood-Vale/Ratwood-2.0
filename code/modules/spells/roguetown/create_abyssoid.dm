/obj/effect/proc_holder/spell/self/create_abyssoid
	name = "造化渊蛭"
	desc = "以自身鲜血将一只水蛭转化为渊蛭。"
	overlay_state = "bloodsteal"
	chargedrain = 0
	chargetime = 0
	range = -1
	movement_interrupt = TRUE
	invocation_type = "none"
	miracle = FALSE
	devotion_cost = 0

/obj/effect/proc_holder/spell/self/create_abyssoid/cast(mob/living/user)
	var/obj/item/natural/worms/leech/target
	var/list/hand_items = list(user.get_active_held_item(), user.get_inactive_held_item())

	for(var/obj/item/natural/worms/leech/leech in hand_items)
		target = leech
		break

	if(!target)
		to_chat(user, span_warning("你必须手持一只水蛭，才能进行转化！"))
		return FALSE

	if(istype(target, /obj/item/natural/worms/leech/abyssoid))
		to_chat(user, span_warning("这只水蛭已经受过 Abyssor 的赐福，化作渊蛭了！"))
		return FALSE

	if(user.blood_volume < BLOOD_VOLUME_BAD)
		to_chat(user, span_warning("你没有足够的鲜血可以献祭！"))
		return FALSE

	user.visible_message(span_warning("[user] 对着 [target] 开始低声诵念古怪祷词……"), \
						span_notice("我开始进行转化仪式，向 Abyssor 献上自己的鲜血。"))

	if(!do_after(user, 10 SECONDS, target = user))
		to_chat(user, span_warning("仪式被打断了！"))
		return FALSE

	if(!(target in hand_items))
		to_chat(user, span_warning("仪式期间你必须一直握着那只水蛭！"))
		return FALSE

	if(user.blood_volume < BLOOD_VOLUME_BAD)
		to_chat(user, span_warning("你没有足够的鲜血完成仪式！"))
		return FALSE

	user.blood_volume = max(user.blood_volume - 70, 0)
	var/obj/item/natural/worms/leech/abyssoid/new_leech = new(user.drop_location())
	qdel(target)
	user.put_in_hands(new_leech)

	user.visible_message(span_warning("[user] 完成了仪式，水蛭随之发生蜕变！"), \
						span_red("这只水蛭化作了一只神圣的渊蛭！"))
	SEND_SIGNAL(user, COMSIG_ABYSSOID_CREATED)

	return TRUE
