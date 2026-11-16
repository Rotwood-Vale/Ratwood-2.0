/datum/crafting_recipe/roguetown/weaving
	abstract_type = /datum/crafting_recipe/roguetown/weaving
	display_category = ITEM_CAT_GARMENT_COMMON
	structurecraft = /obj/machinery/loom
	skillcraft = /datum/skill/craft/sewing
	subtype_reqs = TRUE		//For subtypes of fur

/datum/crafting_recipe/roguetown/weaving/rags
	name = "webbed shirt"
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt/webs)
	reqs = list(/obj/item/natural/silk = 1)
	craftdiff = 1
	sellprice = 6

/datum/crafting_recipe/roguetown/weaving/webbing
	name = "webbed leggings"
	result = list(/obj/item/clothing/under/roguetown/webs)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 1
	sellprice = 9

/datum/crafting_recipe/roguetown/weaving/cloak
	name = "silk half cloak"
	result = list(/obj/item/clothing/cloak/half)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	sellprice = 15

/datum/crafting_recipe/roguetown/weaving/puritan
	name = "puritan's cape"
	result = list(/obj/item/clothing/cloak/cape/puritan)
	reqs = list(/obj/item/natural/silk = 4)
	craftdiff = 3
	sellprice = 25
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/weaving/shirt
	name = "formal silks"
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt/puritan)
	reqs = list(/obj/item/natural/silk = 5)
	craftdiff = 3
	sellprice = 25
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/weaving/shepardmask
	name = "half-mask"
	result = list(/obj/item/clothing/mask/rogue/shepherd)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 1)
	craftdiff = 1
	sellprice = 10
	display_category = ITEM_CAT_CLOTH_MASK

/datum/crafting_recipe/roguetown/weaving/astratarobe
	name = "astrata robes"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/astrata)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4
	sellprice = 20

/datum/crafting_recipe/roguetown/weaving/abyssorrobe
	name = "abyssor robes"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/abyssor)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4
	sellprice = 20

/datum/crafting_recipe/roguetown/weaving/abyssorhood
	name = "abyssor hood"
	result = list(/obj/item/clothing/head/roguetown/roguehood/abyssor)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	sellprice = 20

/datum/crafting_recipe/roguetown/weaving/astratahood
	name = "solar hood"
	result = list(/obj/item/clothing/head/roguetown/roguehood/astrata)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	sellprice = 20

/datum/crafting_recipe/roguetown/weaving/nocrobe
	name = "noc robes"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/noc)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4
	sellprice = 20

/datum/crafting_recipe/roguetown/weaving/nochood
	name = "moon hood"
	result = list(/obj/item/clothing/head/roguetown/nochood)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	sellprice = 20

/datum/crafting_recipe/roguetown/weaving/dendorrobe
	name = "dendor robes"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/dendor)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4
	sellprice = 20

/datum/crafting_recipe/roguetown/weaving/necrarobe
	name = "necra robes"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/necra)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4
	sellprice = 20

/datum/crafting_recipe/roguetown/weaving/necrahood
	name = "necra hood"
	result = list(/obj/item/clothing/head/roguetown/necrahood)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	sellprice = 20

/datum/crafting_recipe/roguetown/weaving/barkeep
	name = "bar dress"
	result = list (/obj/item/clothing/suit/roguetown/shirt/dress)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 2)
	craftdiff = 5
	sellprice = 27
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/weaving/silkdress
	name = "chemise"
	result = list (/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/random)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 3)
	craftdiff = 5
	sellprice = 30
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/weaving/silkcoat
	name = "silk coat"
	result = list (/obj/item/clothing/suit/roguetown/armor/silkcoat)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 3,
				/obj/item/natural/fur = 2)
	craftdiff = 5
	sellprice = 60
	display_category = ITEM_CAT_GARMENT_FINE

//Eora content from Stonekeep
/datum/crafting_recipe/roguetown/weaving/eoramask
	name = "eora mask"
	result = list(/obj/item/clothing/head/roguetown/eoramask)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 2)
	craftdiff = 3
	sellprice = 20
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/crafting_recipe/roguetown/weaving/eorarobes
	name = "eora robes"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/eora)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	sellprice = 20

/datum/crafting_recipe/roguetown/weaving/cloak_rosa
	name = "regal cloak"
	result = /obj/item/clothing/cloak/rosa
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1, /obj/item/alch/rosa = 1 )
	structurecraft = /obj/machinery/loom
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/weaving/cloak_rosa_two
	name = "courtly cloak"
	result = /obj/item/clothing/cloak/rosa/two
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1, /obj/item/alch/rosa = 1 )
	structurecraft = /obj/machinery/loom
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/weaving/head_roguetown_roguehood_eorahood
	name = "opera hood"
	result = /obj/item/clothing/head/roguetown/roguehood/eorahood
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	structurecraft = /obj/machinery/loom
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/weaving/head_roguetown_roguehood_ravox
	name = "ravox hood"
	result = /obj/item/clothing/head/roguetown/roguehood/ravox
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	structurecraft = /obj/machinery/loom
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/weaving/head_roguetown_roguehood_see
	name = "see hood"
	result = /obj/item/clothing/head/roguetown/roguehood/see
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	structurecraft = /obj/machinery/loom
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/weaving/suit_roguetown_shirt_robe_ravox
	name = "ravox robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/ravox
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/silk = 1)
	structurecraft = /obj/machinery/loom
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/weaving/suit_roguetown_shirt_robe_see
	name = "see robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/see
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/silk = 1)
	structurecraft = /obj/machinery/loom
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/weaving/suit_roguetown_shirt_robe_seecleric
	name = "see clerical robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/seecleric
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/silk = 1)
	structurecraft = /obj/machinery/loom
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/weaving/suit_roguetown_shirt_tunic_rosa
	name = "ivory dress"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/rosa
	reqs = list(/obj/item/natural/silk = 3, /obj/item/natural/cloth = 2, /obj/item/alch/rosa = 1)
	structurecraft = /obj/machinery/loom
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/weaving/suit_roguetown_shirt_tunic_rosa_five
	name = "sable dress"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/rosa/five
	reqs = list(/obj/item/natural/silk = 3, /obj/item/natural/cloth = 2, /obj/item/alch/rosa = 1)
	structurecraft = /obj/machinery/loom
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/weaving/suit_roguetown_shirt_tunic_rosa_four
	name = "obsidian dress"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/rosa/four
	reqs = list(/obj/item/natural/silk = 3, /obj/item/natural/cloth = 2, /obj/item/alch/rosa = 1)
	structurecraft = /obj/machinery/loom
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/weaving/suit_roguetown_shirt_tunic_rosa_six
	name = "maroon dress"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/rosa/six
	reqs = list(/obj/item/natural/silk = 3, /obj/item/natural/cloth = 2, /obj/item/alch/rosa = 1)
	structurecraft = /obj/machinery/loom
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/weaving/suit_roguetown_shirt_tunic_rosa_three
	name = "velvet dress"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/rosa/three
	reqs = list(/obj/item/natural/silk = 3, /obj/item/natural/cloth = 2, /obj/item/alch/rosa = 1)
	structurecraft = /obj/machinery/loom
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_FINE
