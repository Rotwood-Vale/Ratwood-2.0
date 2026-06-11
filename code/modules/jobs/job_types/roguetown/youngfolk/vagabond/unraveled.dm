/datum/advclass/vagabond_unraveled
	name = "心神崩解者"
	examine_name = "乞儿"
	tutorial = "你曾试图理解心智如何腐朽，如今却亲身活在这场腐朽之中，成了个被自身病痛束缚的流浪医者。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/vagabond/unraveled
	category_tags = list(CTAG_VAGABOND)
	traits_applied = list(TRAIT_PSYCHOSIS, TRAIT_NOSTINK)
	subclass_stats = list(
		STATKEY_INT = -2,
		STATKEY_LCK = -2,
	)
	subclass_skills = list(
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT
	)
	extra_context = "会持续产生幻觉。"

/datum/outfit/job/roguetown/vagabond/unraveled/pre_equip(mob/living/carbon/human/human)
	..()
	
	if(should_wear_femme_clothes(human))
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	
	pants = /obj/item/clothing/under/roguetown/loincloth
	r_hand = /obj/item/rogueweapon/woodstaff

	if(prob(33))
		cloak = /obj/item/clothing/cloak/half/brown
		gloves = /obj/item/clothing/gloves/roguetown/fingerless

	human.hallucination = INFINITY
