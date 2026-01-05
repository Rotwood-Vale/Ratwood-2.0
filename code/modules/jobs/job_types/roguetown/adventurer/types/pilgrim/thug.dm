/datum/advclass/thug
	name = "Thug"
	tutorial = "You're a working-class tough—the kind who does odd jobs, manual labor, and whatever needs doing to get by. You've learned skills from a dozen different trades: hauling cargo, working construction, helping on farms, doing repairs. You're strong, practical, and know how to handle yourself in a scrap. Maybe you've bent the law here and there, but mostly you're just trying to make an honest-ish living with your hands and your back."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/thug
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)
	cmode_music = 'sound/music/cmode/towner/combat_towner2.ogg'
	category_tags = list(CTAG_TOWNER)
	subclass_languages = list(/datum/language/thievescant)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/mining = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/thug/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)		// Cosmetic title selection
		H.adjust_blindness(-3)
		var/cosmetic_titles = list(
			"Laborer",
			"Worker",
			"Thug",
			"Hired Hand",
			"Hauler",
			"Roughneck",
			"Manual Laborer")
		var/cosmetic_choice = input(H, "Select your working style.", "Work Specialties") as anything in cosmetic_titles
		
		switch(cosmetic_choice)
			if("Laborer")
				to_chat(H, span_notice("You are a Laborer, earning your keep through hard work."))
				H.mind.cosmetic_class_title = "Laborer"
				H.adjust_skillrank(/datum/skill/labor/lumberjacking, 1, TRUE)
			if("Worker")
				to_chat(H, span_notice("You are a Worker, doing honest labor."))
				H.mind.cosmetic_class_title = "Worker"
				H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			if("Thug")
				to_chat(H, span_notice("You are a Thug, ready to handle any rough situation."))
				H.mind.cosmetic_class_title = "Thug"
				H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
			if("Hired Hand")
				to_chat(H, span_notice("You are a Hired Hand, available for any task."))
				H.mind.cosmetic_class_title = "Hired Hand"
				H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
			if("Hauler")
				to_chat(H, span_notice("You are a Hauler, moving goods and materials."))
				H.mind.cosmetic_class_title = "Hauler"
				H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			if("Roughneck")
				to_chat(H, span_notice("You are a Roughneck, unrefined but effective."))
				H.mind.cosmetic_class_title = "Roughneck"
				H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
			if("Manual Laborer")
				to_chat(H, span_notice("You are a Manual Laborer, working with your hands."))
				H.mind.cosmetic_class_title = "Manual Laborer"
				H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		
		// Weapon selection
		var/weapons = list("Knuckles","Cudgel","Bronze Axe")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Knuckles")
				beltr = /obj/item/rogueweapon/knuckles/bronzeknuckles
				to_chat(H, span_notice("You prefer to settle things with your fists."))
			if("Cudgel")
				beltl = /obj/item/rogueweapon/mace/cudgel
				to_chat(H, span_notice("A good club gets the point across."))
			if("Bronze Axe")
				beltr = /obj/item/rogueweapon/stoneaxe/battle
				to_chat(H, span_notice("A solid bronze axe - practical for work and defense."))
	head = /obj/item/clothing/head/roguetown/roguehood/random
	belt = /obj/item/storage/belt/rogue/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	backr = /obj/item/storage/backpack/rogue/backpack
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
	if(!beltl)
		beltl = /obj/item/rogueweapon/huntingknife
	backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/rogueweapon/hammer/wood = 1,
		/obj/item/flashlight/flare/torch/lantern/copper = 1,
		/obj/item/rope = 2,
		/obj/item/lockpick = 1,
		/obj/item/reagent_containers/glass/bottle/waterskin = 1,
		/obj/item/reagent_containers/food/snacks/rogue/bread = 1,
		/obj/item/natural/cloth/bandage = 2,
	)
