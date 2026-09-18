/obj/item/reagent_containers/glass/sauceboat/coastal_seasoning
	name = "spicy coastal seasoning"
	desc = "A weathered tin of imported seasoning. It smells salty, spicy, and faintly of citrus."
	icon = 'modular/mariocooking/sprites/seafood_seasoning_tin.dmi'
	icon_state = "seafood_seasoning_tin"
	volume = 30
	dropshrink = 0.5
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = list(1)
	list_reagents = list(/datum/reagent/consumable/sauce/cajun = 30)
	reagent_flags = DRAINABLE
	spillable = FALSE
	possible_item_intents = list(INTENT_POUR, INTENT_GENERIC)
	food_application_message = "You shake some spicy coastal seasoning over"

/obj/item/reagent_containers/glass/sauceboat/coastal_seasoning/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Use the feed intent on food to season it. The tin cannot be refilled.")
