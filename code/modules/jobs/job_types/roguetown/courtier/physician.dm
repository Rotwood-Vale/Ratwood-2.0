/datum/job/roguetown/physician
	title = "Head Physician"
	display_title = "首席医师"
	flag = PHYSICIAN
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	display_order = JDO_PHYSICIAN
	tutorial = "你是一位医术高超的大医者，也是当前诊所的负责人。\
		管理你的诊所，以及你麾下的药剂师们。\
		身为上层阶级的一员，你应当准备好为贵族诊治，而你也拥有与之相称的权限。"
	outfit = /datum/outfit/job/roguetown/physician
	whitelist_req = TRUE
	advclass_cat_rolls = list(CTAG_COURTPHYS = 2)
	social_rank = SOCIAL_RANK_NOBLE
	give_bank_account = 30
	min_pq = 3 //Please don't kill the duke by operating on strong intent. Play apothecary until you're deserving of the great white beak of doom
	max_pq = null
	round_contrib_points = 5

	cmode_music = 'sound/music/combat_physician.ogg'

	job_traits = list(TRAIT_MEDICINE_EXPERT, TRAIT_ALCHEMY_EXPERT, TRAIT_NOSTINK, TRAIT_EMPATH, TRAIT_NOBLE)
	job_subclasses = list(
		/datum/advclass/physician
	)
	spells = list(/obj/effect/proc_holder/spell/invoked/takeapprentice)

/datum/advclass/physician
	name = "首席医师"
	tutorial = "你是一位医术高超的大医者，也是当前诊所的负责人。\
		管理你的诊所，以及你麾下的药剂师们。\
		身为上层阶级的一员，你应当准备好为贵族诊治，而你也拥有与之相称的权限。"
	outfit = /datum/outfit/job/roguetown/physician/basic
	category_tags = list(CTAG_COURTPHYS)
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_WIL = 1,
		STATKEY_LCK = 1,
		STATKEY_SPD = 1,
		STATKEY_STR = -1,
		STATKEY_CON = -1,
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN, //same tier as other yeomen
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN, //to properly wield a caneblade
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_LEGENDARY,
	)

/datum/outfit/job/roguetown/physician
	job_bitflag = BITFLAG_ROYALTY

/datum/outfit/job/roguetown/physician
	name = "医师"
	jobtype = /datum/job/roguetown/physician

/datum/outfit/job/roguetown/physician/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/physician
	mask = /obj/item/clothing/mask/rogue/physician
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid            //coin to hire mercenaries or adventurers with
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/physician
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/black
	gloves = /obj/item/clothing/gloves/roguetown/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather/mourning
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/belt/rogue/surgery_bag/full/physician
	beltr = /obj/item/rogueweapon/scabbard/sheath/courtphysician
	id = /obj/item/scomstone/bad
	r_hand = /obj/item/rogueweapon/sword/rapier/courtphysician
	backl = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 2,
		/obj/item/natural/worms/leech/cheele = 1, //little buddy
		/obj/item/reagent_containers/glass/bottle/waterskin = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/mini_flagpole/apothecary = 1,
		/obj/item/storage/keyring/physician = 1,
	)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
	if(H.age == AGE_MIDDLEAGED)
		H.adjust_skillrank_up_to(/datum/skill/craft/sewing, 4, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 6, TRUE) //small carrot to play old
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_PER, 1)
