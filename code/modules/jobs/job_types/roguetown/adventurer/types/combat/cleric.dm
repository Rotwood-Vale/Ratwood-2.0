/datum/advclass/cleric
	name = "Monk"
	tutorial = "You are a wandering acolyte, versed in both miracles and martial arts. You forego the hauberk that paladins wear in favor of humbling your foes through bloodless strikes. Your satchel hangs heavy, too, with ample provisions for the pilgrimage you're upon."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	vampcompat = FALSE
	outfit = /datum/outfit/job/roguetown/adventurer/cleric
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	class_select_category = CLASS_CAT_CLERIC
	subclass_social_rank = SOCIAL_RANK_YEOMAN
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_CIVILIZEDBARBARIAN, TRAIT_OUTLANDER)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 2,
		STATKEY_SPD = 1, //Base of +9, over the standard +7. Special clemency given to the Monk, as their playstyle is exceedingly lethal - light-to-no armor, while specializing in a dangerous melee style.
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
	)
	// One of you is gonna look at me and act like I am stupid. It is a form of disguise
	// Also because the alternative is not very clean codewise.
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "This subclass can choose from multiple disciplines. The further your chosen discipline strays from unarmed combat, however, the greater your skills in fistfighting and wrestling will atrophy. Taking a Quarterstaff provides a minor bonus to Perception, but removes the 'Dodge Expert' trait."

/datum/outfit/job/roguetown/adventurer/cleric
	allowed_patrons = ALL_PATRONS

/datum/outfit/job/roguetown/adventurer/cleric/pre_equip(mob/living/carbon/human/H)
	..()

	// Add druidic skill for Dendor followers
	if(istype(H.patron, /datum/patron/divine/dendor))
		H.adjust_skillrank(/datum/skill/magic/druidic, 3, TRUE)
		to_chat(H, span_notice("As a follower of Dendor, you have innate knowledge of druidic magic."))

	to_chat(H, span_warning("You are a wandering acolyte, versed in both miracles and martial arts. You forego the hauberk that paladins wear in favor of humbling your foes through bloodless strikes. Your satchel hangs heavy, too, with ample provisions for the pilgrimage you're upon."))
	head = /obj/item/clothing/head/roguetown/headband/monk
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/monk
	pants = /obj/item/clothing/under/roguetown/tights/black
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	backl = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltr = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 1,
		/obj/item/reagent_containers/food/snacks/rogue/bread = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/beer = 1, //Plays into the classic stereotype of beer-loving monks and well-stocked pilgrims.
		)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)	//Capped to T1 miracles. Better passive regeneration.
	if(H.mind)
		var/weapons = list("Discipline - Unarmed","Katar","Knuckledusters","Quarterstaff")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Discipline - Unarmed")
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, 4, TRUE)
				gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
			if("Katar")
				beltl = /obj/item/rogueweapon/katar/bronze
				gloves = /obj/item/clothing/gloves/roguetown/bandages
			if("Knuckledusters")
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					beltl = /obj/item/rogueweapon/knuckles/psydon/old
					gloves = /obj/item/clothing/gloves/roguetown/bandages
				else
					beltl = /obj/item/rogueweapon/knuckles/bronzeknuckles
					gloves = /obj/item/clothing/gloves/roguetown/bandages
			if("Quarterstaff")
				H.adjust_skillrank_up_to(/datum/skill/combat/staves, 3, TRUE) //On par with the new Quarterstaff-centric virtue. A monk can take said-virtue if they want the best of both worlds.
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 2, TRUE) //Balance idea's pretty simple. A dedicated staff user can use polearms too - as both weapon types are fundamentally similar, but it'd always be a skill level lower than the staff.
				H.change_stat(STATKEY_PER, 1) //Compliments the quarterstaff's precision-based mechanics.
				REMOVE_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
				l_hand = /obj/item/rogueweapon/scabbard/gwstrap
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
				gloves = /obj/item/clothing/gloves/roguetown/bandages
	H.cmode_music = 'sound/music/combat_holy.ogg' // left in bc i feel like monk players want their darktide TRAIT_DODGEEXPERT
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			cloak = /obj/item/clothing/cloak/psydontabard
			mask = /obj/item/clothing/head/roguetown/roguehood/psydon
		if(/datum/patron/divine/astrata)
			mask = /obj/item/clothing/head/roguetown/roguehood/astrata
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/astrata
		if(/datum/patron/divine/noc)
			mask =  /obj/item/clothing/head/roguetown/nochood
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/noc
		if(/datum/patron/divine/abyssor)
			mask = /obj/item/clothing/head/roguetown/roguehood/abyssor
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor
		if(/datum/patron/divine/dendor)
			mask = /obj/item/clothing/head/roguetown/dendormask
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/dendor
		if(/datum/patron/divine/necra)
			mask = /obj/item/clothing/head/roguetown/necrahood
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/necra
		if (/datum/patron/divine/malum)
			mask = /obj/item/clothing/head/roguetown/roguehood //placeholder
			cloak = /obj/item/clothing/cloak/templar/malumite
		if (/datum/patron/divine/eora)
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/eora
			mask = /obj/item/clothing/head/roguetown/eoramask
		if (/datum/patron/divine/xylix)
			cloak = /obj/item/clothing/cloak/templar/xylix
		else
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe //placeholder, anyone who doesn't have cool patron drip sprites just gets generic robes
			mask = /obj/item/clothing/head/roguetown/roguehood
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			neck = /obj/item/clothing/neck/roguetown/psicross
		if(/datum/patron/divine/undivided)
			neck = /obj/item/clothing/neck/roguetown/psicross/undivided
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
		if(/datum/patron/divine/noc)
			neck = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
		if(/datum/patron/divine/dendor)
			neck = /obj/item/clothing/neck/roguetown/psicross/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg' // see: druid.dm
		if(/datum/patron/divine/necra)
			neck = /obj/item/clothing/neck/roguetown/psicross/necra
			H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/ravox)
			neck = /obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/malum)
			neck = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/divine/eora)
			neck = /obj/item/clothing/neck/roguetown/psicross/eora
			H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			neck = /obj/item/clothing/neck/roguetown/luckcharm
			H.cmode_music = 'sound/music/combat_jester.ogg'

/datum/advclass/cleric/paladin
	name = "Paladin"
	tutorial = "You are a holy knight, clad in maille and armed with steel. Where others of the clergy may have spent their free time studying scriptures, you devoted yourself towards fighting Psydonia's evils - a longsword in one hand, and a clenched psycross in the other."
	outfit = /datum/outfit/job/roguetown/adventurer/paladin
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "This subclass can choose to take one of two holy items to take along: a potion of lifeblood and Novice skills in Medicine, or a silver longsword that gives Journeyman skills in Swordsmanship."

/datum/outfit/job/roguetown/adventurer/paladin/pre_equip(mob/living/carbon/human/H)
	to_chat(H, span_warning("You are a holy knight, clad in maille and armed with steel. Where others of the clergy may have spent their free time studying scriptures, you devoted yourself towards fighting Psydonia's evils - a longsword in one hand, and a clenched psycross in the other."))
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/shield/iron
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/chain
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/metal = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		)
	H.cmode_music = 'sound/music/cmode/church/combat_reckoning.ogg'
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			cloak = /obj/item/clothing/cloak/psydontabard
			if(H.mind)
				var/helmets = list("Armet","Buckethelm")
				var/helmet_choice = input(H, "Choose your HELMET.", "WALK IN HIS LIGHT.") as anything in helmets
				switch(helmet_choice)
					if("Armet")
						head = /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm
					if("Buckethelm")
						head = /obj/item/clothing/head/roguetown/helmet/heavy/psybucket
				var/armors = list("Hauberk","Cuirass")
				var/armor_choice = input(H, "Choose your MAILLE.", "STAND AGAINST HER DARKNESS.") as anything in armors
				switch(armor_choice)
					if("Hauberk")
						armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
					if("Cuirass")
						armor = /obj/item/clothing/suit/roguetown/armor/plate/half/fluted/ornate
		if(/datum/patron/divine/astrata)
			cloak = /obj/item/clothing/cloak/templar/astrata
			head = /obj/item/clothing/head/roguetown/helmet/heavy/astratan
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
		if(/datum/patron/divine/noc)
			cloak = /obj/item/clothing/cloak/templar/noc
			head = /obj/item/clothing/head/roguetown/helmet/heavy/nochelm
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
		if(/datum/patron/divine/abyssor)
			cloak = /obj/item/clothing/cloak/abyssortabard
			head = /obj/item/clothing/head/roguetown/helmet/heavy/abyssorgreathelm
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
		if(/datum/patron/divine/dendor)
			cloak = /obj/item/clothing/cloak/templar/dendor
			head = /obj/item/clothing/head/roguetown/helmet/heavy/dendorhelm
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
		if(/datum/patron/divine/necra)
			cloak = /obj/item/clothing/cloak/templar/necra
			head = /obj/item/clothing/head/roguetown/helmet/heavy/necrahelm
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
		if (/datum/patron/divine/malum)
			cloak = /obj/item/clothing/cloak/templar/malum
			head = /obj/item/clothing/head/roguetown/helmet/heavy/malum
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
		if (/datum/patron/divine/eora)
			cloak = /obj/item/clothing/cloak/templar/eora
			head = /obj/item/clothing/head/roguetown/helmet/heavy/eoran
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
		if (/datum/patron/divine/ravox)
			cloak = /obj/item/clothing/cloak/cleric/ravox
			head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/gold
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
		if (/datum/patron/divine/xylix)
			cloak = /obj/item/clothing/cloak/templar/xylix
			head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
		if (/datum/patron/divine/pestra)
			cloak = /obj/item/clothing/cloak/templar/pestra
			head = /obj/item/clothing/head/roguetown/helmet/heavy/pestran
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
		else
			cloak = /obj/item/clothing/cloak/cape/crusader
			head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)	//Capped to T1 miracles.
	if(H.mind)
		var/weapons = list("Longsword","Mace","Flail","Whip","Spear","Axe")
		var/weapon_choice = input(H, "Choose your WEAPON.", "TAKE UP YOUR GOD'S ARMS.") as anything in weapons
		switch(weapon_choice)
			if("Longsword")
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					beltr = /obj/item/rogueweapon/sword/long/oldpsysword
				else
					beltr = /obj/item/rogueweapon/sword/long
				r_hand = /obj/item/rogueweapon/scabbard/sword
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Mace")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					beltr = /obj/item/rogueweapon/mace/cudgel/psy/old
				else
					beltr = /obj/item/rogueweapon/mace
			if("Flail")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/flail
			if("Whip")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/whip
			if("Spear")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					r_hand = /obj/item/rogueweapon/spear/psyspear/old
				else
					r_hand = /obj/item/rogueweapon/spear
			if("Axe")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/stoneaxe/woodcut
		var/oaths = list("Cleric - Medicine & Mirth","Crusader - Silver Longsword")
		var/oath_choice = input(H, "Choose your OATH.", "PROFESS YOUR BLESSINGS.") as anything in oaths
		switch(oath_choice)
			if("Cleric - Medicine & Mirth")
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_NOVICE, TRUE)
				beltl = /obj/item/reagent_containers/glass/bottle/rogue/healthpot //No needles or cloth, but a basic potion of lifeblood - similar to the Sorcerer's manna potion. Take the 'Physician's Apprentice' virtue for that, uncapped skills, and more.
			if("Crusader - Silver Longsword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				l_hand = /obj/item/rogueweapon/sword/long/silver //Turns the Paladin into a pre-Exorcist version of the Monster Hunter. Differences are +1 CON / -1 INT, access to minor miracles, and more limb coverage.
				beltl = /obj/item/rogueweapon/scabbard/sword //Functionally, inflicts silverbane at the cost of -5 damage. Likely won't be a balancing issue, unless we start seeing +5-10 Clerics overnight.

	H.set_blindness(0)
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			wrists = /obj/item/clothing/neck/roguetown/psicross
		if(/datum/patron/divine/undivided)
			wrists = /obj/item/clothing/neck/roguetown/psicross/undivided
		if(/datum/patron/divine/astrata)
			wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
			H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
		if(/datum/patron/divine/noc)
			wrists = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			wrists = /obj/item/clothing/neck/roguetown/psicross/abyssor
		if(/datum/patron/divine/dendor)
			wrists = /obj/item/clothing/neck/roguetown/psicross/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg' // see: druid.dm
		if(/datum/patron/divine/necra)
			wrists = /obj/item/clothing/neck/roguetown/psicross/necra
			H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
		if(/datum/patron/divine/pestra)
			wrists = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/ravox)
			wrists = /obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/malum)
			wrists = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/divine/eora)
			wrists = /obj/item/clothing/neck/roguetown/psicross/eora
			H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			wrists = /obj/item/clothing/neck/roguetown/luckcharm
			H.cmode_music = 'sound/music/combat_jester.ogg'

/datum/advclass/cleric/cantor
	name = "Cantor"
	tutorial = "You were a bard once - but you've found a new calling. Your eyes have been opened to the divine, now you wander from city to city singing songs and telling tales of your patron's greatness."
	outfit = /datum/outfit/job/roguetown/adventurer/cantor
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_EMPATH)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 2,
	)
	subclass_skills = list(
		/datum/skill/misc/music = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "This subclass has higher-tier miracles, but regenerates Devotion far slower."

/datum/outfit/job/roguetown/adventurer/cantor/pre_equip(mob/living/carbon/human/H)
	to_chat(H, span_warning("You were a bard once - but you've found a new calling. Your eyes have been opened to the divine, now you wander from city to city singing songs and telling tales of your patron's greatness."))
	H.mind?.current?.faction += "[H.name]_faction"
	head = /obj/item/clothing/head/roguetown/bardhat
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/special
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = CLERIC_REQ_2)	//Capped to T2 miracles.
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T2)
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.cmode_music = 'sound/music/cmode/church/combat_reckoning.ogg'
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/mockery)
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			cloak = /obj/item/clothing/cloak/templar/psydon
		if(/datum/patron/divine/astrata)
			cloak = /obj/item/clothing/cloak/templar/astrata
		if(/datum/patron/divine/noc)
			cloak = /obj/item/clothing/cloak/templar/noc
		if(/datum/patron/divine/abyssor)
			cloak = /obj/item/clothing/cloak/templar/abyssor
		if(/datum/patron/divine/dendor)
			cloak = /obj/item/clothing/cloak/templar/dendor
		if(/datum/patron/divine/necra)
			cloak = /obj/item/clothing/cloak/templar/necra
		if (/datum/patron/divine/malum)
			cloak = /obj/item/clothing/cloak/templar/malum
		if (/datum/patron/divine/eora)
			cloak = /obj/item/clothing/cloak/templar/eora
		if (/datum/patron/divine/ravox)
			cloak = /obj/item/clothing/cloak/templar/ravox
		if (/datum/patron/divine/xylix)
			cloak = /obj/item/clothing/cloak/templar/xylix
		if (/datum/patron/divine/pestra)
			cloak = /obj/item/clothing/cloak/templar/pestra
		else
			cloak = /obj/item/clothing/cloak/cape/crusader
	if(H.mind)
		var/weapons = list("Accordion","Drum","Flute","Guitar","Harp","Hurdy-Gurdy","Lute","Psyaltery","Shamisen","Trumpet","Viola","Vocal Talisman")
		var/weapon_choice = tgui_input_list(H, "Choose your instrument.", "TAKE UP ARMS", weapons)
		H.set_blindness(0)
		switch(weapon_choice)
			if("Accordion")
				backr = /obj/item/rogue/instrument/accord
			if("Drum")
				backr = /obj/item/rogue/instrument/drum
			if("Flute")
				backr = /obj/item/rogue/instrument/flute
			if("Guitar")
				backr = /obj/item/rogue/instrument/guitar
			if("Harp")
				backr = /obj/item/rogue/instrument/harp
			if("Hurdy-Gurdy")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("Lute")
				backr = /obj/item/rogue/instrument/lute
			if("Psyaltery")
				backr = /obj/item/rogue/instrument/psyaltery
			if("Shamisen")
				backr = /obj/item/rogue/instrument/shamisen
			if("Trumpet")
				backr = /obj/item/rogue/instrument/trumpet
			if("Viola")
				backr = /obj/item/rogue/instrument/viola
			if("Vocal Talisman")
				backr = /obj/item/rogue/instrument/vocals

	switch(H.patron?.type)
		if(/datum/patron/old_god)
			neck = /obj/item/clothing/neck/roguetown/psicross
		if(/datum/patron/divine/undivided)
			neck = /obj/item/clothing/neck/roguetown/psicross/undivided
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
		if(/datum/patron/divine/noc)
			neck = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
		if(/datum/patron/divine/dendor)
			neck = /obj/item/clothing/neck/roguetown/psicross/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg' // see: druid.dm
		if(/datum/patron/divine/necra)
			neck = /obj/item/clothing/neck/roguetown/psicross/necra
			H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/ravox)
			neck = /obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/malum)
			neck = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/divine/eora)
			neck = /obj/item/clothing/neck/roguetown/psicross/eora
			H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			neck = /obj/item/clothing/neck/roguetown/luckcharm
			H.cmode_music = 'sound/music/combat_jester.ogg'

/datum/advclass/cleric/missionary
	name = "Missionary"
	tutorial = "You are a devout worshipper of the divine with a strong connection to your patron god. You've spent years studying scriptures and serving your deity - now you wander into foreign lands, spreading the word of your faith."
	outfit = /datum/outfit/job/roguetown/adventurer/missionary
	traits_applied = list()
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE, //If a potential staff-polearm user is at Apprentice-level or below, it's fine to match both combat skills.
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "This subclass regenerates Devotion far quicker, but only has access to lesser miracles."

/datum/outfit/job/roguetown/adventurer/missionary/pre_equip(mob/living/carbon/human/H)
	to_chat(H, span_warning("You are a devout worshipper of the divine with a strong connection to your patron god. You've spent years studying scriptures and serving your deity - now you wander into foreign lands, spreading the word of your faith."))
	H.mind.current.faction += "[H.name]_faction"
	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		)
	H.cmode_music = 'sound/music/cmode/church/combat_reckoning.ogg'
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			cloak = /obj/item/clothing/cloak/psydontabard
			head = /obj/item/clothing/head/roguetown/roguehood/psydon
		if(/datum/patron/divine/astrata)
			head = /obj/item/clothing/head/roguetown/roguehood/astrata
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/astrata
		if(/datum/patron/divine/noc)
			head =  /obj/item/clothing/head/roguetown/nochood
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/noc
		if(/datum/patron/divine/abyssor)
			head = /obj/item/clothing/head/roguetown/roguehood/abyssor
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor
		if(/datum/patron/divine/dendor)
			head = /obj/item/clothing/head/roguetown/dendormask
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/dendor
		if(/datum/patron/divine/necra)
			head = /obj/item/clothing/head/roguetown/necrahood
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/necra
		if (/datum/patron/divine/malum)
			head = /obj/item/clothing/head/roguetown/roguehood //placeholder
			cloak = /obj/item/clothing/cloak/templar/malumite
		if (/datum/patron/divine/eora)
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/eora
			head = /obj/item/clothing/head/roguetown/eoramask
			backpack_contents[/obj/item/reagent_containers/eoran_seed] = 1
		if (/datum/patron/divine/xylix)
			cloak = /obj/item/clothing/cloak/templar/xylix
		if(/datum/patron/inhumen/zizo)
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe
			head = /obj/item/clothing/head/roguetown/roguehood
			H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
			H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
		else
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe //placeholder, anyone who doesn't have cool patron drip sprites just gets generic robes
			head = /obj/item/clothing/head/roguetown/roguehood
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_3)	//Minor regen, capped to T3, parity with other Holy and/or Arcyne caster - no others spend 15 minutes idling only to unlock their entire potencial.
	if(H.mind)
		var/weapons = list("Woodstaff", "Quarterstaff")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Woodstaff")
				backr = /obj/item/rogueweapon/woodstaff
			if("Quarterstaff")
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
				l_hand = /obj/item/rogueweapon/scabbard/gwstrap
	if(istype(H.patron, /datum/patron/divine))
		// For now, only Tennites get this. Heretics can have a special treat later
		H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/divineblast)
	if(istype(H.patron, /datum/patron/inhumen))
		H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/divineblast/unholyblast)
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			neck = /obj/item/clothing/neck/roguetown/psicross
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
		if(/datum/patron/divine/noc)
			neck = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
		if(/datum/patron/divine/dendor)
			neck = /obj/item/clothing/neck/roguetown/psicross/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg' // see: druid.dm
		if(/datum/patron/divine/necra)
			neck = /obj/item/clothing/neck/roguetown/psicross/necra
			H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/ravox)
			neck = /obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/malum)
			neck = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/divine/eora)
			neck = /obj/item/clothing/neck/roguetown/psicross/eora
			H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			neck = /obj/item/clothing/neck/roguetown/luckcharm
			H.cmode_music = 'sound/music/combat_jester.ogg'



//-----------------------
//-----------------------
//-----------------------
//-----------------------
//-----------------------
//-----------------------
//-----------------------
/datum/advclass/cleric/shaman
	name = "Shaman"
	tutorial = "You are a shaman, a spiritual guide who channels divine and arcane power through sacred totems. Ostracized by the church but revered by those who remember the old ways, you commune with spirits and gods alike through your bonded totem. \
	\nYour power flows through your TOTEM - a sacred focus bonded to your soul that you MUST hold to cast spells or miracles. You can only ever bond with ONE totem. Feed it with offerings to maintain your power: alchemical reagents for arcane magic, sacred items for divine miracles. Upgrade your totem with materials (magical stone, copper bar, tin bar, iron bar, silver bar, gold bar) to increase its capacity. \
	\nYou can customize your totem's name and description."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	vampcompat = FALSE
	outfit = /datum/outfit/job/roguetown/adventurer/cleric/shaman
	category_tags = list(CTAG_ADVENTURER)
	class_select_category = CLASS_CAT_CLERIC
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_DEATHSIGHT, TRAIT_WITCH, TRAIT_ARCYNE_T1, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
		STATKEY_LCK = 1
	)

	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/cleric/shaman/pre_equip(mob/living/carbon/human/H)
	// Don't call parent ..() to avoid monk weapon selection
	cloak = /obj/item/clothing/cloak/tribal
	armor = /obj/item/clothing/suit/roguetown/shirt/robe
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	gloves = /obj/item/clothing/gloves/roguetown/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	pants = /obj/item/clothing/under/roguetown/trou
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	backl = /obj/item/storage/backpack/rogue/backpack/bagpack
	backpack_contents = list(
						/obj/item/reagent_containers/glass/mortar = 1,
						/obj/item/pestle = 1,
						/obj/item/candle/yellow = 2,
						/obj/item/chalk = 1
						)

	// Cosmetic title selection
	H.adjust_blindness(-3)
	
	// Headgear selection
	if(H.mind)
		var/headgear = list("Volf Helm", "Saiga Helm")
		var/headgear_choice = input(H, "Choose your headgear.", "SPIRITUAL VESTMENTS") as anything in headgear
		switch(headgear_choice)
			if("Volf Helm")
				head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
			if("Saiga Helm")
				head = /obj/item/clothing/head/roguetown/helmet/leather/saiga
	
	H.adjust_blindness(-3)
	var/cosmetic_titles = list(
		"Shaman", "Shamaness",
		"Spirit-Walker",
		"Totem-Bearer",
		"Mystic",
		"Herbalist",
		"Wise One",
		"Seer",
		"Oracle",
		"Spiritual Guide",
		"Ritualist"
	)
	var/cosmetic_choice = input(H, "What title do you bear?", "Spiritual Paths") as anything in cosmetic_titles
	if(cosmetic_choice)
		H.mind.cosmetic_class_title = cosmetic_choice
		to_chat(H, span_notice("You are known as a [cosmetic_choice]."))

	var/classes = list("Spirit Magic", "Divine Communion", "Balanced Path")
	var/classchoice = input("How do your powers manifest?", "SPIRITUAL PATHS") as anything in classes

	switch (classchoice)
		if("Spirit Magic")
			// Arcane-focused shaman: arcyne 3 with arcane totem
			ADD_TRAIT(H, TRAIT_ARCYNE_T3, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)
			H.mind?.adjust_spellpoints(14)
			beltl = /obj/item/storage/magebag/associate
			// Give arcane totem
			var/obj/item/witch_totem/arcane_totem = new /obj/item/witch_totem(get_turf(H))
			arcane_totem.totem_type = "arcane"
			arcane_totem.current_energy = arcane_totem.max_energy // Start fully charged
			arcane_totem.bond_to_witch(H)
			H.put_in_hands(arcane_totem, forced = TRUE)



		if("Divine Communion")
			// Miracle-focused shaman: capped at t3 miracles with divine totem
			var/datum/devotion/D = new /datum/devotion/(H, H.patron)
			H.adjust_skillrank(/datum/skill/magic/holy, 2, TRUE)
			D.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_WITCH, devotion_limit = CLERIC_REQ_3)
			D.max_devotion *= 0.35
			//Can't pray, devotion cap is less than a witch's, but has access to T3 miracles.


			H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
			H.mind?.adjust_spellpoints(6)
			beltl = /obj/item/storage/magebag/alchemist

			// Give divine/unholy blast based on patron
			if(istype(H.patron, /datum/patron/divine))
				H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/divineblast)
			if(istype(H.patron, /datum/patron/inhumen))
				H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/divineblast/unholyblast)

			// Give divine totem
			var/obj/item/witch_totem/divine_totem = new /obj/item/witch_totem(get_turf(H))
			divine_totem.totem_type = "divine"
			divine_totem.current_energy = divine_totem.max_energy // Start fully charged
			divine_totem.bond_to_witch(H)
			H.put_in_hands(divine_totem, forced = TRUE)



		if("Balanced Path")
			// Hybrid shaman with t2 arcane and t2 miracles
			var/datum/devotion/D = new /datum/devotion/(H, H.patron)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
			D.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)
			D.max_devotion *= 0.5

			ADD_TRAIT(H, TRAIT_ARCYNE_T2, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
			H.mind?.adjust_spellpoints(8)
			beltl = /obj/item/storage/magebag/alchemist

			// Give hybrid totem
			var/obj/item/witch_totem/hybrid_totem = new /obj/item/witch_totem(get_turf(H))
			hybrid_totem.totem_type = "hybrid"
			hybrid_totem.current_energy = hybrid_totem.max_energy // Start fully charged
			hybrid_totem.bond_to_witch(H)
			H.put_in_hands(hybrid_totem, forced = TRUE)

	if(H.mind)
		switch (classchoice)
			if("Spirit Magic")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/guidance)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/aerosolize)

	// SKILL SELECTION
	if(H.mind)
		var/misc_skills = list(
			"Stealing" = /datum/skill/misc/stealing,
			"Music" = /datum/skill/misc/music,
			"Tracking" = /datum/skill/misc/tracking,
			"Lockpicking" = /datum/skill/misc/lockpicking,
			"Sneaking" = /datum/skill/misc/sneaking,
			"Riding" = /datum/skill/misc/riding
		)
		var/labor_skills = list(
			"Farming" = /datum/skill/labor/farming,
			"Lumberjacking" = /datum/skill/labor/lumberjacking,
			"Fishing" = /datum/skill/labor/fishing,
			"Butchering" = /datum/skill/labor/butchering,
			"Mining" = /datum/skill/labor/mining
		)
		var/craft_skills = list(
			"Ceramics" = /datum/skill/craft/ceramics,
			"Masonry" = /datum/skill/craft/masonry,
			"Engineering" = /datum/skill/craft/engineering,
			"Traps" = /datum/skill/craft/traps,
			"Tanning" = /datum/skill/craft/tanning,
		)
		var/combat_skills = list(
			"Axes" = /datum/skill/combat/axes,
			"Unarmed" = /datum/skill/combat/unarmed,
			"Knives" = /datum/skill/combat/knives,
			"Wrestling" = /datum/skill/combat/wrestling,
			"Staves" = /datum/skill/combat/staves,
			"Whips & Flails" = /datum/skill/combat/whipsflails,
			"Bows" = /datum/skill/combat/bows,
			"Crossbows" = /datum/skill/combat/crossbows,
			"Polearms" = /datum/skill/combat/polearms,
			"Shields" = /datum/skill/combat/shields,
			"Slings" = /datum/skill/combat/slings,
			"Swords" = /datum/skill/combat/swords,
			"Maces" = /datum/skill/combat/maces
		)

		// Select one skill to EXPERT
		var/expert_skill_name = input(H, "Choose one skill to EXPERT. [1/1]", "Skill Selection") as anything in misc_skills + labor_skills + craft_skills
		if(expert_skill_name)
			H.adjust_skillrank_up_to(misc_skills[expert_skill_name] || labor_skills[expert_skill_name] || craft_skills[expert_skill_name], SKILL_LEVEL_EXPERT, TRUE)
			if(expert_skill_name in misc_skills)
				misc_skills -= expert_skill_name
			if(expert_skill_name in labor_skills)
				labor_skills -= expert_skill_name
			if(expert_skill_name in craft_skills)
				craft_skills -= expert_skill_name 

		// Select one MISC/LABOR/CRAFT skill to JOURNEYMAN
		for(var/i in 1 to 1)
			var/journeyman_name = input(H, "Choose one skill to JOURNEYMAN. [1/1]", "Skill Selection") as anything in misc_skills + labor_skills + craft_skills
			if(journeyman_name)
				H.adjust_skillrank_up_to(misc_skills[journeyman_name] || labor_skills[journeyman_name] || craft_skills[journeyman_name], SKILL_LEVEL_JOURNEYMAN, TRUE)
				if(journeyman_name in misc_skills)
					misc_skills -= journeyman_name
				if(journeyman_name in labor_skills)
					labor_skills -= journeyman_name
				if(journeyman_name in craft_skills)
					craft_skills -= journeyman_name

		// Select one COMBAT skill to JOURNEYMAN
		var/journeyman_combat_name = input(H, "Choose a COMBAT skill to JOURNEYMAN. [1/1]", "Skill Selection") as anything in combat_skills
		if(journeyman_combat_name)
			H.adjust_skillrank_up_to(combat_skills[journeyman_combat_name], SKILL_LEVEL_JOURNEYMAN, TRUE)
			if(journeyman_combat_name in combat_skills)
				combat_skills -= journeyman_combat_name

		// Select three skills to APPRENTICE
		for(var/i in 1 to 2)
			var/apprentice_name = input(H, "Choose a skill to APPRENTICE. [i]/2", "Skill Selection") as anything in misc_skills + labor_skills + craft_skills + combat_skills
			if(apprentice_name)
				H.adjust_skillrank_up_to(misc_skills[apprentice_name] || labor_skills[apprentice_name] || craft_skills[apprentice_name] || combat_skills[apprentice_name], SKILL_LEVEL_APPRENTICE, TRUE)
				if(apprentice_name in misc_skills)
					misc_skills -= apprentice_name
				if(apprentice_name in labor_skills)
					labor_skills -= apprentice_name
				if(apprentice_name in craft_skills)
					craft_skills -= apprentice_name
				if(apprentice_name in combat_skills)
					combat_skills -= apprentice_name

		// Select two skills to NOVICE
		for(var/i in 1 to 2)
			var/novice_name = input(H, "Choose a skill to NOVICE. [i]/2", "Skill Selection") as anything in misc_skills + labor_skills + craft_skills + combat_skills
			if(novice_name)
				H.adjust_skillrank_up_to(misc_skills[novice_name] || labor_skills[novice_name] || craft_skills[novice_name] || combat_skills[novice_name], SKILL_LEVEL_NOVICE, TRUE)
				if(novice_name in misc_skills)
					misc_skills -= novice_name
				if(novice_name in labor_skills)
					labor_skills -= novice_name
				if(novice_name in craft_skills)
					craft_skills -= novice_name
				if(novice_name in combat_skills)
					combat_skills -= novice_name

	// TRAIT SELECTION
	if(H.mind)
		var/shaman_traits = list(
			"Seedknow" = TRAIT_SEEDKNOW,
			"Empath" = TRAIT_EMPATH,
			"Keen Ears" = TRAIT_KEENEARS,
			"Sleuth" = TRAIT_SLEUTH,
			"Outdoorsman" = TRAIT_OUTDOORSMAN,
			"Woodwalker" = TRAIT_WOODWALKER,
			"Light Step" = TRAIT_LIGHT_STEP,
			"Perfect Tracker" = TRAIT_PERFECT_TRACKER,
			"Beautiful" = TRAIT_BEAUTIFUL,
			"Good Lover" = TRAIT_GOODLOVER,
			"Intellectual" = TRAIT_INTELLECTUAL,
			"Sewing Expert" = TRAIT_SEWING_EXPERT,
			"Dyes Master" = TRAIT_DYES,
			"Survival Expert" = TRAIT_SURVIVAL_EXPERT
		)

		// Select four traits
		for(var/i in 1 to 2)
			var/trait_name = input(H, "Choose a trait [i]/2.", "Trait Selection") as anything in shaman_traits
			if(trait_name)
				ADD_TRAIT(H, shaman_traits[trait_name], TRAIT_GENERIC)
				if(trait_name in shaman_traits)
					shaman_traits -= trait_name

	if(H.gender == FEMALE)
		armor = /obj/item/clothing/suit/roguetown/shirt/robe
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
		pants = /obj/item/clothing/under/roguetown/skirt

	if(H.age == AGE_OLD)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_LCK, 1)
		H.mind?.adjust_spellpoints(3)

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_ZURCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_ZURCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_ZURCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_ZURCH, TRAIT_GENERIC)

	// Psycross loadout for Divine Communion shamans
	if(classchoice == "Divine Communion")
		switch(H.patron?.type)
			if(/datum/patron/old_god)
				neck = /obj/item/clothing/neck/roguetown/psicross
			if(/datum/patron/divine/astrata)
				neck = /obj/item/clothing/neck/roguetown/psicross/astrata
				H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
			if(/datum/patron/divine/noc)
				neck = /obj/item/clothing/neck/roguetown/psicross/noc
			if(/datum/patron/divine/abyssor)
				neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
			if(/datum/patron/divine/dendor)
				neck = /obj/item/clothing/neck/roguetown/psicross/dendor
				H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'
			if(/datum/patron/divine/necra)
				neck = /obj/item/clothing/neck/roguetown/psicross/necra
				H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
			if(/datum/patron/divine/pestra)
				neck = /obj/item/clothing/neck/roguetown/psicross/pestra
			if(/datum/patron/divine/ravox)
				neck = /obj/item/clothing/neck/roguetown/psicross/ravox
			if(/datum/patron/divine/malum)
				neck = /obj/item/clothing/neck/roguetown/psicross/malum
			if(/datum/patron/divine/eora)
				neck = /obj/item/clothing/neck/roguetown/psicross/eora
				H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
			if(/datum/patron/divine/xylix)
				neck = /obj/item/clothing/neck/roguetown/luckcharm
				H.cmode_music = 'sound/music/combat_jester.ogg'
