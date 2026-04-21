// In exchange for martial skills beyond ranged, they can now set traps, too.
/datum/advclass/janissary/zephyr
	name = "Janissary Zephyr"
	tutorial = "You are a professional soldier of the realm, specializing in ranged implements. You sport a keen eye, looking for your enemies weaknesses."
	outfit = /datum/outfit/job/roguetown/janissary/zephyr

	category_tags = list(CTAG_JANISSARY)
	subclass_stats = list(
		STATKEY_SPD = 2,// seems kinda lame but remember guardsman bonus!!
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		traits_applied = list(TRAIT_DODGEEXPERT))

	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/bows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/slings = SKILL_LEVEL_MASTER,//Your entire point is ranged.
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,//You get a knife, just in case.
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,//And can double in maces and swords.
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN, //slave patrol!
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
	)
	extra_context = "Can set traps."

/datum/outfit/job/roguetown/janissary/zephyr/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	pants = /obj/item/clothing/under/roguetown/splintlegs
	wrists = /obj/item/clothing/wrists/roguetown/splintarms
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/zyb
	head = /obj/item/clothing/head/roguetown/helmet/janissaryhelm
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/guardcastle = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Crossbow","Bow","Sling")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		var/armor_options = list("Light Armor", "Medium Armor")
		var/armor_choice = input(H, "Choose your armor.", "TAKE UP ARMS") as anything in armor_options
		H.set_blindness(0)
		switch(weapon_choice)
			if("Crossbow")
				beltr = /obj/item/quiver/bolts
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			if("Bow") // They can head down to the armory to sideshift into one of the other bows.
				beltr = /obj/item/quiver/arrows
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			if("Sling")
				beltr = /obj/item/quiver/sling/iron
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling // Both are belt slots and it's not worth setting where the cugel goes for everyone else, sad.
				
		var/weapons2 = list("Scimitar","Whip","Club")
		var/weapon_choice2 = input(H, "Choose your sidearm.", "TAKE UP ARMS") as anything in weapons2
		switch(weapon_choice2)
			if("Scimitar")
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/saber/iron
			if("Whip") // They can head down to the armory to sideshift into one of the other bows.
				beltl = /obj/item/rogueweapon/whip
			if("Club")
				beltl = /obj/item/rogueweapon/mace/cudgel

		switch(armor_choice)
			if("Light Armor")
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/zyb
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			if("Medium Armor")
				armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/janissary
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

		H.verbs |= /mob/proc/haltyell
		//Skirmishers get funny spells. Wowzers.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/skirmisher_trap)
