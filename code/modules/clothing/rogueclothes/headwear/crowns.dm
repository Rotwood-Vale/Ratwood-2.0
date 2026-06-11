
/obj/item/clothing/head/roguetown/crown/
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/head/roguetown/crown/fakecrown
	name = "假王冠"
	desc = "你本不该看到这个。"
	icon_state = "serpcrown"

/obj/item/clothing/head/roguetown/crown/surplus
	name = "王冠"
	icon_state = "serpcrowno"
	sellprice = 100
	allowed_race = list(/datum/species/goblinp)
	dropshrink = null

/obj/item/clothing/head/roguetown/crown/byos
	name = "远古王冠"
	desc = "乌嘎 恰卡……"
	color = "#ffe6db"
	icon_state = "serpcrowno"
	sellprice = 100
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	dropshrink = null

/obj/item/clothing/head/roguetown/crown/sparrowcrown
	name = "冠军头环"
	desc = ""
	icon_state = "sparrowcrown"
	//dropshrink = 0
	dynamic_hair_suffix = null
	resistance_flags = FIRE_PROOF | ACID_PROOF
	sellprice = 50

/obj/item/clothing/head/roguetown/nyle
	name = "奈尔宝珠"
	icon_state = "nile"
	body_parts_covered = null
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = null
	sellprice = 100
	resistance_flags = FIRE_PROOF
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/head/roguetown/nyle/consortcrown
	name = "镶宝王冠"
	icon_state = "consortcrown"
	item_state = "consortcrown"
	sellprice = 100

/obj/item/clothing/head/roguetown/circlet
	name = "金色头环"
	icon_state = "circlet"
	item_state = "circlet"
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing
	sellprice = 50

/obj/item/clothing/head/roguetown/circlet/carvedgem
	name = "通用雕刻宝石头环"
	desc = "你本不该看到这个。"
	smeltresult = null
	salvage_result = null

/obj/item/clothing/head/roguetown/circlet/carvedgem/jade
	name = "玉头环"
	desc = "一顶由玉雕成的华美头环。"
	icon_state = "circlet_jade"
	sellprice = 65

/obj/item/clothing/head/roguetown/circlet/carvedgem/amber
	name = "琥珀头环"
	desc = "一顶由琥珀雕成的华美头环。"
	icon_state = "circlet_amber"
	sellprice = 65

/obj/item/clothing/head/roguetown/circlet/carvedgem/shell
	name = "贝壳头环"
	desc = "一顶由贝壳雕成的华美头环。"
	icon_state = "circlet_shell"
	sellprice = 25

/obj/item/clothing/head/roguetown/circlet/carvedgem/rose
	name = "玫瑰石头环"
	desc = "一顶由玫瑰石雕成的华美头环。"
	icon_state = "circlet_rose"
	sellprice = 30

/obj/item/clothing/head/roguetown/circlet/carvedgem/turq
	name = "天青石头环"
	desc = "一顶由天青石雕成的华美头环。"
	icon_state = "circlet_turq"
	sellprice = 90

/obj/item/clothing/head/roguetown/circlet/carvedgem/onyxa
	name = "缟玛瑙头环"
	desc = "一顶由缟玛瑙雕成的华美头环。"
	icon_state = "circlet_onyxa"
	sellprice = 45

/obj/item/clothing/head/roguetown/circlet/carvedgem/coral
	name = "心石头环"
	desc = "一顶由心石雕成的华美头环。"
	icon_state = "circlet_coral"
	sellprice = 75

/obj/item/clothing/head/roguetown/circlet/carvedgem/opal
	name = "欧泊头环"
	desc = "一顶由欧泊雕成的华美头环。"
	icon_state = "circlet_opal"
	sellprice = 95

/obj/item/clothing/head/roguetown/circlet/carvedgem/chitin
	name = "甲壳头环"
	desc = "一顶由甲虫甲壳雕成的华美头环。"
	icon_state = "circlet_shell"
	color = "#7B8C5E"
	sellprice = 20
