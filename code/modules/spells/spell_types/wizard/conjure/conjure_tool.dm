/obj/effect/proc_holder/spell/invoked/conjure_tool
	name = "召具术"
	desc = "在你手中或地上召出一件你所选择的工具。"
	overlay_icon = 'icons/mob/actions/malummiracles.dmi'
	action_icon = 'icons/mob/actions/malummiracles.dmi'
	overlay_state = "conjure_tool"
	sound = list('sound/magic/whiteflame.ogg')

	releasedrain = 60
	chargedrain = 1
	chargetime = 2 SECONDS
	no_early_release = TRUE
	recharge_time = 1 MINUTES

	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = TRUE
	antimagic_allowed = FALSE
	charging_slowdown = 3
	cost = 1
	spell_tier = 1 // Spellblade tier.

	invocations = list("玛勒姆，赐我工具！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_LOW

	var/obj/item/conjured_tool = null

	var/list/tool_options = list(
		"锄头" = /obj/item/rogueweapon/hoe,
		"连枷" = /obj/item/rogueweapon/thresher,
		"镰刀" = /obj/item/rogueweapon/sickle,
		"草叉" = /obj/item/rogueweapon/pitchfork,
		"铁钳" = /obj/item/rogueweapon/tongs,
		"锤子" = /obj/item/rogueweapon/hammer/iron,
		"铲子" = /obj/item/rogueweapon/shovel,
		"鱼竿" = /obj/item/fishingrod,
	)

/obj/effect/proc_holder/spell/invoked/conjure_tool/cast(list/targets, mob/living/user = usr)
	var/tool_choice = input(user, "选择一件工具", "Conjure Tool") as anything in tool_options
	if(!tool_choice)
		return
	tool_choice = tool_options[tool_choice]
	if(src.conjured_tool)
		qdel(src.conjured_tool)
		src.conjured_tool = null

	var/obj/item/R = new tool_choice(user.drop_location())
	R.blade_dulling = DULLING_SHAFT_CONJURED
	R.filters += filter(type = "drop_shadow", x=0, y=0, size=1, offset = 2, color = GLOW_COLOR_ARCANE)
	R.smeltresult = null
	R.salvage_result = null
	R.fiber_salvage = FALSE
	user.put_in_hands(R)
	src.conjured_tool = R
	return TRUE

/obj/effect/proc_holder/spell/invoked/conjure_tool/Destroy()
	if(src.conjured_tool)
		src.visible_message(span_warning("[src] 的边缘开始闪烁消退，随后彻底消失了！"))
		qdel(src.conjured_tool)
		src.conjured_tool = null
	return ..()
