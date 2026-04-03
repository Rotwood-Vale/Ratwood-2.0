/proc/getfishingloot(var/mob/living/carbon/human/fisherman, var/list/modlist, turf/target, var/skill_power = 1)
	if(!istype(target, /turf/open/water))
		return null
	var/is_abyssor_fisher = FALSE
	if(ishuman(fisherman) && fisherman.patron?.type == /datum/patron/divine/abyssor)
		is_abyssor_fisher = TRUE
	if(ishuman(fisherman))
		if(fisherman.patron.type == /datum/patron/divine/abyssor)
			modlist["dangerFishingMod"] *= 1.10  // +10% danger
			modlist["treasureFishingMod"] *= 0.90  // -10% treasure
			modlist["rareFishingMod"] *= 1.25  // +25% rare
		if(fisherman.STALUC > 10)
			var/trait_bonus = 0
			if(HAS_TRAIT(fisherman, TRAIT_CAUTIOUS_FISHER))
				trait_bonus = 0.20
			var/tier1_bonus = min(fisherman.STALUC - 10, 5) // 5% bonus per point up until 15
			var/tier2_bonus = max(fisherman.STALUC - 15, 0) // 1% bonus per point past 15
			var/total_bonus = ((tier1_bonus * 0.05) + (tier2_bonus * 0.01) + (trait_bonus)) * skill_power
			modlist["rareFishingMod"] *= (1 + total_bonus)
			modlist["treasureFishingMod"] *= (1 + total_bonus)
			modlist["dangerFishingMod"] *= (1 - (trait_bonus * 3))
		else if(fisherman.STALUC < 10)
			// Unlucky fishers attract more dangerous encounters (5% more per point under 10).
			var/bad_luck = 10 - fisherman.STALUC
			modlist["dangerFishingMod"] *= (1 + bad_luck * 0.05)
	var/fishingloot
	if(istype(target, /turf/open/water/river) || istype(target, /turf/open/water/cleanshallow) || istype(target, /turf/open/water/pond))
		fishingloot = pickweightAllowZero(createFreshWaterFishWeightListModlist(modlist))
	else if(istype(target, /turf/open/water/ocean/deep))
		fishingloot = pickweightAllowZero(createDeepSeaFishWeightListModlist(modlist))
	else if(istype(target, /turf/open/water/ocean))
		fishingloot = pickweightAllowZero(createCoastalSeaFishWeightListModlist(modlist))
	else if(istype(target, /turf/open/water/swamp/deep) || istype(target, /turf/open/water/swamp))
		fishingloot = pickweightAllowZero(createMudFishWeightListModlist(modlist))
	if(!is_abyssor_fisher)
		if(fishingloot == /obj/item/reagent_containers/food/snacks/fish/creepy_squid || fishingloot == /obj/item/reagent_containers/food/snacks/fish/creepy_shark)
			if(istype(target, /turf/open/water/ocean/deep))
				var/list/deep_weights = createDeepSeaFishWeightListModlist(modlist)
				deep_weights -= /obj/item/reagent_containers/food/snacks/fish/creepy_squid
				deep_weights -= /obj/item/reagent_containers/food/snacks/fish/creepy_shark
				fishingloot = pickweightAllowZero(deep_weights)
			else if(istype(target, /turf/open/water/ocean))
				var/list/coast_weights = createCoastalSeaFishWeightListModlist(modlist)
				coast_weights -= /obj/item/reagent_containers/food/snacks/fish/creepy_squid
				coast_weights -= /obj/item/reagent_containers/food/snacks/fish/creepy_shark
				fishingloot = pickweightAllowZero(coast_weights)
	return fishingloot

/proc/get_handfishingloot(var/mob/living/carbon/human/fisherman, var/list/modlist, turf/target, var/skill_power = 1, var/cage_roll_chance = 30)
	if(!istype(target, /turf/open/water))
		return null
	if(!islist(modlist))
		modlist = list(
			"commonFishingMod" = 1,
			"rareFishingMod" = 1,
			"treasureFishingMod" = 1,
			"trashFishingMod" = 1,
			"dangerFishingMod" = 1,
			"ceruleanFishingMod" = 0,
			"cheeseFishingMod" = 0,
		)

	var/list/base_mods = modlist.Copy()
	var/base_loot = getfishingloot(fisherman, base_mods, target, skill_power)
	if(cage_roll_chance <= 0 || !prob(cage_roll_chance))
		return base_loot

	var/list/cage_mods = upgradecagemodlist(fisherman, modlist.Copy(), skill_power)
	var/cage_loot = pickweightAllowZero(createCageFishWeightListModlist(cage_mods, target))
	if(cage_loot)
		return cage_loot
	return base_loot

/proc/is_excluded_fishing_border_turf(turf/T)
	if(!T)
		return FALSE
	var/type_string = "[T.type]"
	if(findtext(type_string, "/turf/open/floor/rogue/dirt"))
		return TRUE
	if(findtext(type_string, "/turf/open/floor/rogue/grass"))
		return TRUE
	if(findtext(type_string, "/turf/open/floor/rogue/sand"))
		return TRUE
	if(findtext(type_string, "/turf/open/floor/rogue/mud"))
		return TRUE
	return FALSE

/proc/get_fishing_excluded_turf_distance(turf/open/water/W, max_scan = 6)
	if(!W)
		return 0
	var/closest_dist = max_scan + 1
	for(var/turf/T in spiral_range_turfs(max_scan, W))
		if(!is_excluded_fishing_border_turf(T))
			continue
		closest_dist = min(closest_dist, get_dist(W, T))
	if(closest_dist > max_scan)
		return max_scan + 1
	return closest_dist

/proc/upgradecagemodlist(var/mob/living/carbon/human/fisherman, var/list/modlist, var/skill_power = 1)
	if(ishuman(fisherman))
		if(fisherman.patron.type == /datum/patron/divine/abyssor)
			modlist["dangerFishingMod"] *= 1.10  // +10% danger
			modlist["treasureFishingMod"] *= 0.90  // -10% treasure
			modlist["rareFishingMod"] *= 1.25  // +25% rare
		if(fisherman.STALUC > 10)
			var/trait_bonus = 0
			if(HAS_TRAIT(fisherman, TRAIT_CAUTIOUS_FISHER))
				trait_bonus = 0.20
			var/tier1_bonus = min(fisherman.STALUC - 10, 5) // 5% bonus per point up until 15
			var/tier2_bonus = max(fisherman.STALUC - 15, 0) // 1% bonus per point past 15
			var/total_bonus = ((tier1_bonus * 0.05) + (tier2_bonus * 0.01) + (trait_bonus)) * skill_power
			modlist["rareFishingMod"] *= (1 + total_bonus)
			modlist["treasureFishingMod"] *= (1 + total_bonus)
			modlist["dangerFishingMod"] *= (1 - (trait_bonus * 3))
		else if(fisherman.STALUC < 10)
			var/bad_luck = 10 - fisherman.STALUC
			modlist["dangerFishingMod"] *= (1 + bad_luck * 0.05)
	return modlist

/proc/getbaitlife(var/fishing_skill, var/obj/item/bait, var/basechance = 80)
	if(!bait)
		return FALSE
	if(bait.isbait)
		bait.sync_bait_durability()
		if(bait.baitresilience > 0)
			var/durability_loss = max(1, round(bait.bait_max_durability * 0.30, 1))
			bait.baitresilience = max(0, bait.baitresilience - durability_loss)
			bait.sync_bait_durability()
			return (bait.baitresilience <= 0)
		return TRUE
	if(prob(basechance - (fishing_skill * 10)))
		return TRUE
	return FALSE
