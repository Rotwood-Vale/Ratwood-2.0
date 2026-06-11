/datum/job/roguetown/apothecary
	title = "Apothecary"
	display_title = "药剂师"
	flag = APOTHECARY
	department_flag = COURTIERS
	faction = "Station"
	total_positions = 2
	spawn_positions = 2

	allowed_races = RACES_ALL_KINDS
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED)

	tutorial = "你是一名技艺娴熟的医者，受过系统训练，也在行医之道上积累了经验。你听命于首席医师，由其准许你开展诊疗。谁若落到你的手术刀下，最好自求多福。"

	outfit = /datum/outfit/job/roguetown/apothecary

	cmode_music = 'sound/music/combat_physician.ogg'

	display_order = JDO_APOTHECARY
	give_bank_account = 30

	min_pq = 0
	max_pq = null
	round_contrib_points = 5
	social_rank = SOCIAL_RANK_YEOMAN
	advclass_cat_rolls = list(CTAG_APOTH = 2)
	job_traits = list(TRAIT_MEDICINE_EXPERT, TRAIT_ALCHEMY_EXPERT, TRAIT_NOSTINK, TRAIT_EMPATH)
	job_subclasses = list(
		/datum/advclass/apothecary
	)
	spells = list(/obj/effect/proc_holder/spell/invoked/takeapprentice)

/datum/advclass/apothecary
	name = "药剂师"
	tutorial = "你是一名技艺娴熟的医者，受过系统训练，也在行医之道上积累了经验。你听命于首席医师，由其准许你开展诊疗。谁若落到你的手术刀下，最好自求多福。"
	outfit = /datum/outfit/job/roguetown/apothecary/basic
	category_tags = list(CTAG_APOTH)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE, //enhances survival chances.
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_MASTER,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/apothecary/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/roguehood/black
	pants = /obj/item/clothing/under/roguetown/trou/apothecary
	shirt = /obj/item/clothing/suit/roguetown/shirt/apothshirt
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/black
	belt = /obj/item/storage/belt/rogue/leather/rope
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/storage/belt/rogue/surgery_bag/full/physician
	beltr = /obj/item/roguekey/physician
	id = /obj/item/scomstone/bad
	r_hand = /obj/item/rogueweapon/woodstaff/
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/natural/worms/leech/cheele = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/clothing/mask/rogue/physician = 1,
		/obj/item/storage/keyring = 1,
		/obj/item/roguekey/keeper = 1,
		/obj/item/mini_flagpole/apothecary
	)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
