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

// Dynamic on_mob_life that applies effects based on alchemy_effects list
/datum/reagent/herb_extract/on_mob_life(mob/living/carbon/M)
	if(!alchemy_effects || !alchemy_effects.len)
		..()
		return
	
	// Apply each effect
	for(var/effect in alchemy_effects)
		if(volume > 0.99)
			switch(effect)
				if(EFFECT_HEAL_BRUTE)
					M.adjustBruteLoss(-0.5*REM, 0)
				if(EFFECT_HEAL_BURN)
					M.adjustFireLoss(-0.5*REM, 0)
				if(EFFECT_HEAL_TOX)
					M.adjustToxLoss(-0.5*REM, 0)
				if(EFFECT_RESTORE_STAMINA)
					M.stamina_add(-5)
				if(EFFECT_RESTORE_MANA)
					M.energy_add(5)
	
	..()
	. = 1

// Water
/datum/reagent/herb_extract/tonic
	name = "herbal tonic"
	color = "#6a9295"
	taste_description = "watery herbs"
	alpha = 150

// Oil
/datum/reagent/herb_extract/oil
	name = "herbal oil"
	color = "#d4af37"
	taste_description = "oily herbs"
	alpha = 180

// Wine
/datum/reagent/herb_extract/bitters
	name = "herbal bitters"
	color = "#8a0b0b"
	taste_description = "bitter herbs and wine"
	alpha = 170

// Acid
/datum/reagent/herb_extract/vitriol
	name = "herbal vitriol"
	color = "#5eff00"
	taste_description = "caustic herbs"
	alpha = 160

// Water2
/datum/reagent/herb_extract/syrup
	name = "herbal syrup"
	color = "#4a7a7d"
	taste_description = "sweet herbal syrup"
	alpha = 200

// Oil2
/datum/reagent/herb_extract/paste
	name = "herbal paste"
	color = "#a38728"
	taste_description = "thick herbal paste"
	alpha = 220

// Wine2
/datum/reagent/herb_extract/powder
	name = "herbal powder"
	color = "#6a3a1a"
	taste_description = "powdered herbs"
	alpha = 240
	reagent_state = SOLID

// Acid2
/datum/reagent/herb_extract/salt
	name = "herbal salt"
	color = "#e0e0e0"
	taste_description = "crystalline herbal salt"
	alpha = 250
	reagent_state = SOLID

// Helper proc to create herb extract with copied effects
/proc/create_herb_extract(extract_type, obj/item/ingr, base_amount = 30)
	var/datum/reagent/herb_extract/extract = new extract_type()
	
	// Copy herb name
	if(istype(ingr, /obj/item))
		extract.source_herb_type = ingr.type
		extract.source_herb_name = ingr.name
		extract.name = "[ingr.name] [initial(extract.name)]"
	
	return extract
