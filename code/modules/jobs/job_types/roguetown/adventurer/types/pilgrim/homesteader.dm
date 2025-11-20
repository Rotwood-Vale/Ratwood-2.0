/datum/advclass/homesteader
	name = "Peasant"
	tutorial = "Vale population's tendency to take up arms and become unwashed beastslayers had forced you to take up jobs, small and large of most professions.\n A jack of all trades, what will you be known as this week?"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/homesteader

	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	subclass_social_rank = SOCIAL_RANK_PEASANT
	subclass_stats = list(
		STATKEY_SPD = -1,
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_INT = 2,
	)


//	adaptive_name = FALSE


	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_NOVICE,  //They don't get massive skilll list anymore aside of journeyman in crafting.
	)

/datum/outfit/job/roguetown/homesteader/pre_equip(mob/living/carbon/human/H)
	..()
	// Homesteader cosmetic title selection
	H.adjust_blindness(-3)
	var/cosmetic_titles = list(
	"Artisan", "Artisana",
	"Craftsman", "Craftswoman",
	"Devotee", "Devotess",
	"Fieldworker",
	"Forager",
	"Handiworker",
	"Hedgefolk",
	"Herbalist",
	"Homesteader", "Homesteadress",
	"Householder", "Househusband", "Housewife",
	"Laborer",
	"Nurse", "Nun",
	"Pioneer",
	"Settler",
	"Tradesperson",
	"Villager",
	"Woodsman", "Woodswoman",
	"Chirurgeon")
	var/cosmetic_choice = input(H, "Select your cosmetic title.", "Cosmetic Titles") as anything in cosmetic_titles

	switch(cosmetic_choice)
		if("Devotee")
			to_chat(H, span_notice("You are a Devotee, a pious peasant devoted to faith and community."))
			H.mind.cosmetic_class_title = "Devotee"
		if("Devotess")
			to_chat(H, span_notice("You are a Devotess, a pious peasant devoted to faith and community."))
			H.mind.cosmetic_class_title = "Devotess"
		if("Fieldworker")
			to_chat(H, span_notice("You are a Fieldworker, a laborer of fields and land."))
			H.mind.cosmetic_class_title = "Fieldworker"
		if("Fieldwoman")
			to_chat(H, span_notice("You are a Fieldwoman, a laborer of fields and land."))
			H.mind.cosmetic_class_title = "Fieldwoman"
		if("Handiworker")
			to_chat(H, span_notice("You are a Handiworker, skilled in small crafts and repairs."))
			H.mind.cosmetic_class_title = "Handiworker"
		if("Handiwoman")
			to_chat(H, span_notice("You are a Handiwoman, skilled in small crafts and repairs."))
			H.mind.cosmetic_class_title = "Handiwoman"
		if("Hedgefolk")
			to_chat(H, span_notice("You are Hedgefolk, a rural dweller of modest means."))
			H.mind.cosmetic_class_title = "Hedgefolk"
		if("Herbalist")
			to_chat(H, span_notice("You are an Herbalist, skilled in plants and their remedies."))
			H.mind.cosmetic_class_title = "Herbalist"
		if("Homesteader")
			to_chat(H, span_notice("You are a Homesteader, a settler and keeper of land."))
			H.mind.cosmetic_class_title = "Homesteader"
		if("Homesteadress")
			to_chat(H, span_notice("You are a Homesteadress, a settler and keeper of land."))
			H.mind.cosmetic_class_title = "Homesteadress"
		if("Householder")
			to_chat(H, span_notice("You are a Householder, a keeper of dwelling and family."))
			H.mind.cosmetic_class_title = "Householder"
		if("Househusband")
			to_chat(H, span_notice("You are a Househusband, a keeper of dwelling and family."))
			H.mind.cosmetic_class_title = "Househusband"
		if("Housewife")
			to_chat(H, span_notice("You are a Housewife, a keeper of dwelling and family."))
			H.mind.cosmetic_class_title = "Housewife"
		if("Laborer")
			to_chat(H, span_notice("You are a Laborer, a hard worker and commoner."))
			H.mind.cosmetic_class_title = "Laborer"
		if("Laboress")
			to_chat(H, span_notice("You are a Laboress, a hard worker and commoner."))
			H.mind.cosmetic_class_title = "Laboress"
		if("Villager")
			to_chat(H, span_notice("You are a Villager, common folk of the settlement."))
			H.mind.cosmetic_class_title = "Villager"
		if("Villagewoman")
			to_chat(H, span_notice("You are a Villagewoman, common folk of the settlement."))
			H.mind.cosmetic_class_title = "Villagewoman"
		if("Artisan")
			to_chat(H, span_notice("You are an Artisan, skilled in your craft and trade."))
			H.mind.cosmetic_class_title = "Artisan"
		if("Artisana")
			to_chat(H, span_notice("You are an Artisana, skilled in your craft and trade."))
			H.mind.cosmetic_class_title = "Artisana"
		if("Pioneer")
			to_chat(H, span_notice("You are a Pioneer, a brave settler of new lands."))
			H.mind.cosmetic_class_title = "Pioneer"
		if("Pioneress")
			to_chat(H, span_notice("You are a Pioneress, a brave settler of new lands."))
			H.mind.cosmetic_class_title = "Pioneress"
		if("Settler")
			to_chat(H, span_notice("You are a Settler, one who makes a home in strange lands."))
			H.mind.cosmetic_class_title = "Settler"
		if("Settleress")
			to_chat(H, span_notice("You are a Settleress, one who makes a home in strange lands."))
			H.mind.cosmetic_class_title = "Settleress"
		if("Tradesperson")
			to_chat(H, span_notice("You are a Tradesperson, skilled in commerce and craft."))
			H.mind.cosmetic_class_title = "Tradesperson"
		if("Tradewoman")
			to_chat(H, span_notice("You are a Tradewoman, skilled in commerce and craft."))
			H.mind.cosmetic_class_title = "Tradewoman"
		if("Woodsman")
			to_chat(H, span_notice("You are a Woodsman, at home in forest and timber."))
			H.mind.cosmetic_class_title = "Woodsman"
		if("Woodswoman")
			to_chat(H, span_notice("You are a Woodswoman, at home in forest and timber."))
			H.mind.cosmetic_class_title = "Woodswoman"
		if("Craftsman")
			to_chat(H, span_notice("You are a Craftsman, skilled in your trade."))
			H.mind.cosmetic_class_title = "Craftsman"
		if("Craftswoman")
			to_chat(H, span_notice("You are a Craftswoman, skilled in your trade."))
			H.mind.cosmetic_class_title = "Craftswoman"
		if("Forager")
			to_chat(H, span_notice("You are a Forager, gathering from the wilds."))
			H.mind.cosmetic_class_title = "Forager"
		if("Nurse")
			to_chat(H, span_notice("You are a Nurse, caring for the sick and wounded."))
			H.mind.cosmetic_class_title = "Nurse"
		if("Nun")
			to_chat(H, span_notice("You are a Nun, devoted to faith and service."))
			H.mind.cosmetic_class_title = "Nun"
		if("Chirurgeon")
			to_chat(H, span_notice("You are a Chirurgeon, skilled in surgical arts and healing."))
			H.mind.cosmetic_class_title = "Chirurgeon"


	// STAT PACK SELECTION
	var/stat_packs = list("Agile - SPD +2, CON +1, STR -1, WIL -1", "Bookworm - INT +1, PER +1, WIL +1, STR -2, CON -2", "Toned - STR +1, CON +1, WIL +1, INT -1", "All-Rounded - No Changes")
	var/stat_choice = input(H, "Select your stat focus. [1/1]", "Stat Pack Selection") as anything in stat_packs

	switch(stat_choice)
		if("Agile - SPD +2, CON +1, STR -1, WIL -1")
			to_chat(H, span_notice("You are agile and nimble."))
			H.change_stat(STATKEY_SPD, 2)
			H.change_stat(STATKEY_WIL, -1)
			H.change_stat(STATKEY_STR, -1) 
			H.change_stat(STATKEY_CON, 1)
		if("Bookworm - INT +1, PER +1, WIL +1, STR -2, CON -2")
			to_chat(H, span_notice("You are learned and wise."))
			H.change_stat(STATKEY_INT, 1)
			H.change_stat(STATKEY_PER, 1)
			H.change_stat(STATKEY_WIL, 1)
			H.change_stat(STATKEY_STR, -2)
			H.change_stat(STATKEY_CON, -2)
		if("Toned - STR +1, CON +1, WIL +1, INT -1")
			to_chat(H, span_notice("You are strong and hardy."))
			H.change_stat(STATKEY_STR, 1)
			H.change_stat(STATKEY_CON, 1)
			H.change_stat(STATKEY_WIL, 1)
			H.change_stat(STATKEY_INT, -1)
		if("All-Rounded - No Changes")
			to_chat(H, span_notice("You are balanced in all aspects."))
			// No stat changes for all-rounded

	// INVENTORY SELECTION
	// Individual bronze and copper weapons and armor
	var/bronze_copper_items = list(
		"Bronze Arming Sword" = /obj/item/rogueweapon/sword/bronze,
		"Bronze Katar" = /obj/item/rogueweapon/katar/bronze,
		"Bronze Knuckles" = /obj/item/rogueweapon/knuckles/bronzeknuckles,
		"Bronze Mace" = /obj/item/rogueweapon/mace/bronze,
		"Bronze Spear" = /obj/item/rogueweapon/spear/bronze,
		"Bronze Whip" = /obj/item/rogueweapon/whip/bronze,

		"Copper Cudgel" = /obj/item/rogueweapon/mace/cudgel/copper,
		"Copper Heart Protector" = /obj/item/clothing/suit/roguetown/armor/plate/half/copper,
		"Copper Lamellar Cap" = /obj/item/clothing/head/roguetown/helmet/coppercap,
		"Copper Messer" = /obj/item/rogueweapon/sword/short/messer/copper,
		"Copper Rhomphaia" = /obj/item/rogueweapon/sword/long/rhomphaia/copper,
		"Copper Spear" = /obj/item/rogueweapon/spear/stone/copper,

		"Recurve Bow" = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve,
		"Quiver (Arrows)" = /obj/item/quiver/arrows
	)

	// Bronze and Copper Daily Tools - preset combinations (Axe + Dagger/Knife + Sheath)
	var/daily_tools_combos = list(
		"Bronze Axe + Bronze Knife + Sheath" = list(/obj/item/rogueweapon/stoneaxe/woodcut/bronze, /obj/item/rogueweapon/huntingknife/bronze, /obj/item/rogueweapon/scabbard/sheath),
		"Copper Hatchet + Copper Knife + Sheath" = list(/obj/item/rogueweapon/stoneaxe/handaxe/copper, /obj/item/rogueweapon/huntingknife/copper, /obj/item/rogueweapon/scabbard/sheath)
	)

	// Utility and Knowledge items
	var/utility_knowledge_items = list(
		"Bedroll" = /obj/item/bedroll,
		"Cooking Pan" = /obj/item/cooking/pan,
		"Fishing Rod" = /obj/item/fishingrod/crafted,
		"Folding Table" = /obj/item/contraption/folding_table_stored,
		"Hammer" = /obj/item/rogueweapon/hammer/steel,
		"Hoe" = /obj/item/rogueweapon/hoe,
		"Lockpick Ring" = /obj/item/lockpickring/mundane,
		"Alchemical Pouch" = /obj/item/storage/magebag,
		"Hunting Bag" = /obj/item/storage/meatbag,
		"Millstone" = /obj/item/millstone,
		"Musical Instrument" = pick(subtypesof(/obj/item/rogue/instrument)),
		"Pick" = /obj/item/rogueweapon/pick,
		"Scissors" = /obj/item/rogueweapon/huntingknife/scissors,
		"Surgery Bag" = /obj/item/storage/belt/rogue/surgery_bag/full,
		"Great Weapon Strap" = /obj/item/rogueweapon/scabbard/gwstrap,
		"Medicine Pouch" = /obj/item/storage/belt/rogue/pouch/medicine,
		"Food Bag" = /obj/item/storage/roguebag/food,

		"Diagnose Spell" = /obj/effect/proc_holder/spell/invoked/diagnose/secular,
		"Appraise Spell" = /obj/effect/proc_holder/spell/invoked/appraise/secular,
		"Find Familiar Spell" = /obj/effect/proc_holder/spell/self/findfamiliar,
		"Take Apprentice Spell" = /obj/effect/proc_holder/spell/invoked/takeapprentice
	)

	if(H.mind)
		// Select one daily tools combo
		var/combo_name = input(H, "Choose a daily tools combination [1/1].", "Daily Tools") as anything in daily_tools_combos
		if(combo_name)
			var/combo_list = daily_tools_combos[combo_name]
			var/counter = 1
			for(var/item_path in combo_list)
				var/unique_key = "[combo_name] [counter]"
				H.mind.special_items[unique_key] = item_path
				counter++

		// Select three individual bronze/copper items
		for(var/i in 1 to 3)
			var/bronze_copper_name = input(H, "Choose a bronze or copper item [i]/3.", "Bronze/Copper Items") as anything in bronze_copper_items
			if(bronze_copper_name)
				H.mind.special_items[bronze_copper_name] = bronze_copper_items[bronze_copper_name]
				// Grant APPRENTICE level skill for bronze/copper weapons
				switch(bronze_copper_name)
					if("Bronze Arming Sword", "Copper Messer", "Copper Rhomphaia")
						H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_APPRENTICE, TRUE)
					if("Bronze Katar", "Bronze Knuckles")
						H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_APPRENTICE, TRUE)
						H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_APPRENTICE, TRUE)
					if("Bronze Mace", "Copper Cudgel")
						H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_APPRENTICE, TRUE)
					if("Bronze Spear", "Copper Spear")
						H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_APPRENTICE, TRUE)
					if("Bronze Whip")
						H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_APPRENTICE, TRUE)
					if("Recurve Bow", "Quiver (Arrows)")
						H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_NOVICE, TRUE)
				if(bronze_copper_name in bronze_copper_items)
					bronze_copper_items -= bronze_copper_name

		// Select three utility/knowledge items
		for(var/i in 1 to 7)
			var/utility_name = input(H, "Choose a Utility Apparatus or Knowledge item [i]/7.", "Utility & Knowledge") as anything in utility_knowledge_items
			if(utility_name)
				var/item_path = utility_knowledge_items[utility_name]
				if(ispath(item_path, /obj/effect/proc_holder/spell))
					// Handle spells - add directly to mind
					H.AddSpell(new item_path)
				else
					// Handle regular items - add to special_items
					H.mind.special_items[utility_name] = item_path
				if(utility_name in utility_knowledge_items)
					utility_knowledge_items -= utility_name

// Still random clothing... meh. Get your loadout ones.
	head = pick(/obj/item/clothing/head/roguetown/hatfur,
	/obj/item/clothing/head/roguetown/hatblu,
	/obj/item/clothing/head/roguetown/nightman,
	/obj/item/clothing/head/roguetown/roguehood,
	/obj/item/clothing/head/roguetown/roguehood/random,
	/obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood,
	/obj/item/clothing/head/roguetown/fancyhat)

	if(prob(50))
		mask = /obj/item/clothing/mask/rogue/spectacles

	cloak = pick(/obj/item/clothing/cloak/raincloak/furcloak,
	/obj/item/clothing/cloak/half)

	armor = pick(/obj/item/clothing/suit/roguetown/armor/workervest,
	/obj/item/clothing/suit/roguetown/armor/leather/vest)

	pants = pick(/obj/item/clothing/under/roguetown/trou,
	/obj/item/clothing/under/roguetown/tights/random)

	shirt = pick(/obj/item/clothing/suit/roguetown/shirt/undershirt/random,
	/obj/item/clothing/suit/roguetown/shirt/undershirt/puritan,
	/obj/item/clothing/suit/roguetown/armor/gambeson/light)

	shoes = pick(/obj/item/clothing/shoes/roguetown/boots/leather,
	/obj/item/clothing/shoes/roguetown/shortboots)

	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	backl = /obj/item/storage/backpack/rogue/backpack

//Debloats their contents
	backpack_contents = list(
						/obj/item/flint = 1,
						/obj/item/rogueweapon/handsaw = 1,
						/obj/item/dye_brush = 1,
						/obj/item/reagent_containers/powder/salt = 1,
						/obj/item/reagent_containers/food/snacks/rogue/cheddar = 2,
						/obj/item/natural/cloth = 2,
						/obj/item/flashlight/flare/torch/lantern = 1,
//						/obj/item/book/rogue/yeoldecookingmanual = 1,
//						/obj/item/natural/worms = 2,
						/obj/item/rogueweapon/shovel/small = 1,
						/obj/item/rogueweapon/chisel = 1,
	)

	if(H.mind)
		// Skill selection with readable names
		var/misc_skills = list(
			"Stealing" = /datum/skill/misc/stealing,
			"Music" = /datum/skill/misc/music,
			"Reading" = /datum/skill/misc/reading,
			"Medicine" = /datum/skill/misc/medicine,
			"Tracking" = /datum/skill/misc/tracking,
			"Lockpicking" = /datum/skill/misc/lockpicking,
			"Sneaking" = /datum/skill/misc/sneaking,
			"Riding" = /datum/skill/misc/riding
		)
		var/labor_skills = list(
			"Farming" = /datum/skill/labor/farming,
			"Lumberjacking" = /datum/skill/labor/lumberjacking,
			"Fishing" = /datum/skill/labor/fishing,
			"Butchering" = /datum/skill/labor/butchering,
			"Mining" = /datum/skill/labor/mining
		)
		var/craft_skills = list(
			"Sewing" = /datum/skill/craft/sewing,
			"Ceramics" = /datum/skill/craft/ceramics,
			"Carpentry" = /datum/skill/craft/carpentry,
			"Masonry" = /datum/skill/craft/masonry,
			"Engineering" = /datum/skill/craft/engineering,
			"Traps" = /datum/skill/craft/traps,
			"Alchemy" = /datum/skill/craft/alchemy,
			"Tanning" = /datum/skill/craft/tanning,
			"Cooking" = /datum/skill/craft/cooking,
			"Weaponsmithing" = /datum/skill/craft/weaponsmithing,
			"Armorsmithing" = /datum/skill/craft/armorsmithing,
			"Blacksmithing" = /datum/skill/craft/blacksmithing,
			"Smelting" = /datum/skill/craft/smelting
		)
		var/combat_skills = list(
			"Axes" = /datum/skill/combat/axes,
			"Unarmed" = /datum/skill/combat/unarmed,
			"Knives" = /datum/skill/combat/knives,
			"Wrestling" = /datum/skill/combat/wrestling,
			"Staves" = /datum/skill/combat/staves,
			"Whips & Flails" = /datum/skill/combat/whipsflails,
			"Bows" = /datum/skill/combat/bows,
			"Crossbows" = /datum/skill/combat/crossbows,
			"Polearms" = /datum/skill/combat/polearms,
			"Shields" = /datum/skill/combat/shields,
			"Slings" = /datum/skill/combat/slings,
			"Swords" = /datum/skill/combat/swords,
			"Maces" = /datum/skill/combat/maces
		)

		// Select one skill to EXPERT
		var/expert_skill_name = input(H, "Choose one skill to EXPERT. [1/1]", "Skill Selection") as anything in misc_skills + labor_skills + craft_skills
		if(expert_skill_name)
			H.adjust_skillrank_up_to(misc_skills[expert_skill_name] || labor_skills[expert_skill_name] || craft_skills[expert_skill_name], SKILL_LEVEL_EXPERT, TRUE)
			if(expert_skill_name in misc_skills)
				misc_skills -= expert_skill_name
			if(expert_skill_name in labor_skills)
				labor_skills -= expert_skill_name
			if(expert_skill_name in craft_skills)
				craft_skills -= expert_skill_name 

		// Select one COMBAT skill to JOURNEYMAN
		var/journeyman_combat_name = input(H, "Choose a COMBAT skill to JOURNEYMAN. [1/1]", "Skill Selection") as anything in combat_skills
		if(journeyman_combat_name)
			H.adjust_skillrank_up_to(combat_skills[journeyman_combat_name], SKILL_LEVEL_JOURNEYMAN, TRUE)
			if(journeyman_combat_name in combat_skills)
				combat_skills -= journeyman_combat_name

		// Select two MISC/LABOR/CRAFT skills to JOURNEYMAN
		for(var/i in 1 to 2)
			var/journeyman_name = input(H, "Choose a MISC/LABOR/CRAFT skill to JOURNEYMAN. [i]/2", "Skill Selection") as anything in misc_skills + labor_skills + craft_skills
			if(journeyman_name)
				H.adjust_skillrank_up_to(misc_skills[journeyman_name] || labor_skills[journeyman_name] || craft_skills[journeyman_name], SKILL_LEVEL_JOURNEYMAN, TRUE)
				if(journeyman_name in misc_skills)
					misc_skills -= journeyman_name
				if(journeyman_name in labor_skills)
					labor_skills -= journeyman_name
				if(journeyman_name in craft_skills)
					craft_skills -= journeyman_name

		// Select three skills to APPRENTICE
		for(var/i in 1 to 3)
			var/apprentice_name = input(H, "Choose a skill to APPRENTICE. [i]/3", "Skill Selection") as anything in misc_skills + labor_skills + craft_skills + combat_skills
			if(apprentice_name)
				H.adjust_skillrank_up_to(misc_skills[apprentice_name] || labor_skills[apprentice_name] || craft_skills[apprentice_name] || combat_skills[apprentice_name], SKILL_LEVEL_APPRENTICE, TRUE)
				if(apprentice_name in misc_skills)
					misc_skills -= apprentice_name
				if(apprentice_name in labor_skills)
					labor_skills -= apprentice_name
				if(apprentice_name in craft_skills)
					craft_skills -= apprentice_name
				if(apprentice_name in combat_skills)
					combat_skills -= apprentice_name

		// Select four skills to NOVICE
		for(var/i in 1 to 6)
			var/novice_name = input(H, "Choose a skill to NOVICE. [i]/6", "Skill Selection") as anything in misc_skills + labor_skills + craft_skills + combat_skills
			if(novice_name)
				H.adjust_skillrank_up_to(misc_skills[novice_name] || labor_skills[novice_name] || craft_skills[novice_name] || combat_skills[novice_name], SKILL_LEVEL_NOVICE, TRUE)
				if(novice_name in misc_skills)
					misc_skills -= novice_name
				if(novice_name in labor_skills)
					labor_skills -= novice_name
				if(novice_name in craft_skills)
					craft_skills -= novice_name
				if(novice_name in combat_skills)
					combat_skills -= novice_name

		// TRAIT SELECTION
		// Skill-unlocking traits
		var/skill_unlock_traits = list(
			"Homestead Expert" = TRAIT_HOMESTEAD_EXPERT,
			"Alchemy Expert" = TRAIT_ALCHEMY_EXPERT,
			"Survival Expert" = TRAIT_SURVIVAL_EXPERT,
			"Sewing Expert" = TRAIT_SEWING_EXPERT
		)
		
		// Non-skill-locking traits
		var/regular_traits = list( //Actual survival suff
			"Outdoorsman" = TRAIT_OUTDOORSMAN,
			"Woodwalker" = TRAIT_WOODWALKER,
			"Sleuth" = TRAIT_SLEUTH,
			"Native Of the Land" = TRAIT_AZURENATIVE,
			"Light Step" = TRAIT_LIGHT_STEP,
			"Perfect Tracker" = TRAIT_PERFECT_TRACKER,
			"Woodsman" = TRAIT_WOODSMAN,
			"Seed Knowledge" = TRAIT_SEEDKNOW,

			"Dyes Master" = TRAIT_DYES, // More RP centric stuff
			"Intellectual" = TRAIT_INTELLECTUAL,
			"Good Lover" = TRAIT_GOODLOVER,
			"Empath" = TRAIT_EMPATH,
			"See Prices (Shitty)" = TRAIT_SEEPRICES_SHITTY,
			"Beautiful" = TRAIT_BEAUTIFUL,
			"Cicerone" = TRAIT_CICERONE,
			"Keen Ears" = TRAIT_KEENEARS
		)

		// Select two skill-unlocking traits
		for(var/i in 1 to 2)
			var/skill_trait_name = input(H, "Choose a skill-unlocking trait [i]/2.", "Trait Selection") as anything in skill_unlock_traits
			if(skill_trait_name)
				ADD_TRAIT(H, skill_unlock_traits[skill_trait_name], TRAIT_GENERIC)
				if(skill_trait_name in skill_unlock_traits)
					skill_unlock_traits -= skill_trait_name

		// Select four regular traits
		for(var/i in 1 to 4)
			var/regular_trait_name = input(H, "Choose a trait [i]/4.", "Trait Selection") as anything in regular_traits
			if(regular_trait_name)
				ADD_TRAIT(H, regular_traits[regular_trait_name], TRAIT_GENERIC)
				if(regular_trait_name in regular_traits)
					regular_traits -= regular_trait_name
