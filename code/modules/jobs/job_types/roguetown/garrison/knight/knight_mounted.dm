/datum/advclass/knight/mountedknight
	name = "骑战骑士"
	tutorial = "你便是英雄长诗中最典型的骑士模样，深谙如何驾驭坐骑驰入战场。 \
	你专精于最适合马上作战的兵器，包括长剑、长柄武器与弓械。"
	outfit = /datum/outfit/job/roguetown/knight/mountedknight

	category_tags = list(CTAG_ROYALGUARD)

	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_EQUESTRIAN)
	//Decent all-around stats. Nothing spectacular. Ranged/melee hybrid class on horseback.
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 2,
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
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
	)

	extra_context = "This class is restricted from using the Equestrian virtue."

	virtue_restrictions = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/roguetown/knight/mountedknight/pre_equip(mob/living/carbon/human/H)
	..()
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= /mob/proc/haltyell

	if(H.mind)
		H.adjust_blindness(-3)
		var/weapons = list(
			"长剑 + 十字弩",
			"钩镰枪 + 反曲弓",
			"重钉锤 + 长弓",
			"马刀 + 反曲弓",
			"骑枪 + 鸢盾"
		)
		var/weapon_choice = input(H, "选择你的武器。", "整备武装") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("长剑 + 十字弩")
				beltl = /obj/item/rogueweapon/scabbard/sword/noble
				r_hand = /obj/item/rogueweapon/sword/long
				beltr = /obj/item/quiver/bolts
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("钩镰枪 + 反曲弓")
				r_hand = /obj/item/rogueweapon/spear/billhook
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/quiver/arrows
				beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
			if("重钉锤 + 长弓")
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
				beltr = /obj/item/quiver/arrows
				beltl = /obj/item/rogueweapon/mace/goden/steel
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
			if("马刀 + 反曲弓")
				l_hand = /obj/item/rogueweapon/scabbard/sword/noble
				r_hand = /obj/item/rogueweapon/sword/sabre
				beltr = /obj/item/quiver/arrows
				beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("骑枪 + 鸢盾")
				r_hand = /obj/item/rogueweapon/spear/lance
				backl = /obj/item/rogueweapon/shield/tower/metal
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_APPRENTICE, TRUE) // Let them skip dummy hitting

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
	
	if (H.mind)
		H.AddSpell(new /obj/effect/proc_holder/spell/self/choose_riding_virtue_mount)
