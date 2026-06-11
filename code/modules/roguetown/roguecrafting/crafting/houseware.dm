/datum/crafting_recipe/roguetown/survival/spoon
	name = "木勺（x3）（1 根小圆木）"
	category = "家居"
	result = list(
		/obj/item/kitchen/spoon,
		/obj/item/kitchen/spoon,
		/obj/item/kitchen/spoon,
		)
	reqs = list(/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/survival/fork
	name = "木叉（x3）（1 根小圆木）"
	category = "家居"
	result = list(
		/obj/item/kitchen/fork,
		/obj/item/kitchen/fork,
		/obj/item/kitchen/fork,
		)
	reqs = list(/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/survival/platter
	name = "木盘（x2）（1 根小圆木）"
	category = "家居"
	result = list(
		/obj/item/cooking/platter,
		/obj/item/cooking/platter,
		)
	reqs = list(/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/survival/rollingpin
	name = "擀面杖（1 根小圆木）"
	category = "家居"
	result = /obj/item/kitchen/rollingpin
	reqs = list(/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/survival/woodbucket
	name = "木桶（1 根小圆木）"
	category = "家居"
	result = /obj/item/reagent_containers/glass/bucket
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/woodcup
	name = "木杯（x3）（1 根小圆木）"
	category = "家居"
	result = list(
		/obj/item/reagent_containers/glass/cup/wooden/crafted,
		/obj/item/reagent_containers/glass/cup/wooden/crafted,
		/obj/item/reagent_containers/glass/cup/wooden/crafted,
		)
	reqs = list(/obj/item/grown/log/tree/small = 1)

/obj/item/reagent_containers/glass/cup/wooden/crafted
	sellprice = 3

/datum/crafting_recipe/roguetown/survival/woodtray
	name = "木托盘（x2）（1 根小圆木）"
	category = "家居"
	result = list(
		/obj/item/storage/bag/tray,
		/obj/item/storage/bag/tray,
		)
	reqs = list(/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/survival/woodbowl
	name = "木碗（x3）（1 根小圆木）"
	category = "家居"
	result = list(
		/obj/item/reagent_containers/glass/bowl,
		/obj/item/reagent_containers/glass/bowl,
		/obj/item/reagent_containers/glass/bowl,
		)
	reqs = list(/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/survival/pot
	name = "石锅（2 块石料）"
	category = "家居"
	result = /obj/item/reagent_containers/glass/bucket/pot/stone
	reqs = list(/obj/item/natural/stone = 2)

/datum/crafting_recipe/roguetown/survival/soap
	name = "肥皂（x3）（1 份兽脂）"
	category = "家居"
	result = list(
		/obj/item/soap,
		/obj/item/soap,
		/obj/item/soap,
		)
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1)

/datum/crafting_recipe/roguetown/survival/candle
	name = "蜡烛（x3）（1 份兽脂）"
	category = "家居"
	result = list(
		/obj/item/candle/yellow,
		/obj/item/candle/yellow,
		/obj/item/candle/yellow,
		)
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1)

/datum/crafting_recipe/roguetown/survival/candle/eora
	name = "伊欧拉 蜡烛（x3）（1 份兽脂，1 朵 Rosa，25 圣水）"
	category = "家居"
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
