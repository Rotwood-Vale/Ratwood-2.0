/datum/advclass/noble
	name = "贵族"
	tutorial = "你是一名远游异乡的贵族。财富总会引来穷人觊觎，他们巴不得把你辛苦得来（或者说继承得来）的金币摸个精光，所以最好步步小心，免得落得个凄惨下场。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/adventurer/noble
	subclass_social_rank = SOCIAL_RANK_NOBLE
	traits_applied = list(TRAIT_NOBLE)
	class_select_category = CLASS_CAT_NOBLE
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)

	cmode_music = 'sound/music/combat_knight.ogg'
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/music = SKILL_LEVEL_NOVICE,
	)

	extra_context = "This class is restricted from using the Equestrian virtue."

	virtue_restrictions = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/roguetown/adventurer/noble/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是一名远游异乡的贵族。财富总会引来穷人觊觎，他们巴不得把你辛苦得来（或者说继承得来）的金币摸个精光，所以最好步步小心，免得落得个凄惨下场。"))
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	id = /obj/item/clothing/ring/silver
	beltl = /obj/item/rogueweapon/sword/sabre/dec
	l_hand = /obj/item/rogueweapon/scabbard/sword/noble
	if(should_wear_masc_clothes(H))
		cloak = /obj/item/clothing/cloak/half/red
		shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/red
		pants = /obj/item/clothing/under/roguetown/tights/black
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/gen/purple
		cloak = /obj/item/clothing/cloak/raincloak/purple
	// backpack_contents = list(/obj/item/recipe_book/survival = 1)//superceded by tgui
	H.set_blindness(0)

	if (H.mind && !H.mind.has_spell(/obj/effect/proc_holder/spell/self/choose_riding_virtue_mount))
		H.AddSpell(new /obj/effect/proc_holder/spell/self/choose_riding_virtue_mount)

/datum/advclass/noble/knighte
	name = "游方骑士"
	tutorial = "你是一名来自远方国度的骑士，出身某个贵胄家门，因种种缘由来到谷地。"
	outfit = /datum/outfit/job/roguetown/adventurer/knighte
	subclass_social_rank = SOCIAL_RANK_MINOR_NOBLE
	traits_applied = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
	)

	extra_context = "This class is restricted from using the Equestrian virtue."

	virtue_restrictions = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/roguetown/adventurer/knighte/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		to_chat(H, span_warning("你是一名来自远方国度的骑士，出身某个贵胄家门，因种种缘由来到谷地。"))
		var/helmets = list(
			"猪面尖盔" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"卫兵盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"栅面盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"桶盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"骑士盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"遮面沙勒盔"			= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"阿梅特盔"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"猎犬头尖盔" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"伊特鲁斯坎尖盔" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"窄缝锅盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"蛙嘴盔"	= /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth,
			"不戴头盔"
			)
		var/helmchoice = input(H, "选择你的头盔。", "整盔披甲") as anything in helmets
		if(helmchoice != "不戴头盔")
			head = helmets[helmchoice]

		var/armors = list(
			"布面甲"		= /obj/item/clothing/suit/roguetown/armor/brigandine,
			"札板外套"	= /obj/item/clothing/suit/roguetown/armor/brigandine/coatplates,
			"钢胸甲"		= /obj/item/clothing/suit/roguetown/armor/plate/half,
			)
		var/armorchoice = input(H, "选择你的护甲。", "整装备战") as anything in armors
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
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		)
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("长剑","钉锤与盾","连枷与盾","钩镰枪","战斧","巨斧")
		var/weapon_choice = input(H, "选择你的武器。", "执兵而起") as anything in weapons
		switch(weapon_choice)
			if("长剑")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/sword/long
				r_hand = /obj/item/rogueweapon/scabbard/sword/noble
			if("钉锤与盾")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/mace
				backr = /obj/item/rogueweapon/shield/tower/metal
			if("连枷与盾")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/flail
				backr = /obj/item/rogueweapon/shield/tower/metal
			if("钩镰枪")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/spear/billhook
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("战斧")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/stoneaxe/battle
			if("巨斧")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/greataxe
				backr = /obj/item/rogueweapon/scabbard/gwstrap

	if (H.mind && !H.mind.has_spell(/obj/effect/proc_holder/spell/self/choose_riding_virtue_mount))
		H.AddSpell(new /obj/effect/proc_holder/spell/self/choose_riding_virtue_mount)

/datum/advclass/noble/squire
	name = "游方侍从"
	tutorial = "你是一名远行四方的侍从，正在寻找一位肯磨炼你技艺的师傅，以及一位愿为你授勋的领主。"
	outfit = /datum/outfit/job/roguetown/adventurer/squire
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_SQUIRE_REPAIR)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_STR = 1,
		STATKEY_PER = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
	)
	extra_context = "可在轻甲（闪避专家）与中甲之间二选一。"

/datum/outfit/job/roguetown/adventurer/squire/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是一名远行在外的侍从，四处寻找愿意磨炼你技艺的师傅，以及愿意亲手授你骑士身份的领主。"))
	head = /obj/item/clothing/head/roguetown/roguehood
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	cloak = /obj/item/clothing/cloak/stabard
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/flashlight/flare/torch/lantern
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/storage/belt/rogue/pouch/coins/poor = 1, /obj/item/armor_brush = 1, /obj/item/polishing_cream = 1, /obj/item/rogueweapon/hammer/iron = 1, /obj/item/rogueweapon/huntingknife = 1, /obj/item/rogueweapon/scabbard/sheath/noble = 1)
	if(H.mind)
		var/armors = list("轻甲","中甲")
		var/armor_choice = input(H, "选择你的护甲。", "你将披着何等甲胄赴死") as anything in armors
		switch(armor_choice)
			if("轻甲")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
				armor = /obj/item/clothing/suit/roguetown/armor/leather
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
				gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			if("中甲")
				shirt = /obj/item/clothing/suit/roguetown/shirt/tunic
				armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
				pants = /obj/item/clothing/under/roguetown/chainlegs/iron
				gloves = /obj/item/clothing/gloves/roguetown/chain/iron
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
		var/weapons = list("骑士剑","短剑与盾","弓与箭","长矛")
		var/weapon_choice = input(H, "选择你的武器。", "你赴死前将挥舞何物") as anything in weapons
		switch(weapon_choice)
			if("骑士剑")
				backl = /obj/item/rogueweapon/scabbard/sword/noble
				r_hand = /obj/item/rogueweapon/sword/iron
			if("短剑与盾")
				beltr = /obj/item/rogueweapon/scabbard/sword/noble
				backl = /obj/item/rogueweapon/shield/wood
				r_hand = /obj/item/rogueweapon/sword/short/iron
			if("弓与箭")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_JOURNEYMAN, TRUE)
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				beltr = /obj/item/quiver/arrows
			if("长矛")
				r_hand = /obj/item/rogueweapon/spear
				backl = /obj/item/rogueweapon/scabbard/gwstrap
	H.set_blindness(0)
