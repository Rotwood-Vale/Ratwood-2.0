/datum/job/roguetown/butler // really need to re-name all these when the codebase isn't a fork and search will update for the peasants...
	title = "Seneschal"
	display_title = "总管"
	flag = BUTLER
	department_flag = COURTIERS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = ACCEPTED_RACES

	tutorial = "侍奉至死，这便是你的信条。你是庄园的内务总管，统领宅邸仆役，打点这片产业日复一日的行政事务。这个职位还允许你在首席男仆与女仆长两种风格间作出选择。"
	outfit = /datum/outfit/job/roguetown/seneschal
	advclass_cat_rolls = list(CTAG_SENESCHAL = 20)
	display_order = JDO_BUTLER
	give_bank_account = 30
	min_pq = 3
	max_pq = null
	round_contrib_points = 3
	social_rank = SOCIAL_RANK_YEOMAN
	job_subclasses = list(
		/datum/advclass/seneschal/seneschal,
		/datum/advclass/seneschal/headmaid,
		/datum/advclass/seneschal/chiefbutler
	)
	spells = list(/obj/effect/proc_holder/spell/invoked/takeapprentice)

/datum/advclass/seneschal
	traits_applied = list(TRAIT_CICERONE, TRAIT_KEENEARS, TRAIT_SLEUTH, TRAIT_HOMESTEAD_EXPERT, TRAIT_SEWING_EXPERT, TRAIT_ROYALSERVANT, TRAIT_FOOD_STIPEND) // They have Expert Sewing
	category_tags = list(CTAG_SENESCHAL)

/datum/advclass/seneschal/seneschal
	name = "总管"
	tutorial = "虽然你仍需在必要时亲自补上宅邸仆役的差事，但你早已把自己塑造成凌驾于他们之上的人物。"
	outfit = /datum/outfit/job/roguetown/seneschal/seneschal
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_LCK = 1, // Usual leadership carrot.
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/seneschal
	has_loadout = TRUE

//This applies to all Seneschal subclasses
/datum/outfit/job/roguetown/seneschal/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	if(H.age == AGE_MIDDLEAGED)
		H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)

/datum/outfit/job/roguetown/seneschal/seneschal/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/armor/gambeson/tailcoat
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/formal
	pants = /obj/item/clothing/under/roguetown/trou/formal
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	backl = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather/suspenders/butler // Aware that these render over shit like coats. it's a problem for another day, in my time.
	beltr = /obj/item/storage/keyring/servant
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	id = /obj/item/scomstone/bad

/datum/advclass/seneschal/headmaid
	name = "女仆长"
	tutorial = "无论你是真的从女仆里升上来的，还是单纯偏爱那一身花边，你都把自己打扮成了女仆长的模样。不过你的职责与本领并无不同。"
	outfit = /datum/outfit/job/roguetown/seneschal/headmaid
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_LCK = 1, // Usual leadership carrot.
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/seneschal/headmaid/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/maidband
	armor = /obj/item/clothing/suit/roguetown/shirt/dress/maid
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	cloak = /obj/item/clothing/cloak/apron/maid
	backl = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather/sash
	beltr = /obj/item/storage/keyring/servant
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	id = /obj/item/scomstone/bad

/datum/advclass/seneschal/chiefbutler
	name = "首席男仆"
	tutorial = "你是男仆中的上等人物，清嗓子再低声来一句“容我一言”的本事无人能及。不过作为总管，你的职责与才能依旧不变。"
	outfit = /datum/outfit/job/roguetown/seneschal/chiefbutler
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_LCK = 1, // Usual leadership carrot.
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/seneschal/chiefbutler/pre_equip(mob/living/carbon/human/H)
	..() // They need a monocle.
	armor = /obj/item/clothing/armor/gambeson/tailcoat
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/formal
	pants = /obj/item/clothing/under/roguetown/trou/formal
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	backl = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather/suspenders/butler
	beltr = /obj/item/storage/keyring/servant
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	id = /obj/item/scomstone/bad
