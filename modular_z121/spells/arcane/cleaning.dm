// modular_z121 自定义奥术法术：清洁术（Cleaning Spell）
// 仅在 modular_z121 内实现，复用主线的清洁辅助函数，不改动主线清洁系统。
// 背景：一位足不出户的法师在被自家垃圾活埋之前，捣鼓出的居家小法术。

/obj/effect/proc_holder/spell/invoked/cleaning
	name = "清洁术"
	desc = "一位濒临被垃圾活埋的宅居法师所创的居家法术，能净除法术范围内的一切污秽。"
	cost = 1
	xp_gain = TRUE
	releasedrain = 1
	chargedrain = 0
	chargetime = 0			// 即时施法，无需蓄力。
	recharge_time = 1 SECONDS	// 冷却 1 秒。
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	spell_tier = 1
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "cleaning"
	invocations = list("泡泡清洁!")	// 咒文（喊出）。
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	no_early_release = TRUE
	movement_interrupt = FALSE
	associated_skill = /datum/skill/magic/arcane
	range = 7		// 施法者可选定的目标地块距离。
	miracle = FALSE
	gesture_required = TRUE
	// 以选定地块为中心的清洁半径。半径 1 即选定地块加其周围一圈（共 3x3 = 9 格）。
	var/clean_radius = 1

/obj/effect/proc_holder/spell/invoked/cleaning/cast(list/targets, mob/living/user = usr)
	// 把施法者选定的目标解析为清洁区域的中心地块（无论点到的是地块、物件还是生物都取其所在地块）。
	var/atom/target_atom = targets[1]
	var/turf/center = get_turf(target_atom)
	if(!center)
		to_chat(user, span_warning("这里没有可供清洁的落点。"))
		revert_cast()
		return FALSE

	// 先统计区域内可清洁的污物（血迹、呕吐物、泥污等可清除残迹）数量，用于事后反馈，
	// 同时判断这一片是否本就干净，从而避免白白消耗法力。
	var/filth_count = 0
	for(var/turf/spot in range(clean_radius, center))
		for(var/obj/effect/decal/cleanable/filth in spot)
			filth_count++

	if(!filth_count)
		// 区域内一尘不染，没有需要清理的污物，撤销施法以退还消耗。
		to_chat(user, span_warning("这片地方本就干净，没有需要清理的污物。"))
		revert_cast()
		return FALSE

	// 逐格清洁：wash_turf 会向地块发送清洁信号并删除其上的可清洁残迹。
	for(var/turf/spot in range(clean_radius, center))
		wash_turf(spot, CLEAN_MEDIUM)

	playsound(center, pick('sound/foley/waterwash (1).ogg', 'sound/foley/waterwash (2).ogg'), 60, TRUE)
	user.visible_message(span_notice("[user] 念出咒文，一阵晶莹的肥皂泡涌起，将四周的污秽涤荡一空！"))
	to_chat(user, span_notice("我唤出一片清洁的泡沫，洗净了这片区域里的 [filth_count] 处污物。"))
	return TRUE
