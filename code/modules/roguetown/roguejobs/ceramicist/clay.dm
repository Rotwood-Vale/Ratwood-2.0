/obj/item/natural/clay
	name = "clay"
	icon_state = "clay"
	desc = "A handful of damp, malleable clay"
	gripped_intents = null
	dropshrink = 0.75
	possible_item_intents = list(INTENT_GENERIC)
	force = 0
	throwforce = 0
	slot_flags = null
	obj_flags = null
	w_class = WEIGHT_CLASS_TINY
	var/cooked_type = /obj/item/natural/stone // What does this item turn into when glazed in a kiln?
					// A regular clay lump just becomes an ordinary stone.
					// ...Possibly used to make bricks in a separate PR? Interesting way to integrate
					// the mason's construction work with the new Potter profession. - SunriseOYH

	var/cooking = 0 			// This variable measures the progress of the glazing act.
	var/cooktime = 1 MINUTES    // This dictates the time needed to glaze.
	var/burning = 0				// This variable measures the progress of the burning act
	var/burntime = 5 MINUTES	// How long must it be left unattended to burn and be ruined?
	var/burned_color = "#302d2d"
	var/shatter_chance = 20
	var/ash_kneads = 0
	var/sand_added = FALSE
	var/stonedust_added = FALSE
	var/final_temper_is_glass = FALSE
	var/is_wet = FALSE
	var/needs_knead_after_wet = FALSE
	var/list/special_glaze_result_types = null
	var/list/special_glaze_icon_states = null
	var/special_glaze_selected_type = null
	var/special_glaze_default_type = null
	var/needs_glaze_gold_dust = FALSE
	var/has_glaze_gold_dust = FALSE

/obj/item/natural/clay/proc/select_special_glaze(obj/item/dye_brush/brush, mob/living/user)
	if(!special_glaze_result_types?.len || !special_glaze_icon_states?.len)
		return FALSE
	if(!brush)
		return TRUE
	var/list/radial_choices = list()
	for(var/choice_name in special_glaze_result_types)
		var/choice_icon_state = special_glaze_icon_states[choice_name]
		radial_choices[choice_name] = image(icon = icon, icon_state = choice_icon_state)
	var/choice = show_radial_menu(user, src, radial_choices, require_near = TRUE, tooltips = TRUE)
	if(!choice)
		return TRUE
	special_glaze_selected_type = special_glaze_result_types[choice]
	to_chat(user, span_notice("I prepare [src] for a [LOWER_TEXT(choice)] finish."))
	if(needs_glaze_gold_dust && !has_glaze_gold_dust)
		to_chat(user, span_warning("I need to add gold dust before baking, or it will bake into a regular porcelain finish."))
	else if(needs_glaze_gold_dust && has_glaze_gold_dust)
		to_chat(user, span_notice("Gold dust is already added. This piece is ready to fire."))
	return TRUE

/obj/item/natural/clay/examine(mob/user)
	. = ..()
	if(special_glaze_result_types?.len)
		if(needs_glaze_gold_dust)
			. += span_info("Tip: While this piece is raw, add gold dust and use a dye brush with middle-click to choose its glaze style before firing.")
		else
			. += span_info("Tip: While this piece is raw, use a dye brush with middle-click to choose its glaze style before firing.")

/obj/item/natural/clay/proc/consume_wetting_water(obj/item/reagent_containers/container)
	if(!container?.reagents)
		return FALSE
	if(container.reagents.has_reagent(/datum/reagent/water, 2))
		container.reagents.remove_reagent(/datum/reagent/water, 2)
		return TRUE
	if(container.reagents.has_reagent(/datum/reagent/water/gross, 2))
		container.reagents.remove_reagent(/datum/reagent/water/gross, 2)
		return TRUE
	return FALSE

/obj/item/natural/clay/proc/set_wet_state(new_state)
	is_wet = !!new_state
	if(src.type == /obj/item/natural/clay)
		icon_state = is_wet ? "kneaded_clay" : initial(icon_state)

/obj/item/natural/clay/proc/get_knead_time(mob/living/user, base_time)
	var/skill_level = SKILL_LEVEL_NONE
	if(user)
		skill_level = user.get_skill_level(/datum/skill/craft/ceramics)
	// Journeyman is baseline; lower skills take longer, higher skills speed up kneading
	return max(6, round(base_time) + (SKILL_LEVEL_JOURNEYMAN - skill_level) * 4)

/obj/item/natural/clay/proc/is_refinement_ready()
	if(final_temper_is_glass)
		return ash_kneads >= 1 && sand_added && stonedust_added
	return ash_kneads >= 2 && sand_added

/obj/item/natural/clay/proc/knead_wetted_clay(mob/living/user)
	if(!user)
		return FALSE
	if(!is_wet || !needs_knead_after_wet)
		return FALSE
	to_chat(user, span_notice("I knead the wet clay to make it workable..."))
	playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
	if(!do_after(user, get_knead_time(user, 1.5 SECONDS), target = src))
		return FALSE
	needs_knead_after_wet = FALSE
	if(is_refinement_ready())
		var/turf/drop_turf = get_turf(src)
		if(final_temper_is_glass)
			new /obj/item/natural/clay/glassbatch(drop_turf)
			to_chat(user, span_notice("The mixture is now ready to be fired into glass."))
		else
			var/obj/item/natural/clay/refined/refined_clay = new(drop_turf)
			refined_clay.is_wet = FALSE
			to_chat(user, span_notice("The clay is now fully refined and ready for porcelain work."))
		if(user.mind)
			user.mind.add_sleep_experience(/datum/skill/craft/ceramics, 4, FALSE)
		qdel(src)
		return TRUE
	if(user.mind)
		user.mind.add_sleep_experience(/datum/skill/craft/ceramics, 4, FALSE)
	return TRUE

/obj/item/natural/clay/attack_right(mob/user)
	var/obj/item/dye_brush/brush = user?.get_active_held_item()
	if(istype(brush))
		if(select_special_glaze(brush, user))
			return TRUE
	return ..()

/obj/item/natural/clay/MiddleClick(mob/user, params)
	if(!Adjacent(user))
		return ..()
	var/obj/item/dye_brush/brush = user?.get_active_held_item()
	if(istype(brush))
		if(select_special_glaze(brush, user))
			return TRUE
	return ..()

/obj/item/natural/clay/kneaded
	name = "kneaded clay"
	desc = "Well-worked clay made pliable for pottery. Prepared by wetting two lumps of raw clay with a water source and thoroughly kneading them together until smooth. Requires: 2x raw clay, water. Worked at a potter's wheel into basic clayware."
	icon_state = "kneaded_clay"

/obj/item/natural/clay/refined_partial
	name = "partially refined clay"
	desc = "Clay mixed with refining materials, but not fully worked yet."
	icon_state = "partialrefined_clay"

// '''Clay''' for making glass.
/obj/item/natural/clay/glassbatch
	name = "glass batch"
	icon_state = "glassBatch"
	desc = "A precisely weighed mixture of ground silica (clay), flux (ash), sand, and stabilizer (stone powder). Requires: 2x clay, 1x ash, 1x sand, 1x stone powder. Heat in a smelter to yield heated glass, then shape with a blowing rod."
	smeltresult = /obj/item/natural/glass/heated 	// Pulled from the furnace with tongs for blowing.
	grind_results = list(/datum/reagent/iron = 15)
	sellprice = 5
	cooktime = 0
	burntime = 0

/obj/item/natural/clay/Initialize(mapload)
	if(cooked_type)
		cooktime = 30 SECONDS
	..() // The ..() refers to calling the parent class's (obj/item/natural) Initialize() proc.

/obj/item/natural/clay/refined
	name = "refined clay"
	desc = "Fine clay tempered with ash and sand to produce a smooth, dense body fit for porcelain. Requires: 1x kneaded clay, 2x ash, 1x sand. Add the ingredients, then wet and knead once to finish it. Worked at a potter's wheel into fine porcelain."
	icon_state = "refined_clay"

/obj/item/natural/clay/refined/Initialize(mapload)
	. = ..()
	if(cooked_type)
		cooktime = 1 MINUTES

/obj/item/natural/clay/attack_hand(mob/living/user)
	if(is_wet && needs_knead_after_wet)
		if(knead_wetted_clay(user))
			return
	return ..()

/obj/item/natural/clay/attackby(obj/item/W, mob/living/user, params)
	if(istype(src, /obj/item/natural/clay/refined))
		return ..()

	if(!user)
		return ..()

	if(istype(W, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = W
		if(select_special_glaze(brush, user))
			return TRUE

	if(istype(W, /obj/item/alch/golddust) && needs_glaze_gold_dust)
		if(has_glaze_gold_dust)
			to_chat(user, span_warning("This piece already has gold dust added."))
			return TRUE
		if(!do_after(user, 2 SECONDS, target = src))
			return TRUE
		has_glaze_gold_dust = TRUE
		qdel(W)
		to_chat(user, span_notice("I dust [src] with gold, ready for firing. I should brush glaze onto it to make it fancier."))
		if(!special_glaze_selected_type)
			to_chat(user, span_info("I can still choose a glaze style with a dye brush before firing."))
		return TRUE

	var/found_table = locate(/obj/structure/table) in (loc)
	var/obj/item/reagent_containers/water_container = W
	if(istype(water_container) && !is_wet)
		if((istype(src, /obj/item/natural/clay/kneaded) || istype(src, /obj/item/natural/clay/refined_partial)) && !is_refinement_ready())
			to_chat(user, span_notice("I don't need to wet this again until all the tempering ingredients are added."))
			return TRUE
		if(isturf(loc) && !found_table)
			to_chat(user, span_notice("I need a table to work this clay."))
			return TRUE
		if(!consume_wetting_water(water_container))
			to_chat(user, span_notice("Needs more water to work it."))
			return TRUE
		to_chat(user, span_notice("I wet the clay so it can be worked again."))
		playsound(get_turf(user), 'modular/Neu_Food/sound/splishy.ogg', 80, TRUE, -1)
		set_wet_state(TRUE)
		needs_knead_after_wet = TRUE
		return TRUE

	if(src.type == /obj/item/natural/clay && W.type == /obj/item/natural/clay)
		if(!is_wet)
			to_chat(user, span_warning("This clay is too dry. I need to wet it first."))
			return
		if(needs_knead_after_wet)
			to_chat(user, span_warning("I should knead the wetted clay first before adding more clay."))
			return
		if(isturf(loc) && !found_table)
			to_chat(user, span_notice("I need a table to knead this properly."))
			return
		to_chat(user, span_notice("I knead the clay together..."))
		playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
		if(!do_after(user, get_knead_time(user, 2 SECONDS), target = src))
			return
		qdel(W)
		var/obj/item/natural/clay/kneaded/kneaded_clay = new(loc)
		kneaded_clay.is_wet = FALSE
		if(user.mind)
			user.mind.add_sleep_experience(/datum/skill/craft/ceramics, 6, FALSE)
		qdel(src)
		return

	if(user.get_skill_level(/datum/skill/craft/ceramics) < SKILL_LEVEL_JOURNEYMAN)
		to_chat(user, span_warning("I need journeyman pottery knowledge to refine clay."))
		return ..()

	if(!(istype(src, /obj/item/natural/clay/kneaded) || istype(src, /obj/item/natural/clay/refined_partial)))
		return ..()

	if(isturf(loc) && !found_table)
		to_chat(user, span_notice("I need a table to keep kneading this."))
		return

	if(istype(W, /obj/item/ash))
		if(ash_kneads >= 2)
			to_chat(user, span_warning("This clay already has enough ash mixed in."))
			return
		to_chat(user, span_notice("I add ash to the clay mixture."))
		playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
		if(!do_after(user, 1 SECONDS, target = src))
			return
		if(istype(src, /obj/item/natural/clay/kneaded))
			var/obj/item/natural/clay/refined_partial/partial = new(loc)
			partial.ash_kneads = ash_kneads + 1
			partial.sand_added = sand_added
			partial.stonedust_added = stonedust_added
			partial.final_temper_is_glass = final_temper_is_glass
			partial.is_wet = FALSE
			partial.needs_knead_after_wet = FALSE
			qdel(W)
			if(user.mind)
				user.mind.add_sleep_experience(/datum/skill/craft/ceramics, 2, FALSE)
			to_chat(user, span_notice("The clay now has [partial.ash_kneads]/2 ash added."))
			if(partial.is_refinement_ready())
				to_chat(user, span_notice("The clay mix is ready. I need to wet it and knead it once more to finish it."))
			qdel(src)
			return
		ash_kneads++
		qdel(W)
		if(user.mind)
			user.mind.add_sleep_experience(/datum/skill/craft/ceramics, 2, FALSE)
		to_chat(user, span_notice("The clay now has [ash_kneads]/2 ash added."))
		if(is_refinement_ready())
			to_chat(user, span_notice("The clay mix is ready. I need to wet it and knead it once more to finish it."))
		return

	if(istype(W, /obj/item/alch/stonedust))
		if(user.get_skill_level(/datum/skill/craft/ceramics) < SKILL_LEVEL_JOURNEYMAN)
			to_chat(user, span_warning("I need journeyman pottery knowledge to prepare glass batches."))
			return ..()
		if(stonedust_added)
			to_chat(user, span_warning("This clay already has enough stone dust mixed in."))
			return
		to_chat(user, span_notice("I add stone dust to the clay mixture."))
		playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
		if(!do_after(user, 1 SECONDS, target = src))
			return
		if(istype(src, /obj/item/natural/clay/kneaded))
			var/obj/item/natural/clay/refined_partial/partial = new(loc)
			partial.ash_kneads = ash_kneads
			partial.sand_added = sand_added
			partial.stonedust_added = TRUE
			partial.final_temper_is_glass = TRUE
			partial.is_wet = FALSE
			partial.needs_knead_after_wet = FALSE
			qdel(W)
			if(user.mind)
				user.mind.add_sleep_experience(/datum/skill/craft/ceramics, 2, FALSE)
			if(partial.is_refinement_ready())
				to_chat(user, span_notice("The clay mix is ready. I need to wet it and knead it once more to finish it."))
			else
				to_chat(user, span_notice("This clay is partially refined. I still need ash and sand before it can be finished."))
			qdel(src)
			return
		stonedust_added = TRUE
		final_temper_is_glass = TRUE
		qdel(W)
		if(user.mind)
			user.mind.add_sleep_experience(/datum/skill/craft/ceramics, 2, FALSE)
		if(is_refinement_ready())
			to_chat(user, span_notice("The clay mix is ready. I need to wet it and knead it once more to finish it."))
		else
			to_chat(user, span_notice("This clay is partially refined. I still need ash and sand before it can be finished."))
		return

	if(istype(W, /obj/item/natural/stone) || istype(W, /obj/item/natural/dirtclod/sand))
		if(sand_added)
			to_chat(user, span_warning("This clay already has enough sand mixed in."))
			return
		to_chat(user, span_notice("I add sand to the clay mixture."))
		playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
		if(!do_after(user, 1 SECONDS, target = src))
			return
		if(istype(src, /obj/item/natural/clay/kneaded))
			var/obj/item/natural/clay/refined_partial/partial = new(loc)
			partial.ash_kneads = ash_kneads
			partial.sand_added = TRUE
			partial.stonedust_added = stonedust_added
			partial.final_temper_is_glass = final_temper_is_glass
			partial.is_wet = FALSE
			partial.needs_knead_after_wet = FALSE
			qdel(W)
			if(user.mind)
				user.mind.add_sleep_experience(/datum/skill/craft/ceramics, 2, FALSE)
			if(partial.is_refinement_ready())
				to_chat(user, span_notice("The clay mix is ready. I need to wet it and knead it once more to finish it."))
			else if(partial.final_temper_is_glass)
				to_chat(user, span_notice("This clay is partially refined. I still need ash and stone dust before it can become glass batch."))
			else
				to_chat(user, span_notice("This clay is partially refined. I need more ash to finish it."))
			qdel(src)
			return
		sand_added = TRUE
		qdel(W)
		if(user.mind)
			user.mind.add_sleep_experience(/datum/skill/craft/ceramics, 2, FALSE)
		if(is_refinement_ready())
			to_chat(user, span_notice("The clay mix is ready. I need to wet it and knead it once more to finish it."))
		else if(final_temper_is_glass)
			to_chat(user, span_notice("This clay is partially refined. I still need ash and stone dust before it can become glass batch."))
		else
			to_chat(user, span_notice("This clay is partially refined. I need more ash to finish it."))
		return

	return ..()

/obj/item/natural/clay/cooking(input as num, burninput, atom/A) // I am using the same variable names from cooking
	if(!input)
		return
	if(cooktime)
		if(cooking < cooktime)
			cooking = cooking + input
			if(cooking >= cooktime)
				return heating_act(A)
			return
	burning(burninput)

/obj/item/natural/clay/heating_act(atom/A)
	var/obj/item/result
	var/successful_gold_glaze = FALSE
	var/successful_special_glaze = FALSE
	if(istype(A,/obj/machinery/light/rogue/oven))
		if(prob(shatter_chance))
			if(A)
				A.visible_message(span_warning("[src] cracks apart in the heat!"))
			playsound(src, 'sound/foley/glassbreak.ogg', 75, TRUE)
			qdel(src)
			return null
		if(cooked_type)
			var/target_cooked_type = cooked_type
			if(special_glaze_selected_type)
				if(needs_glaze_gold_dust && !has_glaze_gold_dust)
					target_cooked_type = special_glaze_default_type || cooked_type
					if(A)
						A.visible_message(span_notice("[src] bakes without enough gold and settles into a standard finish."))
				else
					target_cooked_type = special_glaze_selected_type
					successful_special_glaze = TRUE
					if(needs_glaze_gold_dust && has_glaze_gold_dust)
						successful_gold_glaze = TRUE
			result = new target_cooked_type(A)
			if(successful_gold_glaze && result.sellprice)
				result.sellprice = max(result.sellprice, round(initial(result.sellprice) * 2))
			apply_pottery_quality(result, pottery_quality, creator_skill, istype(src, /obj/item/natural/clay/porcelain))
			if(!istype(src, /obj/item/natural/clay/porcelain) && result.dropshrink < 1)
				result.dropshrink = 1
			if(successful_special_glaze)
				var/glaze_floor_multiplier = 1.0
				switch(pottery_quality)
					if(2)
						glaze_floor_multiplier = 1.2
					if(3)
						glaze_floor_multiplier = 1.4
					if(4)
						glaze_floor_multiplier = 1.6
					if(5)
						glaze_floor_multiplier = 2.0
				var/min_glaze_value = round(80 * glaze_floor_multiplier)
				if(!result.sellprice || result.sellprice < min_glaze_value)
					result.sellprice = min_glaze_value
				result.polished = 4
				if(!result.GetComponent(/datum/component/metal_glint))
					result.AddComponent(/datum/component/metal_glint)
		return result
	result = new /obj/item/ash(A) // No cooked_type? Pulverized.
	return result

/obj/item/natural/clay/proc/apply_pottery_quality(obj/item/result, quality_tier, creator_skill_level, source_is_porcelain = FALSE)
	if(!result)
		return
	
	var/quality_prefix = ""
	var/quality_multiplier = 1.0
	
	switch(quality_tier)
		if(0)
			quality_prefix = "crude "
			quality_multiplier = 0.4
		if(1)
			quality_prefix = "poor "
			quality_multiplier = 0.6
		if(2)
			quality_prefix = ""
			quality_multiplier = 0.8
		if(3)
			quality_prefix = "fine "
			quality_multiplier = 1.1
		if(4)
			quality_prefix = "flawless "
			quality_multiplier = 1.2
		if(5)
			quality_prefix = "masterwork "
			quality_multiplier = 1.5
	
	// Apply quality prefix to name
	if(quality_prefix)
		result.name = quality_prefix + initial(result.name)
	
	// Apply quality multiplier to sell price
	if(result.sellprice)
		result.sellprice = round(result.sellprice * quality_multiplier)

	// Non-porcelain clayware should stay meaningfully valuable and still scale with quality.
	if(!source_is_porcelain && result.sellprice)
		var/non_porcelain_min_base = 12
		var/non_porcelain_min_value = round(non_porcelain_min_base * quality_multiplier)
		if(result.sellprice < non_porcelain_min_value)
			result.sellprice = non_porcelain_min_value
	
	// Add masterwork sparkling effect
	if(quality_tier >= 4)
		result.polished = 4
		if(!result.GetComponent(/datum/component/metal_glint))
			result.AddComponent(/datum/component/metal_glint)
	
	// Store quality info on the result
	result.pottery_quality = quality_tier
	result.creator_skill = creator_skill_level
	result.pottery_fragile = TRUE
	result.pottery_baked_at = world.time

/obj/item/natural/clay/burning(input as num) // Overrides the generic /obj/item/proc/burning in snacks.dm
	if(!input)
		return
	if(burntime)
		burning = burning + input
		if(burning >= burntime && color != burned_color)
			color = burned_color
			name = "burned [name]"
