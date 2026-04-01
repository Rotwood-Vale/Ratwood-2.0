// chocolate. Maybe sweets. 
/obj/item/reagent_containers/food/snacks/rogue/chocolate
	name = "dark chocolate bar"
	icon = 'modular/Neu_Food/icons/others/chocolate.dmi'
	icon_state = "chocolate_d"
	desc = "A bar of dark chocolate. Bitter, but still delicious."
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_EXTREME
	foodtype = SUGAR 
	tastes = list("bitterness" = 1,)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 6 
	eat_effect = /datum/status_effect/buff/snackbuff
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)

/obj/item/reagent_containers/food/snacks/rogue/chocolate_milk
	name = "milk chocolate bar"
	icon = 'modular/Neu_Food/icons/others/chocolate.dmi'
	icon_state = "chocolate_l"
	desc = "A bar of milk chocolate. Sweet and delicious."
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_EXTREME
	foodtype = SUGAR | DAIRY
	tastes = list("sweetness" = 2)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 6
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)

/obj/item/reagent_containers/food/snacks/rogue/chocolate_raisin
	name = "raisin chocolate bar"
	icon = 'modular/Neu_Food/icons/others/chocolate.dmi'
	icon_state = "chocolate_r"
	desc = "A bar of chocolate with raisins. Sweet and chewy."
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_EXTREME
	foodtype = SUGAR | FRUIT 
	tastes = list("sweetness" = 2, "tartness" = 1)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 6
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)

/obj/item/reagent_containers/food/snacks/rogue/chocolate_honeynut
	name = "honey nut chocolate bar"
	icon = 'modular/Neu_Food/icons/others/chocolate.dmi'
	icon_state = "chocolate_h"
	desc = "A glorious bar of milk chocolate mixed with honey and rocknut, crafted with utmost care by Malumite Chocolatemaker Guilds of mountainous regions of Grenzelhoft. Snack worthy of a King, or a Grand Duke."
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_EXTREME
	foodtype = SUGAR | DAIRY 
	tastes = list("sweetness" = 2, "nuttiness" = 1)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 6
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	list_reagents = list(/datum/reagent/consumable/honey = 2, /datum/reagent/consumable/nutriment = SNACK_DECENT)
