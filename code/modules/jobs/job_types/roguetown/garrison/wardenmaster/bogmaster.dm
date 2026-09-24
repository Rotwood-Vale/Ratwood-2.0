/datum/advclass/wardenmaster/bogmaster
	name = "Bogmaster"
	examine_name = "Bogmaster"
	tutorial = "You're the Bogmaster of Lowtown; employed by the Baron to protect its residents and stand as a wall between the Duchy and the Bog.\
	 You've seen enough, lived enough, fought enough to master the Bog. Do not let your comrades get lost in its putrid depths."
	outfit = /datum/outfit/job/roguetown/wardenmaster/bogmaster
	cmode_music = 'sound/music/combat_hornofthebeast.ogg'
	category_tags = list(CTAG_BOGMASTER)
	traits_applied = list(
		TRAIT_STEELHEARTED,
		TRAIT_MEDIUMARMOR,
		TRAIT_PERFECT_TRACKER,
		TRAIT_OUTDOORSMAN,
		TRAIT_WOODSMAN,
		TRAIT_SURVIVAL_EXPERT
		)
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_CON = 2,
		STATKEY_STR = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
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
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
	)
/datum/outfit/job/roguetown/wardenmaster/bogmaster/pre_equip(mob/living/carbon/human/H)
	..()
	has_loadout = TRUE
	neck = /obj/item/clothing/neck/roguetown/bevor
	cloak = /obj/item/clothing/cloak/forrestercloak/snow/wardenmaster
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded/warden/melee
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/chainlegs
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/chain
	belt = /obj/item/storage/belt/rogue/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/garrison
	r_hand = /obj/item/rogueweapon/greataxe/steel/oath
	l_hand = /obj/item/rogueweapon/scabbard/gwstrap

	if(H.mind)
		var/weapons = list("Steel Messer","Steel Mace","Warden Axe")
		var/weapon_choice = input(H,"CHOOSE YOUR SIDEARM.", "YOU'RE NOT ALONE") as anything in weapons
		switch(weapon_choice)
			if("Steel Messer")
				beltl = /obj/item/rogueweapon/sword/short/messer
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 3, TRUE)
			if("Steel Mace")
				beltl = /obj/item/rogueweapon/mace/steel
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 3, TRUE)
			if("Warden Axe")
				beltl = /obj/item/rogueweapon/stoneaxe/woodcut/wardenpick
		var/helmets = list(
			"Antlers of the Antelope"   = /obj/item/clothing/head/roguetown/helmet/bascinet/antler/melee,
			"Skull of the Volf"         = /obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf/melee,
			"Skull of the Ram"          = /obj/item/clothing/head/roguetown/helmet/sallet/warden/goat/melee,
			"Skull of the Bear"         = /obj/item/clothing/head/roguetown/helmet/sallet/warden/bear/melee,
			"None"
	)
		var/helmchoice = input(H, "Choose your Path.", "HELMET SELECTION") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]
