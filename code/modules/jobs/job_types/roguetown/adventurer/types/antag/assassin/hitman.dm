/datum/advclass/assassin_hitman
	name = "刺客 - 职业杀手"
	tutorial = "你可不是什么街头混混或乡野粗汉。你钻研这门营生已有多年，甚至数十年之久。你的本事？便是融入任何地方，耐心等目标落单，然后干净利落地下手。毕竟，死人是不会开口的。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/assassin/hitman
	category_tags = list(CTAG_ASSASSIN)
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_BLACKBAGGER)	// Agent (15)47 - Lets you use the blackbag and garrote you
	// Weighted 14
	subclass_stats = list(
		STATKEY_PER = 1,
		STATKEY_SPD = 2,
		STATKEY_STR = 1,
		STATKEY_WIL = 2,
		STATKEY_CON = 2,
		STATKEY_INT = 1,
		STATKEY_LCK = 2,	//Bit quirky but should be good for them with maces etc.
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,			// Main weapon is going to be their garrote but maces are a good backup. (Cudgel prob)
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,		// GRAB HEEEE!!!
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,		// Viable to punch shit or use brass-knuckles as a backup.
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,	// Niche but I guess incase they get a ranged weapon on-hand.
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/assassin/hitman/pre_equip(mob/living/carbon/human/H)
	..()
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
					/obj/item/flashlight/flare/torch/lantern/prelit = 1,
					/obj/item/lockpickring/mundane = 1,
					/obj/item/clothing/head/inqarticles/blackbag = 1,
					/obj/item/inqarticles/garrote = 1,
					)
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	head = /obj/item/clothing/head/roguetown/helmet/kettle
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	backl = /obj/item/rogueweapon/mace/cudgel
	beltl = /obj/item/rogueweapon/knuckles

	if(!istype(H.patron, /datum/patron/inhumen/graggar))
		var/inputty = input(H, "你要将自己的信仰改为 格拉加 吗？", "兽吼回荡", "否") as anything in list("是", "否")
		if(inputty == "是")
			to_chat(H, span_warning("我先前侍奉的神明已弃我而去……如今，格拉加 才是我的新主人。"))
			H.set_patron(/datum/patron/inhumen/graggar)
