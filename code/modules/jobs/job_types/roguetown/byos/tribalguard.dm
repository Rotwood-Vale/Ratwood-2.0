/datum/job/roguetown/tribalguard
	title = "Tribal Guard"
	flag = TRIBALGUARD
	department_flag = TRIBAL
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	selection_color = JCOLOR_TRIBAL

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/goblinp, /datum/species/anthromorphsmall, /datum/species/kobold)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	// tutorial = "Ooga Chacka Guard-a-Chacka."
	tutorial = "You're the hand of the Chief, and the iron claw of The Dragon. He's of higher power than any mortal. At least, that's what you've been taught. He is the biggest and strongest afterall. \
	Do what the Chief insists, while keeping order in the fort. Try not to venture out without the Chief's say-so. \
	'Tend' to captives when possible, instead of outright killing them."
	display_order = JDO_TRIBALGUARD
	whitelist_req = TRUE

	outfit = /datum/outfit/job/roguetown/tribalguard
	advclass_cat_rolls = list(CTAG_TRIBALGUARD = 20)

	min_pq = 0
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/combat_gronn.ogg'
	// cmode_music = 'sound/music/hornofthebeast.ogg'
	// social_rank = SOCIAL_RANK_PEASANT
	job_traits = list(TRAIT_OUTDOORSMAN, TRAIT_SURVIVAL_EXPERT, TRAIT_TRIBAL, TRAIT_DARKVISION)
	job_subclasses = list(
		/datum/advclass/tribalguard/hunter,
		/datum/advclass/tribalguard/warrior,
		/datum/advclass/tribalguard/savage)

/datum/outfit/job/roguetown/tribalguard
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/fur
	cloak = /obj/item/clothing/cloak/tribal
	belt = /obj/item/storage/belt/rogue/leather/rope
	backr = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/furlinedanklets

/datum/advclass/tribalguard/hunter
	name = "Hunter"
	tutorial = "Ooga Chacka Shoota-Chacka."
	outfit = /datum/outfit/job/roguetown/tribalguard/hunter
	category_tags = list(CTAG_TRIBALGUARD)
	traits_applied = list(TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_SPD = 2,
		STATKEY_WIL = 2
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/slings = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/tribalguard/hunter/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	neck = /obj/item/clothing/neck/roguetown/coif
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/armor/leather/hide/bikini
	pants = /obj/item/clothing/under/roguetown/trou/leather
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/padagger
	backpack_contents = list(
		/obj/item/roguekey/tribal = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)
	H.faction += list("orcs", "tribe")
	if(!H.has_language(/datum/language/draconic))
		H.grant_language(/datum/language/draconic)
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("Bow","Sling","Spear & Javelins")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Bow")
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				beltr = /obj/item/quiver/arrows
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/slings, 4, TRUE)
			if("Sling") 
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
				beltr = /obj/item/quiver/sling/paalloy
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/slings, 4, TRUE)
			if("Spear & Javelins") 
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/spear/paalloy
				beltr = /obj/item/quiver/javelin/paalloy
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 3, TRUE)
				H.change_stat(STATKEY_SPD, -1)
				H.change_stat(STATKEY_STR, 1)


/datum/advclass/tribalguard/warrior
	name = "Warrior"
	tutorial = "Ooga Chacka WHACKah-chacka!."
	// tutorial = "You're one of the Chief's trusted guards, though many just know you to be a brute. Strong, perhaps too strong, for your size. You've experience with all kinds of weapons, and unarmed combat."
	outfit = /datum/outfit/job/roguetown/tribalguard/warrior
	category_tags = list(CTAG_TRIBALGUARD)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_PER = 2
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/slings = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE, // This should let them fry meat on fires.
	)

/datum/outfit/job/roguetown/tribalguard/warrior/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/paalloy
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/paalloy
	pants = /obj/item/clothing/under/roguetown/trou/leather
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/padagger
	backpack_contents = list(
		/obj/item/roguekey/tribal = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		)
	H.verbs |= /mob/proc/haltyell
	H.faction += list("orcs", "tribe")
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("Ancient Bardiche","Ancient Greatmace","Ancient Spear & Shield", "Ancient Javelins & Shield")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Ancient Bardiche")
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/halberd/bardiche/paalloy
			if("Ancient Greatmace") 
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/mace/goden/steel/paalloy
			if("Ancient Spear & Shield") 
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/spear/paalloy
			if("Ancient Javelins & Shield")
				beltr = /obj/item/quiver/javelin/paalloy
				backl = /obj/item/rogueweapon/shield/tower
				
		var/weapons2 = list("Club","Mace","Axe")
		var/weapon_choice2 = input(H, "Choose your sidearm.", "TAKE UP ARMS") as anything in weapons2
		switch(weapon_choice2)
			if("Club")
				beltl = /obj/item/rogueweapon/mace/cudgel/shellrungu
			if("Axe")
				beltl = /obj/item/rogueweapon/stoneaxe/woodcut/steel/paaxe
			if("Mace")
				beltl = /obj/item/rogueweapon/mace/steel/palloy

/datum/advclass/tribalguard/savage
	name = "Savage"
	tutorial = "Ooga Chacka WHACKah-chacka!."
	// tutorial = "You're one of the Chief's trusted guards, though many just know you to be a brute. Strong, perhaps too strong, for your size. You've experience with all kinds of weapons, and unarmed combat."
	outfit = /datum/outfit/job/roguetown/tribalguard/savage
	category_tags = list(CTAG_TRIBALGUARD)
	traits_applied = list(TRAIT_CRITICAL_RESISTANCE, TRAIT_CIVILIZEDBARBARIAN, TRAIT_STRONGBITE)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_INT = -2,
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/slings = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE, // This should let them fry meat on fires.
	)

/datum/outfit/job/roguetown/tribalguard/savage/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/paalloy
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/paalloy
	pants = /obj/item/clothing/under/roguetown/trou/leather
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/barbarian
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/padagger
	if(should_wear_masc_clothes(H))
		H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
		backl = /obj/item/storage/backpack/rogue/satchel
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/armor/leather/bikini
		backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/tribal = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		)
	H.verbs |= /mob/proc/haltyell
	H.faction += list("orcs", "tribe")
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("Ancient Bardiche","Ancient Greatmace", "Ancient Javelins & Shield", "Maul - +STR/CON, -SPD/PER/INT")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Ancient Bardiche")
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/halberd/bardiche/paalloy
			if("Ancient Greatmace") 
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/mace/goden/steel/paalloy
			if("Ancient Javelins & Shield")
				beltr = /obj/item/quiver/javelin/paalloy
				backl = /obj/item/rogueweapon/shield/tower
			if("Maul - +STR/CON, -SPD/PER/INT")
				r_hand = /obj/item/rogueweapon/mace/maul
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.change_stat(STATKEY_STR, 1)
				H.change_stat(STATKEY_CON, 1)
				H.change_stat(STATKEY_SPD, -1)
				H.change_stat(STATKEY_PER, -1)
				H.change_stat(STATKEY_INT, -1)
				
		var/weapons2 = list("Club","Mace","Axe")
		var/weapon_choice2 = input(H, "Choose your sidearm.", "TAKE UP ARMS") as anything in weapons2
		switch(weapon_choice2)
			if("Club")
				beltl = /obj/item/rogueweapon/mace/cudgel/shellrungu
			if("Axe")
				beltl = /obj/item/rogueweapon/stoneaxe/woodcut/steel/paaxe
			if("Mace")
				beltl = /obj/item/rogueweapon/mace/steel/palloy
