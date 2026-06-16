// Melee goon. STR and martial setup.
/datum/advclass/janissary/footman
	name = "耶尼切里步兵"
	tutorial = "你是苏丹扈从的一员。确保苏丹及其臣民的安全，保卫当权者免受外界恐怖之物的侵害，守护苏丹国的存续。"
	outfit = /datum/outfit/job/roguetown/janissary/footman

	category_tags = list(CTAG_JANISSARY)
	// traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,// seems kinda lame but remember guardsman bonus!!
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/slings = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/janissary/footman/pre_equip(mob/living/carbon/human/H)
	..()

	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/janissary
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/zyb
	head = /obj/item/clothing/head/roguetown/helmet/janissaryhelm
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	gloves = /obj/item/clothing/gloves/roguetown/chain
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt
	beltl = /obj/item/rogueweapon/whip
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/guardcastle = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("弯刀与盾","战锤与盾","巴迪什斧","大锤——+力量/体质，-速度/感知/智力")
		var/weapon_choice = input(H, "选择你的武器：", "拿起武器") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("弯刀与盾")
				r_hand = /obj/item/rogueweapon/sword/short/falchion
				beltr = /obj/item/rogueweapon/scabbard/sword
				backl = /obj/item/rogueweapon/shield/iron/zybantine
			if("战锤与盾")
				r_hand = /obj/item/rogueweapon/mace/warhammer
				backl = /obj/item/rogueweapon/shield/iron/zybantine
			if("巴迪什斧")
				r_hand = /obj/item/rogueweapon/halberd/bardiche
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("大锤——+力量/体质，-速度/感知/智力")
				r_hand = /obj/item/rogueweapon/mace/maul
				l_hand = /obj/item/reagent_containers/glass/bottle/rogue/beer
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.change_stat(STATKEY_STR, 1)
				H.change_stat(STATKEY_CON, 1)
				H.change_stat(STATKEY_SPD, -1)
				H.change_stat(STATKEY_PER, -1)
				H.change_stat(STATKEY_INT, -1)
	H.verbs |= /mob/proc/haltyell
