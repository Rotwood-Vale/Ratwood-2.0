//CON/WIL with a saiga. A polearm footman but not actually.
//An odd combination of stats and skills, rounded out by a saiga and the funny riding trait.
/datum/advclass/manorguard/cavalry
	name = "Cavalryman"
	tutorial = "You are a professional soldier of the realm, specializing in the steady beat of hoof falls. Lighter and more expendable then the knights, you charge with lance in hand."
	outfit = /datum/outfit/job/roguetown/manorguard/cavalry
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled //Since knights start with the Buck

	category_tags = list(CTAG_MENATARMS)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_EQUESTRIAN)
	//Garrison mounted class; charge and charge often.
	subclass_stats = list(
		STATKEY_CON = 2,// seems kinda lame but remember guardsman bonus!!
		STATKEY_WIL = 2,// Your name is speed, and speed is running.
		STATKEY_STR = 1,
		STATKEY_INT = 1, // No strength to account for the nominally better weapons. We'll see.
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN, 		// Still have a cugel.
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,	//Best whip training out of MAAs, they're strong.
		/datum/skill/combat/bows = SKILL_LEVEL_NOVICE,			// We discourage horse archers, though.
		/datum/skill/combat/slings = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT, 		// Like the other horselords.
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,	//Best tracker. Might as well give it something to stick-out utility wise.
	)

/datum/outfit/job/roguetown/manorguard/cavalry/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/gorget
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Bardiche","Sword & Shield")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Bardiche")
				r_hand = /obj/item/rogueweapon/halberd/bardiche
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Sword & Shield")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/sabre
				backl = /obj/item/rogueweapon/shield/wood

		backpack_contents = list(
			/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
			/obj/item/rope/chain = 1,
			/obj/item/storage/keyring/guardcastle = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
			)
		H.verbs |= /mob/proc/haltyell

		var/armor_options = list("Brigandine Set", "Maille Set")
		var/armor_choice = input(H, "Choose your armor.", "TAKE UP ARMS") as anything in armor_options

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
