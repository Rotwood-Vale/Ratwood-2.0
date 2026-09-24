/datum/advclass/wardenmaster/bogguard
	name = "Bogguard"
	examine_name = "Bogguard"
	tutorial = "Ancient. Experienced. You're one of the last remaining Bogguards; guardians of the now-lost forts of the Bogmen. Your loyalty yet persists.\
	You fought for too long, yet the mind remembers every blow, every slash, and every hardship. Your heart yet beats for Lowtown and those whom you swore to protect."
	outfit = /datum/outfit/job/roguetown/wardenmaster/bogguard
	allowed_ages = list(AGE_OLD) //It's..almost like the bogguard dont exist anymore.
	cmode_music = 'sound/music/cmode/antag/combat_thewall.ogg'
	category_tags = list(CTAG_BOGMASTER)
	traits_applied = list(
		TRAIT_STEELHEARTED,
		TRAIT_MEDIUMARMOR,
		TRAIT_PERFECT_TRACKER,
		TRAIT_OUTDOORSMAN,
		TRAIT_WOODSMAN,
		TRAIT_SURVIVAL_EXPERT,
		TRAIT_BADTRAINER //we don't want expert trained lowtown garrison.
		)
	subclass_stats = list(
		STATKEY_INT = 2,	//They have old age INT buff, yes.
		STATKEY_WIL = 2,	//But it also makes them weak as hell.
		STATKEY_STR = 1,	//Maybe nerfable because of masters, I think it's fine.
		STATKEY_CON = 1,	//No one plays old people anyhow.
		STATKEY_SPD = -1	//Maybe your knees are not good, though.
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT, // so they don't stam out after giving an order. might be a meme class, still needs a tad strength.
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
	)
/datum/outfit/job/roguetown/wardenmaster/bogguard/pre_equip(mob/living/carbon/human/H)
	..()
	has_loadout = TRUE
	neck = /obj/item/clothing/neck/roguetown/bevor
	cloak = /obj/item/clothing/cloak/tabard/knight/bogmaster
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/chainlegs
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	belt = /obj/item/storage/belt/rogue/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/garrison
	beltr = /obj/item/quiver/javelin/iron

	if(H.mind)
		var/weapons = list("Billhook","Broadsword","Steel Greataxe", "Warhammer & Shield")
		var/weapon_choice = input(H,"CHOOSE YOUR FRIEND", "ENDURE TOGETHER") as anything in weapons
		switch(weapon_choice)
			if("Billhook")
				r_hand = /obj/item/rogueweapon/spear/billhook
				l_hand = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 5, TRUE)
			if("Broadsword")
				r_hand = /obj/item/rogueweapon/sword/long/broadsword //FREEDOOOOOOOOOOOOOOOOOOOOM
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
			if("Steel Greataxe")
				r_hand = /obj/item/rogueweapon/greataxe/steel
				l_hand = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 5, TRUE)
			if("Warhammer & Shield")
				r_hand = /obj/item/rogueweapon/mace/warhammer
				l_hand = /obj/item/rogueweapon/shield/tower
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 5, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, 3, TRUE)
		var/helmets = list(
			"Bogman Helmet"   = /obj/item/clothing/head/roguetown/helmet/heavy/guard/bogman,
			"Heavy Kettle Helmet"         = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"None"
	)
		var/helmchoice = input(H, "Choose your lifeline.", "HELMET SELECTION") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]
