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
		// Check if we can brew - either with ingredients OR with extract reagents for secondary processing
		var/can_brew = ingredients.len > 0 || src.reagents.has_reagent(/datum/reagent/herb_extract, 30)
		
		if(can_brew)
			if(brewing < 20)
				// Check for base reagents (water, oil, wine, acid) - need 90u minimum
				// OR check for extract reagents for secondary processing - need 30u minimum
				if(src.reagents.has_reagent(/datum/reagent/water,90) ||
				   src.reagents.has_reagent(/datum/reagent/cooking_oil,90) ||
				   src.reagents.has_reagent(/datum/reagent/consumable/ethanol,90) ||
				   src.reagents.has_reagent(/datum/reagent/rogueacid,90) ||
				   src.reagents.has_reagent(/datum/reagent/herb_extract,30))  // Secondary processing needs only 30u
					brewing++
					if(prob(10))
						playsound(src, "bubbles", 100, FALSE)
			else if(brewing == 20)
				// First, try KCD-style alchemy (herb + base reagent → extract OR extract → concentrate)
				if(try_kcd_herb_extraction())
					return
				
				// Fall back to traditional potion system
				var/list/outcomes = list()
				for(var/obj/item/ing in src.ingredients)
					if(!istype(ing,/obj/item/alch))
						continue
					var/obj/item/alch/alching = ing
					if(alching.major_pot != null)
						if(outcomes[alching.major_pot] != null)
							outcomes[alching.major_pot] += 3
						else
							outcomes[alching.major_pot] = 3
					if(alching.med_pot != null)
						if(outcomes[alching.med_pot] != null)
							outcomes[alching.med_pot] += 2
						else
							outcomes[alching.med_pot] = 2
					if(alching.minor_pot != null)
						if(outcomes[alching.minor_pot] != null)
							outcomes[alching.minor_pot] += 1
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
	if(istype(I,/obj/item/alch))
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

// KCD-Style Herb Extraction: Process single herb with base reagent
/obj/machinery/light/rogue/cauldron/proc/try_kcd_herb_extraction()
	// Check if we're doing secondary processing (no herb needed) or primary (herb needed)
	var/obj/item/alch/herb = null
	var/herb_count = 0
	
	for(var/obj/item/ing in src.ingredients)
		if(istype(ing, /obj/item/alch))
			herb = ing
			herb_count++
	
	if(!lastuser)
		brewing = 0
		src.visible_message(span_info("The cauldron can't brew anything without an alchemist to guide it."))
		return TRUE
	
	var/user_skill = lastuser.get_skill_level(/datum/skill/craft/alchemy)
	var/amt2raise = lastuser.STAINT*2
	
	// Determine which base reagent and create appropriate extract
	var/datum/reagent/extract_type = null
	var/base_reagent_type = null
	var/base_amount = 0
	var/skill_required = SKILL_LEVEL_NOVICE
	var/extract_name = ""
	var/is_secondary_processing = FALSE
	
	// Check for secondary processing first (no herb needed)
	// AMATEUR - Secondary processing: Tonic → Concentrate
	if(src.reagents.has_reagent(/datum/reagent/herb_extract/tonic, 30))
		extract_type = /datum/reagent/herb_extract/concentrate
		base_reagent_type = /datum/reagent/herb_extract/tonic
		base_amount = src.reagents.get_reagent_amount(/datum/reagent/herb_extract/tonic)
		skill_required = SKILL_LEVEL_APPRENTICE
		extract_name = "concentrate"
		is_secondary_processing = TRUE
	
	// JOURNEYMAN - Tertiary processing
	else if(src.reagents.has_reagent(/datum/reagent/herb_extract/oil, 30))
		extract_type = /datum/reagent/herb_extract/paste
		base_reagent_type = /datum/reagent/herb_extract/oil
		base_amount = src.reagents.get_reagent_amount(/datum/reagent/herb_extract/oil)
		skill_required = SKILL_LEVEL_JOURNEYMAN
		extract_name = "paste"
		is_secondary_processing = TRUE
		
	else if(src.reagents.has_reagent(/datum/reagent/herb_extract/elixir, 30))
		extract_type = /datum/reagent/herb_extract/syrup
		base_reagent_type = /datum/reagent/herb_extract/elixir
		base_amount = src.reagents.get_reagent_amount(/datum/reagent/herb_extract/elixir)
		skill_required = SKILL_LEVEL_JOURNEYMAN
		extract_name = "syrup"
		is_secondary_processing = TRUE
	
	// EXPERT - Quaternary processing
	else if(src.reagents.has_reagent(/datum/reagent/herb_extract/vitriol, 30))
		extract_type = /datum/reagent/herb_extract/salt
		base_reagent_type = /datum/reagent/herb_extract/vitriol
		base_amount = src.reagents.get_reagent_amount(/datum/reagent/herb_extract/vitriol)
		skill_required = SKILL_LEVEL_EXPERT
		extract_name = "salt"
		is_secondary_processing = TRUE
	
	// If not secondary processing, check for primary extraction (requires herb)
	if(!is_secondary_processing)
		// Primary extraction requires exactly one herb
		if(herb_count != 1)
			return FALSE
		
		// NOVICE LEVEL - Primary extraction (90u base → extract)
		if(src.reagents.has_reagent(/datum/reagent/water, 90))
			extract_type = /datum/reagent/herb_extract/tonic
			base_reagent_type = /datum/reagent/water
			base_amount = src.reagents.get_reagent_amount(/datum/reagent/water)
			skill_required = SKILL_LEVEL_NOVICE
			extract_name = "tonic"
			
		else if(src.reagents.has_reagent(/datum/reagent/cooking_oil, 90))
			extract_type = /datum/reagent/herb_extract/oil
			base_reagent_type = /datum/reagent/cooking_oil
			base_amount = src.reagents.get_reagent_amount(/datum/reagent/cooking_oil)
			skill_required = SKILL_LEVEL_NOVICE
			extract_name = "oil"
			
		else if(src.reagents.has_reagent(/datum/reagent/consumable/ethanol/wine, 90))
			extract_type = /datum/reagent/herb_extract/elixir
			base_reagent_type = /datum/reagent/consumable/ethanol/wine
			base_amount = src.reagents.get_reagent_amount(/datum/reagent/consumable/ethanol/wine)
			skill_required = SKILL_LEVEL_NOVICE
			extract_name = "elixir"
		
		// AMATEUR LEVEL
		else if(src.reagents.has_reagent(/datum/reagent/rogueacid, 90))
			extract_type = /datum/reagent/herb_extract/vitriol
			base_reagent_type = /datum/reagent/rogueacid
			base_amount = src.reagents.get_reagent_amount(/datum/reagent/rogueacid)
			skill_required = SKILL_LEVEL_APPRENTICE
			extract_name = "vitriol"
		
		else
			return FALSE
	
	if(!extract_type)
		return FALSE
	
	// Check skill requirement
	if(skill_required > user_skill)
		brewing = 0
		src.visible_message(span_warning("The ingredients in the cauldron meld together into a disgusting mess! A more skilled alchemist is needed for this recipe."))
		if(reagents)
			src.reagents.remove_reagent(base_reagent_type, base_amount)
		for(var/obj/item/ing in src.ingredients)
			qdel(ing)
		src.reagents.add_reagent(/datum/reagent/yuck, base_amount)
		lastuser.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE)
		ingredients = list()
		brewing = 21
		return TRUE
	
	// Success! Create the herb extract
	var/output_amount = base_amount  // 1:1 conversion
	
	// Remove base reagent and any herbs
	if(reagents)
		src.reagents.remove_reagent(base_reagent_type, base_amount)
	for(var/obj/item/ing in src.ingredients)
		qdel(ing)
	
	// Add the extract reagent
	src.reagents.add_reagent(extract_type, output_amount)
	
	// For secondary processing, copy effects from the base extract
	if(is_secondary_processing)
		// Find the source extract and copy its effects to the new concentrated version
		var/datum/reagent/herb_extract/source_extract = null
		for(var/datum/reagent/R in src.reagents.reagent_list)
			if(istype(R, /datum/reagent/herb_extract))
				source_extract = R
				break
		
		if(source_extract)
			for(var/datum/reagent/herb_extract/R in src.reagents.reagent_list)
				if(R.type == extract_type)
					if(source_extract.alchemy_effects)
						R.set_alchemy_effects(source_extract.alchemy_effects.effects)
					if(source_extract.source_herb_name)
						R.source_herb_name = source_extract.source_herb_name
						R.source_herb_type = source_extract.source_herb_type
						R.name = "[source_extract.source_herb_name] [initial(R.name)]"
					break
		
		src.visible_message("<span class='info'>The cauldron finishes boiling, creating a more concentrated extract.</span>")
	else
		// Primary processing - copy alchemy effects from herb to the extract
		if(herb && herb.alchemy_effects && herb.alchemy_effects.len)
			for(var/datum/reagent/herb_extract/R in src.reagents.reagent_list)
				if(R.type == extract_type)
					R.set_alchemy_effects(herb.alchemy_effects)
					R.source_herb_name = herb.name
					R.source_herb_type = herb.type
					R.name = "[herb.name] [initial(R.name)]"
					break
		
		src.visible_message("<span class='info'>The cauldron finishes boiling, creating [herb.name] [extract_name].</span>")
	
	lastuser.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE)
	
	playsound(src, "bubbles", 100, TRUE)
	playsound(src,'sound/misc/smelter_fin.ogg', 30, FALSE)
	ingredients = list()
	brewing = 21
	
	return TRUE
