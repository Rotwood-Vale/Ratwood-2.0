/obj/item/fishingcage
	name = "捕鱼笼"
	desc = "一只结实的笼子，用来捕捉贝类。把水蛭或蠕虫放进去后，不幸的贝类很快就会被引诱进来。"
	icon_state = "fishingcage"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_BULKY
	throwforce = 0
	slot_flags = ITEM_SLOT_BACK
	var/check_counter = 0
	var/deployed = 0
	var/obj/item/caught
	var/obj/item/bait
	var/time2catch = 40 SECONDS // RW had this at 20 seconds, but if you produce more than 3 - 4 cages you would be limited only by the rate you get worm, so a slight nerf.

/obj/item/fishingcage/attack_self(mob/user)
	. = ..()

	var/turf/T = get_step(user, user.dir)
	if(!istype(T, /turf/open/water))
		to_chat(user, span_warning("这个得放进水里！"))
		return // We don't need to check non water tiles.

	user.visible_message(span_notice("[user]开始布设捕鱼笼……"), \
						span_notice("我开始布设捕鱼笼……"))
	var/deploy_speed = get_skill_delay(user.get_skill_level(/datum/skill/labor/fishing), 1, slowest = 6) //in seconds

	if(!is_valid_fishing_spot(T))
		to_chat(user, span_warning("这片水域似乎没有水生生物……"))
		return
	
	if(istype(T, /turf/open/water))
		if(do_after(user, deploy_speed, target = src))
			user.transferItemToLoc(src, T)
			deployed = 1
			icon_state = "fishingcage_deployed"
			anchored = 1
	else
		to_chat(user, span_warning("不把它放进水里，我什么也抓不到。"))
		return

/obj/item/fishingcage/attack_hand(mob/user)
	if(deployed)
		var/deploy_speed = get_skill_delay(user.get_skill_level(/datum/skill/labor/fishing), 1, slowest = 6) //in seconds
		if(caught)
			user.visible_message(span_notice("[user]开始从笼中收取猎获……"), \
								span_notice("我开始从笼中收取猎获……"))
			if(do_after(user, deploy_speed, target = src))
				STOP_PROCESSING(SSobj, src)
				icon_state = "fishingcage_deployed"
				add_sleep_experience(user, /datum/skill/labor/fishing, 20)
				record_featured_stat(FEATURED_STATS_FISHERS, user)
				record_round_statistic(STATS_FISH_CAUGHT)
				new caught(user.loc)
				caught = null
				desc = initial(desc)
		else
			user.visible_message(span_notice("[user]开始拆除捕鱼笼……"), \
								span_notice("我开始拆除捕鱼笼……"))
			if(do_after(user, deploy_speed, target = src))
				STOP_PROCESSING(SSobj, src)
				deployed = 0
				QDEL_NULL(bait) //you lose the bait if you take out the cage without catching anything
				desc = initial(desc)
				icon_state = initial(icon_state)
				anchored = 0
				..()
	else
		..()

/obj/item/fishingcage/attackby(obj/item/I, mob/user, params)
	if(bait)
		to_chat(user, span_warning("笼子里已经放了饵料。"))
		return
	if(I.baitpenalty != 100) // We use baitpenalty instead of baitchance so let's just exclude anything with 100
		user.visible_message(span_notice("[user]开始把饵料放进捕鱼笼……"), \
							span_notice("我开始把[I]放进捕鱼笼……"))
		if(do_after(user, 3 SECONDS, target = src))
			playsound(src.loc, 'sound/foley/pierce.ogg', 50, FALSE)
			I.forceMove(src)
			bait = I
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
			caught = pickweightAllowZero(createCageFishWeightListModlist(bait.fishingMods))
			icon_state = "fishingcage_caught"
			QDEL_NULL(bait)
	..()

/obj/item/fishingcage/examine(mob/user)
	. = ..()
	if(icon_state == "fishingcage_caught")
		. += span_warning("里面似乎有什么东西……")
	
