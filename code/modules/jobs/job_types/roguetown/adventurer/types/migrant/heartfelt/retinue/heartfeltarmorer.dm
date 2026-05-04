
/datum/advclass/heartfelt/retinue/armorer
	name = "Heartfeltian Armorer"
	tutorial = "You are the Heartfeltian's Armorer destined for greatness, but fate intervened with the barony's downfall,\
	With your home in ruins, you look to the Vale, hoping to find new purpose or refuge amidst the chaos."
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
		"Blacksteel and Steel Stash" = /obj/item/storage/roguebag/heartfelt/armorer
	)

/datum/outfit/job/roguetown/heartfelt/retinue/armorer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You start with a stash of items for setting up a forge. Alongside some bars for smithing."))
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
			"Iron sword mold" = /obj/item/mold/sword,
			"Iron axe mold" = /obj/item/mold/axe,
			"Iron mace mold" = /obj/item/mold/mace,
			"Iron knife mold" = /obj/item/mold/knife,
			"Iron polearm mold" = /obj/item/mold/polearm,
			"Iron plate" = /obj/item/mold/plate
		)
		var/mold_names = list()
		for (var/name in molds)
			mold_names += name
		for (var/i = 1 to 2)
			var/mold_choice = input(H, "Choose your starting molds", "Select") as anything in mold_names
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
