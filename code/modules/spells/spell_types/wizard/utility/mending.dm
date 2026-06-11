/obj/effect/proc_holder/spell/invoked/mending
	name = "修补术"
	desc = "用奥术能量修补一件物品。修复效果随你的智力而变化。"
	overlay_state = "mending"
	releasedrain = 50
	chargetime = 5
	recharge_time = 20 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	movement_interrupt = FALSE
	no_early_release = FALSE
	chargedloop = null
	sound = 'sound/magic/whiteflame.ogg'
	cost = 2
	spell_tier = 1 // Utility. For repair
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	miracle = FALSE

	invocations = list("裂痕，复原。")
	invocation_type = "shout" //can be none, whisper, emote and shout

	var/repair_percent = 0.20
	var/int_bonus = 0.00

/obj/effect/proc_holder/spell/invoked/mending/cast(list/targets, mob/living/user)
	if(!istype(targets[1], /obj/item))
		to_chat(user, span_warning("这里没有物品！"))
		revert_cast()
		return

	var/obj/item/I = targets[1]

	if(!I.anvilrepair && !I.sewrepair)
		to_chat(user, span_warning("连魔法也无法修补这件物品！"))
		revert_cast()
		return
	if(I.obj_integrity >= I.max_integrity && I.body_parts_covered_dynamic == I.body_parts_covered)
		to_chat(user, span_info("[I]看起来完好无损。"))
		revert_cast()
		return

	user.visible_message(
			span_warning("[user]开始专注于[I]！"),
			span_notice("我开始专注于[I]......")
	)
	if(!do_after(user, 4 SECONDS, TRUE, I, TRUE))
		to_chat(user, span_warning("我的专注被打断了！我没能修好[I]。"))
		revert_cast()
		return

	var/repair_amount = (repair_percent + (user.STAINT * 0.01)) * I.max_integrity

	I.obj_integrity = min(I.obj_integrity + repair_amount, I.max_integrity)
	user.visible_message(span_info("[I]泛起微弱的修补光辉。"))
	playsound(I, 'sound/foley/sewflesh.ogg', 50, TRUE, -2)

	if(I.obj_integrity >= I.max_integrity)
		if(I.obj_broken)
			I.obj_fix()
		if (I.shoddy_repair && user.get_skill_level(/datum/skill/magic/arcane) >= SKILL_LEVEL_JOURNEYMAN)
			I.shoddy_repair = FALSE
			user.visible_message(span_info("[I]柔和发光，奥术魔法正在弥补仓促修补造成的损伤。"))
		if(I.body_parts_covered_dynamic != I.body_parts_covered)
			I.repair_coverage()
			to_chat(user, span_info("[I]破损的层面重新愈合在一起。"))


/obj/effect/proc_holder/spell/invoked/mending/lesser
	name = "次级修补术"
	repair_percent = 0.10
	recharge_time = 30 SECONDS
	cost = 1
