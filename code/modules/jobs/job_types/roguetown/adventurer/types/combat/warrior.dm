/datum/advclass/sfighter
	name = "战阵大师"
	tutorial = "你是一名老练的兵器专家，身披锁甲，久经战阵与厮杀，早已把战场上的本事磨进了骨子里。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/sfighter
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander2.ogg'
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR)
	class_select_category = CLASS_CAT_WARRIOR
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 1,
		STATKEY_CON = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/sfighter/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是一名老练的兵器专家，身披锁甲，久经战阵与厮杀，早已把战场上的本事磨进了骨子里。"))
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("长剑","钉锤","钩镰枪","战斧","短剑与铁盾","铁军刀与木盾")
		var/weapon_choice = input(H, "选择你的武器。", "执兵而起") as anything in weapons
		switch(weapon_choice)
			if("长剑")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/rogueweapon/sword/long
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("钉锤")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/rogueweapon/mace
			if("钩镰枪")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/spear/billhook
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("战斧")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/rogueweapon/stoneaxe/battle
			if("短剑与铁盾")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				backr = /obj/item/rogueweapon/shield/iron
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/short/iron
			if("铁军刀与木盾")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/sabre/iron
				beltr = /obj/item/rogueweapon/scabbard/sword
				backr = /obj/item/rogueweapon/shield/wood
		var/armors = list("锁甲套装","铁胸甲","棉甲与头盔","轻型 Zybantu 护甲")
		var/armor_choice = input(H, "选择你的护甲。", "整装备战") as anything in armors
		switch(armor_choice)
			if("锁甲套装")
				armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
				shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random//giving them something to wear under their armors
				pants = /obj/item/clothing/under/roguetown/chainlegs/iron
				neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
				gloves = /obj/item/clothing/gloves/roguetown/chain/iron
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			if("铁胸甲")
				armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
				neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
				shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random
				pants = /obj/item/clothing/under/roguetown/splintlegs/iron
				gloves = /obj/item/clothing/gloves/roguetown/angle
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			if("棉甲与头盔")
				armor = /obj/item/clothing/suit/roguetown/armor/gambeson
				neck = /obj/item/clothing/neck/roguetown/coif/padded//neck cover
				shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random
				wrists = /obj/item/clothing/wrists/roguetown/splintarms/iron//adding it since this set feels far too weak compared to the other two, gets one helmet and arm cover at least
				pants = /obj/item/clothing/under/roguetown/trou/leather
				head = /obj/item/clothing/head/roguetown/helmet/kettle
				gloves = /obj/item/clothing/gloves/roguetown/angle
			if("轻型 Zybantu 护甲")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/zyb
				pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex/zyb
				head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab
				gloves = /obj/item/clothing/gloves/roguetown/angle
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)


/datum/advclass/sfighter/duelist
	name = "决斗家"
	tutorial = "你是一名受人尊敬的剑士，宁肯舍弃甲胄，也要换来更轻捷灵活的战斗方式。"
	outfit = /datum/outfit/job/roguetown/adventurer/duelist
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander2.ogg'
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_DODGEEXPERT, TRAIT_DECEIVING_MEEKNESS)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/duelist/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是一名受人尊敬的剑士，宁肯舍弃甲胄，也要换来更轻捷灵活的战斗方式。"))
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("刺剑与招架匕首","军刀与圆盾","单刃刀与圆盾","匕首与招架匕首","双持短剑","重型匕首与徒手强化")
		var/weapon_choice = input(H, "选择你的武器。", "执兵而起") as anything in weapons
		switch(weapon_choice)
			if("刺剑与招架匕首")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)//So it actually parries with said dagger.
				l_hand = /obj/item/rogueweapon/sword/rapier
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
				backr = /obj/item/rogueweapon/scabbard/sword
			if("军刀与圆盾")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/sword/sabre
				r_hand = /obj/item/rogueweapon/shield/buckler
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("单刃刀与圆盾")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/sword/short/messer/iron/virtue
				r_hand = /obj/item/rogueweapon/shield/buckler
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("匕首与招架匕首")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
				beltr = /obj/item/rogueweapon/scabbard/sheath
			if("重型匕首与徒手强化")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				l_hand = /obj/item/rogueweapon/huntingknife/combat
				beltr = /obj/item/rogueweapon/scabbard/sheath
			if("双持短剑")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				l_hand = /obj/item/rogueweapon/sword/short
				r_hand = /obj/item/rogueweapon/sword/short
				beltr = /obj/item/rogueweapon/scabbard/sword
				beltl = /obj/item/rogueweapon/scabbard/sword
	armor = /obj/item/clothing/armor/leather/jacket/leathercoat/duelcoat
	head = /obj/item/clothing/head/roguetown/duelisthat
	mask = /obj/item/clothing/mask/rogue/duelmask
	cloak = /obj/item/clothing/cloak/duelistcape
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	pants = /obj/item/clothing/under/roguetown/trou/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	neck = /obj/item/clothing/neck/roguetown/gorget
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/shield/buckler
	belt = /obj/item/storage/belt/rogue/leather
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/parrying = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/clothing/ring/duelist = 2
		)

/datum/advclass/sfighter/barbarian
	name = "蛮战士"
	tutorial = "你是一名残暴的战士，舍弃甲胄，只信奉最原始的力量。碾碎你的敌人，看着他们在你面前溃逃，听他们的女人放声哀嚎！哦，对了，你还可以专精徒手格斗与摔跤。"
	outfit = /datum/outfit/job/roguetown/adventurer/barbarian
	cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_CRITICAL_RESISTANCE, TRAIT_NOPAINSTUN)
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_INT = -2,
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
	)
	extra_context = "该子职业有两种修习路线可选：其一提供专家级拳斗能力与“专家拳师”特质；其二则给予独特装备，并以 1 点速度换取 1 点感知。"

/datum/outfit/job/roguetown/adventurer/barbarian/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	to_chat(H, span_warning("你是一名残暴的战士，舍弃甲胄，只信奉最原始的力量。碾碎你的敌人，看着他们在你面前溃逃，听他们的女人放声哀嚎！哦，对了，你还可以专精徒手格斗与摔跤。"))
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("青铜拳刃","青铜剑","青铜斧","青铜钉锤","青铜矛","修习 - 猎鞭者","修习 - 徒手")
		var/weapon_choice = input(H, "选择你的武器。", "执兵而起。") as anything in weapons
		switch(weapon_choice)
			if("青铜拳刃")
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
				head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
				r_hand = /obj/item/rogueweapon/katar/bronze
				gloves = /obj/item/clothing/gloves/roguetown/bandages
			if("青铜斧")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
				r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/bronze
				gloves = /obj/item/clothing/gloves/roguetown/bandages
			if("青铜剑")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/bronze
				gloves = /obj/item/clothing/gloves/roguetown/bandages
			if("青铜钉锤")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
				r_hand = /obj/item/rogueweapon/mace/bronze
				gloves = /obj/item/clothing/gloves/roguetown/bandages
			if("青铜矛")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
				r_hand = /obj/item/rogueweapon/spear/bronze
				gloves = /obj/item/clothing/gloves/roguetown/bandages
			if("修习 - 猎鞭者")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				head = /obj/item/clothing/head/roguetown/headband/monk/barbarian
				armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
				r_hand = /obj/item/rogueweapon/whip/bronze
				gloves = /obj/item/clothing/gloves/roguetown/bandages
				H.change_stat(STATKEY_SPD, -1) //Little more protection, little less speed.
				H.change_stat(STATKEY_PER, 1) //Allows for more critical usage of the Whip's strengths.
			if ("修习 - 徒手")
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
				ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
				head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
				gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
		belt = /obj/item/storage/belt/rogue/leather/battleskirt/barbarian
		pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/bronzeskirt
		shoes = /obj/item/clothing/shoes/roguetown/boots/furlinedboots
		wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	if(should_wear_masc_clothes(H))
		H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
		backl = /obj/item/storage/backpack/rogue/satchel
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/armor/leather/bikini
		backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife/bronze = 1,
		)

/datum/advclass/sfighter/ironclad
	name = "铁甲战士"
	tutorial = "你是一名将信赖寄托于坚实甲胄之上的战士。最好的进攻，往往就是最好的防御。"
	outfit = /datum/outfit/job/roguetown/adventurer/ironclad
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/ironclad/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	if(H.mind)
		to_chat(H, span_warning("你将信赖寄托于坚实甲胄之上。最好的进攻，往往就是最好的防御。"))
		var/helmets = list(
			"沙勒盔"			= /obj/item/clothing/head/roguetown/helmet/sallet/iron,
			"遮面沙勒盔"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored/iron,
			"锅盔"		= /obj/item/clothing/head/roguetown/helmet/kettle/iron,
			"桶盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron,
			"骑士盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/iron,
			"蛙嘴盔"	= /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth,
			"不戴头盔"
			)
		var/helmchoice = input(H, "选择你的头盔。", "整盔披甲") as anything in helmets
		if(helmchoice != "不戴头盔")
			head = helmets[helmchoice]

		var/armors = list(
			"胸甲加锁子外衣",
			"半身板甲加轻棉甲"
			)
		var/armorchoice = input(H, "选择你的护甲。", "整装备战") as anything in armors
		switch(armorchoice)
			if("胸甲加锁子外衣")
				armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
			if("半身板甲加轻棉甲")
				armor = /obj/item/clothing/suit/roguetown/armor/plate/iron
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light

		var/legs = list(
			"锁甲护腿"	= /obj/item/clothing/under/roguetown/chainlegs/iron,
			"锁甲裙甲"		= /obj/item/clothing/under/roguetown/chainlegs/iron/kilt
			)
		var/legschoice = input(H, "选择你的下装。", "整备护腿") as anything in legs
		pants = legs[legschoice]
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	neck = /obj/item/clothing/neck/roguetown/bevor/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/black
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		)
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("行刑剑","战锤与盾","连枷与盾","卢塞恩锤","巨斧","防御就是一切")
		var/weapon_choice = input(H, "选择你的武器。", "整装备战") as anything in weapons
		switch(weapon_choice)
			if("行刑剑")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				backr = /obj/item/rogueweapon/sword/long/exe
			if("战锤与盾")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/mace/warhammer
				backr = /obj/item/rogueweapon/shield/iron
			if("连枷与盾")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/flail
				backr = /obj/item/rogueweapon/shield/iron
			if("卢塞恩锤")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("巨斧")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/greataxe
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("防御就是一切")
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/shield/atgervi

/datum/advclass/sfighter/mhunter
	name = "驱魔人"
	tutorial = "你是专门猎杀可怖怪物的行家：夜兽、吸血鬼、活尸，以及更多污秽之物。凡人的血肉或许有所极限，但只要手持银兵、身披钢甲，你依旧能把天平稍稍拨向自己这一边。"
	outfit = /datum/outfit/job/roguetown/adventurer/mhunter
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander2.ogg'
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_PURITAN_ADVENTURER, TRAIT_ALCHEMY_EXPERT)
	maximum_possible_slots = 5 //Not a Wretch or Towner, but still conditionally lethal for an Adventurer - especially with steel coverage and round-start access to silver weapons. Adjust the amount of available slots as needed.
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
	) //Follows the Adventurer's seven-point statblock rule. Adds an eighth point to an unoccupied statkey, when a discipline is selected.
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		)
	extra_context = "该子职业可在开局时选择一把银制武器，并从三种修习路线中择一：每条路线都会提供不同等级的护甲训练、独特特质，以及对若干属性的小幅 1 点加成。年老角色在该子职业上会更为娴熟。"

/datum/outfit/job/roguetown/adventurer/mhunter/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	to_chat(H, span_warning("你是专门猎杀可怖怪物的行家：夜兽、吸血鬼、活尸，以及更多污秽之物。凡人的血肉或许有所极限，但只要手持银兵、身披钢甲，你依旧能把天平稍稍拨向自己这一边。"))
	H.verbs |= /mob/living/carbon/human/proc/faith_test //Allows the Exorcist to interrogate others for their faith. Trait's agnostically worded, to allow more flexiable usage by Pantheoneers and Ascendants in this role.
	H.verbs |= /mob/living/carbon/human/proc/torture_victim //Not as scary as it sounds. Mostly. Okay, just a little bit.
	if(H.mind)
		var/silver = list("银匕首","银短剑","银骑士剑","银刺剑","银长剑","银阔剑","银钉锤","银战锤","银晨星锤","银鞭","银战斧","银长柄斧","银长矛","银长杖")
		var/silver_choice = input(H, "选择你的武器。", "整备兵刃。") as anything in silver //Trim down to five or six choices, later? See what's the most popular, first. Gives people a chance to experiment with all of the new silver weapons.
		switch(silver_choice)
			if("银匕首")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/silver
				beltr = /obj/item/rogueweapon/scabbard/sheath
			if("银短剑")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/short/silver
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("银骑士剑")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/silver
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("银刺剑")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/rapier/silver
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("银长剑")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/long/silver
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("银阔剑")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/long/kriegmesser/silver
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("银钉锤")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/mace/steel/silver
			if("银战锤")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/mace/warhammer/steel/silver
			if("银晨星锤")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/flail/sflail/silver
			if("银鞭")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/whip/silver
			if("银战斧")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/silver
			if("银长柄斧")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/greataxe/silver
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("银长矛")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/spear/silver
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("银长杖")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/silver
				backr = /obj/item/rogueweapon/scabbard/gwstrap

		var/sidearm = list("匕首", "招架匕首", "萨克斯短刃", "祝圣银桩", "祝圣银铲", "巨盾")
		var/sidearm_choice = input(H, "选择你的副武器。", "先祈祷，再出手。") as anything in sidearm
		switch(sidearm_choice)
			if("匕首")
				l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("招架匕首")
				l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("萨克斯短刃")
				l_hand = /obj/item/rogueweapon/huntingknife/combat
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("祝圣银桩")
				l_hand = /obj/item/rogueweapon/huntingknife/idagger/silver/stake/preblessed
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("祝圣银铲")
				l_hand = /obj/item/rogueweapon/shovel/silver/preblessed //Unlocks the secret 'Shovel Knight' subclass. No dagger skills if you take this. Doesn't scale off anything, I think. Raw style.
			if("巨盾")
				l_hand = /obj/item/rogueweapon/shield/tower/metal
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)

		var/discipline = list("守旧派 - 邪魅炼金与锁甲外衣", "改革派 - 闪避专家与短锁甲", "正统派 - 板甲训练与胸甲")
		var/discipline_choice = input(H, "选择你的修习路线。", "直面你的梦魇。") as anything in discipline
		switch(discipline_choice)
			if("守旧派 - 邪魅炼金与锁甲外衣")
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_SILVER_BLESSED, TRAIT_GENERIC) //'Witcher' archetype. Weaponized alchemy gifts both immunity to nitebeastly curses and a self-suppliable +3 statboost. Well-rounded in almost every facet, but leaves less to chance.
				H.change_stat(STATKEY_INT, 1)
				H.change_stat(STATKEY_LCK, -1)
				head = /obj/item/clothing/head/roguetown/puritan/armored
				armor = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
				belt = /obj/item/storage/belt/rogue/leather/black
				beltl = pick(
					/obj/item/reagent_containers/glass/bottle/alchemical/strpot,
					/obj/item/reagent_containers/glass/bottle/alchemical/conpot,
					/obj/item/reagent_containers/glass/bottle/alchemical/endpot,
					/obj/item/reagent_containers/glass/bottle/alchemical/spdpot,
					/obj/item/reagent_containers/glass/bottle/alchemical/perpot,
					/obj/item/reagent_containers/glass/bottle/alchemical/intpot,
					/obj/item/reagent_containers/glass/bottle/alchemical/lucpot,
					)
			if("改革派 - 闪避专家与短锁甲")
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC) //'Puritan' archetype. Closer to the Roguetown-era Inquisitor in portrayal. No armor training, but overprepared with silver throwing daggers and excellent evasive maneuvers.
				H.change_stat(STATKEY_SPD, 1)
				H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)
				head = /obj/item/clothing/head/roguetown/puritan
				armor = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
				belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/silver
			if("正统派 - 板甲训练与胸甲")
				ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_ZOMBIE_IMMUNE, TRAIT_GENERIC) //'Templar' archetype. Blessings protect from the Rot, while opening the opportunity for heavy armor usage. Well-protected and resilient, but slower and visibly identifiable as a prioritable threat.
				H.change_stat(STATKEY_CON, 1)
				H.change_stat(STATKEY_SPD, -1)
				armor = /obj/item/clothing/suit/roguetown/armor/plate/half/fluted
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
				belt = /obj/item/storage/belt/rogue/leather/black
				var/helmets = list("清教武帽", "遮面沙勒盔", "Volfskulle 尖盔", "饰纹阿梅特盔")
				var/helmet_choice = input(H, "选择你的面貌。", "鼓起精神。") as anything in helmets
				switch(helmet_choice)
					if("清教武帽")
						head = /obj/item/clothing/head/roguetown/puritan/armored
					if("遮面沙勒盔")
						head = /obj/item/clothing/head/roguetown/helmet/sallet/visored
					if("Volfskulle 尖盔")
						head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/puritan
					if("饰纹阿梅特盔")
						head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/fluted

	backl = /obj/item/storage/backpack/rogue/satchel
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	pants = /obj/item/clothing/under/roguetown/tights/puritan
	cloak = /obj/item/clothing/cloak/cape/puritan
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	gloves = /obj/item/clothing/gloves/roguetown/angle
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/metal = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife = 1, //Ensures that Exorcists who take the Shovel can still butcher wildlife. Minor oversight on my part.
		)
	var/cross = list("众神升临", "旧神哀悼") 
	var/cross_choice = input(H, "你佩戴的是谁的圣徽？", "选择你的圣器。") as anything in cross
	switch(cross_choice)
		if("众神升临")
			wrists = /obj/item/clothing/neck/roguetown/psicross/silver/undivided
		if("旧神哀悼")
			wrists = /obj/item/clothing/neck/roguetown/psicross/silver

	if(H.age == AGE_OLD)
		H.change_stat(STATKEY_INT, 1)
		H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/axes, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	//Old people get the option to become glass cannons. Expert Knives + Expert in their chosen weapon, but a permenant -I STR, -I PER, -2 SPD and -2 CON debuff.
/datum/advclass/sfighter/amazon
	name = "亚马逊战士"
	tutorial = "来自远方异土的凶悍女战士。亚马逊人会依照自己偏好的战斗方式选择护甲，从轻捷灵动到重甲护身，各有其道。"
	outfit = /datum/outfit/job/adventurer/amazon
	traits_applied = list(TRAIT_STEELHEARTED)
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	subclass_stats = list()
	subclass_social_rank = SOCIAL_RANK_DIRT

/datum/outfit/job/adventurer/amazon/pre_equip(mob/living/carbon/human/H, visualsOnly)

	var/armor_styles = list("皮甲式样","兽皮甲式样","铆钉皮甲式样","半身板甲式样","全身板甲式样")
	var/armor_choice = input(H, "选择你的护甲风格。", "可用护甲风格") as anything in armor_styles

	switch(armor_choice)

		if("皮甲式样")
			to_chat(H, span_warning("你是一名迅捷灵活的战士，仰仗速度与闪避周旋。轻便皮甲让你的机动性发挥到极致。"))
			H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
			H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)
			H.adjust_skillrank(/datum/skill/craft/tanning, 2, TRUE)
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			H.set_blindness(0)
			H.change_stat("speed", 3)
			H.change_stat("willpower", 1)
			H.change_stat("strength", 1)
			armor = /obj/item/clothing/suit/roguetown/armor/leather/bikini
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/bikini
			pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shorts
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			shoes = /obj/item/clothing/shoes/roguetown/boots/furlinedboots
			gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
			backl = /obj/item/storage/backpack/rogue/satchel
			belt = /obj/item/storage/belt/rogue/leather
			neck = /obj/item/storage/belt/rogue/pouch/coins/poor
			backpack_contents = list(/obj/item/flashlight/flare/torch = 1, /obj/item/rogueweapon/huntingknife = 1)
			var/weapons = list("钢指虎","斧","剑","鞭","矛","老娘赤手空拳就够了！！！")
			var/weapon_choice = input(H, "选择你的武器。", "执兵而起") as anything in weapons
			switch(weapon_choice)
				if ("钢指虎")
					H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
					beltr = /obj/item/rogueweapon/knuckles
				if("斧")
					H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
					beltr = /obj/item/rogueweapon/stoneaxe/boneaxe
				if("剑")
					H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
					r_hand = /obj/item/rogueweapon/sword/short
					beltr = /obj/item/rogueweapon/scabbard/sword
				if("鞭")
					H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
					beltr = /obj/item/rogueweapon/whip
				if("矛")
					H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
					r_hand = /obj/item/rogueweapon/spear/bonespear
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if ("老娘赤手空拳就够了！！！")
					H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
					ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)

		if("兽皮甲式样")
			to_chat(H, span_warning("你是一名迅捷灵活的战士，仰仗速度与闪避周旋。轻便皮甲让你的机动性发挥到极致。"))
			H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
			H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)
			H.adjust_skillrank(/datum/skill/craft/tanning, 2, TRUE)
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			H.set_blindness(0)
			H.change_stat("speed", 3)
			H.change_stat("willpower", 1)
			H.change_stat("strength", 1)
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hide/bikini
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/bikini
			pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shorts
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			shoes = /obj/item/clothing/shoes/roguetown/boots/furlinedboots
			gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
			backl = /obj/item/storage/backpack/rogue/satchel
			belt = /obj/item/storage/belt/rogue/leather
			neck = /obj/item/storage/belt/rogue/pouch/coins/poor
			backpack_contents = list(/obj/item/flashlight/flare/torch = 1, /obj/item/rogueweapon/huntingknife = 1)
			var/weapons = list("钢指虎","斧","剑","鞭","矛","老娘赤手空拳就够了！！！")
			var/weapon_choice = input(H, "选择你的武器。", "执兵而起") as anything in weapons
			switch(weapon_choice)
				if ("钢指虎")
					H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
					beltr = /obj/item/rogueweapon/knuckles
				if("斧")
					H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
					beltr = /obj/item/rogueweapon/stoneaxe/boneaxe
				if("剑")
					H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
					r_hand = /obj/item/rogueweapon/sword/short
					beltr = /obj/item/rogueweapon/scabbard/sword
				if("鞭")
					H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
					beltr = /obj/item/rogueweapon/whip
				if("矛")
					H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
					r_hand = /obj/item/rogueweapon/spear/bonespear
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if ("老娘赤手空拳就够了！！！")
					H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
					ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)


		if("铆钉皮甲式样")
			to_chat(H, span_warning("你是一名讲究章法的战士，将轻便防护与精准兵器巧妙结合。"))
			H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			H.set_blindness(0)
			H.change_stat("speed", 2)
			H.change_stat("willpower", 1)
			H.change_stat("strength", 2)
			armor = /obj/item/clothing/suit/roguetown/armor/leather/studded/bikini
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/bikini
			pants = /obj/item/clothing/under/roguetown/tights/black
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			shoes = /obj/item/clothing/shoes/roguetown/boots
			gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
			backl = /obj/item/storage/backpack/rogue/satchel
			belt = /obj/item/storage/belt/rogue/leather
			neck = /obj/item/storage/belt/rogue/pouch/coins/poor
			backpack_contents = list(/obj/item/flashlight/flare/torch = 1, /obj/item/rogueweapon/huntingknife/idagger/steel = 1)
			var/weapons = list("拳刃","刺剑","鞭","钩镰枪","老娘赤手空拳就够了！！！")
			var/weapon_choice = input(H, "选择你的武器。", "整装备战") as anything in weapons
			switch(weapon_choice)
				if ("拳刃")
					H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
					beltr = /obj/item/rogueweapon/katar
				if("刺剑")
					H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
					beltr = /obj/item/rogueweapon/sword/rapier
				if("鞭")
					H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
					beltr = /obj/item/rogueweapon/whip
				if("钩镰枪")
					H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
					r_hand = /obj/item/rogueweapon/spear/billhook
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if ("老娘赤手空拳就够了！！！")
					H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
					ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)

		if("半身板甲式样")
			to_chat(H, span_warning("你是一名路数均衡的战士，身着中甲，挥舞重兵，专为打出毁灭性的猛击。"))
			H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)			
			H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_NOPAIN, TRAIT_GENERIC)
			H.set_blindness(0)
			H.change_stat("strength", 2)
			H.change_stat("willpower", 2)
			H.change_stat("constitution", 1)
			armor = /obj/item/clothing/suit/roguetown/armor/plate/bikini
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/bikini
			pants = /obj/item/clothing/under/roguetown/trou/leather
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			shoes = /obj/item/clothing/shoes/roguetown/boots
			gloves = /obj/item/clothing/gloves/roguetown/angle
			backl = /obj/item/storage/backpack/rogue/satchel
			belt = /obj/item/storage/belt/rogue/leather
			neck = /obj/item/storage/belt/rogue/pouch/coins/poor
			var/weapons = list("巨剑","鹰嘴锤","战斧","老娘赤手空拳就够了！！！")
			var/weapon_choice = input(H, "选择你的武器。", "执兵而起") as anything in weapons
			switch(weapon_choice)
				if("巨剑")
					H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
					r_hand = /obj/item/rogueweapon/greatsword
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("鹰嘴锤")
					H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
					r_hand = /obj/item/rogueweapon/eaglebeak
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("战斧")
					H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
					beltr = /obj/item/rogueweapon/stoneaxe/battle
				if ("老娘赤手空拳就够了！！！")
					H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
					ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
			backpack_contents = list(/obj/item/flashlight/flare/torch = 1, /obj/item/rogueweapon/huntingknife = 1, /obj/item/recipe_book/survival = 1)

		if("全身板甲式样")
			to_chat(H, span_warning("你是一头披甲重装的攻城槌，躲在大盾之后也能硬吃惊人的打击而不倒。"))
			H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)	//Funny nerf because I can in fact stop you. No double shield meta for you.		
			H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
			ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
			H.set_blindness(0)
			H.change_stat("strength", 3)
			H.change_stat("constitution", 3)
			H.change_stat("speed", -1)
			armor = /obj/item/clothing/suit/roguetown/armor/plate/full/bikini
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/bikini
			pants = /obj/item/clothing/under/roguetown/trou/leather
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			shoes = /obj/item/clothing/shoes/roguetown/boots
			gloves = /obj/item/clothing/gloves/roguetown/angle
			backl = /obj/item/storage/backpack/rogue/satchel
			belt = /obj/item/storage/belt/rogue/leather
			neck = /obj/item/storage/belt/rogue/pouch/coins/poor
			backpack_contents = list(/obj/item/flashlight/flare/torch = 1, /obj/item/rogueweapon/huntingknife = 1, /obj/item/recipe_book/survival = 1)
			var/weapons = list("剑与塔盾","钉锤与塔盾","两面塔盾！！！")
			var/weapon_choice = input(H, "选择你的武器。", "执兵而起") as anything in weapons
			switch(weapon_choice)
				if("剑与塔盾")
					H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
					r_hand = /obj/item/rogueweapon/sword/short
					backr = /obj/item/rogueweapon/shield/tower
					beltr = /obj/item/rogueweapon/scabbard/sword
				if("钉锤与塔盾")
					H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
					beltr = /obj/item/rogueweapon/mace
					backr = /obj/item/rogueweapon/shield/tower
				if ("两面塔盾！！！")
					H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
					r_hand = /obj/item/rogueweapon/shield/tower
					l_hand = /obj/item/rogueweapon/shield/tower
					ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
