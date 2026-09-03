/datum/advclass/mercenary/crocs // formerly Anthrax.dm
	name = "Crocs de l'araignée Cavalier"
	tutorial = "The Crocs de l'araignée, translated literally to mean \"Spider's Teeth\", is a renowned collective of blades, whips, and riders for hire often employed in the vast drow undercity complexes and occasionally the surface above. Infamous for their battlefrenzy, sadism, and mastery over arachnid cavalry, a member of the Spider's Teeth stands among some of the fiercest if cruelest warriors in Psydonia. Dark elves ultimately are only truly aligned to themselves and their own interests; this trait makes them surprisingly pragmatic and straightforward mercenaries, as a drow can be counted on to do any job so long as the price is right and it serves whatever higher ambition they might have."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/elf/dark,
		/datum/species/human/halfelf, // Because half-drows are half-elves, guh.
	)
	outfit = /datum/outfit/job/roguetown/mercenary/crocs
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_MERCENARY)

	cmode_music = 'sound/music/combat_delf.ogg'

	traits_applied = list(TRAIT_DARKVISION, TRAIT_MEDIUMARMOR, TRAIT_EQUESTRIAN)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 1,
	)

	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN, 
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,

	)
	extra_context = "This subclass is race-limited to: Dark Elves Only."
	


/datum/outfit/job/roguetown/mercenary/crocs/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/weapons = list("Sabre","Shotel","Aruval","Hooksword","Falx","Greatsabre","Thrusting Longsword","Kriegmesser","Whip","Spined Greatflail, 12 STR MIN","Hefty Greatflail, 13 STR MIN")
		var/weapon_choice = input(H, "Choose your weapon.", "How do you kill?") as anything in weapons
		switch(weapon_choice)
			if("Sabre")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/rogueweapon/shield/tower/spidershield
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/sabre/stalker
			if("Shotel")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/rogueweapon/shield/tower/spidershield
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long/shotel/stalker
			if("Aruval")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/rogueweapon/shield/tower/spidershield
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long/rhomphaia/stalker
			if("Hooksword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/rogueweapon/shield/tower/spidershield
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/sabre/hook/stalker
			if("Falx")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/rogueweapon/shield/tower/spidershield
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/falx/stalker
			if("Greatsabre")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/rogueweapon/shield/tower/spidershield
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long/elf/stalker
			if("Thrusting Longsword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/rogueweapon/shield/tower/spidershield
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long/stalker
			if("Kriegmesser")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/rogueweapon/shield/tower/spidershield
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long/kriegmesser/stalker
			if("Whip")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/rogueweapon/shield/tower/spidershield
				r_hand = /obj/item/rogueweapon/whip/spiderwhip
			if("Spined Greatflail, 12 STR MIN")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/flail/peasantwarflail/stalker
			if("Hefty Greatflail, 13 STR MIN")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/flail/peasantwarflail/stalker/alt
		var/riding = list("I'm a spider-rider", "I'm a foot-soldier")
		var/ridingchoice = input(H, "Choose your faith", "FAITH") as anything in riding
		switch(ridingchoice)
			if("I'm a spider-rider")
				l_hand = /obj/item/bait/spider
			if("I'm a foot-soldier")
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
		var/helmets = list("Full Chain Coif + Mantle", "Smiling Bascinet", "Winged Armet")
		var/helmet_choice = input(H, "How do you dress?", "Get dressed.") as anything in helmets
		switch(helmet_choice)
			if("Full Chain Coif + Mantle")
				head = /obj/item/clothing/neck/roguetown/chaincoif/full/black
			if("Smiling Bascinet")
				head = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/shadowplate
			if("Winged Armet")
				head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/shadowplate

	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants/maille
	backl = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1, 
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1, 
		/obj/item/rogueweapon/huntingknife/idagger/steel/dirk = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/shadowplate
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/shadowrobe
	gloves = /obj/item/clothing/gloves/roguetown/plate/shadowgauntlets
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	mask = /obj/item/clothing/mask/rogue/facemask/shadowfacemask
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	beltl = /obj/item/rope/chain
	
	
	if(H.gender == FEMALE)
		ADD_TRAIT(H, TRAIT_DEATHBYSNUSNU, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NUTCRACKER, TRAIT_GENERIC) // female drow have a certain stereotype
	
	if(H.gender == MALE)
		H.change_stat(STATKEY_STR, -1)
		H.change_stat(STATKEY_LCK, -1)//you dont want to be a male underdwelling drow
		H.change_stat(STATKEY_WIL, 1)//more likely to have been beaten = more pain tolerance
		H.change_stat(STATKEY_SPD, 1)

	if(H.age == AGE_OLD)
		ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC) // YEARS of experience
		H.adjust_skillrank_up_to(/datum/skill/misc/riding, SKILL_LEVEL_MASTER, TRUE)//sex joke
	

	H.merctype = 15

/datum/advclass/mercenary/crocsass
	name = "Crocs de l'araignée Assassin"
	tutorial = "The Crocs de l'araignée, translated literally to mean \"Spider's Teeth\", is a renowned collective of blades, whips, and riders for hire often employed in the vast drow undercity complexes and occasionally the surface above. Infamous for their battlefrenzy, sadism, and mastery over arachnid cavalry, a member of the Spider's Teeth stands among some of the fiercest if cruelest warriors in Psydonia. Dark elves ultimately are only truly aligned to themselves and their own interests; this trait makes them surprisingly pragmatic and straightforward mercenaries, as a drow can be counted on to do any job so long as the price is right and it serves whatever higher ambition they might have."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/elf/dark,
		/datum/species/human/halfelf, // Because half-drows are half-elves, guh.
	)
	outfit = /datum/outfit/job/roguetown/mercenary/crocs
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_MERCENARY)

	cmode_music = 'sound/music/combat_delf.ogg'
	outfit = /datum/outfit/job/roguetown/mercenary/crocsass
	traits_applied = list(TRAIT_DARKVISION, TRAIT_DODGEEXPERT, TRAIT_EQUESTRIAN, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 1,
		STATKEY_SPD = 3,
		STATKEY_STR = -1
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN, 
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN, 
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)
	
/datum/outfit/job/roguetown/mercenary/crocsass/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/weapons = list("Slurbow","Shortbow","Dual Daggers","Dual Hookswords","Dual Falx","Dual Shotel","Dual Whips")
		var/weapon_choice = input(H, "Choose your weapon.", "How do you kill?") as anything in weapons
		switch(weapon_choice)
			if("Slurbow")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow/stalker
				beltl = /obj/item/rogueweapon/sword/falx/stalker//backup
				beltr =  /obj/item/quiver/bolts/
			if("Shortbow")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/sword/falx/stalker//backup
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
				beltr = /obj/item/quiver/poisonarrows/
			if("Dual Daggers")
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sheath
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/dirk
			if("Dual Hookswords")
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/rogueweapon/scabbard/sword
				beltl = /obj/item/rogueweapon/scabbard/sword
				beltr = /obj/item/rogueweapon/sword/sabre/hook/stalker
				r_hand = /obj/item/rogueweapon/sword/sabre/hook/stalker
			if("Dual Falx")
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/rogueweapon/scabbard/sword
				beltl = /obj/item/rogueweapon/scabbard/sword
				beltr = /obj/item/rogueweapon/sword/falx/stalker
				r_hand = /obj/item/rogueweapon/sword/falx/stalker
			if("Dual Sabers")
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/rogueweapon/scabbard/sword
				beltl = /obj/item/rogueweapon/scabbard/sword
				beltr = /obj/item/rogueweapon/sword/sabre/stalker
				r_hand = /obj/item/rogueweapon/sword/sabre/stalker
			if("Dual Shotel")
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/rogueweapon/scabbard/sword
				beltl = /obj/item/rogueweapon/scabbard/sword
				beltr = /obj/item/rogueweapon/sword/long/shotel/stalker
				r_hand = /obj/item/rogueweapon/sword/long/shotel/stalker
			if("Dual Whips")//hilarious
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/rogueweapon/whip/spiderwhip
				beltl = /obj/item/rogueweapon/whip/spiderwhip
		var/riding = list("I'm a spider-rider", "I'm a foot-soldier")
		var/ridingchoice = input(H, "Choose your faith", "FAITH") as anything in riding
		switch(ridingchoice)
			if("I'm a spider-rider")
				l_hand = /obj/item/bait/spider
			if("I'm a foot-soldier")
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
		var/helmets = list("Full Chain Coif + Mantle", "Smiling Bascinet")
		var/helmet_choice = input(H, "How do you dress?", "Get dressed.") as anything in helmets
		switch(helmet_choice)
			if("Full Chain Coif + Mantle")
				head = /obj/item/clothing/neck/roguetown/chaincoif/full/black
			if("Smiling Bascinet")
				head = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/shadowplate

	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/shadowrobe
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/shadowvest
	cloak = /obj/item/clothing/cloak/shadowcloak
	gloves = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/elflock
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	mask = /obj/item/clothing/mask/rogue/shepherd/shadowmask/delf
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	backl = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1, 
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1, 
		/obj/item/rogueweapon/huntingknife/idagger/steel/dirk = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/lockpick = 1
		)
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants
	
	if(H.gender == FEMALE)
		ADD_TRAIT(H, TRAIT_DEATHBYSNUSNU, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NUTCRACKER, TRAIT_GENERIC) // female drow have a certain stereotype
	
	if(H.gender == MALE)
		H.change_stat(STATKEY_STR, -1)
		H.change_stat(STATKEY_LCK, -1)//you dont want to be a male underdwelling drow
		H.change_stat(STATKEY_WIL, 1)//more likely to have been beaten = more pain tolerance
		H.change_stat(STATKEY_SPD, 1)

	if(H.age == AGE_OLD)
		ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC) // YEARS of experience
		H.adjust_skillrank_up_to(/datum/skill/misc/riding, SKILL_LEVEL_MASTER, TRUE)//sex joke
	
	H.merctype = 15
