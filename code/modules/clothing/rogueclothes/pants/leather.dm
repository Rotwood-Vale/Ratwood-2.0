
/obj/item/clothing/under/roguetown/trou
	name = "工装裤"
	desc = "劳动者穿着的优质长裤。"
	gender = PLURAL
	icon_state = "trou"
	item_state = "trou"
//	adjustable = CAN_CADJUST
	sewrepair = TRUE
	armor = ARMOR_PADDED_BAD
	prevent_crits = list(BCLASS_CUT)
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	armor_class = ARMOR_CLASS_LIGHT
	salvage_amount = 1
	cold_protection = GROIN | LEG_RIGHT | LEG_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/under/roguetown/trou/leather
	name = "皮裤"
	armor = ARMOR_LEATHER
	icon_state = "leathertrou"
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	max_integrity = ARMOR_INT_LEG_LEATHER
	resistance_flags = FIRE_PROOF
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/under/roguetown/trou/leather/mourning
	name = "悼丧长裤"
	icon_state = "leathertrou"
	color = "#151615"

/obj/item/clothing/under/roguetown/trou/shadowpants
	name = "丝质紧身裤"
	desc = "贴身的腿部衣物，几乎贴得有些过头。"
	icon_state = "shadowpants"
	allowed_race = NON_DWARVEN_RACE_TYPES
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = GROIN | LEG_RIGHT | LEG_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/under/roguetown/trou/beltpants
	name = "多扣皮裤"
	desc = "深色皮裤上点缀着多到不实用的皮带扣。"
	icon_state = "beltpants"
	item_state = "beltpants"

/obj/item/clothing/under/roguetown/trou/apothecary
	name = "药剂师长裤"
	desc = "加了厚垫的长裤，上面沾满了无数草药留下的痕迹。"
	icon_state = "apothpants"
	item_state = "apothpants"

/obj/item/clothing/under/roguetown/trou/artipants
	name = "工匠长裤"
	desc = "厚实的皮裤，旨在保护穿戴者免受火花和飞散齿轮碎片伤害。看这些磨痕，它显然已经用过很多次了。"
	icon_state = "artipants"
	item_state = "artipants"

/obj/item/clothing/under/roguetown/trou/leathertights
	name = "皮质紧身裤"
	desc = "有格调的皮质紧身裤，贴身却不失品味。"
	icon_state = "leathertights"
	item_state = "leathertights"
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/under/roguetown/trou/formal
	name = "礼裤"
	desc = "一条正式场合穿着的长裤。"
	icon = 'icons/roguetown/clothing/pants.dmi'
	icon_state = "butlerpants"
	item_state = "butlerpants"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/pants.dmi'
	detail_tag = "_detail"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_maids.dmi'
	slot_flags = ITEM_SLOT_PANTS
	salvage_result = /obj/item/natural/cloth
	detail_color = CLOTHING_BLACK
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN

/obj/item/clothing/under/roguetown/trou/formal/shorts
	name = "礼装短裤"
	desc = "一条正式短裤，任何精神抖擞的年轻小伙都能穿得很体面。"
	icon = 'icons/roguetown/clothing/pants.dmi'
	icon_state = "butlershorts"
	item_state = "butlershorts"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/pants.dmi'
	slot_flags = ITEM_SLOT_PANTS
	detail_color = CLOTHING_BLACK

/obj/item/clothing/under/roguetown/trou/leather/pontifex
	name = "最高祭司恰克丘尔裤"
	desc = "一条手工缝制的宽松薄皮裤。裤脚在小腿处收紧如袜，而大腿部位则鼓起成宽大的轮廓。"
	icon_state = "monkpants"
	item_state = "monkpants"
	naledicolor = TRUE
	salvage_result = /obj/item/natural/hide/cured
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = GROIN | LEG_RIGHT | LEG_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/under/roguetown/trou/leather/pontifex/zyb
	name = "宽松沙漠裤"
	desc = "一条手工制作的宽松薄皮裤。它能防止沙子灌进靴子，遮挡烈日晒伤双腿，也能避免怪物的尖牙咬穿你的脚踝。"
	naledicolor = FALSE
	color = CLOTHING_DARKDRAB
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = GROIN | LEG_RIGHT | LEG_LEFT
	max_heat_protection_temperature = 600

/obj/item/clothing/under/roguetown/trou/leather/eastern
	icon_state = "eastpants1"
	allowed_race = NON_DWARVEN_RACE_TYPES
