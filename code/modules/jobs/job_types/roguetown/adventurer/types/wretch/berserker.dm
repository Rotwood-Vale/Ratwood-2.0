/datum/advclass/wretch/berserker
	name = "狂战士"
	tutorial = "你是因残暴而令人畏惧的战士，执意将自己的力量用于满足私欲。强权即公理，而你便是这句老话的活生生写照。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/berserker
	cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'
	class_select_category = CLASS_CAT_WARRIOR
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_STRONGBITE, TRAIT_CRITICAL_RESISTANCE, TRAIT_NOPAINSTUN)
	// Literally same stat spread as Atgervi Shaman
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_INT = -1,
		STATKEY_PER = -1
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/wretch/berserker/pre_equip(mob/living/carbon/human/H)
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	backr = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/hip/headhook //Standard iron version. More-so for style than substance.
	neck = /obj/item/clothing/neck/roguetown/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/combat = 1, //Steel variant of the hunting knife. Pseudoantagonist-tier, plus an avenue to hack limbs with.
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	if(H.mind)
		var/weapons = list("武修徒手","拳刃","指虎","冲拳匕首","战斧","巨锤","法尔克斯弯刃")
		var/weapon_choice = input(H, "选择你的武器。", "掏出他们的内脏。") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("武修徒手")
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
				ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
			if("拳刃")
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
				beltr = /obj/item/rogueweapon/katar
			if("指虎")
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
				beltr = /obj/item/rogueweapon/knuckles
			if("冲拳匕首")
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
				r_hand = /obj/item/rogueweapon/katar/punchdagger
			if("战斧")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/rogueweapon/stoneaxe/battle
			if("巨锤")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/mace/goden/steel
			if("法尔克斯弯刃")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/falx
		var/helmets = list("狂战士狼颅盆盔","钢锅盔加荒卫面具")
		var/helmet_choice = input(H, "选择你的头盔。", "武装自己。") as anything in helmets
		switch(helmet_choice)
			if("狂战士狼颅盆盔")
				head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker //Pseudoantagonistic-exclusive. Light AC with an on-wear trait for HELMBITING.
			if("钢锅盔加荒卫面具")
				head = /obj/item/clothing/head/roguetown/helmet/kettle
				mask = /obj/item/clothing/mask/rogue/wildguard
		wretch_select_bounty(H)
