#define ENCHANT_DURATION 15 MINUTES
#define ENCHANT_DURATION_GOLD 200 MINUTES

/obj/effect/proc_holder/spell/invoked/enchant_weapon
	name = "武器附魔"
	desc = "为你手中或地上的一件武器施加附魔，并替换其原有附魔。 \n\
	附魔会持续 15 分钟，若武器被奥术使用者持有，还会自动续时。\n\
	若施法者手中握有一块金矿，它会被消耗，以将附魔延长为近乎永久的 200 分钟。\n\
	已附魔武器无法再次附魔。\n\
	力刃：使武器威力提高 5。\n\
	坚固：使武器当前耐久与耐久上限提高 100。"
	overlay_state = "enchant_weapon"
	sound = list('sound/magic/whiteflame.ogg')

	releasedrain = 30
	chargedrain = 2
	chargetime = 3 SECONDS // Can be used mid combat if needed.
	no_early_release = TRUE
	recharge_time = 1 MINUTES 

	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	antimagic_allowed = FALSE

	charging_slowdown = 3
	cost = 2 // Slightly discounted as it is mostly buff.
	spell_tier = 2 // Spellblade tier.

	invocations = list("兵刃，受我祝铭！") // Enchant Weapon(s)
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_LOW

/obj/effect/proc_holder/spell/invoked/enchant_weapon/cast(list/targets, mob/user = usr)
	var/target = targets[1]
	var/obj/item/sacrifice

	var/list/enchant_types = list(
		"力刃" = FORCE_BLADE_ENCHANT,
		"坚固" = DURABILITY_ENCHANT
	)

	for(var/obj/item/I in user.held_items)
		if(istype(I, /obj/item/rogueore/gold))
			sacrifice = I

	if(istype(target, /obj/item/rogueweapon))
		var/obj/item/I = target
		var/enchant_type = input(user, "选择你要施加的附魔类型：", "武器附魔") as anything in enchant_types
		if(!enchant_type)
			return
		enchant_type = enchant_types[enchant_type]
		var/enchant_duration = sacrifice ? ENCHANT_DURATION_GOLD : ENCHANT_DURATION
		if(sacrifice)
			qdel(sacrifice)
			to_chat(user, "我消耗了 [sacrifice]，令 [I] 获得了近乎永久的附魔。")
		if(I.GetComponent(/datum/component/enchanted_weapon))
			qdel(I.GetComponent(/datum/component/enchanted_weapon))
		var/refresh_skill = user.get_skill_level(/datum/skill/magic/arcane) ? /datum/skill/magic/arcane : /datum/skill/magic/holy
		I.AddComponent(/datum/component/enchanted_weapon, enchant_duration, TRUE, refresh_skill, enchant_type)
		user.visible_message("[user] 为 [I] 施下附魔，令其笼罩在一层魔法光辉之中。")
		return TRUE
	else
		to_chat(user, span_warning("这不是可供附魔的有效目标！我必须对一件武器施法。"))
		revert_cast()
		return FALSE
		
#undef ENCHANT_DURATION
