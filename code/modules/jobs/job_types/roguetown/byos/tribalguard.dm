/datum/job/roguetown/tribalguard
	title = "Tribal Guard"
	flag = TRIBALGUARD
	department_flag = TRIBAL
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	selection_color = JCOLOR_TRIBAL

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/goblinp, /datum/species/anthromorphsmall, /datum/species/kobold)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	// tutorial = "Ooga Chacka Guard-a-Chacka."
	tutorial = "你是酋长的臂膀，也是 The Dragon 的铁爪。祂的力量凌驾于任何凡人之上，至少你从小就是这么被教导的。毕竟，祂最大，也最强。\
	你要遵照酋长的命令，同时维持寨中的秩序。没有酋长首肯，最好别擅自离开。\
	若有可能，尽量去“照料”俘虏，而不是一上来就把他们杀掉。"
	display_order = JDO_TRIBALGUARD
	whitelist_req = TRUE

	outfit = /datum/outfit/job/roguetown/tribalguard
	advclass_cat_rolls = list(CTAG_TRIBALGUARD = 20)

	min_pq = 0
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/combat_gronn.ogg'
	// cmode_music = 'sound/music/hornofthebeast.ogg'
	// social_rank = SOCIAL_RANK_PEASANT
	job_traits = list(TRAIT_OUTDOORSMAN, TRAIT_SURVIVAL_EXPERT, TRAIT_TRIBAL, TRAIT_DARKVISION)
	job_subclasses = list(
		/datum/advclass/tribalguard/hunter,
		/datum/advclass/tribalguard/warrior,
		/datum/advclass/tribalguard/savage)

/datum/outfit/job/roguetown/tribalguard
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/fur
	cloak = /obj/item/clothing/cloak/tribal
	belt = /obj/item/storage/belt/rogue/leather/rope
	backr = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/furlinedanklets

/datum/advclass/tribalguard/hunter
	name = "猎手"
	tutorial = "你是部落中的追踪者与猎手，擅长用弓索和投枪在树林、峭壁与洞穴间追猎猎物，也追猎那些闯入者。"
	outfit = /datum/outfit/job/roguetown/tribalguard/hunter
	category_tags = list(CTAG_TRIBALGUARD)
	traits_applied = list(TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_SPD = 2,
		STATKEY_WIL = 2
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/slings = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/tribalguard/hunter/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	neck = /obj/item/clothing/neck/roguetown/coif
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/armor/leather/hide/bikini
	pants = /obj/item/clothing/under/roguetown/trou/leather
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/ancient
	backpack_contents = list(
		/obj/item/roguekey/tribal = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)
	H.faction += list("orcs", "tribe")
	if(!H.has_language(/datum/language/draconic))
		H.grant_language(/datum/language/draconic)
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("弓","投石索","长矛与标枪")
		var/weapon_choice = input(H, "选择你的武器。", "整备武装") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("弓")
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				beltr = /obj/item/quiver/arrows
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/slings, 4, TRUE)
			if("投石索") 
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
				beltr = /obj/item/quiver/sling/ancient
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/slings, 4, TRUE)
			if("长矛与标枪") 
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/spear/ancient
				beltr = /obj/item/quiver/javelin/ancient
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 3, TRUE)
				H.change_stat(STATKEY_SPD, -1)
				H.change_stat(STATKEY_STR, 1)


/datum/advclass/tribalguard/warrior
	name = "战士"
	tutorial = "你是酋长麾下最可靠的卫士之一，披着厚甲、挥着重兵，习惯在近身厮杀中用蛮力与凶性压垮敌人。"
	// tutorial = "You're one of the Chief's trusted guards, though many just know you to be a brute. Strong, perhaps too strong, for your size. You've experience with all kinds of weapons, and unarmed combat."
	outfit = /datum/outfit/job/roguetown/tribalguard/warrior
	category_tags = list(CTAG_TRIBALGUARD)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_PER = 2
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/slings = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE, // This should let them fry meat on fires.
	)

/datum/outfit/job/roguetown/tribalguard/warrior/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	neck = /obj/item/clothing/neck/roguetown/chaincoif/ancient
	gloves = /obj/item/clothing/gloves/roguetown/chain/ancient
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/ancient
	pants = /obj/item/clothing/under/roguetown/trou/leather
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/ancient
	backpack_contents = list(
		/obj/item/roguekey/tribal = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		)
	H.verbs |= /mob/proc/haltyell
	H.faction += list("orcs", "tribe")
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("远古长柄战斧","远古巨权杖","远古长矛与盾", "远古标枪与盾")
		var/weapon_choice = input(H, "选择你的武器。", "拿起武器") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("远古长柄战斧")
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/halberd/bardiche/ancient
			if("远古巨权杖") 
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/mace/goden/steel/ancient
			if("远古长矛与盾") 
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/spear/ancient
			if("远古标枪与盾")
				beltr = /obj/item/quiver/javelin/ancient
				backl = /obj/item/rogueweapon/shield/tower
				
		var/weapons2 = list("棍棒","钉头锤","手斧")
		var/weapon_choice2 = input(H, "选择你的副武器。", "拿起武器") as anything in weapons2
		switch(weapon_choice2)
			if("棍棒")
				beltl = /obj/item/rogueweapon/mace/cudgel/shellrungu
			if("手斧")
				beltl = /obj/item/rogueweapon/stoneaxe/woodcut/steel/ancient
			if("钉头锤")
				beltl = /obj/item/rogueweapon/mace/steel/ancient

/datum/advclass/tribalguard/savage
	name = "蛮勇者"
	tutorial = "你是部落里最凶暴、最野蛮的近战怪物，靠着更可怕的体魄和原始怒火扑向敌人，把战场搅成血肉泥潭。"
	// tutorial = "You're one of the Chief's trusted guards, though many just know you to be a brute. Strong, perhaps too strong, for your size. You've experience with all kinds of weapons, and unarmed combat."
	outfit = /datum/outfit/job/roguetown/tribalguard/savage
	category_tags = list(CTAG_TRIBALGUARD)
	traits_applied = list(TRAIT_CRITICAL_RESISTANCE, TRAIT_CIVILIZEDBARBARIAN, TRAIT_STRONGBITE)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_INT = -2,
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/slings = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE, // This should let them fry meat on fires.
	)

/datum/outfit/job/roguetown/tribalguard/savage/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	neck = /obj/item/clothing/neck/roguetown/chaincoif/ancient
	gloves = /obj/item/clothing/gloves/roguetown/chain/ancient
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/ancient
	pants = /obj/item/clothing/under/roguetown/trou/leather
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/barbarian
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/ancient
	if(should_wear_masc_clothes(H))
		H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
		backl = /obj/item/storage/backpack/rogue/satchel
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/armor/leather/bikini
		backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/tribal = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		)
	H.verbs |= /mob/proc/haltyell
	H.faction += list("orcs", "tribe")
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("远古长柄战斧","远古巨权杖", "远古标枪与盾", "大槌 - 力量/体质提升，速度/感知/智力下降")
		var/weapon_choice = input(H, "选择你的武器。", "拿起武器") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("远古长柄战斧")
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/halberd/bardiche/ancient
			if("远古巨权杖") 
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/mace/goden/steel/ancient
			if("远古标枪与盾")
				beltr = /obj/item/quiver/javelin/ancient
				backl = /obj/item/rogueweapon/shield/tower
			if("大槌 - 力量/体质提升，速度/感知/智力下降")
				r_hand = /obj/item/rogueweapon/mace/maul
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.change_stat(STATKEY_STR, 1)
				H.change_stat(STATKEY_CON, 1)
				H.change_stat(STATKEY_SPD, -1)
				H.change_stat(STATKEY_PER, -1)
				H.change_stat(STATKEY_INT, -1)
				
		var/weapons2 = list("棍棒","钉头锤","手斧")
		var/weapon_choice2 = input(H, "选择你的副武器。", "拿起武器") as anything in weapons2
		switch(weapon_choice2)
			if("棍棒")
				beltl = /obj/item/rogueweapon/mace/cudgel/shellrungu
			if("手斧")
				beltl = /obj/item/rogueweapon/stoneaxe/woodcut/steel/ancient
			if("钉头锤")
				beltl = /obj/item/rogueweapon/mace/steel/ancient
