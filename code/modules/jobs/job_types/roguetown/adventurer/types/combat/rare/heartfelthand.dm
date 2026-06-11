/datum/advclass/heartfelthand
	name = "赤心 之手"
	tutorial = "你作为王室之手侍奉领主，负责领地里的一切外交事务。 \
	也许终有一日，你也会成为领主。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	outfit = /datum/outfit/job/roguetown/adventurer/heartfelthand
	maximum_possible_slots = 1
	pickprob = 100
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_SEEPRICES)
	category_tags = list(CTAG_DISABLED)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_INT = 3,
		STATKEY_STR = 2
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/heartfelthand/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	belt = /obj/item/storage/belt/rogue/leather/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	pants = /obj/item/clothing/under/roguetown/tights/black
	armor = /obj/item/clothing/suit/roguetown/armor/heartfelt/hand
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	gloves =/obj/item/clothing/gloves/roguetown/angle
	beltl = /obj/item/rogueweapon/scabbard/sword
	l_hand = /obj/item/rogueweapon/sword/sabre/dec
	beltr = /obj/item/rogueweapon/huntingknife
	backr = /obj/item/storage/backpack/rogue/satchel/heartfelt
	backpack_contents = list(
						/obj/item/flashlight/flare/torch = 1,
						)
	mask = /obj/item/clothing/mask/rogue/spectacles/golden
	id = /obj/item/scomstone
