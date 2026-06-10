/obj/effect/proc_holder/spell/invoked/yixinghuanying
	name = "移形换影"
	desc = "与所选活物瞬间互换位置。"
	cost = 3
	xp_gain = TRUE
	releasedrain = 10
	chargedrain = 1
	chargetime = 1 SECONDS
	recharge_time = 10 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	overlay_state = "blink"
	spell_tier = 2
	invocations = list("形影相易，移位于此！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	range = 7
	miracle = FALSE
	sound = 'sound/magic/swap.ogg'

/obj/effect/proc_holder/spell/invoked/yixinghuanying/cast(list/targets, mob/living/user = usr)
	var/atom/target_atom = targets[1]
	if(!isliving(target_atom))
		to_chat(user, span_warning("移形换影只能对活物施放，不能对物品使用。"))
		revert_cast()
		return FALSE

	var/mob/living/target = target_atom
	if(target == user)
		to_chat(user, span_warning("我不能与自己交换位置。"))
		revert_cast()
		return FALSE

	var/turf/target_turf = get_turf(target)
	var/turf/user_turf = get_turf(user)
	if(!target_turf || !user_turf)
		revert_cast()
		return FALSE

	playsound(target_turf, 'sound/magic/swap.ogg', 100, TRUE)
	user.forceMove(target_turf)
	target.forceMove(user_turf)
	user.visible_message(span_warning("[user] 与 [target] 的身影骤然交错，转瞬间互换了位置！"), span_notice("我与 [target] 的位置在一瞬间互换了。"))
	to_chat(target, span_warning("一阵扭曲的奥术之力卷过，我与 [user] 的位置瞬间互换了！"))
	return TRUE
