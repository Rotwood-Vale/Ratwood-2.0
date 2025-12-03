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
