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
	var/maxingredients = 1  // Only one item can fit
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
/datum/reagents/proc/has_reagent_type(datum/reagent/reagent_type, amount)
	var/total = 0
	for (var/datum/reagent/R in reagent_list)
		if (istype(R, reagent_type))
			total += R.volume
			if (total >= amount)
				return TRUE
	return FALSE

/obj/machinery/light/rogue/cauldron/process()
	..()
	update_icon()
	if(on)
		var/can_brew = (length(ingredients) > 0) || (src.reagents && src.reagents.has_reagent_type(/datum/reagent/herb_extract, 60))

		if(can_brew)
			if(brewing < 20)
				if(src.reagents && (src.reagents.has_reagent_type(/datum/reagent/water, 90) || src.reagents.has_reagent_type(/datum/reagent/consumable/oil/tallow, 90) || src.reagents.has_reagent_type(/datum/reagent/consumable/ethanol, 90) || src.reagents.has_reagent_type(/datum/reagent/rogueacid, 90) || src.reagents.has_reagent_type(/datum/reagent/herb_extract, 60)))
					brewing++
					if(prob(10))
						playsound(src, "bubbles", 100, FALSE)

			else if(brewing == 20)
				if(try_kcd_herb_extraction())
					// probably also reset brewing on success so it doesn't re-fire every tick:
					brewing = 0
					return
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
	// JOURNEYMAN - Secondary processing: Tonic → Syrup, Oil → Paste
	if(src.reagents.has_reagent(/datum/reagent/herb_extract/tonic, 60))
		extract_type = /datum/reagent/herb_extract/syrup
		base_reagent_type = /datum/reagent/herb_extract/tonic
		base_amount = src.reagents.get_reagent_amount(/datum/reagent/herb_extract/tonic)
		skill_required = SKILL_LEVEL_JOURNEYMAN
		extract_name = "syrup"
		is_secondary_processing = TRUE
	
	else if(src.reagents.has_reagent(/datum/reagent/herb_extract/oil, 60))
		extract_type = /datum/reagent/herb_extract/paste
		base_reagent_type = /datum/reagent/herb_extract/oil
		base_amount = src.reagents.get_reagent_amount(/datum/reagent/herb_extract/oil)
		skill_required = SKILL_LEVEL_JOURNEYMAN
		extract_name = "paste"
		is_secondary_processing = TRUE
	
	// EXPERT - Tertiary processing: Bitters → Powder, Vitriol → Salt
	else if(src.reagents.has_reagent(/datum/reagent/herb_extract/bitters, 60))
		extract_type = /datum/reagent/herb_extract/powder
		base_reagent_type = /datum/reagent/herb_extract/bitters
		base_amount = src.reagents.get_reagent_amount(/datum/reagent/herb_extract/bitters)
		skill_required = SKILL_LEVEL_EXPERT
		extract_name = "powder"
		is_secondary_processing = TRUE
		
	else if(src.reagents.has_reagent(/datum/reagent/herb_extract/vitriol, 60))
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
			
		else if(src.reagents.has_reagent(/datum/reagent/consumable/oil/tallow, 90))
			extract_type = /datum/reagent/herb_extract/oil
			base_reagent_type = /datum/reagent/consumable/oil/tallow
			base_amount = src.reagents.get_reagent_amount(/datum/reagent/consumable/oil/tallow)
			skill_required = SKILL_LEVEL_NOVICE
			extract_name = "oil"
		
		// AMATEUR LEVEL - Wine and Acid
		else if(src.reagents.has_reagent(/datum/reagent/consumable/ethanol/wine, 90))
			extract_type = /datum/reagent/herb_extract/bitters
			base_reagent_type = /datum/reagent/consumable/ethanol/wine
			base_amount = src.reagents.get_reagent_amount(/datum/reagent/consumable/ethanol/wine)
			skill_required = SKILL_LEVEL_APPRENTICE
			extract_name = "bitters"
			
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
	var/output_amount = 0
	if(is_secondary_processing)
		output_amount = base_amount * 0.5  // 60u → 30u (1/2 conversion for secondary)
	else
		output_amount = base_amount * 0.667  // 90u → 60u (2/3 conversion for primary)
	
	// Remove base reagent and any herbs
	if(reagents)
		src.reagents.remove_reagent(base_reagent_type, base_amount)
	for(var/obj/item/ing in src.ingredients)
		qdel(ing)
	
	// Add the extract reagent
	src.reagents.add_reagent(extract_type, output_amount)
	
	// For secondary processing, UPGRADE effects to GREATER versions
	if(is_secondary_processing)
		var/list/source_effects = null
		var/source_herb = null
		var/source_type = null
		var/source_color = null
		var/source_smell = null
		var/source_taste = null
		var/source_alpha = null
		
		for(var/datum/reagent/R in src.reagents.reagent_list)
			if(istype(R, base_reagent_type))
				if(istype(R, /datum/reagent/herb_extract))
					var/datum/reagent/herb_extract/HE = R
					if(HE.alchemy_effects && HE.alchemy_effects.len)
						source_effects = HE.alchemy_effects.Copy()
					source_herb = HE.source_herb_name
					source_type = HE.source_herb_type
					source_color = HE.color
					source_smell = HE.smell_description
					source_taste = HE.taste_description
					source_alpha = HE.alpha
				break
		
		// Apply upgraded GREATER effects to the new concentrated extract
		if(source_effects && source_effects.len)
			for(var/datum/reagent/herb_extract/R in src.reagents.reagent_list)
				if(R.type == extract_type)
					// Upgrade to GREATER versions
					var/list/greater_effects = upgrade_effects_to_greater(source_effects)
					R.set_alchemy_effects(greater_effects)
					
					if(source_herb)
						R.source_herb_name = source_herb
						R.source_herb_type = source_type
						R.name = "[source_herb] [initial(R.name)]"
					
					// Transfer properties
					if(source_color)
						R.color = source_color
					if(source_smell)
						R.smell_description = source_smell
					if(source_taste)
						R.taste_description = source_taste
					if(isnum(source_alpha))
						R.alpha = source_alpha
					break
		
		src.visible_message("<span class='info'>The cauldron finishes boiling, creating a GREATER concentrated extract!</span>")
	else
		// Primary processing - select SPECIFIC effects based on extract type
		if(herb && herb.alchemy_effects && herb.alchemy_effects.len)
			for(var/datum/reagent/herb_extract/R in src.reagents.reagent_list)
				if(R.type == extract_type)
					var/list/selected_effects = list()
					
					// Select effects based on extract type:
					// Tonic (water) = effect #1
					// Oil = effect #2
					// Bitters (wine) = ALL effects
					// Vitriol (acid) = effect #4
					if(extract_type == /datum/reagent/herb_extract/tonic)
						// Take effect #1
						if(herb.alchemy_effects.len >= 1)
							selected_effects += herb.alchemy_effects[1]
					else if(extract_type == /datum/reagent/herb_extract/oil)
						// Take effect #2
						if(herb.alchemy_effects.len >= 2)
							selected_effects += herb.alchemy_effects[2]
					else if(extract_type == /datum/reagent/herb_extract/bitters)
						// Take ALL effects
						selected_effects = herb.alchemy_effects.Copy()
					else if(extract_type == /datum/reagent/herb_extract/vitriol)
						// Take effect #4
						if(herb.alchemy_effects.len >= 4)
							selected_effects += herb.alchemy_effects[4]
					
					R.set_alchemy_effects(selected_effects)
					R.source_herb_name = herb.name
					R.source_herb_type = herb.type
					R.name = "[herb.name] [initial(R.name)]"
					
					// Generate smell from selected effects
					var/list/smell_parts = list()
					for(var/effect in selected_effects)
						var/smell = get_effect_smell(effect)
						if(smell && !(smell in smell_parts))
							smell_parts += smell
					R.smell_description = smell_parts.Join(", ")
					
					// Set taste based on herb name
					R.taste_description = "[herb.name] and [initial(R.taste_description)]"
					break
		
		src.visible_message("<span class='info'>The cauldron finishes boiling, creating [herb.name] [extract_name].</span>")
	
	lastuser.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE)
	
	playsound(src, "bubbles", 100, TRUE)
	playsound(src,'sound/misc/smelter_fin.ogg', 30, FALSE)
	ingredients = list()
	brewing = 21
	
	return TRUE
