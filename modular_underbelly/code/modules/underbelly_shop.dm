/// A single purchaseable entry in the Trader's shop.
/datum/underbelly_shop_item
	var/name = ""
	var/desc = ""
	var/item_type
	/// How many are left in stock. Restocked each cycle.
	var/stock = 1
	/// Base price in mammon
	var/cost = 10
	/// Whether this item is only for Flingers
	var/flinger_only = FALSE
	/// Role string this item is exclusive to (null = all roles)
	var/exclusive_role = null

/datum/underbelly_shop_item/New(iname, idesc, itype, istock, icost, iflinger = FALSE, irole = null)
	name = iname
	desc = idesc
	item_type = itype
	stock = istock
	cost = icost
	flinger_only = iflinger
	exclusive_role = irole

// The shop datum. Held by the Trader NPC.
/datum/underbelly_shop
	var/mob/living/carbon/human/species/human/northern/underbelly_trader/trader
	/// All stocked item datums this cycle
	var/list/shared_pool = list()
	var/list/exclusive_pool = list()
	var/list/flinger_pool = list()
	/// Track how many of each item a customer has bought this cycle, keyed "ckey_itemname"
	var/list/purchase_counts = list()

/datum/underbelly_shop/New(mob/living/carbon/human/species/human/northern/underbelly_trader/T)
	trader = T

/datum/underbelly_shop/Destroy()
	QDEL_LIST(shared_pool)
	QDEL_LIST(exclusive_pool)
	QDEL_LIST(flinger_pool)
	return ..()

/datum/underbelly_shop/proc/do_restock()
	QDEL_LIST(shared_pool)
	QDEL_LIST(exclusive_pool)
	QDEL_LIST(flinger_pool)
	purchase_counts = list()

	// --- SHARED POOL (30-45 items drawn from a master list) ---
	var/list/master = list(
		list("Ratkept Ale",        "A dark, musty ale from the cellars below.",       /obj/item/reagent_containers/glass/bottle/rogue/beer/ratkept,       2, 8),
		list("Hagwood Bitter",     "Leaves a bitter finish. Medicinal, maybe.",        /obj/item/reagent_containers/glass/bottle/rogue/beer/hagwoodbitter,  2, 8),
		list("Black Goat Stout",   "Thick enough to chew.",                            /obj/item/reagent_containers/glass/bottle/rogue/beer/blackgoat,      2, 9),
		list("Gronnmead",          "Sweet mead, a northern favourite.",                /obj/item/reagent_containers/glass/bottle/rogue/beer/gronnmead,      2, 10),
		list("Sourwine",           "It's wine. Mostly.",                               /obj/item/reagent_containers/glass/bottle/rogue/wine/sourwine,       2, 12),
		list("Red Wine",           "Decent table wine, faintly dusty.",                /obj/item/reagent_containers/glass/bottle/rogue/redwine,             1, 18),
		list("Salted Cracker",     "Won't fill you up but it'll quiet your gut.",      /obj/item/reagent_containers/food/snacks/rogue/crackerscooked,       3, 3),
		list("Bread Loaf",         "Rough but honest.",                                /obj/item/reagent_containers/food/snacks/rogue/bread,               2, 4),
		list("Butter Slice",       "Something to put on the bread.",                   /obj/item/reagent_containers/food/snacks/butterslice,               2, 2),
		list("Hard Boiled Egg",    "Filling. Smells.",                                 /obj/item/reagent_containers/food/snacks/egg,                       3, 2),
		list("Steak",              "Cooked, barely. Good protein.",                    /obj/item/reagent_containers/food/snacks/rogue/meat/steak,          1, 12),
		list("Sausage",            "What's in it? Don't ask.",                         /obj/item/reagent_containers/food/snacks/rogue/meat/sausage,        2, 6),
		list("Lockpick Ring",      "A loop of slim iron picks. For doors.",            /obj/item/lockpickring/mundane,                                     1, 35),
		list("Smoke Bomb",         "Throws up a thick screen. Useful for exits.",      /obj/item/bomb/smoke,                                               1, 20),
		list("Satchel",            "Short carry bag. Fits most shoulders.",            /obj/item/storage/backpack/rogue/satchel/short,                     1, 15),
		list("Satchel (Large)",    "Bigger. Better.",                                  /obj/item/storage/backpack/rogue/satchel,                           1, 20),
		list("Rope Belt Pouch",    "Loops on your belt. Keeps your hands free.",       /obj/item/storage/belt/rogue/leather/rope,                          2, 8),
		list("Bandage Bundle",     "Full cloth bandages. Stops the bleeding.",         /obj/item/natural/bundle/cloth/bandage/full,                        3, 5),
		list("Water Flask",        "Sealed waterskin. Holds a litre.",                 /obj/item/reagent_containers/glass/bottle/waterskin,                2, 5),
		list("Torch (Lantern)",    "Oil lantern on a stick. Burns steady.",            /obj/item/flashlight/flare/torch/lantern,                           2, 7),
		list("Mess Kit",           "Pot, bowl, spoon. Everything you need out there.", /obj/item/storage/gadget/messkit,                                   1, 8),
		list("Hunting Knife",      "Good steel. Good edge.",                           /obj/item/rogueweapon/huntingknife/idagger/steel,                   1, 25),
		list("Navaja",             "A folding blade. Fits in your sleeve.",            /obj/item/rogueweapon/huntingknife/idagger/navaja,                  1, 22),
		list("Katar",              "Punch dagger. Fits the knuckles.",                 /obj/item/rogueweapon/katar/punchdagger,                            1, 30),
		list("Wood Staff",         "A solid walking stick. Also a weapon.",            /obj/item/rogueweapon/woodstaff,                                    1, 12),
		list("Quarterstaff",       "Balanced length. Versatile fighter's tool.",       /obj/item/rogueweapon/woodstaff/quarterstaff,                       1, 18),
		list("Quiver",             "Holds arrows or bolts.",                           /obj/item/quiver,                                                   1, 5),
		list("Broadhead Arrows",   "Bundle of five iron-headed arrows.",               /obj/item/ammo_casing/caseless/rogue/arrow/iron,                    5, 8),
		list("Water Arrows",       "Bundle of five. Douses torches nicely.",           /obj/item/ammo_casing/caseless/rogue/arrow/water,                   5, 5),
		list("Crossbow Bolts",     "Bundle of five standard bolts.",                   /obj/item/ammo_casing/caseless/rogue/bolt,                          5, 10),
		list("Bedroll",            "Enough to sleep on hard ground.",                  /obj/item/bedroll,                                                  1, 10),
	)

	// Shuffle and take 30-45 items
	var/list/shuffled = shuffle(master)
	var/take = rand(30, min(45, shuffled.len))
	for(var/i = 1 to take)
		var/entry = shuffled[i]
		shared_pool += new /datum/underbelly_shop_item(entry[1], entry[2], entry[3], entry[4], entry[5])

	// --- EXCLUSIVE POOL (role-weighted) ---
	var/list/excl_master = list(
		list("Lockpick (Gold)",    "Picks even tricky locks.",                         /obj/item/lockpick/golden,                                          1, 60,  FALSE, "Thief"),
		list("Lockpick",           "A thin iron pick.",                                /obj/item/lockpick,                                                 2, 12,  FALSE, "Thief"),
		list("Collar & Chain",     "Heavy leash. Good for keeping someone close.",     /obj/item/leash/chain,                                              1, 40,  FALSE, "Bandit"),
		list("Common Poison",      "Coat a blade or slip it in a drink.",              /obj/item/reagent_containers/glass/bottle/rogue/poison,             1, 45,  FALSE, null),
		list("Strong Poison",      "Hits harder. Harder to source.",                   /obj/item/reagent_containers/glass/bottle/rogue/strongpoison,       1, 80,  FALSE, null),
		list("Arquebus Pistol",    "Single shot. Loud. Effective.",                    /obj/item/gun/ballistic/firearm/arquebus_pistol,                    1, 120, FALSE, "Bandit"),
		list("Recurving Bow",      "Better pull weight, quieter than a firearm.",      /obj/item/gun/ballistic/revolver/grenadelauncher/recurvebow,         1, 55,  FALSE, null),
		list("Crossbow",           "Slow to load but accurate at range.",              /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow,           1, 85,  FALSE, null),
		list("Bomb",               "Loud. Messy. Gets the job done.",                  /obj/item/bomb,                                                     1, 95,  FALSE, null),
	)
	// Shuffle exclusive pool, keep up to 8 entries
	var/list/excl_shuffled = shuffle(excl_master)
	for(var/i = 1 to min(8, excl_shuffled.len))
		var/entry = excl_shuffled[i]
		exclusive_pool += new /datum/underbelly_shop_item(entry[1], entry[2], entry[3], entry[4], entry[5], FALSE, entry[7])

	// --- FLINGER POOL (copy of shared + better illegal items, up to 10 extra) ---
	for(var/datum/underbelly_shop_item/SI in shared_pool)
		var/datum/underbelly_shop_item/copy = new /datum/underbelly_shop_item(SI.name, SI.desc, SI.item_type, SI.stock * 2, SI.cost)
		flinger_pool += copy
	// Extra illegal items for Flingers
	var/list/flinger_extra = list(
		list("Strong Poison",      "Hits harder. Harder to source.",                  /obj/item/reagent_containers/glass/bottle/rogue/strongpoison,  2, 65,  TRUE),
		list("Bomb",               "Loud. Messy. Very effective.",                    /obj/item/bomb,                                                2, 75,  TRUE),
		list("Arquebus Pistol",    "Single shot firearm.",                            /obj/item/gun/ballistic/firearm/arquebus_pistol,               2, 95,  TRUE),
		list("Smoke Bomb (Extra)", "Three in the pouch.",                             /obj/item/bomb/smoke,                                          3, 15,  TRUE),
		list("Lockpick (Gold)",    "Picks even tricky locks.",                        /obj/item/lockpick/golden,                                     2, 50,  TRUE),
	)
	for(var/entry in flinger_extra)
		flinger_pool += new /datum/underbelly_shop_item(entry[1], entry[2], entry[3], entry[4], entry[5], TRUE)

/datum/underbelly_shop/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "UnderbellyShop", "The Trader")
		ui.open()

/datum/underbelly_shop/ui_state(mob/user)
	return GLOB.conscious_state

/datum/underbelly_shop/ui_data(mob/user)
	var/mob/living/carbon/human/H = user
	var/user_budget = GLOB.underbelly_chute ? (GLOB.underbelly_chute.budgets[H.ckey] || 0) : 0
	var/is_flinger = istype(H) && (H.job == "Flinger")

	var/list/shared_data = list()
	for(var/datum/underbelly_shop_item/SI in shared_pool)
		var/buy_count = purchase_counts["[H.ckey]_[SI.name]"] || 0
		shared_data += list(list(
			"name" = SI.name,
			"desc" = SI.desc,
			"cost" = SI.cost,
			"stock" = SI.stock,
			"bought" = buy_count,
		))

	var/list/excl_data = list()
	for(var/datum/underbelly_shop_item/SI in exclusive_pool)
		var/buy_count = purchase_counts["[H.ckey]_[SI.name]"] || 0
		excl_data += list(list(
			"name" = SI.name,
			"desc" = SI.desc,
			"cost" = SI.cost,
			"stock" = SI.stock,
			"bought" = buy_count,
		))

	var/list/flinger_data = list()
	for(var/datum/underbelly_shop_item/SI in flinger_pool)
		var/buy_limit = SI.flinger_only ? 2 : 1
		var/buy_count = purchase_counts["[H.ckey]_flinger_[SI.name]"] || 0
		flinger_data += list(list(
			"name" = SI.name,
			"desc" = SI.desc,
			"cost" = SI.cost,
			"stock" = SI.stock,
			"bought" = buy_count,
			"buy_limit" = buy_limit,
		))

	var/ticks_left = trader ? max(0, trader.next_restock - world.time) : 0
	return list(
		"budget" = user_budget,
		"is_flinger" = is_flinger,
		"trader_name" = trader ? trader.name : "The Trader",
		"ticks_to_restock" = ticks_left,
		"shared" = shared_data,
		"exclusive" = excl_data,
		"flinger" = flinger_data,
	)

/datum/underbelly_shop/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	var/mob/living/carbon/human/H = ui.user
	if(!istype(H))
		return FALSE
	if(!GLOB.underbelly_chute)
		to_chat(H, span_warning("The chute isn't active. Deposit coins first."))
		return FALSE

	switch(action)
		if("buy_shared", "buy_exclusive")
			var/pool = (action == "buy_shared") ? shared_pool : exclusive_pool
			var/item_name = params["name"]
			var/datum/underbelly_shop_item/SI = locate_item(pool, item_name)
			if(!SI)
				return FALSE
			return do_purchase(H, SI, "[H.ckey]_[SI.name]", 1)

		if("buy_flinger")
			if(H.job != "Flinger")
				to_chat(H, span_warning("That's not for you."))
				return FALSE
			var/item_name = params["name"]
			var/datum/underbelly_shop_item/SI = locate_item(flinger_pool, item_name)
			if(!SI)
				return FALSE
			var/buy_limit = SI.flinger_only ? 2 : 1
			return do_purchase(H, SI, "[H.ckey]_flinger_[SI.name]", buy_limit)

/datum/underbelly_shop/proc/locate_item(list/pool, item_name)
	for(var/datum/underbelly_shop_item/SI in pool)
		if(SI.name == item_name)
			return SI
	return null

/datum/underbelly_shop/proc/do_purchase(mob/living/carbon/human/H, datum/underbelly_shop_item/SI, count_key, max_buys)
	var/budget = GLOB.underbelly_chute.budgets[H.ckey] || 0
	if(SI.stock <= 0)
		to_chat(H, span_warning("That's all out."))
		return FALSE
	if(budget < SI.cost)
		trader?.on_no_coin(H)
		return FALSE
	var/bought_so_far = purchase_counts[count_key] || 0
	if(bought_so_far >= max_buys)
		to_chat(H, span_warning("You've already bought your limit of that."))
		return FALSE
	GLOB.underbelly_chute.budgets[H.ckey] -= SI.cost
	SI.stock -= 1
	purchase_counts[count_key] = bought_so_far + 1
	new SI.item_type(get_turf(H))
	trader?.on_purchase(H)
	return TRUE
