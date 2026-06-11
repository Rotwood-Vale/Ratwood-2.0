/datum/advclass/mercenary/crocs // formerly Anthrax.dm
	name = "Crocs de l'araignee 骑手"
	tutorial = "Crocs de l'araignee，直译即为“蛛牙”，是一支赫赫有名的雇佣团体，擅使刀剑、长鞭与坐骑，常受雇于庞大的卓尔地下城群，偶尔也会在地表活动。蛛牙之人因嗜战、残虐，以及驾驭蛛形坐骑的本领而恶名昭彰；在 普赛多尼亚，他们称得上是最凶悍、也最残酷的一批战士。黑暗精灵说到底只真正忠于自己与自身利益，这也使他们意外地成了务实而直白的佣兵，只要价钱合适，又能服务于他们更高的野心，卓尔便什么活都肯接。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/elf/dark,
		/datum/species/human/halfelf, // Because half-drows are half-elves, guh.
	)
	outfit = /datum/outfit/job/roguetown/mercenary/crocs
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_MERCENARY)

	cmode_music = 'sound/music/combat_delf.ogg'

	traits_applied = list(TRAIT_DARKVISION, TRAIT_MEDIUMARMOR, TRAIT_EQUESTRIAN)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 1,
	)

	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN, 
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,

	)
	extra_context = "该分支仅限黑暗精灵使用。"
	


/datum/outfit/job/roguetown/mercenary/crocs/pre_equip(mob/living/carbon/human/H)
	..()
	has_loadout = TRUE
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants
	backl = /obj/item/storage/backpack/rogue/satchel/black
	head = /obj/item/clothing/neck/roguetown/chaincoif/full/black
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1, 
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1, 
		/obj/item/rogueweapon/huntingknife/idagger/steel/dirk = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/shadowplate
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/shadowrobe
	gloves = /obj/item/clothing/gloves/roguetown/plate/shadowgauntlets
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	mask = /obj/item/clothing/mask/rogue/facemask/shadowfacemask
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	backr = /obj/item/rogueweapon/shield/tower/spidershield
	beltl = /obj/item/rope/chain
	
	
	if(H.gender == FEMALE)
		ADD_TRAIT(H, TRAIT_DEATHBYSNUSNU, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NUTCRACKER, TRAIT_GENERIC) // female drow have a certain stereotype
	
	if(H.gender == MALE)
		H.change_stat(STATKEY_STR, -1)
		H.change_stat(STATKEY_LCK, 1) 

	if(H.age == AGE_OLD)
		ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC) // YEARS of experience
	

	H.merctype = 15

/datum/outfit/job/roguetown/mercenary/crocs/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/riding = list("我是蛛骑手", "我是步战兵")
	var/ridingchoice = input(H, "选择你的路数。", "战斗方式") as anything in riding
	switch(ridingchoice)
		if("我是蛛骑手")
			H.put_in_hands(new /obj/item/bait/spider, TRUE)
		if("我是步战兵")
			H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
	var/weapons = list("马刀","长鞭")
	var/weapon_choice = input(H, "选择你的武器。", "你如何杀敌？") as anything in weapons
	switch(weapon_choice)
		if("马刀")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_R, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/sabre/stalker, TRUE)
		if("长鞭")
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/whip/spiderwhip, SLOT_BELT_R, TRUE)

/datum/advclass/mercenary/crocsass
	name = "Crocs de l'araignee 刺客"
	tutorial = "Crocs de l'araignee，直译即为“蛛牙”，是一支赫赫有名的雇佣团体，擅使刀剑、长鞭与坐骑，常受雇于庞大的卓尔地下城群，偶尔也会在地表活动。蛛牙之人因嗜战、残虐，以及驾驭蛛形坐骑的本领而恶名昭彰；在 普赛多尼亚，他们称得上是最凶悍、也最残酷的一批战士。黑暗精灵说到底只真正忠于自己与自身利益，这也使他们意外地成了务实而直白的佣兵，只要价钱合适，又能服务于他们更高的野心，卓尔便什么活都肯接。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/elf/dark,
		/datum/species/human/halfelf, // Because half-drows are half-elves, guh.
	)
	outfit = /datum/outfit/job/roguetown/mercenary/crocs
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_MERCENARY)

	cmode_music = 'sound/music/combat_delf.ogg'
	outfit = /datum/outfit/job/roguetown/mercenary/crocsass
	traits_applied = list(TRAIT_DARKVISION, TRAIT_DODGEEXPERT, TRAIT_EQUESTRIAN)
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 1,
		STATKEY_SPD = 3,
		STATKEY_STR = -1
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN, 
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN, 
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)
	
/datum/outfit/job/roguetown/mercenary/crocsass/pre_equip(mob/living/carbon/human/H)
	..()
	has_loadout = TRUE
	shirt = /obj/item/clothing/suit/roguetown/shirt/shadowshirt/elflock
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/shadowrobe
	cloak = /obj/item/clothing/cloak/shadowcloak
	gloves = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/elflock
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	mask = /obj/item/clothing/mask/rogue/shepherd/shadowmask/delf
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	backl = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1, 
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1, 
		/obj/item/rogueweapon/huntingknife/idagger/steel/dirk = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/lockpick = 1
		)
	head = /obj/item/clothing/neck/roguetown/chaincoif/full/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants
	beltl = /obj/item/rope/chain
	
	if(H.gender == FEMALE)
		ADD_TRAIT(H, TRAIT_DEATHBYSNUSNU, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NUTCRACKER, TRAIT_GENERIC) // female drow have a certain stereotype
	
	if(H.gender == MALE)
		H.change_stat(STATKEY_STR, -1)
		H.change_stat(STATKEY_LCK, 1) 

	if(H.age == AGE_OLD)
		ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC) // YEARS of experience
	
	H.merctype = 15
/datum/outfit/job/roguetown/mercenary/crocsass/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/riding = list("我是蛛骑手", "我是步战兵")
	var/ridingchoice = input(H, "选择你的路数。", "战斗方式") as anything in riding
	switch(ridingchoice)
		if("我是蛛骑手")
			H.put_in_hands(new /obj/item/bait/spider, TRUE)
		if("我是步战兵")
			H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
	var/weapons = list("蛛弩","短弓","双匕")
	var/weapon_choice = input(H, "选择你的武器。", "你如何杀敌？") as anything in weapons
	switch(weapon_choice)
		if("蛛弩")
			H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/bolts/, SLOT_BACK_R, TRUE)
		if("短弓")
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/bow, SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/poisonarrows/, SLOT_BELT_R, TRUE)
		if("双匕")
			ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sheath, SLOT_BELT_R, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel/dirk, TRUE)
