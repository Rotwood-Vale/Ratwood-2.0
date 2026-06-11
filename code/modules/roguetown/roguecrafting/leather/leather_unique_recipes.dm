// Unique class drip or something that might fit into another category
/datum/crafting_recipe/roguetown/leather/unique
	abstract_type = /datum/crafting_recipe/roguetown/leather/unique

/datum/crafting_recipe/roguetown/leather/unique/artipants
	name = "修补匠长裤"
	result = list(/obj/item/clothing/under/roguetown/trou/artipants)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/hide/cured = 2)
	tools = list(/obj/item/needle)
	craftdiff = 3
	sellprice = 11

/datum/crafting_recipe/roguetown/leather/unique/baggyleatherpants
	name = "Pontifex 的 chaqchur"
	result = list(/obj/item/clothing/under/roguetown/trou/leather/pontifex)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/hide/cured = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 20

/datum/crafting_recipe/roguetown/leatherunique/gladsandals
	name = "角斗士凉鞋"
	result = list(/obj/item/clothing/shoes/roguetown/gladiator)
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 3
	sellprice = 12

/datum/crafting_recipe/roguetown/leather/unique/grenzelboots
	name = "格伦泽尔霍夫特ian 靴子"
	result = list(/obj/item/clothing/shoes/roguetown/boots/grenzelhoft)
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/reagent_containers/food/snacks/tallow = 1,
				/obj/item/natural/fur = 1,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 15

/datum/crafting_recipe/roguetown/leather/unique/otavanleatherpants
	name = "奥塔万 皮裤"
	result = list(/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan)
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fur = 1)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 30

/datum/crafting_recipe/roguetown/leather/unique/fencingbreeches
	name = "击剑马裤"
	result = list(/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic)
	reqs = list(/obj/item/natural/fibers = 1,
				/obj/item/natural/hide/cured = 2,
				/obj/item/natural/cloth = 4)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 20

/datum/crafting_recipe/roguetown/leather/unique/otavanboots
	name = "奥塔万 皮靴"
	result = list(/obj/item/clothing/shoes/roguetown/boots/otavan)
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/reagent_containers/food/snacks/tallow = 1,
				/obj/item/natural/fur = 1,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 25

/datum/crafting_recipe/roguetown/leather/unique/buckleshoes
	name = "扣带鞋"
	result = list(/obj/item/clothing/shoes/roguetown/simpleshoes/buckle)
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 25

/datum/crafting_recipe/roguetown/leather/unique/monkleather
	name = "Pontifex 的卡夫坦"
	result = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/pontifex)
	reqs = list(/obj/item/natural/hide/cured = 4,
				/obj/item/natural/cloth = 1,
				/obj/item/reagent_containers/food/snacks/tallow = 1)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 23

/datum/crafting_recipe/roguetown/leather/unique/furlinedjacket
	name = "工艺师夹克"
	result = list(/obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket)
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fur = 1,
				/obj/item/natural/cloth = 1)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 21

/datum/crafting_recipe/roguetown/leather/unique/winterjacket
	name = "冬装夹克"
	result = list(/obj/item/clothing/suit/roguetown/armor/leather/vest/winterjacket)
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fur = 2,
				/obj/item/natural/cloth = 1)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 24

/datum/crafting_recipe/roguetown/leather/unique/openrobes
	name = "萨满外套"
	result = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy/atgervi)
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/cloth = 1)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 20

/datum/crafting_recipe/roguetown/leather/unique/monkrobes
	name = "圣僧法衣"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/monk/holy)
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/reagent_containers/food/snacks/tallow = 1,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 6 //Can be a bit strong, reduce to 5 if too high.

/datum/crafting_recipe/roguetown/leather/unique/crafteast
	name = "装饰 dobo 长袍"
	result = list(/obj/item/clothing/suit/roguetown/armor/basiceast/crafteast)
	reqs = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/natural/fibers = 2,
		/obj/item/clothing/suit/roguetown/armor/basiceast = 1)
	tools = list(/obj/item/needle)
	craftdiff = 5

