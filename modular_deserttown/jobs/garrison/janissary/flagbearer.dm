/datum/advclass/janissary/flagbearer
	name = "旗手"
	tutorial = "你是军士长的副手，受命在出征时执掌宫廷旗帜。只要旗帜不倒，你的战友们便知道该向何处集结。"
	outfit = /datum/outfit/job/roguetown/janissary/flagbearer
	category_tags = list(CTAG_JANISSARY)
	traits_applied = list(TRAIT_CRITICAL_RESISTANCE, TRAIT_STANDARD_BEARER)
	subclass_stats = list(
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)
	maximum_possible_slots = 1

/datum/outfit/job/roguetown/janissary/flagbearer/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/helmet/janissaryhelm
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/janissary
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/zyb
	wrists = /obj/item/clothing/wrists/roguetown/splintarms
	pants = /obj/item/clothing/under/roguetown/splintlegs
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/guardcastle = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)
	H.verbs |= /mob/proc/haltyell

	if(H.mind)
		var/weapons = list("长矛","戟斧")
		var/weapon_choice = input(H, "选择你的武器：", "拿起武器") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("长矛")
				r_hand = /obj/item/rogueweapon/spear/keep_standard
			if("戟斧")
				r_hand = /obj/item/rogueweapon/spear/keep_standard/poleaxe
