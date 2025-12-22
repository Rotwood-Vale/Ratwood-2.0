/datum/job/roguetown/rookie
	title = "Rookie"
	flag = ROOKIE
	department_flag = GARRISON
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)
	advclass_cat_rolls = list(CTAG_ROOKIE = 20)
	job_traits = list(TRAIT_SQUIRE_REPAIR)

	tutorial = "Odd-jobs, running messages, fixing dents and talking to locals; the Guard can always use a spare pair of hands, eyes and ears. Assist your fellow guards in dealing with threats - both within and without. \
				Given a brief introduction in weapons and guardwork, the rest of your training is to be picked up on the job. \
				Obey your superiors (your superiors being pretty much everyone with a jupon) and show the nobles your respect. Keep an eye out, try to learn a thing or two, then one day you might live to make an adequate soldier."
	outfit = /datum/outfit/job/roguetown/rookie
	display_order = JDO_SQUIRE
	give_bank_account = TRUE
	min_pq = 0 //starting role
	max_pq = null
	round_contrib_points = 2
	social_rank = SOCIAL_RANK_PEASANT

	cmode_music = 'sound/music/combat_ManAtArms.ogg'
	job_subclasses = list(
		/datum/advclass/rookie/frontline,
		/datum/advclass/rookie/backline
	)

/datum/outfit/job/roguetown/rookie
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	cloak = /obj/item/clothing/cloak/stabard/surcoat/guard
	id = /obj/item/scomstone/bad/garrison
	job_bitflag = BITFLAG_GARRISON

/datum/job/roguetown/rookie/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/stabard/surcoat/guard))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "rookie's tabard ([index])"

//
// 
/datum/advclass/rookie/frontline
	name = "Frontline Recruit"
	tutorial = "CHGANGE MEE!!"
	outfit = /datum/outfit/job/roguetown/rookie/footman

	category_tags = list(CTAG_ROOKIE)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting, SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking, SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/rookie/footman/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.verbs |= /mob/proc/haltyell_exhausting
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	gloves = /obj/item/clothing/gloves/roguetown/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger,
		/obj/item/storage/belt/rogue/pouch,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/storage/keyring/guardcastle = 1,
		)
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Iron Sword","Cudgel","Spear")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Iron Sword")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/short/iron
				backl = /obj/item/rogueweapon/shield
			if("Cudgel")
				beltr = /obj/item/rogueweapon/mace/cudgel
				backl = /obj/item/rogueweapon/shield
			if("Spear")
				r_hand = /obj/item/rogueweapon/spear// Helmet selection
				backl = /obj/item/rogueweapon/scabbard/gwstrap
		var/helmets = list(
			"Leather Helmet" = /obj/item/clothing/head/roguetown/helmet/leather,
			"Simple Helmet" = /obj/item/clothing/head/roguetown/helmet,
			"Kettle Helmet" = /obj/item/clothing/head/roguetown/helmet/kettle,
			"Skull Cap" = /obj/item/clothing/head/roguetown/helmet/skullcap,
			"None"
		)
		var/helmchoice = input(H, "Choose your helmet.", "HEAD PROTECTION") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

		// Trade selection
		var/trades = list("Healer","Farmhand","Clothworker","Craftsman","Urchin")
		var/trade_choice = input(H, "Choose your former trade.", "WHO ARE YOU?") as anything in trades

		switch(trade_choice)
			if("Healer")
				H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_APPRENTICE, TRUE)

			if("Farmhand")
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_NOVICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_JOURNEYMAN, TRUE)

			if("Clothworker")
				H.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/tanning, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_JOURNEYMAN, TRUE)

			if("Craftsman")
				H.adjust_skillrank_up_to(/datum/skill/craft/smelting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/ceramics, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_APPRENTICE, TRUE)

			if("Urchin")
				H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/stealing, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, SKILL_LEVEL_APPRENTICE, TRUE)

// 
// 
// 

/datum/advclass/rookie/backline
	name = "Backline Recruit"
	tutorial = "CHANGE ME LATER!!"
	outfit = /datum/outfit/job/roguetown/rookie/skirmisher

	category_tags = list(CTAG_ROOKIE)
	subclass_stats = list(
		STATKEY_SPD = 1,
		STATKEY_PER = 2,
		STATKEY_END = 1,
		STATKEY_CON = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/slings = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_NOVICE,//clobbering criminals
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting, SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking, SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/rookie/skirmisher/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.verbs |= /mob/proc/haltyell_exhausting
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	pants = /obj/item/clothing/under/roguetown/trou/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger,
		/obj/item/storage/belt/rogue/pouch,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/storage/keyring/guardcastle = 1,
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
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			if("Bow") // They can head down to the armory to sideshift into one of the other bows.
				beltr = /obj/item/quiver/arrows
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			if("Sling")
				beltr = /obj/item/quiver/sling/iron
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling 

		switch(armor_choice)
			if("Light Armor")
				armor = /obj/item/clothing/suit/roguetown/armor/leather
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			if("Medium Armor")
				armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

		var/helmets = list(
			"Leather Helmet" = /obj/item/clothing/head/roguetown/helmet/leather,
			"Simple Helmet" = /obj/item/clothing/head/roguetown/helmet,
			"Kettle Helmet" = /obj/item/clothing/head/roguetown/helmet/kettle,
			"Skull Cap" = /obj/item/clothing/head/roguetown/helmet/skullcap,
			"None"
		)
		var/helmchoice = input(H, "Choose your helmet.", "HEAD PROTECTION") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

		// Trade selection
		var/trades = list("Healer","Farmhand","Craftsman", "Clothworker", "Urchin")
		var/trade_choice = input(H, "Choose your former trade.", "WHO ARE YOU?") as anything in trades

		switch(trade_choice)
			if("Healer")
				H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_APPRENTICE, TRUE)

			if("Farmhand")
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_NOVICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_JOURNEYMAN, TRUE)

			if("Clothworker")
				H.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/tanning, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_JOURNEYMAN, TRUE)

			if("Craftsman")
				H.adjust_skillrank_up_to(/datum/skill/craft/smelting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/ceramics, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_APPRENTICE, TRUE)

			if("Urchin")
				H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/stealing, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, SKILL_LEVEL_APPRENTICE, TRUE)
