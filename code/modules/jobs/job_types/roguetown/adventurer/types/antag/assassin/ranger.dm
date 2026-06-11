/datum/advclass/assassin_ranger
	name = "刺客 - 猎人"
	tutorial = "你这一生都在追猎最危险的猎物, 那就是凡人。你杀过的恐熊，也比不上那些死在你手下的人。追上你的猎物，宰了那条疯狗，然后拿你的报酬。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/assassin/ranger
	category_tags = list(CTAG_ASSASSIN)
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_WOODWALKER, TRAIT_OUTDOORSMAN)	// Master of the Forest - Tosses them a bone for wilderness chases.
	// Weighted 14
	subclass_stats = list(
		STATKEY_PER = 4,
		STATKEY_SPD = 3,
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,			// Fall-back/melee weapon is using a big ol' axe.
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_MASTER,			//Good ranged weapon options
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/assassin/ranger/pre_equip(mob/living/carbon/human/H)
	..()
	cloak = /obj/item/clothing/cloak/raincloak/red
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/angle
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
					/obj/item/flashlight/flare/torch/lantern/prelit = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1,
					/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
					/obj/item/needle/thorn = 1,
					/obj/item/natural/cloth = 1,
					)
	mask = /obj/item/clothing/mask/rogue/wildguard
	neck = /obj/item/clothing/neck/roguetown/coif
	head = /obj/item/clothing/head/roguetown/helmet/kettle
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	beltr = /obj/item/rogueweapon/stoneaxe/woodcut/wardenpick
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("紫杉长弓","十字弩")
		var/weapon_choice = input(H, "选择你的武器。", "执兵而起") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("紫杉长弓")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_MASTER, TRUE)
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
				beltl = /obj/item/quiver/arrows
			if("十字弩")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_MASTER, TRUE)
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltl = /obj/item/quiver/bolts

	if(!istype(H.patron, /datum/patron/inhumen/graggar))
		var/inputty = input(H, "你要将自己的信仰改为 格拉加 吗？", "兽吼回荡", "否") as anything in list("是", "否")
		if(inputty == "是")
			to_chat(H, span_warning("我先前侍奉的神明已弃我而去……如今，格拉加 才是我的新主人。"))
			H.set_patron(/datum/patron/inhumen/graggar)
