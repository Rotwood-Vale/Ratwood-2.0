/obj/effect/proc_holder/spell/invoked/counterspell
	name = "反制术"
	desc = "短暂抹除目标周身的奥术能量。既能直接阻止其施法，也能让多数法术无法作用于该目标。"
	cost = 3
	releasedrain = 35
	chargedrain = 1
	chargetime = 0
	recharge_time = 80 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/wind
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3 // Full shut down of another mage should be a full mage privilege, imo
	invocations = list("反制，回应！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	overlay_state = "rune2"

#define FILTER_COUNTERSPELL "counterspell_glow"

/obj/effect/proc_holder/spell/invoked/counterspell/cast(list/targets, mob/user = usr)
	if(isliving(targets[1]))
		var/mob/living/carbon/target = targets[1]
		if(HAS_TRAIT(target, TRAIT_COUNTERCOUNTERSPELL))
			to_chat(user, "<span class='warning'>对方立刻反制了我的反制术！这一招对他不会生效！</span>")
			revert_cast()
			return
		ADD_TRAIT(target, TRAIT_SPELLCOCKBLOCK, MAGIC_TRAIT)
		ADD_TRAIT(target, TRAIT_ANTIMAGIC, MAGIC_TRAIT)
		target.add_filter(FILTER_COUNTERSPELL, 2, list("type" = "outline", "color" = "#FFFFFF", "alpha" = 30, "size" = 1))
		to_chat(target, span_warning("我感觉自己与奥术的联系彻底断开了。连空气都仿佛静止了……"))
		target.visible_message("[target] 周身的奥术气息似乎黯淡了下去。")
		addtimer(CALLBACK(src, PROC_REF(remove_buff), target), wait = 20 SECONDS)
		return TRUE
	

/obj/effect/proc_holder/spell/invoked/counterspell/proc/remove_buff(mob/living/carbon/target)
	REMOVE_TRAIT(target, TRAIT_SPELLCOCKBLOCK, MAGIC_TRAIT)
	REMOVE_TRAIT(target, TRAIT_ANTIMAGIC, MAGIC_TRAIT)
	target.remove_filter(FILTER_COUNTERSPELL)
	to_chat(target, span_warning("我感觉奥术的联系再次回到了自己身边。"))
	target.visible_message("[target] 周身的奥术气息又重新浮现。")

#undef FILTER_COUNTERSPELL
