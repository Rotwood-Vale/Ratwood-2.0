/datum/advclass/minstrel
	name = "Minstrel"
	tutorial = "Unlike those so-called 'bards' who traipse around in fancy cloth and swordfight in the woods, you follow the calling of a true musician. You've simply... yet to find a receptive audience."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/minstrel
	subclass_social_rank = SOCIAL_RANK_PEASANT
	category_tags = list(CTAG_TOWNER)
	traits_applied = list(TRAIT_EMPATH, TRAIT_GOODLOVER, TRAIT_HOMESTEAD_EXPERT)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_INT = 2,
		STATKEY_PER = 1,
		STATKEY_LCK = 1
	)
	subclass_skills = list(
		/datum/skill/misc/music = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/minstrel/pre_equip(mob/living/carbon/human/H)
	..()
	// Minstrel cosmetic title selection
	if(H.mind)
		H.adjust_blindness(-3)
		var/cosmetic_titles = list(
			"Minstrel",
			"Musician",
			"Songster",
			"Performer",
			"Troubadour",
			"Balladeer")
		var/cosmetic_choice = input(H, "Select your musical profession.", "Musical Professions") as anything in cosmetic_titles
		
		switch(cosmetic_choice)
			if("Minstrel")
				to_chat(H, span_notice("You are a Minstrel, entertaining with music."))
				H.mind.cosmetic_class_title = "Minstrel"
				H.adjust_skillrank(/datum/skill/misc/music, 1, TRUE)
			if("Musician")
				to_chat(H, span_notice("You are a Musician, mastering your instruments."))
				H.mind.cosmetic_class_title = "Musician"
				H.adjust_skillrank(/datum/skill/misc/music, 1, TRUE)
			if("Songster")
				to_chat(H, span_notice("You are a Songster, singing tales and ballads."))
				H.mind.cosmetic_class_title = "Songster"
				H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
			if("Performer")
				to_chat(H, span_notice("You are a Performer, captivating audiences."))
				H.mind.cosmetic_class_title = "Performer"
				H.adjust_skillrank(/datum/skill/misc/sneaking, 1, TRUE)
			if("Troubadour")
				to_chat(H, span_notice("You are a Troubadour, wandering with your music."))
				H.mind.cosmetic_class_title = "Troubadour"
				H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			if("Balladeer")
				to_chat(H, span_notice("You are a Balladeer, crafting songs and stories."))
				H.mind.cosmetic_class_title = "Balladeer"
				H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.set_blindness(0)
	
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	cloak = /obj/item/clothing/cloak/half
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
	r_hand = /obj/item/rogue/instrument/accord
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/cloth
	beltr = /obj/item/rogueweapon/huntingknife/idagger
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
					/obj/item/rogue/instrument/lute = 1,
					/obj/item/rogue/instrument/flute = 1,
					/obj/item/rogue/instrument/drum = 1,
					/obj/item/flashlight/flare/torch/lantern/copper = 1,
						/obj/item/rogueweapon/scabbard/sheath = 1
						)
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T3)
