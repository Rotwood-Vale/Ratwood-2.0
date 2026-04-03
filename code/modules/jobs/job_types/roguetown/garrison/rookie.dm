/datum/job/roguetown/rookie
	title = "Rookie"
	flag = ROOKIE
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)
	advclass_cat_rolls = list(CTAG_ROOKIE = 20)
	job_traits = list(TRAIT_SQUIRE_REPAIR, TRAIT_GUARDSMAN)

	tutorial = "Odd-jobs, running messages, fixing dents and talking to locals; the Guard can always use a spare pair of hands, eyes and ears. Assist your fellow guards in dealing with threats - both within and without. \
				Given a brief introduction in weapons and guardwork, the rest of your training is to be picked up on the job. \
				Obey your superiors (everyone who isn't you) and show the nobles your respect. Keep an eye out, try to learn a thing or two, then one day you might live to make an adequate soldier."
	
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
	gloves = /obj/item/clothing/gloves/roguetown/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	belt = /obj/item/storage/belt/rogue/leather
	id = /obj/item/scomstone/bad/garrison
	job_bitflag = BITFLAG_GARRISON

// /datum/job/roguetown/squire/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
// 	. = ..()
// 	if(ishuman(L))
// 		addtimer(CALLBACK(L, TYPE_PROC_REF(/mob, cloak_and_title_setup)), 50)


/datum/advclass/rookie/frontline
	name = "Frontline Recruit"
	tutorial = "The quickest way to learn is also the deadliest."
	outfit = /datum/outfit/job/roguetown/rookie/footman

	category_tags = list(CTAG_ROOKIE)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_END = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/shields = 2,
		/datum/skill/combat/maces = 3,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/polearms = 3,
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/medicine = 2,
		/datum/skill/misc/tracking = 2,
		/datum/skill/craft/crafting, 1,
		/datum/skill/craft/cooking, 1,
	)

/datum/outfit/job/roguetown/rookie/footman/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.verbs |= /mob/proc/haltyell_exhausting
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	if(SSmapping.config.map_name == "Rockhill")
		cloak = /obj/item/clothing/cloak/citywatch
		head = /obj/item/clothing/head/roguetown/helmet/kettle/citywatch
	else
		cloak = /obj/item/clothing/cloak/stabard/surcoat/guard
		head = /obj/item/clothing/head/roguetown/helmet/kettle/
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger,
		/obj/item/storage/belt/rogue/pouch,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/storage/keyring/guardcastle = 1,
		/obj/item/rogueweapon/hammer/iron,
		)
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Sword and Shield","Cudgel and Shield","Spear")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Sword and Shield")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/short/iron
				backl = /obj/item/rogueweapon/shield/iron
			if("Cudgel and Shield")
				r_hand = /obj/item/rogueweapon/mace/cudgel
				backl = /obj/item/rogueweapon/shield/iron
			if("Spear")
				r_hand = /obj/item/rogueweapon/spear
				backl = /obj/item/rogueweapon/scabbard/gwstrap

/datum/advclass/rookie/backline
	name = "Backline Recruit"
	tutorial = "Keep your distance, watch carefully, and stick 'em when they ain't lookin'"
	outfit = /datum/outfit/job/roguetown/rookie/skirmisher

	category_tags = list(CTAG_ROOKIE)
	subclass_stats = list(
		STATKEY_SPD = 1,
		STATKEY_PER = 1,
		STATKEY_END = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/bows = 3,
		/datum/skill/combat/crossbows = 3,
		/datum/skill/combat/slings = 3,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/maces = 2,//clobbering criminals
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 4,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/medicine = 2,
		/datum/skill/misc/tracking = 2,
		/datum/skill/craft/crafting, 1,
		/datum/skill/craft/cooking, 1,
	)

/datum/outfit/job/roguetown/rookie/skirmisher/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.verbs |= /mob/proc/haltyell_exhausting
	pants = /obj/item/clothing/under/roguetown/trou/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	beltl = /obj/item/rogueweapon/mace/cudgel
	if(SSmapping.config.map_name == "Rockhill")
		cloak = /obj/item/clothing/cloak/citywatch
		head = /obj/item/clothing/head/roguetown/helmet/kettle/citywatch
	else
		cloak = /obj/item/clothing/cloak/stabard/surcoat/guard
		head = /obj/item/clothing/head/roguetown/helmet/kettle/
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger,
		/obj/item/storage/belt/rogue/pouch,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/storage/keyring/guardcastle = 1,
		/obj/item/rogueweapon/hammer/iron,
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
			if("Bow")
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
				armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

