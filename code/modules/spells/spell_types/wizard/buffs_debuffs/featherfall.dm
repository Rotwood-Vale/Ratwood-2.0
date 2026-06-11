/obj/effect/proc_holder/spell/invoked/featherfall
	name = "羽落术"
	desc = "赋予你自己和邻近生物一些抵御坠落伤害的能力。"
	cost = 2
	xp_gain = TRUE
	school = "transmutation"
	releasedrain = 50
	chargedrain = 0
	chargetime = 1 SECONDS
	recharge_time = 2 MINUTES
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = TRUE
	spell_tier = 1 // Not directly combat useful
	invocations = list("如羽般轻坠。")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "jump"

/obj/effect/proc_holder/spell/invoked/featherfall/cast(list/targets, mob/user = usr)

	user.visible_message("[user]低声念诵咒文，一道昏暗的光脉从其身上扩散开来。")

	for(var/mob/living/L in range(1, usr))
		L.apply_status_effect(/datum/status_effect/buff/featherfall)

	return TRUE
