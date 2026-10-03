//A subtype of the melee goon. You're given the stunmace, which allows access off of Rockhill.
//Additionally, one of the rarer weapon types, the maul, as a choice.
//Expert unarmed to top it off. Make sah proud.
//In exchange, you're slower. Much slower. Both in matters of speed or otherwise.
/datum/advclass/manorguard/gormless
	name = "Catchpole"
	tutorial = "Not quite the professional. Not quite the soldier. More akin to a brute they've given a hammer, some leftover equipment and told to face the enemy. \
	Yet, you've proven yourself more reliable than disposable. More than most can say."
	outfit = /datum/outfit/job/roguetown/manorguard/gormless

	category_tags = list(CTAG_MENATARMS)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	stat_budget = STAT_BUDGET_MID
	favored_stats = list(STATKEY_STR = STAT_VERY_FAVORED, STATKEY_CON = STAT_VERY_FAVORED, STATKEY_WIL = STAT_FAVORED, STATKEY_SPD = STAT_DISFAVORED, STATKEY_INT = STAT_VERY_DISFAVORED)
	subclass_skills = list(//You get no reading, m'lord. Go smack a dummy with a book, if you don't like soul.
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/manorguard/gormless/pre_equip(mob/living/carbon/human/H)
	..()

	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	wrists = /obj/item/clothing/wrists/roguetown/splintarms/iron
	pants = /obj/item/clothing/under/roguetown/splintlegs/iron
	beltl = /obj/item/rogueweapon/mace/cudgel
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Stunmace & Shield","Maul - 14STR Minimum")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Stunmace & Shield")
				r_hand = /obj/item/rogueweapon/mace/stunmace
				backl = /obj/item/rogueweapon/shield/iron
			if("Maul - 14STR Minimum")
				r_hand = /obj/item/rogueweapon/mace/maul
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.change_stat(STATKEY_STR, 1) /// so even without a strength-specific statpack, you can at least use the weapon. With one, it allows great maul just like on city guard.
				H.change_stat(STATKEY_SPD, -1)
				H.change_stat(STATKEY_INT, -1)

	backpack_contents = list(//Iron dagger and ale instead of red.
		/obj/item/rogueweapon/huntingknife/idagger = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/guardcastle = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/beer = 1,
		)

	H.verbs |= /mob/proc/haltyell

//All iron exclusive, as with the armour.
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
