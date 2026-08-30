// Tree Sapling — Dendor Content
// Planted by druids and skilled farmers using tree seeds.
// Grows through 4 stages with proper watering:
//   Stage 1 (SAPLING):     small seedling sprite, needs water
//   Stage 2 (SHRUB):       shrub sprite, needs water
//   Stage 3 (YOUNG_TREE):  young tree sprite, removes soil below, standalone
//   Stage 4:               spawns the final tree structure, qdels self

#define TREESAP_STAGE_SAPLING 1
#define TREESAP_STAGE_SHRUB   2
#define TREESAP_STAGE_YOUNG   3

#define TREESAP_WATER_MAX    200
#define TREESAP_STAGE_TIME   (10 MINUTES)
#define TREESAP_YOUNG_TIME   (5 MINUTES)
#define TREESAP_WATER_DRAIN  0.5  // water units lost per second (~6.7 min to dry)
#define TREESAP_DEATH_TICKS  60   // negative-progress seconds before dying

/obj/structure/tree_sapling
	name = "tree sapling"
	desc = "A tender sapling bedded in mounded soil. It needs regular watering to take root."
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	max_integrity = 20
	resistance_flags = FLAMMABLE
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "palebush_2"
	layer = OBJ_LAYER

	var/stage = TREESAP_STAGE_SAPLING
	var/growth_progress = 0
	var/dead = FALSE
	var/obj/structure/soil/linked_soil
	var/soil_water_drain = 3.0 / (1 MINUTES)
	var/soil_nutrition_drain = 2.0 / (1 MINUTES)
	var/has_grown = FALSE   // prevents death before first watering

	// What tree to spawn when fully grown
	var/tree_final_type = /obj/structure/flora/newtree

	// Per-stage icon data (stage 1 uses own icon/icon_state)
	var/stage2_icon  = 'icons/obj/flora/ausflora.dmi'
	var/stage2_state = "sunnybush_1"
	var/stage3_icon  = 'icons/roguetown/misc/foliagetall.dmi'
	var/stage3_state = "t12"
	var/dead_icon    = 'icons/roguetown/misc/crops.dmi'
	var/dead_state   = "lemon3"
	// pixel offsets applied when advancing stages
	var/stage2_pixel_x = 0
	var/stage2_pixel_y = 0
	var/stage3_pixel_x = 1
	var/stage3_pixel_y = 0

/obj/structure/tree_sapling/Initialize(mapload)
	. = ..()
	linked_soil = locate(/obj/structure/soil) in get_turf(src)
	if(linked_soil)
		RegisterSignal(linked_soil, COMSIG_QDELETING, PROC_REF(on_soil_deleted))
	START_PROCESSING(SSprocessing, src)

/obj/structure/tree_sapling/Destroy()
	if(linked_soil && !QDELETED(linked_soil))
		UnregisterSignal(linked_soil, COMSIG_QDELETING)
	linked_soil = null
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/structure/tree_sapling/proc/on_soil_deleted(datum/source)
	UnregisterSignal(source, COMSIG_QDELETING)
	linked_soil = null

/obj/structure/tree_sapling/process(dt)
	if(dead)
		return PROCESS_KILL

	if(stage <= TREESAP_STAGE_SHRUB)
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
			if(growth_progress <= -TREESAP_DEATH_TICKS)
				wither_and_die()
				return PROCESS_KILL
	else
		growth_progress += dt
	var/stage_time = (stage == TREESAP_STAGE_YOUNG) ? TREESAP_YOUNG_TIME : TREESAP_STAGE_TIME
	if(growth_progress >= stage_time)
		advance_stage()

/obj/structure/tree_sapling/proc/wither_and_die()
	STOP_PROCESSING(SSprocessing, src)
	dead = TRUE
	name = "withered sapling"
	density = FALSE
	opacity = FALSE
	pixel_x = 0
	icon = dead_icon
	icon_state = dead_state
	visible_message(span_warning("[src] withers and dies from lack of water."))

/obj/structure/tree_sapling/proc/advance_stage()
	growth_progress = 0
	stage++
	switch(stage)
		if(TREESAP_STAGE_SHRUB)
			icon = stage2_icon
			icon_state = stage2_state
			pixel_x = stage2_pixel_x
			pixel_y = stage2_pixel_y
			max_integrity = 100
			obj_integrity = 100
			static_debris = list(/obj/item/natural/fibers = 1, /obj/item/grown/log/tree/stick = 1)
			destroy_sound = "plantcross"
		if(TREESAP_STAGE_YOUNG)
			for(var/obj/structure/soil/S in get_turf(src))
				qdel(S)
			linked_soil = null
			icon = stage3_icon
			icon_state = stage3_state
			density = TRUE
			opacity = TRUE
			pixel_x = stage3_pixel_x
			pixel_y = stage3_pixel_y
			max_integrity = 150
			obj_integrity = 150
			blade_dulling = DULLING_CUT
			attacked_sound = 'sound/misc/woodhit.ogg'
			destroy_sound = 'sound/misc/treefall.ogg'
		if(4)
			spawn_final_tree()

/obj/structure/tree_sapling/proc/spawn_final_tree()
	var/atom/movable/final_tree = new tree_final_type(get_turf(src))
	if(final_tree)
		final_tree.pixel_x = pixel_x
		final_tree.pixel_y = pixel_y
	qdel(src)

/obj/structure/tree_sapling/proc/drop_withered_loot()
	if(prob(20))
		new /obj/item/grown/log/tree/small(get_turf(src))
		return
	new /obj/item/grown/log/tree/stick(get_turf(src))
	new /obj/item/grown/log/tree/stick(get_turf(src))

/obj/structure/tree_sapling/obj_destruction(damage_flag)
	if(stage == TREESAP_STAGE_YOUNG)
		new /obj/item/grown/log/tree(get_turf(src))
		if(prob(50))
			new /obj/item/grown/log/tree/stick(get_turf(src))
	return ..()

/obj/structure/tree_sapling/examine(mob/user)
	// While alive and rooted in soil, forward examine to the soil plot — it shows all growth and status info.
	if(!dead && linked_soil && !QDELETED(linked_soil))
		return linked_soil.examine(user)
	. = ..()
	if(dead)
		. += span_warning("It has withered and died. Shovel it out to clear the spot.")
		return
	// Standalone young tree — soil already removed when it transitioned.
	if(stage == TREESAP_STAGE_YOUNG)
		. += span_notice("A young tree still taking root. It should grow on its own now.")
		if(isliving(user))
			var/mob/living/living_user = user
			if(living_user.get_skill_level(/datum/skill/labor/farming) >= SKILL_LEVEL_EXPERT || HAS_TRAIT(living_user, TRAIT_SEEDKNOW))
				var/time_remaining = max(TREESAP_YOUNG_TIME - growth_progress, 0)
				. += span_info("Estimated time to finish growing: [DisplayTimeText(time_remaining)].")

/obj/structure/tree_sapling/attackby(obj/item/I, mob/living/user, params)
	if(stage <= TREESAP_STAGE_SHRUB && !dead && linked_soil)
		if(linked_soil.try_handle_watering(I, user, params))
			return
		if(linked_soil.try_handle_fertilizing(I, user, params))
			return

	// Shovelling out
	if(istype(I, /obj/item/rogueweapon/shovel))
		to_chat(user, span_notice("I begin uprooting [src]..."))
		playsound(src, 'sound/items/dig_shovel.ogg', 80, TRUE)
		if(do_after(user, 3 SECONDS, target = src))
			if(dead)
				drop_withered_loot()
			to_chat(user, span_notice("I remove [src]."))
			qdel(src)
		return

	return ..()

//==============================================================================
// Subtypes
//==============================================================================

/obj/structure/tree_sapling/pine
	name = "pine sapling"
	desc = "A tender pine sapling. Keep it watered and it will grow into a tall pine tree."
	icon_state = "palebush_3"
	stage2_state = "pointybush_1"
	stage3_state = "t11"
	dead_state = "apple3"
	tree_final_type = /obj/structure/flora/roguetree/pine

/obj/structure/tree_sapling/sakura
	name = "sakura sapling"
	desc = "A tender cherry-blossom sapling. Water it faithfully and it will reward you with clouds of pink bloom."
	icon_state = "palebush_1"
	stage2_state = "pinkbush"
	stage3_state = "t10"
	stage3_pixel_x = -10
	dead_state = "apple3"
	tree_final_type = /obj/structure/flora/sakura

// Override: do not copy sapling pixel_x to the sakura tree — let the tree use its own defined offset.
/obj/structure/tree_sapling/sakura/spawn_final_tree()
	new tree_final_type(get_turf(src))
	qdel(src)
