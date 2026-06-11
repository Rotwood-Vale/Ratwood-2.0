/datum/crafting_recipe/roguetown/weaving
	structurecraft = /obj/machinery/loom
	skillcraft = /datum/skill/craft/sewing
	subtype_reqs = TRUE		//For subtypes of fur

/datum/crafting_recipe/roguetown/weaving/rags
	name = "蛛网衬衣"
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt/webs)
	reqs = list(/obj/item/natural/silk = 1)
	craftdiff = 1
	sellprice = 6

/datum/crafting_recipe/roguetown/weaving/webbing
	name = "蛛网护腿"
	result = list(/obj/item/clothing/under/roguetown/webs)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 1
	sellprice = 9

/datum/crafting_recipe/roguetown/weaving/cloak
	name = "丝质半披风"
	result = list(/obj/item/clothing/cloak/half)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	sellprice = 19

/datum/crafting_recipe/roguetown/weaving/puritan
	name = "清教徒披肩"
	result = list(/obj/item/clothing/cloak/cape/puritan)
	reqs = list(/obj/item/natural/silk = 4)
	craftdiff = 3
	sellprice = 35

/datum/crafting_recipe/roguetown/weaving/shirt
	name = "礼服丝衣"
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt/puritan)
	reqs = list(/obj/item/natural/silk = 5)
	craftdiff = 3
	sellprice = 35

/datum/crafting_recipe/roguetown/weaving/shepardmask
	name = "半面具"
	result = list(/obj/item/clothing/mask/rogue/shepherd)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 1)
	craftdiff = 1
	sellprice = 30

/datum/crafting_recipe/roguetown/weaving/astratarobe
	name = "阿斯特拉塔 长袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/astrata)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4
	sellprice = 25

/datum/crafting_recipe/roguetown/weaving/abyssorrobe
	name = "阿比索尔 长袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/abyssor)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4
	sellprice = 25

/datum/crafting_recipe/roguetown/weaving/abyssorhood
	name = "阿比索尔 兜帽"
	result = list(/obj/item/clothing/head/roguetown/roguehood/abyssor)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	sellprice = 25

/datum/crafting_recipe/roguetown/weaving/astratahood
	name = "太阳兜帽"
	result = list(/obj/item/clothing/head/roguetown/roguehood/astrata)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	sellprice = 25

/datum/crafting_recipe/roguetown/weaving/nocrobe
	name = "诺克 长袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/noc)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4
	sellprice = 25

/datum/crafting_recipe/roguetown/weaving/nochood
	name = "月之兜帽"
	result = list(/obj/item/clothing/head/roguetown/nochood)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	sellprice = 25

/datum/crafting_recipe/roguetown/weaving/dendorrobe
	name = "登多尔 长袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/dendor)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4
	sellprice = 25

/datum/crafting_recipe/roguetown/weaving/necrarobe
	name = "内克拉 长袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/necra)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4
	sellprice = 25

/datum/crafting_recipe/roguetown/weaving/necrahood
	name = "内克拉 兜帽"
	result = list(/obj/item/clothing/head/roguetown/necrahood)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	sellprice = 20

/datum/crafting_recipe/roguetown/weaving/barkeep
	name = "酒馆长裙"
	result = list (/obj/item/clothing/suit/roguetown/shirt/dress)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 2)
	craftdiff = 5
	sellprice = 27

/datum/crafting_recipe/roguetown/weaving/silkdress
	name = "衬裙"
	result = list (/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/random)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 3)
	craftdiff = 5
	sellprice = 30

/datum/crafting_recipe/roguetown/weaving/silkcoat
	name = "丝质外套"
	result = list (/obj/item/clothing/suit/roguetown/armor/silkcoat)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 3,
				/obj/item/natural/fur = 2)
	craftdiff = 5
	sellprice = 60

//Eora content from Stonekeep
/datum/crafting_recipe/roguetown/weaving/eoramask
	name = "伊欧拉 面具"
	result = list(/obj/item/clothing/head/roguetown/eoramask)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 2)
	craftdiff = 3
	sellprice = 20

/datum/crafting_recipe/roguetown/weaving/eorarobes
	name = "伊欧拉 长袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/eora)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	sellprice = 20
