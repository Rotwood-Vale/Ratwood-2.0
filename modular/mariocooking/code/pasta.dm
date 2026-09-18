/obj/item/reagent_containers/food/snacks/rogue/pasta
	name = "raw pasta"
	desc = "Freshly cut noodles. Boil them in a pot of water."
	icon = 'modular/mariocooking/sprites/mfood_default.dmi'
	icon_state = "pasta_raw"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	tastes = list("raw dough" = 1)
	eat_effect = /datum/status_effect/debuff/uncookedfood
	boiled_type = /obj/item/reagent_containers/food/snacks/rogue/pasta/cooked
	rotprocess = SHELFLIFE_DECENT
	w_class = WEIGHT_CLASS_NORMAL

// Pasta has no filling icon; ordinary slicing/cooking calls this hook.
/obj/item/reagent_containers/food/snacks/rogue/pasta/update_snack_overlays(obj/item/reagent_containers/food/snacks/source)
	update_icon()

/obj/item/reagent_containers/food/snacks/rogue/pasta/cooked
	name = "pasta"
	desc = "Tender boiled noodles, ready for a sauce."
	icon_state = "pasta_cooked"
	tastes = list("noodles" = 1)
	eat_effect = null
	boiled_type = null
	cooktime = 0
	faretype = FARE_POOR
	var/mutable_appearance/sauce_overlay

/obj/item/reagent_containers/food/snacks/rogue/pasta/cooked/update_icon()
	. = ..()
	if(sauce_overlay)
		cut_overlay(sauce_overlay)
		sauce_overlay = null
	var/datum/reagent/consumable/sauce/dominant
	for(var/datum/reagent/consumable/sauce/sauce in reagents?.reagent_list)
		if(!sauce.pasta_name)
			continue
		// Equal quantities keep the first sauce in the holder's stable order.
		if(!dominant || sauce.volume > dominant.volume)
			dominant = sauce
	name = dominant ? dominant.pasta_name : initial(name)
	if(eat_effect == /datum/status_effect/debuff/rotfood)
		name = "rotten [name]"
	if(dominant)
		sauce_overlay = mutable_appearance(icon, "pasta_sauce")
		sauce_overlay.color = dominant.color
		add_overlay(sauce_overlay)
