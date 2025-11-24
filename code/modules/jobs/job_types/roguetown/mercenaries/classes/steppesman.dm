/datum/advclass/mercenary/steppesman
	name = "Liga Aavnik"
	tutorial = "As part of your mandatory service to your Kozak's Hetmen, your yearly rotation brings you from service in the Motherland's Vanguard, \
	to serve in the Liga Aavnik, the unified mercenary army of the Northern Steppe, with you; taking part in the Ferentine front. \
	Bring gold, and glory to the homeland. Chest' cherez pobedu."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/steppesman
	class_select_category = CLASS_CAT_AAVNR
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/combat_league.ogg'
	subclass_languages = list(/datum/language/aavnic)
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled
	extra_context = "This subclass has 5 loadouts with various stats, skills & equipment."
	subclass_skills = list(
	//Universal skills
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/mercenary/steppesman/pre_equip(mob/living/carbon/human/H)
	..()

	//Universal gear
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/flashlight/flare/torch,
		/obj/item/rogueweapon/huntingknife/idagger/steel,
		/obj/item/storage/belt/rogue/pouch/coins/poor,
		/obj/item/rogueweapon/whip/nagaika,
		/obj/item/rogueweapon/scabbard/sheath
		)

	// CLASS ARCHETYPES
	H.adjust_blindness(-3)
	if(H.mind)
		var/classes = list("Starshina - Saber Veteran", "Obyvatel' - Elite Sapper", "Gromoverzhets - Pálya Sapper", "Zastrel'shchik - Light Archer", "Plastunsky - Light Infantry")
		var/classchoice = input(H, "Choose your archetypes", "Available archetypes") as anything in classes

		switch(classchoice)
			if("Starshina - Saber Veteran")	//Tl;dr - medium armor class for Mount and Blade larpers who still get a saiga. Akin to Vaquero with specific drip.
				H.set_blindness(0)
				to_chat(H, span_warning("The Starshina are the Junior officer class of the Northern steppe Kozaks, veterans of conflicts across all of Grimoria. \
				Your extended time in the service grants you your shishka, shield, and armor- but make no mistake. \
				You are not some filthy Grenzel noble sipping on his bitters. Head the charge, Zoloto i slava."))
				shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman
				head = /obj/item/clothing/head/roguetown/helmet/sallet/shishak
				gloves = /obj/item/clothing/gloves/roguetown/chain
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/steppe	//Scale armor w/ better durability & unique sprite
				cloak = /obj/item/clothing/cloak/raincloak/furcloak
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				backl = /obj/item/rogueweapon/shield/iron/steppesman
				beltl= /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/sabre/steppesman
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
				H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
				H.adjust_skillrank(/datum/skill/misc/tracking, 2, TRUE)
				H.change_stat(STATKEY_STR, 2)
				H.change_stat(STATKEY_WIL, 1)
				H.change_stat(STATKEY_CON, 2)
				H.change_stat(STATKEY_SPD, 1)
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				H.dna.species.soundpack_m = new /datum/voicepack/male/evil() 	//Fits in my head all too well.
				var/masks = list(
				"Humen" 	= /obj/item/clothing/mask/rogue/facemask/steel/steppesman,
				"Beast"		= /obj/item/clothing/mask/rogue/facemask/steel/steppesman/anthro,
				"None"
		)
				var/maskchoice = input("What fits your face?", "MASK SELECTION") as anything in masks
				if(maskchoice != "None")
					mask = masks[maskchoice]

			if("Obyvatel' - Elite Sapper")	//Tl;dr - medium armor sappers with less mobility in exchange for their different statblock and equipment.
				H.set_blindness(0)
				to_chat(H, span_warning("The Obyvatel' are a uniquely trained unit of Kozaky footmen, learned in the arts of destruction, and fortification. \
				They are often the first to follow the Starshina into battle, and; are likely the first to fall. \
				You are the shield, and your brothers are the sword. Dvigaytes' ni dlya kogo." ))
				shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman
				head = /obj/item/clothing/head/roguetown/helmet/sallet/shishak
				gloves = /obj/item/clothing/gloves/roguetown/chain
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/steppe
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				backl = /obj/item/rogueweapon/shield/iron/steppesman // rucksack aka /bagpack eats whatever goes to backpack_contents so replaced with shield
				l_hand = /obj/item/rogueweapon/stoneaxe/battle/steppesman
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				backpack_contents = list(
					/obj/item/roguekey/mercenary,
					/obj/item/storage/belt/rogue/pouch/coins/poor,
					/obj/item/rogueweapon/handsaw,
					/obj/item/rogueweapon/chisel,
					/obj/item/rogueweapon/huntingknife/combat,
					/obj/item/rogueweapon/scabbard/sheath
				)
				H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
				H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, 2, TRUE)		//To avoid virtue cheese
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, 2, TRUE)		//Ditto
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, 2, TRUE)		//Ditto
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, 3, TRUE)		//Ditto
				H.adjust_skillrank_up_to(/datum/skill/craft/traps, 3, TRUE)			//Ditto
				H.change_stat(STATKEY_STR, 2)		//Statblock prone to revision. Probably will be revised. Currently weighted for 7 points and not 9.
				H.change_stat(STATKEY_WIL, 3)
				H.change_stat(STATKEY_CON, 2)
				H.change_stat(STATKEY_PER, 2)
				H.change_stat(STATKEY_SPD, -2)
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				H.dna.species.soundpack_m = new /datum/voicepack/male/evil()
				var/masks = list(
				"Humen" 	= /obj/item/clothing/mask/rogue/facemask/steel/steppesman,
				"Beast"		= /obj/item/clothing/mask/rogue/facemask/steel/steppesman/anthro,
				"None"
		)
				var/maskchoice = input("What fits your face?", "MASK SELECTION") as anything in masks
				if(maskchoice != "None")
					mask = masks[maskchoice]

			if("Gromoverzhets - Pálya Sapper")	//Tl;dr - these guys fucking EXPLODE. No whip. No dagger. Less skills. Three TNT sticks. Impact of choice. Godspeed.
				H.set_blindness(0)
				to_chat(H, span_warning("The Gromoverzhets are a smaller branch of the Obyvatel' \
				solely responsible for the handling, and frequent use- of the Company's explosives. \
				Let common sense be your guide, and your throwing arm; strong. Ne ubivay sebya, pozhaluysta."))
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
				head = /obj/item/clothing/head/roguetown/papakha
				gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
				if(should_wear_femme_clothes(H))
					armor = /obj/item/clothing/suit/roguetown/armor/leather/studded/bikini
				else
					armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/steppe
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				backl = /obj/item/rogueweapon/shield/iron/steppesman
				beltl = /obj/item/tntstick
				beltr = /obj/item/tntstick
				l_hand = /obj/item/rogueweapon/stoneaxe/battle/steppesman
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				//No whip, dagger, etc. Only the explosives and some basic stuff.
				backpack_contents = list(
					/obj/item/roguekey/mercenary,
					/obj/item/storage/belt/rogue/pouch/coins/poor,
					/obj/item/tntstick
					)
				H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)//One less axe skill.
				H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)//One less shield skill.
				H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
				H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, 2, TRUE)		//To avoid virtue cheese
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, 2, TRUE)		//Ditto
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, 3, TRUE)		//Ditto
				H.adjust_skillrank_up_to(/datum/skill/craft/traps, 3, TRUE)			//Ditto
				H.change_stat(STATKEY_WIL, 3)		//Two less speed, no con, compared to 'elite' sappers. 7 spread.
				H.change_stat(STATKEY_STR, 2)
				H.change_stat(STATKEY_PER, 2)
				H.change_stat(STATKEY_SPD, -4)
				ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)//No armour skill. They get BOMBS.
				H.dna.species.soundpack_m = new /datum/voicepack/male/evil()
				var/masks = list(
				"Humen" 	= /obj/item/clothing/mask/rogue/facemask/steel/steppesman,
				"Beast"		= /obj/item/clothing/mask/rogue/facemask/steel/steppesman/anthro,
				"None"
		)
				var/maskchoice = input("What fits your face?", "MASK SELECTION") as anything in masks
				if(maskchoice != "None")
					mask = masks[maskchoice]

				var/special_grenade = list(
				"EXPLOSIVE"			= /obj/item/impact_grenade/explosion,
				"DUST"				= /obj/item/impact_grenade/smoke,
				"POISON"			= /obj/item/impact_grenade/smoke/poison_gas,
				"CONFLAGRATION"		= /obj/item/impact_grenade/smoke/fire_gas,
				"BLINDING"			= /obj/item/impact_grenade/smoke/blind_gas,
				"None"
		)
				var/grenade_choice = input("What impact grenade do you carry?", "IMPACT SELECTION") as anything in special_grenade
				if(grenade_choice != "None")
					r_hand = special_grenade[grenade_choice]
				else//Do they not take a grenade? Engineering skill and alchemy. They're a bomb factory.
					H.adjust_skillrank_up_to(/datum/skill/craft/engineering, 2, TRUE)	//Eeyup.
					H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 2, TRUE)	//This ain't a pie factory.


			if("Zastrel'shchik - Light Archer")	//Tl;dr - light armor class for Tatar-style archery.
				H.set_blindness(0)
				to_chat(H, span_warning("The Gromoverzhets are a smaller branch of the Obyvatel' \
				solely responsible for the handling, and frequent use- of the Company's explosives. \
				Let common sense be your guide, and your throwing arm; strong. Ne ubivay sebya, pozhaluysta."))
				shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman
				head = /obj/item/clothing/head/roguetown/helmet/sallet/shishak
				gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/steppe
				cloak = /obj/item/clothing/cloak/raincloak/furcloak
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
				beltr = /obj/item/quiver/javelin/iron
				beltl = /obj/item/quiver/arrows
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/steppesman
				neck = /obj/item/clothing/neck/roguetown/leather
				H.adjust_skillrank(/datum/skill/combat/bows, 5, TRUE)
				H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/slings, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
				H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
				H.adjust_skillrank(/datum/skill/misc/tracking, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
				H.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
				H.change_stat(STATKEY_PER, 3)
				H.change_stat(STATKEY_WIL, 2)
				H.change_stat(STATKEY_SPD, 2)
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)

			if("Plastunsky - Light Infantry")		//Tl;dr - Old Steppesman whip build, light armor, be the glass canon you always wanted to be. Live your life, king.
				H.set_blindness(0)
				to_chat(H, span_warning("Being an Aavnic, and part of a Kozak is not a title one earns, nor is born with. It's a way of life. \
				Eccentric frontiersmen who look Noble, and Peasant in the eye, in the same light. \
				Freshly conscripted, these men serve as Plastunsky, and carry whatever they brought along to the fight. \
				Peasant levy as they may seem- they are the bane of civilized warriors. Pust' chetyre zverya vedut tebya." ))
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
				head = /obj/item/clothing/head/roguetown/papakha	//No helm
				gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/steppe
				cloak = /obj/item/clothing/cloak/volfmantle			//Crazed man, gives the look.
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
				beltr = /obj/item/rogueweapon/shield/buckler		//Doesn't get good shield skill + no armor, so they get this to compensate for no parry on whip.
				beltl = /obj/item/rogueweapon/whip
				neck = /obj/item/clothing/neck/roguetown/bevor		//Better neckpiece for slightly less skill variety. Based it off a cool piece of art...
				H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
				H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)		//Bit high but he doesn't get huge strength boons so makes up for it. Same as a guard.
				H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
				H.adjust_skillrank(/datum/skill/misc/tracking, 2, TRUE)
				H.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
				H.change_stat(STATKEY_STR, 1)
				H.change_stat(STATKEY_PER, 2)
				H.change_stat(STATKEY_WIL, 1)
				H.change_stat(STATKEY_SPD, 2)
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_OUTDOORSMAN, TRAIT_GENERIC)
				H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()		//Semi-crazed warrior vibe.

	H.merctype = 11
