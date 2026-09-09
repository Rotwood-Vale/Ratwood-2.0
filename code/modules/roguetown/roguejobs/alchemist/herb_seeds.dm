/obj/item/herbseed
	name = "herb seeds"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "seeds"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	possible_item_intents = list(/datum/intent/use)
	var/makes_herb = null
	var/seed_identity = "unknown"

/obj/item/herbseed/examine(mob/user)
	. = ..()
	var/show_real_identity = FALSE
	if(isliving(user))
		var/mob/living/living = user
		if(HAS_TRAIT(living, TRAIT_SEEDKNOW) || HAS_TRAIT(living,TRAIT_LEGENDARY_ALCHEMIST))
			show_real_identity = TRUE
		// Alchemy seeds, so they would know them
		else if(living.get_skill_level(/datum/skill/craft/alchemy) >= 2 || living.get_skill_level(/datum/skill/labor/farming) >= 2)
			show_real_identity = TRUE
	else
		show_real_identity = TRUE
	if(show_real_identity)
		. += span_info("I can tell these are [seed_identity]")

/obj/item/herbseed/attack_turf(turf/T, mob/living/user)
	var/obj/structure/soil/soil = get_soil_on_turf(T)
	if(soil)
		try_plant_seed(user, soil)
		return
	else if(istype(T, /turf/open/floor/rogue/dirt))
		to_chat(user, span_notice("I begin making a mound for the seeds..."))
		if(do_after(user, get_farming_do_time(user, 10 SECONDS), target = src))
			apply_farming_fatigue(user, 30)
			soil = get_soil_on_turf(T)
			if(!soil)
				soil = new /obj/structure/soil(T)
			try_plant_seed(user, soil)
		return
	. = ..()

/obj/item/herbseed/proc/try_plant_seed(mob/living/user, obj/structure/soil/soil)
	if(soil.plant || soil.has_custom_growth())
		to_chat(user, span_warning("There is already something planted in \the [soil]!"))
		return
	to_chat(user, span_notice("I plant \the [src] in \the [soil]. I should check back later when it has grown."))
	var/obj/structure/soil_seedling/herb/seedling = new(get_turf(soil))
	seedling.configure_seedling(soil, icon, icon_state, makes_herb, 5 MINUTES)
	seedling.desc = "A small seedling bedded in a soil plot. It will need healthy soil to sprout."
	qdel(src)
	return

/obj/item/herbseed/proc/become_plant(obj/structure/soil/soil,to_make)
	if(ispath(to_make))
		var/obj/structure/flora/roguegrass/herb/newplant = new to_make
		newplant.forceMove(get_turf(soil))
		newplant.pixel_x += rand(-3,3)
		soil.visible_message(span_info("The [soil] suddenly bursts away to reveal \the [newplant]!"))
	else
		soil.visible_message(span_info("The [soil] suddenly collapses, leaving nothing behind..."))
	qdel(soil)
	return

/obj/structure/soil_seedling
	name = "seedling"
	desc = "A small seedling bedded in a soil plot."
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	max_integrity = 5
	resistance_flags = FLAMMABLE
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "seeds"
	layer = OBJ_LAYER
	var/obj/structure/soil/linked_soil
	var/seed_icon = 'icons/roguetown/items/produce.dmi'
	var/seed_state = "seeds"
	var/final_type
	var/grow_duration = 5 MINUTES
	var/growth_progress = 0
	var/soil_water_drain = 1.0 / (1 MINUTES)
	var/soil_nutrition_drain = 1.0 / (1 MINUTES)
	var/final_pixel_x_jitter = 0
	var/stage = 1

/obj/structure/soil_seedling/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/structure/soil_seedling/Destroy()
	if(linked_soil && !QDELETED(linked_soil))
		UnregisterSignal(linked_soil, COMSIG_QDELETING)
	linked_soil = null
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/structure/soil_seedling/proc/on_soil_deleted(datum/source)
	UnregisterSignal(source, COMSIG_QDELETING)
	linked_soil = null

/obj/structure/soil_seedling/proc/configure_seedling(obj/structure/soil/soil, _seed_icon, _seed_state, _final_type, _grow_duration)
	if(linked_soil && !QDELETED(linked_soil))
		UnregisterSignal(linked_soil, COMSIG_QDELETING)
	linked_soil = soil
	if(linked_soil)
		RegisterSignal(linked_soil, COMSIG_QDELETING, PROC_REF(on_soil_deleted))
	seed_icon = _seed_icon
	seed_state = _seed_state
	final_type = _final_type
	grow_duration = _grow_duration
	icon = seed_icon
	icon_state = seed_state

/obj/structure/soil_seedling/process(dt)
	if(!linked_soil || QDELETED(linked_soil))
		qdel(src)
		return PROCESS_KILL
	if(linked_soil.water > 0 && linked_soil.nutrition > 0)
		linked_soil.adjust_water(-dt * soil_water_drain)
		linked_soil.adjust_nutrition(-dt * soil_nutrition_drain)
		growth_progress += dt * linked_soil.get_environmental_growth_multiplier()
	else
		growth_progress = max(growth_progress - dt * 2, 0)
	if(stage == 1 && growth_progress >= (grow_duration / 2))
		stage = 2
		icon = 'icons/roguetown/misc/crops.dmi'
		icon_state = "sunflower0"
	if(growth_progress >= grow_duration)
		bloom()
		return

/obj/structure/soil_seedling/attackby(obj/item/I, mob/living/user, params)
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

/obj/structure/soil_seedling/examine(mob/user)
	// Forward examine to the soil plot — it shows all growth and soil status info.
	if(linked_soil && !QDELETED(linked_soil))
		return linked_soil.examine(user)
	. = ..()

/obj/structure/soil_seedling/proc/bloom()
	if(QDELETED(src) || !ispath(final_type))
		return
	var/atom/movable/final_growth = new final_type(get_turf(src))
	if(final_pixel_x_jitter && final_growth)
		final_growth.pixel_x += rand(-final_pixel_x_jitter, final_pixel_x_jitter)
	if(linked_soil && !QDELETED(linked_soil))
		linked_soil.visible_message(span_info("The [linked_soil] parts as [final_growth] pushes through the earth!"))
		qdel(linked_soil)
	qdel(src)

/obj/structure/soil_seedling/herb
	name = "herb seedling"
	final_pixel_x_jitter = 3

/obj/structure/soil_seedling/flower
	name = "flower seedling"

/obj/item/herbseed/atropa
	makes_herb = /obj/structure/flora/roguegrass/herb/atropa
	seed_identity = "atropa seeds"

/obj/item/herbseed/matricaria
	makes_herb = /obj/structure/flora/roguegrass/herb/matricaria
	seed_identity = "matricaria seeds"

/obj/item/herbseed/symphitum
	makes_herb = /obj/structure/flora/roguegrass/herb/symphitum
	seed_identity = "symphitum seeds"

/obj/item/herbseed/taraxacum
	makes_herb = /obj/structure/flora/roguegrass/herb/taraxacum
	seed_identity = "taraxacum seeds"

/obj/item/herbseed/euphrasia
	makes_herb = /obj/structure/flora/roguegrass/herb/euphrasia
	seed_identity = "euphrasia seeds"

/obj/item/herbseed/paris
	makes_herb = /obj/structure/flora/roguegrass/herb/paris
	seed_identity = "paris seeds"

/obj/item/herbseed/calendula
	makes_herb = /obj/structure/flora/roguegrass/herb/calendula
	seed_identity = "calendula seeds"

/obj/item/herbseed/mentha
	makes_herb = /obj/structure/flora/roguegrass/herb/mentha
	seed_identity = "mentha seeds"

/obj/item/herbseed/urtica
	makes_herb = /obj/structure/flora/roguegrass/herb/urtica
	seed_identity = "urtica seeds"

/obj/item/herbseed/salvia
	makes_herb = /obj/structure/flora/roguegrass/herb/salvia
	seed_identity = "salvia seeds"

/obj/item/herbseed/hypericum
	makes_herb = /obj/structure/flora/roguegrass/herb/hypericum
	seed_identity = "hypericum seeds"

/obj/item/herbseed/benedictus
	makes_herb = /obj/structure/flora/roguegrass/herb/benedictus
	seed_identity = "benedictus seeds"

/obj/item/herbseed/valeriana
	makes_herb = /obj/structure/flora/roguegrass/herb/valeriana
	seed_identity = "valeriana seeds"

/obj/item/herbseed/artemisia
	makes_herb = /obj/structure/flora/roguegrass/herb/artemisia
	seed_identity = "artemisia seeds"

/obj/item/herbseed/rosa
	makes_herb = /obj/structure/flora/roguegrass/herb/rosa
	seed_identity = "rosa seeds"

/obj/item/herbseed/manabloom
	makes_herb = /obj/structure/flora/roguegrass/herb/manabloom
	seed_identity = "manabloom seeds"
