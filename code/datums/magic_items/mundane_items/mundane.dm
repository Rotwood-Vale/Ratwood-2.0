//T1 Enchantments
/datum/magic_item/mundane/woodcut
	name = "伐木"
	description = "它如树木般坚实。"
	var/last_used

/datum/magic_item/mundane/woodcut/on_hit_structure(obj/item/i, obj/target, mob/living/user)
	if(istype(target, /obj/structure/flora))
		var/obj/structure/flora/tree = target
		tree.obj_integrity -= 100
	. = ..()

/datum/magic_item/mundane/mining
	name = "采矿"
	description = "它表面覆着岩层。"
	var/active_item = FALSE
	var/max_skill = FALSE

/datum/magic_item/mundane/mining/on_hit_structure(obj/item/i, turf/target, mob/living/user)
	if(istype(target, /obj/item/natural/rock))
		var/obj/item/natural/rock/rocktarget = target
		rocktarget.obj_integrity -= 500 //smashs through boulders with ease
	. = ..()

/datum/magic_item/mundane/mining/on_equip(obj/item/i, mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	if(slot == ITEM_SLOT_HANDS)
		user.change_stat(STATKEY_WIL, 1)
		if(user.get_skill_level(/datum/skill/labor/mining)== 6)
			max_skill = TRUE //they are max level, so we skip giving them skills
		else
			user.adjust_skillrank(/datum/skill/labor/mining, 1, TRUE)
		to_chat(user, span_notice("我感觉已经准备好去采矿了！"))
		active_item = TRUE
	else
		return

/datum/magic_item/mundane/mining/on_drop(obj/item/i, mob/living/user)
	. = ..()
	if(active_item)
		active_item = FALSE
		if (!max_skill)
			user.adjust_skillrank(/datum/skill/labor/mining, -1, TRUE) //stripping them a level since they weren't max
		user.change_stat(STATKEY_WIL, -1)
		to_chat(user, span_notice("我又恢复平凡了。"))

/datum/magic_item/mundane/xylix
	name = "Xylix 的恩赐"
	description = "它仿佛隐约散发着笑声。"
	var/active_item = FALSE

/datum/magic_item/mundane/xylix/on_equip(obj/item/i, mob/living/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_HANDS)
		return
	if(active_item)
		return
	else
		user.STALUC += 1
		to_chat(user, span_notice("我感觉自己相当走运。"))
		active_item = TRUE

/datum/magic_item/mundane/xylix/on_drop(obj/item/i, mob/living/user)
	if(active_item)
		active_item = FALSE
		user.STALUC -= 1
		to_chat(user, span_notice("我又恢复平凡了。"))

/datum/magic_item/mundane/unyieldinglight
	name = "不屈之光"
	description = "它散发着明亮的光芒。"
	var/active = FALSE

/datum/magic_item/mundane/unyieldinglight/on_use(obj/item/i, mob/living/user)
	if(!active)
		active = TRUE

		i.light_color = "#3FBAFD"
		to_chat(user, span_notice("我轻握 [i]，它突然绽放出耀眼光芒。"))
		i.set_light(TRUE)
		i.light_outer_range = 6
	. = ..()

/datum/magic_item/mundane/holding
	name = "收纳"
	description = "它里面似乎比外面更大。"

/datum/magic_item/mundane/holding/on_apply(obj/item/i)
	.=..()
	var/obj/item/storage = i
	var/datum/component/storage/STR = storage.GetComponent(/datum/component/storage)
	if(STR.max_w_class == WEIGHT_CLASS_SMALL)
		STR.max_w_class++
	STR.screen_max_columns = STR.screen_max_columns + 2

/datum/magic_item/mundane/revealing
	name = "显露"
	description = "它的光亮得刺眼。"
	var/active = FALSE

/datum/magic_item/mundane/revealing/on_apply(obj/item/i)
	.=..()
	var/obj/item/flashlight/flare/light = i
	light.light_outer_range = light.light_outer_range * 3
