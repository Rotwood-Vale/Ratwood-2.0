/datum/advclass/knight/heavy
	name = "重装骑士"
	tutorial = "你受过极为扎实的训练，打击也比大多数人更为沉重，对剑、斧、锤与长柄武器都已运用纯熟。 \
	人们或许畏惧骑在鞍上的骑士，但他们真正该害怕的，是那些翻身下马之后依旧能把人撕碎的家伙……"
	outfit = /datum/outfit/job/roguetown/knight/heavy

	category_tags = list(CTAG_ROYALGUARD)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 3,//Heavy hitters. Less con/end, high strength.
		STATKEY_INT = 1,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/knight/heavy/pre_equip(mob/living/carbon/human/H)
	..()
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= /mob/proc/haltyell

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("巨剑","双手剑","重钉锤","战斧","巨斧","穿甲剑","鹰喙锤","战戟")
		var/weapon_choice = input(H, "选择你的武器。", "整备武装") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("巨剑")
				r_hand = /obj/item/rogueweapon/greatsword
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("双手剑")
				r_hand = /obj/item/rogueweapon/greatsword/grenz
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("重钉锤")
				r_hand = /obj/item/rogueweapon/mace/goden/steel
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
			if("战斧")
				r_hand = /obj/item/rogueweapon/stoneaxe/battle
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_MASTER, TRUE)
			if("巨斧")
				r_hand = /obj/item/rogueweapon/greataxe/steel
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_MASTER, TRUE)
			if("穿甲剑")
				r_hand = /obj/item/rogueweapon/estoc
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("鹰喙锤")
				r_hand = /obj/item/rogueweapon/eaglebeak
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
			if("战戟")
				r_hand = /obj/item/rogueweapon/spear/partizan
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)

	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	pants = /obj/item/clothing/under/roguetown/chainlegs

	if(H.mind)
		var/helmets = list(
			"猪面尖顶盔" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"萨伏伊式盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"栅面盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"桶盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"骑士盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"带面罩萨拉德盔"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"阿米特盔"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"犬吻尖顶盔" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"伊特鲁斯坎尖顶盔" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"开缝锅盔"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"蛙嘴盔"	= /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth,
			"无"
		)
		var/helmchoice = input(H, "选择你的头盔。", "整备头盔") as anything in helmets
		if(helmchoice != "无")
			head = helmets[helmchoice]

		var/armors = list(
			"布面甲"		= /obj/item/clothing/suit/roguetown/armor/brigandine/retinue,
			"甲片外衣"	= /obj/item/clothing/suit/roguetown/armor/brigandine/coatplates,
			"钢胸甲"		= /obj/item/clothing/suit/roguetown/armor/plate/half,
			"凹槽胸甲"	= /obj/item/clothing/suit/roguetown/armor/plate/half/fluted,
			"全身板甲"		= /obj/item/clothing/suit/roguetown/armor/plate/full,
			"华饰全身板甲"	= /obj/item/clothing/suit/roguetown/armor/plate/full/fluted,
		)
		var/armorchoice = input(H, "选择你的护甲。", "整备护甲") as anything in armors
		armor = armors[armorchoice]

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1
	)
