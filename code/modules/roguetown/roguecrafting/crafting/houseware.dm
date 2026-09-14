/datum/crafting_recipe/roguetown/survival/spoon
	display_category = ITEM_CAT_DECORATION
	name = "spoon (x3) (1 small log)"
	category = "Houseware"
	result = list(
		/obj/item/kitchen/spoon,
		/obj/item/kitchen/spoon,
		/obj/item/kitchen/spoon,
		)
	reqs = list(/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/survival/fork
	display_category = ITEM_CAT_DECORATION
	name = "fork (x3) (1 small log)"
	category = "Houseware"
	result = list(
		/obj/item/kitchen/fork,
		/obj/item/kitchen/fork,
		/obj/item/kitchen/fork,
		)
	reqs = list(/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/survival/platter
	display_category = ITEM_CAT_DECORATION
	name = "platter (x2) (1 small log)"
	category = "Houseware"
	result = list(
		/obj/item/cooking/platter,
		/obj/item/cooking/platter,
		)
	reqs = list(/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/survival/rollingpin
	display_category = ITEM_CAT_DECORATION
	name = "rollingpin (1 small log)"
	category = "Houseware"
	result = /obj/item/kitchen/rollingpin
	reqs = list(/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/survival/woodbucket
	display_category = ITEM_CAT_DECORATION
	name = "bucket (1 small log)"
	category = "Houseware"
	result = /obj/item/reagent_containers/glass/bucket
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/woodcup
	display_category = ITEM_CAT_DECORATION
	name = "wooden cups (x3) (1 small log)"
	category = "Houseware"
	result = list(
		/obj/item/reagent_containers/glass/cup/wooden/crafted,
		/obj/item/reagent_containers/glass/cup/wooden/crafted,
		/obj/item/reagent_containers/glass/cup/wooden/crafted,
		)
	reqs = list(/obj/item/grown/log/tree/small = 1)

/obj/item/reagent_containers/glass/cup/wooden/crafted
	sellprice = 3

/datum/crafting_recipe/roguetown/survival/woodtray
	display_category = ITEM_CAT_DECORATION
	name = "wooden trays (x2) (1 small log)"
	category = "Houseware"
	result = list(
		/obj/item/storage/bag/tray,
		/obj/item/storage/bag/tray,
		)
	reqs = list(/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/survival/woodbowl
	display_category = ITEM_CAT_DECORATION
	name = "wooden bowls (x3) (1 small log)"
	category = "Houseware"
	result = list(
		/obj/item/reagent_containers/glass/bowl,
		/obj/item/reagent_containers/glass/bowl,
		/obj/item/reagent_containers/glass/bowl,
		)
	reqs = list(/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/survival/pot
	display_category = ITEM_CAT_DECORATION
	name = "stone pot (2 stones)"
	category = "Houseware"
	result = /obj/item/reagent_containers/glass/bucket/pot/stone
	reqs = list(/obj/item/natural/stone = 2)

/datum/crafting_recipe/roguetown/survival/soap
	display_category = ITEM_CAT_DECORATION
	name = "soap (3x) (1 tallow)"
	category = "Houseware"
	result = list(
		/obj/item/soap,
		/obj/item/soap,
		/obj/item/soap,
		)
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1)

/datum/crafting_recipe/roguetown/survival/candle
	display_category = ITEM_CAT_DECORATION
	name = "candle (x3) (1 tallow)"
	category = "Houseware"
	result = list(
		/obj/item/candle/yellow,
		/obj/item/candle/yellow,
		/obj/item/candle/yellow,
		)
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1)

/datum/crafting_recipe/roguetown/survival/candle/eora
	display_category = ITEM_CAT_DECORATION
	name = "eora's candle (x3) (1 tallow, 1 rosa, 25 blessed water)"
	category = "Houseware"
	result = list(
		/obj/item/candle/eora,
		/obj/item/candle/eora,
		/obj/item/candle/eora,
		)
	reqs = list(
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/alch/rosa = 1,
		/datum/reagent/water/blessed = 25,
		)
