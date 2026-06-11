//dwarf master smith

/datum/advclass/masterblacksmith
	name = "锻造大师"
	tutorial = "你是一名锻造大师，钢铁在你手里像面团般可塑，黄金也如陶土般听话。\
	去打造大师级的兵器与甲胄吧，成为所有向往你那座雄伟熔炉之人心中的传奇。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/masterblacksmith
	subclass_social_rank = SOCIAL_RANK_YEOMAN
	maximum_possible_slots = 1
	pickprob = 5
	category_tags = list(CTAG_TOWNER)
	traits_applied = list(TRAIT_TRAINED_SMITH, TRAIT_SMITHING_EXPERT)
	subclass_stats = list(
		STATKEY_LCK = 4,
		STATKEY_STR = 2,
		STATKEY_INT = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
		STATKEY_PER = 1
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/smelting = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/masterblacksmith/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/hammer/iron
	beltl = /obj/item/rogueweapon/tongs
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	mouth = /obj/item/rogueweapon/huntingknife

	gloves = /obj/item/clothing/gloves/roguetown/leather
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	pants = /obj/item/clothing/under/roguetown/trou
	cloak = /obj/item/clothing/cloak/apron/blacksmith

	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
						/obj/item/flint = 1,
						/obj/item/rogueore/coal=2,
						/obj/item/rogueore/iron=2,
						/obj/item/rogueore/silver=1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/rogueweapon/scabbard/sheath = 1
						)
	if(H.pronouns == HE_HIM)
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
	else
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
