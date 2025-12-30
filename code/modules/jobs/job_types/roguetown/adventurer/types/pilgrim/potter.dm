/datum/advclass/potter
	name = "Artisan"
	tutorial = "You are a skilled artisan—a creator of fine crafts and useful goods. Whether you work with clay, glass, wood, or fabric, your hands bring beauty and function to the world. Choose your specialty and craft your legacy."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/potter
	subclass_social_rank = SOCIAL_RANK_YEOMAN
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)

	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/ceramics = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/engineering = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/potter/pre_equip(mob/living/carbon/human/H)
	..()
	// Artisan cosmetic title selection
	if(H.mind)
		H.adjust_blindness(-3)
		var/cosmetic_titles = list(
			"Potter",
			"Ceramicist",
			"Glassblower",
			"Sculptor",
			"Woodcarver",
			"Weaver",
			"Crafter",
			"Artisan")
		var/cosmetic_choice = input(H, "Select your craft specialty.", "Craft Specialties") as anything in cosmetic_titles
		
		switch(cosmetic_choice)
			if("Potter")
				to_chat(H, span_notice("You are a Potter, shaping clay into useful vessels."))
				H.mind.cosmetic_class_title = "Potter"
				H.adjust_skillrank(/datum/skill/craft/ceramics, 1, TRUE)
			if("Ceramicist")
				to_chat(H, span_notice("You are a Ceramicist, mastering the art of pottery."))
				H.mind.cosmetic_class_title = "Ceramicist"
				H.adjust_skillrank(/datum/skill/craft/ceramics, 1, TRUE)
			if("Glassblower")
				to_chat(H, span_notice("You are a Glassblower, crafting beautiful glass works."))
				H.mind.cosmetic_class_title = "Glassblower"
				H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
			if("Sculptor")
				to_chat(H, span_notice("You are a Sculptor, carving stone and wood into art."))
				H.mind.cosmetic_class_title = "Sculptor"
				H.adjust_skillrank(/datum/skill/craft/masonry, 1, TRUE)
			if("Woodcarver")
				to_chat(H, span_notice("You are a Woodcarver, working with timber and tools."))
				H.mind.cosmetic_class_title = "Woodcarver"
				H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
			if("Weaver")
				to_chat(H, span_notice("You are a Weaver, creating textiles and fabrics."))
				H.mind.cosmetic_class_title = "Weaver"
				H.adjust_skillrank(/datum/skill/craft/sewing, 1, TRUE)
			if("Crafter")
				to_chat(H, span_notice("You are a Crafter, skilled in many trades."))
				H.mind.cosmetic_class_title = "Crafter"
				H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
			if("Artisan")
				to_chat(H, span_notice("You are an Artisan, a master of crafts."))
				H.mind.cosmetic_class_title = "Artisan"
				H.adjust_skillrank(/datum/skill/craft/engineering, 1, TRUE)
		H.set_blindness(0)
	
	head = /obj/item/clothing/head/roguetown/hatfur
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/hatblu

	cloak = /obj/item/clothing/cloak/apron/blacksmith
	pants = /obj/item/clothing/under/roguetown/trou
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltl = /obj/item/rogueweapon/blowrod
	beltr = /obj/item/rogueweapon/tongs   // Necessary for removing hot glass panes from furnaces.
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/rogueweapon/shovel  // For getting clay

	backpack_contents = list(
		/obj/item/natural/clay = 5,
		/obj/item/natural/clay/glassbatch = 2,
		/obj/item/rogueore/coal = 2,
		/obj/item/roguegear/bronze = 1,
		/obj/item/dye_brush = 1,
		/obj/item/recipe_book/ceramics = 1)
	// Clay and glassBatch are raw materials
	// Coal so he can build an ore furnace for glass blowing
	// Coggers so he can build a potter's wheel.
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/digclay)
