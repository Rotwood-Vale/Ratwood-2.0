/datum/advclass/mercenary/routier
	name = "奥塔瓦 巡战骑士"
	tutorial = "巡战骑士 是一支令人生畏的 奥塔瓦 佣兵团，由出身贵族家门的骑士兄弟组成，为那些想在太平年月里也谋取利益的领主效命。整个 奥塔瓦 贵族阶层，乃至部分神职者，都热切盼着听闻你的功绩；他们期待你坚忍不屈，成为其信仰的斗士，彰显贵族真正的价值。你做得到吗？"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = NON_DWARVEN_RACE_TYPES
	outfit = /datum/outfit/job/roguetown/mercenary/routier
	subclass_languages = list(/datum/language/otavan)
	class_select_category = CLASS_CAT_OTAVA
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_NOBLE)
	cmode_music = 'sound/music/combat_routier.ogg'
	subclass_stats = list(
		STATKEY_CON = 4,
		STATKEY_WIL = 2,
		STATKEY_STR = 2,
		STATKEY_PER = 1,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/routier/pre_equip(mob/living/carbon/human/H)
	..()

	// CLASS ARCHETYPES
	H.adjust_blindness(-3)
	var/classes = list("剑士","持钉锤者","链枷手", "徒步枪骑兵")
	if(H.mind)
		var/classchoice = input(H, "选择你的战斗流派。", "可选流派") as anything in classes
		H.set_blindness(0)
		to_chat(H, span_warning("你是一名 奥塔瓦 骑士，对自己选定的兵器早已驾轻就熟。"))
		switch(classchoice)
			if("剑士")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sword/noble
				l_hand = /obj/item/rogueweapon/sword/short/falchion
			if("持钉锤者")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
				beltl = /obj/item/rogueweapon/mace/steel/morningstar
			if("链枷手")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)
				beltl = /obj/item/rogueweapon/flail/sflail
			if("徒步枪骑兵")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
				r_hand = /obj/item/rogueweapon/spear/lance
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	neck = /obj/item/clothing/neck/roguetown/fencerguard
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
	head = /obj/item/clothing/head/roguetown/helmet/otavan
	armor = /obj/item/clothing/suit/roguetown/armor/plate/otavan
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	shoes = /obj/item/clothing/shoes/roguetown/boots/otavan
	gloves = /obj/item/clothing/gloves/roguetown/otavan
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backl = /obj/item/rogueweapon/shield/tower/metal
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1
		)
	H.merctype = 10
