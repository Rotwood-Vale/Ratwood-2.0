//Psydonian templars with decent devotion regen.
//Counting as minor nobles, as 'knights' of the See.
//They get combination setups. The backbone of the Inquisitor's sect.
/datum/advclass/psydoniantemplar // A templar, but for the Inquisition
	name = "裁律骑士"
	tutorial = "你是 普赛顿 的骑士，身披纵棱锁甲，并被赐予施行低阶神迹的能力。\
	虽然无缘更高阶的奇迹与仪式，但你以严整武艺与受祝兵装弥补了这一切。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/psydoniantemplar
	category_tags = list(CTAG_INQUISITION)
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'sound/music/templarofpsydonia.ogg'
	subclass_social_rank = SOCIAL_RANK_MINOR_NOBLE
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_CON = 3,
		STATKEY_STR = 2,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list(
		"《Psydon 圣典》" = /obj/item/book/rogue/bibble/psy
	)

/datum/outfit/job/roguetown/psydoniantemplar
	job_bitflag = BITFLAG_HOLY_WARRIOR

/datum/outfit/job/roguetown/psydoniantemplar/pre_equip(mob/living/carbon/human/H)
	..()
	has_loadout = TRUE
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver
	cloak = /obj/item/clothing/cloak/psydontabard
	gloves = /obj/item/clothing/gloves/roguetown/chain/psydon
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	pants = /obj/item/clothing/under/roguetown/chainlegs
	backr = /obj/item/storage/backpack/rogue/satchel/otavan
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	belt = /obj/item/storage/belt/rogue/leather/black
	id = /obj/item/clothing/ring/signet/silver
	backpack_contents = list(/obj/item/roguekey/inquisition = 1,
	/obj/item/paper/inqslip/arrival/adju = 1,
	/obj/item/storage/belt/rogue/pouch/coins/mid = 1)

	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2) //Higher limit compared to others.
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_retribution)//Rebuke, but blood cost and worse.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_sacrosanctity)//To get your blood back, m'lord.

/datum/outfit/job/roguetown/psydoniantemplar/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/helmets = list("巴布塔盔", "萨莱特盔", "阿米特盔", "桶盔")
	var/helmet_choice = input(H,"选择你的头盔。", "戴上 普赛顿 的圣盔。") as anything in helmets
	switch(helmet_choice)
		if("巴布塔盔")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/psydonbarbute, SLOT_HEAD, TRUE)
		if("萨莱特盔")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/psysallet, SLOT_HEAD, TRUE)
		if("阿米特盔")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm, SLOT_HEAD, TRUE)
		if("桶盔")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/psybucket, SLOT_HEAD, TRUE)

	var/armors = list("锁子甲袍", "胸甲")
	var/armor_choice = input(H, "选择你的护甲。", "披上 普赛顿 的圣衣。") as anything in armors
	switch(armor_choice)
		if("锁子甲袍")
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate, SLOT_ARMOR, TRUE)
		if("胸甲")
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/half/fluted/ornate, SLOT_ARMOR, TRUE)

	var/weapons = list("Psydonic 长剑 + 盾", "Psydonic 战斧 + 盾", "Psydonic 鞭 + 盾",
		"Psydonic 连枷 + 盾", "Psydonic 大钉锤 + 短剑", "Psydonic 长矛 + 手锤", "Psydonic 长柄斧 + 短剑",
		"Psydonic 戟 + 短剑", "Psydonic 巨剑 + 手锤")
	var/weapon_choice = input(H,"选择你的武器。", "执起 普赛顿 的兵刃。") as anything in weapons
	switch(weapon_choice)
		//Typical arms and such.
		if("Psydonic 长剑 + 盾")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/psysword(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal, SLOT_BACK_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		if("Psydonic 战斧 + 盾")
			H.put_in_hands(new /obj/item/rogueweapon/stoneaxe/battle/psyaxe(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal, SLOT_BACK_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
		if("Psydonic 鞭 + 盾")
			H.put_in_hands(new /obj/item/rogueweapon/whip/psywhip_lesser(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal, SLOT_BACK_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)
		if("Psydonic 连枷 + 盾")
			H.put_in_hands(new /obj/item/rogueweapon/flail/sflail/psyflail(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal, SLOT_BACK_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)
		//Polearms and the like.
		if("Psydonic 大钉锤 + 短剑")
			H.put_in_hands(new /obj/item/rogueweapon/mace/goden/psy(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/short/psy(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
		if("Psydonic 长矛 + 手锤")
			H.put_in_hands(new /obj/item/rogueweapon/spear/psyspear(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/mace/cudgel/psy(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
		if("Psydonic 长柄斧 + 短剑")
			H.put_in_hands(new /obj/item/rogueweapon/greataxe/psy(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/short/psy(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
		if("Psydonic 戟 + 短剑")
			H.put_in_hands(new /obj/item/rogueweapon/halberd/psyhalberd(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/short/psy(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
		if("Psydonic 巨剑 + 手锤")
			H.put_in_hands(new /obj/item/rogueweapon/greatsword/psygsword(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/mace/cudgel/psy(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
