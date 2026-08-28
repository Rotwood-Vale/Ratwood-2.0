/datum/advclass/sedeentwatchman
	name = "Militia Watchman"
	flag = SEDEENTWATCHMAN
	tutorial = "You are a watchman of the Sedeent Militia, you are tasked with ensuring the exiles stay on the island."
	outfit = /datum/outfit/job/roguetown/sedeentwatchman
	department_flag = GARRISON
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	give_bank_account = 15
	min_pq = 0
	max_pq = null
	round_contrib_points = 2
	advclass_cat_rolls = list(CAT_SEDEENTWATCHMAN = 2)
	display_order = JDO_WATCHMAN
	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)
	category_tags = list(CTAG_SEDEENTWATCHMAN)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
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
		/datum/skill/craft/cooking = 1,
	)

/datum/outfit/job/roguetown/sedeentwatchman/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.verbs |= /mob/proc/haltyell_exhausting
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	cloak = /obj/item/clothing/cloak/stabard/surcoat/guard
	head = /obj/item/clothing/head/roguetown/helmet/kettle/
	if(SSmapping.current_map.map_name == "Rockhill")
		cloak = /obj/item/clothing/cloak/citywatch
		head = /obj/item/clothing/head/roguetown/helmet/kettle/citywatch
	if(SSmapping.current_map.map_name == "Desert Town")
		cloak = /obj/item/clothing/cloak/citywatch/janissary
		head = /obj/item/clothing/head/roguetown/helmet/janissaryhelm
		shoes = /obj/item/clothing/shoes/roguetown/shalal
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/zyb
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger,
		/obj/item/storage/belt/rogue/pouch,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/storage/keyring/guardcastle = 1,
		/obj/item/rogueweapon/hammer/iron,
		)
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Sword and Shield","Cudgel and Shield","Spear")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
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
