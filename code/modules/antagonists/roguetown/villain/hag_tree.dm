/**
 * Heartroot Tree — /obj/structure/roguemachine/mossmother/travel
 *
 * The hag's fast-travel network. Placed on the map via the hag_tree landmark.
 * - Hags can travel freely to any tree (10s cast, cooldown gated by hag_teleport_check).
 * - Curse-scarred mortals (TRAIT_CURSE_SCAR) can travel to any non-hut tree,
 *   and to the hut tree once all hag wards are destroyed.
 * - Plain mortals can only use the tree to enter/exit the hut after wards are gone.
 * - Feeding lux to a tree notifies all active hags with the area name and feeder.
 * - Hag is notified when any non-hag teleports into her bog or hut via the roots.
 */

/obj/structure/roguemachine/mossmother
	name = "Mossmother"
	desc = "One of the most sacred of trees. The very heart of the bog, its roots extend across every single inch of land drenched by maddened waters. Its moss is said to have magical properties."
	icon = 'icons/roguetown/items/hag/hag_tree.dmi'
	icon_state = "mossmother"
	density = TRUE
	max_integrity = 0 // Indestructible
	anchored = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/mossmother/travel
	name = "Heartroot Tree"
	desc = "No one knows why, but these trees seem nigh indestructible. You feel uneasy looking at this monstrosity of roots and bark."
	icon_state = "tree"
	var/cooldown_until = 0
	var/static/list/hag_lux_alert_times = list()

/obj/structure/roguemachine/mossmother/travel/Initialize(mapload)
	. = ..()
	GLOB.hag_trees += src

/obj/structure/roguemachine/mossmother/travel/Destroy()
	GLOB.hag_trees -= src
	return ..()

/obj/structure/roguemachine/mossmother/travel/attack_hand(mob/living/user)
	if(..())
		return
	handle_travel(user)

/obj/structure/roguemachine/mossmother/travel/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/reagent_containers/lux) || istype(W, /obj/item/reagent_containers/lux_impure))
		if(world.time < cooldown_until)
			var/remaining = round((cooldown_until - world.time) / 10)
			to_chat(user, span_warning("The tree is still sated. It will not hunger again for another [remaining] seconds."))
			return
		to_chat(user, span_boldnotice("You begin to feed the tree lux..."))
		if(!do_after(user, 2 SECONDS, target = src))
			return
		if(world.time < cooldown_until)
			return
		var/is_impure = istype(W, /obj/item/reagent_containers/lux_impure)
		user.visible_message(span_notice("[user] pours [W] over the roots of [src]."), \
			span_boldnotice("You feed the heartroot. The ground trembles as the Lux is absorbed."))
		qdel(W)
		notify_hag_lux_fed(user, is_impure)
		cooldown_until = world.time + (is_impure ? 90 SECONDS : 120 SECONDS)
		return
	return ..()

/// Notifies all active hags that a tree was fed with lux, including the feeder's name and area.
/obj/structure/roguemachine/mossmother/travel/proc/notify_hag_lux_fed(mob/living/feeder, is_impure = FALSE, alert_cooldown = 20 SECONDS)
	var/area/A = get_area(src)
	var/area_name = A ? A.name : "an unknown thicket"
	var/feeder_name = feeder ? feeder.real_name : "a mysterious force"
	for(var/obj/structure/roguemachine/hag_heart/heart in GLOB.hag_hearts)
		if(!heart.bound_hag?.owner?.current)
			continue
		var/key = "[REF(heart.bound_hag.owner)]:[REF(src)]:[is_impure]:[feeder ? REF(feeder.mind) : "none"]"
		var/last_alert = hag_lux_alert_times[key] || 0
		if(world.time < last_alert + alert_cooldown)
			continue
		hag_lux_alert_times[key] = world.time
		to_chat(heart.bound_hag.owner.current, \
			span_boldnotice("The roots hum deep within [area_name]... [feeder_name] has fed the network with [is_impure ? "Impure" : "Pure"] Lux!"))

/// Builds the destination list and opens the travel menu for the user.
/obj/structure/roguemachine/mossmother/travel/proc/handle_travel(mob/living/user)
	var/datum/antagonist/hag/hag_datum = user?.mind?.has_antag_datum(/datum/antagonist/hag)
	var/is_hag = !!hag_datum
	var/is_scarred = HAS_TRAIT(user, TRAIT_CURSE_SCAR)

	if(is_hag)
		var/datum/component/hag_curio_tracker/tracker = user.GetComponent(/datum/component/hag_curio_tracker)
		if(tracker && !tracker.hag_teleport_check())
			to_chat(user, span_warning("Your soul is still too frayed from your last return to walk the deep roots. Wait a bit longer..."))
			return
	else if(!is_scarred && length(GLOB.hag_wards))
		to_chat(user, span_warning("The roots refuse you. You bear no mark the Mossmother recognises."))
		return

	// Plain mortals only get the hut in/out shortcut once wards are gone.
	if(!is_hag && !is_scarred)
		if(length(GLOB.hag_wards))
			to_chat(user, span_warning("The roots twist away from your touch."))
			return
		var/area/my_area = get_area(src)
		if(istype(my_area, /area/rogue/indoors/shelter/bog_hag_hut))
			var/list/exits = list()
			for(var/obj/structure/roguemachine/mossmother/travel/T in GLOB.hag_trees)
				if(!istype(get_area(T), /area/rogue/indoors/shelter/bog_hag_hut))
					exits += T
			if(length(exits))
				do_teleport(user, pick(exits), FALSE)
			else
				to_chat(user, span_warning("The roots find no path out from here."))
		else
			for(var/obj/structure/roguemachine/mossmother/travel/T in GLOB.hag_trees)
				if(istype(get_area(T), /area/rogue/indoors/shelter/bog_hag_hut))
					do_teleport(user, T, FALSE)
					return
			to_chat(user, span_warning("The roots cannot find the hag's hut."))
		return

	var/list/destinations = list()
	for(var/obj/structure/roguemachine/mossmother/travel/tree in GLOB.hag_trees)
		if(tree == src)
			continue
		var/area/A = get_area(tree)
		var/is_hut = istype(A, /area/rogue/indoors/shelter/bog_hag_hut)
		// Scarred mortals can't reach the hut tree while wards still stand
		if(!is_hag && is_hut && length(GLOB.hag_wards))
			continue
		var/base_label = A ? A.name : "Unknown Thicket"
		var/label = base_label
		var/suffix = 2
		while(destinations[label])
			label = "[base_label] ([suffix])"
			suffix++
		destinations[label] = REF(tree)

	if(!length(destinations))
		to_chat(user, span_warning("The roots lead nowhere from here."))
		return

	var/selection = tgui_input_list(user, "Choose your destination", "Walk the Roots", destinations)
	if(!selection)
		return

	var/target_ref = destinations[selection]
	var/obj/structure/roguemachine/mossmother/travel/target = locate(target_ref) in GLOB.hag_trees
	if(!target)
		return

	do_teleport(user, target, is_hag)

/// Performs the actual teleport after a channelling delay, dragging any pulled mob along.
/obj/structure/roguemachine/mossmother/travel/proc/do_teleport(mob/living/user, obj/structure/roguemachine/mossmother/travel/target, is_hag = FALSE)
	if(!target || !user || !user.Adjacent(src))
		return

	var/mob/living/passenger = user.pulling
	if(passenger && get_dist(src, passenger) > 2)
		passenger = null

	var/wait_time = is_hag ? 10 SECONDS : 20 SECONDS
	user.visible_message(span_notice("[user] begins to sink into the mossy roots of [src]..."), \
		span_notice("You begin to dissolve into the network of roots, seeking the path to [get_area(target)]."))
	if(passenger)
		user.visible_message(span_danger("[user] begins to drag [passenger] into the mossy roots..."))

	if(!do_after(user, wait_time, target = src))
		return
	if(!target || !user.Adjacent(src))
		return

	var/turf/destination = get_step(target, SOUTH)
	if(!destination || destination.is_blocked_turf())
		destination = get_turf(target)

	user.forceMove(destination)
	user.visible_message(span_notice("[user] emerges from the roots of [target]."), \
		span_boldnotice("The roots spit you back out into [get_area(target)]."))

	if(passenger && get_dist(src, passenger) <= 2)
		passenger.forceMove(destination)
		to_chat(passenger, span_userdanger("You are dragged through the suffocating, muddy darkness of the roots!"))
