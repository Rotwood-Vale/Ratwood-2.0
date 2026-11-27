/datum/foreign_realm/gronn
	id = REALM_GRONN
	name = "Gronn"
	roll_weight = TRADE_REALM_WEIGHT_DISTANT
	demanded_categories = list(NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_ARMOR_HEAVY, NAVIGATOR_BUCKET_POTTERY, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_ALCOHOL, NAVIGATOR_BUCKET_MISCELLANEOUS)
	ship_name_words = list(
		"Fjord", "Nöküd", "Volf", "Beorn", "Ravn",
		"Skuld", "Storm", "Aurora", "Glacier", "Ulfr",
		"Drage", "Frosti", "Hrim", "Norn", "Saiga",
	)
	captain_first_names = list(
		"Oarri", "Niillas", "Aslak", "Mikkel", "Ánte",
		"Heaika", "Sammol", "Ivvár", "Biera", "Hánsa",
		"Risten", "Máret", "Elle", "Sárá", "Inga",
	)
	captain_last_names = list(
		"Nöküd", "Volfsson", "Saigahorn", "Glacierborn", "Stormbringer",
		"Ravnstrid", "Frostbearer", "Drageaette", "Norrsker", "Hrimskogr",
	)
	ship_types = list(
		list("name" = "Knarr", "tonnage" = 30, "weight" = 15),
		list("name" = "Longship", "tonnage" = 80, "weight" = 30),
		list("name" = "Icebreaker Hulk", "tonnage" = 200, "weight" = 30),
		list("name" = "Great Drakkar", "tonnage" = 400, "weight" = 20),
		list("name" = "Fenrir", "tonnage" = 700, "weight" = 5),
	)
	city_tags = list(
		"Nöküd-By", "Volfshaven", "Saigahold",
		"Ravnskar",
	)
	city_tag_chance = 30
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_IRON_ORE, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_MEAT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_PORK, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_TALLOW, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_VISCERA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_GARLICK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_CALENDULA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_POPPY, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM),
		list("good" = TRADE_GOOD_BUTTER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_CABBAGE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_ROCKNUT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FEAST),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_STEAK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/mead, "keg_mult" = 3),
		list("recipe" = /datum/brewing_recipe/spidermead),
		list("recipe" = /datum/brewing_recipe/voddena),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/food/honey,
		/datum/supply_pack/rogue/gronn/gronnarmor,
		/datum/supply_pack/rogue/gronn/gronnpants,
		/datum/supply_pack/rogue/gronn/farhat,
		/datum/supply_pack/rogue/gronn/nomadhelmet,
		/datum/supply_pack/rogue/gronn/nomadscalemail,
		/datum/supply_pack/rogue/gronn/kurche,
		/datum/supply_pack/rogue/gronn/kite_shield,
		/datum/supply_pack/rogue/gronn/warrior_kit,
		/datum/supply_pack/rogue/gronn/gronnic_heavy_plate,
		/datum/supply_pack/rogue/gronn/gronnic_heavy_helm,
		/datum/supply_pack/rogue/gronn/heavy_kit,
		/datum/supply_pack/rogue/gronn/spider_honey,
		/datum/supply_pack/rogue/gronn/cured_megafauna,
		/datum/supply_pack/rogue/gronn/ring_courage,
		/datum/supply_pack/rogue/alcohol/gronnmead,
	)
	hail_lines = list(
		"Southlander. Hide, iron, fur. Salt, coal, steel. The trade is simple. Do not complicate it.",
		"My crew has not seen sun for a fortnight. Keep them on the pier; do not invite them inland.",
		"I will sell my hides at a fair price. I will not sell my dogs. Three of your stevedores asked already.",
		"Saigahold sends its finest iron. Take it with respect.",
		"Last voyage's hold carried six of your countrymen home. They walked off freely at Volfshaven and bought drinks for my crew. This voyage carries hides. Keep your priests off my deck and we will speak prices.",
		"These antlers will fetch a fine price south, I am told. Your priests have a particular name for the beast they came from. We do not use that name. Pay or do not, but do not preach.",
		"There is a totem under my sailcloth that is not for sale and not for your church to see. If your magistrate calls it idolatry, your magistrate has not seen real winter.",
		"The aurora followed us south. The crew calls that a witness. Your Ten have nothing to do with it; do not bring your priests to argue otherwise.",
		"We do not raid this season. The compact holds. Pray the next captain you meet from our shore says the same.",
		"I bring mead enough to drown the winter. Drink it as men, not as your southern fashion of sipping it like broth.",
		"My people dream of plaice in butter, herbed with mentha. You people call it Saint Dendor's Salmon, an Otavais dish I heard. Sell me the southern butter, the mentha, and the plaices in ice. We pays well"
	)
