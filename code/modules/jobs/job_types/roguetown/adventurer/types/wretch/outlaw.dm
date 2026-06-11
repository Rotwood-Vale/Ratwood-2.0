/datum/advclass/wretch/outlaw
	name = "亡命徒"
	tutorial = "你是夜里令人闻风丧胆的家伙，用你的狡诈与速度迅速出手，在任何人察觉前带着赃物全身而退。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/outlaw
	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg'
	class_select_category = CLASS_CAT_ROGUE
	category_tags = list(CTAG_WRETCH)
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_WIL = 2,
		STATKEY_PER = 1
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE, //A bonus rather than something to be encouraged
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/stealing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,		//why did these guys not even have SOME crafting experience?
	)


/datum/outfit/job/roguetown/wretch/outlaw/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是夜里令人闻风丧胆的家伙，用你的狡诈与速度迅速出手，在任何人察觉前带着赃物全身而退。"))
	head = /obj/item/clothing/head/roguetown/helmet/kettle
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	neck = /obj/item/clothing/neck/roguetown/gorget
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	mask = /obj/item/clothing/mask/rogue/ragmask/black
	beltr = /obj/item/quiver/bolts
	r_hand = /obj/item/rogueweapon/mace/cudgel //From thief PR
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/roguebag = 1,
		/obj/item/ammo_casing/caseless/rogue/bolt/water = 3,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)
	if(H.mind)
		var/weapons = list("细剑","匕首", "长鞭")
		var/weapon_choice = input(H, "选择你的武器。", "披甲执兵") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("细剑")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/rapier
			if("匕首")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sheath
				l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/special // Why were they spawning with an elven dagger in the first place??? Please LMK.
			if ("长鞭")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				beltl = /obj/item/rogueweapon/whip
		wretch_select_bounty(H)

/datum/advclass/wretch/outlaw/marauder
	name = "掠夺者"
	tutorial = "你是强盗与劫掠者，更喜欢用最直接的手段从那些倒霉受害者身上榨出钱财。"
	outfit = /datum/outfit/job/roguetown/wretch/marauder
	cmode_music = 'sound/music/cmode/antag/combat_thewall.ogg'
	class_select_category = CLASS_CAT_WARRIOR
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_MEDIUMARMOR)	//let us Try giving them medium armor. What can go wrong?!
	//Still a bit quick but sturdier. A bit more stupid, though.	
	subclass_stats = list(
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1,
		STATKEY_STR = 2,
		STATKEY_INT = -1
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,		//Fear the man who robs at a distance. Somehow.
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,		//build some pallisade barricades or the likes! Blockade!
	)

/datum/outfit/job/roguetown/wretch/marauder/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是强盗与劫掠者，更喜欢用最直接的手段从那些倒霉受害者身上榨出钱财。"))
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron		//iron breastplate so they need to find a way to upgrade it. Only piece of medium armor they get
	cloak = /obj/item/clothing/cloak/stabard/dungeon
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	gloves = /obj/item/clothing/gloves/roguetown/angle
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	neck = /obj/item/clothing/neck/roguetown/gorget 
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	mask = /obj/item/clothing/mask/rogue/ragmask/black
	r_hand = /obj/item/rogueweapon/mace/cudgel //From thief PR
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)
	if(H.mind)
		var/weapons = list("单持鸢盾","匕首加弩", "民兵战镐加鸢盾", "民兵长矛加鸢盾", "民兵战斧", "民兵古登达格棍", "链枷加鸢盾")
		var/weapon_choice = input(H, "选择你的武器。", "披甲执兵") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("单持鸢盾")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				backr = /obj/item/rogueweapon/shield/iron
			if("匕首加弩")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sheath
				l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltr = /obj/item/quiver/bolts
			if ("民兵战镐加鸢盾")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
				beltl = /obj/item/rogueweapon/pick/militia/steel		//this one has axe skill. Other one had MINING.
				backr = /obj/item/rogueweapon/shield/iron
			if ("民兵长矛加鸢盾")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/spear/militia
				backr = /obj/item/rogueweapon/shield/heater
			if ("民兵战斧")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/greataxe/militia
			if ("民兵古登达格棍")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/woodstaff/militia
			if ("链枷加鸢盾")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/flail/sflail
				backr = /obj/item/rogueweapon/shield/heater
		wretch_select_bounty(H)
