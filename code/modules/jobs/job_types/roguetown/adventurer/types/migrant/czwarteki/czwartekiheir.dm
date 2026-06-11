/datum/advclass/czwarteki/heir
	name = "兹瓦尔特基 继承人"
	tutorial = "你是 兹瓦尔特基 领主的继承人。也许只是众多继承人之一。你的父母带着你一同踏上这场远行，让你在故土之外的诸国中历练见识。"
	outfit = /datum/outfit/job/roguetown/czwarteki/heir
	traits_applied = list(TRAIT_NOBLE, TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED)
	category_tags = list(CTAG_CZWAR_HEIR)

	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

	subclass_languages = list(
		/datum/language/aavnic,
	)

	subclass_stats = list(
	STATKEY_STR = 2,
	STATKEY_WIL = 2,
	STATKEY_INT = 1,
	STATKEY_SPD = 1,
	STATKEY_LCK = 3,
	)

	subclass_skills = list(
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/czwarteki/heir/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/nyle/consortcrown
	pants = /obj/item/clothing/under/roguetown/chainlegs
	armor = /obj/item/clothing/suit/roguetown/armor/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/flashlight/flare/torch/lantern
	l_hand = /obj/item/rogueweapon/sword/sabre/dec
	beltl = /obj/item/rogueweapon/scabbard/sword/noble
	neck = /obj/item/clothing/neck/roguetown/bevor
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1, 
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
		)
	H.cmode_music = 'sound/music/combat_czwarteki.ogg'
