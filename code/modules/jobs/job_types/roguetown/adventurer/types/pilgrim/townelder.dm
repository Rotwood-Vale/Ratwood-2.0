/datum/advclass/elder
	name = "镇中长者"
	maximum_possible_slots = 1
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_OLD)
	tutorial = "你如古树般德高望重、年岁悠长，早在最初那批守望者的时代便已积累了非凡见识。人们仰赖你，不仅把你当作师者，也把你看作在事态演变成暴力前，能化解许多小纷争的引路人。并非每件事都必须以流血收场，不管随从们有多希望如此。在这动荡时日里，引领你的镇民吧，免得他们因无知而招来贵族的怒火。"
	outfit = /datum/outfit/job/roguetown/elder
	subclass_social_rank = SOCIAL_RANK_MINOR_NOBLE	//not a noble, but similar ranking
	cmode_music = 'sound/music/cmode/towner/combat_retired.ogg'
	category_tags = list(CTAG_TOWNER)
	traits_applied = list(TRAIT_SEEPRICES_SHITTY, TRAIT_EMPATH, TRAIT_MEDICINE_EXPERT, TRAIT_HOMESTEAD_EXPERT, TRAIT_ALCHEMY_EXPERT, TRAIT_SMITHING_EXPERT, TRAIT_SEWING_EXPERT, TRAIT_SURVIVAL_EXPERT)
	maximum_possible_slots = 20 // Should never fill, for the purpose of players to know what types towners are in round at the menu
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_MASTER,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/engineering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/ceramics = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/elder/pre_equip(mob/living/carbon/human/H)
	..()
	cloak = /obj/item/clothing/cloak/stabard/guardhood/elder
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/white
	pants = /obj/item/clothing/under/roguetown/tights
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/mace
	beltl = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/bad
	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, /obj/item/storage/belt/rogue/pouch/coins/rich = 1)
	if(should_wear_femme_clothes(H))
		head = /obj/item/clothing/head/roguetown/chaperon/greyscale/elder
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress
		backr = /obj/item/clothing/cloak/raincloak/furcloak
	else if(should_wear_masc_clothes(H))
		head = /obj/item/clothing/head/roguetown/chaperon/greyscale/elder
		shirt = /obj/item/clothing/suit/roguetown/shirt/tunic
		gloves = /obj/item/clothing/gloves/roguetown/leather
