#define CTAG_VAMPIRE_SPAWN "ctag_vspawn"
/datum/job/roguetown/vampire_spawn
	title = "Vampire Spawn"
	flag = VAMPIRE_SERVANT
	department_flag = SLOP
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	min_pq = null
	max_pq = null

	allowed_sexes = list(MALE, FEMALE)
	tutorial = ""

	advclass_cat_rolls = list(CTAG_VAMPIRE_SPAWN = 20)
	show_in_credits = FALSE
	give_bank_account = FALSE
	announce_latejoin = FALSE
	cmode_music = 'sound/music/combat_weird.ogg'

/datum/job/roguetown/vampire_servant/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	SSmapping.retainer.death_knights |= L.mind
	return ..()

/datum/advclass/vampire_spawn
	name = "吸血鬼子嗣"
	outfit = /datum/outfit/job/roguetown/vampire_spawn

	category_tags = list(CTAG_VAMPIRE_SPAWN)

	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 3,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/vampire_spawn/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/bevor
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/steel
	backr = /obj/item/storage/backpack/rogue/satchel/black

	if(H.mind)
		var/weapons = list(
			"长剑与十字弩",
			"钩镰枪与反曲弓",
			"巨型权杖与长弓", 
			"军刀与反曲弓",
			"双手大剑",
			"重型权杖",
			"战斧",
			"双刃巨斧",
			"刺剑",
			"卢塞恩锤矛",
			"帕提赞长戟",
		)
		var/weapon_choice = input(H, "选择你的武器。", "整备武装") as anything in weapons
		switch(weapon_choice)
			if("长剑与十字弩")
				beltl = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long
				beltr = /obj/item/quiver/bolts
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			if("钩镰枪与反曲弓")
				r_hand = /obj/item/rogueweapon/spear/billhook
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/quiver/arrows
				beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			if("巨型权杖与长弓")
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
				beltr = /obj/item/quiver/arrows
				beltl = /obj/item/rogueweapon/mace/goden/steel
			if("军刀与反曲弓")
				l_hand = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/sabre
				beltr = /obj/item/quiver/arrows
				beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			if("双手大剑")
				r_hand = /obj/item/rogueweapon/greatsword/zwei
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("重型权杖")
				r_hand = /obj/item/rogueweapon/mace/goden/steel
			if("战斧")
				r_hand = /obj/item/rogueweapon/stoneaxe/battle
			if("双刃巨斧")
				r_hand = /obj/item/rogueweapon/greataxe/steel
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("刺剑")
				r_hand = /obj/item/rogueweapon/estoc
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("卢塞恩锤矛")
				r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("帕提赞长戟")
				r_hand = /obj/item/rogueweapon/spear/partizan
				backl = /obj/item/rogueweapon/scabbard/gwstrap

	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	pants = /obj/item/clothing/under/roguetown/chainlegs

	if(H.mind)
		var/helmets = list(
			"猪面巴西内盔" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"卫兵头盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"栅面头盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"桶盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"骑士头盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"带面甲萨莱特盔"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"阿米特盔"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"犬首巴西内盔" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"Etrusca 巴西内盔" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"裂缝锅盔"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"无"
		)
		var/helmchoice = input(H, "选择你的头盔。", "整备盔甲") as anything in helmets
		if(helmchoice != "无")
			head = helmets[helmchoice]

		var/armors = list(
			"布面甲"		= /obj/item/clothing/suit/roguetown/armor/brigandine/retinue,
			"札甲罩衣"	= /obj/item/clothing/suit/roguetown/armor/brigandine/coatplates,
			"钢胸甲"		= /obj/item/clothing/suit/roguetown/armor/plate/half,
			"纵槽胸甲"	= /obj/item/clothing/suit/roguetown/armor/plate/half/fluted,
		)
		var/armorchoice = input(H, "选择你的护甲。", "整备护甲") as anything in armors
		armor = armors[armorchoice]

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, 
		/obj/item/rope/chain = 1, 
		/obj/item/rogueweapon/scabbard/sheath = 1
	)
#undef CTAG_VAMPIRE_SPAWN
