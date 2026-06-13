// modular_z121 自定义冒险者子职业：魔弓手
// 仅在 modular_z121 内挂入 Adventurer 的 Mage 分栏，不改动主线职业定义。

/datum/advclass/z121_arcane_archer
	name = "魔弓手"
	tutorial = "你来自一个强迫你学习魔法的世家，尽管学习魔法占用了你大多数时间，但仍有闲暇的时间去练习你最喜欢的弓术，你的智慧发现了魔法的新机缘，但你却再也无法进一步改良它的威力。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/z121_arcane_archer
	category_tags = list(CTAG_ADVENTURER)
	class_select_category = CLASS_CAT_MAGE
	subclass_social_rank = SOCIAL_RANK_PEASANT
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	traits_applied = list(
		TRAIT_MAGEARMOR,
		TRAIT_DODGEEXPERT,
		TRAIT_ARCYNE_T2,
	)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_INT = 2,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
	)
	// 给少量法术点以匹配“学徒级奥术训练”，只够学习基础战斗法术，不直接发强力成型法术。
	subclass_spellpoints = 10
	extra_context = "拥有魔法障壁、闪避专家与奥术训练（学徒）；擅长弓术与基础奥术，但不会直接获得现成战斗法术。"

/datum/outfit/job/roguetown/adventurer/z121_arcane_archer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你来自一个强迫你学习魔法的世家，尽管学习魔法占用了你大多数时间，但仍有闲暇的时间去练习你最喜欢的弓术，你的智慧发现了魔法的新机缘，但你却再也无法进一步改良它的威力。"))

	// 按需求固定发放轻装弓术与学徒奥术混合配置。
	head = /obj/item/clothing/head/roguetown/roguehood/random
	cloak = /obj/item/clothing/cloak/raincloak/blue
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	backr = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/huntingknife/idagger
	beltr = /obj/item/quiver/magic
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots

	// 挎包内只放题述指定的小件，避免超出用户给定的开局内容。
	backpack_contents = list(
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/chalk = 1,
		/obj/item/flashlight/flare/torch = 1,
	)
