/obj/item/fishingcage
	name = "fishing cage"
	desc = "A sturdy cage used to catch shellfishes. Put a leech or worm inside and an unfortunate shellfish should be lured inside shortly."
	icon_state = "fishingcage"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_BULKY
	throwforce = 0
	slot_flags = ITEM_SLOT_BACK
	var/check_counter = 0
	var/deployed = 0
	var/obj/item/caught
	var/obj/item/bait
	var/bait_bundle_uses = 0
	var/list/caught_modlist
	var/mob/fisherperson
	var/time2catch = 40 SECONDS // RW had this at 20 seconds, but if you produce more than 3 - 4 cages you would be limited only by the rate you get worm, so a slight nerf.
	var/static/list/cage_size_weights = list("tiny" = 40, "small" = 40, "normal" = 40, "large" = 20, "huge" = 5, "prize" = 1)
	var/max_durability = 100
	var/durability = 100

/obj/item/fishingcage/Initialize(mapload)
	. = ..()
	max_durability = max(1, max_durability)
	max_integrity = max_durability
	obj_integrity = clamp(durability, 0, max_integrity)
	durability = obj_integrity

/obj/item/fishingcage/proc/get_durability_percent()
	if(max_integrity <= 0)
		return 0
	return round((obj_integrity / max_integrity) * 100)

/obj/item/fishingcage/proc/adjust_durability(amount)
	if(amount <= 0)
		return FALSE
	obj_integrity = max(0, obj_integrity - amount)
	durability = obj_integrity
	return obj_integrity <= 0

/obj/item/fishingcage/proc/repair_durability(amount)
	if(amount <= 0)
		return FALSE
	var/old_durability = obj_integrity
	obj_integrity = min(max_integrity, obj_integrity + amount)
	durability = obj_integrity
	return obj_integrity > old_durability

/obj/item/fishingcage/proc/get_harvest_stamina_drain(mob/living/user, base_percent = 18.75)
	if(!user)
		return 0
	var/athletics_skill = max(user.get_skill_level(/datum/skill/misc/athletics), 0)
	var/fishing_skill = max(user.get_skill_level(/datum/skill/labor/fishing), 0)
	var/strength_bonus = max(0, user.STASTR - 10)
	var/effective_percent = max(1, base_percent - athletics_skill - fishing_skill - strength_bonus)
	var/drain = round((user.max_stamina * effective_percent) / 100, 1)
	return max(1, drain)

/obj/item/fishingcage/attack_self(mob/user)
	. = ..()

	var/turf/T = get_step(user, user.dir)
	if(!istype(T, /turf/open/water))
		to_chat(user, span_warning("This goes into water!"))
		return // We don't need to check non water tiles.

	user.visible_message(span_notice("[user] begins deploying the fishing cage..."), \
						span_notice("I begin deploying the fishing cage..."))
	var/deploy_speed = get_skill_delay(user.get_skill_level(/datum/skill/labor/fishing), 1, slowest = 6) //in seconds

	if(!is_valid_fishing_spot(T))
		to_chat(user, span_warning("This body of water seems devoid of aquatic life..."))
		return
	if(locate(/obj/item/fishingcage) in T)
		to_chat(user, span_warning("There's already a fishing cage here."))
		return
	
	if(istype(T, /turf/open/water))
		if(do_after(user, deploy_speed, target = src))
			user.transferItemToLoc(src, T)
			deployed = 1
			icon_state = "fishingcage_deployed"
			anchored = 1
	else
		to_chat(user, span_warning("I'm not catching anything if I don't put this on water"))
		return

/obj/item/fishingcage/attack_hand(mob/user)
	if(deployed)
		var/deploy_speed = get_skill_delay(user.get_skill_level(/datum/skill/labor/fishing), 0.5, slowest = 6) //in seconds
		if(caught)
			user.visible_message(span_notice("[user] begins to harvest from the cage..."), \
								span_notice("I begin harvesting the from the cage..."))
			if(do_after(user, deploy_speed, target = src))
				var/harvest_stamina_drain = get_harvest_stamina_drain(user)
				if(harvest_stamina_drain && !user.stamina_add(harvest_stamina_drain))
					to_chat(user, span_warning("I'm too exhausted to pull out the cage's catch right now."))
					return
				add_sleep_experience(user, /datum/skill/labor/fishing, 20)
				record_featured_stat(FEATURED_STATS_FISHERS, user)
				record_round_statistic(STATS_FISH_CAUGHT)
				var/obj/item/new_caught = new caught(user.loc)
				if(istype(new_caught, /obj/item/reagent_containers/food/snacks/fish))
					var/obj/item/reagent_containers/food/snacks/fish/F = new_caught
					apply_fishing_quality_to_fish(F, caught_modlist, cage_size_weights)
				if(adjust_durability(10))
					visible_message(span_warning("[src] falls apart after one catch too many!"))
					QDEL_NULL(bait)
					caught = null
					caught_modlist = null
					deployed = 0
					anchored = 0
					STOP_PROCESSING(SSobj, src)
					qdel(src)
					return
				caught = null
				caught_modlist = null
				if(!bait)
					desc = initial(desc)
					icon_state = "fishingcage_deployed"
				else
					//sound queue to keep it clear that it's still baited
					playsound(src.loc, 'sound/foley/pierce.ogg', 50, FALSE)
					icon_state = "fishingcage_ready"
					check_counter = world.time
					time2catch = get_skill_delay(user.get_skill_level(/datum/skill/labor/fishing), 5, slowest = 40) //in seconds
					START_PROCESSING(SSobj, src)
		else
			user.visible_message(span_notice("[user] begins disarming the fishing cage..."), \
								span_notice("I begin disarming the fishing cage..."))
			if(do_after(user, deploy_speed, target = src))
				STOP_PROCESSING(SSobj, src)
				deployed = 0
				QDEL_NULL(bait) //you lose the bait if you take out the cage without catching anything
				bait_bundle_uses = 0
				caught_modlist = null
				desc = initial(desc)
				icon_state = initial(icon_state)
				anchored = 0
				..()
	else
		..()

/obj/item/fishingcage/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/rogueweapon/hammer))
		if(durability >= max_durability)
			to_chat(user, span_warning("The fishing cage doesn't need repairs."))
			return
		if(user.get_skill_level(/datum/skill/craft/crafting) <= 0)
			to_chat(user, span_warning("I don't know how to repair this cage."))
			return
		user.visible_message(span_notice("[user] begins repairing [src] with [I]..."), span_notice("I begin repairing [src] with [I]..."))
		var/repair_time = max(2 SECONDS, (6 SECONDS) - (user.get_skill_level(/datum/skill/craft/crafting) * 1 SECONDS))
		if(!do_after(user, repair_time, target = src))
			return
		var/repair_amount = min(30, max_durability - durability)
		if(repair_durability(repair_amount))
			playsound(src.loc, 'sound/items/bsmith3.ogg', 70, FALSE)
			if(user.mind)
				user.mind.add_sleep_experience(/datum/skill/craft/crafting, max(1, repair_amount / 5), FALSE)
		return

	if(bait)
		to_chat(user, span_warning("There's bait already in the cage."))
		return
	fisherperson = user
	if(istype(I, /obj/item/natural/bundle/worms))
		var/obj/item/natural/bundle/worms/W = I
		if(W.amount <= 0)
			to_chat(user, span_warning("There are no worms left in that bundle."))
			return
		user.visible_message(span_notice("[user] starts adding bait to the fishing cage..."), \
							span_notice("I start to add bait to the fishing cage..."))
		if(do_after(user, 3 SECONDS, target = src))
			playsound(src.loc, 'sound/foley/pierce.ogg', 50, FALSE)
			var/obj/item/new_bait = new W.stacktype(src)
			bait = new_bait
			bait_bundle_uses = clamp(W.amount, 1, W.maxamount)
			qdel(W)
			check_counter = world.time
			time2catch = get_skill_delay(user.get_skill_level(/datum/skill/labor/fishing), 5, slowest = 40) //in seconds
			icon_state = "fishingcage_ready"
			START_PROCESSING(SSobj, src)
			return
		return
	if(I.baitpenalty != 100) // We use baitpenalty instead of baitchance so let's just exclude anything with 100
		user.visible_message(span_notice("[user] starts adding the bait to the fishing cage..."), \
							span_notice("I start to add [I] to the fishing cage..."))
		if(do_after(user, 3 SECONDS, target = src))
			playsound(src.loc, 'sound/foley/pierce.ogg', 50, FALSE)
			I.forceMove(src)
			bait = I
			bait_bundle_uses = 0
			check_counter = world.time
			time2catch = get_skill_delay(user.get_skill_level(/datum/skill/labor/fishing), 5, slowest = 40) //in seconds
			icon_state = "fishingcage_ready"
			START_PROCESSING(SSobj, src)
			return
	. = ..()

/obj/item/fishingcage/process()
	if(!(deployed && bait))
		return PROCESS_KILL
	if(world.time > check_counter + time2catch)
		check_counter = world.time
		var/list/fishingmodlist
		if(islist(bait.fishingMods))
			fishingmodlist = bait.fishingMods.Copy()
		else
			fishingmodlist = list(
				"commonFishingMod" = 1,
				"rareFishingMod" = 1,
				"treasureFishingMod" = 1,
				"trashFishingMod" = 1,
				"dangerFishingMod" = 1,
				"ceruleanFishingMod" = 0,
				"cheeseFishingMod" = 0,
				"net_cage_ultra_boost" = 2,
				"net_cage_prize_boost" = 2,
			)
		if(!fishingmodlist["net_cage_ultra_boost"])
			fishingmodlist["net_cage_ultra_boost"] = 2
		if(!fishingmodlist["net_cage_prize_boost"])
			fishingmodlist["net_cage_prize_boost"] = 2
		if(is_cheese_bait(bait))
			fishingmodlist["cheeseFishingMod"] = 1
		var/fishingskill = 0
		if(!QDELETED(fisherperson))
			fishingmodlist = upgradecagemodlist(fisherperson, fishingmodlist)
			fishingskill = fisherperson.get_skill_level(/datum/skill/labor/fishing)
		fishingmodlist["rareFishingMod"] *= clamp(0.70 + (fishingskill * 0.05), 0.70, 1.05)
		fishingmodlist["net_cage_ultra_boost"] = min(fishingmodlist["net_cage_ultra_boost"], clamp(0.35 + (fishingskill * 0.14), 0.35, 1.15))
		fishingmodlist["net_cage_prize_boost"] = min(fishingmodlist["net_cage_prize_boost"], clamp(0.20 + (fishingskill * 0.09), 0.20, 0.75))
		fishingmodlist["size_large_mult"] = clamp(0.80 + (fishingskill * 0.04), 0.70, 1.05)
		fishingmodlist["size_huge_mult"] = clamp(0.55 + (fishingskill * 0.05), 0.40, 0.90)
		fishingmodlist["size_prize_mult"] = clamp(0.25 + (fishingskill * 0.05), 0.20, 0.70)
		caught = pickweightAllowZero(createCageFishWeightListModlist(fishingmodlist, get_turf(src)))
		caught_modlist = fishingmodlist.Copy()
		icon_state = "fishingcage_caught"
		var/consume_bait = FALSE
		if(istype(bait, /obj/item/natural/worms))
			if(bait_bundle_uses > 0)
				bait_bundle_uses--
				consume_bait = (bait_bundle_uses <= 0)
			else
				consume_bait = TRUE
		else
			consume_bait = getbaitlife(fishingskill, bait, 100)
		if(consume_bait)
			QDEL_NULL(bait)
			bait_bundle_uses = 0
			fisherperson = null
			STOP_PROCESSING(SSobj, src)
	..()

/obj/item/fishingcage/examine(mob/user)
	. = ..()
	. += span_notice("Durability: [get_durability_percent()]%")
	if(icon_state == "fishingcage_caught")
		. += span_warning("Something seems to be inside...")
	if(bait)
		if(bait_bundle_uses > 1 && istype(bait, /obj/item/natural/worms))
			var/bait_label = "worms"
			if(istype(bait, /obj/item/natural/worms/leech))
				bait_label = "leeches"
			else if(istype(bait, /obj/item/natural/worms/grubs) || istype(bait, /obj/item/natural/worms/grub_silk))
				bait_label = "grubs"
			. += span_notice("Baited with [bait_bundle_uses] [bait_label].")
		else
			. += span_notice("Baited with a [bait.name].")
	else
		. += span_warning("It has no bait inside.")
	
