// modular_z121 自定义奥术法术：清水如泉
// 仅在 modular_z121 内实现，不改动主线液体系统。

/obj/effect/proc_holder/spell/invoked/clearwater_spring
	name = "清水如泉"
	desc = "唤出清水的法术，简直是沙漠中的救命法术！"
	cost = 1
	xp_gain = TRUE
	releasedrain = 1
	chargedrain = 0
	chargetime = 0
	recharge_time = 1 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	spell_tier = 1
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "clearwater_spring"
	invocations = list("清水如泉！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	no_early_release = TRUE
	movement_interrupt = FALSE
	associated_skill = /datum/skill/magic/arcane
	range = 1
	miracle = FALSE
	gesture_required = TRUE

/obj/effect/proc_holder/spell/invoked/clearwater_spring/cast(list/targets, mob/living/user = usr)
	var/atom/target_atom = targets[1]
	if(!isobj(target_atom) || isliving(target_atom))
		to_chat(user, span_warning("清水如泉只能对能够盛水的容器施放。"))
		revert_cast()
		return FALSE

	var/obj/target_obj = target_atom
	if(!can_fill_with_water(target_obj))
		to_chat(user, span_warning("[target_obj] 并不是可灌装液体的容器。"))
		revert_cast()
		return FALSE
	if(target_obj.reagents.total_volume > 0)
		// 只允许对空容器施法，避免与已有液体发生混合或反应后失去“安全清水”的效果。
		to_chat(user, span_warning("[target_obj] 里已经有液体了，清水如泉只能对空容器施放。"))
		revert_cast()
		return FALSE

	var/remaining_volume = target_obj.reagents.maximum_volume - target_obj.reagents.total_volume
	if(remaining_volume <= 0)
		to_chat(user, span_warning("[target_obj] 已经装满了。"))
		revert_cast()
		return FALSE

	// 空容器会被直接注满为可安全饮用的清水。
	target_obj.reagents.add_reagent(/datum/reagent/water, remaining_volume)
	playsound(get_turf(target_obj), 'sound/magic/whiteflame.ogg', 60, TRUE)
	user.visible_message(span_notice("[user] 指尖一点，[target_obj] 中顿时涌出澄澈清水，仿佛凭空冒出一眼泉。"))
	to_chat(user, span_notice("我将 [target_obj] 中剩余的空间尽数注满了可安全饮用的清水。"))
	return TRUE

/obj/effect/proc_holder/spell/invoked/clearwater_spring/proc/can_fill_with_water(obj/target_obj)
	if(!target_obj.reagents)
		return FALSE
	if(!target_obj.is_refillable())
		return FALSE
	return TRUE
