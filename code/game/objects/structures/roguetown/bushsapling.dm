// Bush Sapling & Flower Sprout — Dendor Content
#define BUSHSAP_STAGE_SAPLING 1
#define BUSHSAP_STAGE_BUDDING 2
#define BUSHSAP_STAGE_MATURE  3

#define BUSHSAP_STAGE_TIME   (5 MINUTES)
#define BUSHSAP_HEDGE_TIME   (5 MINUTES)
#define BUSHSAP_DEATH_TICKS  60   // negative-progress seconds before withering

//==============================================================================
// Non-blocking tall hedge — spawned when a bush sapling reaches stage 4.
//==============================================================================

/obj/structure/flora/roguegrass/bush/wall/tall/grown
	density = FALSE
	debris = list(/obj/item/natural/fibers = 1, /obj/item/natural/thorn = 1)

//==============================================================================
// Bush sapling
//==============================================================================

/obj/structure/bush_sapling
	name = "bush sapling"
	desc = "A small bush sapling, ready for planting. It draws from the soil while it takes root."
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	max_integrity = 15
	resistance_flags = FLAMMABLE
	icon = 'icons/roguetown/misc/crops.dmi'
	icon_state = "blackberry2"
	layer = OBJ_LAYER

	var/stage = BUSHSAP_STAGE_SAPLING
	var/growth_progress = 0
	var/dead = FALSE
	var/obj/structure/soil/linked_soil
	var/soil_water_drain = 3.0 / (1 MINUTES)
	var/soil_nutrition_drain = 2.0 / (1 MINUTES)

	// Stage-3 loot, mirrors /obj/structure/flora/roguegrass/bush
	var/bushtype = null
	var/list/looty = list()
	/// world.time threshold for loot refresh
	var/res_replenish = 0
	/// Prevents death before the sapling has received its first watering
	var/has_grown = FALSE

/obj/structure/bush_sapling/Initialize(mapload)
	. = ..()
	linked_soil = locate(/obj/structure/soil) in get_turf(src)
	if(linked_soil)
		RegisterSignal(linked_soil, COMSIG_QDELETING, PROC_REF(on_soil_deleted))
	START_PROCESSING(SSprocessing, src)

/obj/structure/bush_sapling/Destroy()
	if(linked_soil && !QDELETED(linked_soil))
		UnregisterSignal(linked_soil, COMSIG_QDELETING)
	linked_soil = null
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/structure/bush_sapling/proc/on_soil_deleted(datum/source)
	UnregisterSignal(source, COMSIG_QDELETING)
	linked_soil = null

/obj/structure/bush_sapling/process(dt)
	if(dead)
		return PROCESS_KILL

	if(stage <= BUSHSAP_STAGE_BUDDING)
		if(!linked_soil || QDELETED(linked_soil))
			wither_and_die()
			return PROCESS_KILL
		if(linked_soil.water > 0 && linked_soil.nutrition > 0)
			linked_soil.adjust_water(-dt * soil_water_drain)
			linked_soil.adjust_nutrition(-dt * soil_nutrition_drain)
			growth_progress += dt * linked_soil.get_environmental_growth_multiplier()
			has_grown = TRUE
		else if(has_grown)
			growth_progress -= dt * 2
			if(growth_progress <= -BUSHSAP_DEATH_TICKS)
				wither_and_die()
				return PROCESS_KILL
	else
		growth_progress += dt
	var/stage_time = (stage == BUSHSAP_STAGE_MATURE) ? BUSHSAP_HEDGE_TIME : BUSHSAP_STAGE_TIME
	if(growth_progress >= stage_time)
		advance_stage()

/obj/structure/bush_sapling/proc/wither_and_die()
	STOP_PROCESSING(SSprocessing, src)
	dead = TRUE
	name = "dead bush sapling"
	density = FALSE
	opacity = FALSE
	pixel_x = 0
	icon = 'icons/roguetown/misc/crops.dmi'
	icon_state = "apple3"
	visible_message(span_warning("[src] withers and dies from poor soil conditions."))

/obj/structure/bush_sapling/proc/advance_stage()
	growth_progress = 0
	stage++
	switch(stage)
		if(BUSHSAP_STAGE_BUDDING)
			name = "bush sprout"
			icon = 'icons/roguetown/misc/foliage.dmi'
			icon_state = "bush2"
		if(BUSHSAP_STAGE_MATURE)
			name = "bush"
			for(var/obj/structure/soil/S in get_turf(src))
				qdel(S)
			linked_soil = null
			// Pick loot type, same weighting as the wild bush
			if(isnull(bushtype))
				bushtype = pickweight(list(
					/obj/item/reagent_containers/food/snacks/grown/berries/rogue       = 5,
					/obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison = 3,
					/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed       = 1
				))
			loot_replenish()
			icon = 'icons/roguetown/misc/foliage.dmi'
			icon_state = "bush2"
			// Match regular wild bush integrity and add blade dulling
			max_integrity = 100
			obj_integrity = 100
			blade_dulling = DULLING_CUT
			destroy_sound = "plantcross"
		if(4)
			spawn_hedge()

/obj/structure/bush_sapling/proc/loot_replenish()
	looty = list()
	if(bushtype)
		looty += bushtype
	if(prob(66))
		looty += /obj/item/natural/thorn
	looty += /obj/item/natural/fibers

/obj/structure/bush_sapling/proc/spawn_hedge()
	new /obj/structure/flora/roguegrass/bush/wall/tall/grown(get_turf(src))
	qdel(src)

/obj/structure/bush_sapling/obj_destruction(damage_flag)
	if(stage == BUSHSAP_STAGE_MATURE && !dead)
		// Drop loot like a wild bush being destroyed
		new /obj/item/natural/fibers(get_turf(src))
		new /obj/item/natural/thorn(get_turf(src))
		if(looty.len)
			var/loot_type = pick(looty)
			new loot_type(get_turf(src))
	return ..()

/obj/structure/bush_sapling/Crossed(atom/movable/AM)
	. = ..()
	if(!dead && isliving(AM))
		playsound(src.loc, "plantcross", 50, FALSE, -1)

/obj/structure/bush_sapling/examine(mob/user)
	// While still rooted in soil (stages 1-2), forward examine to the soil plot — it shows all status/growth info.
	if(!dead && linked_soil && !QDELETED(linked_soil))
		return linked_soil.examine(user)
	. = ..()
	if(dead)
		. += span_warning("It has withered and died. Shovel it out to clear the spot.")
		return
	// Standalone mature bush — soil already removed when it transitioned.
	if(stage == BUSHSAP_STAGE_MATURE)
		var/time_to_hedge = max(BUSHSAP_HEDGE_TIME - growth_progress, 0)
		if(growth_progress >= BUSHSAP_HEDGE_TIME * 0.7)
			. += span_warning("It is looking overgrown. Shear it soon, or it will become a tall hedge in [DisplayTimeText(time_to_hedge)].")
		else
			. += span_notice("A mature bush. Shear it with scissors to keep it manageable, or leave it to grow into a taller hedge in [DisplayTimeText(time_to_hedge)].")

/obj/structure/bush_sapling/attack_hand(mob/user)
	// Stage-3: pickable like a wild bush
	if(stage == BUSHSAP_STAGE_MATURE && !dead)
		user.changeNext_move(CLICK_CD_INTENTCAP)
		playsound(src.loc, "plantcross", 50, FALSE, -1)
		if(do_after(user, 12, target = src))
			if(!looty.len && world.time > res_replenish)
				loot_replenish()
			if(prob(50) && looty.len)
				if(looty.len == 1)
					res_replenish = world.time + 8 MINUTES
				var/obj/item/B = pick_n_take(looty)
				if(B)
					B = new B(user.loc)
					user.put_in_hands(B)
					user.visible_message(span_notice("[user] finds [B] in [src]."))
					return
			user.visible_message(span_warning("[user] searches through [src]."))
			if(!looty.len)
				to_chat(user, span_warning("Picked clean... I should try later."))
		return
	return ..()

/obj/structure/bush_sapling/attackby(obj/item/I, mob/living/user, params)
	if(stage <= BUSHSAP_STAGE_BUDDING && !dead && linked_soil)
		if(linked_soil.try_handle_watering(I, user, params))
			return
		if(linked_soil.try_handle_fertilizing(I, user, params))
			return

	// Shearing at stage 3 — requires snip intent so the player opts in deliberately
	if((istype(I, /obj/item/rogueweapon/huntingknife/scissors) || istype(I, /obj/item/rogueweapon/huntingknife/throwingknife/bauernwehr)) && user.used_intent.type == /datum/intent/snip && stage == BUSHSAP_STAGE_MATURE && !dead)
		to_chat(user, span_notice("I begin trimming [src]..."))
		if(do_after(user, 3 SECONDS, target = src))
			var/num_fibers = rand(1, 2)
			for(var/i in 1 to num_fibers)
				new /obj/item/natural/fibers(user.loc)
			to_chat(user, span_notice("I trim back the overgrowth and collect [num_fibers] [num_fibers == 1 ? "fiber" : "fibers"]."))
			growth_progress = 0  // resets hedge-growth timer
		return

	// Shovelling out
	if(istype(I, /obj/item/rogueweapon/shovel))
		to_chat(user, span_notice("I begin uprooting [src]..."))
		if(do_after(user, 3 SECONDS, target = src))
			to_chat(user, span_notice("I remove [src]."))
			qdel(src)
		return

	return ..()

//==============================================================================
// Flower sprout — planted from /obj/item/seeds/flower
//==============================================================================

/obj/structure/flower_sprout
	name = "flower sprout"
	desc = "A freshly planted flower seed. Water it and step back."
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	max_integrity = 5
	resistance_flags = FLAMMABLE
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "palebush_1"
	layer = OBJ_LAYER

	var/watered = FALSE
	var/bloom_type = /obj/structure/flora/ausbushes/ywflowers
	var/timerid = null

/obj/structure/flower_sprout/Destroy()
	if(timerid)
		deltimer(timerid)
	return ..()

/obj/structure/flower_sprout/examine(mob/user)
	. = ..()
	if(watered)
		. += span_info("Already watered — it should bloom soon.")
	else
		. += span_info("It needs watering to start growing.")

/obj/structure/flower_sprout/attackby(obj/item/I, mob/living/user, params)
	if(!watered && istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/RC = I
		var/water_amt = RC.reagents.get_reagent_amount(/datum/reagent/water)
		var/holy_amt  = RC.reagents.get_reagent_amount(/datum/reagent/water/holywater)
		if(water_amt + holy_amt <= 0)
			to_chat(user, span_warning("[RC] doesn't have any water in it."))
			return
		if(water_amt > 0)
			RC.reagents.remove_reagent(/datum/reagent/water, min(1, water_amt))
		else
			RC.reagents.remove_reagent(/datum/reagent/water/holywater, min(1, holy_amt))
		watered = TRUE
		to_chat(user, span_notice("I water [src]. It should bloom soon."))
		timerid = addtimer(CALLBACK(src, PROC_REF(bloom)), 5 MINUTES, flags = TIMER_STOPPABLE)
		return
	if(watered && istype(I, /obj/item/reagent_containers))
		to_chat(user, span_info("Already watered; just needs time now."))
		return
	if(istype(I, /obj/item/rogueweapon/shovel))
		to_chat(user, span_notice("I begin uprooting [src]..."))
		if(do_after(user, 2 SECONDS, target = src))
			qdel(src)
		return
	return ..()

/obj/structure/flower_sprout/proc/bloom()
	if(QDELETED(src))
		return
	new bloom_type(get_turf(src))
	qdel(src)

// Subtypes — one per flower variety

/obj/structure/flower_sprout/yellow
	name = "yellow flower sprout"
	bloom_type = /obj/structure/flora/ausbushes/ywflowers

/obj/structure/flower_sprout/brflower
	name = "blue & red flower sprout"
	bloom_type = /obj/structure/flora/ausbushes/brflowers

/obj/structure/flower_sprout/ppflower
	name = "purple & pink flower sprout"
	bloom_type = /obj/structure/flora/ausbushes/ppflowers

/obj/structure/flower_sprout/lavender
	name = "lavender sprout"
	bloom_type = /obj/structure/flora/ausbushes/lavendergrass
