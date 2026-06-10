/atom/movable/screen/alert/status_effect/buff/group_darkvision
	name = "群体黑暗视觉"
	desc = "我能更清晰地在黑暗中视物。"
	icon_state = "buff"

/datum/status_effect/buff/group_darkvision
	id = "group_darkvision"
	alert_type = /atom/movable/screen/alert/status_effect/buff/group_darkvision
	duration = 30 MINUTES

/datum/status_effect/buff/group_darkvision/on_apply(mob/living/new_owner, assocskill)
	if(assocskill)
		duration += 10 MINUTES * assocskill
	. = ..()
	to_chat(owner, span_warning("更强的黑暗视觉笼罩了我，黑暗变得清晰可辨。"))
	ADD_TRAIT(owner, TRAIT_DARKVISION, MAGIC_TRAIT)

/datum/status_effect/buff/group_darkvision/on_remove()
	. = ..()
	to_chat(owner, span_warning("强化的黑暗视觉消退了，黑暗重新恢复原样。"))
	REMOVE_TRAIT(owner, TRAIT_DARKVISION, MAGIC_TRAIT)

/obj/effect/proc_holder/spell/invoked/group_darkvision
	name = "群体黑暗视觉"
	desc = "强化施法者与周围 1 格内活物的夜视能力，持续时间为黑暗视觉的两倍。"
	overlay_state = "darkvision"
	clothes_req = FALSE
	school = "transmutation"
	releasedrain = 160
	chargedrain = 0
	chargetime = 2 SECONDS
	no_early_release = TRUE
	recharge_time = 3 MINUTES
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	invocations = list("群星之瞳，照彻黑夜。")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 2
	xp_gain = TRUE
	cost = 4

/obj/effect/proc_holder/spell/invoked/group_darkvision/cast(list/targets, mob/user = usr)
	for(var/mob/living/L in range(1, usr))
		L.apply_status_effect(/datum/status_effect/buff/group_darkvision, user.get_skill_level(associated_skill))
	return TRUE

/atom/movable/screen/alert/status_effect/buff/group_fortitude
	name = "群体坚韧术"
	desc = "我的身心机能被群体坚韧术强化了。"
	icon_state = "buff"

/datum/status_effect/buff/group_fortitude
	parent_type = /datum/status_effect/buff/fortitude
	alert_type = /atom/movable/screen/alert/status_effect/buff/group_fortitude
	duration = 3 MINUTES

/atom/movable/screen/alert/status_effect/buff/group_guidance
	name = "群体引导术"
	desc = "奥术之力正引导着我的动作。"
	icon_state = "buff"

/datum/status_effect/buff/group_guidance
	parent_type = /datum/status_effect/buff/guidance
	alert_type = /atom/movable/screen/alert/status_effect/buff/group_guidance
	duration = 3 MINUTES

/atom/movable/screen/alert/status_effect/buff/group_haste
	name = "群体加速术"
	desc = "我正受到群体加速术的强化。"
	icon_state = "buff"

/datum/status_effect/buff/group_haste
	parent_type = /datum/status_effect/buff/haste
	alert_type = /atom/movable/screen/alert/status_effect/buff/group_haste
	duration = 2 MINUTES

/atom/movable/screen/alert/status_effect/buff/group_longstrider
	name = "群体远行者之步"
	desc = "崎岖地形已无法阻碍我的步伐。"
	icon_state = "buff"

/datum/status_effect/buff/group_longstrider
	parent_type = /datum/status_effect/buff/longstrider
	alert_type = /atom/movable/screen/alert/status_effect/buff/group_longstrider
	duration = 30 MINUTES

/atom/movable/screen/alert/status_effect/buff/group_stoneskin
	name = "群体石肤术"
	desc = "我的皮肤如岩石般坚硬。"
	icon_state = "buff"

/datum/status_effect/buff/group_stoneskin
	parent_type = /datum/status_effect/buff/stoneskin
	alert_type = /atom/movable/screen/alert/status_effect/buff/group_stoneskin
	duration = 3 MINUTES

/atom/movable/screen/alert/status_effect/buff/group_giants_strength
	name = "群体巨人之力"
	desc = "我的肌肉被群体巨人之力强化了。"
	icon_state = "buff"

/datum/status_effect/buff/group_giants_strength
	parent_type = /datum/status_effect/buff/giants_strength
	alert_type = /atom/movable/screen/alert/status_effect/buff/group_giants_strength
	duration = 3 MINUTES

/atom/movable/screen/alert/status_effect/buff/group_magic_flight
	name = "群体飞行术"
	desc = "魔法托举着我的身躯，让我得以自由飞行。"
	icon_state = "buff"

/datum/status_effect/buff/group_magic_flight
	parent_type = /datum/status_effect/buff/magic_flight
	alert_type = /atom/movable/screen/alert/status_effect/buff/group_magic_flight
	duration = 120 SECONDS

/obj/effect/proc_holder/spell/invoked/group_enlarge
	name = "群体巨化术"
	desc = "暂时将施法者与周围 1 格内的活物放大成高大魁梧的巨型姿态。"
	cost = 4
	overlay_state = "enlarge"
	releasedrain = 70
	chargedrain = 1
	chargetime = 2 SECONDS
	recharge_time = 4 MINUTES
	human_req = TRUE
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	spell_tier = 2
	invocations = list("众躯膨胀壮大吧！")
	invocation_type = "shout"
	chargedloop = /datum/looping_sound/wind
	associated_skill = /datum/skill/magic/arcane
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	range = 7

/obj/effect/proc_holder/spell/invoked/group_enlarge/cast(list/targets, mob/user = usr)
	var/affected_any = FALSE
	for(var/mob/living/carbon/target in range(1, user))
		if(HAS_TRAIT(target, TRAIT_BIGGUY))
			continue
		ADD_TRAIT(target, TRAIT_BIGGUY, MAGIC_TRAIT)
		ADD_TRAIT(target, TRAIT_DEATHBYSNUSNU, MAGIC_TRAIT)
		target.transform = target.transform.Scale(1.25, 1.25)
		target.transform = target.transform.Translate(0, (0.25 * 16))
		target.update_transform()
		to_chat(target, span_warning("我感觉自己比平时高大得多，简直能直接撞穿一扇门！"))
		target.visible_message("[target]的身体膨胀变大了！")
		addtimer(CALLBACK(src, PROC_REF(remove_enlarge_buff), target), wait = 120 SECONDS)
		affected_any = TRUE

	if(!affected_any)
		to_chat(user, span_warning("周围没有可被群体巨化术影响的目标。"))
		revert_cast()
		return FALSE

	user.visible_message(span_notice("[user] 的法术化作扩散的巨化之力，使周围的身影一同膨胀壮大！"))
	return TRUE

/obj/effect/proc_holder/spell/invoked/group_enlarge/proc/remove_enlarge_buff(mob/living/carbon/target)
	REMOVE_TRAIT(target, TRAIT_BIGGUY, MAGIC_TRAIT)
	REMOVE_TRAIT(target, TRAIT_DEATHBYSNUSNU, MAGIC_TRAIT)
	target.transform = target.transform.Translate(0, -(0.25 * 16))
	target.transform = target.transform.Scale(1/1.25, 1/1.25)
	target.update_transform()
	to_chat(target, span_warning("我突然感觉自己缩小了。"))
	target.visible_message("[target]的身体迅速缩小了！")

/obj/effect/proc_holder/spell/invoked/group_fortitude_spell
	name = "群体坚韧术"
	desc = "强化施法者与周围 1 格内活物的耐力承受能力，持续时间翻倍。"
	cost = 6
	xp_gain = TRUE
	releasedrain = 120
	chargedrain = 1
	chargetime = 2 SECONDS
	recharge_time = 4 MINUTES
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	overlay_state = "fortitude"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 2
	invocations = list("赐吾等坚韧。")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane

/obj/effect/proc_holder/spell/invoked/group_fortitude_spell/cast(list/targets, mob/user = usr)
	playsound(get_turf(user), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)
	user.visible_message("[user]低声念诵咒文，绿色光辉如涟漪般扩散到周围。")
	for(var/mob/living/L in range(1, user))
		L.apply_status_effect(/datum/status_effect/buff/group_fortitude)
	return TRUE

/obj/effect/proc_holder/spell/invoked/group_guidance
	name = "群体引导术"
	desc = "引导施法者与周围 1 格内活物的动作与战斗节奏，持续时间翻倍。"
	overlay_state = "guidance"
	cost = 4
	xp_gain = TRUE
	releasedrain = 120
	chargedrain = 1
	chargetime = 2 SECONDS
	recharge_time = 4 MINUTES
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	spell_tier = 2
	invocations = list("指引吾等吧。")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane

/obj/effect/proc_holder/spell/invoked/group_guidance/cast(list/targets, mob/user = usr)
	playsound(get_turf(user), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)
	user.visible_message("[user]低声念诵咒文，橙色光辉化作薄幕笼罩周围。")
	for(var/mob/living/L in range(1, user))
		L.apply_status_effect(/datum/status_effect/buff/group_guidance)
	return TRUE

/obj/effect/proc_holder/spell/invoked/group_haste
	name = "群体加速术"
	desc = "令施法者与周围 1 格内活物获得魔法加速效果，持续时间翻倍。"
	cost = 8
	xp_gain = TRUE
	releasedrain = 120
	chargedrain = 1
	chargetime = 2 SECONDS
	recharge_time = 4 MINUTES
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	overlay_state = "haste"
	spell_tier = 2
	invocations = list("迅捷加诸吾等！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_MEDIUM
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane

/obj/effect/proc_holder/spell/invoked/group_haste/cast(list/targets, mob/user = usr)
	playsound(get_turf(user), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)
	user.visible_message("[user]高声念诵咒文，黄色光辉瞬间扩散到周围每个人身上。")
	for(var/mob/living/L in range(1, user))
		L.apply_status_effect(/datum/status_effect/buff/group_haste)
	return TRUE

/obj/effect/proc_holder/spell/invoked/group_longstrider
	name = "群体远行者之步"
	desc = "赐予施法者与周围 1 格内活物持续 30 分钟的崎岖地形自由通行能力。"
	cost = 4
	xp_gain = TRUE
	school = "transmutation"
	releasedrain = 100
	chargedrain = 0
	chargetime = 2 SECONDS
	recharge_time = 3 MINUTES
	human_req = TRUE
	warnie = "spellwarning"
	no_early_release = TRUE
	spell_tier = 1
	invocations = list("长步远行，同行无阻。")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	range = 7

/obj/effect/proc_holder/spell/invoked/group_longstrider/cast(list/targets, mob/user = usr)
	user.visible_message("[user] 低声念出咒文，一圈更为清晰的黯淡光晕自其身上扩散开来。")
	for(var/mob/living/L in range(1, user))
		L.apply_status_effect(/datum/status_effect/buff/group_longstrider)
	return TRUE

/obj/effect/proc_holder/spell/invoked/group_stoneskin
	name = "群体石肤术"
	overlay_state = "stoneskin"
	desc = "令施法者与周围 1 格内活物的皮肤如岩石般坚硬，持续时间翻倍。"
	cost = 4
	xp_gain = TRUE
	releasedrain = 120
	chargedrain = 1
	chargetime = 2 SECONDS
	recharge_time = 4 MINUTES
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	spell_tier = 2
	invocations = list("如磐石般屹立，共承其坚。")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	range = 7

/obj/effect/proc_holder/spell/invoked/group_stoneskin/cast(list/targets, mob/user = usr)
	playsound(get_turf(user), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)
	user.visible_message("[user] 低声念诵咒文，周围众人的皮肤随之渐渐硬化。")
	for(var/mob/living/L in range(1, user))
		L.apply_status_effect(/datum/status_effect/buff/group_stoneskin)
	return TRUE

/obj/effect/proc_holder/spell/invoked/group_giants_strength
	name = "群体巨人之力"
	overlay_state = "giantsstrength"
	desc = "强化施法者与周围 1 格内活物。持续时间翻倍。`+3 力量`"
	cost = 8
	xp_gain = TRUE
	releasedrain = 120
	chargedrain = 1
	chargetime = 2 SECONDS
	recharge_time = 4 MINUTES
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	overlay_state = "giants_strength"
	spell_tier = 2
	invocations = list("巨人之力，加诸吾等。")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	range = 7

/obj/effect/proc_holder/spell/invoked/group_giants_strength/cast(list/targets, mob/user = usr)
	playsound(get_turf(user), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)
	user.visible_message("[user] 低声念诵咒文，周围众人的肌肉随之隆起壮大。")
	for(var/mob/living/L in range(1, user))
		L.apply_status_effect(/datum/status_effect/buff/group_giants_strength)
	return TRUE

/obj/effect/proc_holder/spell/invoked/group_leap
	name = "群体腾跃术"
	desc = "强化施法者与周围 1 格内活物的双腿，使其在更长时间内高高跃起。"
	cost = 4
	releasedrain = 70
	chargedrain = 1
	chargetime = 2 SECONDS
	recharge_time = 4 MINUTES
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	gesture_required = TRUE
	spell_tier = 1
	invocations = list("众身齐跃！")
	invocation_type = "whisper"
	hide_charge_effect = TRUE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/wind
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "rune5"
	range = 7

/obj/effect/proc_holder/spell/invoked/group_leap/cast(list/targets, mob/user = usr)
	var/affected_any = FALSE
	for(var/mob/living/carbon/target in range(1, user))
		if(HAS_TRAIT(target, TRAIT_ZJUMP))
			continue
		ADD_TRAIT(target, TRAIT_ZJUMP, MAGIC_TRAIT)
		to_chat(target, span_warning("我的双腿变得更有力了！我感觉自己能一跃而起！"))
		addtimer(CALLBACK(src, PROC_REF(remove_leap_buff), target), wait = 40 SECONDS)
		affected_any = TRUE

	if(!affected_any)
		to_chat(user, span_warning("周围没有可被群体腾跃术影响的目标。"))
		revert_cast()
		return FALSE

	user.visible_message(span_notice("[user] 的法术化作轻盈之风，使周围众人的双腿都充满爆发力。"))
	return TRUE

/obj/effect/proc_holder/spell/invoked/group_leap/proc/remove_leap_buff(mob/living/carbon/target)
	REMOVE_TRAIT(target, TRAIT_ZJUMP, MAGIC_TRAIT)
	to_chat(target, span_warning("我的双腿忽然变得沉重无力。"))
	target.Immobilize(5)

/obj/effect/proc_holder/spell/invoked/group_flight
	name = "群体飞行术"
	desc = "以纯粹魔力托举施法者与周围 1 格内活物，使其在更长时间内自由飞行。"
	cost = 12
	releasedrain = 20
	chargetime = 12 SECONDS
	recharge_time = 4 MINUTES
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	overlay_state = "haste"
	spell_tier = 3
	invocations = list("众人皆可凌空而起！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_MEDIUM
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	gesture_required = TRUE
	range = 7
	miracle = FALSE
	xp_gain = TRUE

/obj/effect/proc_holder/spell/invoked/group_flight/cast(list/targets, mob/living/user = usr)
	playsound(get_turf(user), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)
	user.visible_message(span_notice("[user] 释放出的魔力如无形气流般扩散，将周围众人一并托离地面。"))
	for(var/mob/living/L in range(1, user))
		L.apply_status_effect(/datum/status_effect/buff/group_magic_flight)
		to_chat(L, span_notice("无形魔力在我脚下汇聚，将我托入飞行。"))
	return TRUE
