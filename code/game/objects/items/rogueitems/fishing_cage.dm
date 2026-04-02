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
				add_sleep_experience(user, /datum/skill/labor/fishing, 20)
				record_featured_stat(FEATURED_STATS_FISHERS, user)
				record_round_statistic(STATS_FISH_CAUGHT)
				var/obj/item/new_caught = new caught(user.loc)
				if(istype(new_caught, /obj/item/reagent_containers/food/snacks/fish))
					var/obj/item/reagent_containers/food/snacks/fish/F = new_caught
					apply_fishing_quality_to_fish(F, caught_modlist, cage_size_weights)
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
	if(bait)
		to_chat(user, span_warning("There's bait already on the cage."))
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
	if(deployed && bait)
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
				)
			if(is_cheese_bait(bait))
				fishingmodlist["cheeseFishingMod"] = 1
			var/fishingskill = 0
			if(!QDELETED(fisherperson))
				fishingmodlist = upgradecagemodlist(fisherperson, fishingmodlist)
				fishingskill = fisherperson.get_skill_level(/datum/skill/labor/fishing)
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
	
