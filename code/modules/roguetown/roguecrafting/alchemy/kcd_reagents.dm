// KCD-Style Alchemy Reagents
// Template-based reagents that copy properties from herbs

// Constants for KCD alchemy
#define KCD_MIN_BASE_REAGENT_AMOUNT 30 // Minimum amount of base reagent needed for processing
#define KCD_MIN_SECONDARY_REAGENT_AMOUNT 30 // Minimum amount needed for secondary processing
#define KCD_REAGENT_OUTPUT_RATIO 0.33 // Output ratio: 30u input -> 10u output (33%)
#define ALCHEMY_MIN_VOLUME_THRESHOLD 0.99 // Minimum volume for reagent effects to trigger

// Base template reagent for all KCD-style alchemical products
/datum/reagent/alch_template
	description = "An alchemical preparation."
	reagent_state = LIQUID
	metabolization_rate = REAGENTS_METABOLISM
	// Properties that will be copied from source herb
	var/source_herb_type = null
	var/source_herb_name = ""
	
// NOVICE LEVEL RECIPES

// Water + Herb = Herb Tonic
/datum/reagent/alch_template/tonic
	name = "herbal tonic"
	description = "A tonic made by boiling herbs in water."
	color = "#6a9295"
	taste_description = "watery herbs"
	alpha = 150

/datum/reagent/alch_template/tonic/on_mob_life(mob/living/carbon/M)
	// Mild healing effect
	if(volume > ALCHEMY_MIN_VOLUME_THRESHOLD)
		M.adjustBruteLoss(-0.5*REM, 0)
		M.adjustFireLoss(-0.5*REM, 0)
	..()

// Oil + Herb = Oil of Herb (we'll need to create an oil reagent)
/datum/reagent/cooking_oil
	name = "Cooking Oil"
	description = "An oil extracted from plants, useful for cooking and alchemy."
	reagent_state = LIQUID
	color = "#d4af37"
	taste_description = "oil"
	alpha = 200

/datum/reagent/alch_template/oil_extract
	name = "herbal oil"
	description = "An oil infused with herbs."
	color = "#d4af37"
	taste_description = "oily herbs"
	alpha = 180

/datum/reagent/alch_template/oil_extract/on_mob_life(mob/living/carbon/M)
	// Mild stamina restoration
	if(volume > ALCHEMY_MIN_VOLUME_THRESHOLD)
		M.stamina_add(-5)
	..()

// Wine + Herb = Herb Elixir  
/datum/reagent/alch_template/elixir
	name = "herbal elixir"
	description = "An elixir made by steeping herbs in wine."
	color = "#8a0b0b"
	taste_description = "sweet herbs and wine"
	alpha = 170

/datum/reagent/alch_template/elixir/on_mob_life(mob/living/carbon/M)
	// Mild energy restoration
	if(!HAS_TRAIT(M, TRAIT_INFINITE_STAMINA))
		M.energy_add(5)
	..()

// AMATEUR LEVEL RECIPES

// Spirits + Herb = Herb Bitters
/datum/reagent/alch_template/bitters
	name = "herbal bitters"
	description = "A bitter preparation made by steeping herbs in strong spirits."
	color = "#5f3b23"
	taste_description = "bitter herbs and alcohol"
	alpha = 180

/datum/reagent/alch_template/bitters/on_mob_life(mob/living/carbon/M)
	// Moderate healing
	if(volume > ALCHEMY_MIN_VOLUME_THRESHOLD)
		M.adjustBruteLoss(-1*REM, 0)
		M.adjustFireLoss(-1*REM, 0)
	..()

// Acid + Herb = Vitriol of Herb
/datum/reagent/alch_template/vitriol
	name = "herbal vitriol"
	description = "A caustic extract made by dissolving herbs in acid."
	color = "#5eff00"
	taste_description = "burning herbs"
	alpha = 160

/datum/reagent/alch_template/vitriol/on_mob_life(mob/living/carbon/M)
	// Potent but risky - heals but also damages
	if(volume > ALCHEMY_MIN_VOLUME_THRESHOLD)
		M.adjustBruteLoss(-2*REM, 0)
		M.adjustToxLoss(0.5*REM, 0)
	..()

// Herb Tonic + Boil Again = Herb Concentrate
/datum/reagent/alch_template/concentrate
	name = "herbal concentrate"
	description = "A concentrated tonic made by repeatedly boiling herbs."
	color = "#4a6a6d"
	taste_description = "concentrated herbs"
	alpha = 200

/datum/reagent/alch_template/concentrate/on_mob_life(mob/living/carbon/M)
	// Stronger healing than tonic
	if(volume > ALCHEMY_MIN_VOLUME_THRESHOLD)
		M.adjustBruteLoss(-1.5*REM, 0)
		M.adjustFireLoss(-1.5*REM, 0)
		M.adjustOxyLoss(-1*REM, 0)
	..()

// JOURNEYMAN LEVEL RECIPES

// Oil of Herb + Boil Again = Herb Paste
/datum/reagent/alch_template/paste
	name = "herbal paste"
	description = "A thick paste made by reducing herbal oil."
	color = "#8b7355"
	taste_description = "thick herbs"
	alpha = 220

/datum/reagent/alch_template/paste/on_mob_life(mob/living/carbon/M)
	// Strong stamina restoration
	if(volume > ALCHEMY_MIN_VOLUME_THRESHOLD)
		M.stamina_add(-15)
	..()

// Herb Elixir + Boil Again = Herb Syrup
/datum/reagent/alch_template/syrup
	name = "herbal syrup"
	description = "A thick syrup made by reducing herbal elixir."
	color = "#6a0808"
	taste_description = "thick sweet herbs"
	alpha = 210

/datum/reagent/alch_template/syrup/on_mob_life(mob/living/carbon/M)
	// Strong energy restoration
	if(!HAS_TRAIT(M, TRAIT_INFINITE_STAMINA))
		M.energy_add(15)
	..()

// Herb Bitters + Boil Again = Herb Powder
/datum/reagent/alch_template/powder_extract
	name = "herbal powder extract"
	description = "A powerful extract made by reducing herbal bitters to powder consistency."
	color = "#3f2617"
	taste_description = "intensely bitter herbs"
	alpha = 230

/datum/reagent/alch_template/powder_extract/on_mob_life(mob/living/carbon/M)
	// Very strong healing
	if(volume > ALCHEMY_MIN_VOLUME_THRESHOLD)
		M.adjustBruteLoss(-2.5*REM, 0)
		M.adjustFireLoss(-2.5*REM, 0)
		M.adjustOxyLoss(-1.5*REM, 0)
	..()

// EXPERT LEVEL RECIPES

// Vitriol of Herb + Boil Again = Herb Salt
/datum/reagent/alch_template/salt_extract
	name = "herbal salt"
	description = "Crystallized salts infused with herbal essence, made by evaporating vitriol."
	color = "#3fff00"
	taste_description = "caustic herbal crystals"
	alpha = 240

/datum/reagent/alch_template/salt_extract/on_mob_life(mob/living/carbon/M)
	// Most potent but most risky
	if(volume > ALCHEMY_MIN_VOLUME_THRESHOLD)
		M.adjustBruteLoss(-3.5*REM, 0)
		M.adjustFireLoss(-3.5*REM, 0)
		M.adjustOxyLoss(-2*REM, 0)
		M.adjustToxLoss(1*REM, 0)
	..()
