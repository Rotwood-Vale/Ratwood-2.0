/datum/brewing_recipe/golden_calendula_tea
	name = "金盏花茶"
	category = "茶饮"
	bottle_name = "金盏花茶"
	bottle_desc = "一瓶本地煮制的金盏花茶。带有草本风味。"
	reagent_to_brew = /datum/reagent/consumable/golden_calendula_tea
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/alch/calendula = 1, /obj/item/alch/mentha = 1, /obj/item/reagent_containers/food/snacks/rogue/honey = 1)
	brewed_amount = 6
	brew_time = 4 MINUTES
	sell_value = 60
	heat_required = 320

/datum/brewing_recipe/soothing_valerian_tea
	name = "舒缓缬草茶"
	category = "茶饮"
	bottle_name = "舒缓缬草茶"
	bottle_desc = "一瓶本地煮制的舒缓缬草茶。带有草本风味。"
	reagent_to_brew = /datum/reagent/consumable/soothing_valerian_tea
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/alch/valeriana = 1, /obj/item/alch/hypericum = 1, /obj/item/reagent_containers/food/snacks/rogue/honey = 1)
	brewed_amount = 6
	brew_time = 4 MINUTES
	sell_value = 60
	heat_required = 310
