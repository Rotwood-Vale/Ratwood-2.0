// Powdered Produce Reagents
// Created when grinding produce in a mortar
// Each powder inherits alchemy effects from the source produce

// Base template for powdered produce
/datum/reagent/powdered_produce
	description = "A fine powder ground from produce."
	reagent_state = SOLID
	metabolization_rate = REAGENTS_METABOLISM
	color = "#d4c5a9"
	alpha = 200
	taste_description = "powder"

// Dynamic on_mob_life that applies effects based on alchemy_effects list
/datum/reagent/powdered_produce/on_mob_life(mob/living/carbon/M)
	if(!alchemy_effects || !alchemy_effects.len)
		..()
		return
	
	// Apply each effect (same logic as herb extracts)
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

// Individual powdered produce types
// These will be created dynamically based on what produce exists

/datum/reagent/powdered_produce/apple
	name = "powdered apple"
	description = "A fine powder ground from apples."
	color = "#ff4444"
	taste_description = "sweet apple powder"
	alchemy_effects = list(EFFECT_RESTORE_STAMINA, EFFECT_HEAL_BRUTE, EFFECT_FORTIFY_CONSTITUTION)

/datum/reagent/powdered_produce/pear
	name = "powdered pear"
	description = "A fine powder ground from pears."
	color = "#d4ff44"
	taste_description = "sweet pear powder"
	alchemy_effects = list(EFFECT_RESTORE_ENERGY, EFFECT_HEAL_BURN, EFFECT_FORTIFY_ENDURANCE)

/datum/reagent/powdered_produce/lemon
	name = "powdered lemon"
	description = "A fine powder ground from lemons."
	color = "#ffff44"
	taste_description = "sour lemon powder"
	alchemy_effects = list(EFFECT_HEAL_TOX, EFFECT_FORTIFY_PERCEPTION, EFFECT_RESTORE_STAMINA)

/datum/reagent/powdered_produce/lime
	name = "powdered lime"
	description = "A fine powder ground from limes."
	color = "#44ff44"
	taste_description = "tart lime powder"
	alchemy_effects = list(EFFECT_HEAL_TOX, EFFECT_RESTORE_ENERGY, EFFECT_FORTIFY_LUCK)

/datum/reagent/powdered_produce/tangerine
	name = "powdered tangerine"
	description = "A fine powder ground from tangerines."
	color = "#ff8844"
	taste_description = "citrus powder"
	alchemy_effects = list(EFFECT_RESTORE_STAMINA, EFFECT_FORTIFY_PERCEPTION, EFFECT_HEAL_BRUTE)

/datum/reagent/powdered_produce/plum
	name = "powdered plum"
	description = "A fine powder ground from plums."
	color = "#884488"
	taste_description = "sweet plum powder"
	alchemy_effects = list(EFFECT_RESTORE_BLOOD, EFFECT_HEAL_BURN, EFFECT_FORTIFY_CONSTITUTION)

/datum/reagent/powdered_produce/strawberry
	name = "powdered strawberry"
	description = "A fine powder ground from strawberries."
	color = "#ff4466"
	taste_description = "sweet strawberry powder"
	alchemy_effects = list(EFFECT_HEAL_BURN, EFFECT_RESTORE_STAMINA, EFFECT_FORTIFY_PERCEPTION)

/datum/reagent/powdered_produce/blackberry
	name = "powdered blackberry"
	description = "A fine powder ground from blackberries."
	color = "#441144"
	taste_description = "dark berry powder"
	alchemy_effects = list(EFFECT_RESTORE_BLOOD, EFFECT_HEAL_TOX, EFFECT_FORTIFY_ENDURANCE)

/datum/reagent/powdered_produce/raspberry
	name = "powdered raspberry"
	description = "A fine powder ground from raspberries."
	color = "#ff1144"
	taste_description = "tart raspberry powder"
	alchemy_effects = list(EFFECT_HEAL_BRUTE, EFFECT_RESTORE_STAMINA, EFFECT_FORTIFY_LUCK)

/datum/reagent/powdered_produce/tomato
	name = "powdered tomato"
	description = "A fine powder ground from tomatoes."
	color = "#ff3333"
	taste_description = "savory tomato powder"
	alchemy_effects = list(EFFECT_HEAL_BURN, EFFECT_RESTORE_BLOOD, EFFECT_FORTIFY_ENDURANCE)

/datum/reagent/powdered_produce/jacksberries
	name = "powdered jacksberries"
	description = "A fine powder ground from jacksberries."
	color = "#664488"
	taste_description = "wild berry powder"
	alchemy_effects = list(EFFECT_RESTORE_BLOOD, EFFECT_HEAL_TOX, EFFECT_FORTIFY_LUCK)

/datum/reagent/powdered_produce/rocknut
	name = "powdered rocknut"
	description = "A fine powder ground from rocknuts."
	color = "#8b7355"
	taste_description = "nutty powder"
	alchemy_effects = list(EFFECT_FORTIFY_STRENGTH, EFFECT_RESTORE_ENERGY, EFFECT_FORTIFY_ENDURANCE)

/datum/reagent/powdered_produce/cabbage
	name = "powdered cabbage"
	description = "A fine powder ground from cabbage."
	color = "#88ff88"
	taste_description = "vegetable powder"
	alchemy_effects = list(EFFECT_FORTIFY_ENDURANCE, EFFECT_HEAL_BRUTE, EFFECT_RESTORE_ENERGY)

/datum/reagent/powdered_produce/turnip
	name = "powdered turnip"
	description = "A fine powder ground from turnips."
	color = "#ddccaa"
	taste_description = "earthy turnip powder"
	alchemy_effects = list(EFFECT_RESTORE_STAMINA, EFFECT_FORTIFY_CONSTITUTION, EFFECT_HEAL_BRUTE)

/datum/reagent/powdered_produce/potato
	name = "powdered potato"
	description = "A fine powder ground from potatoes."
	color = "#ccaa88"
	taste_description = "starchy potato powder"
	alchemy_effects = list(EFFECT_FORTIFY_CONSTITUTION, EFFECT_RESTORE_STAMINA, EFFECT_FORTIFY_ENDURANCE)

/datum/reagent/powdered_produce/onion
	name = "powdered onion"
	description = "A fine powder ground from onions."
	color = "#ffddbb"
	taste_description = "pungent onion powder"
	alchemy_effects = list(EFFECT_FORTIFY_PERCEPTION, EFFECT_HEAL_TOX, EFFECT_RESTORE_BLOOD)

/datum/reagent/powdered_produce/wheat_grain
	name = "powdered wheat"
	description = "A fine powder ground from wheat grain."
	color = "#f0e68c"
	taste_description = "grain powder"
	alchemy_effects = list(EFFECT_RESTORE_ENERGY, EFFECT_RESTORE_STAMINA, EFFECT_FORTIFY_ENDURANCE)

/datum/reagent/powdered_produce/oat_grain
	name = "powdered oat"
	description = "A fine powder ground from oat grain."
	color = "#ccbb99"
	taste_description = "oat powder"
	alchemy_effects = list(EFFECT_RESTORE_STAMINA, EFFECT_FORTIFY_CONSTITUTION, EFFECT_RESTORE_ENERGY)

/datum/reagent/powdered_produce/rice_grain
	name = "powdered rice"
	description = "A fine powder ground from rice grain."
	color = "#f0f0f0"
	taste_description = "rice powder"
	alchemy_effects = list(EFFECT_RESTORE_ENERGY, EFFECT_FORTIFY_ENDURANCE, EFFECT_RESTORE_STAMINA)

/datum/reagent/powdered_produce/fyritius_flower
	name = "powdered fyritius"
	description = "A fine powder ground from fyritius flowers."
	color = "#ff0000"
	taste_description = "dangerous powder"
	alchemy_effects = list(EFFECT_POISON, EFFECT_DAMAGE_STAMINA, EFFECT_WEAKNESS)

/datum/reagent/powdered_produce/swampweed
	name = "powdered swampweed"
	description = "A fine powder ground from swampweed."
	color = "#446644"
	taste_description = "swampy powder"
	alchemy_effects = list(EFFECT_SLOW, EFFECT_WEAKNESS, EFFECT_DAMAGE_ENERGY)

/datum/reagent/powdered_produce/westleach_leaf
	name = "powdered westleach"
	description = "A fine powder ground from westleach leaves."
	color = "#88aa66"
	taste_description = "herbal tobacco powder"
	alchemy_effects = list(EFFECT_FORTIFY_PERCEPTION, EFFECT_RESTORE_STAMINA, EFFECT_FORTIFY_INTELLIGENCE)

/datum/reagent/powdered_produce/sunflower
	name = "powdered sunflower"
	description = "A fine powder ground from sunflowers."
	color = "#ffdd44"
	taste_description = "floral powder"
	alchemy_effects = list(EFFECT_FORTIFY_LUCK, EFFECT_RESTORE_ENERGY, EFFECT_FORTIFY_PERCEPTION)

/datum/reagent/powdered_produce/sugarcane
	name = "powdered sugarcane"
	description = "A fine powder ground from sugarcane."
	color = "#eeddcc"
	taste_description = "sweet powder"
	alchemy_effects = list(EFFECT_RESTORE_ENERGY, EFFECT_RESTORE_STAMINA, EFFECT_FORTIFY_SPEED)
