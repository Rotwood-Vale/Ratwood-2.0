/datum/advclass/scavenger/harvester
	name = "Harvester"
	tutorial = "Perhaps terrible fate befell your last homestead, or circumstances conspired to drive you away.\
	Either way, the soil of these lands are rich and fertile, so you hear. Let us hope you can build something to last the winter."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/refugee/harvester
	cmode_music = 'sound/music/cmode/towner/combat_towner2.ogg'
	
	category_tags = list(CTAG_PILGRIM)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 1,
		STATKEY_CON = 1,
	)

/datum/outfit/job/roguetown/refugee/harvester/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE) //less than a dedicated lumberjack
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE) //gotta build your farmstead
	H.adjust_skillrank(/datum/skill/craft/masonry, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/butchering, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/lumberjacking, 2, TRUE) //probably don't need much higher
	H.adjust_skillrank(/datum/skill/labor/farming, 3, TRUE) //less than a dedicated farmer
	H.adjust_skillrank(/datum/skill/craft/traps, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	belt = /obj/item/storage/belt/rogue/leather/rope
	head = /obj/item/clothing/head/roguetown/strawhat
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/rogueweapon/stoneaxe/woodcut/	//simple but effective
	neck = /obj/item/clothing/neck/roguetown/coif
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/rogueweapon/sickle
	backpack_contents = list(
						/obj/item/flint = 1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/rogueweapon/huntingknife = 1,
						/obj/item/recipe_book/builder = 1,
						/obj/item/recipe_book/survival = 1,
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
	name = "Prospector"
	tutorial = "Following the promise of rich veins and scrap metal, you come to these lands \
	to mine and smith, peddling wares to fellow iterant bog-wanderers. Only after building a forge for yourself, of course"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/refugee/prospector
	
	category_tags = list(CTAG_PILGRIM)
	traits_applied = list(TRAIT_TRAINED_SMITH)
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
		STATKEY_STR = 1,
		STATKEY_INT = 1,
		STATKEY_SPD = -1
	)

/datum/outfit/job/roguetown/refugee/prospector/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/hatfur
	r_hand = /obj/item/rogueweapon/pick
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltr = /obj/item/rogueweapon/hammer/wood
	beltl = /obj/item/rogueweapon/tongs
	neck = /obj/item/clothing/neck/roguetown/coif
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	cloak = /obj/item/clothing/cloak/apron/blacksmith
	mouth = /obj/item/rogueweapon/huntingknife
	pants = /obj/item/clothing/under/roguetown/trou
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
						/obj/item/flint = 1,
						/obj/item/rogueore/coal=1,
						/obj/item/rogueore/iron=1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/recipe_book/blacksmithing = 1,
						/obj/item/recipe_book/survival = 1,
						/obj/item/rogueweapon/scabbard/sheath = 1
						)
	if(H.pronouns == HE_HIM)
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
	else
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shoes = /obj/item/clothing/shoes/roguetown/shortboots

	H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/engineering, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/blacksmithing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/armorsmithing, 2, TRUE) //probably enough to crank out some cheap iron armour, maybe we'll want to boost it
	H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/smelting, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mining, 3, TRUE) //less than a dedicated miner
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE) //for climbing in those mines
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE) //got to do something with all those rocks you find
