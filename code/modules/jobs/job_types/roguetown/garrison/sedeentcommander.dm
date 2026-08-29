/datum/job/roguetown/sedeentcommander
	title = "Militia Commander"
	flag = COMMANDER
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "You are the commander of the Militia at Sedeent, you protect the Mayor and command the Militia.\
		the denizens of the settlement look upon you for protection against the waves."
	display_order = JDO_COMMANDER
	round_contrib_points = 2
	social_rank = SOCIAL_RANK_YEOMAN
	outfit = /datum/outfit/job/roguetown/sedeentcommander
	always_show_on_latechoices = TRUE
	advclass_cat_rolls = list(
		CTAG_SEDEENTCOMMANDER = 2
	)
	give_bank_account = 25
	min_pq = 5
	max_pq = null
	job_traits = list(
		TRAIT_MEDIUMARMOR
	)
	job_subclasses = list(
		/datum/advclass/sedeentcommander/commander
	)


/datum/outfit/job/roguetown/sedeentcommander
	job_bitflag = BITFLAG_GARRISON


/datum/advclass/sedeentcommander/commander
	name = "Militia Commander"
	tutorial = "You are the commander of the Militia at Sedeent, you protect the Mayor and command the Militia.\
		The denizens of the settlement look upon you for protection against the waves."
	outfit = /datum/outfit/job/roguetown/sedeentcommander/commander
	category_tags = list(
		CTAG_SEDEENTCOMMANDER
	)

	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1
	)

	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/slings = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE
	)


/datum/outfit/job/roguetown/sedeentcommander/commander/pre_equip(mob/living/carbon/human/H)
	..()

	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	neck = /obj/item/clothing/neck/roguetown/gorget
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	beltl = /obj/item/rogueweapon/mace/cudgel
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/bad/garrison
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list(
			"Warhammer & Shield",
			"Axe & Shield",
			"Halberd",
			"Greataxe"
		)

		var/weapon_choice = input(
			H,
			"Choose your weapon.",
			"TAKE UP ARMS"
		) as anything in weapons
		H.set_blindness(0)

		switch(weapon_choice)

			if("Warhammer & Shield")
				beltr = /obj/item/rogueweapon/mace/warhammer
				backl = /obj/item/rogueweapon/shield/iron
			if("Axe & Shield")
				beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel
				backl = /obj/item/rogueweapon/shield/iron
			if("Halberd")
				r_hand = /obj/item/rogueweapon/halberd
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Greataxe")
				r_hand = /obj/item/rogueweapon/greataxe
				backl = /obj/item/rogueweapon/scabbard/gwstrap


	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/commanderseedent = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1
	)

	H.verbs |= /mob/proc/haltyell


	if(H.mind)
		var/armor_options = list(
			"Brigandine Set",
			"Maille Set"
		)

		var/armor_choice = input(
			H,
			"Choose your armor.",
			"TAKE UP ARMS"
		) as anything in armor_options

		switch(armor_choice)

			if("Brigandine Set")
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light/retinue
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
				wrists = /obj/item/clothing/wrists/roguetown/splintarms
				pants = /obj/item/clothing/under/roguetown/splintlegs

			if("Maille Set")
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				pants = /obj/item/clothing/under/roguetown/chainlegs


		var/helmets = list(
			"Kettle Helmet" = /obj/item/clothing/head/roguetown/helmet/kettle,
			"Militia Helmet" = /obj/item/clothing/head/roguetown/helmet/citywatch/sedeent,
		)

		var/helmchoice = input(
			H,
			"Choose your Helm.",
			"TAKE UP HELMS"
		) as anything in helmets

		if(helmchoice != "None")
			head = helmets[helmchoice]
