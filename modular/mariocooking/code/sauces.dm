/datum/reagent/consumable/sauce
	name = "sauce"
	description = "A prepared condiment for food."
	nutriment_factor = 0
	taste_mult = 8
	/// Optional display name when this is the predominant sauce on pasta.
	var/pasta_name

/datum/reagent/consumable/sauce/reaction_mob(mob/living/eater, method = TOUCH, reac_volume)
	// The consumable preference handler accesses human-only variables.
	if(ishuman(eater))
		return ..()

/datum/reagent/consumable/sauce/tomato
	name = "Tomato Sauce"
	taste_description = "sweet, salted tomatoes"
	color = "#B84028"
	pasta_name = "Tomato Pasta"

/datum/reagent/consumable/sauce/garlick_butter
	name = "Garlick Butter"
	taste_description = "rich butter and fragrant garlick"
	color = "#E8C96B"
	pasta_name = "Garlick Butter Pasta"

/datum/reagent/consumable/sauce/cajun
	name = "Coastal Sauce"
	taste_description = "salty, lemony, tangy and seafoody"
	color = "#ffc272"

/datum/reagent/consumable/sauce/cajun_spicy
	name = "Spicy Coastal Sauce"
	taste_description = "salty, lemony, tangy and seafoody with a spicy kick"
	color = "#ff9c72"

/datum/reagent/consumable/sauce/gravy
	name = "Gravy"
	taste_description = "rich, savory meat gravy"
	color = "#805034"
	pasta_name = "Gravy Pasta"

/datum/reagent/consumable/sauce/ruined
	name = "Ruined Sauce"
	description = "An unsuccessful attempt at a sauce."
	taste_description = "burnt, disagreeable slop"
	color = "#615947"

/datum/reagent/consumable/sauce/secret
	name = "Secret Sauce"
	description = "An inexplicably wonderful sauce."
	taste_description = "something that tastes unimaginable"
	color = "#A377B5"
	pasta_name = "Secret Sauce Pasta"

/datum/reagent/consumable/sauce/secret/reaction_mob(mob/living/eater, method = TOUCH, reac_volume)
	. = ..()
	if(method != INGEST || reac_volume <= 0 || !iscarbon(eater))
		return
	if(!eater.has_stress_event(/datum/stressevent/secret_sauce))
		to_chat(eater, span_nicegreen("This sauce tastes unimaginable!"))
	eater.add_stress(/datum/stressevent/secret_sauce)

/datum/stressevent/secret_sauce
	stressadd = -8
	timer = 15 MINUTES
	desc = span_green("That Secret Sauce tastes unimaginable. I can still recall every extraordinary bite.")
