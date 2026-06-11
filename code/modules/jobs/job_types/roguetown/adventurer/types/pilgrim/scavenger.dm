/datum/advclass/scavenger/harvester
	name = "垦荒者"
	tutorial = "也许你上一处家园遭逢惨祸，也许是世事逼得你不得不背井离乡。\
	不管怎样，你听说这片土地的土壤丰饶肥沃。只盼你这次能建立起一份熬得过寒冬的家业。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/refugee/harvester
	cmode_music = 'sound/music/cmode/towner/combat_towner2.ogg'
	traits_applied = list(TRAIT_SEEDKNOW, TRAIT_HOMESTEAD_EXPERT)
	category_tags = list(CTAG_PILGRIM)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 1,
		STATKEY_CON = 1,
		STATKEY_INT = 1,
	)

/datum/outfit/job/roguetown/refugee/harvester/pre_equip(mob/living/carbon/human/H)
	..()

	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE) //less than a dedicated lumberjack
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)

	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)

	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE) //gotta build your farmstead
	H.adjust_skillrank(/datum/skill/craft/masonry, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/farming, 3, TRUE) //less than a dedicated farmer

	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)

	H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/lumberjacking, 2, TRUE) //probably don't need much higher
	H.adjust_skillrank(/datum/skill/labor/butchering, 2, TRUE) //rearin' beasts
	H.adjust_skillrank(/datum/skill/craft/sewing, 1, TRUE) //makin' sacks

	belt = /obj/item/storage/belt/rogue/leather/rope
	head = /obj/item/clothing/head/roguetown/strawhat
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/rogueweapon/stoneaxe/woodcut/ //simple but effective
	neck = 	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/rogueweapon/sickle

	backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/seeds/wheat = 2,
		/obj/item/seeds/apple = 1,
		/obj/item/ash = 3,
		/obj/item/seeds/potato = 1,
	)
	if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen
	else
		armor = /obj/item/clothing/suit/roguetown/armor/workervest
		pants = /obj/item/clothing/under/roguetown/trou
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random



/datum/advclass/scavenger/prospector
	name = "淘矿人"
	tutorial = "循着富矿矿脉与废金属的传闻，你来到这片土地，\
	一边采矿打铁，一边把货物卖给同样在沼地间漂泊谋生的人。当然，前提还是你得先给自己搭起一座熔炉。"
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/refugee/prospector

	category_tags = list(CTAG_PILGRIM)
	traits_applied = list(TRAIT_SMITHING_EXPERT, TRAIT_TRAINED_SMITH, TRAIT_HOMESTEAD_EXPERT)
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_CON = 2,
		STATKEY_STR = 1,
		STATKEY_INT = 1,
		STATKEY_SPD = -1
	)

/datum/outfit/job/roguetown/refugee/prospector/pre_equip(mob/living/carbon/human/H)
	..()
	r_hand = /obj/item/rogueweapon/pick/copper
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/hammer/copper
	beltl = /obj/item/rogueweapon/tongs
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	cloak = /obj/item/clothing/cloak/apron/blacksmith
	mouth = /obj/item/rogueweapon/huntingknife/bronze
	pants = /obj/item/clothing/under/roguetown/trou
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/rogueore/coal = 4,
		/obj/item/rogueore/iron = 5,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/blacksmithing = 1,
		/obj/item/armor_brush = 1,
		/obj/item/polishing_cream = 1
		)

	if(H.pronouns == HE_HIM)
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
	else
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shoes = /obj/item/clothing/shoes/roguetown/shortboots

	H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE) //for climbing in those mines

	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)

	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)

	H.adjust_skillrank(/datum/skill/craft/engineering, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/armorsmithing, 2, TRUE) //probably enough to crank out some cheap iron armour, maybe we'll want to boost it
	H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/blacksmithing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/smelting, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mining, 3, TRUE) //less than a dedicated miner

	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)

	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/ceramics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 3, TRUE) //got to do something with all those rocks you find
