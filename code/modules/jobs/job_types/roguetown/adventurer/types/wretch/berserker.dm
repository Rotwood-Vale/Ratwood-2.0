/datum/advclass/wretch/berserker
	name = "Berserker"
	tutorial = "You are a warrior feared for your brutality, dedicated to using your might for your own gain. Might equals right, and you are the reminder of such a saying."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/berserker
	cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'
	class_select_category = CLASS_CAT_WARRIOR
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_STRONGBITE, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_NOPAINSTUN, TRAIT_BLOOD_RESISTANCE, TRAIT_RAGE)
	// Literally same stat spread as Atgervi Shaman
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_INT = -2,
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
	)
	subclass_stashed_items = list(
		"Sewing Kit" = /obj/item/repair_kit,
	)
	virtue_restrictions = list(
		/datum/virtue/combat/tough_hide,
	)
/datum/outfit/job/roguetown/wretch/berserker/pre_equip(mob/living/carbon/human/H)
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	backr = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/combat = 1, //Steel variant of the hunting knife. Pseudoantagonist-tier, plus an avenue to hack limbs with.
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	if(H.mind)
		H.set_blindness(0)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/rage)
		var/list/armor_choices = list("Light Armor", "Unstoppable Skin")
		var/armor_choice = input(H,"Choose your DEFENSE.", "I CAN TAKE IT!!") as anything in armor_choices
		switch(armor_choice)
			if("Light Armor")
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
			if("Unstoppable Skin")
				armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/chest/berzerker
				shirt = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/body/berzerker
		var/list/main_choices = list("Unarmed Master", "Martial Expert") // Unarmed focuses on master punching and wrestling moves, Martial gives you two expert weapon skills to be flexible
		var/category_choice = input(H, "Choose your MEANS OF VIOLENCE.", "SMASH OR SLASH!!") as anything in main_choices
		switch(category_choice)
			if("Unarmed Master")
				ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
				gloves = /obj/item/clothing/gloves/roguetown/bandages/pugilist // apperantly normal barb gets em so for consistency sake
				var/list/unarmed_options = list("Katar", "Knuckledusters", "Punch Dagger", "FISTS ONLY, NO WEAPONS EVER")
				var/weapon_choice = input(H, "Choose how you PUNCH!", "BREAK THEIR BONES.") as anything in unarmed_options
				switch(weapon_choice)
					if("Katar")
						H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
						beltr = /obj/item/rogueweapon/katar
					if("Knuckledusters")
						H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
						beltr = /obj/item/rogueweapon/knuckles/ancient
					if("Punch Dagger")
						H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
						beltr = /obj/item/rogueweapon/katar/punchdagger
					if("FISTS ONLY, NO WEAPONS EVER")
						H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
						H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_MASTER, TRUE)
						ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
						ADD_TRAIT(H, TRAIT_WEAPONLESS, TRAIT_GENERIC)
						H.change_stat(STATKEY_INT, 2)//no stat malus for pure unarmed
						H.change_stat(STATKEY_WIL, 1)//nice little bonus for our fist only chuds
			if("Martial Expert") // designed to compete with unarmed by giving you alternatives to approaching fights- only expert
				var/list/martial_options = list("Greatsword", "Battle Axe", "Grand Mace", "Grand Maul, 15 STR MIN", "Berserker's Sword, 14 STR MIN")
				var/weapon_choice = input(H, "Choose your WEAPONS of WAR!", "SPILL THEIR ENTRAILS.") as anything in martial_options
				switch(weapon_choice)
					if("Greatsword")
						H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
						r_hand = /obj/item/rogueweapon/greatsword/ancient
						backl = /obj/item/rogueweapon/scabbard/gwstrap
					if("Battle Axe")
						H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
						beltr = /obj/item/rogueweapon/stoneaxe/battle
					if("Grand Mace")
						H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
						r_hand = /obj/item/rogueweapon/mace/goden/steel
						backl = /obj/item/rogueweapon/scabbard/gwstrap
					if("Grand Maul, 15 STR MIN")
						H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
						r_hand = /obj/item/rogueweapon/mace/maul/grand
						backl = /obj/item/rogueweapon/scabbard/gwstrap
					if("Berserker's Sword, 14 STR MIN") //Swapped out the falx for this, it's a primary weapon afterall
						H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
						r_hand = /obj/item/rogueweapon/sword/long/exe/berserk
				var/list/sidearm_options = list("An Arming Sword", "An Axe", "Mace")
				var/sidearm_choice = input(H, "Choose your secondary WEAPON!", "SPILL THEIR ENTRAILS.") as anything in sidearm_options
				switch(sidearm_choice)
					if("An Arming Sword")
						H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
						beltl = /obj/item/rogueweapon/sword/iron
					if("An Axe")
						H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
						if(weapon_choice == "Battle Axe")
							ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
							beltl = /obj/item/rogueweapon/stoneaxe/battle
						else
							beltl = /obj/item/rogueweapon/stoneaxe/woodcut
					if("Mace")
						H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
						beltl = /obj/item/rogueweapon/mace
		var/helmets = list("Berserker's Volfskulle Bascinet","Steel Kettle + Wildguard")
		var/helmet_choice = input(H, "Choose your HELMET.", "STEEL YOURSELF.") as anything in helmets
		switch(helmet_choice)
			if("Berserker's Volfskulle Bascinet")
				head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker //Pseudoantagonistic-exclusive. Light AC with an on-wear trait for HELMBITING.
			if("Steel Kettle + Wildguard")
				head = /obj/item/clothing/head/roguetown/helmet/kettle
				mask = /obj/item/clothing/mask/rogue/wildguard
		wretch_select_bounty(H)
