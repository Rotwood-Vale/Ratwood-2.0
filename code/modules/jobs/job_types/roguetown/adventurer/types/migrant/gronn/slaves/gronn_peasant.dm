/datum/advclass/gronn/slave/peasant
	name = "Captured Peasant"
	tutorial = "You worked the soil and tended the hearth before the tribe took you. Seeds, sickle and stewpot are all one trade to you, and a warband marches on its belly."
	outfit = /datum/outfit/job/roguetown/gronn/slave/peasant
	category_tags = list(CTAG_GRONN_SLAVE)
	traits_applied = list(TRAIT_SEEDKNOW, TRAIT_HOMESTEAD_EXPERT, TRAIT_NOSTINK, TRAIT_LONGSTRIDER)
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_STR = 1,
		STATKEY_CON = 2,
		STATKEY_SPD = 1,
		STATKEY_INT = -1,
	)
	subclass_skills = list(
		/datum/skill/labor/farming = SKILL_LEVEL_MASTER,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_MASTER,
		/datum/skill/labor/fishing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/gronn/slave/peasant/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/cursed_collar
	belt = /obj/item/storage/belt/rogue/leather/rope
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/nomadpants
	armor = /obj/item/clothing/suit/roguetown/armor/workervest
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/hoe
	r_hand = /obj/item/rogueweapon/sickle
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch = 1,
		/obj/item/flint = 1,
		/obj/item/seeds/wheat = 3,
		/obj/item/seeds/apple = 2,
		/obj/item/seeds/potato = 2,
		/obj/item/recipe_book/cooking = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/flashlight/flare/torch/lantern = 1
		)

	H.cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'

	if(!H.has_language(/datum/language/gronnic))
		H.grant_language(/datum/language/gronnic)
		to_chat(H, span_info("I can speak Gronnic with ,n before my speech."))

	H.set_blindness(0)
