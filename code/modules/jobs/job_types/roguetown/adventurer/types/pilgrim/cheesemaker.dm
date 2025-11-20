/datum/advclass/cheesemaker
	name = "Cheesemaker"
	tutorial = "Cheese cheese cheese! You have not just cheese itself, but the crucial beast from whence it comes \
	As very skilled cook you come with some ingredients to make food and feed the masses. \
	Take good care of your precious bovine companion, and she will reward you in kind."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/cheesemaker
	subclass_social_rank = SOCIAL_RANK_YEOMAN
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)

	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/cow
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_CON = 2,//Cheeese diet
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/maces = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/axes = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/cheesemaker/pre_equip(mob/living/carbon/human/H)
	..()
	mouth = /obj/item/rogueweapon/huntingknife
	belt = /obj/item/storage/belt/rogue/leather
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
		pants = /obj/item/clothing/under/roguetown/skirt/random
	else if(should_wear_masc_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/armor/workervest
		pants = /obj/item/clothing/under/roguetown/tights/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
	head = /obj/item/clothing/head/roguetown/cookhat
	cloak = /obj/item/clothing/cloak/apron
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	backl = /obj/item/storage/backpack/rogue/backpack
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltl = /obj/item/flint
	beltr = /obj/item/rogueweapon/scabbard/sheath
	backpack_contents = list(
		/obj/item/reagent_containers/powder/salt = 3,
		/obj/item/reagent_containers/food/snacks/rogue/cheddar = 2,
		/obj/item/reagent_containers/glass/bottle/waterskin,
		/obj/item/reagent_containers/food/snacks/grown/wheat = 6,
		/obj/item/natural/cloth = 2,
		/obj/item/book/rogue/yeoldecookingmanual = 1,
		/obj/item/recipe_book/survival = 1,
		)
	r_hand = /obj/item/flashlight/flare/torch
