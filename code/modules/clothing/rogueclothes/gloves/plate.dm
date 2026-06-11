/obj/item/clothing/gloves/roguetown/plate
	name = "板甲护手"
	desc = "以钢材制成的板甲护手。为双手提供全面而可靠的防护。"
	icon_state = "gauntlets"
	armor = ARMOR_PLATE
	prevent_crits = list(BCLASS_CHOP, BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	resistance_flags = FIRE_PROOF
	blocksound = PLATEHIT
	max_integrity = ARMOR_INT_SIDE_STEEL
	blade_dulling = DULLING_BASH
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	sewrepair = FALSE
	grid_width = 64
	grid_height = 32
	unarmed_bonus = 1.2

/obj/item/clothing/gloves/roguetown/plate/iron
	name = "铁制板甲护手"
	desc = "以铁材制成的板甲护手。为双手提供全面而可靠的防护，但比钢制款稍微没那么耐用。"
	icon_state = "igauntlets"
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_SIDE_IRON

/obj/item/clothing/gloves/roguetown/plate/ancient
	name = "远古板甲护手"
	desc = "抛光的吉尔布兰兹机件精密相连，包覆张开的双手。'怜悯'与'纯真'不过是愚昧者高举的辞藻; 无须愧疚地洒下他们的血吧，好让世界得以照她的形象重铸。"
	icon_state = "agauntlets"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/gloves/roguetown/plate/ancient/decrepit
	name = "破败板甲护手"
	desc = "磨损的青铜机件拼成手部外壳。笨重得难以稳稳搭弓，僵硬得难以舒适握剑; 若把拳头再攥紧些，分节边缘就会割进血肉。"
	icon_state = "agauntlets"
	max_integrity = ARMOR_INT_SIDE_DECREPIT
	color = "#bb9696"
	anvilrepair = null

/obj/item/clothing/gloves/roguetown/plate/graggar
	name = "凶暴护手"
	desc = "承载着这个世界原动力, 暴力的板甲护手。"
	max_integrity = ARMOR_INT_SIDE_ANTAG
	armor = ARMOR_ASCENDANT
	icon_state = "graggarplategloves"

/obj/item/clothing/gloves/roguetown/plate/graggar/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "ARMOR", "RENDERED ASUNDER")

/obj/item/clothing/gloves/roguetown/plate/matthios
	name = "镀金护手"
	desc = "多少人曾把性命贱卖，"
	icon_state = "matthiosgloves"
	max_integrity = ARMOR_INT_SIDE_ANTAG
	armor = ARMOR_ASCENDANT

/obj/item/clothing/gloves/roguetown/plate/matthios/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/gloves/roguetown/plate/matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)


/obj/item/clothing/gloves/roguetown/plate/zizo
	name = "阿凡泰因护手"
	desc = "阿凡泰因板甲护手。自应被知晓之界的边缘之外呼唤而来。以她之名。"
	icon_state = "zizogauntlets"
	max_integrity = ARMOR_INT_SIDE_ANTAG
	armor = ARMOR_ASCENDANT

/obj/item/clothing/gloves/roguetown/plate/zizo/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/gloves/roguetown/plate/zizo/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/gloves/roguetown/plate/shadowgauntlets
	name = "暗板护手"
	desc = "手指镀金并塑造成利爪形态的护手。可惜尖端都太钝，伤不了人。"
	icon_state = "shadowgauntlets"
	allowed_race = NON_DWARVEN_RACE_TYPES
	body_parts_covered = HANDS|ARMS //For "heavy" drow merc

/obj/item/clothing/gloves/roguetown/plate/kote
	name = "贾正纳护手"
	desc = "一套强化过的卡曾贡式护手。穿着它几乎只能战斗，但也不至于完全妨碍行动。"
	icon_state = "kazengungauntlets"
	item_state = "kazengungauntlets"
	body_parts_covered = HANDS|ARMS
	detail_tag = "_detail"
	color = "#FFFFFF"
	detail_color = "#FFFFFF"
	var/picked = FALSE

/obj/item/clothing/gloves/roguetown/plate/kote/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "选择颜色。", "制服配色") as anything in GLOB.colorlist
		var/playerchoice = GLOB.colorlist[choice]
		picked = TRUE
		detail_color = playerchoice
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_armor()
			H.update_icon()

/obj/item/clothing/gloves/roguetown/plate/kote/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)
