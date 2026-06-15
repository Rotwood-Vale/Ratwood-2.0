#define CHEAP_PERFUME_PRICE 15
#define EXPENSIVE_PERFUME_PRICE 30

// Ofc Bathhouse sells perfumes
// Other server has it as random. I prefer it to not be random so people can get what they want.

/datum/supply_pack/rogue/bath_perfume
	group = "Cosmetics"
	crate_name = "perfumery' crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/bath_perfume/lavender
	name = "薰衣草香水"
	cost = CHEAP_PERFUME_PRICE
	contains = list(/obj/item/perfume/lavender)

/datum/supply_pack/rogue/bath_perfume/cherry
	name = "樱桃香水"
	cost = CHEAP_PERFUME_PRICE
	contains = list(/obj/item/perfume/cherry)

/datum/supply_pack/rogue/bath_perfume/rose
	name = "玫瑰香水"
	cost = CHEAP_PERFUME_PRICE
	contains = list(/obj/item/perfume/rose)

/datum/supply_pack/rogue/bath_perfume/jasmine
	name = "茉莉香水"
	cost = CHEAP_PERFUME_PRICE
	contains = list(/obj/item/perfume/jasmine)

/datum/supply_pack/rogue/bath_perfume/mint
	name = "薄荷香水"
	cost = CHEAP_PERFUME_PRICE
	contains = list(/obj/item/perfume/mint)

/datum/supply_pack/rogue/bath_perfume/vanilla
	name = "香草香水"
	cost = CHEAP_PERFUME_PRICE
	contains = list(/obj/item/perfume/vanilla)

/datum/supply_pack/rogue/bath_perfume/pear
	name = "梨香水"
	cost = CHEAP_PERFUME_PRICE
	contains = list(/obj/item/perfume/pear)

/datum/supply_pack/rogue/bath_perfume/strawberry
	name = "草莓香水"
	cost = CHEAP_PERFUME_PRICE
	contains = list(/obj/item/perfume/strawberry)

/datum/supply_pack/rogue/bath_perfume/cinnamon
	name = "肉桂香水"
	cost = CHEAP_PERFUME_PRICE
	contains = list(/obj/item/perfume/cinnamon)

// "Premium" perfumes they are more expensive by default
// No special mechanical effects
/datum/supply_pack/rogue/bath_perfume/frankincense
	name = "乳香香水"
	cost = EXPENSIVE_PERFUME_PRICE
	contains = list(/obj/item/perfume/frankincense)

/datum/supply_pack/rogue/bath_perfume/sandalwood
	name = "檀香香水"
	cost = EXPENSIVE_PERFUME_PRICE
	contains = list(/obj/item/perfume/sandalwood)

/datum/supply_pack/rogue/bath_perfume/myrrh
	name = "没药香水"
	cost = EXPENSIVE_PERFUME_PRICE
	contains = list(/obj/item/perfume/myrrh)

/*
	held_items[/obj/item/azure_lipstick] = list("PRICE" = rand(33,50),"NAME" = "red lipstick")
	held_items[/obj/item/azure_lipstick/jade] = list("PRICE" = rand(33,50),"NAME" = "jade lipstick")
	held_items[/obj/item/azure_lipstick/purple] = list("PRICE" = rand(33,50),"NAME" = "purple lipstick")
	held_items[/obj/item/azure_lipstick/black] = list("PRICE" = rand(33,50),"NAME" = "black lipstick")
*/

/datum/supply_pack/rogue/bath_perfume/red_lipstik
	name = "红口红"
	cost = 22
	contains = list(/obj/item/azure_lipstick)

/datum/supply_pack/rogue/bath_perfume/jade_lipstik
	name = "翡翠口红"
	cost = 25
	contains = list(/obj/item/azure_lipstick/jade)

/datum/supply_pack/rogue/bath_perfume/purple_lipstik
	name = "紫口红"
	cost = 25
	contains = list(/obj/item/azure_lipstick/purple)

/datum/supply_pack/rogue/bath_perfume/black_lipstik
	name = "黑口红"
	cost = 25
	contains = list(/obj/item/azure_lipstick/black)

/datum/supply_pack/rogue/bath_perfume/hair_dye
	name = "染发膏"
	cost = 15
	contains = list(
					/obj/item/hair_dye_cream,
					/obj/item/hair_dye_cream,
					/obj/item/hair_dye_cream,
				)
