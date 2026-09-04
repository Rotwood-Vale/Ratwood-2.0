// Special old man exclusive subclass from old RW.
/datum/advclass/manorguard/retainer
	name = "Retainer"
	tutorial = "You are an aging man-at-arms who has spent decades in faithful service. Though the vigor of youth has faded, discipline and experience remain."
	outfit = /datum/outfit/job/roguetown/manorguard/retainer
	allowed_ages = list(AGE_OLD)
	category_tags = list(CTAG_MENATARMS)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 1,// seems kinda lame but remember guardsman bonus!!
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 2,
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,// Jack of all trades, at least compared to other guardsmen.
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,// You'l always be good with your sword.
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/slings = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,// A bone.
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
	)
	extra_context = "This subclass gains Expert skill in their weapon of choice, but always retains Expert in swords to utilize their decorated arming sword."

/datum/outfit/job/roguetown/manorguard/retainer/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
	pants = /obj/item/clothing/under/roguetown/chainlegs
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/chain
	beltr = /obj/item/rogueweapon/scabbard
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Arming Sword & Shield","Axe & Shield","Flail & Shield","Warhammer & Shield","Greataxe","Halberd")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Arming Sword & Shield")// It'd be kind of funny if they got dual wielder, but no.
				H.put_in_hands(new /obj/item/rogueweapon/sword(H), TRUE, forced = TRUE)
				backl = /obj/item/rogueweapon/shield/iron
				beltl = /obj/item/rogueweapon/scabbard
			if("Axe & Shield")
				H.put_in_hands(new /obj/item/rogueweapon/stoneaxe/woodcut/steel(H), TRUE, forced = TRUE)
				backl = /obj/item/rogueweapon/shield/iron
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
			if("Flail & Shield")
				H.put_in_hands(new /obj/item/rogueweapon/flail/sflail(H), TRUE, forced = TRUE)
				backl = /obj/item/rogueweapon/shield/iron
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
			if("Warhammer & Shield")
				H.put_in_hands(new /obj/item/rogueweapon/mace/warhammer/steel(H), TRUE, forced = TRUE)
				backl = /obj/item/rogueweapon/shield/iron
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			if("Greataxe")
				H.put_in_hands(new /obj/item/rogueweapon/greataxe(H), TRUE, forced = TRUE)
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
			if("Halberd")
				H.put_in_hands(new /obj/item/rogueweapon/halberd(H), TRUE, forced = TRUE)
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)

		H.put_in_hands(new /obj/item/rogueweapon/sword/decorated(H), TRUE, forced = TRUE)// Your special old man sword.

		backpack_contents = list(
			/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
			/obj/item/rogueweapon/mace/cudgel = 1,
			/obj/item/rope/chain = 1,
			/obj/item/storage/keyring/guardcastle = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
			)
		H.verbs |= /mob/proc/haltyell

		var/helmets = list(
		"Simple Helmet" 	= /obj/item/clothing/head/roguetown/helmet,
		"Kettle Helmet" 	= /obj/item/clothing/head/roguetown/helmet/kettle,
		"Bascinet Helmet"		= /obj/item/clothing/head/roguetown/helmet/bascinet,
		"Sallet Helmet"		= /obj/item/clothing/head/roguetown/helmet/sallet,
		"Winged Helmet" 	= /obj/item/clothing/head/roguetown/helmet/winged,
		"Skull Cap"			= /obj/item/clothing/head/roguetown/helmet/skullcap,
		"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]
