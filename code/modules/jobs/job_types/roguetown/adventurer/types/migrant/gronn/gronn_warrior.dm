/datum/advclass/gronn/warrior
	name = ""
	category_tags = list()
	subclass_languages = list(/datum/language/gronnic)

/datum/advclass/gronn/warrior/warrior
	name = "Gronnic Warrior"
	tutorial = "You are the elite, the best fighters of your tribe. You fight side by side with the Chieftain and ensure their survival."
	outfit = /datum/outfit/job/roguetown/gronn/warrior/warrior
	category_tags = list(CTAG_GRONN_WARRIOR)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED, TRAIT_OUTLANDER, TRAIT_GRONN_HORDE)
	subclass_stats = list(
		STATKEY_CON = 3,
		STATKEY_WIL = 2,
		STATKEY_STR = 3,
		STATKEY_INT = -2,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE, //weapon pick bumps whatever you take to expert
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/bows = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/gronn/warrior/warrior/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/nomadhelmet
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/nomadpants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather
	armor = /obj/item/clothing/suit/roguetown/armor/kurche
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife = 1,
	)
	if(H.mind)
		var/weapons = list("Iron Greataxe", "Iron Spear", "Bardiche", "Beast Claws + Iron Claw", "Iron Warhammer + Shield", "Iron Mace + Shield")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Iron Greataxe")
				r_hand = /obj/item/rogueweapon/greataxe
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
			if("Iron Spear")
				r_hand = /obj/item/rogueweapon/spear
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
			if("Bardiche")
				r_hand = /obj/item/rogueweapon/halberd/bardiche
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
			if("Beast Claws + Iron Claw")
				r_hand = /obj/item/rogueweapon/handclaw/gronn //beast claws
				l_hand = /obj/item/rogueweapon/handclaw //iron hound claws, the plain gronnic ones
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, 4, TRUE)
			if("Iron Warhammer + Shield")
				r_hand = /obj/item/rogueweapon/mace/warhammer
				backr = /obj/item/rogueweapon/shield/iron/steppesman
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, 4, TRUE)
			if("Iron Mace + Shield")
				r_hand = /obj/item/rogueweapon/mace
				backr = /obj/item/rogueweapon/shield/iron/steppesman
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, 4, TRUE)
			else //In case they DC or don't choose close the panel, etc
				r_hand = /obj/item/rogueweapon/greataxe
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn
		if(/datum/patron/inhumen/graggar)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/gronn
		if(/datum/patron/inhumen/matthios)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gronn
		if(/datum/patron/inhumen/baotha)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha/gronn
		if(/datum/patron/divine/abyssor)
			id = /obj/item/clothing/neck/roguetown/psicross/abyssor/gronn
		if(/datum/patron/divine/dendor)
			id = /obj/item/clothing/neck/roguetown/psicross/dendor/gronn
		else
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn/special //Failsafe. Gives a specially-fluffed version of Zizo's talisman, which can be reinterpreted as needed.

	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	H.dna.species.soundpack_f = new /datum/voicepack/female/warrior()

	H.cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'

	if(!H.has_language(/datum/language/gronnic))
		H.grant_language(/datum/language/gronnic)
		to_chat(H, span_info("I can speak Gronnic with ,n before my speech."))

/datum/advclass/gronn/warrior/skirmisher
	name = "Gronnic Skirmisher"
	tutorial = "You are a Skirmisher, riding in the Hordes upon Saiga back and loosing arrows and stones upon the poor foe before you. You thin the enemy's ranks before the Warriors crash into them."
	outfit = /datum/outfit/job/roguetown/gronn/warrior/skirmisher
	category_tags = list(CTAG_GRONN_WARRIOR)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_OUTLANDER, TRAIT_STEELHEARTED, TRAIT_EQUESTRIAN, TRAIT_GRONN_HORDE)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = -2,
		STATKEY_PER = 3,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/slings = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE, //ranged pick bumps whatever you take to expert
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/gronn/warrior/skirmisher/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/hatfur
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/nomadpants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	armor = /obj/item/clothing/suit/roguetown/armor/leather/Huus_quyaq
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife = 1,
	)
	if(H.mind)
		var/weapons = list("Recurve Bow", "Yew Longbow", "Sling")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Recurve Bow")
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				l_hand = /obj/item/quiver/arrows
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)
			if("Yew Longbow")
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow //heavy bow, draw time checks str
				l_hand = /obj/item/quiver/arrows
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)
			if("Sling")
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
				l_hand = /obj/item/quiver/sling/iron
				H.adjust_skillrank_up_to(/datum/skill/combat/slings, 4, TRUE)
			else //In case they DC or don't choose close the panel, etc
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				l_hand = /obj/item/quiver/arrows
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn
		if(/datum/patron/inhumen/graggar)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/gronn
		if(/datum/patron/inhumen/matthios)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gronn
		if(/datum/patron/inhumen/baotha)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha/gronn
		if(/datum/patron/divine/abyssor)
			id = /obj/item/clothing/neck/roguetown/psicross/abyssor/gronn
		if(/datum/patron/divine/dendor)
			id = /obj/item/clothing/neck/roguetown/psicross/dendor/gronn
		else
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn/special //Failsafe. Gives a specially-fluffed version of Zizo's talisman, which can be reinterpreted as needed.

	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	H.dna.species.soundpack_f = new /datum/voicepack/female/warrior()

	H.cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'

	if(!H.has_language(/datum/language/gronnic))
		H.grant_language(/datum/language/gronnic)
		to_chat(H, span_info("I can speak Gronnic with ,n before my speech."))

	H.set_blindness(0)
