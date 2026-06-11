/datum/magic_item/mundane/nomagic
	name = "禁魔"
	description = "其上镶嵌着红色宝石。"

/datum/magic_item/mundane/nomagic/on_equip(obj/item/i, mob/living/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_HANDS)
		return
	else
		ADD_TRAIT(user, TRAIT_SPELLCOCKBLOCK, TRAIT_GENERIC)
		to_chat(user, span_notice("随着我的法力被封锁，我感到一阵被抽离般的空虚……"))


/datum/magic_item/mundane/nomagic/on_drop(obj/item/i, mob/living/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_SPELLCOCKBLOCK, TRAIT_GENERIC)
