/datum/crafting_recipe/roguetown/leather/footwear
	abstract_type = /datum/crafting_recipe/roguetown/leather/footwear
	category = "鞋履"

/datum/crafting_recipe/roguetown/leather/footwear/shoes
	name = "鞋子"
	result = /obj/item/clothing/shoes/roguetown/simpleshoes
	reqs = list(/obj/item/natural/hide/cured = 1)

/datum/crafting_recipe/roguetown/leather/footwear/boots
	name = "皮靴"
	result = /obj/item/clothing/shoes/roguetown/boots/leather
	reqs = list(/obj/item/natural/hide/cured = 1)
	sellprice = 27
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/footwear/boots_heavy
	name = "厚皮靴"
	result = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fur = 1)
	craftdiff = 3	//Same as the heavy leather gloves.

/datum/crafting_recipe/roguetown/leather/footwear/boots_heavy_b
	name = "礼靴"
	result = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fur = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/leather/footwear/boots/furlinedboots
	name = "毛里靴"
	result = /obj/item/clothing/shoes/roguetown/boots/furlinedboots
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fur = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/footwear/boots/short
	name = "短靴"
	result = /obj/item/clothing/shoes/roguetown/shortboots
	reqs = list(/obj/item/natural/hide/cured = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/leather/footwear/boots/dark
	name = "暗色靴"
	result = /obj/item/clothing/shoes/roguetown/boots
	reqs = list(/obj/item/natural/hide/cured = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/footwear/boots/noble
	name = "贵族靴"
	result = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	reqs = list(/obj/item/natural/hide/cured = 3,
				/obj/item/natural/fur = 1)
	craftdiff = 4
