//CON/WIL with a saiga. A polearm footman but not actually.
//An odd combination of stats and skills, rounded out by a saiga and the funny riding trait.
/datum/advclass/manorguard/cavalry
	name = "骑兵"
	tutorial = "你是王国的职业军士，专精于马蹄轰鸣的冲阵之道。你比骑士更轻装，也更容易被拿去消耗，但你仍会手执长枪，直冲敌阵。"
	outfit = /datum/outfit/job/roguetown/manorguard/cavalry

	category_tags = list(CTAG_MENATARMS)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_EQUESTRIAN)
	//Garrison mounted class; charge and charge often.
	subclass_stats = list(
		STATKEY_CON = 2,// seems kinda lame but remember guardsman bonus!!
		STATKEY_WIL = 2,// Your name is speed, and speed is running.
		STATKEY_STR = 1,
		STATKEY_INT = 1, // No strength to account for the nominally better weapons. We'll see.
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN, 		// Still have a cugel.
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,	//Best whip training out of MAAs, they're strong.
		/datum/skill/combat/bows = SKILL_LEVEL_NOVICE,			// We discourage horse archers, though.
		/datum/skill/combat/slings = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT, 		// Like the other horselords.
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,	//Best tracker. Might as well give it something to stick-out utility wise.
	)

	extra_context = "This class is restricted from using the Equestrian virtue."

	virtue_restrictions = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/roguetown/manorguard/cavalry/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/gorget
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	beltl = /obj/item/rogueweapon/mace/cudgel
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("长柄宽刃斧","剑与盾")
		var/weapon_choice = input(H, "选择你的武器。", "拿起武器") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("长柄宽刃斧")
				r_hand = /obj/item/rogueweapon/halberd/bardiche
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("剑与盾")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/sabre
				backl = /obj/item/rogueweapon/shield/wood

		backpack_contents = list(
			/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
			/obj/item/rope/chain = 1,
			/obj/item/storage/keyring/guardcastle = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
			)
		H.verbs |= /mob/proc/haltyell

		var/armor_options = list("锁片甲套装", "锁子甲套装")
		var/armor_choice = input(H, "选择你的护甲。", "穿上护甲") as anything in armor_options

		switch(armor_choice)
			if("锁片甲套装")
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light/retinue
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
				wrists = /obj/item/clothing/wrists/roguetown/splintarms
				pants = /obj/item/clothing/under/roguetown/splintlegs

			if("锁子甲套装")
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				pants = /obj/item/clothing/under/roguetown/chainlegs

		var/helmets = list(
		"素盔" 	= /obj/item/clothing/head/roguetown/helmet,
		"锅盔" 	= /obj/item/clothing/head/roguetown/helmet/kettle,
		"尖顶盔"		= /obj/item/clothing/head/roguetown/helmet/bascinet,
		"萨莱特盔"		= /obj/item/clothing/head/roguetown/helmet/sallet,
		"翼盔" 	= /obj/item/clothing/head/roguetown/helmet/winged,
		"护顶盔"			= /obj/item/clothing/head/roguetown/helmet/skullcap,
		"无"
		)
		var/helmchoice = input(H, "选择你的头盔。", "戴上头盔") as anything in helmets
		if(helmchoice != "无")
			head = helmets[helmchoice]

	if (H.mind)
		H.AddSpell(new /obj/effect/proc_holder/spell/self/choose_riding_virtue_mount)
