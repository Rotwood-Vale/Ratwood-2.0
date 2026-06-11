/datum/job/roguetown/clerk
	title = "Clerk"
	display_title = "文书官"
	flag = CLERK
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)

	tutorial = "文书官、税吏、天选倒霉蛋。你要协助总管处理一切所需事务，并在对方不在时替其执行职责。虽说你不是贵族，但这差事倒也不算最糟。问题在于，一旦钱款有误或不翼而飞，贵族多半还能从牢里钻出去，你呢？嗯……只能说，伊特鲁斯卡 这个时节风景挺好。"

	outfit = /datum/outfit/job/roguetown/clerk
	display_order = JDO_CLERK
	give_bank_account = TRUE
	min_pq = -10
	max_pq = null
	round_contrib_points = 2
	advclass_cat_rolls = list(CTAG_CLERK = 2)
	social_rank = SOCIAL_RANK_YEOMAN
	job_traits = list(TRAIT_SEEPRICES)
	job_subclasses = list(
		/datum/advclass/clerk
	)


/datum/advclass/clerk
	name = "文书官"
	tutorial = "文书官、税吏、天选倒霉蛋。你要协助总管处理一切所需事务，并在对方不在时替其执行职责。虽说你不是贵族，但这差事倒也不算最糟。问题在于，一旦钱款有误或不翼而飞，贵族多半还能从牢里钻出去，你呢？嗯……只能说，伊特鲁斯卡 这个时节风景挺好。"
	subclass_stats = list(
		STATKEY_LCK = 2,
		STATKEY_INT = 2,
		STATKEY_SPD = 1,
		STATKEY_STR = -1
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
	)
	category_tags = list(CTAG_CLERK)
	outfit = /datum/outfit/job/roguetown/clerk/basic

/datum/outfit/job/roguetown/clerk/basic/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)

	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/green
	else if(should_wear_masc_clothes(H))
		armor = /obj/item/clothing/cloak/tabard/knight
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt

	pants = /obj/item/clothing/under/roguetown/tights
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/storage/keyring/steward //serously doubt this is gonna be an issue, but if it is, i'll change it
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/mini_flagpole/steward = 1,
	)
	id = /obj/item/scomstone/bad
