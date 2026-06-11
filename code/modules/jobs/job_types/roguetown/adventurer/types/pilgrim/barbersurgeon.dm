/datum/advclass/barbersurgeon
	name = "理发外科医"
	tutorial = "靠着粗陋的器具和多年积攒下来的经验，你勉强也算得上是一名“自由行医者”，哪怕本地药师根本没收你的申请。年复一年下来，你大概已经给更多人开过刀，甚至比大多数骑士砍过的人还多。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/doctor
	subclass_social_rank = SOCIAL_RANK_YEOMAN
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	traits_applied = list(TRAIT_EMPATH, TRAIT_NOSTINK, TRAIT_MEDICINE_EXPERT, TRAIT_ALCHEMY_EXPERT)
	maximum_possible_slots = 20 // Should never fill, for the purpose of players to know what types towners are in round at the menu
	cmode_music = 'sound/music/combat_physician.ogg'
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_LCK = 1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_MASTER,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/doctor/pre_equip(mob/living/carbon/human/H)
	..()
	mask = /obj/item/clothing/mask/rogue/spectacles
	head = /obj/item/clothing/head/roguetown/nightman
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid /// they are a fine dressed doctor. no one else gonna pay em. psycross removed since it was a hold over for secular
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/physician
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/surgery_bag/full
	beltr = /obj/item/rogueweapon/huntingknife/cleaver /// proper self defense an tree aquiring
	pants = /obj/item/clothing/under/roguetown/trou
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	backl = /obj/item/storage/backpack/rogue/backpack
	if(SSmapping.current_map.map_name == "Desert Town")
		head = /obj/item/clothing/head/roguetown/turban
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb

	backpack_contents = list(
						/obj/item/natural/worms/leech/cheele = 1,
						/obj/item/natural/cloth = 2,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/rogueweapon/huntingknife/scissors/steel = 1,
						/obj/item/hair_dye_cream = 3,
						/obj/item/heart_blood_canister/filled = 2,
						/obj/item/bait/leech = 4
						)
	if(H.age == AGE_OLD)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_PER, 1)
		H.adjust_skillrank_up_to(/datum/skill/misc/medicine, 6, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 4, TRUE)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)

