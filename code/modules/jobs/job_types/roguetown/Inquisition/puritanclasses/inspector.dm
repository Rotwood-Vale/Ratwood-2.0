//The Inspector. Jack of all trades, master of none.
//Respectable assortment of skills, stats, and equipment; good at both subterfuge and combat.
//Functions very well on their own, and even better with a full sect.
/datum/advclass/puritan/inspector
	name = "监察官"
	tutorial = "你们既是调查者，也是外交使，常从那些在多种技艺上展露才能的告解官中被拣选而出。要推动正统教会的谕令，往往只需一次精准出手；至于是靠外交家的辞锋，还是靠刺剑的锋尖，那就由你自己决定。"
	outfit = /datum/outfit/job/roguetown/puritan/inspector
	subclass_languages = list(/datum/language/otavan)
	category_tags = list(CTAG_PURITAN)
	traits_applied = list(
		TRAIT_STEELHEARTED,
		TRAIT_DODGEEXPERT,
		TRAIT_MEDIUMARMOR,
		TRAIT_BLACKBAGGER,
		TRAIT_SILVER_BLESSED,
		TRAIT_INQUISITION,
		TRAIT_PERFECT_TRACKER,
		TRAIT_SLEUTH,
		TRAIT_PURITAN,
		TRAIT_OUTLANDER
		)
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_CON = 2,
		STATKEY_SPD = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 1
	)
	subclass_skills = list(
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"《Psydon 圣典》" = /obj/item/book/rogue/bibble/psy
	)

/datum/outfit/job/roguetown/puritan/inspector/pre_equip(mob/living/carbon/human/H)
	..()
	has_loadout = TRUE
	H.verbs |= /mob/living/carbon/human/proc/faith_test
	H.verbs |= /mob/living/carbon/human/proc/torture_victim
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1) //Capped to T2 miracles.
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/psydon
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	shoes = /obj/item/clothing/shoes/roguetown/boots/otavan/inqboots
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	backr =  /obj/item/storage/backpack/rogue/satchel/otavan
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
	head = /obj/item/clothing/head/roguetown/inqhat
	mask = /obj/item/clothing/mask/rogue/spectacles/inq/spawnpair
	gloves = /obj/item/clothing/gloves/roguetown/otavan/psygloves
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver
	id = /obj/item/clothing/ring/signet/silver
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat
	backpack_contents = list(
		/obj/item/storage/keyring/puritan = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger,
		/obj/item/clothing/head/inqarticles/blackbag = 1,
		/obj/item/inqarticles/garrote = 1,
		/obj/item/rope/inqarticles/inquirycord = 1,
		/obj/item/grapplinghook = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/paper/inqslip/arrival/inq = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)


/datum/outfit/job/roguetown/puritan/inspector/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Psydonic 长剑", "Psydonic 刺剑", "Daybreak（鞭）", "Stigmata（长戟）", "Eucharist（刺剑）")
	var/weapon_choice = input(H,"亮出你的银兵。", "以祂之名执兵。") as anything in weapons
	switch(weapon_choice)
		if("Psydonic 长剑")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/psysword/preblessed(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
		if("Psydonic 刺剑")
			H.put_in_hands(new /obj/item/rogueweapon/sword/rapier/psy/preblessed(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
		if("Daybreak（鞭）")
			H.put_in_hands(new /obj/item/rogueweapon/whip/antique/psywhip(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 5, TRUE)
		if("Stigmata（长戟）")
			H.put_in_hands(new /obj/item/rogueweapon/halberd/psyhalberd/relic(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 5, TRUE)
		if("Eucharist（刺剑）")
			H.put_in_hands(new /obj/item/rogueweapon/sword/rapier/psy/relic(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
	var/quivers = list("弩矢 - 钢尖", "裂甲弩矢 - 银尖，伤害减半")
	var/bolt_choice = input(H,"选择你的弹药。", "执起 普赛顿 的飞矢。") as anything in quivers
	switch(bolt_choice)
		if("弩矢 - 钢尖")
			H.equip_to_slot_or_del(new /obj/item/quiver/bolts, SLOT_BELT_R, TRUE)
		if("裂甲弩矢 - 银尖，伤害减半")
			H.equip_to_slot_or_del(new /obj/item/quiver/holybolts, SLOT_BELT_R, TRUE)
