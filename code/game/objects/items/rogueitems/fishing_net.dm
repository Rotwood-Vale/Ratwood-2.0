/obj/item/fishingnet
	name = "fishing net"
	desc = "A broad throw net for hauling fish from open water."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "net"
	layer = ABOVE_OPEN_TURF_LAYER
	w_class = WEIGHT_CLASS_BULKY
	throwforce = 5
	var/chum_baited = FALSE
	var/max_durability = 100
	var/durability = 100

/obj/item/fishingnet/Initialize(mapload)
	. = ..()
	max_durability = max(1, max_durability)
	max_integrity = max_durability
	obj_integrity = clamp(durability, 0, max_integrity)
	durability = obj_integrity

/obj/item/fishingnet/proc/get_durability_percent()
	if(max_integrity <= 0)
		return 0
	return round((obj_integrity / max_integrity) * 100)

/obj/item/fishingnet/proc/repair_durability(amount)
	if(amount <= 0)
		return FALSE
	var/old_durability = obj_integrity
	obj_integrity = min(max_integrity, obj_integrity + amount)
	durability = obj_integrity
	return obj_integrity > old_durability

/obj/item/fishingnet/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/needle))
		var/obj/item/needle/N = I
		if(durability >= max_durability)
			to_chat(user, span_warning("This net doesn't need repairs."))
			return
		if(user.get_skill_level(/datum/skill/craft/sewing) <= 0)
			to_chat(user, span_warning("I don't know how to mend this net."))
			return
		if(!N.infinite && N.stringamt < 1)
			to_chat(user, span_warning("The needle has no thread left."))
			return
		user.visible_message(span_notice("[user] starts mending [src]..."), span_notice("I start mending [src]..."))
		var/repair_time = max(2 SECONDS, (6 SECONDS) - (user.get_skill_level(/datum/skill/craft/sewing) * 1 SECONDS))
		if(!do_after(user, repair_time, target = src))
			return
		if(!N.infinite)
			N.use(1)
			N.update_icon()
		var/repair_amount = min(25, max_durability - durability)
		if(repair_durability(repair_amount))
			playsound(src.loc, 'sound/foley/sewflesh.ogg', 60, FALSE)
			if(user.mind)
				user.mind.add_sleep_experience(/datum/skill/craft/sewing, max(1, repair_amount / 5), FALSE)
		return

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
	. += span_notice("Durability: [get_durability_percent()]%")
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
	var/cast_stamina_drain = get_hand_fishing_stamina_drain(user, 25)
	if(cast_stamina_drain && !user.stamina_add(cast_stamina_drain))
		to_chat(user, span_warning("I'm too exhausted to cast the net properly."))
		return
	if(QDELETED(src))
		return
	var/obj/structure/fishing_net/deployed/N = new(T)
	N.chum_baited = chum_baited
	N.max_durability = max_durability
	N.durability = durability
	N.max_integrity = N.max_durability
	N.obj_integrity = N.durability
	N.fisherperson = user
	N.catch_interval = get_skill_delay(user.get_skill_level(/datum/skill/labor/fishing), 7.5, slowest = 60)
	N.next_check = world.time
	N.cast_anchor = get_turf(user)
	// When net is casted, chum the tile to attract fish
	apply_chum_to_turf(T)
	var/obj/item/rope/netline/L = new(user)
	L.linked_net = N
	L.cast_anchor = N.cast_anchor
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
	var/turf/cast_anchor
	var/max_durability = 100
	var/durability = 100
	var/max_catch_capacity = 15

/obj/structure/fishing_net/deployed/proc/get_durability_percent()
	if(max_integrity <= 0)
		return 0
	return round((obj_integrity / max_integrity) * 100)

/obj/structure/fishing_net/deployed/proc/adjust_durability(amount)
	if(amount <= 0)
		return FALSE
	obj_integrity = max(0, obj_integrity - amount)
	durability = obj_integrity
	return obj_integrity <= 0

/obj/structure/fishing_net/deployed/proc/repair_durability(amount)
	if(amount <= 0)
		return FALSE
	var/old_durability = obj_integrity
	obj_integrity = min(max_integrity, obj_integrity + amount)
	durability = obj_integrity
	return obj_integrity > old_durability

/obj/structure/fishing_net/deployed/proc/drop_residual_rope()
	var/turf/drop_turf = null
	if(linked_line && !QDELETED(linked_line))
		drop_turf = get_turf(linked_line)
	if(!drop_turf)
		drop_turf = get_turf(src)
	if(drop_turf)
		new /obj/item/rope(drop_turf)

/obj/structure/fishing_net/deployed/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/needle))
		var/obj/item/needle/N = I
		if(durability >= max_durability)
			to_chat(user, span_warning("This net doesn't need repairs."))
			return
		if(user.get_skill_level(/datum/skill/craft/sewing) <= 0)
			to_chat(user, span_warning("I don't know how to mend this net."))
			return
		if(!N.infinite && N.stringamt < 1)
			to_chat(user, span_warning("The needle has no thread left."))
			return
		user.visible_message(span_notice("[user] starts mending [src]..."), span_notice("I start mending [src]..."))
		var/repair_time = max(2 SECONDS, (6 SECONDS) - (user.get_skill_level(/datum/skill/craft/sewing) * 1 SECONDS))
		if(!do_after(user, repair_time, target = src))
			return
		if(!N.infinite)
			N.use(1)
			N.update_icon()
		var/repair_amount = min(25, max_durability - durability)
		if(repair_durability(repair_amount))
			playsound(src.loc, 'sound/foley/sewflesh.ogg', 60, FALSE)
			if(user.mind)
				user.mind.add_sleep_experience(/datum/skill/craft/sewing, max(1, repair_amount / 5), FALSE)
		return

	if(user.used_intent?.blade_class == BCLASS_CUT)
		user.visible_message(span_notice("[user] starts cutting [src] free from the water..."), span_notice("I start cutting the net loose."))
		if(!do_after(user, 2 SECONDS, target = src))
			return
		STOP_PROCESSING(SSobj, src)
		caught_fish = list()
		var/obj/item/fishingnet/N = new(user)
		N.max_durability = max_durability
		N.durability = durability
		N.max_integrity = N.max_durability
		N.obj_integrity = N.durability
		if(!user.put_in_hands(N))
			N.forceMove(user.drop_location())
		if(linked_line)
			qdel(linked_line)
		visible_message(span_warning("[src] is cut free, spilling its catch back into the water."))
		qdel(src)
		return

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
	. += span_notice("Durability: [get_durability_percent()]%")
	if(chum_baited)
		. += span_notice("The cords are soaked in chum.")
	. += span_notice("It seems to be holding [catch_count()]/[max_catch_capacity] fish.")

/obj/structure/fishing_net/deployed/Initialize(mapload)
	. = ..()
	max_durability = max(1, max_durability)
	max_integrity = max_durability
	obj_integrity = clamp(durability, 0, max_integrity)
	durability = obj_integrity
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
	if(catch_count() > max_catch_capacity)
		drop_residual_rope()
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
		"net_cage_ultra_boost" = 2,
		"net_cage_prize_boost" = 2,
	)
	var/fishingskill = 0
	if(!QDELETED(fisherperson) && ishuman(fisherperson))
		modlist = upgradecagemodlist(fisherperson, modlist)
		fishingskill = fisherman_skill(fisherperson)
	modlist["rareFishingMod"] *= clamp(0.30 + (fishingskill * 0.07), 0.30, 0.85)
	modlist["net_cage_ultra_boost"] = min(modlist["net_cage_ultra_boost"], clamp(0.12 + (fishingskill * 0.10), 0.12, 0.65))
	modlist["net_cage_prize_boost"] = min(modlist["net_cage_prize_boost"], clamp(0.06 + (fishingskill * 0.05), 0.06, 0.35))
	modlist["size_large_mult"] = clamp(0.50 + (fishingskill * 0.04), 0.40, 0.90)
	modlist["size_huge_mult"] = clamp(0.22 + (fishingskill * 0.04), 0.15, 0.55)
	modlist["size_prize_mult"] = clamp(0.08 + (fishingskill * 0.03), 0.05, 0.25)
	var/turf/open/water/current_water = get_turf(src)
	var/excluded_dist = current_water ? get_fishing_excluded_turf_distance(current_water, 6) : 7
	if(excluded_dist <= 3)
		// Nets near excluded shoreline terrain should haul mostly junk and fewer rare fish.
		modlist["commonFishingMod"] *= 0.65
		modlist["rareFishingMod"] *= 0.2
		modlist["treasureFishingMod"] *= 0.15
		modlist["trashFishingMod"] *= 6
		modlist["dangerFishingMod"] *= 0.5
	var/loot = getfishingloot(fisherperson, modlist, get_turf(src), 1 + fishingskill * 0.1)
	if(excluded_dist <= 3 && ispath(loot, /obj/item/reagent_containers/food/snacks/fish) && prob(70))
		loot = pickweight(list(
			/obj/item/natural/fibers = 5,
			/obj/item/grown/log/tree/stick = 3,
			/obj/item/reagent_containers/glass/bottle/rogue = 2,
			/obj/item/natural/feather = 1,
		))
	if(ispath(loot, /obj/item/reagent_containers/food/snacks/fish))
		if(adjust_durability(5))
			drop_residual_rope()
			if(linked_line)
				qdel(linked_line)
			visible_message(span_warning("[src] tears apart as its worn cords finally give out!"))
			qdel(src)
			return
		caught_fish += list(list("type" = loot, "mods" = modlist.Copy()))
	else if(ispath(loot, /obj/item))
		caught_fish += loot

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
	var/turf/cast_anchor
	var/turf/last_holder_turf

/obj/item/rope/netline/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/rope/netline/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/rope/netline/proc/get_haul_stamina_drain(mob/living/user, fish_count)
	if(!user)
		return 0
	var/athletics_skill = max(user.get_skill_level(/datum/skill/misc/athletics), 0)
	var/fishing_skill = max(user.get_skill_level(/datum/skill/labor/fishing), 0)
	var/strength_bonus = max(0, user.STASTR - 10)
	var/effective_percent = max(1, 30 - athletics_skill - fishing_skill - strength_bonus)
	var/base_drain = round((user.max_stamina * effective_percent) / 100, 1)
	var/load_bonus = round(max(fish_count, 1) * 0.25, 1)
	return max(1, base_drain + load_bonus)

/obj/item/rope/netline/process()
	if(!linked_net || QDELETED(linked_net))
		return
	if(!ismob(loc))
		return
	var/mob/living/holder = loc
	var/turf/current_holder_turf = get_turf(holder)
	if(!current_holder_turf)
		return
	if(!last_holder_turf)
		last_holder_turf = current_holder_turf
		return
	if(current_holder_turf == last_holder_turf)
		return
	last_holder_turf = current_holder_turf
	if(get_dist(holder, linked_net) <= 5)
		return
	if(holder.dropItemToGround(src))
		to_chat(holder, span_warning("I move too far from the net and drop the line!"))

/obj/item/rope/netline/attack_self(mob/user)
	if(!linked_net || QDELETED(linked_net))
		to_chat(user, span_warning("The net line hangs loose."))
		return
	if(user.get_num_arms(FALSE) < 2)
		to_chat(user, span_warning("I need both hands to haul this line."))
		return
	if(user.get_inactive_held_item())
		to_chat(user, span_warning("My other hand must be free to haul the net."))
		return
	last_holder_turf = get_turf(user)
	var/fish_count = linked_net.catch_count()
	var/str_score = 10
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		str_score = H.STASTR
	var/base_speed = get_skill_delay(user.get_skill_level(/datum/skill/labor/fishing), 1, slowest = 8)
	var/load_penalty = max(0, fish_count - 1) * 0.4
	var/strength_bonus = max(0, str_score - 10) * 0.2
	var/retrieve_speed = max(1.2, base_speed + load_penalty - strength_bonus)
	var/haul_actions
	if(fish_count > 10)
		haul_actions = 4
	else if(fish_count >= 6)
		haul_actions = 3
	else
		haul_actions = max(1, round((max(fish_count, 1) + 2) / 4))
	var/overload = max(0, fish_count - 10)
	for(var/i in 1 to haul_actions)
		if(get_dist(user, linked_net) > 5)
			to_chat(user, span_warning("I wander too far from the net and drop the line."))
			user.dropItemToGround(src)
			return
		var/strength_target = 8 + fish_count + (i - 1) + (overload * 2)
		var/strength_roll = rand(1, 20) + str_score + user.get_skill_level(/datum/skill/labor/fishing)
		if(strength_roll < strength_target)
			var/fail_chance = clamp(5 + (fish_count * 3) + (overload * 4) - max(0, str_score - 10), 3, 35)
			if(prob(fail_chance))
				user.visible_message(span_warning("[user] strains against the net line but loses grip."), span_userdanger("The haul is too heavy right now! I LOSE MY GRIP!"))
				return
		user.visible_message(span_notice("[user] hauls on the rope net ([i]/[haul_actions])..."), span_notice("I haul on the rope net ([i]/[haul_actions])..."))
		if(!do_after(user, retrieve_speed, target = user))
			return
		if(!linked_net || QDELETED(linked_net))
			return
		var/stamina_drain = get_haul_stamina_drain(user, fish_count)
		var/heavy_mult = 1 + (min(max(fish_count - 8, 0), 7) / 7)
		stamina_drain = round(stamina_drain * heavy_mult, 0.1)
		if(stamina_drain && !user.stamina_add(stamina_drain))
			to_chat(user, span_warning("I'm too exhausted to keep hauling the net."))
			return
	var/fish_hauled = 0
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
					fish_hauled++
		else if(ispath(entry))
			var/obj/item/new_catch = new entry(get_turf(user))
			if(istype(new_catch, /obj/item/reagent_containers/food/snacks/fish))
				var/obj/item/reagent_containers/food/snacks/fish/F = new_catch
				apply_fishing_quality_to_fish(F, null, linked_net.net_size_weights)
				fish_hauled++
	if(fish_hauled > 0)
		for(var/i in 1 to fish_hauled)
			add_sleep_experience(user, /datum/skill/labor/fishing, 10)
			record_featured_stat(FEATURED_STATS_FISHERS, user)
			record_round_statistic(STATS_FISH_CAUGHT)
	var/obj/item/fishingnet/N = new(user)
	N.max_durability = linked_net.max_durability
	N.durability = linked_net.durability
	N.max_integrity = N.max_durability
	N.obj_integrity = N.durability
	if(!user.put_in_hands(N))
		N.forceMove(user.drop_location())
	qdel(linked_net)
	qdel(src)

/obj/item/rope/netline/examine(mob/user)
	. = ..()
	if(!linked_net || QDELETED(linked_net))
		. += span_warning("It isn't attached to a net anymore.")
		return
	. += span_notice("The net feels heavy with [linked_net.catch_count()]/[linked_net.max_catch_capacity] fish.")
