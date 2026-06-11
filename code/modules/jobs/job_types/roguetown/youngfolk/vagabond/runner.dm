/datum/advclass/vagabond_runner
	name = "亡命信使"
	examine_name = "乞儿"
	tutorial = "在黑暗中替人传讯本就是刀口舔血的差事。你能活着从上一次险境里脱身，已经算是走运了；如今你手里剩下的，不过是几件破衣和一双还能跑路的脚。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/vagabond/runner
	category_tags = list(CTAG_VAGABOND)
	subclass_social_rank = SOCIAL_RANK_PEASANT
	subclass_stats = list(
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_INT = -2
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/vagabond/runner/pre_equip(mob/living/carbon/human/H)
	..()
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/vagrant
		if(prob(50))
			pants = /obj/item/clothing/under/roguetown/tights/vagrant/l
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
		if(prob(50))
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l

	if(prob(33))
		cloak = /obj/item/clothing/cloak/raincloak/brown
		gloves = /obj/item/clothing/gloves/roguetown/fingerless

	if(prob(10))
		r_hand = /obj/item/rogue/instrument/flute
