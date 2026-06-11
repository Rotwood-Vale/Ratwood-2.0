/datum/advclass/builder
	name = "工匠"
	tutorial = "你是一名手艺高超的木匠兼石匠，能将木材与石料塑造成你所需的一切。\
	修堡垒，搭仓房，铺木地板，竖十字架，修破门，只要有足够的木头和石块，这些活你都做得来。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/builder
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT, TRAIT_MASTER_CARPENTER, TRAIT_MASTER_MASON)
	cmode_music = 'sound/music/cmode/towner/combat_towner2.ogg'
	maximum_possible_slots = 20 // Should never fill, for the purpose of players to know what types towners are in round at the menu
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
		STATKEY_INT = 1,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,

		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,//working at heights
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/masonry = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/engineering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,//makin' sacks

		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/mining = SKILL_LEVEL_APPRENTICE,

		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/builder/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/hatfur
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/hatblu
	armor = /obj/item/clothing/suit/roguetown/armor/workervest
	pants = /obj/item/clothing/under/roguetown/trou
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltl = /obj/item/rogueweapon/hammer/steel
	r_hand = /obj/item/grown/log/tree/small
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
						/obj/item/flint = 1,
						/obj/item/rogueweapon/huntingknife = 1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/rogueweapon/handsaw = 1,
						/obj/item/rogueweapon/chisel,
						/obj/item/dye_brush = 1,
						/obj/item/rogueweapon/scabbard/sheath = 1,
						/obj/item/rogueweapon/stoneaxe/handaxe,
						/obj/item/natural/stone = 4
						)
	if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
	else
		armor = /obj/item/clothing/suit/roguetown/armor/workervest
		pants = /obj/item/clothing/under/roguetown/trou
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	if(H.age == AGE_MIDDLEAGED)
		H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, 5, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/craft/masonry, 5, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, 6, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/craft/masonry, 6, TRUE)
