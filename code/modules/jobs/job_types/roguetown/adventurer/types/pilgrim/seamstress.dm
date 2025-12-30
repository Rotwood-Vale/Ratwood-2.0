/datum/advclass/seamstress
	name = "Seamster"
	tutorial = "You know your trade by the passage of a needle through cloth and leather alike. Mend and sew garments for the townsfolk - Coats, pants, hats, hoods, and so much more. So what if you overcharge? You're the reason everyone looks good in the first place."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/seamstress
	subclass_social_rank = SOCIAL_RANK_YEOMAN
	traits_applied = list(TRAIT_SEWING_EXPERT)

	traits_applied = list(TRAIT_DYES)
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_INT = 2,
		STATKEY_PER = 1,
		STATKEY_STR = -1
	)
	subclass_skills = list(
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/seamstress/pre_equip(mob/living/carbon/human/H)
	..()
	// Seamster cosmetic title selection
	if(H.mind)
		H.adjust_blindness(-3)
		var/cosmetic_titles = list(
			"Seamster",
			"Clothworker",
			"Stitcher",
			"Dressmaker",
			"Weaver")
		var/cosmetic_choice = input(H, "Select your sewing specialty.", "Sewing Specialties") as anything in cosmetic_titles
		
		switch(cosmetic_choice)
			if("Seamster")
				to_chat(H, span_notice("You are a Seamster, skilled with needle and thread."))
				H.mind.cosmetic_class_title = "Seamster"
				H.adjust_skillrank(/datum/skill/craft/sewing, 1, TRUE)
			if("Clothworker")
				to_chat(H, span_notice("You are a Clothworker, working with fabrics."))
				H.mind.cosmetic_class_title = "Clothworker"
				H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
			if("Stitcher")
				to_chat(H, span_notice("You are a Stitcher, mending and creating."))
				H.mind.cosmetic_class_title = "Stitcher"
				H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
			if("Dressmaker")
				to_chat(H, span_notice("You are a Dressmaker, crafting elegant clothing."))
				H.mind.cosmetic_class_title = "Dressmaker"
				H.adjust_skillrank(/datum/skill/craft/tanning, 1, TRUE)
			if("Weaver")
				to_chat(H, span_notice("You are a Weaver, turning thread into cloth."))
				H.mind.cosmetic_class_title = "Weaver"
				H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
		H.set_blindness(0)
	
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	armor = /obj/item/clothing/suit/roguetown/armor/armordress
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/cloth/lady
	beltl = /obj/item/needle
	beltr = /obj/item/rogueweapon/huntingknife/scissors
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
						/obj/item/natural/cloth = 3,
						/obj/item/natural/bundle/fibers/full = 1,
						/obj/item/flashlight/flare/torch = 2,
						/obj/item/needle/thorn = 1,
						/obj/item/recipe_book/sewing = 1,
						/obj/item/book/rogue/swatchbook = 1,
						/obj/item/recipe_book/leatherworking = 1
						)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/fittedclothing)
