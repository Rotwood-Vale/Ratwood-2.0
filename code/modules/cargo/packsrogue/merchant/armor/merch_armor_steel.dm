// Steel Armor
// Iron Ingot is 20 each.
// Each Steel Ingot is 35 each, 40 minimum price.
// Cured Leather is 5 each.
// For Steel Armor, we applies a base 1.25x multiplier AFTER ingot price to account for labor.
// Then round up to nearest 5.

/datum/supply_pack/rogue/armor_steel
	group = "Armor (Steel)"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

// Steel Armor Section. Massive selection here so I am not going to include everything
/datum/supply_pack/rogue/armor_steel/haubergeon_steel
	name = "锁子短甲"
	cost = 50 // 1 Ingots
	contains = list(/obj/item/clothing/suit/roguetown/armor/chainmail)

/datum/supply_pack/rogue/armor_steel/hauberk_steel
	name = "锁子甲"
	cost = 90 // 2 Ingots
	contains = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk)

/datum/supply_pack/rogue/armor_steel/halfplate
	name = "半身板甲"
	cost = 130 // 3 Ingots, 1 Cured Leather
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate)

/datum/supply_pack/rogue/armor_steel/halfplate_fluted
	name = "半身板甲（凹槽）"
	cost = 155 // 3 Ingots, 1 Iron, 1 Cured Leather
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/fluted)

/datum/supply_pack/rogue/armor_steel/fullplate
	name = "全身板甲"
	cost = 350 // 4 Steel, 1 Cured Leather - x2 cuz it is the best armor
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/full)

/datum/supply_pack/rogue/armor_steel/fullplate_fluted
	name = "全身板甲（凹槽）"
	cost = 380 // 4 Steel, 1 Iron, 1 Cured Leather - x2 cuz it is the best armor
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/full/fluted)

/datum/supply_pack/rogue/armor_steel/coatplates
	name = "镶板外衣"
	cost = 95 // 2 Steel
	contains = list(/obj/item/clothing/suit/roguetown/armor/brigandine/coatplates)

/datum/supply_pack/rogue/armor_steel/cuirass_steel
	name = "胸铠"
	cost = 90 // 2 Steel
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/half)

/datum/supply_pack/rogue/armor_steel/scalemail
	name = "鳞甲"
	cost = 90 // 2 Steel
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/scale)

/datum/supply_pack/rogue/armor_steel/brigandine
	name = "板甲衣"
	cost = 100 // 2 Steel, 2 Cloth
	contains = list(/obj/item/clothing/suit/roguetown/armor/brigandine)

/datum/supply_pack/rogue/armor_steel/brigandine_light
	name = "轻型板甲衣"
	cost = 55 //1 Steel, 1 Leather
	contains = list(/obj/item/clothing/suit/roguetown/armor/brigandine/light)

/datum/supply_pack/rogue/armor_steel/chaincoif_steel
	name = "锁子头巾"
	cost = 50 // 1 Steel
	contains = list(/obj/item/clothing/neck/roguetown/chaincoif)

/datum/supply_pack/rogue/armor_steel/chainmantle
	name = "锁链披肩"
	cost = 50 // 1 Steel
	contains = list(/obj/item/clothing/neck/roguetown/chaincoif/chainmantle)

/datum/supply_pack/rogue/armor_steel/chaingloves_steel
	name = "锁链手甲"
	cost = 50 // 1 Steel
	contains = list(/obj/item/clothing/gloves/roguetown/chain)

/datum/supply_pack/rogue/armor_steel/plategloves
	name = "板手甲"
	cost = 50 // 1 Steel
	contains = list(/obj/item/clothing/gloves/roguetown/plate)

/datum/supply_pack/rogue/armor_steel/chausses_brigandine
	name = "板甲衣腿甲"
	cost = 60 //1 Steel, 2 Leather
	contains = list(/obj/item/clothing/under/roguetown/splintlegs)

/datum/supply_pack/rogue/armor_steel/chainleg_steel
	name = "锁链腿甲"
	cost = 50 // 1 Steel
	contains = list(/obj/item/clothing/under/roguetown/chainlegs)

/datum/supply_pack/rogue/armor_steel/platelegs
	name = "板腿甲"
	cost = 90 // 2 Steel
	contains = list(/obj/item/clothing/under/roguetown/platelegs)
	
/datum/supply_pack/rogue/armor_steel/chainkilt
	name = "锁裙"
	cost = 50 // 1 Steel
	contains = list(/obj/item/clothing/under/roguetown/chainlegs/kilt)

/datum/supply_pack/rogue/armor_steel/rearbraces
	name = "板甲衣臂甲"
	cost = 55 // 1 Steel, 1 Leather
	contains = list(/obj/item/clothing/wrists/roguetown/splintarms)

/datum/supply_pack/rogue/armor_steel/bracers_plate
	name = "板臂甲"
	cost = 50 // 1 Steel
	contains = list(/obj/item/clothing/wrists/roguetown/bracers)

/datum/supply_pack/rogue/armor_steel/helmet_nasal
	name = "头盔，鼻护款"
	cost = 50 // 1 Steel
	contains = list(/obj/item/clothing/head/roguetown/helmet)

/datum/supply_pack/rogue/armor_steel/helmet_winged
	name = "头盔，翼饰款"
	cost = 50 // 1 Steel
	contains = list(/obj/item/clothing/head/roguetown/helmet/winged)

/datum/supply_pack/rogue/armor_steel/helmet_kettle
	name = "头盔，锅盔"
	cost = 50 // 1 Steel
	contains = list(/obj/item/clothing/head/roguetown/helmet/kettle)

/datum/supply_pack/rogue/armor_steel/helmet_sallet
	name = "头盔，萨莱"
	cost = 50 // 1 Steel
	contains = list(/obj/item/clothing/head/roguetown/helmet/sallet)

/datum/supply_pack/rogue/armor_steel/helmet_sallet_visor
	name = "头盔，带面罩萨莱"
	cost = 90 // 2 Steel
	contains = list(/obj/item/clothing/head/roguetown/helmet/sallet/visored)

/datum/supply_pack/rogue/armor_steel/helmet_bucket
	name = "头盔，桶盔"
	cost = 90 // 2 Steel
	contains = list(/obj/item/clothing/head/roguetown/helmet/heavy/bucket)

/datum/supply_pack/rogue/armor_steel/helmet_pigface
	name = "头盔，猪面盔"
	cost = 90 // 2 Steel
	contains = list(/obj/item/clothing/head/roguetown/helmet/bascinet/pigface)

/datum/supply_pack/rogue/armor_steel/helmet_hounskull
	name = "头盔，猎犬颅盔"
	cost = 90 // 2 Steel
	contains = list(/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull)

/datum/supply_pack/rogue/armor_steel/helmet_volfplate
	name = "头盔，沃尔夫钢盔"
	cost = 90 // 2 Steel
	contains = list(/obj/item/clothing/head/roguetown/helmet/heavy/volfplate)

/datum/supply_pack/rogue/armor_steel/helmet_bascinet
	name = "头盔，巴西内"
	cost = 90 // 2 Steel
	contains = list(/obj/item/clothing/head/roguetown/helmet/bascinet)

/datum/supply_pack/rogue/armor_steel/helmet_etruscan_bascinet
	name = "头盔，伊特鲁斯卡巴西内"
	cost = 90 // 2 Steel
	contains = list(/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan)

/datum/supply_pack/rogue/armor_steel/helmet_knight
	name = "头盔，骑士款"
	cost = 90 // 2 Steel
	contains = list(/obj/item/clothing/head/roguetown/helmet/heavy/knight)

/datum/supply_pack/rogue/armor_steel/helmet_armet
	name = "头盔，阿梅特"
	cost = 90 // 2 Steel
	contains = list(/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet)

/datum/supply_pack/rogue/armor_steel/helmet_savoyard
	name = "头盔，萨伏依"
	cost = 90 // 2 Steel
	contains = list(/obj/item/clothing/head/roguetown/helmet/heavy/guard)

/datum/supply_pack/rogue/armor_steel/helmet_barred
	name = "头盔，栅面款"
	cost = 90 // 2 Steel
	contains = list(/obj/item/clothing/head/roguetown/helmet/heavy/sheriff)

/datum/supply_pack/rogue/armor_steel/helmet_beak
	name = "头盔，鸟喙款"
	cost = 90 // 2 Steel
	contains = list(/obj/item/clothing/head/roguetown/helmet/heavy/beakhelm)

/datum/supply_pack/rogue/armor_steel/bevor
	name = "护颌"
	cost = 50 // 1 Steel
	contains = list(/obj/item/clothing/neck/roguetown/bevor)

/datum/supply_pack/rogue/armor_steel/gorget_steel
	name = "护喉"
	cost = 50 // 1 Steel
	contains = list(/obj/item/clothing/neck/roguetown/gorget/steel)

/datum/supply_pack/rogue/armor_steel/boots_steel
	name = "甲靴"
	cost = 50 // 1 Steel
	contains = list(/obj/item/clothing/shoes/roguetown/boots/armor)

/datum/supply_pack/rogue/armor_steel/mask_steel
	name = "面甲"
	cost = 50 // 1 Steel
	contains = list(/obj/item/clothing/mask/rogue/facemask/steel)

/datum/supply_pack/rogue/armor_steel/steel/belt
	name = "腰带"
	cost = 50 // 1 Steel
	contains = list(/obj/item/storage/belt/rogue/leather/steel)

/datum/supply_pack/rogue/armor_steel/steel/belt
	name = "挂甲片腰带"
	cost = 50 // 1 Steel
	contains = list(/obj/item/storage/belt/rogue/leather/steel/tasset)
