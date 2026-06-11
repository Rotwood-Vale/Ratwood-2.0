/datum/advclass/knight/footknight
	name = "步战骑士"
	tutorial = "你早已习惯传统的步战之道，对剑、连枷与钉锤的运用都已炉火纯青。 \
	你的坚韧与盾兵武器并用的老练技巧，使你成为极难撂倒的可怕对手！"
	outfit = /datum/outfit/job/roguetown/knight/footknight

	category_tags = list(CTAG_ROYALGUARD)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 1,//Tanky, less strength, but high con/end.
		STATKEY_INT = 1,
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/knight/footknight/pre_equip(mob/living/carbon/human/H)
	..()
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= /mob/proc/haltyell

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("长剑","连枷","战锤","马刀")
		var/weapon_choice = input(H, "选择你的武器。", "整备武装") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("长剑")
				beltl = /obj/item/rogueweapon/scabbard/sword/noble
				l_hand = /obj/item/rogueweapon/sword/long
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("连枷")
				l_hand = /obj/item/rogueweapon/flail/sflail
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_MASTER, TRUE)
			if("战锤")
				beltr = /obj/item/rogueweapon/mace/warhammer/steel
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
			if("马刀")
				beltl = /obj/item/rogueweapon/scabbard/sword/noble
				l_hand = /obj/item/rogueweapon/sword/sabre
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)

	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	pants = /obj/item/clothing/under/roguetown/chainlegs
	backl = /obj/item/rogueweapon/shield/tower/metal
	if(H.mind)
		var/helmets = list(
			"猪面尖顶盔" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"卫士盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
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
