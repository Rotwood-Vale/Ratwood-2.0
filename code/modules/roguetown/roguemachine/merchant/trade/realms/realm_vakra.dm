/datum/foreign_realm/vakra
	id = REALM_VAKRA
	name = "Vakran"
	roll_weight = TRADE_REALM_WEIGHT_RARE
	demanded_categories = list(NAVIGATOR_BUCKET_GARMENT_FINELUX, NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_ARMOR_LIGHT, NAVIGATOR_BUCKET_ARMOR_HEAVY, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_MISCELLANEOUS)
	ship_name_words = list(
		"Otter", "Noc-lit", "Vakran", "Packlord", "Lupianowy",
		"Seavolf", "Toothy", "Fanged", "Claw", "Forder",
		"Paddler", "Noc-bounty",
	)
	captain_first_names = list(
		"Larai", "Hosk", "Kessith", "Slazri", "Rokzar",
		"Hralz", "Zelkar", "Vossar", "Sirhak", "Kazros",
		"Zessira", "Hsalka", "Rikzira", "Solzra", "Kazinna",
	)
	captain_last_names = list(
		"Sturmvolf", "the Sockeye", "Torn-Ear", "Swiftwoda", "the Kundlu",
		"Noclicht", "the Kunda", "Long-Tooth", "the lupianowy",
	)
//Grenzelhoftian ship- Vakra's a clientstate/loosely 'governed' even before the civilwar
	ship_types = list(
		list("name" = "Coaster", "tonnage" = 30, "weight" = 15),
		list("name" = "Cog", "tonnage" = 120, "weight" = 50),
		list("name" = "Hulk", "tonnage" = 250, "weight" = 25),
		list("name" = "Carrack", "tonnage" = 500, "weight" = 10),
	)
	city_tags = list()
	city_tag_chance = 0
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_TOPER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_BLORTZ, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_DORPEL, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_JADE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("good" = TRADE_GOOD_OPAL, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_ONYXA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("good" = TRADE_GOOD_CERULITE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_HEARTSTONE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_AMBER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("good" = TRADE_GOOD_ROSESTONE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_CINNABAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_GOLD_ORE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_STAPLE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_STAPLE_EAGER, "always" = TRUE),
		list("good" = TRADE_GOOD_FIBERS, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_COFFEE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_SILVER_INGOT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_FAT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_POPPY, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_CARROT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_HEALTH_POTION, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/hcake, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_LUXURY),
//		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlickcucumber, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FEAST),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/pepperfish, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_STEAK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/peppersteak, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/menthacake, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_STEAK),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/raisinbread, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/luxintenebre),
		list("recipe" = /datum/brewing_recipe/voddena),
		list("recipe" = /datum/brewing_recipe/jack_wine),
		list("recipe" = /datum/brewing_recipe/blackberry_wine),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/vakra/vreccale,
		/datum/supply_pack/rogue/vakra/helmet,
		/datum/supply_pack/rogue/vakra/warhammer,
		/datum/supply_pack/rogue/vakra/forlorn_hope_regalia,
		/datum/supply_pack/rogue/lirvas/gold_quarterstaff,
		/datum/supply_pack/rogue/lirvas/sabre,
		/datum/supply_pack/rogue/alcohol/rtoper,
	)
	hail_lines = list(
		"The battle lines in Vakra shift all the time. There's no way to know who will own the port by the time we get back to it. Whoever it is, they'll need these supplies.",
		"Vakrans never thought highly of sailing folk, before the war. Called us Otters, they did. They'd chuckle and turn their snouts up at our riverboats. Now? You've never seen a lupianowy so happy as when we come back to port with fresh equipment." ,
		"Most of this stuff was looted from some packlord's holding or other. They raid each other, they sell us the spoils, they buy our supplies. In a few years, nothing will be left in Vakra that shines at all.",
		"Seems odd to be buying fancy dresses and frilly clothes in the middle of a war, doesn't it? I'll let you in on a little secret: no one's wearing this stuff. Anything made with fur will be broken down to make insulation for armor, the rest will be repurposed into gambesons. Peasant clothes aren't made strong enough." ,
		"Got any fish? We can use the flesh to make jerky, of course, but the real value is the oil. Makes lupianowy fur grow thick and lustrous. One of the few luxuries most of them can still afford, back in Vakra.",
		"News from Vakra? Territories aren't the same from one dae to the next. Anything I'd tell you was out of date by the time we left port. If you want to know what's going on in the packlands, hop aboard and see for yourself... I mean, don't, we don't have room for a passenger, but you get what I'm saying.",
		"Buying? Selling? Tak? No? Make up your mind, we've got a war to get back to.",
		"The coffee's for the crew. Don't get much sleep; we work long hours and there's no leg of our journey that's truly safe. Well, that and Rufus snores like Abyssor having a wet dream...",
		"Prusaks aren't all bad, even with their ridiculous hats. I mean, they let us travel their waterways, and unload in their ports. Still, I dread the day the war spills over into their territory. Not sure they'll be so welcoming then.",
		"Dobry den! What can a lightly-salted, old lupianowy do for you t'dae?",
		)
