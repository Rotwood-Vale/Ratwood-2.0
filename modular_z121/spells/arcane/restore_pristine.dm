// modular_z121 自定义奥术法术：恢复如初
// 仅在 modular_z121 内实现，不改动主线法术逻辑。

/obj/effect/proc_holder/spell/invoked/restore_pristine
	name = "恢复如初"
	desc = "通过精湛的魔法技艺让物品或建筑受到的损伤像是时光倒流一般恢复。"
	cost = 4
	xp_gain = TRUE
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	recharge_time = 5 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	spell_tier = 2
	overlay_state = "mending"
	invocations = list("恢复如初！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	no_early_release = TRUE
	movement_interrupt = FALSE
	associated_skill = /datum/skill/magic/arcane
	range = 7
	miracle = FALSE
	gesture_required = TRUE

/obj/effect/proc_holder/spell/invoked/restore_pristine/cast(list/targets, mob/living/user = usr)
	var/atom/target_atom = targets[1]
	if(!isobj(target_atom) || isliving(target_atom))
		to_chat(user, span_warning("恢复如初只能对物品或建筑施放。"))
		revert_cast()
		return FALSE

	var/obj/target_obj = target_atom
	var/arcane_level = max(user.get_skill_level(/datum/skill/magic/arcane), 0)
	if(arcane_level <= 0)
		to_chat(user, span_warning("我对这道回溯魔法的理解还远远不够。"))
		revert_cast()
		return FALSE
	if(!can_restore_target(target_obj, arcane_level))
		to_chat(user, span_warning("[target_obj] 眼下没有任何可供回溯的损伤。"))
		revert_cast()
		return FALSE

	var/restored_any = FALSE
	var/restore_ratio = get_restore_ratio(arcane_level)

	// 奥术 5 级及以上会先把被磨损的最大值回溯到初始值，再直接补满当前值。
	if(arcane_level >= 5)
		restored_any |= restore_maximums(target_obj)
		restored_any |= restore_integrity(target_obj, null, user)
		if(isitem(target_obj))
			var/obj/item/target_item = target_obj
			restored_any |= restore_blade(target_item, null, user)
	else
		restored_any |= restore_integrity(target_obj, restore_ratio, user)
		if(isitem(target_obj))
			var/obj/item/target_item = target_obj
			restored_any |= restore_blade(target_item, restore_ratio, user)

	if(!restored_any)
		to_chat(user, span_warning("[target_obj] 上没有可被恢复如初扭转的损伤。"))
		revert_cast()
		return FALSE

	playsound(get_turf(target_obj), 'sound/magic/whiteflame.ogg', 80, TRUE)
	user.visible_message(span_notice("[user] 朝着 [target_obj] 念出古老咒言，丝丝裂痕与磨损竟像倒流的时光一般自行愈合。"))
	to_chat(user, span_notice("我将 [target_obj] 受到的损伤逆转回更完好的状态。"))
	return TRUE

/obj/effect/proc_holder/spell/invoked/restore_pristine/proc/can_restore_target(obj/target_obj, arcane_level)
	var/initial_max_integrity = initial(target_obj.max_integrity)
	if(target_obj.max_integrity)
		if(target_obj.obj_integrity < target_obj.max_integrity)
			return TRUE
	if(arcane_level >= 5 && initial_max_integrity > target_obj.max_integrity)
		return TRUE
	if(isitem(target_obj))
		var/obj/item/target_item = target_obj
		var/initial_max_blade = initial(target_item.max_blade_int)
		if(target_item.max_blade_int)
			if(target_item.blade_int < target_item.max_blade_int)
				return TRUE
		if(arcane_level >= 5 && initial_max_blade > target_item.max_blade_int)
			return TRUE
	return FALSE

/obj/effect/proc_holder/spell/invoked/restore_pristine/proc/get_restore_ratio(arcane_level)
	if(arcane_level == 1)
		return 0.10
	if(arcane_level == 2)
		return 0.20
	if(arcane_level == 3)
		return 0.40
	if(arcane_level == 4)
		return 0.80
	if(arcane_level >= 5)
		return 1
	return 0

/obj/effect/proc_holder/spell/invoked/restore_pristine/proc/restore_maximums(obj/target_obj)
	var/restored_any = FALSE
	var/initial_max_integrity = initial(target_obj.max_integrity)
	if(initial_max_integrity > target_obj.max_integrity)
		target_obj.max_integrity = initial_max_integrity
		restored_any = TRUE

	if(isitem(target_obj))
		var/obj/item/target_item = target_obj
		var/initial_max_blade = initial(target_item.max_blade_int)
		if(initial_max_blade > target_item.max_blade_int)
			target_item.max_blade_int = initial_max_blade
			restored_any = TRUE

	return restored_any

/obj/effect/proc_holder/spell/invoked/restore_pristine/proc/restore_integrity(obj/target_obj, restore_ratio, mob/living/user)
	if(!target_obj.max_integrity)
		return FALSE

	var/old_integrity = target_obj.obj_integrity
	if(isnull(restore_ratio))
		target_obj.obj_integrity = target_obj.max_integrity
	else
		if(restore_ratio <= 0)
			return FALSE
		var/repair_amount = max(1, round(target_obj.max_integrity * restore_ratio))
		target_obj.obj_integrity = min(target_obj.obj_integrity + repair_amount, target_obj.max_integrity)

	if(target_obj.obj_integrity <= old_integrity)
		return FALSE

	if(target_obj.obj_broken)
		var/fix_threshold = target_obj.integrity_failure ? (target_obj.integrity_failure * target_obj.max_integrity) : 1
		if(target_obj.obj_integrity > fix_threshold)
			target_obj.obj_fix(user, FALSE)

	if(target_obj.obj_integrity >= target_obj.max_integrity)
		target_obj.obj_fix(user)
		if(isitem(target_obj))
			var/obj/item/target_item = target_obj
			if(target_item.shoddy_repair)
				target_item.shoddy_repair = FALSE
			if(target_item.body_parts_covered_dynamic != target_item.body_parts_covered)
				target_item.repair_coverage()
	else if(isitem(target_obj))
		var/obj/item/target_item = target_obj
		target_item.update_damaged_state()

	return TRUE

/obj/effect/proc_holder/spell/invoked/restore_pristine/proc/restore_blade(obj/item/target_item, restore_ratio, mob/living/user)
	if(!target_item.max_blade_int)
		return FALSE

	var/old_blade_int = target_item.blade_int
	if(isnull(restore_ratio))
		target_item.blade_int = target_item.max_blade_int
	else
		if(restore_ratio <= 0)
			return FALSE
		// 这里不走 add_bintegrity()，避免被 TRAIT_SHARPER_BLADES 额外放大恢复量。
		var/blade_amount = max(1, round(target_item.max_blade_int * restore_ratio))
		var/old_ratio = target_item.blade_int / target_item.max_blade_int
		target_item.blade_int = min(target_item.blade_int + blade_amount, target_item.max_blade_int)
		var/new_ratio = target_item.blade_int / target_item.max_blade_int

		if(user)
			if(old_ratio < SHARPNESS_TIER2_THRESHOLD && new_ratio > SHARPNESS_TIER2_THRESHOLD)
				to_chat(user, span_info("<b>崩口</b>被磨平了。刃口恢复了些许平整。"))
			if(old_ratio < SHARPNESS_TIER1_THRESHOLD && new_ratio > SHARPNESS_TIER1_THRESHOLD)
				to_chat(user, span_info("<b>缺口</b>消失了。刃口如今又恢复到了往日的锋利。"))

	return target_item.blade_int > old_blade_int
