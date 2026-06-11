//A subtype of the melee goon. You're given the stunmace, which allows access off of Rockhill.
//Additionally, one of the rarer weapon types, the maul, as a choice.
//Expert unarmed to top it off. Make sah proud.
//In exchange, you're slower. Much slower. Both in matters of speed or otherwise.
/datum/advclass/manorguard/gormless
	name = "缉捕兵"
	tutorial = "算不上真正的行家，也算不上标准的军士。更像是被塞了把锤子、几件淘汰装备，就被赶去迎敌的粗人。\
	可你偏偏证明了自己并非一次性消耗品，而是个靠得住的人。多数人可做不到这点。"
	outfit = /datum/outfit/job/roguetown/manorguard/gormless

	category_tags = list(CTAG_MENATARMS)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(//This is more like +4/+2/+3/-2/-1
		STATKEY_CON = 3,//+1 from guard bonus, so +4 in town.
		STATKEY_STR = 2,
		STATKEY_WIL = 2,//+1 from guard bonus, so +3 in town.
		STATKEY_INT = -2,
		STATKEY_SPD = -2,//+1 from guard bonus, so -1 in town.
	)
	subclass_skills = list(//You get no reading, m'lord. Go smack a dummy with a book, if you don't like soul.
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/manorguard/gormless/pre_equip(mob/living/carbon/human/H)
	..()

	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	wrists = /obj/item/clothing/wrists/roguetown/splintarms/iron
	pants = /obj/item/clothing/under/roguetown/splintlegs/iron
	beltl = /obj/item/rogueweapon/mace/cudgel
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("震慑钉头锤与盾","大槌，需至少 14 力量")
		var/weapon_choice = input(H, "选择你的武器。", "拿起武器") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("震慑钉头锤与盾")
				r_hand = /obj/item/rogueweapon/mace/stunmace
				backl = /obj/item/rogueweapon/shield/iron
			if("大槌，需至少 14 力量")
				r_hand = /obj/item/rogueweapon/mace/maul
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.change_stat(STATKEY_STR, 1) /// so even without a strength-specific statpack, you can at least use the weapon. With one, it allows great maul just like on city guard.
				H.change_stat(STATKEY_SPD, -1)
				H.change_stat(STATKEY_INT, -1)

	backpack_contents = list(//Iron dagger and ale instead of red.
		/obj/item/rogueweapon/huntingknife/idagger = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/guardcastle = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/beer = 1,
		)

	H.verbs |= /mob/proc/haltyell

//All iron exclusive, as with the armour.
	if(H.mind)
		var/helmets = list(
		"锅盔" 	= /obj/item/clothing/head/roguetown/helmet/kettle/iron,
		"萨莱特盔"		= /obj/item/clothing/head/roguetown/helmet/sallet/iron,
		"角盔" 	= /obj/item/clothing/head/roguetown/helmet/horned,
		"护顶盔"			= /obj/item/clothing/head/roguetown/helmet/skullcap,
		"无"
		)
		var/helmchoice = input(H, "选择你的头盔。", "戴上头盔") as anything in helmets
		if(helmchoice != "无")
			head = helmets[helmchoice]
