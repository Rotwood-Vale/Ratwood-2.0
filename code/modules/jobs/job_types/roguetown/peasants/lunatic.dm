/datum/job/roguetown/lunatic
	title = "Lunatic"
	display_title = "疯子"
	flag = LUNATIC
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	round_contrib_points = 2
	var/list/traits_applied
	traits_applied = list(TRAIT_PSYCHOSIS, TRAIT_NOSTINK, TRAIT_MANIAC_AWOKEN, TRAIT_HOMESTEAD_EXPERT) // Maniac_Awoken no longer has any function other than the flavor text and trait
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	outfit = /datum/outfit/job/roguetown/lunatic
	bypass_lastclass = TRUE
	bypass_jobban = FALSE
	min_pq = 100 //the magic of an allowlist server.
	max_pq = null
	tutorial = "你是疯子，是被社会唾弃、也最容易招来厄运的人。你的任务简单，却凶险万分：不择手段地活下去，因为你只要还存在于这世上，危险就会从四面八方自己找上门来。人们说，这片谷地最先逼疯的，永远是那些自以为最了解它的人。"
	display_order = JDO_LUNATIC
	social_rank = SOCIAL_RANK_PEASANT
	cmode_music = 'sound/music/combat_bum.ogg'

	job_traits = list(TRAIT_JESTERPHOBIA)

	advclass_cat_rolls = list(CTAG_LUNATIC = 2)
	job_subclasses = list(
		/datum/advclass/lunatic
	)

/datum/advclass/lunatic
	name = "疯子"
	tutorial = "你是疯子，是被社会唾弃、也最容易招来厄运的人。你的任务简单，却凶险万分：不择手段地活下去，因为你只要还存在于这世上，危险就会从四面八方自己找上门来。人们说，这片谷地最先逼疯的，永远是那些自以为最了解它的人。"
	outfit = /datum/outfit/job/roguetown/lunatic/basic
	category_tags = list(CTAG_LUNATIC)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_CON = 4
	)
	subclass_skills = list(
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/lunatic/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	H.STALUC = rand(3, 8)
	armor = /obj/item/clothing/suit/roguetown/shirt/rags
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
	pants = /obj/item/clothing/under/roguetown/tights/vagrant
	belt  = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/rogueweapon/huntingknife/stoneknife
	beltr = /obj/item/flashlight/flare/torch
