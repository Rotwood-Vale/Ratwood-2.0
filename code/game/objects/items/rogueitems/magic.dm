/////////////////////////////////////////Scrying///////////////////

/obj/item/scrying
	name = "占卜球"
	desc = "透过它的玻璃深处，你能窥视许多生灵……"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state ="scrying"
	throw_speed = 3
	throw_range = 7
	throwforce = 15
	damtype = BURN
	force = 15
	hitsound = 'sound/blank.ogg'
	sellprice = 30
	dropshrink = 0.6

	var/mob/current_owner
	var/last_scry
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = 30 SECONDS
	var/extended_cooldown = 10 MINUTES
	var/on_extended_cooldown = FALSE

	var/debugseverity = FALSE
	var/debugprob = 0

/obj/item/scrying/eye
	name = "诅咒之眼"
	desc = "它正在脉动。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state ="scryeye"
	cooldown = 5 MINUTES

/obj/item/scrying/examine(mob/user)
	. = ..()
	if(on_cooldown())
		. += "这颗宝球需要休息……"
	else
		. += "这颗宝球似乎迫不及待想被使用！"

/obj/item/scrying/proc/on_cooldown()
	if (world.time < last_scry + (on_extended_cooldown ? extended_cooldown : cooldown))
		return TRUE
	// No longer on cooldown, so reset the extended cooldown flag if it was set
	on_extended_cooldown = FALSE
	return FALSE

/obj/item/scrying/attack_self(mob/living/user)
	. = ..()
	if(!user.mind)
		return
	var/input = html_decode(input(user, "你在寻找谁？", "占卜球"))
	if(!input)
		return
	if(!user.key)
		return
	if(!user.mind || !user.mind.do_i_know(name=input))
		to_chat(user, span_warning("我不认识这个名字的人。"))
		return
	var/arcane_skill = user.get_skill_level(/datum/skill/magic/arcane)
	if(on_cooldown())
		if (on_extended_cooldown)
			to_chat(user, span_warning("我已经把这颗宝球逼到极限了，这很危险……"))
		else
			to_chat(user, span_warning("这颗宝球似乎还没准备好。也许我该再等等……"))

	var/time_to_use
	if(arcane_skill >= 1)
		time_to_use = 60 / arcane_skill
	else
		time_to_use = 100

	if(!do_after(user, time_to_use, target = user))
		to_chat(user, span_warning("我需要集中精神……"))
		return

	var/success_chance = 0

	var/break_on_fail = FALSE
	var/failure_severity = 6 - arcane_skill

	// Max severity: 6 (no arcane) + 6 (1 intelligence) + 4 (on cooldown) = 16
	// For an Apprentice using the orb, 3-7 would be the realistic results, depending on whether the orb is on cooldown.
	// Max severity with a unique effect: 10

	// Users too unintelligent to read a mage's tome get worse failures,
	// but not worse success chance
	if (user.STAINT < 12)
		failure_severity += max((6 - (user.STAINT/2)), 1)

	var/on_cooldown = world.time < last_scry + cooldown

	if(on_cooldown)
		// Failure severity is increased, and chance of success is reduced by one proficiency level
		// if the orb is on cooldown
		failure_severity += rand(1, 4)
		switch(arcane_skill)
			if(SKILL_LEVEL_NONE)
				break_on_fail = TRUE
				success_chance = 20
			if(SKILL_LEVEL_NOVICE)
				break_on_fail = TRUE
				success_chance = 50
			if(SKILL_LEVEL_APPRENTICE)
				success_chance = 65
			if(SKILL_LEVEL_JOURNEYMAN)
				success_chance = 80
			if(SKILL_LEVEL_EXPERT)
				success_chance = 90
			if(SKILL_LEVEL_MASTER)
				success_chance = 95
			if(SKILL_LEVEL_LEGENDARY)
				success_chance = 100
	// Only a true master of the arcane can reliably use the orb when it's REALLY been pushed
		if (on_extended_cooldown && arcane_skill < SKILL_LEVEL_LEGENDARY)
			success_chance /= 2
	else
		switch(arcane_skill)
			if(SKILL_LEVEL_NONE)
				break_on_fail = TRUE
				success_chance = 50
			if(SKILL_LEVEL_NOVICE)
				break_on_fail = TRUE
				success_chance = 65
			if(SKILL_LEVEL_APPRENTICE) //Apprentices have this
				success_chance = 80
			if(SKILL_LEVEL_JOURNEYMAN) // refugee mages have this
				success_chance = 90
			if(SKILL_LEVEL_EXPERT)
				success_chance = 94
			if(SKILL_LEVEL_MASTER to SKILL_LEVEL_LEGENDARY) // Magus has this
				success_chance = 100

	if (debugseverity)
		success_chance = 0

	var/lucky_prob = user.get_scaled_sq_luck(1, 50)
	if (prob(lucky_prob))
		break_on_fail = FALSE
		failure_severity -= rand(1, 3)

	var/mob/living/carbon/human/target = get_named_mob(input)
	if (target == null)
		return

//You're once more warned and the trait prevents scrying. It also tells you WHO is trying to scry you.
	if(HAS_TRAIT(target, TRAIT_ANTISCRYING))
		to_chat(user, span_warning("我凝视宝球，却见一层无法穿透的迷雾笼罩着[target.real_name]。"))
		to_chat(target, span_warning("我的奥术帷幕发出尖啸警报！我能清楚看见[user.real_name]正凝视着这片迷雾！"))
		return

	if(!prob(success_chance))
		on_failure(user, target, failure_severity)
		if(break_on_fail)
			failure_break(user)
		return

	playsound(src, 'sound/magic/whiteflame.ogg', 100, TRUE)
	scry(user, target)

	to_chat(user, span_warning("我凝视宝球，却找不到[input]。"))
	return

/obj/item/scrying/proc/get_named_mob(mob_real_name)
	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if (HL.real_name == mob_real_name)
			return HL
	return null

/obj/item/scrying/proc/scry_wrong_person(mob/living/carbon/human/user, mob/living/carbon/human/target)
	// We take the mobname so we know NOT to scry them
	var/len = length(GLOB.human_list)
	var/index = rand(1, len)
	var/mob/living/carbon/human/HL = GLOB.human_list[index]

	// If we get the desired target, add a random value to the index
	// Taking an upper limit of (len-1) should mean that we never roll the desired mob again
	if (HL.real_name == target.real_name)
		index = (index + rand(1, len-1)) % len
		HL = GLOB.human_list[index]

	scry(user, HL)

/obj/item/scrying/proc/scry(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/turf/T = get_turf(target)
	if(!T)
		return
	message_admins("SCRYING: [user.real_name] ([user.ckey]) has used the scrying orb to leer at [target.real_name] ([target.ckey])")
	log_game("SCRYING: [user.real_name] ([user.ckey]) has used the scrying orb to leer at [target.real_name] ([target.ckey])")
	var/mob/dead/observer/screye/S = user.scry_ghost()
	if(!S)
		return
	S.ManualFollow(target)
	last_scry = world.time
	user.visible_message(span_danger("[user]凝视着[src]，[user.p_their()]的双眼翻入脑后。"))
	addtimer(CALLBACK(S, TYPE_PROC_REF(/mob/dead/observer, reenter_corpse)), 8 SECONDS)
	if(!target.stat)
		if(target.STAPER >= 15)
			if(target.mind)
				if(target.mind.do_i_know(name=user.real_name))
					to_chat(target, span_warning("我能清楚看见[user.real_name]的脸正在盯着我！"))
					return
				to_chat(target, span_warning("我能清楚看见一个陌生[user.gender == FEMALE ? "女人" : "男人"]的脸正在盯着我！"))
				return

		if(target.STAPER >= 11)
			to_chat(target, span_warning("我感觉有一双陌生的眼睛正落在我身上。"))
	return

/obj/item/scrying/proc/failure_break(mob/living/user)
	visible_message("[src]炸裂开来！")
	user.flash_fullscreen("redflash1")
	new /obj/item/magic/obsidian(get_turf(src))
	playsound(src, "shatter", 70, TRUE)
	qdel(src)

/obj/item/scrying/proc/on_failure(mob/living/user, mob/living/carbon/human/target, severity)
	var/chance = rand(0, 99) // (chance < n) has n% probability, but we only need to calculate once here

	if (debugseverity)
		severity = debugseverity
		chance = debugprob

	if (on_cooldown())
		extended_cooldown = TRUE
		last_scry = world.time

	switch (severity)
		if (0)
			to_chat(user, span_boldwarning("你将思绪集中在宝球上，但它毫无回应。"))
		if (1)
			if (chance < 40)
				failure_random_person(user, target)
			else if (chance < 70)
				failure_burn(user)
			else
				failure_confused(user)
		if (2)
			if (chance < 20)
				failure_confused(user)
			else if (chance < 80)
				failure_sleep(user)
			else
				failure_drunk(user)
		if (3)
			if (chance < 20)
				failure_sleep(user)
			else if (chance < 80)
				failure_drunk(user)
			else
				failure_high(user)
		if (4)
			if (chance < 20)
				failure_drunk(user)
			else if (chance < 80)
				failure_high(user)
			else
				failure_dimwitted(user)
		if (5)
			if (chance < 10)
				failure_drunk(user)
			else if (chance < 20)
				failure_high(user)
			else
				failure_dimwitted(user)

		// Past this point, the effects of failure can be especially nasty.
		if (6)
			if (chance < 10)
				failure_paralysis(user)
			else
				failure_blind(user)
		if (7)
			if (chance < 10)
				failure_obsession(user)
			else if (chance < 30)
				failure_languageloss(user, target)
			else
				failure_paralysis(user)
		if (8)
			if (chance < 15)
				failure_paralysis(user)
			if (chance < 35)
				failure_obsession(user, target)
			else
				failure_languageloss(user)
		if (9)
			failure_obsession(user, target)
		if (10 to INFINITY)
			failure_feeblemind(user)

/obj/item/scrying/proc/failure_languageloss(mob/living/user)
	to_chat(user, span_boldwarning("你将思绪集中在宝球上，可就在此时，你感觉自己对语言的掌控正在悄然流失……"))
	user.apply_status_effect(/datum/status_effect/debuff/mishap_langloss)

/obj/item/scrying/proc/failure_obsession(mob/living/user, mob/living/target)
	user.visible_message(span_danger("[user]凝视着[src]，[user.p_their()]的双眼翻入脑后。[user.p_they(TRUE)]像看见了什么圣物般微笑起来……"), span_boldwarning("你将思绪集中在宝球上，你看见目标就站在眼前。如此美丽，如此动人……你发现自己已坠入爱恋，坠入痴迷。你还在浪费什么时间？你迫切地需要对方……"))
	if(user.mind)
		user.mind.store_memory("你对[target]已然痴迷。")
	user.faction |= "[REF(target)]"
	user.apply_status_effect(STATUS_EFFECT_INLOVE, target)
	scry(user, target) // Got to see them to fall in love with them...

/obj/item/scrying/proc/failure_feeblemind(mob/living/user)
	user.visible_message(span_danger("[user]凝视着[src]，[user.p_their()]眼中的神采逐渐散去，[user.p_their()]的嘴也无力地张开……"), span_boldwarning("你将思绪集中在宝球上，却感觉它们正一点点流失……流失……缓缓被抽离……流向……"))
	user.apply_status_effect(/datum/status_effect/debuff/mishap_feeblemind)

/obj/item/scrying/proc/failure_paralysis(mob/living/user)
	user.visible_message(span_danger("[user]凝视着[src]。[user.p_their()]身体的某些部位似乎突然失去了力气……"), span_boldwarning("你将思绪集中在宝球上，一阵剧痛猛地穿过头颅，随后诡异的麻木感开始蔓延……"))
	user.apply_status_effect(/datum/status_effect/debuff/mishap_arcane_paralysis)

/obj/item/scrying/proc/failure_blind(mob/living/user)
	user.visible_message(span_danger("[user]凝视着[src]。奥术的黑暗似乎蒙上了[user.p_their()]的双眼！"), span_boldwarning("你将思绪集中在宝球上，视野渐渐暗去……而且再也没有恢复。"))
	user.apply_status_effect(/datum/status_effect/debuff/mishap_blindness)

/obj/item/scrying/proc/failure_dimwitted(mob/living/user)
	user.visible_message(span_danger("[user]凝视着[src]……随后[user.p_their()]的眼神变得呆滞无神。"), span_boldwarning("你将思绪集中在宝球上，虽然什么都没看见，可整个世界却突然变得无比简单。"))
	user.apply_status_effect(/datum/status_effect/debuff/mishap_dimwitted)

/obj/item/scrying/proc/failure_high(mob/living/user)
	user.visible_message(span_danger("[user]凝视着[src]。突然间，[user.p_they()]似乎怎么也安静不下来！"), span_boldwarning("你将思绪集中在宝球上，随后一种过分欢快而轻飘飘的感觉涌上心头！"))
	user.apply_status_effect(/datum/status_effect/debuff/mishap_arcane_high)

/obj/item/scrying/proc/failure_random_person(mob/living/user, mob/living/target)
	user.visible_message(span_danger("[user]凝视着[src]，[user.p_their()]的双眼翻入脑后。"), span_boldwarning("你将思绪集中在宝球上，然后……等等，这不对劲……"))
	scry_wrong_person(user, target)

/obj/item/scrying/proc/failure_sleep(mob/living/user)
	user.visible_message(span_danger("[user]凝视着[src]，接着毫无预兆地睡着了！"), span_boldwarning("你将思绪集中在宝球上，随后只觉得困倦，愈发困倦；也许你该……该……"))
	user.apply_status_effect(/datum/status_effect/debuff/mishap_sleepy)

/obj/item/scrying/proc/failure_confused(mob/living/user)
	user.visible_message(span_danger("[user]凝视着[src]……随后茫然地环顾四周。"), span_boldwarning("你将思绪集中在宝球上，突然间一阵强烈的迷乱袭来，仿佛整个世界都失去了意义。"))
	user.apply_status_effect(/datum/status_effect/debuff/mishap_confused)

/obj/item/scrying/proc/failure_drunk(mob/living/user)
	user.visible_message(span_danger("[user]凝视着[src]，然后猛地打了个嗝。"), span_boldwarning("你将思绪集中在宝球上，世界开始旋转，哦，天啊，你是不是喝多了？哈哈！"))
	user.apply_status_effect(/datum/status_effect/debuff/mishap_arcane_drunkenness)

/obj/item/scrying/proc/failure_burn(mob/living/user)
	user.visible_message(span_danger("[user]凝视着[src]……可宝球突然泛起红光，你还听见了滋滋作响的声音！"), span_boldwarning("你将思绪集中在宝球上，它却不断升温，直到烫得令人难以忍受！"))
	var/obj/item = user.get_item_for_held_index(1)
	if (item == src)
		user.apply_damage(25, BURN, user.get_bodypart(BODY_ZONE_L_ARM))
	else
		user.apply_damage(25, BURN, user.get_bodypart(BODY_ZONE_R_ARM))
	user.flash_fullscreen("redflash1")
	user.emote("scream")

/////////////////////////////////////////Crystal ball ghsot vision///////////////////

/obj/item/crystalball/attack_self(mob/user)
	user.visible_message(span_danger("[user]凝视着[src]，[user.p_their()]双眼翻入脑后。"))
	user.ghostize(1)



/*============
Necra's Censer
============*/
/*
- Cleans in an area around the person after
	a do_after call, infinite uses. Should aid
	the morticians with cleaning the town.
*/

/obj/item/necra_censer
	name = "Necra 的香炉"
	desc = "一只小巧的青铜香炉，会不断吐出异界般的雾气。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state ="necra_censer"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	item_state = "necra_censer"
	w_class = WEIGHT_CLASS_SMALL
	grid_height = 32
	grid_width = 64
	throw_speed = 3
	throw_range = 7
	throwforce = 4
	//hitsound = 'sound/blank.ogg'
	sellprice = 10 // Shouldn't be worth a lot in world
	dropshrink = 0.6

/obj/item/necra_censer/attack_self(mob/user)
	if(do_after(user, 3 SECONDS))
		playsound(user.loc, 'sound/items/censer_use.ogg', 100)
		user.visible_message(span_info("[user.name]抬起手臂，轻轻摇动着[name]上的链条。"))
		var/datum/effect_system/smoke_spread/smoke/necra_censer/S = new
		S.set_up(2, user.loc)
		S.start()
