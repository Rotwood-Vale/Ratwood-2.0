/obj/machinery/light/rogue/cauldron
	name = "cauldron"
	desc = "Bubble, Bubble, toil and trouble. A great iron cauldron for brewing potions."
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "cauldron1"
	base_state = "cauldron"
	density = TRUE
	opacity = FALSE
	anchored = TRUE
	max_integrity = 300
	var/list/ingredients = list()
	var/maxingredients = 2
	var/brewing = 0
	var/waterneed = 90 
	var/mob/living/carbon/human/lastuser
	fueluse = 20 MINUTES
	crossfire = FALSE

/obj/machinery/light/rogue/cauldron/update_icon()
	..()
	cut_overlays()
	if(reagents.total_volume > 0)
		if(!brewing)
			var/mutable_appearance/filling = mutable_appearance(icon, "cauldron_full")
			filling.color = mix_color_from_reagents(reagents.reagent_list)
			filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
			add_overlay(filling)
		if(brewing > 0)
			var/mutable_appearance/filling = mutable_appearance(icon, "cauldron_boiling")
			filling.color = mix_color_from_reagents(reagents.reagent_list)
			filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
			add_overlay(filling)
	return
	
/obj/machinery/light/rogue/cauldron/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/alchemy_ui)
	)

/obj/machinery/light/rogue/cauldron/Initialize(mapload)
	create_reagents(500, DRAINABLE | AMOUNT_VISIBLE | REFILLABLE)
	. = ..()

/obj/machinery/light/rogue/cauldron/Destroy()
	chem_splash(loc, 2, list(reagents))
	return ..()

/obj/machinery/light/rogue/cauldron/burn_out()
	brewing = 0
	..()

/*
/obj/machinery/light/rogue/cauldron/examine(mob/user)
	if(ingredients.len)//ingredients.len
		DISABLE_BITFIELD(reagents.flags, AMOUNT_VISIBLE)
	else
		ENABLE_BITFIELD(reagents.flags, AMOUNT_VISIBLE)
	. = ..()
*/

/obj/machinery/light/rogue/cauldron/process()
	..()
	update_icon()
	if(!on)
		return

	if(ingredients.len == 1)
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
				ALCH_RUNE_RED   = 0,
				ALCH_RUNE_GREEN = 0,
				ALCH_RUNE_BLUE  = 0
			)

			for(var/obj/item/ing in ingredients)
				for(var/r in ing.runes)
					cauldron_runes[r] += ing.runes[r]

			var/datum/alch_cauldron_recipe/found_recipe = null
			for(var/datum/alch_cauldron_recipe/R in GLOB.alch_cauldron_recipes)
				if(!R.name)
					continue
				var/list/req = R.required_runes
				var/r_red   = req[ALCH_RUNE_RED] || 0
				var/r_green = req[ALCH_RUNE_GREEN] || 0
				var/r_blue  = req[ALCH_RUNE_BLUE] || 0

				if(cauldron_runes[ALCH_RUNE_RED] == r_red && \
				   cauldron_runes[ALCH_RUNE_GREEN] == r_green && \
				   cauldron_runes[ALCH_RUNE_BLUE] == r_blue && \
				   R.required_base == cur_base)
					found_recipe = R
					break

			var/amt2raise = lastuser.STAINT * 2

			if(found_recipe)
				if(found_recipe.skill_required > lastuser.get_skill_level(/datum/skill/craft/alchemy))
					brewing = 0
					src.visible_message(span_warning("The ingredients curdle into a disgusting mess! A more skilled alchemist is needed."))
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

				if(found_recipe.output_items.len)
					for(var/itempath in found_recipe.output_items)
						new itempath(get_turf(src))

				src.visible_message(span_info("The cauldron finishes brewing with a glorious aroma!"))
				playsound(src, "bubbles", 100, TRUE)
				playsound(src, 'sound/misc/smelter_fin.ogg', 30, FALSE)
				lastuser.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE)

				brewing = 0
				SStgui.update_uis(src)

			else
				brewing = 0
				src.visible_message(span_info("The ingredients fail to meld together, the essences clash..."))
				playsound(src, 'sound/misc/smelter_fin.ogg', 30, FALSE)
				SStgui.update_uis(src)

/obj/machinery/light/rogue/cauldron/proc/get_current_base_type()
	if(!reagents)
		return null
	if(reagents.has_reagent(/datum/reagent/water, 1))
		return /datum/reagent/water
	if(reagents.has_reagent(/datum/reagent/consumable/ethanol/wine, 1))
		return /datum/reagent/consumable/ethanol/wine
	if(reagents.has_reagent(/datum/reagent/consumable/milk, 1))
		return /datum/reagent/consumable/milk
	return null

/obj/machinery/light/rogue/cauldron/proc/get_base_key(base_path)
	switch(base_path)
		if(/datum/reagent/water)
			return "water"
		if(/datum/reagent/consumable/ethanol/wine)
			return "wine"
		if(/datum/reagent/consumable/milk)
			return "milk"
	return "none"

/obj/machinery/light/rogue/cauldron/attackby(obj/item/I, mob/user, params)
	if(!istype(I))
		return ..()

	if(!I.runes || !I.runes.len)
		return ..()

	if(ingredients.len >= maxingredients)
		to_chat(user, span_warning("Nothing else can fit."))
		return FALSE
	if(!isnull(locate(I.type) in ingredients))
		to_chat(user, span_warning("There is already a [I.name] in [src]! That would ruin the mixture!"))
		return FALSE
	if(!user.transferItemToLoc(I, src))
		to_chat(user, span_warning("[I] is stuck to your hand!"))
		return FALSE

	to_chat(user, span_info("I add [I] to [src]."))
	ingredients += I
	brewing = 0
	lastuser = user
	playsound(src, "bubbles", 100, TRUE)
	update_icon()
	SStgui.update_uis(src)
	return TRUE

/obj/machinery/light/rogue/cauldron/attack_hand(mob/user, params)
	ui_interact(user)

/obj/machinery/light/rogue/cauldron/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AlchemyCauldron", "Алхимическая лаборатория")
		ui.open()


/obj/machinery/light/rogue/cauldron/ui_data(mob/user)
	var/list/data = list()

	data["on"] = on ? TRUE : FALSE
	data["brewing"] = brewing

	var/cur_base_type = get_current_base_type()
	var/base_key = get_base_key(cur_base_type)
	var/base_amount = cur_base_type ? reagents.get_reagent_amount(cur_base_type) : 0

	data["base_type"] = base_key
	data["base_amount"] = base_amount
	data["base_need"] = 60

	var/list/ing_data = list()
	var/list/sum_runes = list("red" = 0, "green" = 0, "blue" = 0)

	for(var/obj/item/ing in ingredients)
		var/list/item_runes = list(
			"red" = ing.runes[ALCH_RUNE_RED] || 0,
			"green" = ing.runes[ALCH_RUNE_GREEN] || 0,
			"blue" = ing.runes[ALCH_RUNE_BLUE] || 0
		)
		sum_runes["red"] += item_runes["red"]
		sum_runes["green"] += item_runes["green"]
		sum_runes["blue"] += item_runes["blue"]

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

		if(sum_runes["red"] == r_red && sum_runes["green"] == r_green && sum_runes["blue"] == r_blue)
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
		var/is_high_tier = (req[ALCH_RUNE_RED] > 3 || req[ALCH_RUNE_GREEN] > 3 || req[ALCH_RUNE_BLUE] > 3 || R.requires_rainbow)
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

	return data

/obj/machinery/light/rogue/cauldron/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return TRUE

	var/mob/user = usr

	switch(action)
		if("insert_item")
			if(ingredients.len >= maxingredients)
				to_chat(user, span_warning("The cauldron is full!"))
				return TRUE
			var/obj/item/I = user.get_active_held_item()
			if(!is_alchemical_ingredient(I))
				to_chat(user, span_warning("You don't have an alchemical ingredient in your active hand!"))
				return TRUE
			if(!isnull(locate(I.type) in ingredients))
				to_chat(user, span_warning("В котле уже есть [I.name]!"))
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
			var/obj/item/found_item = null
			for(var/obj/item/I in ingredients)
				if(REF(I) == target_ref)
					found_item = I
					break

			if(found_item)
				ingredients -= found_item
				if(!user.put_in_hands(found_item))
					found_item.forceMove(get_turf(user))
					to_chat(user, span_notice("Руки полны, [found_item.name] падает на пол."))
				else
					to_chat(user, span_notice("Вы достаете [found_item.name] из котла."))
				brewing = 0
				update_icon()
			return TRUE

		if("brew")
			if(brewing > 0)
				return TRUE
			if(ingredients.len != 1)
				to_chat(user, span_warning("You need exactly 1 ingredients to start brewing!"))
				return TRUE
			if(!on)
				to_chat(user, span_warning("The fire is extinguished!"))
				return TRUE

			var/cur_base = get_current_base_type()
			if(!cur_base || reagents.get_reagent_amount(cur_base) < 60)
				to_chat(user, span_warning("You need at least 60 oz of a liquid base (Water, Wine, or Milk)!"))
				return TRUE

			lastuser = user
			brewing = 1
			playsound(src, "bubbles", 100, TRUE)
			to_chat(user, span_info("You begin the distillation process..."))
			SStgui.update_uis(src)
			return TRUE

		if("toggle_fire")
			if(on)
				burn_out()
				to_chat(user, span_notice("Вы гасите огонь под котлом."))
			else
				on = TRUE
				update_icon()
				to_chat(user, span_notice("Вы разжигаете пламя под котлом."))
			return TRUE

/obj/machinery/light/rogue/cauldron/onkick(mob/user)
	if(ingredients.len)
		for(var/obj/item/in_caul in ingredients)
			ingredients -= in_caul
			in_caul.forceMove(get_turf(user))
	if(reagents)
		chem_splash(loc, 2, list(reagents))
		if(HAS_TRAIT(user, TRAIT_LAMIAN_TAIL))
			user.visible_message("<span class='info'>[user] tailslams [src] over, spilling it's contents!</span>")
		else
			user.visible_message("<span class='info'>[user] kicks [src], spilling it's contents!</span>")
	playsound(src, 'sound/items/beartrap2.ogg', 100, FALSE)
	return ..()

/obj/machinery/light/rogue/cauldron/folding
	name = "folding cauldron"
	desc = "Bubble, Bubble, toil and trouble. A great protable bronze cauldron for brewing potions."
	icon = 'icons/roguetown/misc/gadgets.dmi'
	icon_state = "FoldingCauldronDeployed1"
	base_state = "FoldingCauldronDeployed"
	maxingredients = 3 //-1
	waterneed = 60
	fueluse = 2 MINUTES 

/obj/machinery/light/rogue/cauldron/folding/examine()
	. = ..()
	. += span_blue("Right-Click to fold the cauldron. Empty it first.")

/obj/machinery/light/rogue/cauldron/folding/attack_right(mob/user)
	if(do_after(user, 5 SECONDS, target = src))
		user.visible_message(span_notice("[user] folds [src]."), span_notice("You fold [src]."))
		new /obj/item/folding_table_stored/alchcauldron(drop_location())
		qdel(src)
		return ..()
	return

/obj/machinery/light/rogue/cauldron/folding/Initialize(mapload)
	. = ..()
	burn_out()
	create_reagents(60, DRAINABLE | AMOUNT_VISIBLE | REFILLABLE) //small
	update_icon()

/proc/is_alchemical_ingredient(obj/item/I)
	if(!istype(I))
		return FALSE
	if(istype(I, /obj/item/alch))
		return TRUE
	if(istype(I, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/S = I
		return S.runes && S.runes.len > 0
	return FALSE
