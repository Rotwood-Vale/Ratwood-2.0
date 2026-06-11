/datum/advclass/trader/doomsayer
	name = "末日鼓吹者"
	tutorial = "世界末日要到了！！！至少，你得让客户们相信这一点。当然了，你会在新世界里卖给他们一个安全去处，而且还是由你亲手打造的。"
	outfit = /datum/outfit/job/roguetown/adventurer/doomsayer
	subclass_social_rank = SOCIAL_RANK_PEASANT
	category_tags = list(CTAG_PILGRIM, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	class_select_category = CLASS_CAT_TRADER
	traits_applied = list(TRAIT_PSYCHOSIS, TRAIT_HOMESTEAD_EXPERT)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 1,
		STATKEY_STR = 1,
		STATKEY_CON = 1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/axes = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/doomsayer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("世界末日要到了！！！至少，你得让客户们相信这一点。当然了，你会在新世界里卖给他们一个安全去处，而且还是由你亲手打造的。"))
	head = /obj/item/clothing/head/roguetown/roguehood/black
	mask = /obj/item/clothing/mask/rogue/skullmask
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/black
	belt = /obj/item/storage/belt/rogue/leather/black
	cloak = /obj/item/clothing/cloak/half
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/stoneaxe/woodcut
	backpack_contents = list(
		/obj/item/clothing/neck/roguetown/psicross/silver = 3,
		/obj/item/clothing/neck/roguetown/psicross = 2,
		/obj/item/clothing/neck/roguetown/psicross/wood = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
