#define VALID_FISHING_SPOTS list(\
	/turf/open/water/river,\
	/turf/open/water/cleanshallow,\
	/turf/open/water/ocean,\
	/turf/open/water/ocean/deep,\
	/turf/open/water/swamp,\
	/turf/open/water/swamp/deep )

//Valid spots for fishing add to it if there's more.
/proc/is_valid_fishing_spot(turf/T)
	for(var/i in VALID_FISHING_SPOTS)
		if(istype(T, i))
			return TRUE
	return FALSE

/proc/createFreshWaterFishWeightList(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod)
	var/list/weightList = list(
		/obj/item/reagent_containers/food/snacks/fish/carp = 270*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/sunny = 340*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/salmon = 180*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/eel = 180*commonMod,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1*treasureMod + 15*ceruleanMod,
		/obj/item/clothing/ring/gold = 1*treasureMod + 15*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1*treasureMod + 50*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 10*ceruleanMod,
		/obj/item/grown/log/tree/stick = 1*trashMod,
		/obj/item/natural/cloth = 1*trashMod,
		/obj/item/ammo_casing/caseless/rogue/arrow = 1*trashMod,
		/obj/item/reagent_containers/glass/bottle/rogue = 1*trashMod,
		/obj/item/reagent_containers/food/snacks/smallrat = 1, //That's not a fish...?
 		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 30,
	)
	return counterlist_ceiling(weightList)

/proc/createFreshWaterFishWeightListModlist(list/fishingMods)
	return createFreshWaterFishWeightList(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"])

/proc/createCoastalSeaFishWeightList(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod)
	var/weightList = list (
		/obj/item/reagent_containers/food/snacks/fish/cod = 210*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/plaice = 70*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/sole = 300*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/angler = 60*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 70*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/bass = 210*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/clam = 40*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 10*rareMod + 100*ceruleanMod,
		/obj/item/reagent_containers/food/snacks/fish/creepy_eel = 1*rareMod + 10*ceruleanMod,
		/obj/item/reagent_containers/food/snacks/fish/creepy_squid = 5*rareMod + 10*ceruleanMod,
		/obj/item/reagent_containers/food/snacks/fish/creepy_shark = 1*rareMod + 10*ceruleanMod,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1*treasureMod + 15*ceruleanMod,
		/obj/item/clothing/ring/gold = 1*treasureMod + 15*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1*treasureMod + 50*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 10*ceruleanMod,
		/obj/item/grown/log/tree/stick =  1*trashMod,
		/obj/item/natural/cloth = 1*trashMod,
		/obj/item/ammo_casing/caseless/rogue/arrow = 1*trashMod,
		/obj/item/reagent_containers/glass/bottle/rogue = 1*trashMod,
		/obj/item/reagent_containers/food/snacks/smallrat = 1, //That's not a coastal fish...?
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 30,
	)
	return counterlist_ceiling(weightList)

/proc/createCoastalSeaFishWeightListModlist(list/fishingMods)
	return createCoastalSeaFishWeightList(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"])

/proc/createDeepSeaFishWeightList(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod)
	var/weightList = list (
		/obj/item/reagent_containers/food/snacks/fish/cod = 100*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/plaice = 150*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/sole = 50*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/angler = 150*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 100*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/bass = 100*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/clam = 150*rareMod,
		/obj/item/roguegem/oyster = 40*rareMod + 10*treasureMod,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 50*rareMod + 200*ceruleanMod,
		/obj/item/reagent_containers/food/snacks/fish/creepy_eel = 2*rareMod + 10*ceruleanMod,
		/obj/item/reagent_containers/food/snacks/fish/creepy_squid = 7*rareMod + 10*ceruleanMod,
		/obj/item/reagent_containers/food/snacks/fish/creepy_shark = 2*rareMod + 10*ceruleanMod,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1*treasureMod + 30*ceruleanMod,
		/obj/item/clothing/ring/gold = 1*treasureMod + 30*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1*treasureMod + 75*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 40*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 15*ceruleanMod,
		/obj/item/reagent_containers/glass/bottle/rogue = 1*trashMod,
		/obj/item/reagent_containers/food/snacks/smallrat = 1, //That's not a deep sea fish...?
		/mob/living/carbon/human/species/goblin/npc/sea = 50*dangerMod,
		/mob/living/simple_animal/hostile/rogue/deepone = 50*dangerMod,
		/mob/living/simple_animal/hostile/rogue/deepone/spit = 50*dangerMod,
	)
	return counterlist_ceiling(weightList)

/proc/createDeepSeaFishWeightListModlist(list/fishingMods)
	return createDeepSeaFishWeightList(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"])

/proc/createMudFishWeightList(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod)
	var/weightList = list (
		/obj/item/reagent_containers/food/snacks/fish/mudskipper = 790*commonMod,
		/obj/item/natural/worms/leech = 180*rareMod,
 		/obj/item/clothing/ring/gold = 1*treasureMod + 30*ceruleanMod,
		/obj/item/reagent_containers/food/snacks/smallrat = 1, //Thats one dirty... not a fish...?
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 30,
	)
	return counterlist_ceiling(weightList)

/proc/createMudFishWeightListModlist(list/fishingMods)
	return createMudFishWeightList(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"])

/proc/createCageFishWeightList(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod)
	var/weightList = list(
			/obj/item/reagent_containers/food/snacks/fish/oyster = 250*commonMod,
			/obj/item/reagent_containers/food/snacks/fish/shrimp = 250*commonMod,
			/obj/item/reagent_containers/food/snacks/fish/crab = 250*rareMod,
			/obj/item/reagent_containers/food/snacks/fish/lobster = 250*commonMod,
			/obj/item/reagent_containers/food/snacks/smallrat = 1, //Oh for fucks sake!
		)
	return counterlist_ceiling(weightList)

/proc/createCageFishWeightListModlist(list/fishingMods)
	return createCageFishWeightList(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"])

// Hand fishing pools - Only big fish and clams, more trash and treasure, no small stuff like shrimp
/proc/createHandFishingFreshWaterPool(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod)
	var/list/weightList = list(
		// Big fish that can be grabbed
		/obj/item/reagent_containers/food/snacks/fish/carp = 150*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/salmon = 100*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/eel = 120*commonMod,
		// More treasure
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 3*treasureMod,
		/obj/item/clothing/ring/gold = 2*treasureMod,
		/obj/item/clothing/ring/silver = 3*treasureMod,
		/obj/item/roguegem/blue = 1*treasureMod,
		/obj/item/roguegem/green = 1*treasureMod,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 4*treasureMod,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1*treasureMod,
		// More trash
		/obj/item/grown/log/tree/stick = 4*trashMod,
		/obj/item/natural/cloth = 3*trashMod,
		/obj/item/natural/fibers = 3*trashMod,
		/obj/item/natural/stone = 2*trashMod,
		/obj/item/natural/bone = 2*trashMod,
		/obj/item/clothing/shoes/roguetown/simpleshoes = 2*trashMod,
		/obj/item/rope = 2*trashMod,
		/obj/item/ammo_casing/caseless/rogue/arrow = 2*trashMod,
		/obj/item/reagent_containers/glass/bottle/rogue = 4*trashMod,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 20,
	)
	return counterlist_ceiling(weightList)

/proc/createHandFishingFreshWaterPoolModlist(list/fishingMods)
	return createHandFishingFreshWaterPool(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"])

/proc/createHandFishingSeaPool(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod)
	var/list/weightList = list(
		// Big fish
		/obj/item/reagent_containers/food/snacks/fish/cod = 100*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/angler = 80*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/bass = 100*commonMod,
		// Clams and shellfish - more common in sea
		/obj/item/reagent_containers/food/snacks/fish/clam = 120*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 60*rareMod,
		// Treasure
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 3*treasureMod,
		/obj/item/clothing/ring/gold = 2*treasureMod,
		/obj/item/clothing/ring/silver = 3*treasureMod,
		/obj/item/roguegem/blue = 2*treasureMod,
		/obj/item/roguegem/green = 1*treasureMod,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 3*treasureMod,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 2*treasureMod,
		// Trash
		/obj/item/grown/log/tree/stick = 3*trashMod,
		/obj/item/natural/cloth = 3*trashMod,
		/obj/item/natural/fibers = 4*trashMod,
		/obj/item/natural/stone = 2*trashMod,
		/obj/item/natural/bone = 2*trashMod,
		/obj/item/clothing/shoes/roguetown/simpleshoes = 2*trashMod,
		/obj/item/rope = 3*trashMod,
		/obj/item/ammo_casing/caseless/rogue/arrow = 2*trashMod,
		/obj/item/reagent_containers/glass/bottle/rogue = 3*trashMod,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 30,
	)
	return counterlist_ceiling(weightList)

/proc/createHandFishingSeaPoolModlist(list/fishingMods)
	return createHandFishingSeaPool(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"])

/proc/createHandFishingDeepSeaPool(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod)
	var/list/weightList = list(
		// Deep sea big fish
		/obj/item/reagent_containers/food/snacks/fish/cod = 80*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/angler = 100*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/bass = 70*commonMod,
		// More shellfish in deep sea
		/obj/item/reagent_containers/food/snacks/fish/clam = 140*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 90*rareMod,
		/obj/item/roguegem/oyster = 50*rareMod,
		// More treasure in deep
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 5*treasureMod,
		/obj/item/clothing/ring/gold = 4*treasureMod,
		/obj/item/clothing/ring/silver = 4*treasureMod,
		/obj/item/roguegem/blue = 3*treasureMod,
		/obj/item/roguegem/green = 2*treasureMod,
		/obj/item/roguegem/amethyst = 1*treasureMod,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 5*treasureMod,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 3*treasureMod,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1*treasureMod,
		// Trash
		/obj/item/grown/log/tree/stick = 2*trashMod,
		/obj/item/natural/cloth = 3*trashMod,
		/obj/item/natural/fibers = 3*trashMod,
		/obj/item/natural/stone = 2*trashMod,
		/obj/item/natural/bone = 3*trashMod,
		/obj/item/clothing/shoes/roguetown/simpleshoes = 2*trashMod,
		/obj/item/rope = 2*trashMod,
		/obj/item/reagent_containers/glass/bottle/rogue = 3*trashMod,
	)
	return counterlist_ceiling(weightList)

/proc/createHandFishingDeepSeaPoolModlist(list/fishingMods)
	return createHandFishingDeepSeaPool(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"])

/proc/createHandFishingMurkPool(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod)
	var/list/weightList = list(
		// Murk fish - only a few big ones
		/obj/item/reagent_containers/food/snacks/fish/mudskipper = 150*commonMod,
		/obj/item/natural/worms/leech = 80*rareMod,
		// LOTS more trash in murk
		/obj/item/grown/log/tree/stick = 8*trashMod,
		/obj/item/natural/cloth = 6*trashMod,
		/obj/item/natural/fibers = 7*trashMod,
		/obj/item/natural/stone = 5*trashMod,
		/obj/item/natural/bone = 5*trashMod,
		/obj/item/clothing/shoes/roguetown/simpleshoes = 4*trashMod,
		/obj/item/clothing/shoes/roguetown/boots = 3*trashMod,
		/obj/item/rope = 5*trashMod,
		/obj/item/ammo_casing/caseless/rogue/arrow = 4*trashMod,
		/obj/item/reagent_containers/glass/bottle/rogue = 7*trashMod,
		// More treasure in murk (sunken goods)
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 6*treasureMod,
		/obj/item/clothing/ring/gold = 5*treasureMod,
		/obj/item/clothing/ring/silver = 6*treasureMod,
		/obj/item/roguegem/blue = 3*treasureMod,
		/obj/item/roguegem/green = 3*treasureMod,
		/obj/item/roguegem/amethyst = 2*treasureMod,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 7*treasureMod,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 3*treasureMod,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1*treasureMod,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 20,
	)
	return counterlist_ceiling(weightList)

/proc/createHandFishingMurkPoolModlist(list/fishingMods)
	return createHandFishingMurkPool(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"])

// Helpers for filtering fish pools
/proc/is_fish_item(item_type)
	// Returns TRUE if the item type is only a fish (food snack fish)
	return ispath(item_type, /obj/item/reagent_containers/food/snacks/fish)

/proc/is_dangerous_catch(catch_type)
	// Returns TRUE if the catch is a dangerous mob
	return (ispath(catch_type, /mob/living/simple_animal/hostile) || \
			ispath(catch_type, /mob/living/carbon/human/species/goblin/npc/sea) || \
			ispath(catch_type, /mob/living/simple_animal/hostile/rogue/deepone))

/proc/filterPoolFishOnly(list/weightList)
	// Returns a new weighted list containing only fish items
	var/list/fishOnlyList = list()
	for(var/item_type in weightList)
		if(is_fish_item(item_type))
			fishOnlyList[item_type] = weightList[item_type]
	return counterlist_ceiling(fishOnlyList)

/proc/filterPoolGrabbable(list/weightList)
	// Returns a weighted list excluding dangerous mobs
	var/list/grabbableList = list()
	for(var/item_type in weightList)
		if(!is_dangerous_catch(item_type))
			grabbableList[item_type] = weightList[item_type]
	return counterlist_ceiling(grabbableList)

/proc/calculateBiteFishingSuccess(mob/living/carbon/human/user)
	// Calculate success chance (0-100) for bite fishing
	// Much lower than using tools: Base 20% + tiny stat help + HUGE skill bonus
	var/success_chance = 20

	// Strength adds grip (1% per 2 points, max 4%)
	success_chance += min(4, (user.STASTR - 10) / 2 * 1)

	// Perception adds awareness (2% per 2 points, max 8%)
	success_chance += min(8, (user.STAPER - 10) / 2 * 2)

	// Fishing skill bonus (up to 66% for legendary) - SKILL IS EVERYTHING!
	var/skill_level = user.get_skill_level(/datum/skill/labor/fishing)
	success_chance += skill_level * 6

	return min(90, success_chance) // Cap at 90% with perfect skill and stats

/proc/calculateBiteFishingSpeed(mob/living/carbon/human/user)
	// Calculate catch time in deciseconds for bite fishing
	// Bite fishing should be MUCH slower than using proper tools
	var/catch_time = 500 // 50 seconds base - way slower than rod (12s)

	// Speed reduces time slightly (1% per 2 points, max 5% reduction)
	var/speed_bonus = min(5, (user.STASPD - 10) / 2 * 1)
	catch_time *= (100 - speed_bonus) / 100

	// Perception helps minimally (0.5% per 2 points, max 2% reduction)
	var/perception_bonus = min(2, (user.STAPER - 10) / 2 * 0.5)
	catch_time *= (100 - perception_bonus) / 100

	// Fishing skill bonus is DOMINANT (up to 70% reduction for legendary) - SKILL IS EVERYTHING!
	var/skill_level = user.get_skill_level(/datum/skill/labor/fishing)
	var/skill_bonus = min(70, skill_level * 6.36)
	catch_time *= (100 - skill_bonus) / 100

	return max(120, catch_time) // Minimum 12 seconds with legendary skill
