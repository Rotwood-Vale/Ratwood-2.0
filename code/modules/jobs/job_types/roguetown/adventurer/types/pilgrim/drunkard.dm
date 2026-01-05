/datum/advclass/drunkard
	name = "Gambler"
	tutorial = "Life has dealt you a harsh hand. Once perhaps respectable, fortune turned against you—bad deals, worse debts, or simply the cruel whims of fate. Now you survive by your wits: reading tells, running games, and knowing when to fold. You're skilled at sleight of hand, persuasion, and finding opportunity in chaos. The cards and dice are your trade, but you've picked up other useful skills along the way. Maybe this time, your luck will finally turn..."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/drunkard
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)
	subclass_social_rank = SOCIAL_RANK_PEASANT
	
	category_tags = list(CTAG_TOWNER)
	subclass_stats = list(
		STATKEY_LCK = 3,
		STATKEY_INT = 2,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_STR = -1,
	)
	subclass_skills = list(
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/drunkard/pre_equip(mob/living/carbon/human/H)
	..()
	// Gambler cosmetic title selection
	var/cosmetic_titles = list(
		"Gambler",
		"Dice Thrower",
		"Hustler",
		"Fortune Seeker")
	var/cosmetic_choice = input(H, "Select your gambling specialty.", "Gambling Specialties") as anything in cosmetic_titles
	
	switch(cosmetic_choice)
		if("Gambler")
			to_chat(H, span_notice("You are a Gambler, living by luck and chance."))
			H.mind.cosmetic_class_title = "Gambler"
			H.adjust_skillrank(/datum/skill/misc/stealing, 1, TRUE)
		if("Dice Thrower")
			to_chat(H, span_notice("You are a Dice Thrower, master of bones and chance."))
			H.mind.cosmetic_class_title = "Dice Thrower"
			H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		if("Hustler")
			to_chat(H, span_notice("You are a Hustler, always working an angle."))
			H.mind.cosmetic_class_title = "Hustler"
			H.adjust_skillrank(/datum/skill/misc/sneaking, 1, TRUE)
		if("Fortune Seeker")
			to_chat(H, span_notice("You are a Fortune Seeker, chasing wealth through risk."))
			H.mind.cosmetic_class_title = "Fortune Seeker"
			H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	
	pants = /obj/item/clothing/under/roguetown/tights/vagrant
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
	backl = /obj/item/storage/backpack/rogue/backpack
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/lockpick
	beltl = /obj/item/flint
	backpack_contents = list(
					/obj/item/storage/pill_bottle/dice = 1,
					/obj/item/storage/pill_bottle/dice/farkle = 1,
					/obj/item/reagent_containers/glass/cup = 1,
					/obj/item/toy/cards/deck = 1,
					/obj/item/roguecoin/copper = 3,
					/obj/item/flashlight/flare/torch/lantern/copper = 1,
