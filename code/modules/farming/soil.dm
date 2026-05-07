#define MAX_PLANT_HEALTH 100
#define MAX_PLANT_WATER 300
#define MAX_PLANT_NUTRITION 300
#define MAX_PLANT_WEEDS 100
#define SOIL_DECAY_TIME 10 MINUTES

GLOBAL_LIST_EMPTY(soil_list)

/obj/structure/soil
	name = "soil"
	desc = "Dirt, ready to give life like a womb."
	icon = 'icons/obj/structures/soil.dmi'
	icon_state = "soil"
	density = FALSE
	climbable = FALSE
	max_integrity = 0
	/// Amount of water in the soil. It makes the plant and weeds not loose health
	var/water = 0
	/// Amount of weeds in the soil. The more of them the more water and nutrition they eat.
	var/weeds = 0
	/// Amount of nutrition in the soil. Nutrition is drained for the plant to mature and produce, also makes weeds grow
	var/nutrition = 0
	/// Amount of plant health, if it drops to zero the plant won't grow, make produce and will have to be uprooted.
	var/plant_health = MAX_PLANT_HEALTH
	/// The plant that is currently planted, it is a reference to a singleton
	var/datum/plant_def/plant = null
	/// Time of growth so far
	var/growth_time = 0
	/// Time of making produce so far
	var/produce_time = 0
	/// Whether the plant has matured
	var/matured = FALSE
	/// Whether the produce is ready for harvest
	var/produce_ready = FALSE
	/// Whether the plant is dead
	var/plant_dead = FALSE
	/// The time remaining in which the soil has been tilled and will help the plant grow
	var/tilled_time = 0
	/// The time remaining in which the soil was blessed and will help the plant grow, and make weeds decay
	var/blessed_time = 0
	/// The time remaining in which the soil is pollinated.
	var/pollination_time = 0
	/// Time remaining for the soil to decay and destroy itself, only applicable when its out of water and nutriments and has no plant
	var/soil_decay_time = SOIL_DECAY_TIME
	///The time remaining in which the soil was given special fertilizer, effect is similar to being blessed but with less beneficial effects
	var/fertilized_time = 0

/obj/structure/soil/Initialize(mapload)
	. = ..()
	GLOB.soil_list += src

/obj/structure/soil/Destroy()
	GLOB.soil_list -= src
	return ..()

/obj/structure/soil/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM))
		on_stepped(AM)

/obj/structure/soil/proc/user_harvests(mob/living/user)
	if(!produce_ready)
		return
	apply_farming_fatigue(user, 5)
	add_sleep_experience(user, /datum/skill/labor/farming, user.STAINT * 2)

	var/farming_skill = user.get_skill_level(/datum/skill/labor/farming)
	var/is_legendary = FALSE
	if(farming_skill == SKILL_LEVEL_LEGENDARY) //check if the user has legendary farming skill
		is_legendary = TRUE //we do
	var/chance_to_ruin = 50 - (farming_skill * 25)
	if(prob(chance_to_ruin))
		ruin_produce()
		to_chat(user, span_warning("I ruin the produce..."))
		return
	var/feedback = "I harvest the produce."
	var/modifier = 0
	var/chance_to_ruin_single = 75 - (farming_skill * 25)
	if(prob(chance_to_ruin_single))
		feedback = "I harvest the produce, ruining a little."
		modifier -= 1
	var/chance_to_get_extra = -75 + (farming_skill * 25)
	if(prob(chance_to_get_extra))
		feedback = "I harvest the produce well."
		modifier += 1

	if(has_world_trait(/datum/world_trait/dendor_fertility))
		feedback = "Praise Dendor for our harvest is bountiful."
		modifier += 3

	record_featured_stat(FEATURED_STATS_FARMERS, user)
	record_round_statistic(STATS_PLANTS_HARVESTED)
	to_chat(user, span_notice(feedback))
	yield_produce(modifier, is_legendary)
	// Dendor patrons earn 2 Druidic Trickery XP per successful harvest.
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.patron?.type == /datum/patron/divine/dendor && H.mind)
			H.mind.add_sleep_experience(/datum/skill/magic/druidic, 2)
	update_icon()

/obj/structure/soil/proc/try_handle_harvest(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/rogueweapon/sickle))
		if(!plant || !produce_ready)
			to_chat(user, span_warning("There is nothing to harvest!"))
			return TRUE
		user_harvests(user)
		playsound(src,'sound/items/seed.ogg', 100, FALSE)
		return TRUE
	return FALSE

/obj/structure/soil/proc/try_handle_seed_planting(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/seeds))
		var/obj/item/seeds/seeds = attacking_item
		seeds.try_plant_seed(user, src)
		return TRUE
	else if(istype(attacking_item, /obj/item/herbseed))
		var/obj/item/herbseed/herbseed = attacking_item
		herbseed.try_plant_seed(user, src)
		return TRUE
	return FALSE

/obj/structure/soil/proc/has_custom_growth()
	var/turf/T = get_turf(src)
	if(!T)
		return FALSE
	return locate(/obj/structure/soil_seedling) in T || locate(/obj/structure/tree_sapling) in T || locate(/obj/structure/bush_sapling) in T || locate(/obj/structure/mushroom_sprout) in T || locate(/obj/structure/mushroom_circle) in T

/obj/structure/soil/proc/try_handle_uprooting(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/rogueweapon/shovel))
		to_chat(user, span_notice("I begin to uproot the crop..."))
		playsound(src,'sound/items/dig_shovel.ogg', 100, TRUE)
		if(do_after(user, get_farming_do_time(user, 4 SECONDS), target = src))
			to_chat(user, span_notice("I uproot the crop."))
			playsound(src,'sound/items/dig_shovel.ogg', 100, TRUE)
			uproot()
		return TRUE
	return FALSE

/obj/structure/soil/proc/try_handle_tilling(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/rogueweapon/hoe))
		var/is_legendary = FALSE
		if(user.get_skill_level(/datum/skill/labor/farming) == SKILL_LEVEL_LEGENDARY)
			is_legendary = TRUE
		var/work_time = 4 SECONDS
		if(is_legendary)
			work_time = 1.5 SECONDS //this is then by get_farming_do_time to around .5 seconds
		to_chat(user, span_notice("I begin to till the soil..."))
		playsound(src,'sound/items/dig_shovel.ogg', 100, TRUE)
		if(do_after(user, get_farming_do_time(user, work_time), target = src))
			to_chat(user, span_notice("I till the soil."))
			playsound(src,'sound/items/dig_shovel.ogg', 100, TRUE)
			user_till_soil(user)
			update_icon()
		return TRUE
	return FALSE

/obj/structure/soil/proc/try_handle_watering(obj/item/attacking_item, mob/user, params)
	var/water_amount = 0
	if(istype(attacking_item, /obj/item/reagent_containers))
		var/target_water = MAX_PLANT_WATER - water
		if(target_water <= 0)
			to_chat(user, span_warning("The soil is already wet!"))
			return TRUE
		var/obj/item/reagent_containers/container = attacking_item
		var/reagent_units_needed = CEILING(target_water / 6, 1)
		var/clean_water = min(container.reagents.get_reagent_amount(/datum/reagent/water), reagent_units_needed)
		var/holy_water = min(container.reagents.get_reagent_amount(/datum/reagent/water/holywater), max(reagent_units_needed - clean_water, 0))
		var/blessed_water = min(container.reagents.get_reagent_amount(/datum/reagent/water/blessed), max(reagent_units_needed - clean_water - holy_water, 0))
		var/gross_water = min(container.reagents.get_reagent_amount(/datum/reagent/water/gross), max(reagent_units_needed - clean_water - holy_water - blessed_water, 0))
		var/total_units = clean_water + holy_water + blessed_water + gross_water
		if(total_units <= 0)
			to_chat(user, span_warning("There's no water in \the [container]!"))
			return TRUE
		if(clean_water > 0)
			container.reagents.remove_reagent(/datum/reagent/water, clean_water)
		if(holy_water > 0)
			container.reagents.remove_reagent(/datum/reagent/water/holywater, holy_water)
		if(blessed_water > 0)
			container.reagents.remove_reagent(/datum/reagent/water/blessed, blessed_water)
		if(gross_water > 0)
			container.reagents.remove_reagent(/datum/reagent/water/gross, gross_water)
		water_amount = min(target_water, total_units * 6)
	if(water_amount > 0)
		var/list/wash = list('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg')
		playsound(user, pick_n_take(wash), 100, FALSE)
		to_chat(user, span_notice("I water the soil."))
		adjust_water(water_amount)
		update_icon()
		return TRUE
	return FALSE

/obj/structure/soil/proc/try_handle_fertilizing(obj/item/attacking_item, mob/user, params)
	var/fertilize_amount = 0
	if(istype(attacking_item, /obj/item/ash))
		fertilize_amount = 80
	else if (istype(attacking_item, /obj/item/natural/poo))
		fertilize_amount = 150
	else if (istype(attacking_item, /obj/item/compost))
		fertilize_amount = 150
	else if (istype(attacking_item, /obj/item/fertilizer))
		to_chat(user, span_notice("You mix the fertilizer into the soil..."))
		fertilize_soil()
		qdel(attacking_item)
		update_icon()
		return TRUE
	if(fertilize_amount > 0)
		if(nutrition >= MAX_PLANT_NUTRITION * 0.8)
			to_chat(user, span_warning("The soil is already fertilized!"))
		else
			to_chat(user, span_notice("I fertilize the soil."))
			adjust_nutrition(fertilize_amount)
			qdel(attacking_item)
			update_icon()
		return TRUE
	return FALSE

/obj/structure/soil/proc/try_handle_deweed(obj/item/attacking_item, mob/user, params)
	if(weeds < MAX_PLANT_WEEDS * 0.3)
		return FALSE
	if(attacking_item == null)
		to_chat(user, span_notice("I begin ripping out the weeds with my hands..."))
		if(do_after(user, get_farming_do_time(user, 3 SECONDS), target = src))
			apply_farming_fatigue(user, 20)
			to_chat(user, span_notice("I rip out the weeds."))
			deweed()
			update_icon()
		return TRUE
	if(istype(attacking_item, /obj/item/rogueweapon/hoe))
		apply_farming_fatigue(user, 10)
		to_chat(user, span_notice("I rip out the weeds with the [attacking_item]"))
		deweed()
		update_icon()
		return TRUE
	return FALSE

/obj/structure/soil/proc/try_handle_flatten(obj/item/attacking_item, mob/user, params)
	if(plant)
		return FALSE
	if(istype(attacking_item, /obj/item/rogueweapon/shovel))
		to_chat(user, span_notice("I begin flattening the soil with \the [attacking_item]..."))
		playsound(src,'sound/items/dig_shovel.ogg', 100, TRUE)
		if(do_after(user, get_farming_do_time(user, 3 SECONDS), target = src))
			if(plant)
				return FALSE
			apply_farming_fatigue(user, 10)
			playsound(src,'sound/items/dig_shovel.ogg', 100, TRUE)
			to_chat(user, span_notice("I flatten the soil."))
			decay_soil()
		return TRUE
	return FALSE

/obj/structure/soil/attack_hand(mob/user)
	if(plant && produce_ready)
		to_chat(user, span_notice("I begin collecting the produce..."))
		if(do_after(user, get_farming_do_time(user, 4 SECONDS), target = src))
			playsound(src,'sound/items/seed.ogg', 100, FALSE)
			user_harvests(user)
		return
	if(plant && plant_dead)
		to_chat(user, span_notice("I begin to remove the dead crop..."))
		if(do_after(user, get_farming_do_time(user, 6 SECONDS), target = src))
			if(!plant || !plant_dead)
				return
			apply_farming_fatigue(user, 10)
			to_chat(user, span_notice("I remove the crop."))
			playsound(src,'sound/items/seed.ogg', 100, FALSE)
			uproot()
		return
	. = ..()

/obj/structure/soil/attack_right(mob/user)
	user.changeNext_move(CLICK_CD_FAST)
	var/obj/item = user.get_active_held_item()
	if(try_handle_deweed(item, user, null))
		return
	if(try_handle_flatten(item, user, null))
		return
	return ..()

/obj/structure/soil/attackby(obj/item/attacking_item, mob/user, params)
	user.changeNext_move(CLICK_CD_FAST)
	if(try_handle_seed_planting(attacking_item, user, params))
		return
	if(try_handle_uprooting(attacking_item, user, params))
		return
	if(try_handle_tilling(attacking_item, user, params))
		return
	if(try_handle_watering(attacking_item, user, params))
		return
	if(try_handle_fertilizing(attacking_item, user, params))
		return
	if(try_handle_harvest(attacking_item, user, params))
		return
	return ..()

/obj/structure/soil/proc/on_stepped(mob/living/stepper)
	if(!plant)
		return
	if(stepper.m_intent == MOVE_INTENT_SNEAK)
		return
	if(stepper.m_intent == MOVE_INTENT_WALK)
		adjust_plant_health(-5)
	else if(stepper.m_intent == MOVE_INTENT_RUN)
		adjust_plant_health(-10)
	playsound(src,"plantcross", 100, FALSE)

/obj/structure/soil/proc/deweed()
	if(weeds >= MAX_PLANT_WEEDS * 0.3)
		playsound(src,"plantcross", 100, FALSE)
	adjust_weeds(-100)

/obj/structure/soil/proc/user_till_soil(mob/user)
	apply_farming_fatigue(user, 10)
	till_soil(15 MINUTES * get_farming_effort_multiplier(user))

/obj/structure/soil/proc/till_soil(time = 15 MINUTES)
	tilled_time = time
	adjust_plant_health(-20)
	adjust_weeds(-30)
	if(plant)
		playsound(src,"plantcross", 100, FALSE)
	update_icon()

/obj/structure/soil/proc/bless_soil()
	blessed_time = 12 MINUTES
	// It's a miracle! Plant comes back to life when blessed by Dendor
	if(plant && plant_dead)
		plant_dead = FALSE
		plant_health = 10.0
	// If low on nutrition, Dendor provides
	if(nutrition < 30)
		adjust_nutrition(max(30 - nutrition, 0))
	// If low on water, Dendor provides
	if(water < 30)
		adjust_water(max(30 - water, 0))
	// And it grows a little!
	if(plant)
		add_growth(2 MINUTES)

/obj/structure/soil/proc/fertilize_soil()
	fertilized_time = 60 MINUTES //Keeps the plant fertilized for a good while

/obj/structure/soil/proc/adjust_water(adjust_amount)
	water = clamp(water + adjust_amount, 0, MAX_PLANT_WATER)

/obj/structure/soil/proc/adjust_nutrition(adjust_amount)
	nutrition = clamp(nutrition + adjust_amount, 0, MAX_PLANT_NUTRITION)

/obj/structure/soil/proc/adjust_weeds(adjust_amount)
	weeds = clamp(weeds + adjust_amount, 0, MAX_PLANT_WEEDS)

/obj/structure/soil/proc/adjust_plant_health(adjust_amount)
	if(!plant || plant_dead)
		return
	plant_health = clamp(plant_health + adjust_amount, 0, MAX_PLANT_HEALTH)
	if(plant_health <= 0)
		plant_dead = TRUE
		produce_ready = FALSE
		update_icon()

/obj/structure/soil/Initialize(mapload)
	START_PROCESSING(SSprocessing, src)
//	GLOB.weather_act_upon_list += src
	. = ..()

/obj/structure/soil/Destroy()
	STOP_PROCESSING(SSprocessing, src)
//	GLOB.weather_act_upon_list -= src
	. = ..()

/obj/structure/soil/process()
	var/dt = 10
	process_weeds(dt)
	process_plant(dt)
	process_soil(dt)
	if(soil_decay_time <= 0)
		decay_soil()
	var/turf/obj_turf = get_turf(src)
	if(!obj_turf)
		return
	if(obj_turf.outdoor_effect?.weatherproof)
		return
	if(SSParticleWeather?.runningWeather?.target_trait == PARTICLEWEATHER_RAIN)
		water = min(MAX_PLANT_WATER, water + min(5, 30 / 4))

/obj/structure/soil/weather_act_on(weather_trait, severity)
	if(weather_trait != PARTICLEWEATHER_RAIN)
		return
	water = min(MAX_PLANT_WATER, water + min(5, severity / 4))

/obj/structure/soil/update_icon()
	. = ..()
	update_overlays()

/obj/structure/soil/update_overlays()
	. = ..()
	// Tilled overlay
	if(tilled_time > 0)
		. += "soil-tilled"
	// Water overlay
	var/mutable_appearance/water_ma = mutable_appearance(icon, "soil-overlay")
	water_ma.color = "#000033"
	if(water >= MAX_PLANT_WATER * 0.6)
		water_ma.alpha = 100
	else if (water >= MAX_PLANT_WATER * 0.15)
		water_ma.alpha = 50
	else
		water_ma.alpha = 0
	. += water_ma
	// Nutriment overlay
	var/mutable_appearance/nutri_ma = mutable_appearance(icon, "soil-overlay")
	nutri_ma.color = "#6d3a00"
	if(nutrition >= MAX_PLANT_NUTRITION * 0.6)
		nutri_ma.alpha = 50
	else if (nutrition >= MAX_PLANT_NUTRITION * 0.15)
		nutri_ma.alpha = 25
	else
		nutri_ma.alpha = 0
	. += nutri_ma
	// Plant overlay
	if(plant)
		var/plant_state
		var/plant_color
		if(plant_dead == TRUE)
			plant_color = null
		else if(plant_health <=  MAX_PLANT_HEALTH * 0.3)
			plant_color = "#9c7b43"
		else if (plant_health <=  MAX_PLANT_HEALTH * 0.6)
			plant_color = "#d8b573"
		if(plant_dead == TRUE)
			plant_state = "[plant.icon_state]3"
		else
			if(produce_ready)
				plant_state = "[plant.icon_state]2"
			else if (matured)
				plant_state = "[plant.icon_state]1"
			else
				plant_state = "[plant.icon_state]0"
		var/mutable_appearance/plant_ma = mutable_appearance(plant.icon, plant_state)
		plant_ma.color = plant_color
		. += plant_ma
	// Weeds overlay
	if(weeds >= MAX_PLANT_WEEDS * 0.6)
		. += "weeds-2"
	else if (weeds >= MAX_PLANT_WEEDS * 0.3)
		. += "weeds-1"

/obj/structure/soil/examine(mob/user)
	. = ..()
	var/farming_skill = 0
	var/can_read_growth_timers = FALSE
	var/can_read_soil_stats = FALSE
	if(isliving(user))
		var/mob/living/living_user = user
		farming_skill = living_user.get_skill_level(/datum/skill/labor/farming)
		can_read_growth_timers = farming_skill >= SKILL_LEVEL_EXPERT || HAS_TRAIT(living_user, TRAIT_SEEDKNOW)
		can_read_soil_stats = farming_skill >= SKILL_LEVEL_APPRENTICE || HAS_TRAIT(living_user, TRAIT_SEEDKNOW)
	// Plant description
	if(plant)
		. += span_info("\The [plant.name] is growing here...")
		// Plant health feedback
		if(farming_skill >= SKILL_LEVEL_JOURNEYMAN)
			. += span_info("Crop health: [round((plant_health / MAX_PLANT_HEALTH) * 100)]%")
			if(plant_dead == TRUE)
				. += span_warning("It's dead!")
			else if(plant_health <=  MAX_PLANT_HEALTH * 0.3)
				. += span_warning("It's dying!")
			else if (plant_health <=  MAX_PLANT_HEALTH * 0.6)
				. += span_warning("It's brown and unhealthy...")
		// Plant maturation and produce feedback
		if(matured)
			. += span_info("It's fully matured.")
			if(can_read_growth_timers && !produce_ready)
				var/time_until_produce = max(plant.produce_time - produce_time, 0)
				var/gm = calculate_growth_multiplier()
				var/adjusted_produce = (gm > 0) ? round(time_until_produce / gm) : time_until_produce
				. += span_info("Next harvest in approximately [DisplayTimeText(adjusted_produce)] (at current growth rate).")
		else
			. += span_info("It has yet to mature.")
			if(can_read_growth_timers)
				var/time_until_mature = max(plant.maturation_time - growth_time, 0)
				var/gm = calculate_growth_multiplier()
				var/adjusted_mature = (gm > 0) ? round(time_until_mature / gm) : time_until_mature
				. += span_info("Estimated time to maturity: [DisplayTimeText(adjusted_mature)] (at current growth rate).")
		if(produce_ready)
			. += span_info("It's ready for harvest.")
	// Custom-growth structures sharing this soil: tree saplings, bush saplings, flower/herb seedlings.
	// These don't use the standard soil.plant system, so their status is shown here instead.
	if(!plant)
		var/turf/custom_turf = get_turf(src)
		if(custom_turf)
			var/obj/structure/tree_sapling/tree = locate() in custom_turf
			var/obj/structure/bush_sapling/bush = locate() in custom_turf
			var/obj/structure/soil_seedling/seedling = locate() in custom_turf
			if(tree)
				if(tree.dead)
					. += span_warning("A withered sapling is here. Shovel it out to clear the spot.")
				else
					switch(tree.stage)
						if(TREESAP_STAGE_SAPLING)
							. += span_info("A young tree sapling is taking root here.")
						if(TREESAP_STAGE_SHRUB)
							. += span_info("A small shrub is growing steadily here.")
					if(can_read_growth_timers && tree.stage <= TREESAP_STAGE_SHRUB)
						var/gm = get_environmental_growth_multiplier()
						var/time_rem = max(TREESAP_STAGE_TIME - tree.growth_progress, 0)
						var/adj = (gm > 0) ? round(time_rem / gm) : time_rem
						. += span_info("Estimated time to next stage: [DisplayTimeText(adj)] (at current growth rate).")
			else if(bush)
				if(bush.dead)
					. += span_warning("A withered bush sprout is here. Shovel it out to clear the spot.")
				else
					switch(bush.stage)
						if(BUSHSAP_STAGE_SAPLING)
							. += span_info("A young bush sprout is taking root here.")
						if(BUSHSAP_STAGE_BUDDING)
							. += span_info("A bush sprout is growing, still rooted in the soil.")
					if(can_read_growth_timers && bush.stage < BUSHSAP_STAGE_MATURE)
						var/gm = get_environmental_growth_multiplier()
						var/time_rem = max(BUSHSAP_STAGE_TIME - bush.growth_progress, 0)
						var/adj = (gm > 0) ? round(time_rem / gm) : time_rem
						. += span_info("Estimated time to next stage: [DisplayTimeText(adj)] (at current growth rate).")
			else if(seedling)
				. += span_info("A seedling is germinating here.")
				if(can_read_growth_timers)
					var/gm = get_environmental_growth_multiplier()
					var/time_rem = max(seedling.grow_duration - seedling.growth_progress, 0)
					var/adj = (gm > 0) ? round(time_rem / gm) : time_rem
					. += span_info("Estimated time to bloom: [DisplayTimeText(adj)] (at current growth rate).")
	if(can_read_soil_stats)
		. += span_info("Water: [round((water / MAX_PLANT_WATER) * 100)]%")
		. += span_info("Nutrition: [round((nutrition / MAX_PLANT_NUTRITION) * 100)]%")
	else
		// Water feedback
		if(water <= MAX_PLANT_WATER * 0.15)
			. += span_warning("The soil is thirsty.")
		else if (water <= MAX_PLANT_WATER * 0.5)
			. += span_info("The soil is moist.")
		else
			. += span_info("The soil is wet.")
		// Nutrition feedback
		if(nutrition <= MAX_PLANT_NUTRITION * 0.15)
			. += span_warning("The soil is hungry.")
		else if (nutrition <= MAX_PLANT_NUTRITION * 0.5)
			. += span_info("The soil is sated.")
		else
			. += span_info("The soil looks fertile.")
	// Weeds feedback
	if(weeds >= MAX_PLANT_WEEDS * 0.6)
		. += span_warning("It's overtaken by the weeds!")
	else if (weeds >= MAX_PLANT_WEEDS * 0.3)
		. += span_warning("Weeds are growing out...")
	// Tilled feedback
	if(tilled_time > 0)
		. += span_info("The soil is tilled.")
	// Blessed feedback
	if(blessed_time > 0)
		. += span_good("The soil seems blessed.")
	if(fertilized_time > 0)
		. += span_good("The soil has special fertilizer mixed in.")
	if(pollination_time > 0)
		. += span_good("The soil has been pollinated.")
	// Growth bonus breakdown: visible to expert farmers and those with the seedknow trait.
	// Also shows the effective growth rate so bonus contributions are clearly visible.
	if(can_read_growth_timers)
		var/list/natural_bonuses = get_natural_growth_bonuses()
		if(natural_bonuses["total"] > 0)
			var/list/bonus_parts = list()
			if(natural_bonuses["blessed"] > 0)
				bonus_parts += "blessed soil ([round(natural_bonuses["blessed"] * 100)]%)"
			if(natural_bonuses["living_light"] > 0)
				bonus_parts += "living light ([round(natural_bonuses["living_light"] * 100)]%)"
			if(natural_bonuses["dendor_rune"] > 0)
				bonus_parts += "Rune of Dendor ([round(natural_bonuses["dendor_rune"] * 100)]%)"
			. += span_good("Growth bonus: [round(natural_bonuses["total"] * 100)]% ([english_list(bonus_parts)].)") 

#define BLESSING_WEED_DECAY_RATE 10 / (1 MINUTES)
#define WEED_GROWTH_RATE 3 / (1 MINUTES)
#define WEED_DECAY_RATE 5 / (1 MINUTES)
#define WEED_RESISTANCE_DECAY_RATE 20 / (1 MINUTES)

// These get multiplied by 0.0 to 1.0 depending on amount of weeds
#define WEED_WATER_CONSUMPTION_RATE 5 / (1 MINUTES)
#define WEED_NUTRITION_CONSUMPTION_RATE 5 / (1 MINUTES)

/obj/structure/soil/proc/process_weeds(dt)
	// Blessed soil will have the weeds die
	if(blessed_time > 0 || fertilized_time > 0)
		adjust_weeds(-dt * BLESSING_WEED_DECAY_RATE)
	if(plant && plant.weed_immune)
		// Weeds die if the plant is immune to them
		adjust_weeds(-dt * WEED_RESISTANCE_DECAY_RATE)
		return
	if(water <= 0)
		// Weeds die without water in soil
		adjust_weeds(-dt * WEED_DECAY_RATE)
		return
	// Weeds eat water and nutrition to grow
	var/weed_factor = weeds / MAX_PLANT_WEEDS
	adjust_water(-dt * weed_factor * WEED_WATER_CONSUMPTION_RATE)
	adjust_nutrition(-dt * weed_factor * WEED_NUTRITION_CONSUMPTION_RATE)
	if(nutrition > 0)
		adjust_weeds(dt * WEED_GROWTH_RATE)


#define PLANT_REGENERATION_RATE 10 / (1 MINUTES)
#define PLANT_DECAY_RATE 10 / (1 MINUTES)
#define PLANT_BLESS_HEAL_RATE 20 / (1 MINUTES)
#define PLANT_WEEDS_HARM_RATE 10 / (1 MINUTES)

/obj/structure/soil/proc/process_plant(dt)
	if(!plant)
		return
	if(plant_dead)
		return
	process_plant_nutrition(dt)
	process_plant_health(dt)


/obj/structure/soil/proc/process_plant_health(dt)
	var/drain_rate = plant.water_drain_rate
	// Lots of weeds harm the plant
	if(weeds >= MAX_PLANT_WEEDS * 0.6)
		adjust_plant_health(-dt * PLANT_WEEDS_HARM_RATE)
	// Regenerate plant health if we dont drain water, or we have the water
	if(drain_rate <= 0 || water > 0)
		adjust_plant_health(dt * PLANT_REGENERATION_RATE)
	if(drain_rate > 0)
		// If we're dry and we want to drain water, we loose health
		if(water <= 0)
			adjust_plant_health(-dt * PLANT_DECAY_RATE)
		else
			// Drain water
			adjust_water(-dt * drain_rate)
	// Blessed plants heal!!
	if(blessed_time > 0)
		adjust_plant_health(dt * PLANT_BLESS_HEAL_RATE)

/// Returns an associative list of additive growth bonuses from blessed soil (+20%), Living Light (+10%),
/// and a nearby Rune of Dendor (+5%). Keys: "blessed", "living_light", "dendor_rune", "total" (capped at 35%).
/// Multiple runes do not stack — only one rune's bonus is counted regardless of how many are in range.
/obj/structure/soil/proc/get_natural_growth_bonuses()
	var/blessed_bonus = (blessed_time > 0) ? 0.20 : 0.0
	var/living_light_bonus = 0.0
	for(var/obj/structure/flora/roguetree/wise/sanctified/tree in range(10, src))
		if(tree.tree_data?.has_heal_aura)
			living_light_bonus = 0.10
			break
	var/dendor_rune_bonus = 0.0
	for(var/obj/structure/ritualcircle/dendor in range(5, src))
		dendor_rune_bonus = 0.05
		break
	var/total = min(blessed_bonus + living_light_bonus + dendor_rune_bonus, 0.35)
	return list("blessed" = blessed_bonus, "living_light" = living_light_bonus, "dendor_rune" = dendor_rune_bonus, "total" = total)

/// Returns the growth-speed multiplier from environmental factors only.
/// Includes: tilling, fertilization, pollination, world traits, natural aura bonuses, and weed penalties.
/// Does NOT require a plant — safe to call for tree/bush saplings and seedlings.
/obj/structure/soil/proc/get_environmental_growth_multiplier()
	var/gm = 1.0
	if(tilled_time > 0)
		gm *= 1.6
	if(fertilized_time > 0)
		gm *= 2.0
	if(pollination_time > 0)
		gm *= 1.75
	if(has_world_trait(/datum/world_trait/dendor_fertility))
		gm *= 2.0
	if(has_world_trait(/datum/world_trait/fertility))
		gm *= 1.5
	if(has_world_trait(/datum/world_trait/dendor_drought))
		gm *= 0.4
	var/list/nb = get_natural_growth_bonuses()
	if(nb["total"] > 0)
		gm *= (1.0 + nb["total"])
	if(weeds >= MAX_PLANT_WEEDS * 0.6)
		gm *= 0.75
	if(weeds >= MAX_PLANT_WEEDS * 0.3)
		gm *= 0.75
	return gm

/// Returns the current effective growth-time multiplier based on active soil/plant conditions.
/// Returns 0 if growth is currently blocked (no water, underground, produce ready, etc.).
/obj/structure/soil/proc/calculate_growth_multiplier()
	if(!plant || plant_dead)
		return 0
	var/turf/location = loc
	if(location && !plant.can_grow_underground && location.can_see_sky == SEE_SKY_NO)
		return 0
	if(matured && produce_ready)
		return 0
	var/drain_rate = plant.water_drain_rate
	if(drain_rate > 0 && water <= 0)
		return 0
	var/gm = get_environmental_growth_multiplier()
	if(plant_health <= MAX_PLANT_HEALTH * 0.3)
		gm *= 0.75
	if(plant_health <= MAX_PLANT_HEALTH * 0.6)
		gm *= 0.75
	return gm

/obj/structure/soil/proc/process_plant_nutrition(dt)
	var/turf/location = loc
	if(!plant.can_grow_underground && location.can_see_sky == SEE_SKY_NO)
		return
	// If matured and produce is ready, don't process plant nutrition
	if(matured && produce_ready)
		return
	var/drain_rate = plant.water_drain_rate
	// If we drain water, and have no water, we can't grow
	if(drain_rate > 0 && water <= 0)
		return
	var/growth_multiplier = 1.0
	var/nutriment_eat_mutliplier = 1.0
	// If soil is tilled, grow faster
	if(tilled_time > 0)
		growth_multiplier *= 1.6
	// Blessed soil nutriment reduction (growth boost handled in the additive natural bonus block below).
	if(blessed_time > 0)
		nutriment_eat_mutliplier *= 0.8
	if(fertilized_time > 0)
		growth_multiplier *= 2.0
		nutriment_eat_mutliplier *= 0.4

	if(pollination_time > 0)
		growth_multiplier *= 1.75
		nutriment_eat_mutliplier *= 0.6

	if(has_world_trait(/datum/world_trait/dendor_fertility))
		growth_multiplier *= 2.0
		nutriment_eat_mutliplier *= 0.4

	if(has_world_trait(/datum/world_trait/fertility))
		growth_multiplier *= 1.5

	if(has_world_trait(/datum/world_trait/dendor_drought))
		growth_multiplier *= 0.4
		nutriment_eat_mutliplier *= 2
	// Natural growth bonuses: blessed soil (+20%), Living Light (+10%), Rune of Dendor (+5%) — additive, capped at 35%.
	var/list/natural_bonuses = get_natural_growth_bonuses()
	if(natural_bonuses["total"] > 0)
		growth_multiplier *= (1.0 + natural_bonuses["total"])
	// If there's too many weeds, they hamper the growth of the plant
	if(weeds >= MAX_PLANT_WEEDS * 0.3)
		growth_multiplier *= 0.75
	if(weeds >= MAX_PLANT_WEEDS * 0.6)
		growth_multiplier *= 0.75
	// If we're low on health, also grow slower
	if(plant_health <= MAX_PLANT_HEALTH * 0.6)
		growth_multiplier *= 0.75
	if(plant_health <= MAX_PLANT_HEALTH * 0.3)
		growth_multiplier *= 0.75
	var/target_growth_time = growth_multiplier * dt
	process_growth(target_growth_time)

/obj/structure/soil/proc/process_growth(target_growth_time)
	var/target_nutrition
	if(!matured)
		target_nutrition = (plant.maturation_nutrition / plant.maturation_time) * target_growth_time
	else
		target_nutrition = (plant.produce_nutrition / plant.produce_time) * target_growth_time
	var/possible_nutrition = min(target_nutrition, nutrition)
	var/factor = possible_nutrition / target_nutrition
	var/possible_growth_time = target_growth_time * factor
	adjust_nutrition(-possible_nutrition)
	add_growth(possible_growth_time)


/obj/structure/soil/proc/add_growth(added_growth)
	growth_time += added_growth
	if(!matured)
		if(growth_time >= plant.maturation_time)
			matured = TRUE
			update_icon()
	else
		produce_time += added_growth
		if(produce_time >= plant.produce_time)
			produce_time -= plant.produce_time
			produce_ready = TRUE
			update_icon()


#define SOIL_WATER_DECAY_RATE 0.5 / (1 MINUTES)
#define SOIL_NUTRIMENT_DECAY_RATE 0.5 / (1 MINUTES)

/obj/structure/soil/proc/process_soil(dt)
	// If plant exists and is not dead, nutriment or water is not zero, reset the decay timer
	if(nutrition > 0 || water > 0 || (plant != null && plant_health > 0))
		soil_decay_time = SOIL_DECAY_TIME
	else
		// Otherwise, "decay" the soil
		soil_decay_time = max(soil_decay_time - dt, 0)

	adjust_water(-dt * SOIL_WATER_DECAY_RATE)
	adjust_nutrition(-dt * SOIL_NUTRIMENT_DECAY_RATE * (blessed_time > 0 ? 0.5 : 1))
	if(fertilized_time > 0)
		nutrition = 100
	tilled_time = max(tilled_time - dt, 0)
	blessed_time = max(blessed_time - dt, 0)
	pollination_time = max(pollination_time - dt, 0)

/obj/structure/soil/proc/decay_soil()
	uproot()
	qdel(src)

/obj/structure/soil/proc/uproot()
	if(!plant)
		return
	adjust_weeds(-100)
	yield_uproot_loot()
	ruin_produce()
	plant = null
	update_icon()

/// Spawns uproot loot, such as a long from an apple tree when removing the tree
/obj/structure/soil/proc/yield_uproot_loot()
	if(!matured || !plant.uproot_loot)
		return
	for(var/loot_type in plant.uproot_loot)
		new loot_type(loc)

/// Yields produce on its tile if it's ready for harvest
/obj/structure/soil/proc/ruin_produce()
	produce_ready = FALSE
	update_icon()

/// Yields produce on its tile if it's ready for harvest
/obj/structure/soil/proc/yield_produce(modifier = 0, is_legendary = FALSE)
	if(!produce_ready)
		return
	var/base_amount = rand(plant.produce_amount_min, plant.produce_amount_max)
	var/spawn_amount = max(base_amount + modifier, 1)
	for(var/i in 1 to spawn_amount)
		new plant.produce_type(loc)
	produce_ready = FALSE
	if(!plant.perennial)
		if(is_legendary) //the user has legendary skill
			growth_time = 0 //reset growth time
			matured = FALSE //not mature anymore
		else
			uproot()
	update_icon()

/obj/structure/soil/proc/insert_plant(datum/plant_def/new_plant)
	if(plant)
		return
	plant = new_plant
	plant_health = MAX_PLANT_HEALTH
	growth_time = 0
	produce_time = 0
	matured = FALSE
	produce_ready = FALSE
	plant_dead = FALSE
	update_icon()
