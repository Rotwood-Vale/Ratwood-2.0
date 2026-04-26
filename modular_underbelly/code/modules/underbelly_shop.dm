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
	/// Sound category for purchase voice line routing: "biggun", "mediumgun", "smallgun", "spikedknucks", "deaddrop", or null for generic
	var/purchase_sound_key = null

/datum/underbelly_shop_item/New(iname, idesc, itype, istock, icost, iflinger = FALSE, irole = null, isoundkey = null)
	name = iname
	desc = idesc
	item_type = itype
	stock = istock
	cost = icost
	flinger_only = iflinger
	exclusive_role = irole
	purchase_sound_key = isoundkey

// The shop datum. Held by the Trader NPC.
/datum/underbelly_shop
	var/mob/living/carbon/human/species/human/northern/underbelly_trader/trader
	/// All stocked item datums this cycle
	var/list/shared_pool = list()
	var/list/exclusive_pool = list()
	var/list/flinger_pool = list()
	/// Track how many of each item a customer has bought this cycle, keyed "ckey_itemname"
	var/list/purchase_counts = list()
	/// world.time when the last restock happened
	var/last_restock_time = 0
	/// Per-ckey: world.time of the restock they last opened the shop during (to detect new stock)
	var/list/last_seen_restock = list()
	/// Per-ckey: number of purchases made in the current shopping session
	var/list/session_purchases = list()
	/// Per-ckey: world.time when the current shopping session started
	var/list/session_open_time = list()

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
	last_restock_time = world.time

	// =========================================================
	// GENERAL MERCHANDISE
	// Shuffled pool — 20-30 slots drawn at random each cycle.
	// Format: name, desc, type, stock, cost
	// =========================================================

	// -- Drinks --
	var/list/cat_drinks = list(
		list("Ratkept Ale",      "A dark, musty ale from the cellars below.",        /obj/item/reagent_containers/glass/bottle/rogue/beer/ratkept,      2, 8),
		list("Hagwood Bitter",   "Leaves a bitter finish. Medicinal, maybe.",         /obj/item/reagent_containers/glass/bottle/rogue/beer/hagwoodbitter, 2, 8),
		list("Black Goat Stout", "Thick enough to chew.",                             /obj/item/reagent_containers/glass/bottle/rogue/beer/blackgoat,     2, 9),
		list("Gronnmead",        "Sweet mead, a northern favourite.",                 /obj/item/reagent_containers/glass/bottle/rogue/beer/gronnmead,     2, 10),
		list("Sourwine",         "It's wine. Mostly.",                                /obj/item/reagent_containers/glass/bottle/rogue/wine/sourwine,      2, 12),
		list("Red Wine",         "You won't believe the story I have on how I got this. The maids were TERRIFIED.",                 /obj/item/reagent_containers/glass/bottle/rogue/redwine,            1, 18),
	)

	// -- Food --
	var/list/cat_food = list(
		list("Salted Cracker",   "Won't fill you up but it'll quiet your gut.",       /obj/item/reagent_containers/food/snacks/rogue/crackerscooked,      3, 3),
		list("Bread Loaf",       "Rough but honest.",                                 /obj/item/reagent_containers/food/snacks/rogue/bread,               2, 4),
		list("Butter Slice",     "Something to put on the bread.",                    /obj/item/reagent_containers/food/snacks/butterslice,               2, 2),
		list("Hard Boiled Egg",  "Filling. Smells.",                                  /obj/item/reagent_containers/food/snacks/egg,                       3, 2),
		list("Steak",            "Cooked, barely. Good protein.",                     /obj/item/reagent_containers/food/snacks/rogue/meat/steak,          1, 12),
		list("Sausage",          "What's in it? Don't ask.",                          /obj/item/reagent_containers/food/snacks/rogue/meat/sausage,        2, 6),
	)

	// -- Supplies --
	var/list/cat_supplies = list(
		list("Satchel",          "Short carry bag. Fits on your belt!",             /obj/item/storage/backpack/rogue/satchel/short,                     1, 15),
		list("Satchel (Large)",  "Everyone should have this.",                      /obj/item/storage/backpack/rogue/satchel,                           1, 20),
		list("Rope Belt Pouch",  "Loops on your belt. Keeps your hands free.",        /obj/item/storage/belt/rogue/leather/rope,                          2, 8),
		list("Bandage Bundle",   "Full cloth bandages. Stops the bleeding.",          /obj/item/natural/bundle/cloth/bandage/full,                        3, 5),
		list("Water Flask",      "Sealed waterskin. Holds a litre.",                  /obj/item/reagent_containers/glass/bottle/waterskin,                2, 5),
		list("Torch (Lantern)",  "Oil lantern on a stick. Burns steady.",             /obj/item/flashlight/flare/torch/lantern,                           2, 7),
		list("Mess Kit",         "Pot, bowl, spoon. Everything you need out there.",  /obj/item/storage/gadget/messkit,                                   1, 8),
		list("Bedroll",          "Enough to sleep on hard ground.",                   /obj/item/bedroll,                                                  1, 10),
		list("Smoke Bomb",       "Throws up a thick screen. Useful for exits.",       /obj/item/bomb/smoke,                                               1, 20),
		list("Lockpick Ring",    "A loop of slim iron used to keep your lockpicks.",             /obj/item/lockpickring/mundane,                                     1, 35),
	)

	// -- Light Weapons & Ammo for bows and crossies. --
	var/list/cat_weapons = list(
		list("Hunting Knife",    "Good steel. Good edge.",                            /obj/item/rogueweapon/huntingknife/idagger/steel,                   1, 25),
		list("Navaja",           "A folding blade. Fits in your sleeve.",             /obj/item/rogueweapon/huntingknife/idagger/navaja,                  1, 22),
		list("Katar",            "Punch dagger. Fits the knuckles.",                  /obj/item/rogueweapon/katar/punchdagger,                            1, 30),
		list("Wood Staff",       "A solid walking stick. Also a weapon.",             /obj/item/rogueweapon/woodstaff,                                    1, 12),
		list("Quarterstaff",     "Balanced length. Versatile fighter's tool.",        /obj/item/rogueweapon/woodstaff/quarterstaff,                       1, 18),
		list("Quiver",           "Holds arrows or bolts.",                            /obj/item/quiver,                                                   1, 5),
		list("Broadhead Arrows", "Bundle of five iron-headed arrows.",                /obj/item/ammo_casing/caseless/rogue/arrow/iron,                    5, 8),
		list("Water Arrows",     "Bundle of five. Douses torches nicely.",            /obj/item/ammo_casing/caseless/rogue/arrow/water,                   5, 5),
		list("Crossbow Bolts",   "Bundle of five standard bolts.",                    /obj/item/ammo_casing/caseless/rogue/bolt,                          5, 10),
	)

	var/list/general_master = cat_drinks + cat_food + cat_supplies + cat_weapons
	var/list/general_shuffled = shuffle(general_master)
	var/take = rand(20, min(30, general_shuffled.len))
	for(var/i = 1 to take)
		var/entry = general_shuffled[i]
		shared_pool += new /datum/underbelly_shop_item(entry[1], entry[2], entry[3], entry[4], entry[5])

	// =========================================================
	// TRADE GOODS: INGOTS
	// "We managed to...procure those from a Kingsfield Trading caravan."
	// Each rolls independently. Higher cost = lower prob.
	// Format: name, desc, type, max_stock, cost, chance(%)
	// =========================================================
	var/list/ingot_pool = list(
		list("Iron Ingot",          "Raw worked iron. The backbone of any smithy.",           /obj/item/ingot/iron,         6, 7,  85),
		list("Steel Ingot",         "Refined and ready. Better edge, better everything.",     /obj/item/ingot/steel,        5, 10, 70),
		list("Gold Ingot",          "Heavy. Warm. Makes things happen.",                      /obj/item/ingot/gold,         3, 35, 45),
		list("Silver Ingot",        "Got a werewolf problem, friend? This should solve it.",  /obj/item/ingot/silver,       2, 45, 35),
		list("Blacksteel Ingot",    "Dark alloy. Rare. Don't ask where it's from.",           /obj/item/ingot/blacksteel,   1, 80, 18),
		list("Silver Bullion",      "Blessed and stamped. Kingsfield doesn't know it's gone.",/obj/item/ingot/silverblessed,2, 85, 15),
	)
	for(var/entry in ingot_pool)
		if(prob(entry[6]))
			shared_pool += new /datum/underbelly_shop_item(entry[1], entry[2], entry[3], rand(1, entry[4]), entry[5])

	// =========================================================
	// STOLEN GEAR
	// "Our neighbours upstairs have a lot of shipments going around.
	//  They won't miss a few that suddenly go missing..."
	// Each rolls independently. Format: name, desc, type, max_stock, cost, chance(%)
	// =========================================================

	// -- Warden Helmets (all variants, any may appear) --
	var/list/stolen_helmets = list(
		list("Warden's Helmet",           "Standard-issue sallet of the Wardens. Dented.",           /obj/item/clothing/head/roguetown/helmet/sallet/warden,          2, 35, 45),
		list("Warden's Volfskull Helm",   "The skull of a white volf, mounted on iron. Imposing.",   /obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf,     2, 35, 35),
		list("Warden's Ramskull Helm",    "A ram's skull helm. Horns intact.",                        /obj/item/clothing/head/roguetown/helmet/sallet/warden/goat,     2, 35, 35),
		list("Warden's Bearskull Helm",   "A bear's skull. Heavy and mean-looking.",                  /obj/item/clothing/head/roguetown/helmet/sallet/warden/bear,     2, 35, 35),
		list("Warden's Hood",             "Dark cloth with iron banding. Quiet.",                     /obj/item/clothing/head/roguetown/roguehood/warden,              2, 30, 40),
	)

	// -- Warden Equipment & Armor --
	var/list/stolen_armor = list(
		list("Studded Warden Armor",      "Leather plate with iron studs. Identifies you as one of them. Or someone who robbed one.",
		                                                                                                /obj/item/clothing/suit/roguetown/armor/leather/studded/warden, 1, 55, 25),
		list("Warden's Cloak",            "Dark green. Smells like pine and blood.",                   /obj/item/clothing/cloak/wardencloak,                            2, 28, 40),
		list("Chainmail Hauberk",         "Full-length mail. Heavy but thorough.",                     /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk,       1, 45, 30),
		list("Chainmail",                 "Standard ringmail. Stops a blade, mostly.",                 /obj/item/clothing/suit/roguetown/armor/chainmail,               2, 30, 45),
		list("Brigandine",                "Plates riveted inside cloth. Practical.",                   /obj/item/clothing/suit/roguetown/armor/brigandine,              1, 40, 35),
		list("Neck Coif",                 "Iron-linked hood for the neck and head.",                   /obj/item/clothing/neck/roguetown/coif,                          2, 15, 55),
	)

	// -- Stolen Weapons --
	var/list/stolen_weapons = list(
		list("Longsword",                 "Steel and balanced. A proper knight's blade.",              /obj/item/rogueweapon/sword/long,                               2, 35, 40),
		list("Sabre",                     "Curved steel, fast in the wrist.",                          /obj/item/rogueweapon/sword/sabre,                              2, 35, 40),
		list("Warhammer",                 "A mean hammer. Breaks bones through armor.",                /obj/item/rogueweapon/mace/warhammer/steel,                     2, 40, 35),
	)

	// -- Firearm Accessories --
	var/list/stolen_firearm = list(
		list("Powder Flask",              "Holds a charge of black powder. Keep it away from sparks.", /obj/item/powderflask,                                          3, 40, 60),
		list("Lead Ball Pouch",           "Eight lead balls, ready to load.",                          /obj/item/quiver/bullet/lead,                                   2, 50, 50),
		list("Extended Lead Ball Pouch",  "Sixteen lead balls packed into the same old pouch.",        /obj/item/quiver/bullet/lead/extended,                          1, 90, 20),
		list("Grapeshot Pouch",           "Eight grapeshot charges. For the bigger guns.",             /obj/item/quiver/bullet/grapeshot,                              1, 90, 25),
		list("Extended Grapeshot Pouch",  "Sixteen grapeshot charges for anyone expecting a long night.", /obj/item/quiver/bullet/grapeshot/extended,                   1, 160, 15),
	)

	var/list/stolen_all = stolen_helmets + stolen_armor + stolen_weapons + stolen_firearm
	for(var/entry in stolen_all)
		if(prob(entry[6]))
			shared_pool += new /datum/underbelly_shop_item(entry[1], entry[2], entry[3], rand(1, entry[4]), entry[5])

	// =========================================================
	// EXCLUSIVES
	// Up to 8 entries drawn at random. Role-restricted where noted.
	// Format: name, desc, type, stock, cost, flinger, role
	// =========================================================
	var/list/excl_master = list(
		list("Lockpick (Gold)",    "Picks even tricky locks.",                         /obj/item/lockpick/goldpin,                                         1, 60,  FALSE, "Scum"),
		list("Lockpick",           "A thin iron pick.",                                /obj/item/lockpick,                                                 2, 12,  FALSE, "Scum"),
		list("Scrap Pistol",       "Fires most of the time. A bargain at any price.",  /obj/item/gun/ballistic/firearm/arquebus_pistol/scrap_pistol,       2, 30,  FALSE, "Scum"),
		list("Scrap Blunderbuss",  "Wide spread. Might not fire. Terrifying anyway.",  /obj/item/gun/ballistic/firearm/blunderbuss/scrap_blunderbuss,      1, 45,  FALSE, "Scum"),
		list("Scrap Musket",       "Inaccurate, slow, unreliable. Your only option.", /obj/item/gun/ballistic/firearm/arquebus/scrap_musket,              1, 40,  FALSE, "Scum"),
		list("Collar & Chain",     "Heavy leash. Good for keeping someone close.",     /obj/item/leash/chain,                                              1, 40,  FALSE, "Bandit"),
		list("Common Poison",      "Coat a blade or slip it in a drink.",              /obj/item/reagent_containers/glass/bottle/rogue/poison,             1, 45,  FALSE, null),
		list("Strong Poison",      "Hits harder. Harder to source.",                   /obj/item/reagent_containers/glass/bottle/rogue/strongpoison,       1, 80,  FALSE, null),
		list("Arquebus Pistol",    "Single shot. Loud. Effective.",                    /obj/item/gun/ballistic/firearm/arquebus_pistol,                    1, 120, FALSE, "Bandit"),
		list("Recurving Bow",      "Better pull weight, quieter than a firearm.",      /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve,        1, 55,  FALSE, null),
		list("Crossbow",           "Slow to load but accurate at range.",              /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow,           1, 85,  FALSE, null),
		list("Bomb",               "Loud. Messy. Gets the job done.",                  /obj/item/bomb,                                                     1, 95,  FALSE, null),
	)
	var/list/excl_shuffled = shuffle(excl_master)
	for(var/i = 1 to min(8, excl_shuffled.len))
		var/entry = excl_shuffled[i]
		exclusive_pool += new /datum/underbelly_shop_item(entry[1], entry[2], entry[3], entry[4], entry[5], FALSE, entry[7])

	// =========================================================
	// FLINGER POOL
	// Copy of shared (double stock) + exclusive illegal extras.
	// =========================================================
	for(var/datum/underbelly_shop_item/SI in shared_pool)
		flinger_pool += new /datum/underbelly_shop_item(SI.name, SI.desc, SI.item_type, SI.stock * 2, SI.cost)
	var/list/flinger_extra = list(
		list("Strong Poison",      "Hits harder. Harder to source.",                  /obj/item/reagent_containers/glass/bottle/rogue/strongpoison,  2, 65,  TRUE),
		list("Bomb",               "Loud. Messy. Very effective.",                    /obj/item/bomb,                                                2, 75,  TRUE),
		list("Arquebus Pistol",    "Single shot firearm.",                            /obj/item/gun/ballistic/firearm/arquebus_pistol,               2, 95,  TRUE),
		list("Smoke Bomb (Extra)", "Three in the pouch.",                             /obj/item/bomb/smoke,                                          3, 15,  TRUE),
		list("Lockpick (Gold)",    "Picks even tricky locks.",                        /obj/item/lockpick/goldpin,                                    2, 50,  TRUE),
	)
	for(var/entry in flinger_extra)
		flinger_pool += new /datum/underbelly_shop_item(entry[1], entry[2], entry[3], entry[4], entry[5], TRUE)

/datum/underbelly_shop/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "UnderbellyShop", "The Trader")
		ui.open()
		on_open(user)

/datum/underbelly_shop/ui_state(mob/user)
	return GLOB.conscious_state

/datum/underbelly_shop/proc/on_open(mob/user)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		return
	session_purchases[H.ckey] = 0
	session_open_time[H.ckey] = world.time
	var/has_new_stock = last_restock_time > (last_seen_restock[H.ckey] || 0)
	if(has_new_stock)
		last_seen_restock[H.ckey] = last_restock_time
		trader?.on_shop_open_newstock(H)
	else
		trader?.on_shop_open(H)

/datum/underbelly_shop/ui_close(mob/user)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		return
	trader?.on_shop_close(H)
	var/purchases = session_purchases[H.ckey] || 0
	var/open_time = session_open_time[H.ckey] || 0
	session_purchases[H.ckey] = 0
	if(purchases == 0 && world.time - open_time >= 30 SECONDS)
		trader?.on_nopurchase_close(H)

/datum/underbelly_shop/ui_data(mob/user)
	var/mob/living/carbon/human/H = user
	var/obj/structure/roguemachine/underbelly_chute/chute = GLOB.underbelly_chute
	var/user_budget = chute ? (chute.budgets[H.ckey] || 0) : 0
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
	if(action == "tab_changed")
		switch(params["tab"])
			if("main")
				trader?.on_tab_main(H)
			if("exclusive")
				trader?.on_tab_exclusives(H)
		return TRUE
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
	var/obj/structure/roguemachine/underbelly_chute/chute = GLOB.underbelly_chute
	var/budget = chute ? (chute.budgets[H.ckey] || 0) : 0
	if(SI.exclusive_role && H.job != SI.exclusive_role && H.job != "Gutter King")
		to_chat(H, span_warning("That's not for you."))
		return FALSE
	if(SI.stock <= 0)
		trader?.on_no_stock(H)
		to_chat(H, span_warning("That's all out."))
		return FALSE
	if(budget < SI.cost)
		trader?.on_no_coin(H)
		return FALSE
	var/bought_so_far = purchase_counts[count_key] || 0
	if(bought_so_far >= max_buys)
		to_chat(H, span_warning("You've already bought your limit of that."))
		return FALSE
	chute.budgets[H.ckey] -= SI.cost
	SI.stock -= 1
	purchase_counts[count_key] = bought_so_far + 1
	session_purchases[H.ckey] = (session_purchases[H.ckey] || 0) + 1
	new SI.item_type(get_turf(H))
	trader?.on_purchase(H, SI.purchase_sound_key)
	return TRUE
