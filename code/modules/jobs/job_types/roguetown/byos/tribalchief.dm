
/datum/job/roguetown/tribalchieftain
	title = "Chieftain"
	f_title = "Tribe Chieftess"
	flag = TRIBALCHIEFTAIN
	department_flag = TRIBAL
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = JCOLOR_TRIBAL
	allowed_races = list(/datum/species/goblinp, /datum/species/anthromorphsmall, /datum/species/kobold, /datum/species/dracon, /datum/species/halforc)
	tutorial = "You're the Chief of the local island tribe. A representation of The Dragon's rule, as you are the biggest and strongest. You ensure the spread of his dominion over others where you can, while ensuring none disturb his slumber. \
	There's news of an arriving duchy seeking to lay claim to The Dragon's island. \
	Have your subjects sneak through the caves and elsewhere, robbing and kidnapping passersby. Spread His will upon the weak fools. Bring gold and slaves to your tribe in The Dragon's name!"
	allowed_sexes = list(MALE, FEMALE)
	advclass_cat_rolls = list(CTAG_TRIBALCHIEFTAIN = 20)

	spells = list(
		/obj/effect/proc_holder/spell/self/grant_title,
		// /obj/effect/proc_holder/spell/self/convertrole/servant,
		// /obj/effect/proc_holder/spell/self/convertrole/guard,
		// /obj/effect/proc_holder/spell/self/grant_nobility,
		// /obj/effect/proc_holder/spell/self/convertrole/bog
	)
	outfit = /datum/outfit/job/roguetown/tribalchieftain

	display_order = JDO_TRIBALCHIEFTAIN
	whitelist_req = FALSE
	min_pq = 10
	max_pq = null
	round_contrib_points = 4
	give_bank_account = 1000
	required = TRUE
	cmode_music = 'sound/music/combat_hornofthebeast.ogg'
	// social_rank = SOCIAL_RANK_ROYAL
	// Can't use the Throat when you can't talk properly or.. at all for that matter.
	vice_restrictions = list(/datum/charflaw/mute, /datum/charflaw/unintelligible)

	job_subclasses = list(
		/datum/advclass/tribalchieftain/warrior,
	)

/datum/outfit/job/roguetown/tribalchieftain
	// job_bitflag = BITFLAG_ROYALTY

/datum/outfit/job/roguetown/tribalchieftain
	head = /obj/item/clothing/head/roguetown/crown/byos
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	pants = /obj/item/clothing/under/roguetown/loincloth/brown
	shoes = /obj/item/clothing/shoes/roguetown/gladiator
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltl = /obj/item/storage/keyring/tribalchief

/datum/outfit/job/roguetown/tribalchieftain/pre_equip(mob/living/carbon/human/H)
	..()
	H.faction += list("orcs", "tribe")
	if(!H.has_language(/datum/language/draconic))
		H.grant_language(/datum/language/draconic)
	if(should_wear_femme_clothes(H))
		cloak = /obj/item/clothing/cloak/lordcloak/ladycloak
		shirt = /obj/item/clothing/suit/roguetown/shirt/tribalrag
	else if(should_wear_masc_clothes(H))
		cloak = /obj/item/clothing/cloak/lordcloak
	if(H.wear_mask)
		if(istype(H.wear_mask, /obj/item/clothing/mask/rogue/eyepatch))
			qdel(H.wear_mask)
			mask = /obj/item/clothing/mask/rogue/lordmask
		if(istype(H.wear_mask, /obj/item/clothing/mask/rogue/eyepatch/left))
			qdel(H.wear_mask)
			mask = /obj/item/clothing/mask/rogue/lordmask/l
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
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
				backr = /obj/item/rogueweapon/shield/tower // Both are belt slots and it's not worth setting where the cugel goes for everyone else, sad.
				
		var/weapons2 = list("Club","Mace","Axe")
		var/weapon_choice2 = input(H, "Choose your sidearm.", "TAKE UP ARMS") as anything in weapons2
		switch(weapon_choice2)
			if("Club")
				beltl = /obj/item/rogueweapon/mace/cudgel/shellrungu
			if("Axe")
				beltl = /obj/item/rogueweapon/stoneaxe/woodcut/steel/paaxe
			if("Mace")
				beltl = /obj/item/rogueweapon/mace/steel/palloy

/datum/advclass/tribalchieftain/warrior
	name = "Valiant Warrior"
	tutorial = "Ooga Chacka BESTA chacka!"
	// outfit = /datum/outfit/job/roguetown/tribalchieftain/warrior
	category_tags = list(CTAG_TRIBALCHIEFTAIN)
	traits_applied = list(TRAIT_DNR, TRAIT_HEAVYARMOR, TRAIT_TRIBAL, TRAIT_DARKVISION)
	subclass_stats = list(
		STATKEY_LCK = 5,
		STATKEY_INT = 3,
		STATKEY_WIL = 3,
		STATKEY_PER = 2,
		STATKEY_SPD = 1,
		STATKEY_STR = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)
