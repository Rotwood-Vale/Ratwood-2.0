// KCD-Style Intermediate Reagents
// These are created when boiling herbs with base reagents
// They carry the herb's alchemy effects and can be mixed to create potions

// Base template for herb extracts
/datum/reagent/herb_extract
	description = "An extract made from boiling herbs."
	reagent_state = LIQUID
	metabolization_rate = REAGENTS_METABOLISM
	var/source_herb_name = ""
	var/source_herb_type = null

// Water-based extracts (Herb Tonic)
/datum/reagent/herb_extract/tonic
	name = "herbal tonic"
	color = "#6a9295"
	taste_description = "watery herbs"
	alpha = 150

// Oil-based extracts (Oil of Herb)
/datum/reagent/herb_extract/oil
	name = "herbal oil"
	color = "#d4af37"
	taste_description = "oily herbs"
	alpha = 180

// Wine-based extracts (Herb Elixir)
/datum/reagent/herb_extract/elixir
	name = "herbal elixir"
	color = "#8a0b0b"
	taste_description = "sweet herbs and wine"
	alpha = 170

// Spirits-based extracts (Herb Bitters) - Currently disabled, wine is used for all alcohols
/*
/datum/reagent/herb_extract/bitters
	name = "herbal bitters"
	color = "#5f3b23"
	taste_description = "bitter herbs and alcohol"
	alpha = 180
*/

// Acid-based extracts (Vitriol of Herb)
/datum/reagent/herb_extract/vitriol
	name = "herbal vitriol"
	color = "#5eff00"
	taste_description = "caustic herbs"
	alpha = 160

// Cooking oil reagent for alchemy
/datum/reagent/cooking_oil
	name = "Cooking Oil"
	description = "An oil extracted from plants, useful for cooking and alchemy."
	reagent_state = LIQUID
	color = "#d4af37"
	taste_description = "oil"
	alpha = 200

// Helper proc to create herb extract with copied effects
/proc/create_herb_extract(extract_type, herb_item, base_amount = 30)
	var/datum/reagent/herb_extract/extract = new extract_type()
	
	// Copy herb name
	if(istype(herb_item, /obj/item/alch))
		extract.source_herb_type = herb_item.type
		extract.source_herb_name = herb_item.name
		extract.name = "[herb_item.name] [initial(extract.name)]"
		
		// Copy alchemy effects from herb if it has them
		// This will be set up when herbs are initialized with their effects
	
	return extract
