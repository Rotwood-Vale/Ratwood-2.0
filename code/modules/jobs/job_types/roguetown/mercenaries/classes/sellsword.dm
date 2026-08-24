/datum/advclass/mercenary/sellsword
	name = "Sellsword"
	tutorial = "You are a common sellsword, regarded as scum by many. You have travelled from contract to contract as a bodyguard, mercenary, or cutthroat. No homeland or famous company defines you; only the armor you could afford, the weapon you mastered, and the mammons in your pouch."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/sellsword
	class_select_category = CLASS_CAT_UNALIGNED
	category_tags = list(CTAG_MERCENARY)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 1,
		STATKEY_CON = 1,
		STATKEY_PER = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN
	)
	extra_context = "Choose light, medium, or heavy armor, then specialize in one of thirteen weapons. Light armor also grants a choice of one small utility item."

/datum/outfit/job/roguetown/mercenary/sellsword/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()

	var/armor_choice = "Medium Armor"
	var/weapon_choice = "Bastard Sword"
	var/goodie_choice = "Extra Dagger"

	if(H.mind && !visualsOnly)
		H.adjust_blindness(-3)

		var/list/armor_styles = list("Light Armor", "Medium Armor", "Heavy Armor")
		var/selected_armor = input(H, "Choose your armor.", "TOOLS OF THE TRADE") as anything in armor_styles
		if(selected_armor)
			armor_choice = selected_armor

		var/list/weapons = list(
			"Bastard Sword",
			"Billhook",
			"Bow",
			"Crossbow",
			"Cutlass",
			"Dual Daggers",
			"Flail",
			"Iron Mace",
			"Rapier",
			"Sabre",
			"Short Sword",
			"Spear",
			"Steel Axe"
		)
		var/selected_weapon = input(H, "Choose your weapon.", "TOOLS OF THE TRADE") as anything in weapons
		if(selected_weapon)
			weapon_choice = selected_weapon

		if(armor_choice == "Light Armor")
			var/list/goodies = list("Extra Dagger", "Smoke Bomb", "Small Health Vial")
			var/selected_goodie = input(H, "Choose one extra item.", "TOOLS OF THE TRADE") as anything in goodies
			if(selected_goodie)
				goodie_choice = selected_goodie

		H.set_blindness(0)

	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
	)

	switch(armor_choice)
		if("Light Armor")
			to_chat(H, span_warning("'Can't cut what you can't hit' has always been your motto. Light armor and hard-earned reflexes keep you alive."))
			head = /obj/item/clothing/head/roguetown/helmet/leather
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			gloves = /obj/item/clothing/gloves/roguetown/leather
			armor = /obj/item/clothing/suit/roguetown/armor/leather
			pants = /obj/item/clothing/under/roguetown/trou/leather
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)

			switch(goodie_choice)
				if("Extra Dagger")
					backpack_contents[/obj/item/rogueweapon/huntingknife/idagger] = 1
				if("Smoke Bomb")
					backpack_contents[/obj/item/grenade/smokebomb] = 1
				if("Small Health Vial")
					backpack_contents[/obj/item/reagent_containers/glass/bottle/alchemical/healthpot] = 1

		if("Medium Armor")
			to_chat(H, span_warning("You favor a reliable middle ground: affordable maille with enough coverage to survive a proper melee."))
			head = /obj/item/clothing/head/roguetown/helmet/sallet
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
			neck = /obj/item/clothing/neck/roguetown/gorget
			gloves = /obj/item/clothing/gloves/roguetown/chain
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
			pants = /obj/item/clothing/under/roguetown/tights/black
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

		if("Heavy Armor")
			to_chat(H, span_warning("You spent every spare mammon on plate and maille. Your body is protected, but your exposed head and neck remain an honest weakness."))
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
			pants = /obj/item/clothing/under/roguetown/chainlegs/iron
			belt = /obj/item/storage/belt/rogue/leather/black
			armor = /obj/item/clothing/suit/roguetown/armor/brigandine/coatplates
			gloves = /obj/item/clothing/gloves/roguetown/leather/black
			ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

	switch(weapon_choice)
		if("Bastard Sword")
			r_hand = /obj/item/rogueweapon/sword/long
			beltl = /obj/item/rogueweapon/scabbard/sword
			if(H.mind)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)

		if("Billhook")
			r_hand = /obj/item/rogueweapon/spear/billhook
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			if(H.mind)
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)

		if("Bow")
			backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
			beltr = /obj/item/quiver/arrows
			if(H.mind)
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
			H.change_stat(STATKEY_PER, 1)
			H.change_stat(STATKEY_STR, -1)

		if("Crossbow")
			backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			beltr = /obj/item/quiver/bolts
			if(H.mind)
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
			H.change_stat(STATKEY_PER, 1)
			H.change_stat(STATKEY_STR, -1)

		if("Cutlass")
			r_hand = /obj/item/rogueweapon/sword/cutlass
			beltl = /obj/item/rogueweapon/scabbard/sword
			if(H.mind)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)

		if("Dual Daggers")
			beltl = /obj/item/rogueweapon/huntingknife/idagger
			beltr = /obj/item/rogueweapon/huntingknife/idagger
			if(H.mind)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)

		if("Flail")
			beltr = /obj/item/rogueweapon/flail
			if(H.mind)
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)

		if("Iron Mace")
			beltr = /obj/item/rogueweapon/mace
			if(H.mind)
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)

		if("Rapier")
			r_hand = /obj/item/rogueweapon/sword/rapier
			beltl = /obj/item/rogueweapon/scabbard/sword
			if(H.mind)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)

		if("Sabre")
			r_hand = /obj/item/rogueweapon/sword/sabre
			beltl = /obj/item/rogueweapon/scabbard/sword
			if(H.mind)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)

		if("Short Sword")
			r_hand = /obj/item/rogueweapon/sword/short
			beltl = /obj/item/rogueweapon/scabbard/sword
			if(H.mind)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)

		if("Spear")
			r_hand = /obj/item/rogueweapon/spear
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			if(H.mind)
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)

		if("Steel Axe")
			beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel
			if(H.mind)
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)

	H.merctype = 0
