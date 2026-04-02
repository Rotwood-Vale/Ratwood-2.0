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

/proc/is_cheese_bait(obj/item/I)
	if(!I)
		return FALSE
	return !!findtext("[I.type]", "/cheese")

/proc/get_fish_size_scale(size_tag)
	switch(size_tag)
		if("tiny")
			return 0.75
		if("small")
			return 0.9
		if("large")
			return 1.15
		if("huge")
			return 1.3
		if("prize")
			return 1.45
		else
			return 1

// Tracks chum-enhanced water tiles with original properties as: turf -> list(expiry_time, orig_color, orig_name)
/var/global/list/chummed_fishing_tiles = list()

/proc/apply_chum_to_turf(turf/T, duration = 2 MINUTES)
	if(!T)
		return
	var/world_time_expiry = world.time + duration
	var/orig_color = T.color
	var/orig_name = T.name
	
	// Store expiry and original properties
	chummed_fishing_tiles[T] = list(world_time_expiry, orig_color, orig_name)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(expire_chum_turf), T), duration)
	
	// Visual effect: turn water red/bloody
	T.color = "#8B0000"  // Dark red/blood color
	T.name = "[T.name] (chummed)"

/proc/expire_chum_turf(turf/T)
	if(!T)
		return
	var/expiry_data = chummed_fishing_tiles[T]
	if(!expiry_data)
		return
	var/expiry = expiry_data[1]
	if(world.time < expiry)
		return
	T.color = expiry_data[2]
	T.name = expiry_data[3]
	chummed_fishing_tiles -= T

/proc/is_chummed_fishing_turf(turf/T)
	if(!T)
		return FALSE
	var/expiry_data = chummed_fishing_tiles[T]
	if(!expiry_data)
		return FALSE
	
	var/expiry = expiry_data[1]
	if(world.time > expiry)
		expire_chum_turf(T)
		return FALSE
	return TRUE

/proc/createFreshWaterFishWeightList(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod, cheeseMod)
	var/list/weightList = list(
		/obj/item/reagent_containers/food/snacks/fish/carp = 270*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/sunny = 340*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/salmon = 180*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/eel = 180*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/black_bass = 150 * commonMod,
		/obj/item/reagent_containers/food/snacks/fish/sturgeon = 200 * commonMod,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1*treasureMod + 15*ceruleanMod,
		/obj/item/clothing/ring/gold = 1*treasureMod + 15*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1*treasureMod + 50*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 10*ceruleanMod,
		/obj/item/grown/log/tree/stick = 1*trashMod,
		/obj/item/natural/cloth = 1*trashMod,
		/obj/item/ammo_casing/caseless/rogue/arrow = 1*trashMod,
		/obj/item/reagent_containers/glass/bottle/rogue = 1*trashMod,
		/obj/item/reagent_containers/food/snacks/smallrat = 1 + 15*cheeseMod, //That's not a fish...?
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 1*cheeseMod,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 30,
	)
	return counterlist_ceiling(weightList)

/proc/createFreshWaterFishWeightListModlist(list/fishingMods)
	return createFreshWaterFishWeightList(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"],fishingMods["cheeseFishingMod"])

/proc/createCoastalSeaFishWeightList(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod, cheeseMod)
	var/weightList = list (
		/obj/item/reagent_containers/food/snacks/fish/cod = 210*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/plaice = 70*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/sole = 300*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/angler = 60*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 70*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/bass = 210*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 10*rareMod + 100*ceruleanMod,
		/obj/item/reagent_containers/food/snacks/fish/creepy_eel = 1*rareMod + 10*ceruleanMod,
		/obj/item/reagent_containers/food/snacks/fish/creepy_squid = 5*rareMod + 10*ceruleanMod,
		/obj/item/reagent_containers/food/snacks/fish/creepy_shark = 1*rareMod + 10*ceruleanMod,
		/obj/item/reagent_containers/food/snacks/fish/salmon/black_headed = 40 * rareMod,
		/obj/item/reagent_containers/food/snacks/fish/flounder = 200 * commonMod,
		/obj/item/reagent_containers/food/snacks/fish/mackerel = 210 * commonMod,
		/obj/item/reagent_containers/food/snacks/fish/beaksnapper = 100 * rareMod,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1*treasureMod + 15*ceruleanMod,
		/obj/item/clothing/ring/gold = 1*treasureMod + 15*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1*treasureMod + 50*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 10*ceruleanMod,
		/obj/item/grown/log/tree/stick =  1*trashMod,
		/obj/item/natural/cloth = 1*trashMod,
		/obj/item/ammo_casing/caseless/rogue/arrow = 1*trashMod,
		/obj/item/reagent_containers/glass/bottle/rogue = 1*trashMod,
		/obj/item/reagent_containers/food/snacks/smallrat = 1 + 15*cheeseMod, //That's not a coastal fish...?
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 1*cheeseMod,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 30,
	)
	return counterlist_ceiling(weightList)

/proc/createCoastalSeaFishWeightListModlist(list/fishingMods)
	return createCoastalSeaFishWeightList(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"],fishingMods["cheeseFishingMod"])

/proc/createDeepSeaFishWeightList(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod, cheeseMod)
	var/weightList = list (
		/obj/item/reagent_containers/food/snacks/fish/cod = 100*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/plaice = 150*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/sole = 50*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/angler = 150*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 100*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/bass = 100*commonMod,
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
		/obj/item/reagent_containers/food/snacks/smallrat = 1 + 15*cheeseMod, //That's not a deep sea fish...?
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 1*cheeseMod,
		/mob/living/carbon/human/species/goblin/npc/sea = 50*dangerMod,
		/mob/living/simple_animal/hostile/rogue/deepone = 50*dangerMod,
		/mob/living/simple_animal/hostile/rogue/deepone/spit = 50*dangerMod,
	)
	return counterlist_ceiling(weightList)

/proc/createDeepSeaFishWeightListModlist(list/fishingMods)
	return createDeepSeaFishWeightList(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"],fishingMods["cheeseFishingMod"])

/proc/createMudFishWeightList(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod, cheeseMod)
	var/weightList = list (
		/obj/item/reagent_containers/food/snacks/fish/swamp_shrimp = 200 * commonMod,
		/obj/item/reagent_containers/food/snacks/fish/swamp_mother = 100 * rareMod,
		/obj/item/reagent_containers/food/snacks/fish/zizo_abberation = 20 * rareMod,
		/obj/item/reagent_containers/food/snacks/fish/mudskipper = 790*commonMod,
		/obj/item/natural/worms/leech = 180*rareMod,
		/obj/item/clothing/ring/gold = 1*treasureMod + 30*ceruleanMod,
		/obj/item/reagent_containers/food/snacks/smallrat = 1 + 15*cheeseMod, //Thats one dirty... not a fish...?
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 1*cheeseMod,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 30,
	)
	return counterlist_ceiling(weightList)

/proc/createMudFishWeightListModlist(list/fishingMods)
	return createMudFishWeightList(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"],fishingMods["cheeseFishingMod"])

/proc/createCageFishWeightList(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod, cheeseMod, turf/target)
	var/list/weightList
	if(istype(target, /turf/open/water/ocean) || istype(target, /turf/open/water/ocean/deep))
		weightList = list(
			/obj/item/reagent_containers/food/snacks/fish/oyster = 250*commonMod,
			/obj/item/reagent_containers/food/snacks/fish/oyster/fossilized = 450*rareMod,
			/obj/item/reagent_containers/food/snacks/fish/clam = 300*commonMod,
			/obj/item/reagent_containers/food/snacks/fish/shrimp = 250*commonMod,
			/obj/item/reagent_containers/food/snacks/fish/crab = 250*rareMod,
			/obj/item/reagent_containers/food/snacks/fish/lobster = 250*commonMod,
			/obj/item/reagent_containers/food/snacks/fish/octopus = 15*rareMod,
			/obj/item/reagent_containers/food/snacks/smallrat = 1 + 15*cheeseMod,
			/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 1*cheeseMod,
			/obj/item/grown/log/tree/stick = 100*trashMod,
		)
	else
		weightList = list(
			/obj/item/reagent_containers/food/snacks/fish/clam = 300*commonMod,
			/obj/item/reagent_containers/food/snacks/fish/crab = 250*rareMod,
			/obj/item/reagent_containers/food/snacks/smallrat = 1 + 15*cheeseMod,
			/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 1*cheeseMod,
			/obj/item/grown/log/tree/stick = 100*trashMod,
		)
		if(istype(target, /turf/open/water/swamp) || istype(target, /turf/open/water/swamp/deep) || istype(target, /turf/open/water/river/muddy))
			weightList[/obj/item/reagent_containers/food/snacks/fish/crawfish] = 250*commonMod
	return counterlist_ceiling(weightList)

/proc/createCageFishWeightListModlist(list/fishingMods, turf/target)
	return createCageFishWeightList(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"],fishingMods["cheeseFishingMod"], target)

/proc/apply_fishing_quality_to_fish(obj/item/reagent_containers/food/snacks/fish/F, list/modlist, list/size_weights_override = null)
	if(!F)
		return

	var/list/rarity_weights = list("com" = 70, "rare" = 20, "ultra" = 9, "gold" = 1)
	var/list/size_weights = list("tiny" = 4, "small" = 4, "normal" = 4, "large" = 2, "huge" = 4, "prize" = 1)
	if(islist(size_weights_override))
		size_weights = size_weights_override.Copy()

	if(islist(modlist))
		rarity_weights["com"] = max(1, round(rarity_weights["com"] * max(0.1, modlist["commonFishingMod"] || 1)))
		rarity_weights["rare"] = max(1, round(rarity_weights["rare"] * max(0.1, modlist["rareFishingMod"] || 1)))
		rarity_weights["ultra"] = max(1, round(rarity_weights["ultra"] * max(0.1, modlist["rareFishingMod"] || 1)))
		rarity_weights["gold"] = max(1, round(rarity_weights["gold"] * max(0.1, modlist["ceruleanFishingMod"] || 1)))

	var/fishrarity = pickweightAllowZero(rarity_weights)
	var/fishsize = pickweightAllowZero(size_weights)

	var/raritydesc = "common"
	var/costmod = 1
	switch(fishrarity)
		if("rare")
			raritydesc = "rare"
			costmod *= 2
		if("ultra")
			raritydesc = "ultra-rare"
			costmod *= 4
		if("gold")
			raritydesc = "legendary"
			costmod *= 10

	if(!initial(F.no_rarity_sprite) && islist(F.rarity_icon_states) && F.rarity_icon_states[fishrarity])
		F.icon_state = F.rarity_icon_states[fishrarity]

	if(fishrarity != "com")
		switch(F.type)
			if(/obj/item/reagent_containers/food/snacks/fish/carp)
				F.fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/carp/rare
				F.cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/carp/rare
			if(/obj/item/reagent_containers/food/snacks/fish/eel)
				F.fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/eel/rare
				F.cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/eel/rare
			if(/obj/item/reagent_containers/food/snacks/fish/angler)
				F.fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/angler/rare
				F.cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/angler/rare
			if(/obj/item/reagent_containers/food/snacks/fish/clownfish)
				F.fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/clownfish/rare
				F.cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/clownfish/rare

	switch(fishsize)
		if("tiny")
			F.sizemod = list("tiny" = -999)
			costmod *= 0.5
		if("small")
			F.sizemod = list("tiny" = -999, "small" = -999)
			costmod *= 0.75
		if("large")
			F.vars["fishloot"] = null
			costmod *= 1.5
		if("huge")
			F.vars["fishloot"] = null
			costmod *= 3
		if("prize")
			F.vars["fishloot"] = null
			costmod *= 5
		else
			F.vars["fishloot"] = null

	F.apply_fishing_size(fishsize)
	F.name = "[fishsize] [raritydesc] [F.name]"
	F.sellprice *= costmod
