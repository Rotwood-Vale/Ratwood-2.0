#define CTAG_KJ_KNIGHT "CTAG_KJ_KNIGHT"
#define CTAG_KG_SQUIRE "CTAG_KG_SQUIRE"

/datum/migrant_role/kj_knight
	name = "骑士"
	advclass_cat_rolls = list(CTAG_KJ_KNIGHT = 20)

/datum/migrant_role/kj_knight/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/stabard))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "骑士罩袍（[index]）"
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/honorary = "爵士"
		if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
			honorary = "女爵"
		H.real_name = "[honorary] [prev_real_name]"
		H.name = "[honorary] [prev_name]"

/datum/advclass/kj_knight
	name = "骑士"
	tutorial = "你是一位来自遥远国度的骑士，出身于高贵家族，因为某种缘由来到 Rockwood 谷地。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/adventurer/knighte_expert
	traits_applied = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED, TRAIT_OUTLANDER)
	category_tags = list(CTAG_KJ_KNIGHT)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 2,
	)
	subclass_skills = list(
		/datum/skill/misc/riding= SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling= SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming= SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed= SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics= SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing= SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading= SKILL_LEVEL_JOURNEYMAN,
	)

	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/roguetown/adventurer/knighte_expert/pre_equip(mob/living/carbon/human/H)
	..()
	var/helmets = list(
		"猪脸护鼻盔" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
		"卫兵头盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
		"格栅头盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
		"桶盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
		"骑士头盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
		"带面罩沙勒盔"			= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
		"阿米特盔"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
		"犬面护鼻盔" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
		"伊特鲁里亚护鼻盔" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
		"开缝锅盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
		"无"
		)
	var/helmchoice = input(H, "选择你的头盔。", "戴上头盔") as anything in helmets
	if(helmchoice != "无")
		head = helmets[helmchoice]

	var/armors = list(
		"布面甲"		= /obj/item/clothing/suit/roguetown/armor/brigandine,
		"板片外套"	= /obj/item/clothing/suit/roguetown/armor/brigandine/coatplates,
		"钢胸甲"		= /obj/item/clothing/suit/roguetown/armor/plate/half,
		"槽纹胸甲"	= /obj/item/clothing/suit/roguetown/armor/plate/half/fluted,
		"鳞甲"		= /obj/item/clothing/suit/roguetown/armor/plate/scale,
		)
	var/armorchoice = input(H, "选择你的护甲。", "穿上护甲") as anything in armors
	armor = armors[armorchoice]

	gloves = /obj/item/clothing/gloves/roguetown/chain
	pants = /obj/item/clothing/under/roguetown/chainlegs
	cloak = /obj/item/clothing/cloak/stabard
	neck = /obj/item/clothing/neck/roguetown/bevor
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 3,
		/obj/item/needle = 1,
		/obj/item/recipe_book/survival = 1,
		)
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.set_blindness(0)
	var/weapons = list("长剑+盾牌","钉头锤+盾牌","连枷+盾牌","钩镰枪","骑枪+鸢盾","战斧","双手巨斧")
	var/weapon_choice = input(H, "选择你的武器。", "拿起武器") as anything in weapons
	switch(weapon_choice)
		if("长剑+盾牌")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_MASTER, TRUE)
			beltr = /obj/item/rogueweapon/sword/long
			r_hand = /obj/item/rogueweapon/scabbard/sword/noble
			backr = /obj/item/rogueweapon/shield/tower/metal
		if("钉头锤+盾牌")
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_MASTER, TRUE)
			beltr = /obj/item/rogueweapon/mace
			backr = /obj/item/rogueweapon/shield/tower/metal
		if("连枷+盾牌")
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_MASTER, TRUE)
			beltr = /obj/item/rogueweapon/flail
			backr = /obj/item/rogueweapon/shield/tower/metal
		if("钩镰枪")
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			r_hand = /obj/item/rogueweapon/spear/billhook
			backr = /obj/item/rogueweapon/scabbard/gwstrap
		if("骑枪+鸢盾")
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_MASTER, TRUE)
			r_hand = /obj/item/rogueweapon/spear/lance
			backr = /obj/item/rogueweapon/shield/tower/metal
		if("战斧")
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
			r_hand = /obj/item/rogueweapon/stoneaxe/battle
		if("双手巨斧")
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
			r_hand = /obj/item/rogueweapon/greataxe
			backr = /obj/item/rogueweapon/scabbard/gwstrap

/datum/migrant_role/kj_squire
	name = "侍从"
	advclass_cat_rolls = list(CTAG_KG_SQUIRE = 20)

/datum/advclass/kj_squire
	name = "侍从"
	outfit = /datum/outfit/job/roguetown/adventurer/squire
	traits_applied = list(TRAIT_SQUIRE_REPAIR, TRAIT_MEDIUMARMOR, TRAIT_OUTLANDER)
	category_tags = list(CTAG_KG_SQUIRE)
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_INT = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
	)
	subclass_virtues = list(
		/datum/virtue/utility/riding
	)
#undef CTAG_KJ_KNIGHT
#undef CTAG_KG_SQUIRE
