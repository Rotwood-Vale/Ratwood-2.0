/datum/rmb_intent
	var/name = "意图"
	var/desc = ""
	var/icon_state = ""
	/// Whether the rclick will try to get turfs as target.
	var/prioritize_turfs = FALSE
	/// Whether this intent requires user to be adjacent to their target or not
	var/adjacency = TRUE
	/// Determines whether this intent can be used during click cd
	var/bypasses_click_cd = FALSE

/mob/living/carbon/human/on_cmode()
	if(!cmode)	//We just toggled it off.
		addtimer(CALLBACK(src, PROC_REF(purge_bait)), 30 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		addtimer(CALLBACK(src, PROC_REF(expire_peel)), 60 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	if(!HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
		filtered_balloon_alert(TRAIT_COMBAT_AWARE, (cmode ? ("<i><font color = '#831414'>紧绷</font></i>") : ("<i><font color = '#c7c6c6'>放松</font></i>")), y_offset = 32)

/datum/rmb_intent/proc/special_attack(mob/living/user, atom/target)
	return

/datum/rmb_intent/aimed
	name = "精准"
	desc = "你的攻击会更精确，但恢复时间更长。精准攻击拥有更高的暴击率。\n（战斗模式开启时右键）诱使敌人暴露其瞄准的部位。若与你判断的一致，他们会失去平衡。"
	icon_state = "rmbaimed"

/datum/rmb_intent/aimed/special_attack(mob/living/user, atom/target)
	if(!user)
		return
	if(user.incapacitated())
		return
	if(!ishuman(user))
		return
	if(!ishuman(target))
		return
	if(user == target)
		return

	var/mob/living/carbon/human/HT = target
	var/mob/living/carbon/human/HU = user
	var/target_zone = HT.zone_selected
	var/user_zone = HU.zone_selected
	var/guaranteed_fail = FALSE
	var/special_msg = span_danger("没成功！[HT.p_their(TRUE)]重新站稳了！")

	if(user.has_status_effect(/datum/status_effect/debuff/baitcd))
		return	//We don't do anything if either of us is affected by bait statuses
	if(user_zone == BODY_ZONE_CHEST)
		HU.balloon_alert(HU, "<font color = '#ffffff'>没法诱其露出胸口破绽！</font>") //Don't waste our cooldown
		return

	HU.visible_message(span_danger("[HU]诱使[HT]出招了！"))
	HU.apply_status_effect(/datum/status_effect/debuff/baitcd)

	if(check_zone(target_zone) != check_zone(user_zone) || ((target_zone == BODY_ZONE_CHEST)))
		guaranteed_fail = TRUE

	if(HT.has_status_effect(/datum/status_effect/debuff/baited))
		special_msg = span_warning("太快了！他们已经料到了！")
		guaranteed_fail = TRUE

	if(guaranteed_fail)
		to_chat(HU, special_msg)
		to_chat(HT, span_notice("我骗过了[HU.p_them()]！我重新站稳了！"))
		HU.emote("groan", forced = TRUE)
		HU.stamina_add(HU.max_stamina * 0.2)
		HT.bait_stacks = 0
		HT.apply_status_effect(/datum/status_effect/debuff/baited)
		return

	var/fatiguemod	//The heavier the target's armor, the more fatigue (green bar) we drain.
	var/targetac = HT.highest_ac_worn()
	switch(targetac)
		if(ARMOR_CLASS_NONE)
			fatiguemod = 5
		if(ARMOR_CLASS_LIGHT, ARMOR_CLASS_MEDIUM)
			fatiguemod = 4
		if(ARMOR_CLASS_HEAVY)
			fatiguemod = 3

	HT.apply_status_effect(/datum/status_effect/debuff/baited)
	HT.apply_status_effect(/datum/status_effect/debuff/exposed)
	HT.apply_status_effect(/datum/status_effect/debuff/clickcd, 5 SECONDS)
	HT.bait_stacks++
	if(HT.bait_stacks <= 1)
		HT.Immobilize(0.5 SECONDS)
		HT.stamina_add(HT.max_stamina / fatiguemod)
		HT.Slowdown(3)
		HT.emote("huh", forced = TRUE)
		HU.purge_peel(99)
		HU.changeNext_move(0.1 SECONDS, override = TRUE)
		to_chat(HU, span_notice("[HT.p_they(TRUE)]<b>完全</b>中了我的诱招！再来一次！"))
		to_chat(HT, span_danger("我<b>完全</b>中了[HU.p_their()]的诱招！我快站不稳了！<b>不能再来一次了！</b>"))

	if(HU.has_duelist_ring() && HT.has_duelist_ring() || HT.bait_stacks >= 2)	//We're explicitly (hopefully non-lethally) dueling. Flavor.
		HT.emote("gasp", forced = TRUE)
		HT.OffBalance(4 SECONDS)
		HT.Immobilize(4 SECONDS)
		to_chat(HU, span_notice("[HT.p_they(TRUE)]又一次中招，已经失衡了！就是现在！"))
		to_chat(HT, span_danger("我又<b>完全</b>中了[HU.p_their()]的诱招！我的平衡全没了！</b>"))
		HT.bait_stacks = 0

	if(!HT.pulling)
		return

	HT.stop_pulling()
	to_chat(HU, span_notice("[HT.p_they(TRUE)]中了我的阴招！我挣脱了！"))
	to_chat(HT, span_danger("我中了[HU.p_their()]的阴招！我的擒拿被挣脱了！"))
	HU.OffBalance(2 SECONDS)
	HT.OffBalance(2 SECONDS)
	playsound(user, 'sound/combat/riposte.ogg', 100, TRUE)

/datum/rmb_intent/strong
	name = "强力"
	desc = "你的攻击会获得额外 +1 力量伤害，且无视上限。敌人防御你的攻击时会损失更多锋利度与耐久。凶狠攻击拥有更高暴击率。会故意让手术步骤失败。\n每次命中消耗更多耐力。"
	icon_state = "rmbstrong"
	adjacency = FALSE
	prioritize_turfs = TRUE

/datum/rmb_intent/strong/special_attack(mob/living/user, atom/target)
	if(!user)
		return
	if(user.incapacitated())
		return
	if(!user.mind)
		return
	if(user.has_status_effect(/datum/status_effect/debuff/specialcd))
		return

	var/obj/item/rogueweapon/W = user.get_active_held_item()
	if(istype(W, /obj/item/rogueweapon) && W.special)
		var/skillreq = W.associated_skill
		if(W.special.custom_skill)
			skillreq = W.special.custom_skill
		if(user.get_skill_level(skillreq) < SKILL_LEVEL_JOURNEYMAN)
			to_chat(user, span_info("我对这件武器的技艺还不够熟练，无法这样使用它。"))
			return
		if(W.special.check_range(user, target))
			if(W.special.apply_cost(user))
				W.special.deploy(user, W, target)

/datum/rmb_intent/swift
	name = "迅捷"
	desc = "你的攻击恢复时间更短，但精度更低。"
	icon_state = "rmbswift"

/datum/rmb_intent/special
	name = "特殊"
	desc = "（防御开启时右键）发动一种取决于你当前武器类型的特殊攻击。"
	icon_state = "rmbspecial"

/datum/rmb_intent/feint
	name = "佯攻"
	desc = "（防御开启时右键）一次虚晃而不真正追击的半招，旨在诱使对手露出破绽。对放松且警觉不足的目标更容易失败。"
	icon_state = "rmbfeint"

/datum/rmb_intent/feint/special_attack(mob/living/user, atom/target)
	if(!isliving(target))
		return
	if(!user)
		return
	if(user.incapacitated())
		return
	if(!user.mind)
		return
	if(user.has_status_effect(/datum/status_effect/debuff/feintcd))
		return
	var/mob/living/L = target
	if (L.client && !L.cmode && !L.has_status_effect(/datum/status_effect/buff/clash))
		playsound(user, 'sound/combat/feint.ogg', 100, TRUE)
		user.visible_message(span_danger("[user]试图对[L]使出佯攻，结果却只让自己出了洋相！"))
		user.OffBalance(3 SECONDS)
		user.apply_status_effect(/datum/status_effect/debuff/feintcd)
		for(var/mob/living/carbon/human/H in view(7, user))
			if(H == user || !H.client)
				continue
			if(HAS_TRAIT(H, TRAIT_XYLIX) && !H.has_status_effect(/datum/status_effect/buff/xylix_joy))
				H.apply_status_effect(/datum/status_effect/buff/xylix_joy)
				to_chat(H, span_info("这般短促却傲慢的表演取悦了欢笑之神！"))
		return
	else
		user.visible_message(span_danger("[user]对[target]使出了佯攻！"))
	var/perc = 50
	var/obj/item/I = user.get_active_held_item()
	var/ourskill = 0
	var/theirskill = 0
	var/skill_factor = 0
	if(I)
		if(I.associated_skill)
			ourskill = user.get_skill_level(I.associated_skill)
		if(L.mind)
			I = L.get_active_held_item()
			if(I?.associated_skill)
				theirskill = L.get_skill_level(I.associated_skill)
	perc += (ourskill - theirskill)*15 	//skill is of the essence
	perc += (user.STAINT - L.STAINT)*10	//but it's also mostly a mindgame
	skill_factor = (ourskill - theirskill)/2

	if(L.has_status_effect(/datum/status_effect/debuff/exposed) || L.has_status_effect(/datum/status_effect/debuff/vulnerable))
		perc = 0

	if(L.has_status_effect(/datum/status_effect/buff/clash))
		L.remove_status_effect(/datum/status_effect/buff/clash)
		to_chat(user, span_notice("[L.p_their(TRUE)]的架势被打乱了！"))
		perc = 100

	user.apply_status_effect(/datum/status_effect/debuff/feintcd)
	perc = CLAMP(perc, 0, 90)

	if(!prob(perc)) //feint intent increases the immobilize duration significantly
		playsound(user, 'sound/combat/feint.ogg', 100, TRUE)
		if(user.client?.prefs.showrolls)
			to_chat(user, span_warning("[L.p_they(TRUE)]没有中我的佯攻…… [perc]%"))
		return
	
	var/effect_to_apply = (L.mind ? /datum/status_effect/debuff/vulnerable : /datum/status_effect/debuff/exposed)

	L.apply_status_effect(effect_to_apply, 7 SECONDS)
	L.apply_status_effect(/datum/status_effect/debuff/clickcd, max(1.5 SECONDS + skill_factor, 2.5 SECONDS))
	L.Immobilize(0.5 SECONDS)
	L.stamina_add(L.stamina * 0.1)
	L.Slowdown(2)
	user.changeNext_move(CLICK_CD_FAST)	//We don't want the feint effect to be popped instantly.
	to_chat(user, span_notice("[L.p_they(TRUE)]中了我的佯攻！"))
	to_chat(L, span_danger("我中了[user.p_their()]的佯攻！"))
	playsound(user, 'sound/combat/riposte.ogg', 100, TRUE)


/datum/rmb_intent/riposte
	name = "防御"
	desc = "闪避与招架判定之间没有延迟。\n（未抓取任何东西且手持武器时右键）进入防御姿态，保证挡下下一次命中。\n若双方都在举架状态下互击，武器会发生交锋，可能导致缴械。\n若让其自行结束，或拿它攻击未举架的目标，会令人疲惫。"
	icon_state = "rmbdef"
	adjacency = FALSE
	bypasses_click_cd = TRUE

/datum/rmb_intent/riposte/special_attack(mob/living/user, atom/target)	//Wish we could breakline these somehow.
	if(!user.has_status_effect(/datum/status_effect/buff/clash) && !user.has_status_effect(/datum/status_effect/debuff/clashcd))
		if(!user.get_active_held_item()) //Nothing in our hand to Guard with.
			return
		if(user.r_grab || user.l_grab || length(user.grabbedby)) //Not usable while grabs are in play.
			return
		if(user.IsImmobilized() || user.IsOffBalanced()) //Not usable while we're offbalanced or immobilized
			return
		if(user.m_intent == MOVE_INTENT_RUN)
			to_chat(user, span_warning("我在奔跑时没法专注于此。"))
			return
		if(user.magearmor == FALSE && HAS_TRAIT(user, TRAIT_MAGEARMOR))	//The magearmor is ACTIVE, so we can't Guard. (Yes, it's active while FALSE / 0.)
			to_chat(user, span_warning("我已经在专注维持自己的法师护甲了！"))
			return
		user.apply_status_effect(/datum/status_effect/buff/clash)

/datum/rmb_intent/guard
	name = "警戒"
	desc = "（防御开启时右键）举起武器，准备攻击任何踏入你警戒范围的生物。"
	icon_state = "rmbguard"

/datum/rmb_intent/weak
	name = "收力"
	desc = "你的攻击会减少 1 点力量，并且永远不会暴击。适合长时间惩戒、比斗玩闹与放血。"
	icon_state = "rmbweak"
