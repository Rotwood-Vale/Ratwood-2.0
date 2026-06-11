/datum/job/roguetown/servant
	title = "Servant"
	display_title = "仆役"
//	f_title = "Maid"
	flag = SERVANT
	department_flag = COURTIERS
	faction = "Station"
	total_positions = 6
	spawn_positions = 6

	allowed_races = ACCEPTED_RACES
	allowed_ages = ALL_AGES_LIST

	tutorial = "你得以在公爵宅邸中过上一种还算舒适的服侍生活，听从总管的命令，把整天耗在那些必要却低微的杂务上。这个职位提供劳役仆从、女仆与男仆三种外观风格。"

	outfit = /datum/outfit/job/roguetown/servant
	advclass_cat_rolls = list(CTAG_SERVANT = 20)
	job_traits = list(TRAIT_HOMESTEAD_EXPERT)
	display_order = JDO_SERVANT
	give_bank_account = TRUE
	min_pq = -10
	max_pq = null
	round_contrib_points = 2
	advjob_examine = TRUE
	cmode_music = 'sound/music/cmode/towner/combat_towner.ogg'
	social_rank = SOCIAL_RANK_PEASANT
	job_subclasses = list(
		/datum/advclass/servant/servant,
		/datum/advclass/servant/maid,
		/datum/advclass/servant/butler
	)

/datum/advclass/servant/servant
	name = "仆役"
	tutorial = "你只是个平凡无奇的仆役，穿得也像那么回事：卑微，且最好别太显眼。不过这身打扮倒也实用。"
	outfit = /datum/outfit/job/roguetown/servant/servant
	category_tags = list(CTAG_SERVANT)
	traits_applied = list(TRAIT_CICERONE, TRAIT_KEENEARS, TRAIT_SLEUTH, TRAIT_ROYALSERVANT, TRAIT_FOOD_STIPEND)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_INT = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/servant/servant/pre_equip(mob/living/carbon/human/H)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/formal/shorts
	armor = /obj/item/clothing/suit/roguetown/shirt/dress/maid/servant
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/formal
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backl = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather/suspenders/butler
	beltr = /obj/item/storage/keyring/servant
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	if(H.age == AGE_MIDDLEAGED)
		H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.adjust_skillrank(/datum/skill/labor/farming, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)

/datum/advclass/servant/maid
	name = "女仆"
	tutorial = "没人真的会提起，穿着裙子和长袜做庭院杂活到底有多折腾人，不过至少你看起来确实相当体面。"
	outfit = /datum/outfit/job/roguetown/servant/maid
	category_tags = list(CTAG_SERVANT)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_INT = 1,
		STATKEY_SPD = 1
	)
	traits_applied = list(TRAIT_CICERONE, TRAIT_KEENEARS, TRAIT_SLEUTH, TRAIT_ROYALSERVANT, TRAIT_FOOD_STIPEND)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/servant/maid/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/maidband
	armor = /obj/item/clothing/suit/roguetown/shirt/dress/maid
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	cloak = /obj/item/clothing/cloak/apron/maid
	backl = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather/sash
	beltr = /obj/item/storage/keyring/servant
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	if(H.age == AGE_MIDDLEAGED)
		H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.adjust_skillrank(/datum/skill/labor/farming, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)

/datum/advclass/servant/butler
	name = "男仆"
	tutorial = "无可挑剔的外表就是你的立身之本。你照样还是得下地沾泥，只不过洗衣服的次数更多了。"
	outfit = /datum/outfit/job/roguetown/servant/butler
	category_tags = list(CTAG_SERVANT)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_INT = 1,
		STATKEY_SPD = 1
	)
	traits_applied = list(TRAIT_CICERONE, TRAIT_KEENEARS, TRAIT_SLEUTH, TRAIT_ROYALSERVANT, TRAIT_FOOD_STIPEND)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/servant/butler/pre_equip(mob/living/carbon/human/H)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/formal/shorts
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/formal
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backl = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather/suspenders/butler
	beltr = /obj/item/storage/keyring/servant
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/black
	if(H.age == AGE_MIDDLEAGED)
		H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.adjust_skillrank(/datum/skill/labor/farming, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
