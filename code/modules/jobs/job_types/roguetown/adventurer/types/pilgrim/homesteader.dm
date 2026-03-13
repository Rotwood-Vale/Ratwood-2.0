/datum/advclass/homesteader
	name = "Commoner"
	tutorial = "You are not bound to any guild or master's service. Where others specialize in a single craft, you have learned to adapt - taking whatever work comes your way. Whether you become a skilled artisan, a wilderness survivalist, or something else entirely, your path is yours to forge. What trade will you pursue today?"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/homesteader
	maximum_possible_slots = 10 // Should never fill, for the purpose of players to know what types towners are in round at the menu
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)
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
	"Angler",
	"Artisan", "Artisana",
	"Butcher",
	"Craftsman", "Craftswoman",
	"Devotee", "Devotess",
	"Fieldworker",
	"Forager",
	"Forester",
	"Freeholder",
	"Gardener",
	"Handiworker",
	"Hedgefolk",
	"Herbalist",
	"Homesteader", "Homesteadress",
	"Housekeeper",
	"Householder", "Househusband", "Housewife",
	"Laborer",
	"Mason",
	"Nurse", "Nun",
	"Pioneer",
	"Prospector",
	"Scholar",
	"Scribe",
	"Settler",
	"Shepherd",
	"Smith",
	"Town Doctor",
	"Town Ranger",
	"Tradesman", "Tradewoman",
	"Villager",
	"Weaver",
	"Woodsman", "Woodswoman",
	"Chirurgeon")
	var/cosmetic_choice = input(H, "Select your cosmetic title.", "Cosmetic Titles") as anything in cosmetic_titles

	switch(cosmetic_choice)
		if("Devotee")
			to_chat(H, span_notice("You are a Devotee, a pious peasant devoted to faith and community."))
			H.mind.cosmetic_class_title = "Devotee"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Devotess")
			to_chat(H, span_notice("You are a Devotess, a pious peasant devoted to faith and community."))
			H.mind.cosmetic_class_title = "Devotess"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Fieldworker")
			to_chat(H, span_notice("You are a Fieldworker, a laborer of fields and land."))
			H.mind.cosmetic_class_title = "Fieldworker"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Fieldwoman")
			to_chat(H, span_notice("You are a Fieldwoman, a laborer of fields and land."))
			H.mind.cosmetic_class_title = "Fieldwoman"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Handiworker")
			to_chat(H, span_notice("You are a Handiworker, skilled in small crafts and repairs."))
			H.mind.cosmetic_class_title = "Handiworker"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Handiwoman")
			to_chat(H, span_notice("You are a Handiwoman, skilled in small crafts and repairs."))
			H.mind.cosmetic_class_title = "Handiwoman"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Hedgefolk")
			to_chat(H, span_notice("You are Hedgefolk, a rural dweller of modest means."))
			H.mind.cosmetic_class_title = "Hedgefolk"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Herbalist")
			to_chat(H, span_notice("You are an Herbalist, skilled in plants and their remedies."))
			H.mind.cosmetic_class_title = "Herbalist"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Homesteader")
			to_chat(H, span_notice("You are a Homesteader, a settler and keeper of land."))
			H.mind.cosmetic_class_title = "Homesteader"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Homesteadress")
			to_chat(H, span_notice("You are a Homesteadress, a settler and keeper of land."))
			H.mind.cosmetic_class_title = "Homesteadress"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Householder")
			to_chat(H, span_notice("You are a Householder, a keeper of dwelling and family."))
			H.mind.cosmetic_class_title = "Householder"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Househusband")
			to_chat(H, span_notice("You are a Househusband, a keeper of dwelling and family."))
			H.mind.cosmetic_class_title = "Househusband"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Housewife")
			to_chat(H, span_notice("You are a Housewife, a keeper of dwelling and family."))
			H.mind.cosmetic_class_title = "Housewife"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Laborer")
			to_chat(H, span_notice("You are a Laborer, a hard worker and commoner."))
			H.mind.cosmetic_class_title = "Laborer"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Laboress")
			to_chat(H, span_notice("You are a Laboress, a hard worker and commoner."))
			H.mind.cosmetic_class_title = "Laboress"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Villager")
			to_chat(H, span_notice("You are a Villager, common folk of the settlement."))
			H.mind.cosmetic_class_title = "Villager"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Villagewoman")
			to_chat(H, span_notice("You are a Villagewoman, common folk of the settlement."))
			H.mind.cosmetic_class_title = "Villagewoman"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Artisan")
			to_chat(H, span_notice("You are an Artisan, skilled in your craft and trade."))
			H.mind.cosmetic_class_title = "Artisan"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Artisana")
			to_chat(H, span_notice("You are an Artisana, skilled in your craft and trade."))
			H.mind.cosmetic_class_title = "Artisana"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Pioneer")
			to_chat(H, span_notice("You are a Pioneer, a brave settler of new lands."))
			H.mind.cosmetic_class_title = "Pioneer"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Pioneress")
			to_chat(H, span_notice("You are a Pioneress, a brave settler of new lands."))
			H.mind.cosmetic_class_title = "Pioneress"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Settler")
			to_chat(H, span_notice("You are a Settler, one who makes a home in strange lands."))
			H.mind.cosmetic_class_title = "Settler"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Settleress")
			to_chat(H, span_notice("You are a Settleress, one who makes a home in strange lands."))
			H.mind.cosmetic_class_title = "Settleress"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Tradesman")
			to_chat(H, span_notice("You are a Tradesman, skilled in commerce and craft."))
			H.mind.cosmetic_class_title = "Tradesman"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Tradewoman")
			to_chat(H, span_notice("You are a Tradewoman, skilled in commerce and craft."))
			H.mind.cosmetic_class_title = "Tradewoman"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Woodsman")
			to_chat(H, span_notice("You are a Woodsman, at home in forest and timber."))
			H.mind.cosmetic_class_title = "Woodsman"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Woodswoman")
			to_chat(H, span_notice("You are a Woodswoman, at home in forest and timber."))
			H.mind.cosmetic_class_title = "Woodswoman"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Craftsman")
			to_chat(H, span_notice("You are a Craftsman, skilled in your trade."))
			H.mind.cosmetic_class_title = "Craftsman"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Craftswoman")
			to_chat(H, span_notice("You are a Craftswoman, skilled in your trade."))
			H.mind.cosmetic_class_title = "Craftswoman"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Forager")
			to_chat(H, span_notice("You are a Forager, gathering from the wilds."))
			H.mind.cosmetic_class_title = "Forager"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Nurse")
			to_chat(H, span_notice("You are a Nurse, caring for the sick and wounded."))
			H.mind.cosmetic_class_title = "Nurse"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Nun")
			to_chat(H, span_notice("You are a Nun, devoted to faith and service."))
			H.mind.cosmetic_class_title = "Nun"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Chirurgeon")
			to_chat(H, span_notice("You are a Chirurgeon, skilled in surgical arts and healing."))
			H.mind.cosmetic_class_title = "Chirurgeon"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Angler")
			to_chat(H, span_notice("You are an Angler, skilled in fishing and catching."))
			H.mind.cosmetic_class_title = "Angler"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Weaver")
			to_chat(H, span_notice("You are a Weaver, skilled in textiles and cloth."))
			H.mind.cosmetic_class_title = "Weaver"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Mason")
			to_chat(H, span_notice("You are a Mason, skilled in stonework and building."))
			H.mind.cosmetic_class_title = "Mason"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Forester")
			to_chat(H, span_notice("You are a Forester, keeper of woods and timber."))
			H.mind.cosmetic_class_title = "Forester"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Town Ranger")
			to_chat(H, span_notice("You are a Town Ranger, protector of roads and wilderness."))
			H.mind.cosmetic_class_title = "Town Ranger"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Prospector")
			to_chat(H, span_notice("You are a Prospector, seeking minerals and fortune."))
			H.mind.cosmetic_class_title = "Prospector"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Freeholder")
			to_chat(H, span_notice("You are a Freeholder, owner of your own land."))
			H.mind.cosmetic_class_title = "Freeholder"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Housekeeper")
			to_chat(H, span_notice("You are a Housekeeper, maintaining home and hearth."))
			H.mind.cosmetic_class_title = "Housekeeper"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Town Doctor")
			to_chat(H, span_notice("You are a Town Doctor, healer of the common folk."))
			H.mind.cosmetic_class_title = "Town Doctor"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Scribe")
			to_chat(H, span_notice("You are a Scribe, keeper of records and letters."))
			H.mind.cosmetic_class_title = "Scribe"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Scholar")
			to_chat(H, span_notice("You are a Scholar, learned in books and knowledge."))
			H.mind.cosmetic_class_title = "Scholar"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Butcher")
			to_chat(H, span_notice("You are a Butcher, skilled in meat and trade."))
			H.mind.cosmetic_class_title = "Butcher"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Gardener")
			to_chat(H, span_notice("You are a Gardener, tending plants and soil."))
			H.mind.cosmetic_class_title = "Gardener"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Shepherd")
			to_chat(H, span_notice("You are a Shepherd, keeper of flocks."))
			H.mind.cosmetic_class_title = "Shepherd"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Smith")
			to_chat(H, span_notice("You are a Smith, forger of metal and tools."))
			H.mind.cosmetic_class_title = "Smith"
			H.social_rank = SOCIAL_RANK_YEOMAN


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
		if("Bookworm - INT +1, PER +2, WIL +2, STR -2, CON -2")
			to_chat(H, span_notice("You are learned and wise."))
			H.change_stat(STATKEY_INT, 1)
			H.change_stat(STATKEY_PER, 2)
			H.change_stat(STATKEY_WIL, 2)
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
	// Profession Set Combinations
	var/profession_sets = list(
		"Physiker Set" = list(
			/obj/item/bedroll,
			/obj/item/rogueweapon/huntingknife/scissors,
			/obj/item/storage/belt/rogue/surgery_bag/full,
			/obj/item/storage/belt/rogue/pouch/medicine,
			/obj/effect/proc_holder/spell/invoked/diagnose/secular,
			/obj/item/storage/magebag/alchemist,
			/obj/item/folding_table_stored
		),
		"Provider Set" = list(
			/obj/item/storage/roguebag/food,
			/obj/item/folding_table_stored,
			/obj/item/storage/meatbag,
			/obj/item/millstone,
			/obj/item/rogueweapon/hoe
		),
		"Prospector Set" = list(
			/obj/item/rogueweapon/hammer/steel,
			/obj/item/folding_table_stored,
			/obj/item/lockpickring/mundane,
			/obj/item/rogueweapon/pick,
			/obj/item/rogueweapon/huntingknife/scissors,
			/obj/item/rogueweapon/scabbard/gwstrap
		)
	)

	// Daily Tools - basic combination
	var/daily_tools_combos = list(
		"Bronze Axe + Bronze Knife + Sheath" = list(/obj/item/rogueweapon/stoneaxe/woodcut/bronze, /obj/item/rogueweapon/huntingknife/bronze, /obj/item/rogueweapon/scabbard/sheath),
		"Simple Bow + Quiver" = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow, /obj/item/quiver/arrows)
	)

	if(H.mind)
		// Select two profession sets
		for(var/i in 1 to 1)
			var/profession_set_name = input(H, "Choose a profession set [i]/1.", "Profession Sets") as anything in profession_sets
			if(profession_set_name)
				var/profession_list = profession_sets[profession_set_name]
				var/counter = 1
				for(var/item_path in profession_list)
					if(ispath(item_path, /obj/effect/proc_holder/spell))
						// Handle spells - add directly to mind
						H.AddSpell(new item_path)
					else
						// Handle regular items - add to special_items
						var/unique_key = "[profession_set_name] [counter] [i]"
						H.mind.special_items[unique_key] = item_path
					counter++
				if(profession_set_name in profession_sets)
					profession_sets -= profession_set_name

		// Select one daily tools combo
		var/combo_name = input(H, "Choose a daily tools combination [1/1].", "Daily Tools") as anything in daily_tools_combos
		if(combo_name)
			var/combo_list = daily_tools_combos[combo_name]
			var/counter = 1
			for(var/item_path in combo_list)
				var/unique_key = "[combo_name] [counter]"
				H.mind.special_items[unique_key] = item_path
				counter++

	// OUTFIT SELECTION
	var/outfit_styles = list(
		"Laborer - Worker vest, trou, boots",
		"Field Hand - Straw hat, shortshirt, trou",
		"Woodsman - Hood, workervest, bracers",
		"Fisher - Fisherhat, shortshirt, work vest",
		"Artisan - Tunic, tights, furcloak",
		"Seamster - Armordress, white tunic, cloth belt",
		"Traveler - Half cloak, undershirt, boots",
		"Rustic - Fur hat, shortshirt, leather boots",
		"Miner - Arming cap, trou, work vest",
		"Entertainer - Fancy hat, tunic, half cloak",
		"Modest Scholar - Spectacles, tunic, chaperon",
		"Countryside - Straw hat, chemise, shortboots"
	)
	
	var/outfit_choice = input(H, "Choose your outfit style.", "Outfit Selection") as anything in outfit_styles
	
	// Set base items
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	
	switch(outfit_choice)
		if("Laborer - Worker vest, trou, boots")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
				shoes = /obj/item/clothing/shoes/roguetown/shortboots
				head = /obj/item/clothing/head/roguetown/roguehood/random
			else
				armor = /obj/item/clothing/suit/roguetown/armor/workervest
				pants = /obj/item/clothing/under/roguetown/trou
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather
				head = /obj/item/clothing/head/roguetown/armingcap
		
		if("Field Hand - Straw hat, shortshirt, trou")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
				shoes = /obj/item/clothing/shoes/roguetown/shortboots
			else
				shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
				pants = /obj/item/clothing/under/roguetown/trou
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			head = /obj/item/clothing/head/roguetown/strawhat
		
		if("Woodsman - Hood, workervest, bracers")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			else
				armor = /obj/item/clothing/suit/roguetown/armor/workervest
				pants = /obj/item/clothing/under/roguetown/trou
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			head = /obj/item/clothing/head/roguetown/roguehood
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
		
		if("Fisher - Fisherhat, shortshirt, work vest")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
			else
				pants = /obj/item/clothing/under/roguetown/tights/random
				shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
				armor = /obj/item/clothing/suit/roguetown/armor/workervest
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			head = /obj/item/clothing/head/roguetown/fisherhat
		
		if("Artisan - Tunic, tights, furcloak")
			shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
			pants = /obj/item/clothing/under/roguetown/tights/random
			shoes = /obj/item/clothing/shoes/roguetown/shortboots
			cloak = /obj/item/clothing/cloak/raincloak/furcloak
			head = /obj/item/clothing/head/roguetown/hatblu
		
		if("Seamster - Armordress, white tunic, cloth belt")
			armor = /obj/item/clothing/suit/roguetown/armor/armordress
			shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
			pants = /obj/item/clothing/under/roguetown/tights/random
			shoes = /obj/item/clothing/shoes/roguetown/shortboots
			cloak = /obj/item/clothing/cloak/raincloak/furcloak
			belt = /obj/item/storage/belt/rogue/leather/cloth/lady
		
		if("Traveler - Half cloak, undershirt, boots")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
				shoes = /obj/item/clothing/shoes/roguetown/shortboots
			else
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
				pants = /obj/item/clothing/under/roguetown/trou
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			cloak = /obj/item/clothing/cloak/half
			head = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood
		
		if("Rustic - Fur hat, shortshirt, leather boots")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
			else
				shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
				pants = /obj/item/clothing/under/roguetown/trou
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			head = /obj/item/clothing/head/roguetown/hatfur
		
		if("Miner - Arming cap, trou, work vest")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/brown
			else
				armor = /obj/item/clothing/suit/roguetown/armor/workervest
				pants = /obj/item/clothing/under/roguetown/trou
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
			head = /obj/item/clothing/head/roguetown/armingcap
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather
		
		if("Entertainer - Fancy hat, tunic, half cloak")
			shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
			pants = /obj/item/clothing/under/roguetown/tights/random
			shoes = /obj/item/clothing/shoes/roguetown/shortboots
			cloak = /obj/item/clothing/cloak/half
			head = /obj/item/clothing/head/roguetown/fancyhat
			belt = /obj/item/storage/belt/rogue/leather/cloth
		
		if("Modest Scholar - Spectacles, tunic, chaperon")
			shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
			pants = /obj/item/clothing/under/roguetown/tights/random
			shoes = /obj/item/clothing/shoes/roguetown/shortboots
			head = /obj/item/clothing/head/roguetown/chaperon
			mask = /obj/item/clothing/mask/rogue/spectacles
		
		if("Countryside - Straw hat, chemise, shortboots")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
			else
				shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
				pants = /obj/item/clothing/under/roguetown/trou
			shoes = /obj/item/clothing/shoes/roguetown/shortboots
			head = /obj/item/clothing/head/roguetown/strawhat
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

		// Select four skills to JOURNEYMAN (from any category)
		for(var/i in 1 to 4)
			var/journeyman_name = input(H, "Choose a skill to JOURNEYMAN. [i]/4", "Skill Selection") as anything in misc_skills + labor_skills + craft_skills + combat_skills
			if(journeyman_name)
				H.adjust_skillrank_up_to(misc_skills[journeyman_name] || labor_skills[journeyman_name] || craft_skills[journeyman_name] || combat_skills[journeyman_name], SKILL_LEVEL_JOURNEYMAN, TRUE)
				if(journeyman_name in misc_skills)
					misc_skills -= journeyman_name
				if(journeyman_name in labor_skills)
					labor_skills -= journeyman_name
				if(journeyman_name in craft_skills)
					craft_skills -= journeyman_name
				if(journeyman_name in combat_skills)
					combat_skills -= journeyman_name

		// Select two skills to APPRENTICE
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
		for(var/i in 1 to 5)
			var/novice_name = input(H, "Choose a skill to NOVICE. [i]/5", "Skill Selection") as anything in misc_skills + labor_skills + craft_skills + combat_skills
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
