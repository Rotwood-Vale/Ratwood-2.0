#define ENCHANT_DURATION 15 MINUTES
#define ENCHANT_DURATION_WILDERNESS 200 MINUTES

/obj/effect/proc_holder/spell/invoked/fittedclothing
	name = "量体裁衣"
	desc = "将布甲或皮甲裁改得更贴合穿戴者，使其在一段时间内更耐用。\n\
	你还可以把荒野精华渗入材料中，以延长这一效果。\n\ "
	releasedrain = 50
	chargedrain = 0
	chargetime = 0
	recharge_time = 30 SECONDS
	antimagic_allowed = TRUE

/obj/effect/proc_holder/spell/invoked/fittedclothing/cast(list/targets, mob/user = usr)
	var/target = targets[1]
	var/obj/item/sacrifice

	//var/list/enchant_types = list("Durability" = DURABILITY_ENCHANT)

	for(var/obj/item/I in user.held_items)
		if(istype(I, /obj/item/natural/cured/essence))
			sacrifice = I

	if(istype(target, /obj/item/clothing/))
		var/obj/item/clothing/suit/roguetown/armor/clothingenchant = target
		if((!(clothingenchant.sewrepair)||isnull(clothingenchant.sewrepair) || !(clothingenchant.armor_class == ARMOR_CLASS_LIGHT)))
			to_chat(user, span_warning("我只能调整轻甲部件。"))
			return
		var/enchant_type = DURABILITY_ENCHANT
		var/enchant_duration = sacrifice ? ENCHANT_DURATION_WILDERNESS : ENCHANT_DURATION
		if(sacrifice)
			qdel(sacrifice)
			to_chat(user, "我消耗了[sacrifice]，以近乎永久地强化[clothingenchant]。")
		playsound(loc, 'sound/foley/sewflesh.ogg', 100, TRUE, -2)
		if(clothingenchant.GetComponent(/datum/component/fit_clothing))
			qdel(clothingenchant.GetComponent(/datum/component/fit_clothing))
		clothingenchant.AddComponent(/datum/component/fit_clothing, enchant_duration, TRUE, /datum/skill/magic/arcane, enchant_type)
		user.visible_message("[user] 调整了[clothingenchant]，让它更贴合穿戴者了。")
		return TRUE
	else
		to_chat(user, span_warning("我只能调整轻甲部件。"))
		revert_cast()
		return FALSE
		
#undef ENCHANT_DURATION
