/proc/ferentia_locality(mob/living/carbon/human/H)
	var/is_local = input(H, "你是本地人吗？", "费伦提亚王国") as anything in list("我来自谷地", "我是外乡人")
	switch(is_local)
		if("我来自谷地")
			REMOVE_TRAIT(H, TRAIT_OUTLANDER, JOB_TRAIT)
		else
			to_chat(H, span_notice("我从费伦提亚王国的另一处郡地远道而来，抵达了谷地的佣兵行会。"))


/datum/advclass/mercenary/ferentia
	name = "卖命骑士"
	tutorial = "战斗经验与武艺可付不起食宿，真能买单的是马蒙。你只是看起来像个骑士，于是投身佣兵行会，把自己这副持剑卖力的身板卖给出价最高的人。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/ferentia_sellknight
	class_select_category = CLASS_CAT_FERENTIA
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/combat_fullplate.ogg'
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list( //Roughly equivalent to the Doppelsoldner, but without their unique sword or blacksteel armor, in exchange they're basically a regular guy in plate armor
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_STR = 2,
		STATKEY_INT = 1,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT, //Sword and board kinda guy
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/mercenary/ferentia_sellknight/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("战斗经验与武艺可付不起食宿，真能买单的是马蒙。你只是看起来像个骑士，于是投身佣兵行会，把自己这副持剑卖力的身板卖给出价最高的人。"))
	if(H.mind)
		var/weapons = list("巨剑", "长剑与盾", "细剑与小圆盾")
		var/weapon_choice = input(H, "选择你的武器。", "整备武装") as anything in weapons
		switch(weapon_choice)
			if("巨剑")
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/greatsword
			if("长剑与盾")
				beltl = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long
				backl = /obj/item/rogueweapon/shield/tower/metal
			if("细剑与小圆盾")
				beltl = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/rapier
				backl = /obj/item/rogueweapon/shield/buckler
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
			"开缝锅盔" = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"蛙嘴盔"	= /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth,
			"无"
		)
		var/helmchoice = input(H, "选择你的头盔。", "整备头盔") as anything in helmets
		if(helmchoice != "无")
			head = helmets[helmchoice]
	wrists = /obj/item/clothing/wrists/roguetown/splintarms //We're lowkey kinda poor, so mostly iron armor for anything which isn't vital
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/gorget
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half //Sorry! If you want good armor, better get someone to pay you
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	ferentia_locality(H)
	H.merctype = 17

/datum/advclass/mercenary/ferentia/sellspear
	name = "卖命枪兵"
	tutorial = "像你这样无名而众多的人，正塞满了整座佣兵行会。锁子甲与长柄武器既适合未经细训的人使用，也同样足够有效。"
	outfit = /datum/outfit/job/roguetown/mercenary/ferentia_sellspear
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list( //Extremely all-rounder statline for an extremely all-rounder weapon class and middling armor class. You are John Spearman
		STATKEY_PER = 2, //For stabbing and guardsman larping
		STATKEY_WIL = 2,
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN, //You have an arming sword as a backup but you're not very stellar with it peasant
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/mercenary/ferentia_sellspear/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("像你这样无名而众多的人，正塞满了整座佣兵行会。锁子甲与长柄武器既适合未经细训的人使用，也同样足够有效。"))
	if(H.mind)
		var/weapons = list("戟斧", "战戟", "鹰喙锤", "钩镰枪")
		var/weapon_choice = input(H, "选择你的武器。", "整备武装") as anything in weapons
		switch(weapon_choice)
			if("戟斧")
				r_hand = /obj/item/rogueweapon/halberd
			if("战戟")
				r_hand = /obj/item/rogueweapon/spear/partizan
			if("鹰喙锤")
				r_hand = /obj/item/rogueweapon/eaglebeak
			if("钩镰枪")
				r_hand =/obj/item/rogueweapon/spear/billhook
		var/helmets = list(
			"简盔" 	= /obj/item/clothing/head/roguetown/helmet,
			"锅盔" 	= /obj/item/clothing/head/roguetown/helmet/kettle,
			"尖顶盔"	= /obj/item/clothing/head/roguetown/helmet/bascinet,
			"萨拉德盔"		= /obj/item/clothing/head/roguetown/helmet/sallet,
			"翼盔" 	= /obj/item/clothing/head/roguetown/helmet/winged,
			"铁帽"			= /obj/item/clothing/head/roguetown/helmet/skullcap,
			"无"
		)
		var/helmchoice = input(H, "选择你的头盔。", "整备头盔") as anything in helmets
		if(helmchoice != "无")
			head = helmets[helmchoice]
	l_hand = /obj/item/rogueweapon/sword
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/chain
	backr = /obj/item/storage/backpack/rogue/satchel
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	beltl = /obj/item/rogueweapon/scabbard/sword
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	ferentia_locality(H)
	H.merctype = 17

/datum/advclass/mercenary/ferentia/sellblade
	name = "卖命刀客"
	tutorial = "你既精于刀刃，又步伐轻捷，像你这样的人在佣兵行会里算得上少见。可一旦融入阴影，为他人干那些见不得光的脏活时，你依旧高效得可怕，出手又快又致命。"
	outfit = /datum/outfit/job/roguetown/mercenary/ferentia_sellblade
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_SEEPRICES_SHITTY) //Obligatory fast and nimble dodge expert class, specializing in either daggers or stabby swift weighted swords
	subclass_stats = list( //Potentially a kind of scary statline, but you're going to be frail
		STATKEY_SPD = 3,
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_CON = -1

	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE, //No lockpicking or pickpocketing, you're a shady as fuck shanker, not a thief role
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE, //Your bane is being grabbed, you're an assassin, not a grappler
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	)
	extra_context = "该分支会在所选武器上获得专家级熟练，无论你选的是剑还是匕首。"

/datum/outfit/job/roguetown/mercenary/ferentia_sellblade/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你既精于刀刃，又步伐轻捷，像你这样的人在佣兵行会里算得上少见。可一旦融入阴影，为他人干那些见不得光的脏活时，你依旧高效得可怕，出手又快又致命。"))
	if(H.mind)
		var/weapons = list("细剑", "匕首")
		var/weapon_choice = input(H, "选择你的武器。", "整备武装") as anything in weapons
		switch(weapon_choice)
			if("细剑")
				r_hand = /obj/item/rogueweapon/sword/rapier
				beltl = /obj/item/rogueweapon/scabbard/sword
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			if("匕首")
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
				beltl = /obj/item/rogueweapon/scabbard/sheath
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	belt = /obj/item/storage/belt/rogue/leather
	head = /obj/item/clothing/head/roguetown/roguehood/reinforced
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	neck = /obj/item/clothing/neck/roguetown/bevor
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/angle
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	ferentia_locality(H)
	H.merctype = 17

/datum/advclass/mercenary/ferentia/thug
	name = "受雇打手"
	tutorial = "佣兵行会里挤满了像你这样吃壮了身板、只会靠一把子蛮力挣马蒙的莽汉。头脑简单这词用来形容你最贴切，但你也确实拥有蛮横的力气和一根沉重棍棒。有时候，解决问题就只需要这些。"
	outfit = /datum/outfit/job/roguetown/mercenary/ferentia_thug
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_BASHDOORS, TRAIT_SEEPRICES_SHITTY, TRAIT_DRUNK_HEALING)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 3,
		STATKEY_WIL = 2,
		STATKEY_INT = -2

	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT, 
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
	)
	extra_context = "该分支会在所选战斗方式上获得专家级熟练，无论你选的是锤类还是徒手。"

/datum/outfit/job/roguetown/mercenary/ferentia_thug/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("佣兵行会里挤满了像你这样吃壮了身板、只会靠一把子蛮力挣马蒙的莽汉。头脑简单这词用来形容你最贴切，但你也确实拥有蛮横的力气和一根沉重棍棒。有时候，解决问题就只需要这些。"))
	if(H.mind)
		var/weapons = list("钉锤", "战锤", "要什么棍棒？老子有这双手！")
		var/weapon_choice = input(H, "选择你的武器。", "整备武装") as anything in weapons
		switch(weapon_choice)
			if("钉锤")
				r_hand = /obj/item/rogueweapon/mace/steel
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			if("战锤")
				r_hand = /obj/item/rogueweapon/mace/warhammer/steel
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			if("要什么棍棒？老子有这双手！")
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
				ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather
	head = /obj/item/clothing/neck/roguetown/chaincoif/iron
	mask = /obj/item/clothing/mask/rogue/facemask
	neck = /obj/item/clothing/neck/roguetown/gorget
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/plate
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	ferentia_locality(H)
	H.merctype = 17

/datum/advclass/mercenary/ferentia/crossbowman
	name = "轻装弩手"
	tutorial = "也许你曾是某支卫队的一员，接受过棍棒与十字弩的训练，如今则以费伦提亚人中常见却可靠的远程战力身份，为佣兵行会效劳。"
	outfit = /datum/outfit/job/roguetown/mercenary/ferentia_crossbowman
	traits_applied = list(TRAIT_KEENEARS) //Guardmaxing
	subclass_stats = list( //You're a little bit more tailored to the crossbowman identity than the Grenzelhoft crossbowman which is more of a utility role
		STATKEY_PER = 3,
		STATKEY_WIL = 2,
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN, //Crossbow is your main weapon
		/datum/skill/combat/crossbows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE, //Ranged babies are made to be grabbed
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/mercenary/ferentia_crossbowman/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("也许你曾是某支卫队的一员，接受过棍棒与十字弩的训练，如今则以 费伦提亚 人中常见却可靠的远程战力身份，为佣兵行会效劳。"))
	if(H.mind)
		var/armor_options = list("轻型布面甲", "铆钉皮背心")
		var/armor_choice = input(H, "选择你的护甲。", "整备着装") as anything in armor_options
		switch(armor_choice)
			if("轻型布面甲")
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
			if("铆钉皮背心")
				armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
		var/helmets = list(
			"简盔" 	= /obj/item/clothing/head/roguetown/helmet,
			"锅盔" 	= /obj/item/clothing/head/roguetown/helmet/kettle,
			"尖顶盔"	= /obj/item/clothing/head/roguetown/helmet/bascinet,
			"萨拉德盔"		= /obj/item/clothing/head/roguetown/helmet/sallet,
			"翼盔" 	= /obj/item/clothing/head/roguetown/helmet/winged,
			"铁帽"			= /obj/item/clothing/head/roguetown/helmet/skullcap,
			"无"
		)
		var/helmchoice = input(H, "选择你的头盔。", "整备头盔") as anything in helmets
		if(helmchoice != "无")
			head = helmets[helmchoice]
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/chain
	backr = /obj/item/storage/backpack/rogue/satchel
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	beltr = /obj/item/quiver/bolts
	beltl = /obj/item/rogueweapon/mace/cudgel
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	ferentia_locality(H)
	H.merctype = 17

/datum/advclass/mercenary/ferentia/longbowman
	name = "长弓手"
	tutorial = "你自幼便在林间持弓猎兽，对森林的熟悉程度不下于你对野生赛加羚要害的了解。在佣兵行会里，把土匪看成两条腿的赛加羚并不算难。"
	outfit = /datum/outfit/job/roguetown/mercenary/ferentia_longbowman
	traits_applied = list(TRAIT_OUTDOORSMAN, TRAIT_WOODSMAN, TRAIT_SURVIVAL_EXPERT) //Warden at home
	subclass_stats = list( //Minus three weighted stats but they get woodsman to specialize them in being forest battlers, maybe try and get hired by the wardens pal
		STATKEY_PER = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/slings = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE, //Miscellaneous survivalist flavor skills
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
	)
	extra_context = "该分支会在所选武器上获得老练级熟练，无论你选的是斧还是匕首。此外，此分支的基础属性略低，以平衡 Woodsman 特质在满足条件时带来的更高总体强度。"

/datum/outfit/job/roguetown/mercenary/ferentia_longbowman/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你自幼便在林间持弓猎兽，对森林的熟悉程度不下于你对野生赛加羚要害的了解。在佣兵行会里，把土匪看成两条腿的赛加羚并不算难。"))
	if(H.mind)
		var/weapons = list("斧", "匕首")
		var/weapon_choice = input(H, "选择你的武器。", "整备武装") as anything in weapons
		switch(weapon_choice)
			if("斧")
				r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/pick
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("匕首")
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
				beltl = /obj/item/rogueweapon/scabbard/sheath
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	belt = /obj/item/storage/belt/rogue/leather
	head = /obj/item/clothing/head/roguetown/roguehood/reinforced
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/angle
	backr = /obj/item/storage/backpack/rogue/satchel
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
	beltr = /obj/item/quiver/arrows
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	ferentia_locality(H)
	H.merctype = 17
