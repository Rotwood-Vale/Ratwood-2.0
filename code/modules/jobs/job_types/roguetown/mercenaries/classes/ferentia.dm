/proc/ferentia_locality(mob/living/carbon/human/H)
	var/is_local = input(H, "Are you a local?", "Ferentia Kingdom") as anything in list("I am from the Vale", "I am a foreigner")
	switch(is_local)
		if("I am from the Vale")
			REMOVE_TRAIT(H, TRAIT_OUTLANDER, JOB_TRAIT)
		else
			to_chat(H, span_notice("I have arrived at the Vale's mercenary guild after travelling from a different county within the Ferentian kingdom."))


/datum/advclass/mercenary/ferentia
	name = "Sellknight"
	tutorial = "Combat experience and skill doesn't pay for lodging, mammons do. A knight only in appearance, you took to the mercenary guild to sell your services as sword-toting muscle to the highest bidder."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/ferentia_sellknight
	class_select_category = CLASS_CAT_FERENTIA
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/combat_fullplate.ogg'
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list( //Roughly equivalent to the Doppelsoldner, but without their unique sword or blacksteel armor, in exchange they're basically a regular guy in plate armor
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_STR = 2,
		STATKEY_INT = 1,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT, //Sword and board kinda guy
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/mercenary/ferentia_sellknight/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("Combat experience and skill doesn't pay for lodging, mammons do. A knight only in appearance, you took to the mercenary guild to sell your services as sword-toting muscle to the highest bidder."))
	if(H.mind)
		var/weapons = list("Greatsword", "Longsword & Shield", "Rapier & Buckler")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Greatsword")
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/greatsword
			if("Longsword & Shield")
				beltl = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long
				backl = /obj/item/rogueweapon/shield/tower/metal
			if("Rapier & Buckler")
				beltl = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/rapier
				backl = /obj/item/rogueweapon/shield/buckler
		var/helmets = list(
			"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"Knight Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"Hounskull Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"Etruscan Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"Slitted Kettle" = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"Froggemund Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth,
			"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]
	wrists = /obj/item/clothing/wrists/roguetown/splintarms //We're lowkey kinda poor, so mostly iron armor for anything which isn't vital
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/gorget
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half //Sorry! If you want good armor, better get someone to pay you
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	ferentia_locality(H)
	H.merctype = 17

/datum/advclass/mercenary/ferentia/sellspear
	name = "Sellspear"
	tutorial = "Faceless and numerous, the mercenary guild is occupied by many of your ilk. Maille and polearms are as easily used by the unskilled as they are effective."
	outfit = /datum/outfit/job/roguetown/mercenary/ferentia_sellspear
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list( //Extremely all-rounder statline for an extremely all-rounder weapon class and middling armor class. You are John Spearman
		STATKEY_PER = 2, //For stabbing and guardsman larping
		STATKEY_WIL = 2,
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN, //You have an arming sword as a backup but you're not very stellar with it peasant
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/mercenary/ferentia_sellspear/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("Faceless and numerous, the mercenary guild is occupied by many of your ilk. Maille and polearms are as easily used by the unskilled as they are effective."))
	if(H.mind)
		var/weapons = list("Halberd", "Partizan", "Eagle's Beak", "Billhook")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Halberd")
				r_hand = /obj/item/rogueweapon/halberd
			if("Partizan")
				r_hand = /obj/item/rogueweapon/spear/partizan
			if("Eagle's Beak")
				r_hand = /obj/item/rogueweapon/eaglebeak
			if("Billhook")
				r_hand =/obj/item/rogueweapon/spear/billhook
		var/helmets = list(
			"Simple Helmet" 	= /obj/item/clothing/head/roguetown/helmet,
			"Kettle Helmet" 	= /obj/item/clothing/head/roguetown/helmet/kettle,
			"Bascinet Helmet"	= /obj/item/clothing/head/roguetown/helmet/bascinet,
			"Sallet Helmet"		= /obj/item/clothing/head/roguetown/helmet/sallet,
			"Winged Helmet" 	= /obj/item/clothing/head/roguetown/helmet/winged,
			"Skull Cap"			= /obj/item/clothing/head/roguetown/helmet/skullcap,
			"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]
	l_hand = /obj/item/rogueweapon/sword
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/chain
	backr = /obj/item/storage/backpack/rogue/satchel
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	beltl = /obj/item/rogueweapon/scabbard/sword
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	ferentia_locality(H)
	H.merctype = 17

/datum/advclass/mercenary/ferentia/sellblade
	name = "Sellblade"
	tutorial = "An expert with a blade and nimble on your feet, those of your ability are something of a rare sight in the mercenary guild. Nevertheless effective at accomplishing the dirty work of others as you merge with the shadows, striking fast and deadly."
	outfit = /datum/outfit/job/roguetown/mercenary/ferentia_sellblade
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_SEEPRICES_SHITTY) //Obligatory fast and nimble dodge expert class, specializing in either daggers or stabby swift weighted swords
	subclass_stats = list( //Potentially a kind of scary statline, but you're going to be frail
		STATKEY_SPD = 3,
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_CON = -1

	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE, //No lockpicking or pickpocketing, you're a shady as fuck shanker, not a thief role
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE, //Your bane is being grabbed, you're an assassin, not a grappler
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	)
	extra_context = "This subclass gains Expert skill in their weapon of choice, be it swords or knives."

/datum/outfit/job/roguetown/mercenary/ferentia_sellblade/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("An expert with a blade and nimble on your feet, those of your ability are something of a rare sight in the mercenary guild. Nevertheless effective at accomplishing the dirty work of others as you merge with the shadows, striking fast and deadly."))
	if(H.mind)
		var/weapons = list("Rapier", "Dagger")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Rapier")
				r_hand = /obj/item/rogueweapon/sword/rapier
				beltl = /obj/item/rogueweapon/scabbard/sword
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			if("Dagger")
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
				beltl = /obj/item/rogueweapon/scabbard/sheath
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	belt = /obj/item/storage/belt/rogue/leather
	head = /obj/item/clothing/head/roguetown/roguehood/reinforced
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	neck = /obj/item/clothing/neck/roguetown/bevor
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/angle
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	ferentia_locality(H)
	H.merctype = 17

/datum/advclass/mercenary/ferentia/thug
	name = "Hired Thug"
	tutorial = "The mercenary guild is teeming with corn-fed brutes looking to make mammons off the only thing they're good at - while simple-minded describes you best, you possess brute strength and a heavy club. Sometimes that's all you need to solve problems in lyfe."
	outfit = /datum/outfit/job/roguetown/mercenary/ferentia_thug
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_BASHDOORS, TRAIT_SEEPRICES_SHITTY, TRAIT_DRUNK_HEALING)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 3,
		STATKEY_WIL = 2,
		STATKEY_INT = -2

	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT, 
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
	)
	extra_context = "This subclass gains Expert skill in their weapon of choice, be it maces or unarmed."

/datum/outfit/job/roguetown/mercenary/ferentia_thug/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("The mercenary guild is teeming with corn-fed brutes looking to make mammons off the only thing they're good at - while simple-minded describes you best, you possess brute strength and a heavy club. Sometimes that's all you need to solve problems in lyfe."))
	if(H.mind)
		var/weapons = list("Mace", "Warhammer", "WHO NEEDS A CLUB? I HAVE MY HANDS!")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Mace")
				r_hand = /obj/item/rogueweapon/mace/steel
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			if("Warhammer")
				r_hand = /obj/item/rogueweapon/mace/warhammer/steel
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			if("WHO NEEDS A CLUB? I HAVE MY HANDS!")
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
				ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather
	head = /obj/item/clothing/neck/roguetown/chaincoif/iron
	mask = /obj/item/clothing/mask/rogue/facemask
	neck = /obj/item/clothing/neck/roguetown/gorget
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/plate
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	ferentia_locality(H)
	H.merctype = 17

/datum/advclass/mercenary/ferentia/crossbowman
	name = "Light Crossbowman"
	tutorial = "Once a member of a guard mayhaps - you recieved training in bludgeons and crossbows, serving as a ferentia yet numerous and effective ranged service to the mercenary guild."
	outfit = /datum/outfit/job/roguetown/mercenary/ferentia_crossbowman
	traits_applied = list(TRAIT_KEENEARS) //Guardmaxing
	subclass_stats = list( //You're a little bit more tailored to the crossbowman identity than the Grenzelhoft crossbowman which is more of a utility role
		STATKEY_PER = 3,
		STATKEY_WIL = 2,
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN, //Crossbow is your main weapon
		/datum/skill/combat/crossbows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE, //Ranged babies are made to be grabbed
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/mercenary/ferentia_crossbowman/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("Once a member of a guard, mayhaps - you recieved training in bludgeons and crossbows, serving as a ferentia yet numerous and effective ranged service to the mercenary guild."))
	if(H.mind)
		var/armor_options = list("Light Brigandine", "Studded Leather Vest")
		var/armor_choice = input(H, "Choose your armor.", "DRESS UP") as anything in armor_options
		switch(armor_choice)
			if("Light Brigandine")
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
			if("Studded Leather Vest")
				armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
		var/helmets = list(
			"Simple Helmet" 	= /obj/item/clothing/head/roguetown/helmet,
			"Kettle Helmet" 	= /obj/item/clothing/head/roguetown/helmet/kettle,
			"Bascinet Helmet"	= /obj/item/clothing/head/roguetown/helmet/bascinet,
			"Sallet Helmet"		= /obj/item/clothing/head/roguetown/helmet/sallet,
			"Winged Helmet" 	= /obj/item/clothing/head/roguetown/helmet/winged,
			"Skull Cap"			= /obj/item/clothing/head/roguetown/helmet/skullcap,
			"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/chain
	backr = /obj/item/storage/backpack/rogue/satchel
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	beltr = /obj/item/quiver/bolts
	beltl = /obj/item/rogueweapon/mace/cudgel
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	ferentia_locality(H)
	H.merctype = 17

/datum/advclass/mercenary/ferentia/longbowman
	name = "Longbowman"
	tutorial = "You've trained since you were young with a bow hunting game in the forest. You know the woods like you know the vitals of a wild saiga. In the mercenary guild, it's not hard to think of a brigand as a bipedal saiga."
	outfit = /datum/outfit/job/roguetown/mercenary/ferentia_longbowman
	traits_applied = list(TRAIT_OUTDOORSMAN, TRAIT_WOODSMAN, TRAIT_SURVIVAL_EXPERT) //Warden at home
	subclass_stats = list( //Minus three weighted stats but they get woodsman to specialize them in being forest battlers, maybe try and get hired by the wardens pal
		STATKEY_PER = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/slings = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE, //Miscellaneous survivalist flavor skills
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
	)
	extra_context = "This subclass gains Journeyman skill in their weapon of choice, be it axes or knives. Furthermore, this subclass possesses less stats compared to others to compensate for its Woodsman trait granting it a higher overall stat total when its conditions are met."

/datum/outfit/job/roguetown/mercenary/ferentia_longbowman/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You've trained since you were young with a bow hunting game in the forest. You know the woods like you know the vitals of a wild saiga. In the mercenary guild, it's not hard to think of a brigand as a bipedal saiga."))
	if(H.mind)
		var/weapons = list("Axe", "Dagger")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Axe")
				r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/pick
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Dagger")
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
				beltl = /obj/item/rogueweapon/scabbard/sheath
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	belt = /obj/item/storage/belt/rogue/leather
	head = /obj/item/clothing/head/roguetown/roguehood/reinforced
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/angle
	backr = /obj/item/storage/backpack/rogue/satchel
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
	beltr = /obj/item/quiver/arrows
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	ferentia_locality(H)
	H.merctype = 17
