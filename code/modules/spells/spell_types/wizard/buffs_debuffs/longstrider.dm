/obj/effect/proc_holder/spell/invoked/longstrider
	name = "远行者之步"
	desc = "赐予自己和相邻生物持续 15 分钟的崎岖地形自由通行能力。"
	cost = 2
	xp_gain = TRUE
	school = "transmutation"
	releasedrain = 50
	chargedrain = 0
	chargetime = 1 SECONDS
	recharge_time = 1.5 MINUTES
	human_req = TRUE
	warnie = "spellwarning"
	no_early_release = TRUE
	spell_tier = 1 // Not direct combat useful but still good, replicated by polearm
	invocations = list("长步远行。")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	range = 7

/obj/effect/proc_holder/spell/invoked/longstrider/cast(list/targets, mob/user = usr)

	user.visible_message("[user] 低声念出咒文，一圈黯淡光晕自其身上扩散开来。")

	for(var/mob/living/L in range(1, usr))
		L.apply_status_effect(/datum/status_effect/buff/longstrider)

	return TRUE
