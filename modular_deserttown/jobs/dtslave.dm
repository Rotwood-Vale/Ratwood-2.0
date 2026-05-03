/datum/job/roguetown/slave
	title = "Palace Slave"
	f_title = "Palace Slave"
	flag = SLAVE
	department_flag = YOUNGFOLK
	faction = "Station"
	total_positions = 8//need more slaves!!
	spawn_positions = 8

	allowed_races = ACCEPTED_RACES
	allowed_ages = ALL_AGES_LIST

	tutorial = "Whether you were once a free soul or were born into chattel servitude, you're one of the many abused and mistreated slaves whipped by the Task Master to keep the Sultan's palace running smooth. Each day is marked by a scar on your back, and it is your back that carries the dirty, menial work required to keep the royal family content and decadent."
	
	outfit = /datum/outfit/job/roguetown/slave
	advclass_cat_rolls = list(CTAG_PSLAVE = 20)
	job_traits = list(TRAIT_HOMESTEAD_EXPERT)
	display_order = JDO_SERVANT
	give_bank_account = TRUE
	min_pq = -10
	max_pq = null
	round_contrib_points = 2
	advjob_examine = TRUE
	cmode_music = 'sound/music/cmode/towner/combat_towner.ogg'
	social_rank = SOCIAL_RANK_DIRT
	job_subclasses = list(
		/datum/advclass/slave/servant,
		/datum/advclass/slave/pleasure,
		// /datum/advclass/slave/worker
	)

/datum/advclass/slave/servant
	traits_applied = list(TRAIT_CICERONE, TRAIT_ROYALSERVANT, TRAIT_FOOD_STIPEND)

/datum/advclass/slave/servant
	traits_applied = list(TRAIT_CICERONE)

/datum/advclass/slave/servant
	name = "Servant"
	tutorial = "You are a humdrum servant, dressed the part; lowly and best out of sight. It's practical, however."
	outfit = /datum/outfit/job/roguetown/slave/servant
	category_tags = list(CTAG_PSLAVE)
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
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/slave/servant/pre_equip(mob/living/carbon/human/H)
	..()
	
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb
	else
		pants = /obj/item/clothing/under/roguetown/sirwal/plainrandom
	neck = /obj/item/clothing/neck/roguetown/gorget/cursed_collar
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/rope
	neck = /obj/item/clothing/neck/roguetown/gorget/cursed_collar
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/rope
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

/datum/advclass/slave/pleasure
	name = "Exotic Slave"
	tutorial = "Not one really mentions how hard it is to do yardwork in a dress and stockings, but at least you still look really good."
	outfit = /datum/outfit/job/roguetown/slave/pleasure
	category_tags = list(CTAG_PSLAVE)
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

/datum/outfit/job/roguetown/slave/pleasure/pre_equip(mob/living/carbon/human/H)
	..()
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/storage/keyring/servant
	backpack_contents = list(
		/obj/item/candle/eora = 1,
	)
	if(should_wear_femme_clothes(H))
		mask = /obj/item/clothing/mask/rogue/exoticsilkmask
		neck = /obj/item/clothing/neck/roguetown/gorget/cursed_collar
		shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra
		shoes = /obj/item/clothing/shoes/roguetown/anklets
		belt = /obj/item/storage/belt/rogue/leather/exoticsilkbelt
	else
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
		neck = /obj/item/clothing/neck/roguetown/gorget/cursed_collar
		pants = /obj/item/clothing/under/roguetown/trou/leathertights
		belt = /obj/item/storage/belt/rogue/leather/black
		shoes = /obj/item/clothing/shoes/roguetown/sandals

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/massage)
		var/weapons = list("Harp","Lute","Accordion","Guitar","Hurdy-Gurdy","Viola","Vocal Talisman","Flute", "Psyaltery")
		var/weapon_choice = input(H, "Choose your instrument.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Harp")
				backr = /obj/item/rogue/instrument/harp
			if("Lute")
				backr = /obj/item/rogue/instrument/lute
			if("Accordion")
				backr = /obj/item/rogue/instrument/accord
			if("Guitar")
				backr = /obj/item/rogue/instrument/guitar
			if("Hurdy-Gurdy")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("Viola")
				backr = /obj/item/rogue/instrument/viola
			if("Vocal Talisman")
				backr = /obj/item/rogue/instrument/vocals
			if("Flute")
				backr = /obj/item/rogue/instrument/flute
			if("Psyaltery")
				backr = /obj/item/rogue/instrument/psyaltery

	if(H.age == AGE_MIDDLEAGED)
		H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.adjust_skillrank(/datum/skill/labor/farming, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)

// /datum/advclass/slave/worker
// 	name = "Slave Laborer"
// 	tutorial = "CHANGE THIS. You do HARD WORK!."
// 	outfit = /datum/outfit/job/roguetown/slave/worker
// 	category_tags = list(CTAG_PSLAVE)
// 	subclass_stats = list(
// 		STATKEY_STR = 2,
// 		STATKEY_END = 3,
// 		STATKEY_CON = 1,
// 		STATKEY_SPE = -1,
// 		STATKEY_PER = -1,
// 		STATKEY_INT = -1
// 	)
// 	subclass_skills = list(
// 		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
// 		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
// 		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
// 		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
// 		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
// 		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
// 		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
// 		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
// 		/datum/skill/misc/lockpicking = SKILL_LEVEL_NOVICE,
// 		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
// 		/datum/skill/labor/mining = SKILL_LEVEL_JOURNEYMAN,
// 		/datum/skill/labor/lumberjacking = SKILL_LEVEL_JOURNEYMAN,
// 	)

// /datum/outfit/job/roguetown/slave/worker/pre_equip(mob/living/carbon/human/H)
// 	..()
// 	pants = /obj/item/clothing/under/roguetown/tights/black
// 	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
// 	shoes = /obj/item/clothing/shoes/roguetown/shortboots
// 	backl = /obj/item/storage/backpack/rogue/satchel
// 	belt = /obj/item/storage/belt/rogue/leather
// 	beltr = /obj/item/storage/keyring/servant
// 	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
// 	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/black
// 	if(H.age == AGE_MIDDLEAGED)
// 		H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
// 		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
// 		H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
// 	if(H.age == AGE_OLD)
// 		H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
// 		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
// 		H.adjust_skillrank(/datum/skill/labor/farming, 2, TRUE)
// 		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
