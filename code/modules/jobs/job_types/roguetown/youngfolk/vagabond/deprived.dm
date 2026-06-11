/datum/advclass/vagabond_deprived
	name = "失乡者"
	examine_name = "乞丐"
	tutorial = "你如今只剩下那面可信的盾和一根木棒。战争夺走了你拥有的一切，但你究竟还能夺回本该属于自己的东西，还是终会屈服于 普赛多尼亚 的恐怖之下？"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/vagabond/deprived
	category_tags = list(CTAG_VAGABOND)
	subclass_stats = list(
		STATKEY_LCK = 3
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/vagabond/deprived/pre_equip(mob/living/carbon/human/H)
	..()
	l_hand = /obj/item/rogueweapon/shield/wood
	r_hand = /obj/item/rogueweapon/mace/woodclub
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/loincloth
