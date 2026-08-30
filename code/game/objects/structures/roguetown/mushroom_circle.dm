// Fey Mushroom Circle
//
// GROWTH CHAIN (fey circles only — base mushroom_circle is a plain map decoration):
//   /obj/item/seeds/mushroom_fey  →  planted in blessed soil, watered once
//   /obj/structure/mushroom_sprout (5 min)
//   /obj/structure/mushroom_circle/fey (active portal, tinymushrooms sprite)
//      ↓ 20 min without scissors maintenance
//   mushroomcluster sprite (unusable)
//      ↓ 10 more min
//   /obj/structure/flora/rogueshroom  (random mush1-5, final dead state)
//
// Teleportation (fey only):
//   Hold Dendor amulet → click circle → choose destination → 3 sec cast
//   You must stand inside the circle, and every living being standing in it travels together.
//
// Renaming (fey only):
//   Click with /obj/item/natural/feather (name only, no description editing).

GLOBAL_LIST_EMPTY(mushroom_circles)

//==============================================================================
// Mushroom Fey Sprout
//==============================================================================

/obj/structure/mushroom_sprout
	name = "fey mushroom sprout"
	desc = "A colony of tiny pale shoots, faintly alive with fey energy. Water it and it should bloom."
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	max_integrity = 5
	resistance_flags = FLAMMABLE
	icon = 'icons/roguetown/misc/crops.dmi'
	icon_state = "fyritius0"
	layer = OBJ_LAYER

	var/obj/structure/soil/linked_soil
	var/growth_progress = 0
	var/has_grown = FALSE   // prevents death before first watering
	var/soil_water_drain = 1.0 / (1 MINUTES)
	var/soil_nutrition_drain = 0.75 / (1 MINUTES)

/obj/structure/mushroom_sprout/Initialize(mapload)
	. = ..()
	linked_soil = locate(/obj/structure/soil) in get_turf(src)
	START_PROCESSING(SSprocessing, src)

/obj/structure/mushroom_sprout/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/structure/mushroom_sprout/process(dt)
	if(!linked_soil || QDELETED(linked_soil))
		qdel(src)
		return
	if(linked_soil.blessed_time > 0 && linked_soil.water > 0 && linked_soil.nutrition > 0)
		linked_soil.adjust_water(-dt * soil_water_drain)
		linked_soil.adjust_nutrition(-dt * soil_nutrition_drain)
		growth_progress += dt * linked_soil.get_environmental_growth_multiplier()
		has_grown = TRUE
	else if(has_grown)
		growth_progress -= dt * 2
		if(growth_progress <= -60)
			visible_message(span_warning("[src] withers back into the blessed soil."))
			qdel(src)
			return
	if(growth_progress >= 10 MINUTES)
		bloom()

/obj/structure/mushroom_sprout/examine(mob/user)
	. = ..()
	var/time_to_bloom = max((10 MINUTES) - growth_progress, 0)
	. += span_info("It will bloom into a fey mushroom circle in approximately [DisplayTimeText(time_to_bloom)] if well tended.")
	if(linked_soil)
		if(linked_soil.blessed_time <= 0)
			. += span_warning("The soil's blessing is fading; the sprout will not endure without it.")
		if(linked_soil.water <= 45)
			. += span_warning("The soil beneath it is thirsty.")
		else if(linked_soil.water <= 150)
			. += span_info("The soil beneath it is moist.")
		else
			. += span_info("The soil beneath it is wet.")
		if(linked_soil.nutrition <= 45)
			. += span_warning("The soil beneath it is hungry.")
		else if(linked_soil.nutrition <= 150)
			. += span_info("The soil beneath it is sated.")
		else
			. += span_info("The soil beneath it looks fertile.")

/obj/structure/mushroom_sprout/attackby(obj/item/I, mob/living/user, params)
	if(linked_soil)
		if(linked_soil.try_handle_watering(I, user, params))
			return
		if(linked_soil.try_handle_fertilizing(I, user, params))
			return
	if(istype(I, /obj/item/rogueweapon/shovel))
		to_chat(user, span_notice("I begin uprooting [src]..."))
		if(do_after(user, 2 SECONDS, target = src))
			qdel(src)
		return
	return ..()

/obj/structure/mushroom_sprout/proc/bloom()
	if(QDELETED(src))
		return
	if(linked_soil && !QDELETED(linked_soil))
		qdel(linked_soil)
	new /obj/structure/mushroom_circle/fey(get_turf(src))
	qdel(src)

/obj/structure/mushroom_circle
	name = "mushroom circle"
	desc = "A ring of pale and purple mushrooms growing in a perfect circle."
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	obj_flags = CAN_BE_HIT
	max_integrity = 50
	resistance_flags = FLAMMABLE
	icon = 'icons/roguetown/misc/foliage.dmi'
	icon_state = "tinymushrooms"
	layer = OBJ_LAYER

//==============================================================================
// Fey Mushroom Circle — player-grown, teleport-capable subtype
//==============================================================================
/obj/structure/mushroom_circle/fey
	name = "fey mushroom circle"
	desc = "A magical ring of pale and purple mushrooms that pulse with faint light. Druids of Dendor use these as waypoints to travel across long distances instantly."
	max_integrity = 200
	attacked_sound = 'sound/misc/woodhit.ogg'
	destroy_sound = "plantcross"

	/// Seconds since last scissors maintenance
	var/maintenance_elapsed = 0
	/// TRUE while usable as a portal; set to FALSE when decaying
	var/active = TRUE
	/// Timer ID for the final_decay timer so it can be cancelled on Destroy().
	var/decay_timerid = null
	/// world.time moment when final decay will occur after overgrowth starts.
	var/decay_finish_time = 0

/obj/structure/mushroom_circle/fey/Initialize(mapload)
	. = ..()
	GLOB.mushroom_circles |= src
	set_light(3, 3, 3, l_color = "#5D3FD3")
	START_PROCESSING(SSprocessing, src)

/obj/structure/mushroom_circle/fey/Destroy()
	GLOB.mushroom_circles -= src
	STOP_PROCESSING(SSprocessing, src)
	if(decay_timerid)
		deltimer(decay_timerid)
		decay_timerid = null
	return ..()

/obj/structure/mushroom_circle/fey/obj_destruction(damage_flag)
	for(var/i in 1 to rand(1, 2))
		new /obj/item/natural/fibers(get_turf(src))
	return ..()

/obj/structure/mushroom_circle/fey/process(dt)
	if(!active)
		return
	maintenance_elapsed += dt
	if(maintenance_elapsed >= 90 MINUTES)
		begin_decay()

/obj/structure/mushroom_circle/fey/proc/begin_decay()
	active = FALSE
	GLOB.mushroom_circles -= src
	set_light(0)
	icon = 'icons/roguetown/misc/foliage.dmi'
	icon_state = "mushroomcluster"
	desc = "A withered ring of mushrooms that has lost its fey connection."
	visible_message(span_warning("[src] begins to wither — the mystical light flickers and dies."))
	decay_finish_time = world.time + 5 MINUTES
	decay_timerid = addtimer(CALLBACK(src, PROC_REF(final_decay)), 5 MINUTES, flags = TIMER_STOPPABLE)

/obj/structure/mushroom_circle/fey/proc/final_decay()
	if(QDELETED(src))
		return
	new /obj/structure/flora/rogueshroom(get_turf(src))
	qdel(src)

/obj/structure/mushroom_circle/fey/examine(mob/user)
	. = ..()
	if(!active)
		var/time_to_final_decay = max(decay_finish_time - world.time, 0)
		. += span_warning("The circle has lost its power and has become overgrown. Its fey connection is severed — it will collapse in [DisplayTimeText(time_to_final_decay)].")
		return
	var/time_to_overgrowth = max((90 MINUTES) - maintenance_elapsed, 0)
	if(maintenance_elapsed > (75 MINUTES))
		. += span_warning("The mushrooms look unhealthy. Prune them with scissors soon or the circle will become overgrown in [DisplayTimeText(time_to_overgrowth)].")
	else
		. += span_info("The mushrooms glow steadily with fey power. They will become overgrown in [DisplayTimeText(time_to_overgrowth)] if left untended.")
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.patron && H.patron.type == /datum/patron/divine/dendor)
			if(H.get_skill_level(/datum/skill/magic/druidic) >= SKILL_LEVEL_EXPERT)
				. += span_notice("Hold my amulet of Dendor and press it on this circle to travel to another fey circle.")
			else
				. += span_warning("The fey's mysteries are beyond my current understanding — I need greater druidic training to commune with this circle.")

/obj/structure/mushroom_circle/fey/attackby(obj/item/I, mob/living/user, params)
	// Only block fey circle USE actions from low-skill users — attacking/chopping is always allowed.
	var/is_fey_use = istype(I, /obj/item/natural/feather) || istype(I, /obj/item/clothing/neck/roguetown/psicross/dendor) || ((istype(I, /obj/item/rogueweapon/huntingknife/scissors) || istype(I, /obj/item/rogueweapon/huntingknife/throwingknife/bauernwehr)) && user.used_intent.type == /datum/intent/snip)
	if(is_fey_use && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.get_skill_level(/datum/skill/magic/druidic) < SKILL_LEVEL_EXPERT)
			to_chat(user, span_warning("The fey magic in this circle is beyond my understanding — I need greater druidic training to commune with it."))
			return

	// Feather rename support — name only, no description editing.
	if(istype(I, /obj/item/natural/feather))
		var/new_name = stripped_input(user, "What do you want to name this fey circle?", "Rename Fey Circle", "", MAX_NAME_LEN)
		if(!new_name || QDELETED(src) || !user.canUseTopic(src, BE_CLOSE))
			return
		var/old_name = name
		if(old_name == new_name)
			to_chat(user, span_notice("The fey circle keeps its name."))
		else
			name = "[new_name] ([initial(name)])"
			renamedByPlayer = TRUE
			to_chat(user, span_notice("I rename [old_name] to [new_name]."))
		return

	// Scissors/bauernwehr maintenance — requires snip intent so attacks don't accidentally maintain it
	if((istype(I, /obj/item/rogueweapon/huntingknife/scissors) || istype(I, /obj/item/rogueweapon/huntingknife/throwingknife/bauernwehr)) && user.used_intent.type == /datum/intent/snip)
		if(!active)
			to_chat(user, span_warning("The circle has already faded — it can't be restored now."))
			return
		to_chat(user, span_notice("I carefully tend to [src]..."))
		if(do_after(user, 3 SECONDS, target = src))
			if(!active)
				return
			maintenance_elapsed = 0
			to_chat(user, span_notice("[src] looks well-maintained. The mystical glow brightens."))
		return

	// Dendor amulet — opens fey teleport menu
	if(istype(I, /obj/item/clothing/neck/roguetown/psicross/dendor))
		if(!user.patron || user.patron.type != /datum/patron/divine/dendor)
			to_chat(user, span_warning("Only a follower of Dendor may commune with this circle."))
			return
		if(!active)
			to_chat(user, span_warning("This circle has waned in power — it can no longer carry you anywhere."))
			return
		open_teleport_menu(user)
		return

	return ..()

/obj/structure/mushroom_circle/fey/proc/open_teleport_menu(mob/living/user)
	// 30-second per-user cooldown between fey circle uses.
	if(world.time < (user.mob_timers["feycircle_cooldown"] + 30 SECONDS))
		var/remaining = (user.mob_timers["feycircle_cooldown"] + 30 SECONDS) - world.time
		to_chat(user, span_warning("I must wait [DisplayTimeText(remaining)] before the fey energy recharges inside the ring."))
		return
	if(get_turf(user) != get_turf(src))
		to_chat(user, span_warning("I must stand within the mushroom circle to traverse the fey paths."))
		return
	var/list/choices = list()
	for(var/obj/structure/mushroom_circle/fey/C in GLOB.mushroom_circles)
		if(C == src || !C.active)
			continue
		choices[C.name] = C

	if(!choices.len)
		to_chat(user, span_warning("There are no other active fey mushroom circles within the network."))
		return

	var/choice = input(user, "Which circle do you wish to travel to?", "Fey Mushroom Circle Network") as null|anything in choices
	if(isnull(choice) || QDELETED(src) || QDELETED(user))
		return

	var/obj/structure/mushroom_circle/fey/dest = choices[choice]
	if(QDELETED(dest) || !dest.active)
		to_chat(user, span_warning("That circle has faded since you made your choice."))
		return

	to_chat(user, span_notice("I focus on [dest.name]..."))
	if(!do_after(user, 3 SECONDS, target = src))
		return
	if(QDELETED(dest) || !dest.active)
		to_chat(user, span_warning("The destination circle faded mid-journey."))
		return

	var/turf/dest_turf = get_turf(dest)
	var/turf/source_turf = get_turf(src)
	var/list/travelers = list()
	for(var/mob/living/L in source_turf)
		if(!QDELETED(L))
			travelers += L

	playsound(source_turf, 'sound/misc/portalopen.ogg', 50, FALSE)
	for(var/mob/living/L in travelers)
		L.forceMove(dest_turf)
	playsound(dest_turf, 'sound/misc/portalopen.ogg', 50, FALSE)

	to_chat(user, span_notice("I step into the ring, planting my feet firmly and emerge at [dest.name]."))
	user.mob_timers["feycircle_cooldown"] = world.time
