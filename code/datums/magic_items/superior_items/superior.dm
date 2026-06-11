///T2 Enchantments
/datum/magic_item/superior/nightvision
	name = "夜视"
	description = "其上刻有 Noc 之眼的印记。"
	var/active_item = FALSE

/datum/magic_item/superior/nightvision/on_equip(obj/item/i, mob/living/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_HANDS)
		return
	if(active_item)
		return
	else
		ADD_TRAIT(user, TRAIT_DARKVISION, "[type]")
		active_item = TRUE
		to_chat(user, span_notice("我能看得清楚多了！"))


/datum/magic_item/superior/nightvision/on_drop(obj/item/i, mob/living/user)
	if(active_item)
		REMOVE_TRAIT(user, TRAIT_DARKVISION, "[type]")
		active_item = FALSE
		to_chat(user, span_notice("我又恢复平凡了。"))

/datum/magic_item/superior/unbreaking
	name = "坚不可摧"
	description = "它感觉像黑钢一样坚固。"

/datum/magic_item/superior/unbreaking/on_apply(obj/item/i)
	.=..()
	i.max_integrity += 100
	i.obj_integrity += 100

/datum/magic_item/superior/featherstep
	name = "羽步"
	description = "它轻得像一根羽毛。"
	var/active_item = FALSE

/datum/magic_item/superior/featherstep/on_equip(obj/item/i, mob/living/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_HANDS)
		return
	if(active_item)
		return
	else
		active_item = TRUE
		ADD_TRAIT(user, TRAIT_LIGHT_STEP, "[type]")
		user.change_stat(STATKEY_SPD, 1)
		to_chat(user, span_notice("我感觉自己敏捷多了！"))


/datum/magic_item/superior/featherstep/on_drop(obj/item/i, mob/living/user)
	if(active_item)
		active_item = FALSE
		REMOVE_TRAIT(user, TRAIT_LIGHT_STEP, "[type]")
		user.change_stat(STATKEY_SPD, -1)
		to_chat(user, span_notice("我又恢复平凡了。"))

/datum/magic_item/superior/fireresist
	name = "抗火"
	description = "它似乎正在吸收热量！"
	var/active_item = FALSE

/datum/magic_item/superior/fireresist/on_equip(obj/item/i, mob/living/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_HANDS)
		return
	if(active_item)
		return
	else
		active_item = TRUE
		ADD_TRAIT(user, TRAIT_NOFIRE, "[type]")
		to_chat(user, span_notice("我感觉自己更耐火了！"))

/datum/magic_item/superior/fireresist/on_drop(obj/item/i, mob/living/user)
	if(active_item)
		active_item = FALSE
		REMOVE_TRAIT(user, TRAIT_NOFIRE, "[type]")
		to_chat(user, span_notice("我又恢复平凡了。"))

/datum/magic_item/superior/climbing
	name = "蛛行"
	description = "它的末端竖着如细毛般的纤丝。"
	var/active_item = FALSE
	var/masterclimber = FALSE
	var/legendaryclimber = FALSE

/datum/magic_item/superior/climbing/on_equip(obj/item/i, mob/living/user, slot)
	. = ..()
	if(user.get_skill_level(/datum/skill/misc/climbing)== 6)
		to_chat(user, span_notice("我的技艺太高，已经用不上这个了。"))
		return
	if(slot == ITEM_SLOT_HANDS)
		return
	if(active_item)
		return
	else
		active_item = TRUE
		if(user.get_skill_level(/datum/skill/misc/climbing)== 5)
			masterclimber = TRUE
			user.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		else
			user.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		to_chat(user, span_notice("我感觉自己几乎像蜘蛛一样灵巧！"))

/datum/magic_item/superior/climbing/on_drop(obj/item/i, mob/living/user)
	. = ..()
	if(active_item)
		active_item = FALSE
		if(masterclimber)
			user.adjust_skillrank(/datum/skill/misc/climbing, -1, TRUE)
		else
			user.adjust_skillrank(/datum/skill/misc/climbing, -2, TRUE)
		to_chat(user, span_notice("我又恢复平凡了。"))

/datum/magic_item/superior/thievery
	name = "快手"
	description = "它看起来像是恰好合手。"
	var/active_item = FALSE
	var/masterstealer = FALSE
	var/legendstealer = FALSE
	var/legendlockpick = FALSE

/datum/magic_item/superior/thievery/on_equip(obj/item/i, mob/living/user, slot)
	. = ..()
	if((user.get_skill_level(/datum/skill/misc/stealing)== 6) && (user.get_skill_level(/datum/skill/misc/lockpicking)== 6))
		to_chat(user, span_notice("我的技艺太高，已经用不上这个了。"))
		return
	if(slot == ITEM_SLOT_HANDS)
		return
	if(active_item)
		return
	else
		active_item = TRUE
		if (user.get_skill_level(/datum/skill/misc/stealing) == 6)
			legendstealer = TRUE
			masterstealer = FALSE
		if (user.get_skill_level(/datum/skill/misc/stealing)== 5)
			user.adjust_skillrank(/datum/skill/misc/stealing, 1, TRUE)
			masterstealer = TRUE
		else
			user.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)

		if (user.get_skill_level(/datum/skill/misc/lockpicking)== 6)
			legendlockpick = TRUE
		else
			user.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)

		to_chat(user, span_notice("我感觉自己更灵巧了！"))

/datum/magic_item/superior/thievery/on_drop(obj/item/i, mob/living/user)
	. = ..()
	if(active_item)
		active_item = FALSE
		if (!legendstealer)
			if (masterstealer)
				user.adjust_skillrank(/datum/skill/misc/stealing, -1, TRUE)
			else
				user.adjust_skillrank(/datum/skill/misc/stealing, -2, TRUE)
		if(!legendlockpick)
			user.adjust_skillrank(/datum/skill/misc/lockpicking, -1, TRUE)
		to_chat(user, span_notice("我又恢复平凡了。"))

/datum/magic_item/superior/trekk
	name = "长途健行"
	description = "它看起来能帮助人在崎岖地形中穿行。"
	var/active_item = FALSE

/datum/magic_item/superior/trekk/on_equip(obj/item/i, mob/living/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_HANDS)
		return
	if(active_item)
		return
	else
		active_item = TRUE
		ADD_TRAIT(user, TRAIT_LONGSTRIDER, "[type]")
		to_chat(user, span_notice("我感觉自己能轻松穿过崎岖地面了！"))

/datum/magic_item/superior/trekk/on_drop(obj/item/i, mob/living/user)
	if(active_item)
		active_item = FALSE
		REMOVE_TRAIT(user, TRAIT_LONGSTRIDER, "[type]")
		to_chat(user, span_notice("我又恢复平凡了。"))

/datum/magic_item/superior/smithing
	name = "锻造"
	description = "它带着炉火般的温热。"

/datum/magic_item/superior/smithing/on_apply(obj/item/i)
	.=..()
	var/obj/item/rogueweapon/hammer/hammer = i
	hammer.quality = hammer.quality *2
