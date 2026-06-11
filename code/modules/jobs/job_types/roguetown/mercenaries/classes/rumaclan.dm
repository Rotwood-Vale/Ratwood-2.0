/datum/advclass/mercenary/rumaclan
	name = "流马氏族军人"
	tutorial = "你是一名出身 风郡裔 异乡武团的剑士。流马氏族是被 信义 王朝放逐的流亡者，世人相信他们曾与当时的叛军有所牵连。为避祸患，整个氏族选择远走他乡。他们并非一支严整有序的军队，而更像是一群经验老到的战士松散聚成的团体。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = NON_DWARVEN_RACE_TYPES //no dwarf sprites
	outfit = /datum/outfit/job/roguetown/mercenary/rumaclan
	subclass_languages = list(/datum/language/kazengunese)
	class_select_category = CLASS_CAT_KAZENGUN
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_CRITICAL_RESISTANCE, TRAIT_HARDDISMEMBER, TRAIT_NOPAINSTUN)
	cmode_music = 'sound/music/combat_Kazengun_Runaway_Chariot.ogg'
	subclass_stats = list(
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_STR = 2,
		STATKEY_PER = 1,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	)
	extra_context = "该分支禁止矮人选择。"

/datum/outfit/job/roguetown/mercenary/rumaclan/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是氏族中的剑士，刀剑之艺罕有敌手。只要报酬够好，你便不介意为了自己、为了领头的 首将，或为了整个氏族去接下大多数差事。"))
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/scabbard/sword/kazengun/steel
	beltl = /obj/item/rogueweapon/sword/sabre/mulyeog/rumahench
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/easttats
	cloak = /obj/item/clothing/cloak/eastcloak1
	armor = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
	shoes = /obj/item/clothing/shoes/roguetown/armor/rumaclan
	gloves = /obj/item/clothing/gloves/roguetown/eastgloves2
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		)
	H.merctype = 9

/datum/advclass/mercenary/rumaclan/sasu
	name = "流马氏族射手"
	tutorial = "你是一名出身 风郡裔 异乡武团的弓手。流马氏族是被 信义 王朝放逐的流亡者，世人相信他们曾与当时的叛军有所牵连。为避祸患，整个氏族选择远走他乡。他们并非一支严整有序的军队，而更像是一群经验老到的战士松散聚成的团体。"
	outfit = /datum/outfit/job/roguetown/mercenary/rumaclan_sasu
	subclass_stats = list(
		STATKEY_SPD = 4,
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_STR = -1,
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/rumaclan_sasu/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_blindness(0)
	to_chat(H, span_warning("你是氏族中的弓手，弓艺无双。只要报酬够好，你便不介意为了自己、为了领头的 首将，或为了整个氏族去接下大多数差事。"))
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/quiver/arrows
	beltl = /obj/item/flashlight/flare/torch/lantern
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/easttats
	cloak = /obj/item/clothing/cloak/eastcloak1
	armor = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
	shoes = /obj/item/clothing/shoes/roguetown/armor/rumaclan
	gloves = /obj/item/clothing/gloves/roguetown/eastgloves2
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/kazengun = 1,
		/obj/item/rogueweapon/scabbard/sheath/kazengun = 1,
		)
	H.merctype = 9
