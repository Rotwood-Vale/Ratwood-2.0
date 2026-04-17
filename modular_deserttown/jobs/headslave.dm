/datum/job/roguetown/headslave // really need to re-name all these when the codebase isn't a fork and search will update for the peasants...
	title = "Head Slave"
	flag = HEADSLAVE
	department_flag = COURTIERS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = ACCEPTED_RACES

	tutorial = "Servitude unto death; that is your motto. You are the manor's head slave, commanding over the lesser slaves and seeing to the administrative affairs,\
	 day to day of the estate. While you will always be understood as what you are - a slave - your many years of hard work have proven you to be a loyal, trusted, valuable,\
	  and, to a certain degree, respected member of the court, trained far beyond need of the whip. Indeed, you are entrusted to take the whip to those slaves beneath you.\
	  You love your masters."
	outfit = /datum/outfit/job/roguetown/headslave
	advclass_cat_rolls = list(CTAG_HEADSLAVE = 20)
	display_order = JDO_BUTLER
	give_bank_account = 30
	min_pq = 3
	max_pq = null
	round_contrib_points = 3
	social_rank = SOCIAL_RANK_YEOMAN
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD)
	cmode_music = 'sound/music/combat_desert2.ogg'
	job_subclasses = list(
		/datum/advclass/headslave,
	)
	spells = list(/obj/effect/proc_holder/spell/invoked/takeapprentice)

/datum/advclass/headslave
	traits_applied = list(TRAIT_CICERONE, TRAIT_HOMESTEAD_EXPERT, TRAIT_SEWING_EXPERT, TRAIT_ROYALSERVANT, TRAIT_FOOD_STIPEND) // They have Expert Sewing
	category_tags = list(CTAG_HEADSLAVE)
	name = "Head Slave"
	tutorial = "While still expected to fill in for the duties of the household slaves as needed, you have styled yourself as a figure beyond them."
	outfit = /datum/outfit/job/roguetown/headslave/headslave
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_LCK = 1, // Usual leadership carrot.
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
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

/datum/outfit/job/roguetown/headslave
	has_loadout = TRUE

//This applies to all headslave subclasses
/datum/outfit/job/roguetown/headslave/choose_loadout(mob/living/carbon/human/H)
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

/datum/outfit/job/roguetown/headslave/headslave/pre_equip(mob/living/carbon/human/H)
	..()
	backpack_contents = list(
		/obj/item/rogueweapon/whip = 1,
	)
	if(should_wear_femme_clothes(H))
		mask = /obj/item/clothing/mask/rogue/exoticsilkmask
		neck = /obj/item/clothing/neck/roguetown/collar/leather
		shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra
		shoes = /obj/item/clothing/shoes/roguetown/anklets
		belt = /obj/item/storage/belt/rogue/leather/exoticsilkbelt
		armor = /obj/item/clothing/suit/roguetown/armor/silkcoat
	else
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/beige
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/open
		neck = /obj/item/clothing/neck/roguetown/collar/catbell
		pants = /obj/item/clothing/under/roguetown/trou/leathertights
		belt = /obj/item/storage/belt/rogue/leather/black
		shoes = /obj/item/clothing/shoes/roguetown/sandals

	backl = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/storage/keyring/servant
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	id = /obj/item/scomstone/bad

// /datum/advclass/headslave/headmaid
// 	name = "Head Maid"
// 	tutorial = "Whether you were promoted from one or just like the frills, you stylize yourself as a head maid. Your duties and talents remain the same, though."
// 	outfit = /datum/outfit/job/roguetown/headslave/headmaid
// 	subclass_stats = list(
// 		STATKEY_INT = 2,
// 		STATKEY_PER = 2,
// 		STATKEY_LCK = 1, // Usual leadership carrot.
// 		STATKEY_SPD = 1
// 	)
// 	subclass_skills = list(
// 		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
// 		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
// 		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
// 		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
// 		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
// 		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
// 		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
// 		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
// 		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
// 		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
// 	)

// /datum/outfit/job/roguetown/headslave/headmaid/pre_equip(mob/living/carbon/human/H)
// 	..()
// 	armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/black
// 	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
// 	cloak = /obj/item/clothing/cloak/apron/waist
// 	backl = /obj/item/storage/backpack/rogue/satchel
// 	belt = /obj/item/storage/belt/rogue/leather
// 	beltr = /obj/item/storage/keyring/servant
// 	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
// 	id = /obj/item/scomstone/bad

// /datum/advclass/headslave/chiefbutler
// 	name = "Chief Butler"
// 	tutorial = "You are the ruling class of butler and your ability to clear your throat and murmur 'I say' is without peer. Your duties and talents as headslave remain the same, though."
// 	outfit = /datum/outfit/job/roguetown/headslave/chiefbutler
// 	subclass_stats = list(
// 		STATKEY_INT = 2,
// 		STATKEY_PER = 2,
// 		STATKEY_LCK = 1, // Usual leadership carrot.
// 		STATKEY_SPD = 1
// 	)
// 	subclass_skills = list(
// 		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
// 		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
// 		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
// 		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
// 		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
// 		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
// 		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
// 		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
// 		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
// 		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
// 	)

// /datum/outfit/job/roguetown/headslave/chiefbutler/pre_equip(mob/living/carbon/human/H)
// 	..() // They need a monocle.
// 	pants = /obj/item/clothing/under/roguetown/tights/black
// 	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
// 	shoes = /obj/item/clothing/shoes/roguetown/shortboots
// 	backl = /obj/item/storage/backpack/rogue/satchel
// 	belt = /obj/item/storage/belt/rogue/leather
// 	beltr = /obj/item/storage/keyring/servant
// 	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
// 	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/black
// 	id = /obj/item/scomstone/bad
