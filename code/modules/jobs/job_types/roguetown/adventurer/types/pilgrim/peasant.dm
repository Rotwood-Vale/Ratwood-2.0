/datum/advclass/peasant
	name = "Farmer"
	tutorial = "You are an independent farmer, working your own land and making your own way. Unlike the Soilson bound to manor lands, you have the freedom to farm where you choose. You've learned not just farming but all the skills needed to maintain a homestead—carpentry, butchering, cooking, and basic crafts. You're hardworking, self-sufficient, and know the value of good honest labor."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/peasant
	subclass_social_rank = SOCIAL_RANK_PEASANT
	cmode_music = 'sound/music/cmode/towner/combat_towner2.ogg'
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_INT = 1
	)
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT, TRAIT_SEEDKNOW)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/slings = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/peasant/pre_equip(mob/living/carbon/human/H)
	..()
	// Farmer cosmetic title selection
	H.adjust_blindness(-3)
	var/cosmetic_titles = list(
		"Farmer",
		"Homesteader",
		"Agriculturist",
		"Cultivator",
		"Farmhand")
	var/cosmetic_choice = input(H, "Select your farming specialty.", "Farming Specialties") as anything in cosmetic_titles
	
	switch(cosmetic_choice)
		if("Farmer")
			to_chat(H, span_notice("You are a Farmer, working the land with honest labor."))
			H.mind.cosmetic_class_title = "Farmer"
			H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
		if("Homesteader")
			to_chat(H, span_notice("You are a Homesteader, self-sufficient and independent."))
			H.mind.cosmetic_class_title = "Homesteader"
			H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
		if("Agriculturist")
			to_chat(H, span_notice("You are an Agriculturist, knowledgeable in crop science."))
			H.mind.cosmetic_class_title = "Agriculturist"
			H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
		if("Cultivator")
			to_chat(H, span_notice("You are a Cultivator, nurturing plants to fruition."))
			H.mind.cosmetic_class_title = "Cultivator"
			H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		if("Farmhand")
			to_chat(H, span_notice("You are a Farmhand, working hard from dawn to dusk."))
			H.mind.cosmetic_class_title = "Farmhand"
			H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)

	belt = /obj/item/storage/belt/rogue/leather/rope
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	pants = /obj/item/clothing/under/roguetown/trou
	head = /obj/item/clothing/head/roguetown/strawhat
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	backl = /obj/item/storage/backpack/rogue/backpack
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
	mouth = /obj/item/rogueweapon/huntingknife
	beltr = /obj/item/flint
	if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
		pants = null
		cloak = /obj/item/clothing/cloak/apron/brown
	backpack_contents = list(
						/obj/item/seeds/wheat = 2,
						/obj/item/seeds/apple = 1,
						/obj/item/seeds/cabbage = 1,
						/obj/item/seeds/berryrogue = 1,
						/obj/item/seeds/potato = 1,
						/obj/item/seeds/onion = 1,
						/obj/item/ash = 2,
						/obj/item/reagent_containers/glass/bottle/waterskin = 1,
						/obj/item/flashlight/flare/torch/lantern/copper = 1,
						/obj/item/recipe_book/survival = 1,
						/obj/item/rogueweapon/scabbard/sheath = 1,
						/obj/item/rogueweapon/hammer/wood = 1
						)
	beltl = /obj/item/rogueweapon/sickle
	backr = /obj/item/rogueweapon/hoe
	
	// Age bonuses for experienced farmers
	if(H.age == AGE_MIDDLEAGED)
		H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
		H.adjust_skillrank(/datum/skill/labor/butchering, 1, TRUE)
