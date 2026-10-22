/datum/crafting_recipe/roguetown/engineering/alch_workbench
	name = "Great Alchemical Laboratory"
	category = "Machines"
	result = /obj/machinery/alch_workbench
	reqs = list(
		/obj/item/natural/wood/plank = 6,
		/obj/item/ingot/iron = 2,
		/obj/item/reagent_containers/glass/bottle/alchemical = 4
	)
	verbage_simple = "assemble"
	verbage = "assembles"
	skillcraft = /datum/skill/craft/alchemy
	craftdiff = 3

/obj/machinery/alch_workbench
	name = "Great Alchemical Laboratory"
	desc = "A massive professional workstation for advanced distillation and high-tier alchemy."
	icon = 'icons/roguetown/misc/workbench.dmi'
	icon_state = "labs4"
	density = TRUE
	anchored = TRUE

	bound_width = 64
	bound_height = 32
	bound_x = 0
	bound_y = 0
	pixel_x = 0
	pixel_y = -16

	var/on = TRUE
	var/brewing = 0
	var/maxingredients = 3
	var/list/ingredients = list()
	var/mob/living/carbon/human/lastuser
	var/obj/item/synth_item = null
	var/obj/item/reagent_containers/synth_vessel_1 = null
	var/obj/item/reagent_containers/synth_vessel_2 = null
	var/obj/item/synth_result_item = null

/obj/machinery/alch_workbench/Initialize(mapload)
	. = ..()
	create_reagents(500, DRAINABLE | AMOUNT_VISIBLE | REFILLABLE | TRANSPARENT)
	update_icon()

/obj/machinery/alch_workbench/update_icon()
	. = ..()
	cut_overlays()
	icon_state = "labs4"

	if(reagents && reagents.total_volume > 0)
		var/mutable_appearance/filling = mutable_appearance(icon, "cauldron_full")
		filling.color = mix_color_from_reagents(reagents.reagent_list)
		filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
		add_overlay(filling)

/obj/machinery/alch_workbench/proc/check_synthesis_recipe()
	for(var/datum/alch_synthesis_recipe/R in GLOB.alch_synthesis_recipes)
		if(!R.name)
			continue

		if(R.req_item)
			if(!synth_item || !istype(synth_item, R.req_item))
				continue
		else
			if(synth_item)
				continue

		var/match_direct = check_vessel_match(synth_vessel_1, R.req_reagents_1) && check_vessel_match(synth_vessel_2, R.req_reagents_2)
		var/match_swapped = check_vessel_match(synth_vessel_1, R.req_reagents_2) && check_vessel_match(synth_vessel_2, R.req_reagents_1)

		if(match_direct || match_swapped)
			return R

	return null

/obj/machinery/alch_workbench/proc/check_vessel_match(obj/item/reagent_containers/V, list/req_reagents)
	if(!req_reagents || !req_reagents.len)
		return TRUE
	if(!V || !V.reagents)
		return FALSE
	for(var/reagent_path in req_reagents)
		if(V.reagents.get_reagent_amount(reagent_path) < req_reagents[reagent_path])
			return FALSE
	return TRUE

/obj/machinery/alch_workbench/proc/get_vessel_data(obj/item/reagent_containers/V)
	if(!V)
		return null
	var/list/reags = list()
	if(V.reagents)
		for(var/datum/reagent/R in V.reagents.reagent_list)
			reags += list(list("name" = R.name, "vol" = round(R.volume, 0.1), "color" = R.color || "#3498db"))
	return list(
		"name" = V.name,
		"cur" = V.reagents ? round(V.reagents.total_volume, 0.1) : 0,
		"max" = V.reagents ? V.reagents.maximum_volume : 30,
		"icon" = "[V.icon]",
		"icon_state" = V.icon_state,
		"contents" = reags
	)

/obj/machinery/alch_workbench/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/alch_workbench/attackby(obj/item/I, mob/user, params)
	if(is_alchemical_ingredient(I))
		if(ingredients.len >= maxingredients)
			to_chat(user, span_warning("All reaction slots on the laboratory are full!"))
			return FALSE
		if(!isnull(locate(I.type) in ingredients))
			to_chat(user, span_warning("There is already a [I.name] installed in the laboratory!"))
			return FALSE
		if(!user.transferItemToLoc(I, src))
			to_chat(user, span_warning("[I] is stuck to your hand!"))
			return FALSE

		to_chat(user, span_info("You place [I] into the laboratory reaction chamber."))
		ingredients += I
		brewing = 0
		lastuser = user
		playsound(src, "bubbles", 100, TRUE)
		update_icon()
		SStgui.update_uis(src)
		return TRUE
	return ..()

/obj/machinery/alch_workbench/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AlchemyWorkbench", name)
		ui.open()

/obj/machinery/alch_workbench/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/alchemy_ui)
	)

/obj/machinery/alch_workbench/proc/get_current_base_type()
	if(!reagents)
		return null
	if(reagents.has_reagent(/datum/reagent/water, 1))
		return /datum/reagent/water
	if(reagents.has_reagent(/datum/reagent/consumable/ethanol/wine, 1))
		return /datum/reagent/consumable/ethanol/wine
	if(reagents.has_reagent(/datum/reagent/consumable/milk, 1))
		return /datum/reagent/consumable/milk
	return null

/obj/machinery/alch_workbench/proc/get_base_key(base_path)
	switch(base_path)
		if(/datum/reagent/water)
			return "water"
		if(/datum/reagent/consumable/ethanol/wine)
			return "wine"
		if(/datum/reagent/consumable/milk)
			return "milk"
	return "none"

/obj/machinery/alch_workbench/ui_data(mob/user)
	var/list/data = list()

	data["on"] = on ? TRUE : FALSE
	data["brewing"] = brewing
	data["upgrade_lvl"] = 4

	var/cur_base_type = get_current_base_type()
	var/base_key = get_base_key(cur_base_type)
	var/base_amount = cur_base_type ? reagents.get_reagent_amount(cur_base_type) : 0

	data["base_type"] = base_key
	data["base_amount"] = base_amount ? round(base_amount, 0.1) : 0
	data["base_need"] = 60

	var/list/ing_data = list()
	var/list/sum_runes = list("red" = 0, "green" = 0, "blue" = 0, "rainbow" = 0)

	for(var/obj/item/ing in ingredients)
		var/list/item_runes = list(
			"red"     = ing.runes[ALCH_RUNE_RED] || 0,
			"green"   = ing.runes[ALCH_RUNE_GREEN] || 0,
			"blue"    = ing.runes[ALCH_RUNE_BLUE] || 0,
			"rainbow" = ing.runes[ALCH_RUNE_RAINBOW] || 0
		)
		sum_runes["red"] += item_runes["red"]
		sum_runes["green"] += item_runes["green"]
		sum_runes["blue"] += item_runes["blue"]
		sum_runes["rainbow"] += item_runes["rainbow"]

		ing_data += list(list(
			"name" = ing.name,
			"ref" = REF(ing),
			"runes" = item_runes,
			"icon" = "[ing.icon]",
			"icon_state" = ing.icon_state
		))

	data["ingredients"] = ing_data
	data["total_runes"] = sum_runes

	var/matched_recipe_name = null
	var/matched_base_key = null
	var/list/recipes_list = GLOB.alch_cauldron_recipes

	for(var/datum/alch_cauldron_recipe/R in recipes_list)
		if(!R.name)
			continue
		var/list/req = R.required_runes
		var/r_red   = req[ALCH_RUNE_RED] || 0
		var/r_green = req[ALCH_RUNE_GREEN] || 0
		var/r_blue  = req[ALCH_RUNE_BLUE] || 0

		if(R.requires_rainbow && !sum_runes["rainbow"])
			continue

		if(sum_runes["red"] == r_red && \
		   sum_runes["green"] == r_green && \
		   sum_runes["blue"] == r_blue)
			matched_recipe_name = R.name
			matched_base_key = get_base_key(R.required_base)
			break

	data["matched_recipe"] = matched_recipe_name
	data["matched_base"] = matched_base_key

	var/alch_skill = user.get_skill_level(/datum/skill/craft/alchemy)
	var/list/book_recipes = list()

	for(var/datum/alch_cauldron_recipe/R in recipes_list)
		if(!R.name)
			continue
		var/list/req = R.required_runes
		var/is_high_tier = (req[ALCH_RUNE_RED] > 3 || req[ALCH_RUNE_GREEN] > 3 || req[ALCH_RUNE_BLUE] > 3)

		book_recipes += list(list(
			"name" = R.name,
			"skill" = SSskills.level_names_plain[R.skill_required],
			"skill_met" = (alch_skill >= R.skill_required),
			"base" = get_base_key(R.required_base),
			"high_tier" = is_high_tier,
			"requires_rainbow" = R.requires_rainbow ? TRUE : FALSE,
			"runes" = list(
				"red"   = req[ALCH_RUNE_RED] || 0,
				"green" = req[ALCH_RUNE_GREEN] || 0,
				"blue"  = req[ALCH_RUNE_BLUE] || 0
			)
		))

	data["recipes"] = book_recipes

	var/obj/item/held = user.get_active_held_item()
	data["user_has_ingredient_in_hand"] = (held && held.runes && held.runes.len > 0)

	data["synth_item"] = synth_item ? list(
		"name" = synth_item.name,
		"icon" = "[synth_item.icon]",
		"icon_state" = synth_item.icon_state
	) : null

	data["synth_vessel_1"] = get_vessel_data(synth_vessel_1)
	data["synth_vessel_2"] = get_vessel_data(synth_vessel_2)

	data["synth_result"] = synth_result_item ? list(
		"name" = synth_result_item.name,
		"icon" = "[synth_result_item.icon]",
		"icon_state" = synth_result_item.icon_state
	) : null

	var/datum/alch_synthesis_recipe/SR = check_synthesis_recipe()
	data["matched_synth_recipe"] = SR ? SR.name : null
	data["matched_synth_desc"] = SR ? SR.desc : null

	return data

/obj/machinery/alch_workbench/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return TRUE

	var/mob/user = usr

	switch(action)
		if("insert_item")
			if(ingredients.len >= maxingredients)
				to_chat(user, span_warning("The worlbench is full!"))
				return TRUE
			var/obj/item/I = user.get_active_held_item()
			if(!is_alchemical_ingredient(I))
				to_chat(user, span_warning("You don't have an alchemical ingredient in your active hand!"))
				return TRUE
			if(!isnull(locate(I.type) in ingredients))
				to_chat(user, span_warning("[I.name] has already been installed in the laboratory."))
				return TRUE
			if(!user.transferItemToLoc(I, src))
				return TRUE

			ingredients += I
			brewing = 0
			lastuser = user
			playsound(src, "bubbles", 100, TRUE)
			update_icon()
			return TRUE

		if("remove_item")
			var/target_ref = params["ref"]
			var/obj/item/found = null
			for(var/obj/item/I in ingredients)
				if(REF(I) == target_ref)
					found = I
					break
			if(found)
				ingredients -= found
				if(!user.put_in_hands(found))
					found.forceMove(get_turf(user))
				brewing = 0
				update_icon()
			return TRUE

		if("brew")
			if(brewing > 0)
				return TRUE
			if(ingredients.len < 1)
				to_chat(user, span_warning("At least 1 ingredient is required to start."))
				return TRUE
			if(!on)
				to_chat(user, span_warning("Laboratory heaters are turned off."))
				return TRUE

			var/cur_base = get_current_base_type()
			if(!cur_base || reagents.get_reagent_amount(cur_base) < 60)
				to_chat(user, span_warning("Not enough liquid base"))
				return TRUE

			lastuser = user
			brewing = 1
			playsound(src, "bubbles", 100, TRUE)
			SStgui.update_uis(src)
			return TRUE

		if("toggle_fire")
			on = !on
			update_icon()
			return TRUE
		if("insert_synth_item")
			var/obj/item/I = user.get_active_held_item()
			if(!I || synth_item)
				return TRUE
			if(user.transferItemToLoc(I, src))
				synth_item = I
				update_icon()
			return TRUE

		if("remove_synth_item")
			if(synth_item)
				user.put_in_hands(synth_item)
				synth_item = null
				update_icon()
			return TRUE

		if("insert_synth_vessel")
			var/slot = params["slot"]
			var/obj/item/reagent_containers/RC = user.get_active_held_item()
			if(!istype(RC))
				to_chat(user, span_warning("In your hand must be a reagent container"))
				return TRUE
			if(user.transferItemToLoc(RC, src))
				if(slot == "1")
					synth_vessel_1 = RC
				else
					synth_vessel_2 = RC
				update_icon()
			return TRUE

		if("remove_synth_vessel")
			var/slot = params["slot"]
			var/obj/item/target = (slot == "1") ? synth_vessel_1 : synth_vessel_2
			if(target)
				user.put_in_hands(target)
				if(slot == "1")
					synth_vessel_1 = null
				else
					synth_vessel_2 = null
				update_icon()
			return TRUE

		if("take_synth_result")
			if(synth_result_item)
				if(!user.put_in_hands(synth_result_item))
					synth_result_item.forceMove(get_turf(user))
				synth_result_item = null
				update_icon()
			return TRUE

		if("do_synthesis")
			if(synth_result_item)
				to_chat(user, span_warning("First, take the finished item from the result slot."))
				return TRUE

			var/datum/alch_synthesis_recipe/R = check_synthesis_recipe()
			if(!R)
				to_chat(user, span_warning("The components do not form any known synthesis"))
				return TRUE

			if(R.skill_required > user.get_skill_level(/datum/skill/craft/alchemy))
				to_chat(user, span_warning("You lack the alchemy skill to stabilize this complex synthesis"))
				return TRUE

			var/direct = check_vessel_match(synth_vessel_1, R.req_reagents_1)
			var/obj/item/reagent_containers/V1 = direct ? synth_vessel_1 : synth_vessel_2
			var/obj/item/reagent_containers/V2 = direct ? synth_vessel_2 : synth_vessel_1

			if(R.req_reagents_1)
				for(var/p in R.req_reagents_1)
					V1.reagents.remove_reagent(p, R.req_reagents_1[p])
			if(R.req_reagents_2)
				for(var/p in R.req_reagents_2)
					V2.reagents.remove_reagent(p, R.req_reagents_2[p])

			if(synth_item)
				qdel(synth_item)
				synth_item = null

			if(R.result_item)
				synth_result_item = new R.result_item(src)
			
			if(R.result_reagents && V1)
				V1.reagents.add_reagent_list(R.result_reagents)

			playsound(src, 'sound/effects/hood_ignite.ogg', 60, TRUE)
			user.visible_message(span_notice("[user] successfully completes the alchemical synthesis: [R.name]"))
			update_icon()
			return TRUE

/obj/machinery/alch_workbench/process()
	..()
	update_icon()
	if(!on)
		return

	if(ingredients.len >= 1)
		var/cur_base = get_current_base_type()
		var/base_amt = cur_base ? reagents.get_reagent_amount(cur_base) : 0

		if(brewing > 0 && brewing < 3)
			if(base_amt >= 60)
				brewing++
				if(prob(30))
					playsound(src, "bubbles", 100, FALSE)
				SStgui.update_uis(src)
			else
				brewing = 0
				SStgui.update_uis(src)

		else if(brewing >= 3)
			if(!lastuser)
				brewing = 0
				SStgui.update_uis(src)
				return

			var/list/cauldron_runes = list(
				ALCH_RUNE_RED     = 0,
				ALCH_RUNE_GREEN   = 0,
				ALCH_RUNE_BLUE    = 0
			)

			var/rainbow_tier = 0

			for(var/obj/item/ing in ingredients)
				for(var/r in ing.runes)
					if(r == ALCH_RUNE_RAINBOW)
						rainbow_tier = ing.runes[r]
					else
						cauldron_runes[r] += ing.runes[r]

			var/amt2raise = lastuser.STAINT * 4
			var/datum/alch_cauldron_recipe/found_recipe = null

			if(rainbow_tier > 0)
				for(var/datum/alch_cauldron_recipe/R in GLOB.alch_cauldron_recipes)
					if(!initial(R.name) || !R.vars["requires_rainbow"])
						continue
					var/list/req = R.required_runes
					if(cauldron_runes[ALCH_RUNE_RED] == (req[ALCH_RUNE_RED] || 0) && \
					   cauldron_runes[ALCH_RUNE_GREEN] == (req[ALCH_RUNE_GREEN] || 0) && \
					   cauldron_runes[ALCH_RUNE_BLUE] == (req[ALCH_RUNE_BLUE] || 0) && \
					   R.required_base == cur_base)
						found_recipe = R
						break

			if(!found_recipe && rainbow_tier == 0)
				for(var/datum/alch_cauldron_recipe/R in GLOB.alch_cauldron_recipes)
					if(!initial(R.name) || R.vars["requires_rainbow"])
						continue
					var/list/req = R.required_runes
					if(cauldron_runes[ALCH_RUNE_RED] == (req[ALCH_RUNE_RED] || 0) && \
					   cauldron_runes[ALCH_RUNE_GREEN] == (req[ALCH_RUNE_GREEN] || 0) && \
					   cauldron_runes[ALCH_RUNE_BLUE] == (req[ALCH_RUNE_BLUE] || 0) && \
					   R.required_base == cur_base)
						found_recipe = R
						break

			if(found_recipe)
				if(found_recipe.skill_required > lastuser.get_skill_level(/datum/skill/craft/alchemy))
					brewing = 0
					src.visible_message(span_warning("The ingredients are burning up! Alchemy skill is insufficient."))
					reagents.clear_reagents()
					reagents.add_reagent(/datum/reagent/yuck, 60)
					for(var/obj/item/ing in ingredients)
						qdel(ing)
					ingredients.Cut()
					lastuser.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE)
					SStgui.update_uis(src)
					return

				for(var/obj/item/ing in ingredients)
					qdel(ing)
				ingredients.Cut()

				reagents.clear_reagents()

				if(found_recipe.output_reagents.len)
					reagents.add_reagent_list(found_recipe.output_reagents)

				if(rainbow_tier > 0)
					for(var/reag_path in found_recipe.output_reagents)
						var/datum/reagent/medicine/mythic/M = reagents.get_reagent(reag_path)
						if(istype(M))
							M.potency_tier = rainbow_tier
							if(!islist(M.data))
								M.data = list()
							M.data["potency_tier"] = rainbow_tier

					src.visible_message(span_userdanger("The laboratory is illuminated by a prismatic glow! Created [found_recipe.name] (Rank [rainbow_tier])!"))
				else
					src.visible_message(span_info("The laboratory is finishing the distillation of the potion."))
					playsound(src, 'sound/misc/smelter_fin.ogg', 40, FALSE)

				if(found_recipe.output_items.len)
					for(var/itempath in found_recipe.output_items)
						new itempath(get_turf(src))

				lastuser.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE)
				brewing = 0
				SStgui.update_uis(src)

			else
				brewing = 0
				src.visible_message(span_info("The essences of the components failed to bond within this base..."))
				playsound(src, 'sound/misc/smelter_fin.ogg', 30, FALSE)
				SStgui.update_uis(src)
