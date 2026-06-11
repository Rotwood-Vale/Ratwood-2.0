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
	name = "灌木幼苗"
	desc = "一株可供种植的小灌木幼苗。它会在扎根时从土壤中汲取养分。"
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
	name = "枯死的灌木幼苗"
	density = FALSE
	opacity = FALSE
	pixel_x = 0
	icon = 'icons/roguetown/misc/crops.dmi'
	icon_state = "apple3"
	visible_message(span_warning("[src]因土壤条件太差而枯萎死去了。"))

/obj/structure/bush_sapling/proc/advance_stage()
	growth_progress = 0
	stage++
	switch(stage)
		if(BUSHSAP_STAGE_BUDDING)
			name = "萌芽灌木"
			icon = 'icons/roguetown/misc/foliage.dmi'
			icon_state = "bush2"
		if(BUSHSAP_STAGE_MATURE)
			name = "灌木"
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
		. += span_warning("它已经枯死，显然没法再继续生长了。")
		return
	// Standalone mature bush — soil already removed when it transitioned.
	if(stage == BUSHSAP_STAGE_MATURE)
		var/time_to_hedge = max(BUSHSAP_HEDGE_TIME - growth_progress, 0)
		if(growth_progress >= BUSHSAP_HEDGE_TIME * 0.7)
			. += span_warning("它很快就会长成高篱，大约还需要[DisplayTimeText(time_to_hedge)]。")
		else
			. += span_notice("它正稳步生长成高篱，大约还需要[DisplayTimeText(time_to_hedge)]。")

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
					user.visible_message(span_notice("[user]在[src]里找到了[B]。"))
					return
			user.visible_message(span_warning("[user]翻找着[src]。"))
			if(!looty.len)
				to_chat(user, span_warning("这里面什么也没找到。"))
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
		to_chat(user, span_notice("我开始修剪[src]。"))
		if(do_after(user, 3 SECONDS, target = src))
			var/num_fibers = rand(1, 2)
			for(var/i in 1 to num_fibers)
				new /obj/item/natural/fibers(user.loc)
			to_chat(user, span_notice("我从中剪下了[num_fibers]束[num_fibers == 1 ? "纤维" : "纤维"]。"))
			growth_progress = 0  // resets hedge-growth timer
		return

	// Shovelling out
	if(istype(I, /obj/item/rogueweapon/shovel))
		to_chat(user, span_notice("我开始把[src]铲掉。"))
		if(do_after(user, 3 SECONDS, target = src))
			to_chat(user, span_notice("我铲掉了[src]。"))
			qdel(src)
		return

	return ..()

//==============================================================================
// Flower sprout — planted from /obj/item/seeds/flower
//==============================================================================

/obj/structure/flower_sprout
	name = "花苗"
	desc = "一株刚种下的花苗，只要浇水就会慢慢开花。"
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
		. += span_info("已经浇过水了，它应该很快就会开花。")
	else
		. += span_info("给它浇点水，它应该很快就会开花。")

/obj/structure/flower_sprout/attackby(obj/item/I, mob/living/user, params)
	if(!watered && istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/RC = I
		var/water_amt = RC.reagents.get_reagent_amount(/datum/reagent/water)
		var/holy_amt  = RC.reagents.get_reagent_amount(/datum/reagent/water/holywater)
		if(water_amt + holy_amt <= 0)
			to_chat(user, span_warning("[RC]里没有水。"))
			return
		if(water_amt > 0)
			RC.reagents.remove_reagent(/datum/reagent/water, min(1, water_amt))
		else
			RC.reagents.remove_reagent(/datum/reagent/water/holywater, min(1, holy_amt))
		watered = TRUE
		to_chat(user, span_notice("我给[src]浇了水，它应该很快就会开花。"))
		timerid = addtimer(CALLBACK(src, PROC_REF(bloom)), 5 MINUTES, flags = TIMER_STOPPABLE)
		return
	if(watered && istype(I, /obj/item/reagent_containers))
		to_chat(user, span_info("它已经浇过水了。"))
		return
	if(istype(I, /obj/item/rogueweapon/shovel))
		to_chat(user, span_notice("我开始把[src]铲掉。"))
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
	name = "黄花苗"
	bloom_type = /obj/structure/flora/ausbushes/ywflowers

/obj/structure/flower_sprout/brflower
	name = "棕花苗"
	bloom_type = /obj/structure/flora/ausbushes/brflowers

/obj/structure/flower_sprout/ppflower
	name = "粉紫花苗"
	bloom_type = /obj/structure/flora/ausbushes/ppflowers

/obj/structure/flower_sprout/lavender
	name = "薰衣草苗"
	bloom_type = /obj/structure/flora/ausbushes/lavendergrass
