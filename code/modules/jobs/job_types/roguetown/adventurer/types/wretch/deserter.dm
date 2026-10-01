/datum/advclass/wretch/deserter_knight
	name = "Disgraced Knight"
	tutorial = "You were once a venerated and revered knight - now, a traitor who abandoned your liege. You lyve the lyfe of an outlaw, shunned and looked down upon by society."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	outfit = /datum/outfit/job/roguetown/wretch/deserter
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_EQUESTRIAN, TRAIT_DISGRACED_NOBLE, TRAIT_BOGWALKER)
	maximum_possible_slots = 2 //Ideal role for fraggers. Better to limit it.

	cmode_music = 'sound/music/cmode/antag/combat_disgraced.ogg' // New music since I had some unused oggs around anyway.
	class_select_category = CLASS_CAT_WARRIOR
	// Deserter are the knight-equivalence. They get a balanced, straightforward 11 weighted balance to endure and overcome.
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_CON = 3,
		STATKEY_STR = 2,
		STATKEY_PER = 2,
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
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE, //no miracles to deal w/ stabs through plate armor
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"Armor Plates" =  /obj/item/repair_kit/metal,
	)
	extra_context = "This class is restricted from using the Equestrian virtue."

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
			"Broadsword",
			"Mace + Shield",
			"Flail + Shield",
			"Longsword + Shield",
			"Lucerne",
			"Battle Axe",
			"Lance + Kite Shield",
			"Samshir",
			"Ssangsudo",
			"Shashka + Shield",
			"Steel Flameberge",
			"Grand Mace",
			"Polehammer"
		)
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Estoc")
				r_hand = /obj/item/rogueweapon/estoc
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("Broadsword")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long/broadsword
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
				beltr = /obj/item/rogueweapon/scabbard/sword
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("Ssangsudo")
				r_hand = /obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo
				beltr = /obj/item/rogueweapon/scabbard/sword/kazengun/noparry
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("Shashka + Shield")
				r_hand = /obj/item/rogueweapon/sword/sabre/steppesman
				beltr = /obj/item/rogueweapon/scabbard/sword
				backr = /obj/item/rogueweapon/shield/iron/steppesman
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("Steel Flameberge")
				r_hand = /obj/item/rogueweapon/greatsword/grenz/flamberge
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("Grand Mace")
				r_hand = /obj/item/rogueweapon/mace/goden/steel
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
			if("Polehammer")
				r_hand = /obj/item/rogueweapon/eaglebeak
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)

		var/helmets = list(
			"Pigface Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"Knight's Armet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"Visored Sallet"			= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"Snouted Visored Sallet"			= /obj/item/clothing/head/roguetown/helmet/sallet/visored/snouted,
			"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"Snouted Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/snouted,
			"Hounskull Bascinet"		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"Etruscan Bascinet"		= /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"Slitted Kettle"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"Kulah Khud"	= /obj/item/clothing/head/roguetown/helmet/sallet/zyb,
			"Kabuto"	= /obj/item/clothing/head/roguetown/helmet/heavy/kabuto, //No mask, fuck you
			"Shishak"	= /obj/item/clothing/head/roguetown/helmet/sallet/shishak,
			"Volfskulle Bascinet"		= /obj/item/clothing/head/roguetown/helmet/heavy/volfplate,
			"Roundface Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface,
			"Snouted Roundface Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface/snouted,
			"Froggemund Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth,
			"Cataphract Helmet" = /obj/item/clothing/head/roguetown/helmet/heavy/cataphract,
			"Beaked Helmet" = /obj/item/clothing/head/roguetown/helmet/heavy/beakhelm,
			"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

		var/armors = list(
			"Fullplate"			= /obj/item/clothing/suit/roguetown/armor/plate/full,
			"Fluted Fullplate"		= /obj/item/clothing/suit/roguetown/armor/plate/full/fluted,
			"Fluted Cuirass"	= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted,
			"Steel Cuirass"		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass,
			"Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine,
			"Coat of Plates"		= /obj/item/clothing/suit/roguetown/armor/brigandine/coatplates,
			"Half-Plate"		= /obj/item/clothing/suit/roguetown/armor/plate,
			"Lamellar Scalemail"		= /obj/item/clothing/suit/roguetown/armor/plate/scale/steppe,
			"Haraate Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine/haraate,
			"Cataphract's Armor"	= /obj/item/clothing/suit/roguetown/armor/plate/cataphract,
		)
		var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
		armor = armors[armorchoice]
		wretch_select_bounty(H)
	gloves = /obj/item/clothing/gloves/roguetown/plate
	pants = /obj/item/clothing/under/roguetown/platelegs
	neck = /obj/item/clothing/neck/roguetown/bevor
	cloak = /obj/item/clothing/cloak/tabard/black
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset //less meta
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel //gwstraps landing on backr asyncs with backpack_contents
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)
	if(H.age == AGE_OLD) // To discourage old strugglers
		H.change_stat(STATKEY_PER, 2)
		H.change_stat(STATKEY_CON, 2)
		H.change_stat(STATKEY_SPD, -2) //We're crippling you little buddy
		H.change_stat(STATKEY_LCK, -1) 
	if (H.mind)
		H.AddSpell(new /obj/effect/proc_holder/spell/self/choose_riding_virtue_mount)

/datum/advclass/wretch/deserter/maa
	name = "Deserter"
	tutorial = "You had your post. You had your duty. Dissatisfied, lacking in morale, or simply thinking yourself better than it. - You decided to walk. Now it follows you everywhere you go."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/wretch/deserter/maa

	class_select_category = CLASS_CAT_WARRIOR
	category_tags = list(CTAG_WRETCH)
	//frankly, this is probably not going to happen consistantly with a massive tide of bogmen. If it does uhh, honestly. hilarious.
	//Worst case nuke this to 5 slots, or 4. If it becomes a problem.

	subclass_stashed_items = list(
		"Armor Plates" =	/obj/item/repair_kit/metal,
	)

	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg' // same as regular bandits
	// Slightly more rounded. These can be nudged as needed.
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_BOGWALKER)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 2,
		STATKEY_PER = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN, //Unique only case here, pick crossbow if you want to exceed in crossbows. Otherwise you're decently okay at it.
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT, // Better at climbing away than your average MaA. Only slightly.
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN, // Worse at swimming than the above class.
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE, //No miracles to deal w/ stabs through plate/maile armor
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE, //So you can repair your heater shield + build in the bogs
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE, //So you can maintain your metal gear
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE, //Ditto
	)

/datum/outfit/job/roguetown/wretch/deserter/maa/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/weapons = list("Warhammer & Shield","Sabre & Shield","Axe & Shield","Billhook","Greataxe","Halberd","Crossbow")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Warhammer & Shield")
				beltr = /obj/item/rogueweapon/mace/warhammer/steel
				backl = /obj/item/rogueweapon/shield/heater
			if("Sabre & Shield")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/sabre
				backl = /obj/item/rogueweapon/shield/heater
			if("Axe & Shield")
				beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel
				backl = /obj/item/rogueweapon/shield/heater
			if("Billhook")
				r_hand = /obj/item/rogueweapon/spear/billhook
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Halberd")
				r_hand = /obj/item/rogueweapon/halberd
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Greataxe")
				r_hand = /obj/item/rogueweapon/greataxe
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Crossbow")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltr = /obj/item/quiver/heavybluntbolts


	H.verbs += /mob/living/carbon/human/mind/proc/setorders //Kill if problematic
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/retreat)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/bolster)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/brotherhood)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/charge)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/brotherhood)
	H.verbs |= list(/mob/proc/haltyell, /mob/living/carbon/human/mind/proc/setorders)

		/*
		meant to be less knightly-helmets and more in-line with banditry, brigand loadouts and such so, so no armlets

		we limit this so you have to look moderately evil or suspiciously wearing old-style helmets
		*/
		var/helmets = list(
			"Pigface Bascinet"		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"Hounskull Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"Klappvisier Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"Volfskulle Bascinet"		= /obj/item/clothing/head/roguetown/helmet/heavy/volfplate,
			"Visored Sallet"		= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"Snouted Visored Sallet"		= /obj/item/clothing/head/roguetown/helmet/sallet/visored/snouted,
			"Visored Kettle Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		head = helmets[helmchoice]

		var/armors = list(
			"Cuirass"			= /obj/item/clothing/suit/roguetown/armor/plate/cuirass,
			"Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine,
			"Fluted Cuirass"		= /obj/item/clothing/suit/roguetown/armor/plate/half/fluted,
			"Scalemail"			= /obj/item/clothing/suit/roguetown/armor/plate/scale,
		)
		var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
		armor = armors[armorchoice]

		var/cloaks = list("Bog Green","Black","Brown and Longcoat")
		var/cloak_choice = input(H, "Choose your cloak.", "FOR THE BOG") as anything in cloaks
		switch(cloak_choice)
			if("Bog Green")
				cloak = /obj/item/clothing/cloak/stabard/bog
				mask = /obj/item/clothing/head/roguetown/roguehood/bogman
			if("Black")
				cloak = /obj/item/clothing/cloak/tabard/stabard/dungeon
				mask = /obj/item/clothing/head/roguetown/roguehood/bogman/black
			if("Brown and Longcoat")
				cloak = /obj/item/clothing/suit/roguetown/armor/longcoat/brown
				mask = /obj/item/clothing/head/roguetown/roguehood/bogman/brown

		wretch_select_bounty(H)

	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	pants = /obj/item/clothing/under/roguetown/chainlegs
	neck = /obj/item/clothing/neck/roguetown/bevor
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/chain
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	beltl = /obj/item/rogueweapon/mace/cudgel
	belt = /obj/item/storage/belt/rogue/leather
	backr = /obj/item/storage/backpack/rogue/satchel

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

