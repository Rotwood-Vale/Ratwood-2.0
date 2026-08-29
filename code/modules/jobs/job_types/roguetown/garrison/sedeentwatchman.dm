/datum/job/roguetown/sedeentwatchman
	title = "Militia Watchman"
	flag = WATCHMAN
	department_flag = GARRISON
	faction = "Station"

	total_positions = 2
	spawn_positions = 2

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)

	tutorial = "You are a watchman of the Sedeent Militia, you are tasked with ensuring the exiles stay on the island."

	display_order = JDO_WATCHMAN
	round_contrib_points = 2
	social_rank = SOCIAL_RANK_PEASANT
	always_show_on_latechoices = TRUE
	outfit = /datum/outfit/job/roguetown/sedeentwatchman

	advclass_cat_rolls = list(
		CTAG_SEDEENTWATCHMAN = 2
	)

	give_bank_account = 15
	min_pq = 0
	max_pq = null

	job_traits = list(
		TRAIT_MEDIUMARMOR
	)

	job_subclasses = list(
		/datum/advclass/sedeentwatchman/watchman
	)


/datum/outfit/job/roguetown/sedeentwatchman
	job_bitflag = BITFLAG_GARRISON


/datum/advclass/sedeentwatchman/watchman
	name = "Militia Watchman"

	tutorial = "You are a watchman of the Sedeent Militia, you are tasked with ensuring the exiles stay on the island."

	outfit = /datum/outfit/job/roguetown/sedeentwatchman/watchman

	category_tags = list(
		CTAG_SEDEENTWATCHMAN
	)

	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1
	)

	subclass_skills = list(
		/datum/skill/combat/shields = 2,
		/datum/skill/combat/maces = 3,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/polearms = 3,
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/medicine = 2,
		/datum/skill/misc/tracking = 2,
		/datum/skill/craft/crafting = 1,
		/datum/skill/craft/cooking = 1
	)


/datum/outfit/job/roguetown/sedeentwatchman/watchman/pre_equip(mob/living/carbon/human/H)
	. = ..()

	H.verbs |= /mob/proc/haltyell_exhausting

	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	cloak = /obj/item/clothing/cloak/citywatch/sedeent
	head = /obj/item/clothing/head/roguetown/helmet/citywatch/sedeent
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/bad/garrison

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger = 1,
		/obj/item/storage/belt/rogue/pouch = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/keyring/sedeentgarrison = 1,
		/obj/item/rogueweapon/hammer/iron = 1
	)

	H.adjust_blindness(-3)

	if(H.mind)
		var/weapons = list(
			"Sword and Shield",
			"Cudgel and Shield",
			"Spear"
		)

		var/weapon_choice = input(
			H,
			"Choose your weapon.",
			"TAKE UP ARMS"
		) as anything in weapons

		H.set_blindness(0)

		switch(weapon_choice)
			if("Sword and Shield")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/short/iron
				backl = /obj/item/rogueweapon/shield/iron

			if("Cudgel and Shield")
				r_hand = /obj/item/rogueweapon/mace/cudgel
				backl = /obj/item/rogueweapon/shield/iron

			if("Spear")
				r_hand = /obj/item/rogueweapon/spear
				backl = /obj/item/rogueweapon/scabbard/gwstrap
