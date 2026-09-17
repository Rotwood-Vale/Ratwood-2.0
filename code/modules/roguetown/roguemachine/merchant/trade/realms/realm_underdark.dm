//ships from the underdark- made their from the caverns through natural rivers and sluices. Trade from Mercuriam, kobolds and drow in the caverns
/datum/foreign_realm/underdark
	id = REALM_UNDERDARK
	name = "Underdark"
	roll_weight = TRADE_REALM_WEIGHT_DISTANT
	demanded_categories = list(NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_ARMOR_LIGHT, NAVIGATOR_BUCKET_GARMENT_FINELUX, NAVIGATOR_BUCKET_POTIONS_REAGENTS, NAVIGATOR_BUCKET_ENCHANTMENTS, NAVIGATOR_BUCKET_INSTRUMENTS, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_VALUABLES_CRAFTED, NAVIGATOR_BUCKET_MISCELLANEOUS)
	single_word_base = TRUE
	ship_name_words = list(
		"Duskfang", "Gloomroot", "Emberweb", "Nightspire", "Chitinfall",
		"Voidcarve", "Ashwick", "Hollowfen", "Cinderweb", "Grimtide",
		"Bonelight", "Shadowspur", "Fungalreach", "Mirewake", "Deepglass",
	)
	captain_first_names = list(
		"Xylvaeth", "Serathil", "Nyxandra", "Veshtal", "Ilyndra",
		"Threnos", "Saevrin", "Mordeth", "Quilara", "Zyrenne",
		"Orruth", "Kaelith", "Vantrys", "Aelune", "Draskiel",
	)
	captain_last_names = list(
		"Ixar", "Sevari", "Naxir", "Ghaun", "Ssarn",
		"Draeth", "Kaelis", "Orryn", "Vhoral", "Myrren",
	)
	ship_types = list(
		list("name" = "Chitin Skiff", "tonnage" = 80, "weight" = 20),
		list("name" = "Obsidian Galley", "tonnage" = 200, "weight" = 30),
		list("name" = "Bone Dreadnought", "tonnage" = 800, "weight" = 30),
	)
	city_tags = list()
	city_tag_chance = 0
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_HONEY, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_ANTIDOTE_POTION, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_MUSHROOM,"qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_MEAT_EXOTIC, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_HEALTH_POTION, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_DENDOR_ESSENCE, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_TEA, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_CLAY, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_ENCHSCROLL_BASIC, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_BRONZE_PROSTHETIC, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_PAPER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_ONYXA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_ROCKNUT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/ricepork, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/cookieslicer, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/cookieslicec, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat/spider, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/fryfish/carp, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FISH),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/plum_wine),
		list("recipe" = /datum/brewing_recipe/liquor),
		list("recipe" = /datum/brewing_recipe/luxintenebre),
		list("recipe" = /datum/brewing_recipe/rum),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/gems/onyxa,
		/datum/supply_pack/rogue/food/pepper,
		/datum/supply_pack/rogue/underdark/saber,
		/datum/supply_pack/rogue/underdark/dagger,
		/datum/supply_pack/rogue/underdark/slurbow,
		/datum/supply_pack/rogue/underdark/fangeddagger,
		/datum/supply_pack/rogue/underdark/poisondagger,
		/datum/supply_pack/rogue/underdark/restrainpoison,
		/datum/supply_pack/rogue/underdark/killerpoison,
		/datum/supply_pack/rogue/underdark/antidote,
		/datum/supply_pack/rogue/underdark/crocs,
		/datum/supply_pack/rogue/luxury/fancyteaset,
		/datum/supply_pack/rogue/alcohol/elfblue,
	)
	hail_lines = list(
		"Greetings from House Ixar of the Deep Courts. My manifest is sealed in chitin-wax. Honor the seal and we conclude this with grace, sun-dweller.",
		"Web-silk, cave fungus, and spider-honey in lawful measure; obsidian and refined ore in lesser quantity. Inspect what you must - my ledger-thrall's marks are honest.",
		"My hull bears the mark of the Deep Court. Lesser sigils you may see among my crew - the kobold clans prefer we acknowledge them. Acknowledge me first.",
		"An acid-river surge caught us three tunnels from the surface breach - the same flood that swallowed the lower markets, they say. Psydon's luck runs thin down there. Pay fairly for what reached you.",
		"I speak for House Sevari by right of blood and blade. Nine matrons signed my charter. I have neither time nor inclination for your surface haggling.",
		"My cargo of enchanted scrolls is sealed beneath three locks and one charm. Buy them or do not, but do not ask to inspect them. Psydon watches.",
		"My passenger is a wandering soul of Eora's universal compassion. He pays his own passage in charity & merits, not coin. Mind him as you would any holy beggar - I do.",
		"Mark me - I am Ixar by blood, and that name still binds houses beneath the crust, even where the eastern warrens would have it forgotten. Trade with my house, not with whatever holds its leash.",
		"A ledger-thrall in my hold dreamt of this harbor before we surfaced. She named your harbormaster by his birth-name. The Deep Courts record every utterance - I would have us done quickly..",
		"There is a passenger in bone-white silks who pays in raw obsidia and does not eat or sleep. The crew thinks her one of Necra's many aspects. Take her coin first.",
		"The cave-adder coiled at my prow is no pet, sun-dweller. She earns her keep and her silence. Do not let your priests stare too long; she does not care for any.",
		"My matron's matron served under the old Deep Court before the Sundering. We have outlived three collapses and one flooding. Your surface Duchy does not impress me.",,
		"I carry a Fluvian broker from Mercuriam, all gill-slits and courtesy, who trades in things that shouldn't cross running water. Pay him and ask no questions - the river remembers questions.",	)
