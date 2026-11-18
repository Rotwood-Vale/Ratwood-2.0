/datum/advclass/agent/sicaire
	name = "Otavan Sicaires"
	tutorial = "The Sicaires are a feared order of thieves, assassins, and infiltrators who unlike the routiers, prefer to work among the shadows and rooftops of Otava. Known for kidnapping townfolk of the streets, whether they are a heretic, or simply someone who pissed off the wrong kind of person. Often hired by high-ranking noble figures to take care of political threats to their standing.."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = NON_DWARVEN_RACE_TYPES
	outfit = /datum/outfit/job/roguetown/agent/sicaire
	class_select_category = CLASS_CAT_OTAVA
	category_tags = list(CTAG_COURTAGENT)
	cmode_music = 'sound/music/templarofpsydonia.ogg'
	traits_applied = list(TRAIT_DARKVISION, TRAIT_DODGEEXPERT, TRAIT_LEAPER)
	subclass_languages = list(/datum/language/thievescant, /datum/language/otavan)
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 1,
		STATKEY_SPD = 3,
		STATKEY_STR = -1
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN, 
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN, 
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)
	
/datum/outfit/job/roguetown/agent/sicaire/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/classes = list("L'Enleveur", "Le Bagarreur", "L'Éclaireur")
		var/classchoice = input(H, "Choose your class.", "What is your specialty?") as anything in classes
		switch(classchoice)
			if("L'Éclaireur")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow/stalker
				beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/rondel
				beltr = /obj/item/quiver/bolts
				belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/steel
				neck = /obj/item/clothing/head/roguetown/helmet/leather/armorhood/advanced
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
				cloak = /obj/item/clothing/suit/roguetown/armor/longcoat
				backr = /obj/item/storage/backpack/rogue/satchel/black
				gloves = /obj/item/clothing/gloves/roguetown/otavan
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
				head = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood/black
				shoes = /obj/item/clothing/shoes/roguetown/boots/otavan
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
				backpack_contents = list(
					/obj/item/roguekey/mercenary = 1,
					/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
					/obj/item/rogueweapon/huntingknife/idagger/steel/rondel = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1,
					/obj/item/lockpickring/mundane = 1,
					/obj/item/grapplinghook = 1,
				)

			if("Le Bagarreur")
				ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
				H.change_stat(STATKEY_STR, 2)
				H.change_stat(STATKEY_CON, 2)
				H.change_stat(STATKEY_SPD, -3)
				H.change_stat(STATKEY_PER, -1)
				H.change_stat(STATKEY_WIL, 1)
				beltl = /obj/item/rogueweapon/stoneaxe/hurlbat
				beltr = /obj/item/rogueweapon/stoneaxe/hurlbat
				belt = /obj/item/storage/belt/rogue/leather/battleskirt/faulds/black
				neck = /obj/item/clothing/head/roguetown/helmet/leather/armorhood/advanced
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
				cloak = /obj/item/clothing/suit/roguetown/armor/longcoat
				backr = /obj/item/storage/backpack/rogue/satchel/black
				gloves = /obj/item/clothing/gloves/roguetown/bandages/pugilist
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
				head = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood/black
				shoes = /obj/item/clothing/shoes/roguetown/boots/otavan
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
				backpack_contents = list(
							/obj/item/roguekey/mercenary = 1,
							/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
							/obj/item/rogueweapon/huntingknife/idagger/steel/rondel = 1,
							/obj/item/rogueweapon/scabbard/sheath = 1,
							/obj/item/lockpick = 1,
						)
				var/techniques = list("Dropkick - Pushback + Extra Damage", "Chokeslam - Stamina Damage", "Stunner - Dazed Debuff", "Headbutt - Vulnerable Debuff")
				var/technique_choice = input(H, "Choose your TECHNIQUE.", "TOSS THEM.") as anything in techniques
				switch(technique_choice)
					if("Dropkick - Pushback + Extra Damage")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dropkick)
					if("Chokeslam - Stamina Damage")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/chokeslam)
					if("Stunner - Dazed Debuff")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stunner)
					if("Headbutt - Vulnerable Debuff")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/headbutt)
			if("L'Enleveur")
				ADD_TRAIT(H, TRAIT_BLACKBAGGER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sheath
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/rondel
				belt = /obj/item/storage/belt/rogue/leather/battleskirt/faulds/black
				neck = /obj/item/clothing/head/roguetown/helmet/leather/armorhood/advanced
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
				cloak = /obj/item/clothing/suit/roguetown/armor/longcoat
				backr = /obj/item/storage/backpack/rogue/satchel/black
				gloves = /obj/item/clothing/gloves/roguetown/otavan
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
				head = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood/black
				shoes = /obj/item/clothing/shoes/roguetown/boots/otavan
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
				backpack_contents = list(
					/obj/item/roguekey/mercenary = 1,
					/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
					/obj/item/rogueweapon/huntingknife/idagger/steel/rondel = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1,
					/obj/item/inqarticles/garrote = 1,
					/obj/item/clothing/head/inqarticles/blackbag = 1,
					/obj/item/lockpickring/mundane = 1,
				)
				
/obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood/black
	color = CLOTHING_BLACK
/obj/item/storage/belt/rogue/leather/battleskirt/faulds/black
	color = CLOTHING_BLACK
