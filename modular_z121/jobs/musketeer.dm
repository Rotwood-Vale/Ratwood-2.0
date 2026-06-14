// modular_z121 自定义冒险者子职业：火枪手
// 仅在 modular_z121 内新增，不改动主线 Adventurer 文件。

/datum/advclass/z121_musketeer
	name = "火枪手"
	tutorial = "你是一名格伦泽尔霍夫特火枪手，手持一支出自格伦泽尔霍夫特攻城铁匠之手的手炮。这是一根以火药驱动弹丸的铁制管械，沉重而可靠。你能够在短距离内锁定敌人，用炽热的铅丸撕开他们的护甲。在这个时代，见过火器的人仍然不算多，而能够熟练使用它的人更是稀少。你无疑是佣兵行会中最罕见的存在之一。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/z121_musketeer
	category_tags = list(CTAG_ADVENTURER)
	class_select_category = CLASS_CAT_RANGER
	subclass_social_rank = SOCIAL_RANK_PEASANT
	cmode_music = 'sound/music/combat_grenzelhoft.ogg'
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
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
	)
	extra_context = "拥有铁心、火枪手与闪避大师；精通火器，擅长追踪和短距离点杀，但体魄略逊于普通前线佣兵。"

/datum/outfit/job/roguetown/adventurer/z121_musketeer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是一名格伦泽尔霍夫特火枪手，手持一支出自格伦泽尔霍夫特攻城铁匠之手的手炮。这是一根以火药驱动弹丸的铁制管械，沉重而可靠。你能够在短距离内锁定敌人，用炽热的铅丸撕开他们的护甲。"))

	// 按用户给定清单固定发放火枪手整套装备，不额外改写主线冒险者模板。
	r_hand = /obj/item/gun/ballistic/firearm/handgonne
	l_hand = /obj/item/powderflask
	neck = /obj/item/quiver/bullet/lead
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/fencer
	cloak = /obj/item/clothing/cloak/stabard/grenzelhoft
	head = /obj/item/clothing/head/roguetown/grenzelhofthat
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
	shoes = /obj/item/clothing/shoes/roguetown/boots/grenzelhoft
	wrists = /obj/item/clothing/wrists/roguetown/bracers
