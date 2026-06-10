/obj/effect/proc_holder/spell/invoked/xylix_laughter
	name = "赛利克斯笑术"
	desc = "以戏谑的奥术冲击目标心神，迫使其进行意志检定。失败者将失声狂笑并狼狈倒地。"
	cost = 3
	xp_gain = TRUE
	releasedrain = 20
	chargedrain = 1
	chargetime = 1 SECONDS
	recharge_time = 20 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	school = "illusion"
	spell_tier = 2
	invocations = list("欢笑，吞没其心！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_DISPLACEMENT
	glow_intensity = GLOW_INTENSITY_LOW
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	range = 7
	miracle = FALSE
	gesture_required = TRUE

/obj/effect/proc_holder/spell/invoked/xylix_laughter/cast(list/targets, mob/living/user = usr)
	var/atom/target_atom = targets[1]
	if(!isliving(target_atom))
		revert_cast()
		return FALSE

	var/mob/living/target = target_atom
	if(target == user)
		to_chat(user, span_warning("我没法把自己逗到失控大笑。"))
		revert_cast()
		return FALSE

	if(target.anti_magic_check())
		target.visible_message(span_warning("[target] 周身的反魔法波纹震散了那股滑稽而危险的咒力！"))
		to_chat(user, span_warning("[target] 身上的反魔法抵消了 Xylix狂笑术。"))
		playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
		revert_cast()
		return FALSE

	var/fail_chance = get_failure_chance(user, target)
	if(prob(fail_chance))
		target.Knockdown(3 SECONDS)
		target.visible_message(span_warning("[target] 突然像被什么荒诞笑话击中了心神，仰头狂笑着摔倒在地！"))
		to_chat(target, span_userdanger("荒谬的笑意猛然撕开我的理智，我控制不住地狂笑着倒了下去！"))
		to_chat(user, span_notice("[target] 没能撑住这场荒诞的心灵冲击。"))
		trigger_laugh_sequence(target)
		return TRUE

	target.visible_message(span_notice("[target] 肩膀一抖，勉强忍住了那股突如其来的狂乱笑意，只剩一声短促窃笑。"))
	to_chat(target, span_notice("一阵荒诞的笑意掠过我的脑海，但我还是稳住了心神。"))
	to_chat(user, span_warning("[target] 顶住了 Xylix 的戏谑，只是短促地笑了一声。"))
	target.emote("giggle", intentional = TRUE)
	return TRUE

/obj/effect/proc_holder/spell/invoked/xylix_laughter/proc/get_failure_chance(mob/living/user, mob/living/target)
	var/caster_power = user.STAINT + user.get_skill_level(/datum/skill/magic/arcane) * 2
	var/target_will = target.STAWIL
	if(target.cmode)
		target_will += 1
	return CLAMP(50 + ((caster_power - target_will) * 10), 15, 85)

/obj/effect/proc_holder/spell/invoked/xylix_laughter/proc/trigger_laugh_sequence(mob/living/target)
	if(QDELETED(target))
		return
	target.emote("laugh", intentional = TRUE)
	addtimer(CALLBACK(src, PROC_REF(do_laugh), target), 1 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(do_laugh), target), 2 SECONDS)

/obj/effect/proc_holder/spell/invoked/xylix_laughter/proc/do_laugh(mob/living/target)
	if(QDELETED(target))
		return
	target.emote("laugh", intentional = TRUE)
