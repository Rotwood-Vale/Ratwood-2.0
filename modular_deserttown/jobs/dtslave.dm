/datum/job/roguetown/slave
	title = "Palace Slave"
	display_title = "宫奴"
	f_title = "宫奴"
	flag = SLAVE
	department_flag = YOUNGFOLK
	faction = "Station"
	total_positions = 8//need more slaves!!
	spawn_positions = 8

	allowed_races = ACCEPTED_RACES
	allowed_ages = ALL_AGES_LIST

	tutorial = "无论你曾为自由之身还是生来便是奴籍，你都不过是众多被奴隶主鞭策驱使的受虐奴隶中的一员，只为维持苏丹宫廷的运转。每一天都在你的背上刻下新的伤疤，而正是你的脊背承载着那些肮脏卑微的劳作，维系着王室的奢靡享乐。"
	
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
	name = "仆人"
	tutorial = "你是一名普通的仆人，衣着得体，卑微而最好不被看见。但穿着很实用。"
	outfit = /datum/outfit/job/roguetown/slave/servant
	category_tags = list(CTAG_PSLAVE)
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
	name = "异域奴隶"
	tutorial = "没人提过穿着长裙和长袜干院子里的活有多辛苦，但至少你看起来还是很美。"
	outfit = /datum/outfit/job/roguetown/slave/pleasure
	category_tags = list(CTAG_PSLAVE)
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

/datum/outfit/job/roguetown/slave/pleasure/pre_equip(mob/living/carbon/human/H)
	..()
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
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
		var/weapons = list("竖琴","鲁特琴","手风琴","吉他","绞弦琴","维奥尔琴","歌唱护符","长笛", "索尔特里琴")
		var/weapon_choice = input(H, "选择你的乐器：", "拿起武器") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("竖琴")
				backr = /obj/item/rogue/instrument/harp
			if("鲁特琴")
				backr = /obj/item/rogue/instrument/lute
			if("手风琴")
				backr = /obj/item/rogue/instrument/accord
			if("吉他")
				backr = /obj/item/rogue/instrument/guitar
			if("绞弦琴")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("维奥尔琴")
				backr = /obj/item/rogue/instrument/viola
			if("歌唱护符")
				backr = /obj/item/rogue/instrument/vocals
			if("长笛")
				backr = /obj/item/rogue/instrument/flute
			if("索尔特里琴")
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
