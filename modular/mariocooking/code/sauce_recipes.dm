// Reuse Ratwood's exact item/reagent recipe matcher. Ingredients stay as items:
// salt and flour both contain /datum/reagent/floure and cannot be told apart chemically.
/datum/recipe/sauce
	abstract_type = /datum/recipe/sauce
	time = 30 SECONDS
	var/output_amount = 60

/datum/recipe/sauce/tomato
	items = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/tomato,
		/obj/item/reagent_containers/powder/salt,
		/obj/item/reagent_containers/food/snacks/sugar,
	)
	result = /datum/reagent/consumable/sauce/tomato

/datum/recipe/sauce/garlick_butter
	items = list(
		/obj/item/reagent_containers/food/snacks/butterslice,
		/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove,
		/obj/item/reagent_containers/powder/salt,
	)
	result = /datum/reagent/consumable/sauce/garlick_butter

/datum/recipe/sauce/gravy
	items = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince,
		/obj/item/reagent_containers/powder/flour,
		/obj/item/reagent_containers/powder/salt,
	)
	reagents_list = list(/datum/reagent/water = 10)
	result = /datum/reagent/consumable/sauce/gravy

/datum/recipe/sauce/secret
	result = /datum/reagent/consumable/sauce/secret

/datum/recipe/sauce/secret/New()
	. = ..()
	// Ten ingredients, three unique picks, at least one strange (100+ combinations).
	// No recipe-book registration: the round's selection is deliberately hidden.
	// Originally, I actually wanted to include droopings here, but I am pretty sure that will pref-break people. 
	var/list/pool = list(
		/obj/item/reagent_containers/food/snacks/pepper,
		/obj/item/reagent_containers/food/snacks/allspice,
		/obj/item/reagent_containers/food/snacks/sugar,
		/obj/item/reagent_containers/powder/salt,
		/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove,
		/obj/item/reagent_containers/food/snacks/butterslice,
		/obj/item/reagent_containers/food/snacks/grown/rogue/poppy,
		/obj/item/reagent_containers/food/snacks/rogue/meat_rotten,
		/obj/item/organ/brain,
		/obj/item/organ/eyes,
	)
	items = list()
	// Guarantee a strange ingredient, and avoid collisions with ordinary sauces.
	var/list/strange = pool.Copy(7)
	var/first = pick(strange)
	items += first
	pool -= first
	while(length(items) < 3)
		var/ingredient = pick(pool)
		items += ingredient
		pool -= ingredient

/datum/controller/subsystem/cooking/proc/init_sauce_recipes()
	// Subsystem initialization runs once per round. Guard against accidental rerolls.
	if(length(sauce_recipes))
		return
	for(var/path in subtypesof(/datum/recipe/sauce))
		if(is_abstract(path))
			continue
		sauce_recipes += new path()
