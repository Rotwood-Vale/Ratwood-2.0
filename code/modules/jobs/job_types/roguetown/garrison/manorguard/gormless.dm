// You're the corn-fed brute they keep around solely to smash people into pulps.
/datum/advclass/manorguard/gormless
	name = "Catchpole"
	tutorial = "Not quite the professional. Not quite the soldier. More akin to a brute they've given a bludgeon, some leftover equipment and told to face the enemy. \
	Yet, you've proven yourself more reliable than disposable. More than most can say."
	outfit = /datum/outfit/job/roguetown/manorguard/gormless

	category_tags = list(CTAG_MENATARMS)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_CON = 4,// Stat weight of FOUR. All in on brawn.
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = -2,
		STATKEY_SPD = -2
	)
	subclass_skills = list(// No reading. No medicine. You're a dumbass who smashes people, smashes things, and smashes things into people.
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,// I CAN SMELL THEM
	)
	extra_context = "This subclass cannot read."

/datum/outfit/job/roguetown/manorguard/gormless/pre_equip(mob/living/carbon/human/H)
	..()

	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	wrists = /obj/item/clothing/wrists/roguetown/splintarms/iron
	pants = /obj/item/clothing/under/roguetown/splintlegs/iron
	beltr = /obj/item/rogueweapon/mace/stunmace// You can have this.
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("KNUCKLEDUSTERS!!","Mace & Shield","Maul - +1 STR, -1 SPD, -1 INT")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("KNUCKLEDUSTERS!!")// Impractical compared to the other options. An impractical weapon for an impractical man.
				H.put_in_hands(new /obj/item/rogueweapon/knuckles(H), TRUE, forced = TRUE)
			if("Mace & Shield")
				H.put_in_hands(new /obj/item/rogueweapon/mace/steel(H), TRUE, forced = TRUE)
				backl = /obj/item/rogueweapon/shield/iron
			if("Maul - +1 STR, -1 SPD, -1 INT")
				H.put_in_hands(new /obj/item/rogueweapon/mace/maul(H), TRUE, forced = TRUE)
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.change_stat(STATKEY_STR, 1)// To physically wield it.
				H.change_stat(STATKEY_SPD, -1)
				H.change_stat(STATKEY_INT, -1)

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/guardcastle = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)

	H.verbs |= /mob/proc/haltyell

	if(H.mind)
		var/helmets = list(
		"Kettle Helmet" 	= /obj/item/clothing/head/roguetown/helmet/kettle/iron,
		"Sallet Helmet"		= /obj/item/clothing/head/roguetown/helmet/sallet/iron,
		"Horned Helmet" 	= /obj/item/clothing/head/roguetown/helmet/horned,
		"Skull Cap"			= /obj/item/clothing/head/roguetown/helmet/skullcap,
		"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]
