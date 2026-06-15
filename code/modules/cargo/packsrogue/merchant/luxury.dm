/datum/supply_pack/rogue/luxury
	group = "Luxury"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/luxury/fancyteaset
	name = "精美茶具套装（1 茶壶，4 茶杯）"
	cost = 100
	no_name_quantity = TRUE
	contains = list(/obj/item/reagent_containers/glass/bucket/pot/teapot/fancy,
	/obj/item/reagent_containers/glass/cup/ceramic/fancy,
	/obj/item/reagent_containers/glass/cup/ceramic/fancy,
	/obj/item/reagent_containers/glass/cup/ceramic/fancy,
	/obj/item/reagent_containers/glass/cup/ceramic/fancy)

/datum/supply_pack/rogue/luxury/silverpsicross
	name = "银质 Psycross"
	cost = 120
	contains = list(/obj/item/clothing/neck/roguetown/psicross/silver)

/datum/supply_pack/rogue/luxury/silverdagger
	name = "银匕首"
	cost = 120 //Silver weapons have been made much less powerful but much more common over time
	contains = list(/obj/item/rogueweapon/huntingknife/idagger/silver)

/datum/supply_pack/rogue/luxury/polishing_kit
	name = "抛光套装"
	no_name_quantity = TRUE
	cost = 100
	contains = list(/obj/item/polishing_cream, /obj/item/armor_brush)

/datum/supply_pack/rogue/luxury/circlet
	name = "头环"
	cost = 80
	contains = list(/obj/item/clothing/head/roguetown/circlet)

/datum/supply_pack/rogue/luxury/goldring
	name = "金戒指"
	cost = 70
	contains = list(/obj/item/clothing/ring/gold)

/datum/supply_pack/rogue/luxury/signet
	name = "印戒"
	cost = 220
	contains = list(/obj/item/clothing/ring/signet)

/datum/supply_pack/rogue/luxury/merctoken
	name = "嘉奖状"
	cost = 80
	contains = list(/obj/item/merctoken)

/datum/supply_pack/rogue/luxury/canvas
	name = "画布"
	cost = 30
	contains = list(/obj/item/canvas)

/datum/supply_pack/rogue/luxury/easel
	name = "画架"
	cost = 80
	contains = list(/obj/structure/easel)

/datum/supply_pack/rogue/luxury/paintbrush
	name = "画笔"
	cost = 15
	contains = list(/obj/item/paint_brush)

/datum/supply_pack/rogue/luxury/paintpalette
	name = "调色板"
	cost = 15
	contains = list(/obj/item/paint_palette)

/datum/supply_pack/rogue/luxury/swatchbook
	name = "裁缝色卡簿"
	cost = 20
	contains = list(/obj/item/book/rogue/swatchbook)

// /datum/supply_pack/rogue/luxury/lovepotion
// 	name = "Love Potion"
// 	cost = 300
// 	contains = list(/obj/item/lovepotion)

/datum/supply_pack/rogue/luxury/parasol
	name = "纸伞"
	cost = 25
	contains = list(/obj/item/rogueweapon/mace/parasol)

/datum/supply_pack/rogue/luxury/fineparasol
	name = "精致阳伞"
	cost = 65
	contains = list(/obj/item/rogueweapon/mace/parasol/noble)

/datum/supply_pack/rogue/luxury/suidust
	name = "易容之尘（仅性别）"
	cost = 135
	contains = list(/obj/item/alch/transisdust)

/datum/supply_pack/rogue/adventure_supplies/scabbard/noble
	name = "Noble Scabbard"
	cost = 65
	contains = list(
					/obj/item/rogueweapon/scabbard/sword/noble
				)

/datum/supply_pack/rogue/adventure_supplies/scabbard/royal
	name = "Royal Scabbard"
	cost = 120
	contains = list(
					/obj/item/rogueweapon/scabbard/sword/royal
				)

/datum/supply_pack/rogue/adventure_supplies/sheath/noble
	name = "Noble Sheath"
	cost = 65
	contains = list(
					/obj/item/rogueweapon/scabbard/sheath/noble
				)

/datum/supply_pack/rogue/adventure_supplies/sheath/royal
	name = "Royal Sheath"
	cost = 120
	contains = list(
					/obj/item/rogueweapon/scabbard/sheath/royal
				)
