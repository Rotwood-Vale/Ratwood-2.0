//A subtype of the melee goon. You're given the stunmace, which allows access off of Rockhill.
//Additionally, one of the rarer weapon types, the maul, as a choice.
//Expert unarmed to top it off. Make sah proud.
//In exchange, you're slower. Much slower. Both in matters of speed or otherwise.
/datum/advclass/manorguard/gormless
	name = "Catchpole"
	tutorial = "You're a catchpole, the big muscled brute sent out when intimidating some whiny shopkeep is needed, heads need crushing, or legs need breaking, the big plated juggernaut with the big weapons. Of course, it's expensive wrapping a form like yours in steel, and all that fancy shite goes to the knights, so you've been cheaped out, but you do more with less than most of your colleagues. May your lord feel safe and sound by your metal clad form."
	outfit = /datum/outfit/job/roguetown/manorguard/gormless
	//Imagine the ironclad adventurer, or the sellknight merc, but spiffed up in service of the duke.
	category_tags = list(CTAG_MENATARMS)
	traits_applied = list(TRAIT_HEAVYARMOR) //I know the risk of this, they get iron half-plate at the start, and they're usually too poor to get their hands on steel full-plate. Give players the benefit of the doubt that they won't powergame this. 
	subclass_stats = list(
		STATKEY_CON = 2,
		STATKEY_STR = 3,
		STATKEY_WIL = 2,
		STATKEY_INT = -1,
		STATKEY_SPD = -1,
	)
	// Before you geek, and/or freek out, this has... identical stat weight, to the footman. If you count STR and SPD as two, then you get.
	// 7 without buff, and an extra 6 from the buff, compared to the old statweight of... 3, which was unimpressive given that this is a man-at-arms.
	// 3 STR by default because this is THE big motherfucker subclass for MAA, regardless of weaponchoice.
	// Preparing for minmaxxing, assuming a struggler in the manor with the guard buff, they'll have 15STR 15CON 15WIL 9SPD 8FOR 7PER 6INT which is fine.
	maximum_possible_slots = 2 // We don't want our whole manor guard being catchpoles, for balance purposes, both balance as in "I don't wanna get beaten to death by four plateclad brutes" and "I want the manor guard force to be versatile, not just dipstick heavy melee fighters"
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)
	//Literacy is here, considering the prevalence of education in the setting, and the fact this is a MANOR guard, not just some street dweller. 
	//Also you need it to shop at the commissioner. Anyone who wants to be illiterate could probs just larp it.
	//Just because you're big and strong doesn't mean you're THAT much of a dumbcarcker. I mean, you're a bit, but eh.
	//As for weapon skills, you're Jman with all the big brutal weapons, an apprentice with swords, cause hitting things translates pretty easily and an expert at the weapon you choose. Whips and flails are too dextrous for you.
	//The ONLY thing you really know how to do at all, is fight.
	//No swimming for you, Frederick Barbarossa.
/datum/outfit/job/roguetown/manorguard/gormless/pre_equip(mob/living/carbon/human/H)
	..()
	//Bit of a warning, a bunch of steel stuff is in the armory that will be grabbed nearly immediately. This is a concern I took into account doing balance.
	armor = /obj/item/clothing/suit/roguetown/armor/plate/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron 
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	wrists = /obj/item/clothing/wrists/roguetown/splintarms/iron
	pants = /obj/item/clothing/under/roguetown/splintlegs/iron
	beltl = /obj/item/rogueweapon/mace/cudgel
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Stunmace & Shield","Mace & Shield","Warhammer & Shield","Wood axe & Shield","Maul - 14STR Minimum","Greataxe","Lucerne")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Stunmace & Shield") // Considered removing this because the stunmace is not good.
				r_hand = /obj/item/rogueweapon/mace/stunmace
				backl = /obj/item/rogueweapon/shield/tower
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			if("Mace & Shield")
				r_hand = /obj/item/rogueweapon/mace
				backl = /obj/item/rogueweapon/shield/tower
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			if("Warhammer & Shield")
				r_hand = /obj/item/rogueweapon/mace/warhammer
				backl = /obj/item/rogueweapon/shield/tower
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			if("Woodcutting Axe & Shield")
				r_hand = /obj/item/rogueweapon/stoneaxe/woodcut
				backl = /obj/item/rogueweapon/shield/tower
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
			if("Maul - 14STR Minimum") //Needs a statpack with at least +1 STR to use, same as it used to be. No longer does choosing the maul buff you.
				r_hand = /obj/item/rogueweapon/mace/maul
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			if("Greataxe")
				r_hand = /obj/item/rogueweapon/greataxe
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
			if("Lucerne")
				r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			if("Executioner's Sword")
				r_hand = /obj/item/rogueweapon/sword/long/exe
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE) //I saw this on the ironclad adventurer and was like... Damn the catchpole should have that.
	backpack_contents = list(//Iron dagger and ale instead of red.
		/obj/item/rogueweapon/huntingknife/idagger = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/guardcastle = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/beer = 1, //I'm shocked the catchpole gets booze instead of red, and I'm keeping it because it's aura. "We gave you this fancy armor, if you get it broken then you've already fucked up." type shit.
		)

	H.verbs |= /mob/proc/haltyell

//All iron exclusive, as with the armour.
	if(H.mind)
		var/helmets = list(
		"Iron Visored Sallet" 	= /obj/item/clothing/head/roguetown/helmet/sallet/visored/iron,
		"Iron Bucket Helm" = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron,
		"Iron Knight's Helmet, you poser" = /obj/item/clothing/head/roguetown/helmet/heavy/knight/iron,
		"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]
