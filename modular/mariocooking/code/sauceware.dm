/obj/item/reagent_containers/glass/bucket/pot/saucepan
	name = "saucepan"
	desc = "An iron pan for simmering ingredients into sauces. Use it in hand to begin or cancel a batch, then heat it on a hearth."
	icon = 'modular/mariocooking/sprites/mfood_default.dmi'
	icon_state = "saucepan"
	volume = 60
	w_class = WEIGHT_CLASS_NORMAL
	var/simmering = FALSE
	var/cook_progress = 0

/obj/item/reagent_containers/glass/bucket/pot/saucepan/update_icon()
	// The supplied vessel sprite is shared by every sauce; no pot filling states.
	return

/obj/item/reagent_containers/glass/bucket/pot/saucepan/examine(mob/user)
	. = ..()
	if(length(contents))
		. += span_notice("Ingredients: [english_list(contents)].")
	if(simmering)
		. += span_notice("This batch is ready to simmer on a lit hearth.")

/obj/item/reagent_containers/glass/bucket/pot/saucepan/get_mechanics_examine(mob/user)
	// The ordinary pot's single-ingredient stew instructions do not apply here.
	. = list()
	. += span_info("Add whole ingredient items, then use the saucepan in hand to begin a batch. Place it on a lit hearth to simmer. Fanning the hearth speeds cooking. Use the pan in hand again to cancel and recover its ingredients.")
	. += span_info("Tomato sauce: one tomato, one salt, one sugar. Garlick butter: one butter slice, one garlick clove, one salt. Gravy: one mince, one flour, one salt, and exactly 10 units of water. Extra or missing ingredients ruin a batch.")
	. += span_info("Finished sauce can be poured into a sauceboat using the ordinary feed/fill intents. Empty the saucepan before preparing another batch.")

/obj/item/reagent_containers/glass/bucket/pot/saucepan/attackby(obj/item/I, mob/user, params)
	if(simmering)
		to_chat(user, span_warning("Cancel the batch before changing its ingredients."))
		return TRUE
	if(istype(I, /obj/item/reagent_containers/food/snacks) || istype(I, /obj/item/reagent_containers/powder) || istype(I, /obj/item/organ))
		if(length(contents) >= 6)
			to_chat(user, span_warning("There is no room for more ingredients."))
			return TRUE
		for(var/datum/reagent/consumable/sauce/sauce in reagents.reagent_list)
			to_chat(user, span_warning("Empty the finished sauce first."))
			return TRUE
		if(user.transferItemToLoc(I, src))
			to_chat(user, span_notice("You add [I] to [src]."))
		return TRUE
	if(istype(I, /obj/item/reagent_containers/glass))
		I.attack_obj(src, user)
		return TRUE
	return ..()

/obj/item/reagent_containers/glass/bucket/pot/saucepan/attack_self(mob/user)
	if(simmering)
		simmering = FALSE
		cook_progress = 0
		for(var/obj/item/ingredient in contents)
			ingredient.forceMove(get_turf(user))
		to_chat(user, span_notice("You cancel the batch and empty out its ingredients."))
		return
	if(!length(contents))
		to_chat(user, span_warning("Add ingredients first."))
		return
	simmering = TRUE
	cook_progress = 0
	to_chat(user, span_notice("You stir the ingredients together. The batch is ready to simmer on a hearth."))

/obj/item/reagent_containers/glass/bucket/pot/saucepan/cooking(input)
	if(!simmering || reagents.chem_temp < MIN_STEW_TEMPERATURE)
		return
	var/datum/recipe/sauce/recipe = select_recipe(SScooking.sauce_recipes, src)
	var/cook_time = recipe ? recipe.time : 30 SECONDS
	cook_progress += input
	if(cook_progress < cook_time)
		return
	var/output = recipe ? recipe.result : /datum/reagent/consumable/sauce/ruined
	var/amount = recipe ? recipe.output_amount : 60
	// Like stews, ingredients are converted into the result, not extra chemicals.
	for(var/obj/item/ingredient in contents)
		qdel(ingredient)
	reagents.clear_reagents()
	reagents.add_reagent(output, amount)
	simmering = FALSE
	cook_progress = 0
	playsound(src, "bubbles", 30, TRUE)
	visible_message(span_notice("[src] finishes simmering."))

/obj/item/reagent_containers/glass/bucket/pot/saucepan/Destroy()
	for(var/obj/item/ingredient in contents)
		ingredient.forceMove(get_turf(src))
	return ..()

/obj/item/reagent_containers/glass/sauceboat
	name = "sauceboat"
	desc = "An iron vessel for serving sauce. Fill it from a saucepan, then use the feed intent on food to dress it."
	icon = 'modular/mariocooking/sprites/mfood_default.dmi'
	icon_state = "sauceboat"
	experimental_inhand = TRUE
	volume = 60
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5)
	possible_item_intents = list(INTENT_POUR, INTENT_FILL, INTENT_GENERIC)

/obj/item/reagent_containers/glass/sauceboat/pre_attack(atom/target, mob/living/user, params)
	if(..())
		return TRUE
	// Snacks generally lack CAN_BE_HIT, and many have their own recipe attackby.
	if(user.used_intent.type == INTENT_POUR && istype(target, /obj/item/reagent_containers/food/snacks))
		attack_obj(target, user)
		return TRUE
	return FALSE

/obj/item/reagent_containers/glass/sauceboat/attack_obj(obj/target, mob/living/user)
	if(user.used_intent.type == INTENT_POUR && istype(target, /obj/item/reagent_containers/food/snacks))
		if(!is_drainable())
			return
		if(!reagents.total_volume)
			to_chat(user, span_warning("[src] is empty!"))
			return
		var/has_sauce = FALSE
		for(var/datum/reagent/consumable/sauce/sauce in reagents.reagent_list)
			has_sauce = TRUE
			break
		if(!has_sauce)
			to_chat(user, span_warning("There is no prepared sauce in [src]."))
			return
		if(target.reagents.holder_full())
			to_chat(user, span_warning("[target] cannot hold any more sauce."))
			return
		// Transfer the mixture, including any additives, through normal food ingestion.
		if(reagents.trans_to(target, amount_per_transfer_from_this, transfered_by = user))
			to_chat(user, span_notice("You spoon some sauce over [target]."))
		return
	// Only refill/drain real vessels. Do not coat arbitrary reagent-bearing objects.
	if(istype(target, /obj/item/reagent_containers/glass) || user.used_intent.type == INTENT_GENERIC)
		return ..()

/datum/anvil_recipe/tools/iron/saucepan
	name = "Saucepan"
	created_item = /obj/item/reagent_containers/glass/bucket/pot/saucepan
	display_category = ITEM_CAT_TOOLS_COOKWARE

/datum/anvil_recipe/tools/iron/sauceboat
	name = "Sauceboat"
	created_item = /obj/item/reagent_containers/glass/sauceboat
	display_category = ITEM_CAT_TOOLS_COOKWARE
