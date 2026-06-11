
/datum/advclass/heartfelt/retinue/physician
	name = "赤心 医师"
	tutorial = "你是 赤心 的医师，曾因稳健的双手与救人的智慧而备受称颂，却终究无力将男爵领从悲惨命运中挽回。\
	那些未能救下的人始终萦绕心头，你于是前往这片土地，寻求救赎、重新找回使命，也或许为这世界留下的创伤找出疗方。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/heartfelt/retinue/physician
	maximum_possible_slots = 1
	pickprob = 100
	category_tags = list(CTAG_HFT_RETINUE)
	subclass_social_rank = SOCIAL_RANK_NOBLE
	class_select_category = CLASS_CAT_HFT_COURT

	traits_applied = list(TRAIT_HEARTFELT, TRAIT_NOSTINK, TRAIT_EMPATH, TRAIT_HEARTFELT)

	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_WIL = 1,
		STATKEY_LCK = 1,
		STATKEY_SPD = 2,
	)

	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_LEGENDARY,
	)
// HIGH COURT - /ONE SLOT/ Roles that were previously in the Court, but moved here.

/datum/outfit/job/roguetown/heartfelt/retinue/physician/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/physician
	neck = /obj/item/clothing/neck/roguetown/psicross/pestra
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/physician
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/black
	gloves = /obj/item/clothing/gloves/roguetown/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather/mourning
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/belt/rogue/surgery_bag/full/physician
	beltr = /obj/item/rogueweapon/huntingknife
	id = /obj/item/scomstone/bad
	r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/steel
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew = 2,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 2,
		/obj/item/natural/worms/leech/cheele = 1, //little buddy
		/obj/item/reagent_containers/glass/bottle/waterskin = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/bedroll = 1,
	)

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
		backpack_contents += /obj/item/clothing/mask/rogue/physician
	if(H.age == AGE_OLD)
		H.change_stat("speed", -1)
		H.change_stat("intelligence", 2)
		H.change_stat("perception", 1)
