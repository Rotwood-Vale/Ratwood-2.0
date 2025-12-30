/datum/advclass/blacksmith
	name = "Blacksmith"
	tutorial = "A skilled blacksmith, able to forge capable weapons for warriors in the bog, \
	only after building a forge for themselves of course"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/blacksmith
	subclass_social_rank = SOCIAL_RANK_YEOMAN
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	traits_applied = list(TRAIT_TRAINED_SMITH, TRAIT_SMITHING_EXPERT)
	subclass_stats = list(
		STATKEY_WIL = 1,
		STATKEY_CON = 1,
		STATKEY_STR = 1,
		STATKEY_INT = 2,
		STATKEY_LCK = 1,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN, // The strongest fists in the land.
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/engineering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/mining = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/smelting = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/adventurer/blacksmith/pre_equip(mob/living/carbon/human/H)
	..()
	// Blacksmith cosmetic title selection
	if(H.mind)
		H.adjust_blindness(-3)
		var/cosmetic_titles = list(
			"Blacksmith",
			"Smith",
			"Metalworker",
			"Forgemaster",
			"Ironworker")
		var/cosmetic_choice = input(H, "Select your smithing profession.", "Smithing Professions") as anything in cosmetic_titles
		
		switch(cosmetic_choice)
			if("Blacksmith")
				to_chat(H, span_notice("You are a Blacksmith, forging metal at the anvil."))
				H.mind.cosmetic_class_title = "Blacksmith"
				H.adjust_skillrank(/datum/skill/craft/blacksmithing, 1, TRUE)
			if("Smith")
				to_chat(H, span_notice("You are a Smith, working metal into tools and weapons."))
				H.mind.cosmetic_class_title = "Smith"
				H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, TRUE)
			if("Metalworker")
				to_chat(H, span_notice("You are a Metalworker, shaping iron and steel."))
				H.mind.cosmetic_class_title = "Metalworker"
				H.adjust_skillrank(/datum/skill/craft/smelting, 1, TRUE)
			if("Forgemaster")
				to_chat(H, span_notice("You are a Forgemaster, master of the forge."))
				H.mind.cosmetic_class_title = "Forgemaster"
				H.adjust_skillrank(/datum/skill/craft/engineering, 1, TRUE)
			if("Ironworker")
				to_chat(H, span_notice("You are an Ironworker, crafting with iron."))
				H.mind.cosmetic_class_title = "Ironworker"
				H.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
		H.set_blindness(0)
	
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/hammer/iron
	beltl = /obj/item/rogueweapon/tongs
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	cloak = /obj/item/clothing/cloak/apron/blacksmith
	mouth = /obj/item/rogueweapon/huntingknife
	pants = /obj/item/clothing/under/roguetown/trou
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/rogueweapon/scabbard/sheath
	backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/rogueore/coal = 5,
		/obj/item/rogueore/iron = 6,
		/obj/item/flashlight/flare/torch = 2,
		/obj/item/recipe_book/blacksmithing = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/armor_brush = 1,
		/obj/item/polishing_cream = 1
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
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
