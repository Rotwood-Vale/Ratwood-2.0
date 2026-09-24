/datum/advclass/hammerhold/huscarl
	name = ""
	category_tags = list()
	subclass_languages = list(/datum/language/hammerholdian)

/datum/advclass/hammerhold/huscarl/huscarl
	name = "Hammerholdian Huscarl"
	tutorial = "You are a loyal and skilled bodyguard to your jarl, specialising in pillaging, kidnapping and fighting with good Hammerhold steel."
	outfit = /datum/outfit/job/roguetown/hammerhold/huscarl/huscarl
	category_tags = list(CTAG_HAMMERHOLD_HUSCARL)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED, TRAIT_OUTLANDER, TRAIT_HAMMERHOLD_WARBAND)
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_CON = 3,
		STATKEY_STR = 2,
		STATKEY_PER = 1,
		STATKEY_SPD = -1, //Literally Atgervi Varangian stats
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE, //weapon pick bumps whatever you take to expert
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/hammerhold/huscarl/huscarl/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn/ownel
	neck = /obj/item/clothing/neck/roguetown/gorget
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/gronn
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/splintlegs/iron/gronn
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	gloves = /obj/item/clothing/gloves/roguetown/chain/gronn
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/clothing/neck/roguetown/psicross/abyssor
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/flashlight/flare/torch/lantern = 1
		)

	var/weapons = list("Battle Axe + Shield", "Greataxe", "Steel Warhammer + Shield", "Arming Sword + Shield", "Boar Spear")
	var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Battle Axe + Shield")
			r_hand = /obj/item/rogueweapon/stoneaxe/battle
			backr = /obj/item/rogueweapon/shield/tower/metal
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, 4, TRUE)
		if("Greataxe")
			r_hand = /obj/item/rogueweapon/greataxe/steel
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
		if("Steel Warhammer + Shield")
			r_hand = /obj/item/rogueweapon/mace/warhammer/steel
			backr = /obj/item/rogueweapon/shield/tower/metal
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, 4, TRUE)
		if("Arming Sword + Shield")
			r_hand = /obj/item/rogueweapon/sword
			beltl = /obj/item/rogueweapon/scabbard/sword
			backr = /obj/item/rogueweapon/shield/tower/metal
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, 4, TRUE)
		if("Boar Spear")
			r_hand = /obj/item/rogueweapon/spear/boar
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
		else //In case they DC or don't choose close the panel, etc
			r_hand = /obj/item/rogueweapon/stoneaxe/battle
			backr = /obj/item/rogueweapon/shield/tower/metal
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, 4, TRUE)

	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	H.dna.species.soundpack_f = new /datum/voicepack/female/warrior()

	H.cmode_music = 'sound/music/combat_vagarian.ogg'

	if(!H.has_language(/datum/language/hammerholdian))
		H.grant_language(/datum/language/hammerholdian)
		to_chat(H, span_info("I can speak Hammerholdian with ,h before my speech."))

/datum/advclass/hammerhold/huscarl/marksman
	name = "Hammerholdian Marksman"
	tutorial = "You are a marksman of your jarl's warband. While the Huscarls hold the shield wall, you stand behind it and thin the enemy with arrow, bolt and stone before they ever reach it."
	outfit = /datum/outfit/job/roguetown/hammerhold/huscarl/marksman
	category_tags = list(CTAG_HAMMERHOLD_HUSCARL)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED, TRAIT_OUTLANDER, TRAIT_HAMMERHOLD_WARBAND)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_WIL = 2,
		STATKEY_CON = 2,
		STATKEY_STR = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE, //ranged pick bumps whatever you take to expert
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/hammerhold/huscarl/marksman/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn/ownel
	neck = /obj/item/clothing/neck/roguetown/gorget
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/gronn
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/splintlegs/iron/gronn
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	gloves = /obj/item/clothing/gloves/roguetown/chain/gronn
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/clothing/neck/roguetown/psicross/abyssor
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/flashlight/flare/torch/lantern = 1
		)

	var/weapons = list("Longbow", "Crossbow", "Sling")
	var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Longbow")
			r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow //heavy bow, draw time checks str
			l_hand = /obj/item/quiver/arrows
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)
		if("Crossbow")
			r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			l_hand = /obj/item/quiver/bolts
			H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, 4, TRUE)
		if("Sling")
			r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
			l_hand = /obj/item/quiver/sling/steel //hammerhold gets steel shot, gronn gets iron
			H.adjust_skillrank_up_to(/datum/skill/combat/slings, 4, TRUE)
		else //In case they DC or don't choose close the panel, etc
			r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
			l_hand = /obj/item/quiver/arrows
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)

	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	H.dna.species.soundpack_f = new /datum/voicepack/female/warrior()

	H.cmode_music = 'sound/music/combat_vagarian.ogg'

	if(!H.has_language(/datum/language/hammerholdian))
		H.grant_language(/datum/language/hammerholdian)
		to_chat(H, span_info("I can speak Hammerholdian with ,h before my speech."))
