/datum/advclass/trader/brewer
	name = "酒商"
	tutorial = "你靠贩卖来自世界各地的进口酒水赚钱，不过你自己也并非不懂这门手艺，真到急用时也能亲手酿出自己的麦酒。你甚至还有造一台蒸馏器所需的设备与门道。"
	outfit = /datum/outfit/job/roguetown/adventurer/brewer
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_CICERONE, TRAIT_HOMESTEAD_EXPERT)
	class_select_category = CLASS_CAT_TRADER
	category_tags = list(CTAG_PILGRIM, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_STR = 1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/engineering = SKILL_LEVEL_NOVICE, // CBT to make a copper distillery
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/brewer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你靠贩卖来自世界各地的进口酒水赚钱，不过你自己也并非不懂这门手艺，真到急用时也能亲手酿出自己的麦酒。你甚至还有造一台蒸馏器所需的设备与门道。"))
	mask = /obj/item/clothing/mask/rogue/ragmask/black
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	pants = /obj/item/clothing/under/roguetown/tights/black
	cloak = /obj/item/clothing/suit/roguetown/armor/longcoat
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/red
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/rogueweapon/mace/cudgel
	beltl = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/beer/gronnmead = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/voddena = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/blackgoat = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/elfred = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/elfblue = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/ingot/copper = 2,
		/obj/item/roguegear = 1,
		/obj/item/bottle_kit = 1,
		/obj/item/recipe_book/survival = 1)
