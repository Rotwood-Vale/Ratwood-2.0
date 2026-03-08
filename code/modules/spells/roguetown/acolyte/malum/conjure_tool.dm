/obj/effect/proc_holder/spell/invoked/conjure_tool
	name = "Conjure Tool"
	desc = "Conjure a tool of your choice in your hand or on the ground"
	overlay_state = "null"
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
	spell_tier = 1
	miracle = TRUE
	associated_skill = /datum/skill/magic/holy

	// Whatever I don't care for invocation for this one lol
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_LOW

	var/obj/item/conjured_tool = null

	var/list/tool_options = list(
		"Hoe" = /obj/item/weapon/hoe,
		"Thresher" = /obj/item/weapon/thresher,
		"Sickle" = /obj/item/weapon/sickle,
		"Pitchfork" = /obj/item/weapon/pitchfork,
		"Tongs" = /obj/item/weapon/tongs,
		"Hammer" = /obj/item/weapon/hammer/iron,
		"Shovel" = /obj/item/weapon/shovel,
		"Fishing Rod" = /obj/item/fishingrod,
	)

/obj/effect/proc_holder/spell/invoked/conjure_tool/cast(list/targets, mob/living/user = usr)
	var/tool_choice = input(user, "Choose a tool", "Conjure Tool") as anything in tool_options
	if(!tool_choice)
		return
	tool_choice = tool_options[tool_choice]
	if(src.conjured_tool)
		qdel(src.conjured_tool)
		src.conjured_tool = null

	var/obj/item/R = new tool_choice(user.drop_location())
	R.blade_dulling = DULLING_SHAFT_CONJURED
	if(!QDELETED(R))
		R.AddComponent(/datum/component/conjured_item, GLOW_COLOR_ARCANE)
	user.put_in_hands(R)
	src.conjured_tool = R
	return TRUE

/obj/effect/proc_holder/spell/invoked/conjure_tool/Destroy()
	if(src.conjured_tool)
		src.visible_message(span_warning("The [src]'s borders begin to shimmer and fade, before it vanishes entirely!"))
		qdel(src.conjured_tool)
		src.conjured_tool = null
	return ..()
