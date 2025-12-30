/datum/advclass/hunter
	name = "Hunter"
	tutorial = "You are a hunter. Whether with bow or spear, you hunt the fauna of the glade, skinning what you kill and cooking any meat left over. The job is dangerous but important in the circulation of clothing and light armor. Choose your specialty when you begin."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/hunter
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_OUTDOORSMAN, TRAIT_SURVIVAL_EXPERT)
	cmode_music = 'sound/music/cmode/towner/combat_towner2.ogg'

	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	subclass_stats = list()  // Set dynamically based on specialization choice
	subclass_skills = list()  // Set dynamically based on specialization choice

/datum/outfit/job/roguetown/adventurer/hunter/pre_equip(mob/living/carbon/human/H)
	..()
	// Hunter cosmetic title selection
	if(H.mind)
		H.adjust_blindness(-3)
		var/cosmetic_titles = list(
			"Hunter",
			"Trapper",
			"Woodsman",
			"Forester",
			"Ranger",
			"Huntsman")
		var/cosmetic_choice = input(H, "Select your hunting profession.", "Hunting Professions") as anything in cosmetic_titles
		
		switch(cosmetic_choice)
			if("Hunter")
				to_chat(H, span_notice("You are a Hunter, pursuing game in the wilderness."))
				H.mind.cosmetic_class_title = "Hunter"
				H.adjust_skillrank(/datum/skill/craft/tanning, 1, TRUE)
			if("Trapper")
				to_chat(H, span_notice("You are a Trapper, skilled in catching animals with traps."))
				H.mind.cosmetic_class_title = "Trapper"
				H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
			if("Woodsman")
				to_chat(H, span_notice("You are a Woodsman, living off the land."))
				H.mind.cosmetic_class_title = "Woodsman"
				H.adjust_skillrank(/datum/skill/labor/lumberjacking, 1, TRUE)
			if("Forester")
				to_chat(H, span_notice("You are a Forester, keeper of the woods."))
				H.mind.cosmetic_class_title = "Forester"
				H.adjust_skillrank(/datum/skill/labor/lumberjacking, 1, TRUE)
			if("Ranger")
				to_chat(H, span_notice("You are a Ranger, roaming the wilderness."))
				H.mind.cosmetic_class_title = "Ranger"
				H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
			if("Huntsman")
				to_chat(H, span_notice("You are a Huntsman, a professional hunter."))
				H.mind.cosmetic_class_title = "Huntsman"
				H.adjust_skillrank(/datum/skill/labor/fishing, 1, TRUE)
		
		// Hunter specialization selection
		var/hunting_styles = list("Bowman","Spearman")
		var/style_choice = input(H, "Choose your hunting style.", "HUNTER SPECIALIZATION") as anything in hunting_styles
		H.set_blindness(0)
		
		switch(style_choice)
			if("Bowman")
				to_chat(H, span_notice("You are a Bowman, hunting with bow and arrow from a distance."))
				// Bow Hunter equipment
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				var/obj/item/quiver/arrows/Q = new()
				Q.arrows = list()
				for(var/i in 1 to 10)
					Q.arrows += new /obj/item/ammo_casing/caseless/rogue/arrow/iron(Q)
				beltr = Q
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/short/messer/iron
				// Bow-specific stats
				H.change_stat("perception", 3)
				H.change_stat("intelligence", 1)
				H.change_stat("speed", 1)
				// Bow-specific skills
				H.adjust_skillrank(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank(/datum/skill/combat/crossbows, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank(/datum/skill/combat/slings, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank(/datum/skill/combat/swords, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank(/datum/skill/combat/axes, SKILL_LEVEL_NOVICE, TRUE)
				
			if("Spearman")
				to_chat(H, span_notice("You are a Spearman, hunting with spear and strength up close."))
				// Spear Hunter equipment
				armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				l_hand = /obj/item/rogueweapon/spear
				shoes = /obj/item/clothing/shoes/roguetown/boots/furlinedboots
				beltl = /obj/item/rogueweapon/huntingknife/throwingknife
				// Spear-specific stats
				H.change_stat("strength", 2)
				H.change_stat("constitution", 1)
				H.change_stat("willpower", 1)
				// Spear-specific skills
				H.adjust_skillrank(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
	
	// Common equipment for all hunters
	pants = /obj/item/clothing/under/roguetown/trou/leather
	if(!shirt) // Only set if not already set by specialization
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
	if(!armor) // Only set if not already set by specialization
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
	if(!backr)
		backr = /obj/item/storage/backpack/rogue/satchel
	if(!backl)
		backl = /obj/item/storage/backpack/rogue/backpack
	belt = /obj/item/storage/belt/rogue/leather
	if(!beltr)
		beltr = /obj/item/storage/meatbag
	if(!beltl)
		beltl = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
				/obj/item/flint = 1,
				/obj/item/bait = 1,
				/obj/item/rogueweapon/huntingknife = 1,
				/obj/item/flashlight/flare/torch = 1,
				/obj/item/recipe_book/survival = 1,
				/obj/item/recipe_book/leatherworking = 1,
				/obj/item/rogueweapon/scabbard/sheath = 1
				)
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	
	// Common skills for all hunters
	H.adjust_skillrank(/datum/skill/misc/swimming, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank(/datum/skill/labor/fishing, SKILL_LEVEL_NOVICE, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank(/datum/skill/labor/butchering, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank(/datum/skill/craft/traps, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, SKILL_LEVEL_NOVICE, TRUE)
	H.adjust_skillrank(/datum/skill/misc/tracking, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, SKILL_LEVEL_NOVICE, TRUE)
	
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/huntersyell)
