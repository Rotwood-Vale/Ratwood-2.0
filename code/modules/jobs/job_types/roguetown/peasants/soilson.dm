/datum/job/roguetown/farmer
	title = "Soilson"
	flag = FARMER
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 3
	spawn_positions = 5
	display_order = JDO_SOILSON
	selection_color = JCOLOR_PEASANT
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	cmode_music = 'sound/music/cmode/towner/combat_towner2.ogg'

	tutorial = "你过着一种朴素的生活，而你对日子的那点朴实理解，若让旁人知道其中有多圆满，怕是许多人都会心生羡慕。你知道怎样才算一整天扎实的劳作，也明白额上的汗水都是替自己流的。饥荒与瘟疫也许会降临，但你依旧懂得如何好好庆贺活着这件事。翻耕土地，为周围的人种出新鲜粮食，说不定有朝一日，你就不只是个无人称颂的英雄。"


	f_title = "农妇"
	outfit = /datum/outfit/job/roguetown/farmer
	display_order = 24
	give_bank_account = 17
	min_pq = -10
	max_pq = null
	round_contrib_points = 3
	social_rank = SOCIAL_RANK_PEASANT
	job_traits = list(TRAIT_SEEDKNOW, TRAIT_NOSTINK, TRAIT_LONGSTRIDER, TRAIT_HOMESTEAD_EXPERT)

	advclass_cat_rolls = list(CTAG_SOILBRIDE = 2)
	job_subclasses = list(
		/datum/advclass/soilson
	)
	spells = list(/obj/effect/proc_holder/spell/invoked/takeapprentice)

/datum/advclass/soilson
	name = "农人"
	tutorial = "你过着一种朴素的生活，而你对日子的那点朴实理解，若让旁人知道其中有多圆满，怕是许多人都会心生羡慕。你知道怎样才算一整天扎实的劳作，也明白额上的汗水都是替自己流的。饥荒与瘟疫也许会降临，但你依旧懂得如何好好庆贺活着这件事。翻耕土地，为周围的人种出新鲜粮食，说不定有朝一日，你就不只是个无人称颂的英雄。"
	outfit = /datum/outfit/job/roguetown/farmer/basic
	category_tags = list(CTAG_SOILBRIDE)
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_STR = 1,
		STATKEY_CON = 2,
		STATKEY_SPD = 1,
		STATKEY_INT = -1,//simple and honest
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/slings = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_MASTER,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE, //So they can actually even craft their makeshift weapons
		/datum/skill/craft/masonry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_MASTER,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/farmer/basic/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/armingcap
	mask = /obj/item/clothing/head/roguetown/roguehood
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltr = /obj/item/storage/keyring/soilson
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/flint = 1,
		)
	if(H.age == AGE_OLD)//So ppl have reason to pick this I guess?
		H.adjust_skillrank_up_to(/datum/skill/labor/farming, 6, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/labor/butchering, 6, TRUE)
	if(H.patron?.type == /datum/patron/divine/dendor)
		H.adjust_skillrank_up_to(/datum/skill/magic/druidic, 2, TRUE)
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random
		cloak = /obj/item/clothing/cloak/apron/brown
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/random
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	if(SSmapping.current_map.map_name == "Desert Town")
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/random
		pants = /obj/item/clothing/under/roguetown/sirwal/plainrandom
		shoes = /obj/item/clothing/shoes/roguetown/sandals
		head = /obj/item/clothing/head/roguetown/roguehood/shalal/nomad
