/datum/advclass/cheesemaker
	name = "Cook"
	tutorial = "You are a skilled cook and food artisan. Whether you specialize in cheese, baking, butchery, or general cooking, you bring sustenance and flavor to the masses. You have a loyal bovine companion who provides you with fresh milk and companionship. Take good care of your precious beast, and she will reward you in kind."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/cheesemaker
	subclass_social_rank = SOCIAL_RANK_YEOMAN
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)

	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/cow
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_PER = 1
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/maces = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/axes = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_MASTER,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/cheesemaker/pre_equip(mob/living/carbon/human/H)
	..()
	// Cook cosmetic title selection
	H.adjust_blindness(-3)
	var/cosmetic_titles = list(
		"Baker",
		"Butcher",
		"Cheesemaker",
		"Chef",
		"Cook",
		"Culinary Artist",
		"Dairyman", "Dairywoman",
		"Food Merchant",
		"Pastry Chef")
	var/cosmetic_choice = input(H, "Select your culinary specialty.", "Culinary Specialties") as anything in cosmetic_titles
	
	switch(cosmetic_choice)
		if("Baker")
			to_chat(H, span_notice("You are a Baker, crafting breads and pastries."))
			H.mind.cosmetic_class_title = "Baker"
			H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
			backpack_contents[/obj/item/reagent_containers/food/snacks/grown/wheat] = 8
		if("Butcher")
			to_chat(H, span_notice("You are a Butcher, skilled in preparing meats."))
			H.mind.cosmetic_class_title = "Butcher"
			H.adjust_skillrank(/datum/skill/labor/butchering, 1, TRUE)
		if("Cheesemaker")
			to_chat(H, span_notice("You are a Cheesemaker, master of dairy crafts."))
			H.mind.cosmetic_class_title = "Cheesemaker"
			H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
			backpack_contents[/obj/item/reagent_containers/food/snacks/rogue/cheddar] = 4
		if("Chef")
			to_chat(H, span_notice("You are a Chef, creating culinary masterpieces."))
			H.mind.cosmetic_class_title = "Chef"
			H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		if("Cook")
			to_chat(H, span_notice("You are a Cook, feeding the masses with hearty fare."))
			H.mind.cosmetic_class_title = "Cook"
			H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		if("Culinary Artist")
			to_chat(H, span_notice("You are a Culinary Artist, where food becomes art."))
			H.mind.cosmetic_class_title = "Culinary Artist"
			H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		if("Dairyman")
			to_chat(H, span_notice("You are a Dairyman, master of milk and cheese."))
			H.mind.cosmetic_class_title = "Dairyman"
			H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
			backpack_contents[/obj/item/reagent_containers/food/snacks/rogue/cheddar] = 4
		if("Dairywoman")
			to_chat(H, span_notice("You are a Dairywoman, master of milk and cheese."))
			H.mind.cosmetic_class_title = "Dairywoman"
			H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
			backpack_contents[/obj/item/reagent_containers/food/snacks/rogue/cheddar] = 4
		if("Food Merchant")
			to_chat(H, span_notice("You are a Food Merchant, trading in culinary goods."))
			H.mind.cosmetic_class_title = "Food Merchant"
			H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
			neck = /obj/item/storage/belt/rogue/pouch/coins/mid
		if("Pastry Chef")
			to_chat(H, span_notice("You are a Pastry Chef, creating sweet delights."))
			H.mind.cosmetic_class_title = "Pastry Chef"
			H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
			backpack_contents[/obj/item/reagent_containers/food/snacks/grown/wheat] = 8
	
	mouth = /obj/item/rogueweapon/huntingknife
	belt = /obj/item/storage/belt/rogue/leather
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
		pants = /obj/item/clothing/under/roguetown/skirt/random
	else if(should_wear_masc_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/armor/workervest
		pants = /obj/item/clothing/under/roguetown/tights/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
	head = /obj/item/clothing/head/roguetown/cookhat
	cloak = /obj/item/clothing/cloak/apron
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	backl = /obj/item/storage/backpack/rogue/backpack
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltl = /obj/item/flint
	beltr = /obj/item/rogueweapon/scabbard/sheath
	backpack_contents = list(
		/obj/item/reagent_containers/powder/salt = 3,
		/obj/item/reagent_containers/food/snacks/rogue/cheddar = 2,
		/obj/item/reagent_containers/glass/bottle/waterskin,
		/obj/item/reagent_containers/food/snacks/grown/wheat = 6,
		/obj/item/natural/cloth = 4,
		/obj/item/reagent_containers/glass/bottle = 2,
		/obj/item/book/rogue/yeoldecookingmanual = 1,
		/obj/item/recipe_book/survival = 1,
		)
	r_hand = /obj/item/flashlight/flare/torch
