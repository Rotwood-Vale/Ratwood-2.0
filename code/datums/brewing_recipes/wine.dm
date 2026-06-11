/datum/brewing_recipe/jack_wine
	name = "葡萄酒，杰克莓"
	category = "水果"
	bottle_name = "杰克莓酒"
	bottle_desc = "一瓶本地酿制的杰克莓酒。口感香甜果香浓郁，并带着一丝酸意。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/jackberrywine
	needed_reagents = list(/datum/reagent/water = 198)
	needed_crops = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 6)
	brewed_amount = 6
	brew_time = 5 MINUTES // Wine will have a standard brew time of 5 minutes
	sell_value = 50

	ages = TRUE
	age_times = list(
		/datum/reagent/consumable/ethanol/jackberrywine/aged = 10 MINUTES,
		/datum/reagent/consumable/ethanol/jackberrywine/delectable = 20 MINUTES
	)

/datum/brewing_recipe/plum_wine
	name = "葡萄酒，Umeshu（李子）"
	category = "水果"
	bottle_name = "umeshu 酒"
	bottle_desc = "一瓶本地酿制的李子酒。口感香甜，略带酸味。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/plum_wine
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/fruit/plum = 4, /obj/item/reagent_containers/food/snacks/sugar = 2)
	brewed_amount = 6
	brew_time = 5 MINUTES
	sell_value = 50

	ages = TRUE
	age_times = list(
		/datum/reagent/consumable/ethanol/plum_wine/aged = 10 MINUTES,
		/datum/reagent/consumable/ethanol/plum_wine/delectable = 20 MINUTES
	)

/datum/brewing_recipe/tangerine_wine
	name = "葡萄酒，橘子"
	category = "水果"
	bottle_name = "橘子酒"
	bottle_desc = "一瓶本地酿制的橘子酒。口感酸甜微苦，带着鲜明的柑橘风味。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/tangerine
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine = 4, /obj/item/reagent_containers/food/snacks/sugar = 2)
	brewed_amount = 6
	brew_time = 5 MINUTES
	sell_value = 50

	ages = TRUE
	age_times = list(
		/datum/reagent/consumable/ethanol/tangerine/aged = 10 MINUTES,
		/datum/reagent/consumable/ethanol/tangerine/delectable = 20 MINUTES
	)

/datum/brewing_recipe/raspberry_wine
	name = "葡萄酒，覆盆子"
	category = "水果"
	bottle_name = "覆盆子酒"
	bottle_desc = "一瓶本地酿制的覆盆子酒。口感香甜而酸爽。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/raspberry
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry = 4, /obj/item/reagent_containers/food/snacks/sugar = 2)
	brewed_amount = 6
	brew_time = 5 MINUTES
	sell_value = 50

	ages = TRUE
	age_times = list(
		/datum/reagent/consumable/ethanol/raspberry/aged = 10 MINUTES,
		/datum/reagent/consumable/ethanol/raspberry/delectable = 20 MINUTES
	)

/datum/brewing_recipe/blackberry_wine
	name = "葡萄酒，黑莓"
	category = "水果"
	bottle_name = "黑莓酒"
	bottle_desc = "一瓶本地酿制的黑莓酒。口感微苦而酸。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/blackberry
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry = 4, /obj/item/reagent_containers/food/snacks/sugar = 2)
	brewed_amount = 6
	brew_time = 5 MINUTES
	sell_value = 50

	ages = TRUE
	age_times = list(
		/datum/reagent/consumable/ethanol/blackberry/aged = 10 MINUTES,
		/datum/reagent/consumable/ethanol/blackberry/delectable = 20 MINUTES
	)

/datum/brewing_recipe/whipwine
	name = "葡萄酒，Whip"
	category = "其他"
	bottle_name = "vale whip-wine" // knockoff divine whip wine (magical penis wine)
	bottle_desc = "一瓶本地酿制的 Whipwine。据说是基于 Kazengun 的配方改制而来。它有着格外……皮革般的风味。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/whipwine
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(
		/obj/item/alch/atropa = 1,
		/obj/item/reagent_containers/food/snacks/sugar = 1,
		/obj/item/alch/matricaria = 1,
		/obj/item/alch/paris = 1,
		/obj/item/rogueweapon/whip = 1,
	) // poisonous herbs, sugar, and an actual whip. the power of Mistranslations...
	brewed_amount = 6
	brew_time = 5 MINUTES
	sell_value = 30

/datum/brewing_recipe/luxintenebre
	name = "葡萄酒，Lux"
	category = "其他"
	bottle_name = "luxintebere" // knockoff divine whip wine (magical penis wine)
	bottle_desc = "一种可能带有异端色彩的酿品，Lux 在发酵后会分解为 Vitae，而 Vitae 还能进一步发酵成可口的美酒。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/luxwine
	needed_reagents = list(/datum/reagent/water = 198) // standard
	needed_items = list(
		/obj/item/reagent_containers/lux_impure = 1,
		/obj/item/reagent_containers/food/snacks/sugar = 2,
		/obj/item/alch/calendula = 1,
	) // a single lux, sugar, and a healing herb. seems fair 2 me.
	brewed_amount = 2 // should make 2 bottles
	brew_time = 5 MINUTES
	sell_value = 120  // this shits heretical and has a high black market value
