
/datum/advclass/heartfelt/retinue/armorer
	name = "赤心 铸甲师"
	tutorial = "你是 赤心 的铸甲师，本该成就一番伟业，却被男爵领的覆灭生生打断。\
	如今故土已成废墟，你望向这片土地，希望能在混乱之中寻得新的使命，或至少一处容身之所。"
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/heartfelt/retinue/armorer
	maximum_possible_slots = 1
	pickprob = 100
	category_tags = list(CTAG_HFT_RETINUE)
	class_select_category = CLASS_CAT_HFT_WORKER
	subclass_social_rank = SOCIAL_RANK_YEOMAN

// Master Smith role for Heartfelt

	traits_applied = list(TRAIT_TRAINED_SMITH, TRAIT_SMITHING_EXPERT, TRAIT_MEDIUMARMOR, TRAIT_HEARTFELT)
	subclass_stats = list(
		STATKEY_LCK = 1,
		STATKEY_STR = 2,
		STATKEY_INT = 1,
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 2,
	)

	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/engineering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_MASTER, //One level above Towner Smiths
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_MASTER,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_MASTER,
		/datum/skill/craft/smelting = SKILL_LEVEL_MASTER,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	)

	subclass_stashed_items = list(
		"黑钢与钢锭储备" = /obj/item/storage/roguebag/heartfelt/armorer
	)

/datum/outfit/job/roguetown/heartfelt/retinue/armorer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你开局会携带一批用来搭建铁匠炉的物资，以及一些可供锻造的金属锭。"))
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/hammer/iron
	beltl = /obj/item/rogueweapon/tongs
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	mouth = /obj/item/rogueweapon/huntingknife
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	pants = /obj/item/clothing/under/roguetown/trou
	cloak = /obj/item/clothing/cloak/apron/blacksmith
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/heartfelt
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
						/obj/item/flint = 1,
						/obj/item/rogueore/coal=2,
						/obj/item/rogueore/iron=4,
						/obj/item/rogueore/silver=1,
						/obj/item/flashlight/flare/torch/lantern = 1,
						/obj/item/rogueweapon/scabbard/sheath = 1,
						)

	if(H.mind)
		var/molds = list(
			"铁剑模具" = /obj/item/mold/sword,
			"铁斧模具" = /obj/item/mold/axe,
			"铁锤模具" = /obj/item/mold/mace,
			"铁刀模具" = /obj/item/mold/knife,
			"长柄武器模具" = /obj/item/mold/polearm,
			"铁板甲模具" = /obj/item/mold/plate
		)
		var/mold_names = list()
		for (var/name in molds)
			mold_names += name
		for (var/i = 1 to 2)
			var/mold_choice = input(H, "选择你的起始模具", "选择") as anything in mold_names
			if (i == 1)
				l_hand = molds[mold_choice]
			else
				r_hand = molds[mold_choice]
		H.set_blindness(0)

	if(H.pronouns == HE_HIM)
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
	else
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
		shoes = /obj/item/clothing/shoes/roguetown/shortboots

/obj/item/storage/roguebag/heartfelt/armorer
	populate_contents = list(
	/obj/item/ingot/blacksteel,
	/obj/item/ingot/blacksteel,
	/obj/item/ingot/blacksteel,
	/obj/item/ingot/steel,
	/obj/item/ingot/steel,
	/obj/item/ingot/steel,
	/obj/item/ingot/steel,
	/obj/item/ingot/steel,
	)
