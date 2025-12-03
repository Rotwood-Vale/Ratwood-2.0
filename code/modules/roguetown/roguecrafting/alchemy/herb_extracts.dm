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
		switch(effect)
			if(EFFECT_HEAL_BRUTE)
				M.adjustBruteLoss(-0.5*REM, 0)
			if(EFFECT_HEAL_BURN)
				M.adjustFireLoss(-0.5*REM, 0)
			if(EFFECT_HEAL_TOX)
				M.adjustToxLoss(-0.5*REM, 0)
			if(EFFECT_RESTORE_STAMINA)
				if(volume > 0.99)
					M.stamina_add(-5)
			if(EFFECT_RESTORE_ENERGY)
				if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
					M.energy_add(5)
			if(EFFECT_RESTORE_BLOOD)
				if(M.blood_volume < BLOOD_VOLUME_NORMAL)
					M.blood_volume = min(M.blood_volume+3, BLOOD_VOLUME_NORMAL)
			if(EFFECT_FORTIFY_STRENGTH)
				M.add_stress(/datum/stressevent/buff_strength)
			if(EFFECT_FORTIFY_PERCEPTION)
				M.add_stress(/datum/stressevent/buff_perception)
			if(EFFECT_FORTIFY_INTELLIGENCE)
				M.add_stress(/datum/stressevent/buff_intelligence)
			if(EFFECT_FORTIFY_CONSTITUTION)
				M.add_stress(/datum/stressevent/buff_constitution)
			if(EFFECT_FORTIFY_ENDURANCE)
				M.add_stress(/datum/stressevent/buff_endurance)
			if(EFFECT_FORTIFY_SPEED)
				M.add_stress(/datum/stressevent/buff_speed)
			if(EFFECT_FORTIFY_LUCK)
				M.add_stress(/datum/stressevent/buff_fortune)
			if(EFFECT_PARALYZE)
				if(prob(5))
					M.Paralyze(20)
			if(EFFECT_POISON)
				M.adjustToxLoss(0.5*REM, 0)
			if(EFFECT_DAMAGE_STAMINA)
				if(volume > 0.99)
					M.stamina_add(5)
			if(EFFECT_DAMAGE_ENERGY)
				if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
					M.energy_add(-5)
			if(EFFECT_WEAKNESS)
				M.add_stress(/datum/stressevent/debuff_weakness)
			if(EFFECT_SLOW)
				M.add_movespeed_modifier(MOVESPEED_ID_REAGENT, TRUE, 100, override = TRUE, multiplicative_slowdown = 0.5)
			if(EFFECT_BLINDNESS)
				if(prob(5))
					M.blind_eyes(2)
			if(EFFECT_SILENCE)
				if(prob(5))
					M.silent = max(M.silent, 20)
	
	..()
	. = 1

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

// AMATEUR LEVEL - Secondary processing (boiling extracts again)

// Herb Concentrate (from Herb Tonic)
/datum/reagent/herb_extract/concentrate
	name = "herbal concentrate"
	color = "#4a6a6d"
	taste_description = "concentrated herbs"
	alpha = 200
	description = "A concentrated extract made by repeatedly boiling an herbal tonic."

// JOURNEYMAN LEVEL - Tertiary processing

// Herb Paste (from Oil of Herb)
/datum/reagent/herb_extract/paste
	name = "herbal paste"
	color = "#8b7355"
	taste_description = "thick herbs"
	alpha = 220
	description = "A thick paste made by reducing herbal oil."

// Herb Syrup (from Herb Elixir)
/datum/reagent/herb_extract/syrup
	name = "herbal syrup"
	color = "#6a0808"
	taste_description = "thick sweet herbs"
	alpha = 210
	description = "A thick syrup made by reducing herbal elixir."

// EXPERT LEVEL - Quaternary processing

// Herb Salt (from Vitriol of Herb)
/datum/reagent/herb_extract/salt
	name = "herbal salt"
	color = "#3fff00"
	taste_description = "caustic herbal crystals"
	alpha = 240
	description = "Crystallized salts infused with herbal essence."

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
