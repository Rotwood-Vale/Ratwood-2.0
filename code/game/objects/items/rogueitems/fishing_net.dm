/obj/item/fishingnet
	name = "fishing net"
	desc = "A broad throw net for hauling fish from open water."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "net"
	layer = ABOVE_OPEN_TURF_LAYER
	w_class = WEIGHT_CLASS_BULKY
	throwforce = 5
	var/chum_baited = FALSE

/obj/item/fishingnet/attackby(obj/item/I, mob/user, params)
	if(user.used_intent?.type != /datum/intent/pour)
		return ..()
	if(!istype(I, /obj/item/reagent_containers/glass/bucket))
		return ..()
	var/obj/item/reagent_containers/glass/bucket/B = I
	if(!B.reagents)
		return ..()
	if(B.reagents.total_volume < B.reagents.maximum_volume)
		to_chat(user, span_warning("The bucket must be full of chum."))
		return
	if(B.reagents.get_reagent_amount(/datum/reagent/chum) < B.reagents.maximum_volume)
		to_chat(user, span_warning("The bucket must be full of chum."))
		return
	B.reagents.clear_reagents()
	chum_baited = TRUE
	to_chat(user, span_notice("I soak the net in chum."))
	return

/obj/item/fishingnet/examine(mob/user)
	. = ..()
	if(chum_baited)
		. += span_notice("It reeks of chum and is ready to throw.")

/obj/item/fishingnet/afterattack(obj/target, mob/user, proximity, params)
	if(!isliving(user) || user.doing)
		return ..()
	if(get_dist(user, target) > 6)
		to_chat(user, span_warning("It's too far away..."))
		return
	var/turf/T = get_turf(target)
	if(!istype(T, /turf/open/water))
		to_chat(user, span_warning("I need to toss this into water."))
		return
	if(!chum_baited && !is_chummed_fishing_turf(T))
		to_chat(user, span_warning("It needs to be soaked in chum, or tossed in chummed waters."))
		return
	if(locate(/obj/structure/fishing_net/deployed) in T)
		to_chat(user, span_warning("There's already a net in that spot."))
		return
	var/deploy_speed = get_skill_delay(user.get_skill_level(/datum/skill/labor/fishing), 1.5, slowest = 10)
	user.visible_message(span_notice("[user] starts setting a fishing net..."), span_notice("I start setting the fishing net..."))
	if(!do_after(user, deploy_speed, target = src))
		return
	if(QDELETED(src))
		return
	var/obj/structure/fishing_net/deployed/N = new(T)
	N.chum_baited = chum_baited
	N.fisherperson = user
	N.catch_interval = get_skill_delay(user.get_skill_level(/datum/skill/labor/fishing), 7.5, slowest = 60)
	N.next_check = world.time
	// When net is casted, chum the tile to attract fish
	apply_chum_to_turf(T)
	var/obj/item/rope/netline/L = new(user)
	L.linked_net = N
	N.linked_line = L
	if(!user.put_in_hands(L))
		L.forceMove(user.drop_location())
	qdel(src)

/obj/structure/fishing_net/deployed
	name = "deployed fishing net"
	desc = "A net spread out in the water, waiting for fish."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "net"
	layer = ABOVE_OPEN_TURF_LAYER
	anchored = TRUE
	density = FALSE
	var/chum_baited = FALSE
	var/mob/fisherperson
	var/next_check = 0
	var/catch_interval = 60 SECONDS
	var/list/caught_fish = list()
	var/static/list/net_size_weights = list("tiny" = 40, "small" = 40, "normal" = 40, "large" = 20, "huge" = 5, "prize" = 1)
	var/obj/item/rope/netline/linked_line

/obj/structure/fishing_net/deployed/attackby(obj/item/I, mob/user, params)
	if(user.used_intent?.type != /datum/intent/pour)
		return ..()
	if(!istype(I, /obj/item/reagent_containers/glass/bucket))
		return ..()
	var/obj/item/reagent_containers/glass/bucket/B = I
	if(!B.reagents)
		return ..()
	if(B.reagents.total_volume < B.reagents.maximum_volume)
		to_chat(user, span_warning("The bucket must be full of chum."))
		return
	if(B.reagents.get_reagent_amount(/datum/reagent/chum) < B.reagents.maximum_volume)
		to_chat(user, span_warning("The bucket must be full of chum."))
		return
	B.reagents.clear_reagents()
	chum_baited = TRUE
	to_chat(user, span_notice("I pour chum into the net."))
	return

/obj/structure/fishing_net/deployed/examine(mob/user)
	. = ..()
	if(chum_baited)
		. += span_notice("The cords are soaked in chum.")
	. += span_notice("It seems to be holding [catch_count()] fish.")

/obj/structure/fishing_net/deployed/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/fishing_net/deployed/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(linked_line)
		linked_line.linked_net = null
	return ..()

/obj/structure/fishing_net/deployed/proc/catch_count()
	if(!islist(caught_fish))
		return 0
	return length(caught_fish)

/obj/structure/fishing_net/deployed/process()
	if(catch_count() >= 10)
		if(linked_line)
			qdel(linked_line)
		visible_message(span_warning("[src] tears apart under the weight of too many fish, spilling away its haul!"))
		qdel(src)
		return
	if(world.time < next_check + catch_interval)
		return
	next_check = world.time
	if(!chum_baited && !is_chummed_fishing_turf(get_turf(src)))
		return
	var/list/modlist = list(
		"commonFishingMod" = 1,
		"rareFishingMod" = 1,
		"treasureFishingMod" = 1,
		"trashFishingMod" = 1,
		"dangerFishingMod" = 1,
		"ceruleanFishingMod" = 0,
		"cheeseFishingMod" = 0,
	)
	var/fishingskill = 0
	if(!QDELETED(fisherperson) && ishuman(fisherperson))
		modlist = upgradecagemodlist(fisherperson, modlist)
		fishingskill = fisherman_skill(fisherperson)
	var/loot = getfishingloot(fisherperson, modlist, get_turf(src), 1 + fishingskill * 0.1)
	if(ispath(loot, /obj/item/reagent_containers/food/snacks/fish))
		caught_fish += list(list("type" = loot, "mods" = modlist.Copy()))

/obj/structure/fishing_net/deployed/proc/fisherman_skill(mob/M)
	if(!M)
		return 0
	return M.get_skill_level(/datum/skill/labor/fishing)

/obj/item/rope/netline
	name = "rope net"
	desc = "A haul line connected to a deployed fishing net."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "rope"
	var/obj/structure/fishing_net/deployed/linked_net

/obj/item/rope/netline/attack_self(mob/user)
	if(!linked_net || QDELETED(linked_net))
		to_chat(user, span_warning("The net line hangs loose."))
		return
	var/fish_count = linked_net.catch_count()
	var/str_score = 10
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		str_score = H.STASTR
	var/base_speed = get_skill_delay(user.get_skill_level(/datum/skill/labor/fishing), 1, slowest = 8)
	var/load_penalty = max(0, fish_count - 1) * 0.5
	var/strength_bonus = max(0, str_score - 10) * 0.2
	var/retrieve_speed = max(1.2, base_speed + load_penalty - strength_bonus)
	var/strength_target = 8 + fish_count
	var/strength_roll = rand(1, 20) + str_score
	if(strength_roll < strength_target)
		var/fail_chance = clamp(5 + (fish_count * 3) - max(0, str_score - 10), 3, 20)
		if(prob(fail_chance))
			user.visible_message(span_warning("[user] strains against the net line but loses grip."), span_warning("The haul is too heavy right now, I lose my grip."))
			return
	user.visible_message(span_notice("[user] starts tugging the rope net..."), span_notice("I start tugging the rope net..."))
	if(!do_after(user, retrieve_speed, target = user))
		return
	if(!linked_net || QDELETED(linked_net))
		return
	for(var/entry in linked_net.caught_fish)
		if(islist(entry))
			var/list/catch_data = entry
			var/path = catch_data["type"]
			var/list/mods = catch_data["mods"]
			if(ispath(path))
				var/obj/item/new_catch = new path(get_turf(user))
				if(istype(new_catch, /obj/item/reagent_containers/food/snacks/fish))
					var/obj/item/reagent_containers/food/snacks/fish/F = new_catch
					apply_fishing_quality_to_fish(F, mods, linked_net.net_size_weights)
		else if(ispath(entry))
			var/obj/item/new_catch = new entry(get_turf(user))
			if(istype(new_catch, /obj/item/reagent_containers/food/snacks/fish))
				var/obj/item/reagent_containers/food/snacks/fish/F = new_catch
				apply_fishing_quality_to_fish(F, null, linked_net.net_size_weights)
	var/obj/item/fishingnet/N = new(user)
	if(!user.put_in_hands(N))
		N.forceMove(user.drop_location())
	qdel(linked_net)
	qdel(src)

/obj/item/rope/netline/examine(mob/user)
	. = ..()
	if(!linked_net || QDELETED(linked_net))
		. += span_warning("It isn't attached to a net anymore.")
		return
	. += span_notice("The net feels heavy with [linked_net.catch_count()] fish.")
