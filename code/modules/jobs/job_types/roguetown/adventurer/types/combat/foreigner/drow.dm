/datum/advclass/foreigner/drow
	name = "Crocs de l'araignée Débroussaillage"//idea is these guys are important enough to be considered to join, but not important enough to get the badges of office like the spider mount, the unique mask, etc. They get most but not all.
	tutorial = "The Crocs de l'araignée, translated literally to mean \"Spider's Teeth\", is a renowned collective of blades, \
	whips, and riders for hire often employed in the vast drow undercity complexes and occasionally the surface above. \
	You are at the bottom of this proud sorority of sadists. Prior to full-membership, aspiriants like yourself must prove themselves before their undercity's guild matriarch. \
	While formally called Auxiliaire, the prejorative Débroussaillage, translated as \"Weed Trimmings\", is the far more common title \
	given how few succeed - let alone survive - the grueling recruitment period."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/elf/dark,
		/datum/species/human/halfelf, // Because half-drows are half-elves, guh.
	)
	outfit = /datum/outfit/job/roguetown/adventurer/drow
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/combat_delf.ogg'
	traits_applied = list(TRAIT_DARKVISION)
	subclass_stats = list(
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,//you learn to backstab early
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN, 
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,

	)
	extra_context = "This subclass is race-limited to: Dark Elves Only. \
	This subclass can choose between dodge expert with SPD 2, WIL 2, and PER 1 \
	or medium armor with STR 2, CON 2, and WIL 1. \
	Female drow recieve nutcracker and bedbreaker. Male drow \
	lose -1 STR & -1 LCK, but gain 1 SPD & 1 WIL."

/datum/outfit/job/roguetown/adventurer/drow/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)	
		var/specialization = list("Arbalétrière \"Crossbowyer\"", "Escrimeuse \"Swordswoman\"", "Piqueuse \"Whipper\"")
		var/specialization_choice = input(H, "What do you strive for?", "CHOOSE YOUR DISCIPLINE") as anything in specialization
		switch(specialization_choice)
			if("Arbalétrière \"Crossbowyer\"")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow/stalker/lesser//1:1 with regular slurbow, still good, just not as fancy
				beltr =  /obj/item/quiver/bolts/
			if("Escrimeuse \"Swordswoman\"")
				var/swords = list("Falx", "Sabre", "Greatsabre", "Shotel", "Thrusting Longsword")
				var/sword_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in swords
				switch(sword_choice)
					if("Falx")
						H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
						beltr = /obj/item/rogueweapon/scabbard/sword
						r_hand = /obj/item/rogueweapon/sword/falx/stalker
					if("Sabre")
						H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
						beltr = /obj/item/rogueweapon/scabbard/sword
						r_hand = /obj/item/rogueweapon/sword/sabre/stalker
					if("Greatsabre")
						H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
						beltr = /obj/item/rogueweapon/scabbard/sword
						r_hand = /obj/item/rogueweapon/sword/long/elf/stalker
					if("Shotel")
						H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
						beltr = /obj/item/rogueweapon/scabbard/sword
						r_hand = /obj/item/rogueweapon/sword/long/shotel/stalker
					if("Thrusting Longsword")
						H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
						beltr = /obj/item/rogueweapon/scabbard/sword
						r_hand = /obj/item/rogueweapon/sword/long/stalker
			if("Piqueuse \"Whipper\"")
				var/whips = list("Whip", "Urumi", "Greatflail - 12 STR Min")
				var/whip_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in whips
				switch(whip_choice)
					if("Whip")
						H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN, TRUE)
						r_hand = /obj/item/rogueweapon/whip/spiderwhip
					if("Urumi")
						H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN, TRUE)
						r_hand = /obj/item/rogueweapon/whip/urumi
					if("Greatflail - 12 STR Min")
						H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN, TRUE)
						r_hand = /obj/item/rogueweapon/flail/peasantwarflail/stalker

		var/armors = list("Dodge Expert", "Medium Armor")
		var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
		switch(armorchoice)
			if("Dodge Expert")
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				H.change_stat(STATKEY_WIL, 1)
				H.change_stat(STATKEY_SPD, 2)
				H.change_stat(STATKEY_PER, 1)
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/shadowrobe
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/shadowvest
				cloak = /obj/item/clothing/cloak/shadowcloak
				gloves = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/elflock
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
				mask = /obj/item/clothing/mask/rogue/shepherd/shadowmask/delf
				neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
				backl = /obj/item/storage/backpack/rogue/satchel/black
				backpack_contents = list( 
					/obj/item/storage/belt/rogue/pouch/coins/poor = 1, 
					/obj/item/rogueweapon/huntingknife/idagger/steel/dirk = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1,
					)
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
				belt = /obj/item/storage/belt/rogue/leather/black
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants
			if("Medium Armor")
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				H.change_stat(STATKEY_STR, 2)
				H.change_stat(STATKEY_CON, 2)
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
				belt = /obj/item/storage/belt/rogue/leather/black
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants/maille
				backl = /obj/item/storage/backpack/rogue/satchel/black
				backpack_contents = list(
					/obj/item/storage/belt/rogue/pouch/coins/poor = 1, 
					/obj/item/rogueweapon/huntingknife/idagger/steel/dirk = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1
					)
				armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/shadowplate
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/shadowrobe
				gloves = /obj/item/clothing/gloves/roguetown/plate/shadowgauntlets
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
				mask = /obj/item/clothing/mask/rogue/facemask
				neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
				backr = /obj/item/rogueweapon/shield/tower
		var/helmets = list("Full Chain Coif", "Smiling Bascinet", "Visored Sallet", "Kettle", "Elven Barbute", "Winged Elven Barbute")
		var/helmet_choice = input(H, "How do you dress?", "Get dressed.") as anything in helmets
		switch(helmet_choice)
			if("Full Chain Coif")
				head = /obj/item/clothing/neck/roguetown/chaincoif/full/black
			if("Smiling Bascinet")
				head = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/shadowplate
			if("Visored Sallet")
				head = /obj/item/clothing/head/roguetown/helmet/sallet/visored/shadow
			if("Kettle")
				head = /obj/item/clothing/head/roguetown/helmet/kettle/shadow
			if("Elven Barbute")
				head = /obj/item/clothing/head/roguetown/helmet/elvenbarbute/shadow
			if("Winged Elven Barbute")
				head = /obj/item/clothing/head/roguetown/helmet/elvenbarbute/winged/shadow

	if(H.gender == FEMALE)
		ADD_TRAIT(H, TRAIT_DEATHBYSNUSNU, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NUTCRACKER, TRAIT_GENERIC) // female drow have a certain stereotype
	
	if(H.gender == MALE)
		H.change_stat(STATKEY_STR, -1)
		H.change_stat(STATKEY_LCK, -1)//you dont want to be a male underdwelling drow
		H.change_stat(STATKEY_WIL, 1)//more likely to have been beaten = more pain tolerance
		H.change_stat(STATKEY_SPD, 1)

	if(H.age == AGE_OLD)//since these guys just get journeyman save for crossbows, they get the old age skill buff like exorcist. We want drow hags, sire.
		ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC) // YEARS of experience
		H.adjust_skillrank(/datum/skill/misc/riding, 1, TRUE)//sex joke
		H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)
