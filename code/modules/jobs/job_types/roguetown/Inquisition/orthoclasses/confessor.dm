//Combination miraclist-ranged-melee.
//Capable of torture and intended for espionage.
/datum/advclass/confessor
	name = "告解官"
	tutorial = "你是 普赛顿 的猎手，在潜行与侦缉之道上无人能及。\
	没有哪个嫌犯强大到无法调查，没有哪个房间戒备森严到无法潜入，也没有哪处弱点隐秘到无法利用。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/confessor
	category_tags = list(CTAG_INQUISITION)
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'sound/music/cmode/antag/combat_deadlyshadows.ogg'
	traits_applied = list(
		TRAIT_DODGEEXPERT,
		TRAIT_BLACKBAGGER,
		TRAIT_PERFECT_TRACKER,
		TRAIT_SLEUTH,
		TRAIT_PURITAN_ADVENTURER,//For fluff.
	)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_SPD = 2,
		STATKEY_WIL = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN, //Should rely on the seizing garrote to properly subdue foes.
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN, //Ensures that captured individuals are less likely to die, if subdued with harsher force.
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/stealing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"《Psydon 圣典》" = /obj/item/book/rogue/bibble/psy
	)

/datum/outfit/job/roguetown/confessor
	job_bitflag = BITFLAG_HOLY_WARRIOR

/datum/outfit/job/roguetown/confessor/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	H.verbs |= /mob/living/carbon/human/proc/faith_test
	H.verbs |= /mob/living/carbon/human/proc/torture_victim
	if(H.mind)
		var/weapons = list("受祝 Psydonic 匕首", "Psydonic 手锤", "Psydonic 短剑")
		var/weapon_choice = input(H,"选择你的武器。", "执起 普赛顿 的兵刃。") as anything in weapons
		switch(weapon_choice)
			if("受祝 Psydonic 匕首")
				l_hand = /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger
				r_hand = /obj/item/rogueweapon/scabbard/sheath
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, 4, TRUE)
			if("Psydonic 手锤")
				l_hand = /obj/item/rogueweapon/mace/cudgel/psy
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
			if("Psydonic 短剑")
				l_hand = /obj/item/rogueweapon/sword/short/psy
				r_hand = /obj/item/rogueweapon/scabbard/sword
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		var/quivers = list("弩矢 - 钢尖", "裂甲弩矢 - 银尖，伤害减半")
		var/bolt_choice = input(H,"选择你的弹药。", "执起 普赛顿 的飞矢。") as anything in quivers
		switch(bolt_choice)
			if("弩矢 - 钢尖")
				beltl = /obj/item/quiver/bolts
			if("裂甲弩矢 - 银尖，伤害减半")
				beltl = /obj/item/quiver/holybolts

	head = /obj/item/clothing/head/roguetown/roguehood/psydon/confessor
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/confessor
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
	cloak = /obj/item/storage/backpack/rogue/satchel/beltpack
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver
	gloves = /obj/item/clothing/gloves/roguetown/otavan/psygloves
	neck = /obj/item/clothing/neck/roguetown/gorget
	backr = /obj/item/storage/backpack/rogue/satchel/otavan
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/psydon
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	mask = /obj/item/clothing/mask/rogue/facemask/steel/confessor
	id = /obj/item/clothing/ring/signet/silver
	backpack_contents = list(
		/obj/item/roguekey/inquisition = 1,
		/obj/item/rope/inqarticles/inquirycord = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/clothing/head/inqarticles/blackbag = 1,
		/obj/item/inqarticles/garrote = 1,
		/obj/item/grapplinghook = 1,
		/obj/item/paper/inqslip/arrival/ortho = 1
		)

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)	//Capped to T2 miracles.
