// modular_z121 自定义佣兵子职业：火枪手
// 仅在 modular_z121 内实现，不改动主线佣兵职业文件。

/datum/advclass/z121_musketeer
	name = "火枪手"
	tutorial = "你是一名格伦泽尔霍夫特火枪手，手持一支出自格伦泽尔霍夫特攻城铁匠之手的手炮。这是一根以火药驱动弹丸的铁制管械，沉重而可靠。你能够在短距离内锁定敌人，用炽热的铅丸撕开他们的护甲。\n在这个时代，见过火器的人仍然不算多，而能够熟练使用它的人更是稀少。你无疑是佣兵行会中最罕见的存在之一。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/z121_musketeer
	category_tags = list(CTAG_MERCENARY)
	class_select_category = CLASS_CAT_GRENZELHOFT
	subclass_social_rank = SOCIAL_RANK_PEASANT
	cmode_music = 'sound/music/combat_grenzelhoft.ogg'
	// subclass_languages 会通过 grant_language() 追加到角色现有语言中，因此这里是额外掌握格伦泽尔霍夫特帝国语。
	subclass_languages = list(/datum/language/grenzelhoftian)
	traits_applied = list(
		TRAIT_STEELHEARTED,
		TRAIT_FUSILIER,
		TRAIT_DODGEEXPERT,
	)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
		STATKEY_STR = 1,
		STATKEY_CON = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/firearms = SKILL_LEVEL_MASTER,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		// 实测 Novice 下火枪手仍可能表现为不识字，这里上调到 Apprentice 以确保稳定识字。
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
	)
	extra_context = "拥有铁心、火枪手与闪避大师；精通火器，兼具军刀近战与追踪能力，是佣兵-Grenzelhoft 旗下极为罕见的火器专家。"

/datum/outfit/job/roguetown/mercenary/z121_musketeer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是一名格伦泽尔霍夫特火枪手，手持一支出自格伦泽尔霍夫特攻城铁匠之手的手炮。这是一根以火药驱动弹丸的铁制管械，沉重而可靠。你能够在短距离内锁定敌人，用炽热的铅丸撕开他们的护甲。"))

	// 以现有火枪手为底稿，按需求补成 Grenzelhoft 佣兵页签下的成型火器佣兵。
	r_hand = /obj/item/gun/ballistic/firearm/handgonne
	// 保留手炮在主手，军刀挂到另一侧背位，避免开局把火枪替换掉。
	backr = /obj/item/rogueweapon/sword/sabre
	neck = /obj/item/clothing/neck/roguetown/gorget
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/fencer
	cloak = /obj/item/clothing/cloak/stabard/grenzelhoft
	head = /obj/item/clothing/head/roguetown/grenzelhofthat
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
	shoes = /obj/item/clothing/shoes/roguetown/boots/grenzelhoft
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel/black
	beltl = /obj/item/quiver/bullet/lead
	beltr = /obj/item/powderflask
	// 沿用佣兵钥匙、钱袋与野外补给，保证职业一出生就能独立作战。
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
	)
	// 再补一次识字等级，避免职业初始化链上的其他流程导致火枪手进游戏后无法读字。
	H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_APPRENTICE, TRUE)
	H.merctype = 7
