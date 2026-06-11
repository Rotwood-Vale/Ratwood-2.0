/obj/effect/proc_holder/spell/invoked/darkvision
	name = "黑暗视觉"
	desc = "强化你与周围所有人的夜视能力，持续时间为关联技能每级 5 分钟。"
	overlay_state = "darkvision"
	clothes_req = FALSE
	school = "transmutation"
	releasedrain = 80
	chargedrain = 0
	chargetime = 1 SECONDS
	no_early_release = TRUE
	recharge_time = 1.5 MINUTES
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	invocations = list("黑夜之眼，向我敞开。")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 1
	xp_gain = TRUE
	cost = 2

/obj/effect/proc_holder/spell/invoked/darkvision/miracle
	cost = 0
	spell_tier = 0
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/darkvision/cast(list/targets, mob/user = usr)
	for(var/mob/living/L in range(1, usr))
		L.apply_status_effect(/datum/status_effect/buff/darkvision, user.get_skill_level(associated_skill))
	return TRUE
