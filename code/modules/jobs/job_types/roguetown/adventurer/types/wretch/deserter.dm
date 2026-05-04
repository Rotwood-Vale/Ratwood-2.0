/datum/advclass/wretch/deserter
	name = "Disgraced Knight"
	tutorial = "You were once a venerated and revered knight - now, a traitor who abandoned your liege. You lyve the lyfe of an outlaw, shunned and looked down upon by society."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	outfit = /datum/outfit/job/roguetown/wretch/deserter
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_EQUESTRIAN, TRAIT_DISGRACED_NOBLE)
	maximum_possible_slots = 2 //Ideal role for fraggers. Better to limit it.

	cmode_music = 'sound/music/cmode/antag/combat_thewall.ogg' // same as new hedgeknight music
	class_select_category = CLASS_CAT_WARRIOR
	// Deserter are the knight-equivalence. They get a balanced, straightforward 2 2 3 statspread to endure and overcome.
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_CON = 2,
		STATKEY_STR = 2
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
	)

	virtue_restrictions = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/roguetown/wretch/deserter/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You were once a venerated and revered knight - now, a traitor who abandoned your liege. You lyve the lyfe of an outlaw, shunned and looked down upon by society."))
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	H.verbs |= list(/mob/living/carbon/human/mind/proc/setorderswretch)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/retreat)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/bolster)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/brotherhood)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/charge)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/brotherhood)

		var/weapons = list(
			"Estoc",
			"Mace + Shield",
			"Flail + Shield",
			"Longsword + Shield",
			"Lucerne",
			"Battle Axe",
			"Lance + Kite Shield",
			"Shamshir",		//WHO MISPELLED IT BRO
		)
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Estoc")
				r_hand = /obj/item/rogueweapon/estoc
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("Longsword + Shield")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long
				backr = /obj/item/rogueweapon/shield/tower/metal
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("Mace + Shield")
				beltr = /obj/item/rogueweapon/mace/steel
				backr = /obj/item/rogueweapon/shield/tower/metal
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
			if("Flail + Shield")
				beltr = /obj/item/rogueweapon/flail/sflail
				backr = /obj/item/rogueweapon/shield/tower/metal
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_MASTER, TRUE)
			if("Lucerne")
				r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
			if("Battle Axe")
				backr = /obj/item/rogueweapon/stoneaxe/battle
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_MASTER, TRUE)
			if("Lance + Kite Shield")
				r_hand = /obj/item/rogueweapon/spear/lance
				backr = /obj/item/rogueweapon/shield/tower/metal
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
			if("Shamshir")
				r_hand = /obj/item/rogueweapon/sword/sabre/shamshir
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
		var/helmets = list(
			"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"Knight Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"Visored Sallet"			= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"Hounskull Bascinet" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"Etruscan Bascinet" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"Slitted Kettle"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"Froggemund Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth,
			"Kulah Khud"	= /obj/item/clothing/head/roguetown/helmet/sallet/zyb,
			"Otavan Helmet" = /obj/item/clothing/head/roguetown/helmet/otavan,
			"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

		var/armors = list(
			"Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine,
			"Coat of Plates"	= /obj/item/clothing/suit/roguetown/armor/brigandine/coatplates,
			"Steel Cuirass"		= /obj/item/clothing/suit/roguetown/armor/plate/half,
			"Fluted Cuirass"	= /obj/item/clothing/suit/roguetown/armor/plate/half/fluted,
			"Scalemail"		= /obj/item/clothing/suit/roguetown/armor/plate/scale,
		)
		var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
		armor = armors[armorchoice]
		wretch_select_bounty(H)
	gloves = /obj/item/clothing/gloves/roguetown/plate
	pants = /obj/item/clothing/under/roguetown/chainlegs
	neck = /obj/item/clothing/neck/roguetown/bevor
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/steel
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel //gwstraps landing on backr asyncs with backpack_contents
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)

	if (H.mind)
		H.AddSpell(new /obj/effect/proc_holder/spell/self/choose_riding_virtue_mount)

/datum/advclass/wretch/deserter/maa
	name = "Fighter"
	tutorial = "It matters not what cause you swing your weapon for, in the end you fight the same way your ancestors and their ancestors did: clad in metal and intimately intertwined with gore and death."
	outfit = /datum/outfit/job/roguetown/wretch/desertermaa
	cmode_music = 'sound/music/combat_vigilante.ogg' //Unused by any other class, so may as very well...
	class_select_category = CLASS_CAT_WARRIOR
	// Slightly more rounded. These can be nudged as needed.
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT, // Better at climbing away than your average MaA. Only slightly.
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN, // Worse at swimming than the above class.
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN, // That saiga was stolen. Probably.
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
	)
/datum/outfit/job/roguetown/wretch/desertermaa/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/weapons = list("Warhammer & Shield","Sabre & Shield","Axe & Shield","Billhook","Greataxe","Halberd","Crossbow",)
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Warhammer & Shield")
				beltr = /obj/item/rogueweapon/mace/warhammer
				backl = /obj/item/rogueweapon/shield/iron
			if("Sabre & Shield")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/sabre
				backl = /obj/item/rogueweapon/shield/wood
			if("Axe & Shield")
				beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel
				backl = /obj/item/rogueweapon/shield/iron
			if("Billhook")
				r_hand = /obj/item/rogueweapon/spear/billhook
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Halberd")
				r_hand = /obj/item/rogueweapon/halberd
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Crossbow")
				beltr = /obj/item/quiver/bolts
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			if("Greataxe")
				r_hand = /obj/item/rogueweapon/greataxe
				backl = /obj/item/rogueweapon/scabbard/gwstrap
	H.verbs |= list(/mob/living/carbon/human/mind/proc/setorderswretch)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/retreat)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/bolster)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/brotherhood)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/charge)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/brotherhood)
		var/helmets = list(
		"Simple Helmet" 		 = /obj/item/clothing/head/roguetown/helmet,
		"Kettle Helmet" 		 = /obj/item/clothing/head/roguetown/helmet/kettle,
		"Bascinet Helmet" 		 = /obj/item/clothing/head/roguetown/helmet/bascinet,
		"Sallet Helmet" 		 = /obj/item/clothing/head/roguetown/helmet/sallet,
		"Winged Helmet" 		 = /obj/item/clothing/head/roguetown/helmet/winged,
		"Skull Cap"				 = /obj/item/clothing/head/roguetown/helmet/skullcap,
		"Gronnic Ownel Helmet" 	 = /obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn/ownel,
		"Steel Shishak" 		 = /obj/item/clothing/head/roguetown/helmet/sallet/shishak,
		"Nomad Helmet" 			 = /obj/item/clothing/head/roguetown/helmet/nomadhelmet,
		"Grenzelhoft Plume Hat"  = /obj/item/clothing/head/roguetown/grenzelhofthat,
		"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

		var/masks = list(
		"Steel Mask" 			= /obj/item/clothing/mask/rogue/facemask/steel,
		"Steel Hound Mask" 		= /obj/item/clothing/mask/rogue/facemask/steel/hound,
		"Wildguard" 			= /obj/item/clothing/mask/rogue/wildguard,
		"Steppesman War Mask" 	= /obj/item/clothing/mask/rogue/facemask/steel/steppesman,
		"Steppesman Beast Mask"	= /obj/item/clothing/mask/rogue/facemask/steel/steppesman/anthro,
		"None"
		)
		var/maskchoice = input(H, "Choose your Mask.", "MASK MASK MASK") as anything in masks // Run from it. MASK. MASK. MASK.
		if(maskchoice != "None")
			mask = masks[maskchoice]

		var/armor_options = list("Brigandine Set", "Maille Set", "Cuirass Set", "Hammerholdian Set", "Steppesman Set", "Gronn Set", "Grenzelhoftian Set", "Otavan Set")
		var/armor_choice = input(H, "Choose your armor.", "DIE IN FASHION") as anything in armor_options
		switch(armor_choice)
			if("Brigandine Set")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine
				pants = /obj/item/clothing/under/roguetown/splintlegs
				neck = /obj/item/clothing/neck/roguetown/gorget/steel
				wrists = /obj/item/clothing/wrists/roguetown/splintarms
				gloves = /obj/item/clothing/gloves/roguetown/plate/iron
				shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
			if("Maille Set")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
				armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
				pants = /obj/item/clothing/under/roguetown/chainlegs
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				gloves = /obj/item/clothing/gloves/roguetown/chain
				shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
			if("Cuirass Set")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
				armor = /obj/item/clothing/suit/roguetown/armor/plate/half/fluted
				pants = /obj/item/clothing/under/roguetown/chainlegs
				neck = /obj/item/clothing/neck/roguetown/gorget/steel
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				gloves = /obj/item/clothing/gloves/roguetown/chain
				shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
			if("Hammerholdian Set") //It is actually called Gronn in-game, but it's from AP's lore where Gronns are Totally-Not-Vikings, whereas on RW Gronns are Mongols and Hammerholdians are Vikings.
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/gronn
				pants = /obj/item/clothing/under/roguetown/splintlegs/iron/gronn
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				gloves = /obj/item/clothing/gloves/roguetown/chain/gronn
				shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
			if("Steppesman Set")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah //Better gambeson but your dedicated leg protection is worse.
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/steppe
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				gloves = /obj/item/clothing/gloves/roguetown/chain
				shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman
			if("Gronn Set")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah //Better gambeson but your dedicated leg protection is worse.
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/steppe
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/nomadpants
				neck = /obj/item/clothing/neck/roguetown/gorget/steel
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				gloves = /obj/item/clothing/gloves/roguetown/angle
				shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
			if("Grenzelhoftian Set")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft //Better gambeson but your dedicated leg protection is worse.
				armor = /obj/item/clothing/suit/roguetown/armor/plate/blacksteel_half_plate //Better chest protection but worse limb protection, a fair trade-off.
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
				neck = /obj/item/clothing/neck/roguetown/gorget
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				shoes = /obj/item/clothing/shoes/roguetown/boots/grenzelhoft
				gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
			if("Otavan Set")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan //Better gambeson but your dedicated leg protection is worse.
				armor = /obj/item/clothing/suit/roguetown/armor/plate/half/fluted //Actual Otavan plate's AC is heavy.
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
				neck = /obj/item/clothing/neck/roguetown/fencerguard
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				shoes = /obj/item/clothing/shoes/roguetown/boots/otavan
				gloves = /obj/item/clothing/gloves/roguetown/otavan
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/mace/cudgel
	backr = /obj/item/storage/backpack/rogue/satchel
	if(H.mind)
		var/archetype = list("Heavy Infantry", "Light Infantry", "Bogguard/Cavalryman", "Feldsher", "Warcaster", "Veteran")
		var/archetype_choice = input (H, "Choose your primary training.", "HOW DO YOU KILL?") as anything in archetype
		switch(archetype_choice)
			if("Heavy Infantry") //Classic Deserter. Master Athletics, Expert Swimming and Expert Shields. Otherwise nothing special.
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
				cloak = /obj/item/clothing/cloak/stabard/surcoat
				to_chat(H, span_warning("You trained to fight as a part of dense shield formations. This made you fit, but you didn't have a chance to pick up any other skills."))
			if("Light Infantry") //Throwing weapons guy. Starts with steel javelins; +1 SPD and -1 STR; Journeyman in Sneaking.
				H.change_stat(STATKEY_SPD, 1)
				H.change_stat(STATKEY_STR, -1)
				H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)
				cloak = /obj/item/clothing/cloak/poachercloak //Maybe you are a former Warden-Forester?
				beltl = /obj/item/quiver/javelin/steel
				l_hand = /obj/item/clothing/head/roguetown/roguehood/poacher
				to_chat(H, span_warning("You trained to fight in loose formations, harassing your foes from afar with throwning weapons and swift attacks."))
			if("Bogguard/Cavalryman") //TRAIT_EQUESTRIAN, Expert Riding, Leech & Kneestinger Immunity. BOGGUARD LIVES!
				ADD_TRAIT(H, TRAIT_EQUESTRIAN, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/riding, SKILL_LEVEL_EXPERT, TRUE)
				if (istype (H.patron, /datum/patron/divine/dendor)) //Dendorites get Expert Swimming instead of redundant immunities.
					H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
				else
					ADD_TRAIT(H, TRAIT_LEECHIMMUNE, TRAIT_GENERIC)
					ADD_TRAIT(H, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_GENERIC)
				cloak = /obj/item/clothing/cloak/stabard/bog
				to_chat(H, span_warning("You trained in equestrianism and traversing treacherous terrains. The local bog is no less than a second home for you."))
			if("Feldsher") //Expert Medicine and a surgery bag. No TRAIT_MEDICINE_EXPERT, so you can't progress past Expert without somebody taking you on as their medicine apprentice.
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_EXPERT, TRUE)
				cloak = /obj/item/clothing/suit/roguetown/shirt/robe/feld
				beltl = /obj/item/storage/belt/rogue/surgery_bag
				to_chat(H, span_warning("You were a field chirurgeon, a healer rather than a killer. In time, you learned how to murder and became both."))
			if("Warcaster") //Wretch Spellblade that's not exclusive to racist elfs! T2 Arcyne, Magearmor, Apprentice Arcyne, 12 spell points, but worse stats -- weighted stat total of +5.
				ADD_TRAIT(H, TRAIT_ARCYNE_T2, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_MAGEARMOR, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_APPRENTICE, TRUE)
				H.change_stat(STATKEY_STR, -1)
				H.change_stat(STATKEY_CON, -1)
				H.change_stat(STATKEY_PER, -1)
				H.mind?.adjust_spellpoints(12)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/airblade)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/conjure_weapon)
				cloak = /obj/item/clothing/cloak/tabard
				to_chat(H, span_warning("You trained in the difficult skill of casting magic while clad in burdening armour. Your training paid off, but left little time or energy for physical education."))
			if("Veteran") //Master in primary weapon skills and Expert in all other weapon skills except Unarmed, but worse stats -- weighted stat total of +5.
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
				H.change_stat(STATKEY_INT, 1)
				H.change_stat(STATKEY_STR, -1)
				H.change_stat(STATKEY_WIL, -1)
				H.change_stat(STATKEY_CON, -1)
				H.change_stat(STATKEY_PER, -1)
				cloak = /obj/item/clothing/cloak/stabard/surcoat
				to_chat(H, span_warning("You fought for far too long; your body and mind are on the brink of collapse, but your muscles still remember every single swing and thrust. One last fight..."))
	wretch_select_bounty(H)

	backpack_contents = list(/obj/item/natural/cloth = 1, /obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, /obj/item/rope/chain = 1, /obj/item/storage/belt/rogue/pouch/coins/poor = 1, /obj/item/flashlight/flare/torch/lantern/prelit = 1, /obj/item/rogueweapon/scabbard/sheath = 1)

/obj/effect/proc_holder/spell/invoked/order
	name = ""
	range = 5
	associated_skill = /datum/skill/misc/athletics
	devotion_cost = 0
	chargedrain = 0
	chargetime = 0
	releasedrain = 80
	recharge_time = 2 MINUTES
	miracle = FALSE
	sound = 'sound/magic/inspire_02.ogg'


/obj/effect/proc_holder/spell/invoked/order/retreat
	name = "Tactical Retreat!"
	chargedrain = 0
	chargetime = 0
	desc = "Gives 3 SPD for your brothers!"
	overlay_state = "movemovemove"

/obj/effect/proc_holder/spell/invoked/order/retreat/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.retreattext
		if(!msg)
			to_chat(user, span_alert("I must say something to give an order!"))
			return
		if(user.job == "Deserter")
			if(!(target.job in list("Brotherhood")))
				to_chat(user, span_alert("I cannot order one not of the brotherhood cause!"))
				return
		if(target == user)
			to_chat(user, span_alert("I cannot order myself!"))
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/retreat)
		return TRUE
	revert_cast()
	return FALSE

/datum/status_effect/buff/order/retreat/nextmove_modifier()
	return 0.85

/datum/status_effect/buff/order/retreat
	id = "movemovemove"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/retreat
	effectedstats = list(STATKEY_SPD = 3)
	duration = 0.5 / 1 MINUTES

/atom/movable/screen/alert/status_effect/buff/order/retreat
	name = "Tactical Retreat!!"
	desc = "My commander has ordered me to fall back!"
	icon_state = "buff"

/datum/status_effect/buff/order/retreat/on_apply()
	. = ..()
	to_chat(owner, span_blue("My commander orders me to fall back!"))

/obj/effect/proc_holder/spell/invoked/order/bolster
	name = "Hold the Line!"
	desc = "Gives 2 CON and 3 WIL for your brothers!"
	overlay_state = "takeaim"
	chargedrain = 0
	chargetime = 0

/datum/status_effect/buff/order/bolster
	id = "takeaim"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/bolster
	effectedstats = list(STATKEY_CON = 2, STATKEY_WIL = 3)
	duration = 1 MINUTES

/atom/movable/screen/alert/status_effect/buff/order/bolster
	name = "Hold the Line!"
	desc = "My commander inspires me to endure, and last a little longer!"
	icon_state = "buff"

/datum/status_effect/buff/order/bolster/on_apply()
	. = ..()
	to_chat(owner, span_blue("My commander orders me to hold the line!"))

/obj/effect/proc_holder/spell/invoked/order/bolster/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.bolstertext
		if(!msg)
			to_chat(user, span_alert("I must say something to give an order!"))
			return
		if(user.job == "Deserter")
			if(!(target.job in list("Brotherhood")))
				to_chat(user, span_alert("I cannot order one not of the brotherhood cause!"))
				return
		if(target == user)
			to_chat(user, span_alert("I cannot order myself!"))
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/bolster)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/order/brotherhood
	name = "For the Brotherhood!"
	desc = "Your brothers won't feel any pain for a bit, also it'll help them get back on feet!"
	overlay_state = "onfeet"
	chargedrain = 0
	chargetime = 0
/obj/effect/proc_holder/spell/invoked/order/brotherhood/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.brotherhoodtext
		if(!msg)
			to_chat(user, span_alert("I must say something to give an order!"))
			return
		if(user.job == "Deserter")
			if(!(target.job in list("Brotherhood")))
				to_chat(user, span_alert("I cannot order one not of the brotherhood cause!"))
				return
		if(target == user)
			to_chat(user, span_alert("I cannot order myself!"))
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/brotherhood)
		if(!(target.mobility_flags & MOBILITY_STAND))
			target.SetUnconscious(0)
			target.SetSleeping(0)
			target.SetParalyzed(0)
			target.SetImmobilized(0)
			target.SetStun(0)
			target.SetKnockdown(0)
			target.set_resting(FALSE)
		return TRUE
	revert_cast()
	return FALSE

/datum/status_effect/buff/order/brotherhood
	id = "onfeet"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/brotherhood
	duration = 30 SECONDS

/atom/movable/screen/alert/status_effect/buff/order/brotherhood
	name = "Stand your Ground!"
	desc = "My commander has ordered me to stand proud for the brotherhood!"
	icon_state = "buff"

/datum/status_effect/buff/order/brotherhood/on_apply()
	. = ..()
	to_chat(owner, span_blue("My commander orders me to stand proud for the brotherhood!"))
	ADD_TRAIT(owner, TRAIT_NOPAIN, MAGIC_TRAIT)

/datum/status_effect/buff/order/brotherhood/on_remove()
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, MAGIC_TRAIT)
	. = ..()


/obj/effect/proc_holder/spell/invoked/order/charge
	name = "Charge!"
	desc = "Gives 2 STR and 2 PER for your brothers!"
	overlay_state = "hold"
	chargedrain = 0
	chargetime = 0

/obj/effect/proc_holder/spell/invoked/order/charge/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.holdtext
		if(!msg)
			to_chat(user, span_alert("I must say something to give an order!"))
			return
		if(user.job == "Deserter")
			if(!(target.job in list("Brotherhood")))
				to_chat(user, span_alert("I cannot order one not of the brotherhood cause!"))
				return
		if(target == user)
			to_chat(user, span_alert("I cannot order myself!"))
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/charge)
		return TRUE
	revert_cast()
	return FALSE


/datum/status_effect/buff/order/charge
	id = "hold"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/charge
	effectedstats = list(STATKEY_STR = 2, STATKEY_PER = 2)
	duration = 1 MINUTES

/atom/movable/screen/alert/status_effect/buff/order/charge
	name = "Charge!"
	desc = "My commander wills it - now is the time to charge!"
	icon_state = "buff"

/datum/status_effect/buff/order/charge/on_apply()
	. = ..()
	to_chat(owner, span_blue("My commander orders me to charge! For the brotherhood!"))



/mob/living/carbon/human/mind/proc/setorderswretch()
	set name = "Rehearse Orders"
	set category = "Voice of Command"
	mind.retreattext = input("Send a message.", "Tactical Retreat!!") as text|null
	if(!mind.retreattext)
		to_chat(src, "I must rehearse something for this order...")
		return
	mind.chargetext = input("Send a message.", "Chaaaaarge!!") as text|null
	if(!mind.chargetext)
		to_chat(src, "I must rehearse something for this order...")
		return
	mind.bolstertext = input("Send a message.", "Hold the line!!") as text|null
	if(!mind.bolstertext)
		to_chat(src, "I must rehearse something for this order...")
		return
	mind.brotherhoodtext = input("Send a message.", "Stand proud, for the brotherhood!!") as text|null
	if(!mind.brotherhoodtext)
		to_chat(src, "I must rehearse something for this order...")
		return



/obj/effect/proc_holder/spell/self/convertrole/brotherhood
	name = "Recruit Brotherhood Militia"
	new_role = "Brother"
	overlay_state = "recruit_brotherhood"
	recruitment_faction = "Brother"
	recruitment_message = "We're in this together now, %RECRUIT!"
	accept_message = "For the Brotherhood!"
	refuse_message = "I refuse."

