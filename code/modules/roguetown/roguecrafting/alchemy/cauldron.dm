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
	var/maxingredients = 4
	var/brewing = 0
	var/mob/living/carbon/human/lastuser
	fueluse = 20 MINUTES
	crossfire = FALSE

/obj/machinery/light/rogue/cauldron/update_icon()
	..()
	cut_overlays()
	if(reagents.total_volume > 0)
		if(!brewing)
			var/mutable_appearance/filling = mutable_appearance('icons/roguetown/misc/alchemy.dmi', "cauldron_full")
			filling.color = mix_color_from_reagents(reagents.reagent_list)
			filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
			add_overlay(filling)
		if(brewing > 0)
			var/mutable_appearance/filling = mutable_appearance('icons/roguetown/misc/alchemy.dmi', "cauldron_boiling")
			filling.color = mix_color_from_reagents(reagents.reagent_list)
			filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
			add_overlay(filling)
	return

/obj/machinery/light/rogue/cauldron/Initialize()
	create_reagents(500, DRAINABLE | AMOUNT_VISIBLE | REFILLABLE)
	. = ..()

/obj/machinery/light/rogue/cauldron/Destroy()
	chem_splash(loc, 2, list(reagents))
	qdel(reagents)
	..()

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
	if(on)
		if(ingredients.len)
			if(brewing < 20)
				// Check for various base reagents for KCD-style alchemy
				var/has_ethanol = FALSE
				for(var/datum/reagent/R in src.reagents.reagent_list)
					if(istype(R, /datum/reagent/consumable/ethanol) && src.reagents.get_reagent_amount(R.type) >= KCD_MIN_BASE_REAGENT_AMOUNT)
						has_ethanol = TRUE
						break
				
				if(src.reagents.has_reagent(/datum/reagent/water, KCD_MIN_BASE_REAGENT_AMOUNT) || 
				   src.reagents.has_reagent(/datum/reagent/cooking_oil, KCD_MIN_BASE_REAGENT_AMOUNT) ||
				   has_ethanol ||
				   src.reagents.has_reagent(/datum/reagent/rogueacid, KCD_MIN_BASE_REAGENT_AMOUNT) ||
				   src.reagents.has_reagent(/datum/reagent/alch_template, KCD_MIN_SECONDARY_REAGENT_AMOUNT))
					brewing++
					if(prob(10))
						playsound(src, "bubbles", 100, FALSE)
			else if(brewing == 20)
				// Try KCD-style alchemy first (single herb + base reagent)
				if(try_kcd_alchemy())
					return
				
				var/list/outcomes = list()
				for(var/obj/item/ing in src.ingredients)
					if(!ing.alchemy_component)
						continue
					var/datum/alchemy_component/alch_comp = ing.alchemy_component
					if(alch_comp.major_pot != null)
						if(outcomes[alch_comp.major_pot] != null)
							outcomes[alch_comp.major_pot] += 3
						else
							outcomes[alch_comp.major_pot] = 3
					if(alch_comp.med_pot != null)
						if(outcomes[alch_comp.med_pot] != null)
							outcomes[alch_comp.med_pot] += 2
						else
							outcomes[alch_comp.med_pot] = 2
					if(alch_comp.minor_pot != null)
						if(outcomes[alch_comp.minor_pot] != null)
							outcomes[alch_comp.minor_pot] += 1
						else
							outcomes[alching.minor_pot] = 1
				sortTim(outcomes,cmp=/proc/cmp_numeric_dsc,associative = 1)
				if(outcomes[outcomes[1]] >= 5)
					var/result_path = outcomes[1]
					var/datum/alch_cauldron_recipe/found_recipe = new result_path
					var/amt2raise = lastuser?.STAINT*2
					var/in_cauldron = src?.reagents?.get_reagent_amount(/datum/reagent/water)
					// Handle skillgating
					if(!lastuser)
						brewing = 0
						src.visible_message(span_info("The cauldron can't brew anything without an alchemist to guide it."))
						return
					if(found_recipe.skill_required > lastuser?.get_skill_level(/datum/skill/craft/alchemy))
						brewing = 0
						src.visible_message(span_warning("The ingredients in the cauldron melds together into a disgusting mess! Perhaps a more skilled alchemist is needed for this recipe."))
						if(reagents)
							src.reagents.remove_reagent(/datum/reagent/water, in_cauldron)
						for(var/obj/item/ing in src.ingredients)
							qdel(ing)
						src.reagents.add_reagent(/datum/reagent/yuck, in_cauldron) // 1 to 1 transmutation of yuck
						// Learn from your failure (Yeah you can technically still grind this way you just blow through a lot of ingredients)
						lastuser?.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE) 
						return
					for(var/obj/item/ing in src.ingredients)
						qdel(ing)
					if(reagents)
						src.reagents.remove_reagent(/datum/reagent/water, in_cauldron)
					if(found_recipe.output_reagents.len)
						src.reagents.add_reagent_list(found_recipe.output_reagents)
					if(found_recipe.output_items.len)
						for(var/itempath in found_recipe.output_items)
							new itempath(get_turf(src))
					//handle player perception and reset for next time
					src.visible_message("<span class='info'>The cauldron finishes boiling with a faint [found_recipe.smells_like] smell.</span>")
					record_featured_stat(FEATURED_STATS_ALCHEMISTS, lastuser)
					record_round_statistic(STATS_POTIONS_BREWED)
					//give xp for /datum/skill/craft/alchemy
					lastuser?.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE)
					playsound(src, "bubbles", 100, TRUE)
					playsound(src,'sound/misc/smelter_fin.ogg', 30, FALSE)
					ingredients = list()
					brewing = 21
					qdel(found_recipe)
				else
					brewing = 0
					src.visible_message("<span class='info'>The ingredients in the [src] fail to meld together at all...</span>")
					playsound(src,'sound/misc/smelter_fin.ogg', 30, FALSE)

/obj/machinery/light/rogue/cauldron/attackby(obj/item/I, mob/user, params)
	if(I.alchemy_component)
		if(ingredients.len >= maxingredients)
			to_chat(user, "<span class='warning'>Nothing else can fit.</span>")
			return FALSE
		if(!isnull(locate(I.type) in ingredients))
			to_chat(user, "<span class='warning'>There is already \a [I] in [src]! That would ruin the mixture!</span>")
			return FALSE
		if(!user.transferItemToLoc(I,src))
			to_chat(user, "<span class='warning'>[I] is stuck to my hand!</span>")
			return FALSE
		to_chat(user, "<span class='info'>I add [I] to [src].</span>")
		ingredients += I
		brewing = 0
		lastuser = user
		playsound(src, "bubbles", 100, TRUE)
		cut_overlays()
		var/mutable_appearance/filling = mutable_appearance('icons/roguetown/misc/alchemy.dmi', "cauldron_boiling")
		filling.color = mix_color_from_reagents(reagents.reagent_list)
		filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
		add_overlay(filling)
		sleep(30)
		update_icon()
		return TRUE
	..()

/obj/machinery/light/rogue/cauldron/attack_hand(mob/user, params)
	if(on)
		if(ingredients.len)
			to_chat(user, "<span class='warning'>Something's brewing.</span>")
			return
		else
			to_chat(user, "<span class='info'>Nothing's brewing.</span>")
			return
	else
		if(ingredients.len)
			var/obj/item/I = ingredients[ingredients.len]
			ingredients -= I
			I.loc = user.loc
			user.put_in_active_hand(I)
			user.visible_message("<span class='info'>[user] pulls [I] from [src].</span>")
			return
		to_chat(user, "<span class='info'>It's empty.</span>")
		return ..()

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

// KCD-Style Alchemy: Process single herb with base reagent(s)
/obj/machinery/light/rogue/cauldron/proc/try_kcd_alchemy()
	// Check if we have exactly one ingredient with alchemy component
	var/obj/item/herb = null
	var/herb_count = 0
	
	for(var/obj/item/ing in src.ingredients)
		if(ing.alchemy_component)
			herb = ing
			herb_count++
	
	// KCD alchemy requires exactly one ingredient
	if(herb_count != 1)
		return FALSE
	
	if(!lastuser)
		brewing = 0
		src.visible_message(span_info("The cauldron can't brew anything without an alchemist to guide it."))
		return TRUE
	
	var/amt2raise = lastuser?.STAINT*2
	var/user_skill = lastuser?.get_skill_level(/datum/skill/craft/alchemy)
	var/herb_name = herb.alchemy_component.name
	
	// List to track all base reagents found and their recipes
	var/list/recipes_to_process = list()
	
	// Check for all possible base reagents present in the cauldron
	// NOVICE: Water -> Tonic
	if(src.reagents.has_reagent(/datum/reagent/water, KCD_MIN_BASE_REAGENT_AMOUNT))
		var/amount = src.reagents.get_reagent_amount(/datum/reagent/water)
		recipes_to_process += list(list(
			"output_type" = /datum/reagent/alch_template/tonic,
			"base_reagent_type" = /datum/reagent/water,
			"base_amount" = amount,
			"skill_required" = SKILL_LEVEL_NOVICE,
			"smell" = "watery herbs"
		))
	
	// NOVICE: Cooking Oil -> Oil Extract
	if(src.reagents.has_reagent(/datum/reagent/cooking_oil, KCD_MIN_BASE_REAGENT_AMOUNT))
		var/amount = src.reagents.get_reagent_amount(/datum/reagent/cooking_oil)
		recipes_to_process += list(list(
			"output_type" = /datum/reagent/alch_template/oil_extract,
			"base_reagent_type" = /datum/reagent/cooking_oil,
			"base_amount" = amount,
			"skill_required" = SKILL_LEVEL_NOVICE,
			"smell" = "oily herbs"
		))
	
	// NOVICE: Wine -> Elixir
	if(src.reagents.has_reagent(/datum/reagent/consumable/ethanol/wine, KCD_MIN_BASE_REAGENT_AMOUNT))
		var/amount = src.reagents.get_reagent_amount(/datum/reagent/consumable/ethanol/wine)
		recipes_to_process += list(list(
			"output_type" = /datum/reagent/alch_template/elixir,
			"base_reagent_type" = /datum/reagent/consumable/ethanol/wine,
			"base_amount" = amount,
			"skill_required" = SKILL_LEVEL_NOVICE,
			"smell" = "sweet herbs"
		))
	
	// AMATEUR: Other Ethanol (Spirits) -> Bitters
	for(var/datum/reagent/R in src.reagents.reagent_list)
		if(istype(R, /datum/reagent/consumable/ethanol) && !istype(R, /datum/reagent/consumable/ethanol/wine))
			if(src.reagents.get_reagent_amount(R.type) >= KCD_MIN_BASE_REAGENT_AMOUNT)
				var/amount = src.reagents.get_reagent_amount(R.type)
				recipes_to_process += list(list(
					"output_type" = /datum/reagent/alch_template/bitters,
					"base_reagent_type" = R.type,
					"base_amount" = amount,
					"skill_required" = SKILL_LEVEL_APPRENTICE,
					"smell" = "bitter herbs"
				))
				break // Only process one type of spirit
	
	// AMATEUR: Acid -> Vitriol
	if(src.reagents.has_reagent(/datum/reagent/rogueacid, KCD_MIN_BASE_REAGENT_AMOUNT))
		var/amount = src.reagents.get_reagent_amount(/datum/reagent/rogueacid)
		recipes_to_process += list(list(
			"output_type" = /datum/reagent/alch_template/vitriol,
			"base_reagent_type" = /datum/reagent/rogueacid,
			"base_amount" = amount,
			"skill_required" = SKILL_LEVEL_APPRENTICE,
			"smell" = "caustic herbs"
		))
	
	// Secondary Processing (boiling products again)
	if(src.reagents.has_reagent(/datum/reagent/alch_template/tonic, KCD_MIN_SECONDARY_REAGENT_AMOUNT))
		var/amount = src.reagents.get_reagent_amount(/datum/reagent/alch_template/tonic)
		recipes_to_process += list(list(
			"output_type" = /datum/reagent/alch_template/concentrate,
			"base_reagent_type" = /datum/reagent/alch_template/tonic,
			"base_amount" = amount,
			"skill_required" = SKILL_LEVEL_APPRENTICE,
			"smell" = "concentrated herbs"
		))
	
	if(src.reagents.has_reagent(/datum/reagent/alch_template/oil_extract, KCD_MIN_SECONDARY_REAGENT_AMOUNT))
		var/amount = src.reagents.get_reagent_amount(/datum/reagent/alch_template/oil_extract)
		recipes_to_process += list(list(
			"output_type" = /datum/reagent/alch_template/paste,
			"base_reagent_type" = /datum/reagent/alch_template/oil_extract,
			"base_amount" = amount,
			"skill_required" = SKILL_LEVEL_JOURNEYMAN,
			"smell" = "thick herbs"
		))
	
	if(src.reagents.has_reagent(/datum/reagent/alch_template/elixir, KCD_MIN_SECONDARY_REAGENT_AMOUNT))
		var/amount = src.reagents.get_reagent_amount(/datum/reagent/alch_template/elixir)
		recipes_to_process += list(list(
			"output_type" = /datum/reagent/alch_template/syrup,
			"base_reagent_type" = /datum/reagent/alch_template/elixir,
			"base_amount" = amount,
			"skill_required" = SKILL_LEVEL_JOURNEYMAN,
			"smell" = "thick sweet herbs"
		))
	
	if(src.reagents.has_reagent(/datum/reagent/alch_template/bitters, KCD_MIN_SECONDARY_REAGENT_AMOUNT))
		var/amount = src.reagents.get_reagent_amount(/datum/reagent/alch_template/bitters)
		recipes_to_process += list(list(
			"output_type" = /datum/reagent/alch_template/powder_extract,
			"base_reagent_type" = /datum/reagent/alch_template/bitters,
			"base_amount" = amount,
			"skill_required" = SKILL_LEVEL_JOURNEYMAN,
			"smell" = "intensely bitter herbs"
		))
	
	if(src.reagents.has_reagent(/datum/reagent/alch_template/vitriol, KCD_MIN_SECONDARY_REAGENT_AMOUNT))
		var/amount = src.reagents.get_reagent_amount(/datum/reagent/alch_template/vitriol)
		recipes_to_process += list(list(
			"output_type" = /datum/reagent/alch_template/salt_extract,
			"base_reagent_type" = /datum/reagent/alch_template/vitriol,
			"base_amount" = amount,
			"skill_required" = SKILL_LEVEL_EXPERT,
			"smell" = "caustic crystals"
		))
	
	// No matching base reagents found
	if(!recipes_to_process.len)
		return FALSE
	
	// Process all recipes found
	var/any_success = FALSE
	var/list/smells = list()
	
	for(var/list/recipe in recipes_to_process)
		var/datum/reagent/output_type = recipe["output_type"]
		var/base_reagent_type = recipe["base_reagent_type"]
		var/base_amount = recipe["base_amount"]
		var/skill_required = recipe["skill_required"]
		var/smell = recipe["smell"]
		
		// Check skill requirement
		if(skill_required > user_skill)
			// Fail this recipe but continue with others
			if(reagents)
				src.reagents.remove_reagent(base_reagent_type, base_amount)
			src.reagents.add_reagent(/datum/reagent/yuck, base_amount * KCD_REAGENT_OUTPUT_RATIO)
			continue
		
		// Success! Create the product
		if(reagents)
			src.reagents.remove_reagent(base_reagent_type, base_amount)
		
		// Create output reagent (30u input -> 10u output)
		var/output_amount = base_amount * KCD_REAGENT_OUTPUT_RATIO
		
		// Add the reagent
		src.reagents.add_reagent(output_type, output_amount)
		
		// Customize the reagent name with the herb name
		for(var/datum/reagent/alch_template/R in src.reagents.reagent_list)
			if(R.type == output_type && !R.source_herb_name)
				R.source_herb_type = herb.type
				R.source_herb_name = herb_name
				var/base_name = initial(R.name)
				R.name = "[herb_name] [base_name]"
				break
		
		smells += smell
		any_success = TRUE
	
	// If at least one recipe succeeded
	if(any_success)
		// Delete the herb
		for(var/obj/item/ing in src.ingredients)
			qdel(ing)
		
		// Build smell description
		var/smell_text = "herbs"
		if(smells.len == 1)
			smell_text = smells[1]
		else if(smells.len > 1)
			smell_text = english_list(smells)
		
		src.visible_message("<span class='info'>The cauldron finishes boiling with a faint smell of [smell_text].</span>")
		record_featured_stat(FEATURED_STATS_ALCHEMISTS, lastuser)
		record_round_statistic(STATS_POTIONS_BREWED)
		lastuser?.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE)
		playsound(src, "bubbles", 100, TRUE)
		playsound(src,'sound/misc/smelter_fin.ogg', 30, FALSE)
		ingredients = list()
		brewing = 21
		return TRUE
	
	// All recipes failed
	for(var/obj/item/ing in src.ingredients)
		qdel(ing)
	src.visible_message(span_warning("The ingredients in the cauldron melds together into a disgusting mess! Perhaps a more skilled alchemist is needed for this recipe."))
	lastuser?.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE)
	ingredients = list()
	brewing = 21
	return TRUE
