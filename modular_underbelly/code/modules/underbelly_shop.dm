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
	var/list/shipment_pool = list()
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
	QDEL_LIST(shipment_pool)
	return ..()

/datum/underbelly_shop/proc/do_restock()
	QDEL_LIST(shared_pool)
	QDEL_LIST(exclusive_pool)
	QDEL_LIST(flinger_pool)
	QDEL_LIST(shipment_pool)
	purchase_counts = list()
	last_restock_time = world.time

	// =========================================================
	// MASTER MERCHANDISE POOL
	// Both Main shop and Flinger tab draw from this independently each cycle.
	// Format: name, desc, type, stock, cost
	// =========================================================

	// -- Drinks --
	var/list/cat_drinks = list(
		list("Ratkept Ale",           "A dark, musty ale from the cellars below.",                      /obj/item/reagent_containers/glass/bottle/rogue/beer/ratkept,      2, 8),
		list("Hagwood Bitter",        "Leaves a bitter finish. Medicinal, maybe.",                      /obj/item/reagent_containers/glass/bottle/rogue/beer/hagwoodbitter, 2, 8),
		list("Black Goat Stout",      "Thick enough to chew.",                                          /obj/item/reagent_containers/glass/bottle/rogue/beer/blackgoat,     2, 9),
		list("Gronnmead",             "Sweet mead, a northern favourite.",                              /obj/item/reagent_containers/glass/bottle/rogue/beer/gronnmead,     2, 10),
		list("Sourwine",              "It's wine. Mostly.",                                             /obj/item/reagent_containers/glass/bottle/rogue/wine/sourwine,      2, 12),
		list("Red Wine",              "You won't believe the story I have on how I got this. The maids were TERRIFIED.", /obj/item/reagent_containers/glass/bottle/rogue/redwine, 1, 18),
	)

	// -- Food --
	var/list/cat_food = list(
		list("Salted Cracker",        "Won't fill you up but it'll quiet your gut.",                    /obj/item/reagent_containers/food/snacks/rogue/crackerscooked,  3, 3),
		list("Bread Loaf",            "Rough but honest.",                                              /obj/item/reagent_containers/food/snacks/rogue/bread,           2, 4),
		list("Butter Slice",          "Something to put on the bread.",                                 /obj/item/reagent_containers/food/snacks/butterslice,           2, 2),
		list("Hard Boiled Egg",       "Filling. Smells.",                                               /obj/item/reagent_containers/food/snacks/egg,                   3, 2),
		list("Steak",                 "Cooked, barely. Good protein.",                                  /obj/item/reagent_containers/food/snacks/rogue/meat/steak,      1, 12),
		list("Sausage",               "What's in it? Don't ask.",                                       /obj/item/reagent_containers/food/snacks/rogue/meat/sausage,    2, 6),
		list("Gabagool",              "Etruscan, freshly off the caravan. We beat up like 5 wise guys for this.",               /obj/item/reagent_containers/food/snacks/rogue/meat/gabagool,   1, 60),
	)

	// -- Supplies --
	var/list/cat_supplies = list(
		list("Satchel",               "Short carry bag. Fits on your belt!",                            /obj/item/storage/backpack/rogue/satchel/short,                 1, 15),
		list("Satchel (Large)",       "Everyone should have this.",                                     /obj/item/storage/backpack/rogue/satchel,                       1, 20),
		list("Backpack",              "Carries more than it looks like it should.",                     /obj/item/storage/backpack/rogue/backpack,                      1, 30),
		list("Rope Belt Pouch",       "Loops on your waist. Keeps your hands free.",                     /obj/item/storage/belt/rogue/leather/rope,                      2, 8),
		list("Bandage Bundle",        "Full cloth bandages. Stops the bleeding.",                       /obj/item/natural/bundle/cloth/bandage/full,                    3, 5),
		list("Water Flask",           "Sealed waterskin. Holds a litre.",                               /obj/item/reagent_containers/glass/bottle/waterskin,            2, 5),
		list("Torch (Lamptern)",       "Oil lantern on a stick. Burns steady.",                          /obj/item/flashlight/flare/torch/lantern,                       2, 7),
		list("Mess Kit",              "Pot, bowl, spoon. Everything you need out there.",               /obj/item/storage/gadget/messkit,                               1, 8),
		list("Bedroll",               "Enough to sleep on hard ground.",                                /obj/item/bedroll,                                              1, 10),
		list("Smoke Bomb",            "Throws up a thick screen. Useful for exits.",                    /obj/item/bomb/smoke,                                           1, 20),
		list("Lockpick Ring",         "A loop of slim iron used to keep your lockpicks.",               /obj/item/lockpickring/mundane,                                 1, 35),
		list("Keyring",               "Keeps your keys from getting lost.",                             /obj/item/storage/keyring,                                      1, 10),
		list("Sewing Needle",         "Fine steel needle. Useful for more than sewing.",                /obj/item/needle,                                               2, 5),
	)

	// -- Light Weapons & Ammo --
	var/list/cat_weapons = list(
		list("Hunting Knife",         "Good steel. Good edge.",                                         /obj/item/rogueweapon/huntingknife/idagger/steel,               1, 25),
		list("Navaja",                "A folding blade. Fits in your sleeve.",                          /obj/item/rogueweapon/huntingknife/idagger/navaja,              1, 22),
		list("Katar",                 "Punch dagger. Fits the knuckles.",                               /obj/item/rogueweapon/katar/punchdagger,                        1, 30),
		list("Wood Staff",            "A solid walking stick. Also a weapon.",                          /obj/item/rogueweapon/woodstaff,                                1, 12),
		list("Quarterstaff",          "Balanced length. Versatile fighter's tool.",                     /obj/item/rogueweapon/woodstaff/quarterstaff,                   1, 18),
		list("Quiver",                "Holds arrows or bolts.",                                         /obj/item/quiver,                                               1, 5),
		list("Broadhead Arrows",      "Bundle of five iron-headed arrows.",                             /obj/item/ammo_casing/caseless/rogue/arrow/iron,                5, 8),
		list("Water Arrows",          "Bundle of five. Douses torches nicely.",                         /obj/item/ammo_casing/caseless/rogue/arrow/water,               5, 5),
		list("Crossbow Bolts",        "Bundle of five standard bolts.",                                 /obj/item/ammo_casing/caseless/rogue/bolt,                      5, 10),
	)

	// -- Heavy Weapons --
	var/list/cat_heavy = list(
		list("Arming Sword",          "Steel and well-balanced. Classic fighting blade.",               /obj/item/rogueweapon/sword,                                    1, 50),
		list("Short Sword",           "Quicker in close quarters.",                                     /obj/item/rogueweapon/sword/short,                              1, 50),
		list("Mace",                  "Simple iron head. Effective.",                                   /obj/item/rogueweapon/mace,                                     1, 30),
		list("Warhammer",             "A mean hammer. Breaks bones through armor.",                     /obj/item/rogueweapon/mace/warhammer,                           1, 30),
		list("Spear",                 "Iron-headed, long reach.",                                       /obj/item/rogueweapon/spear,                                    1, 30),
		list("Axe",                   "Steel blade, broad cut.",                                        /obj/item/rogueweapon/stoneaxe/woodcut/steel,                   1, 75),
		list("Flail",                 "Iron ball on a chain. Hurts knights like Hell.",                 /obj/item/rogueweapon/flail,                                    1, 40),
		list("Heater Shield",         "Medium iron shield. Takes a beating.",                           /obj/item/rogueweapon/shield/heater,                            1, 30),
		list("Knuckledusters",        "Iron-wrapped fists. No finesse required.",                       /obj/item/rogueweapon/knuckles,                                 1, 75),
	)

	// -- Ranged --
	var/list/cat_ranged = list(
		list("Regular Bow",           "Simple pull. Quiet and effective at range.",                     /obj/item/gun/ballistic/revolver/grenadelauncher/bow,            1, 10),
		list("Recurving Bow",         "Better pull weight, more range.",                                /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve,    1, 35),
	)

	// -- Potions --
	var/list/cat_potions = list(
		list("Red Elixir",            "Heals wounds. Tastes like lyfeblood.",                           /obj/item/reagent_containers/glass/bottle/rogue/healthpot,      1, 35),
		list("Blue Elixir",           "Restores mana. Smells faintly of energy.",                       /obj/item/reagent_containers/glass/bottle/rogue/manapot,        1, 25),
		list("Green Elixir",          "Boosts stamina. Worth every coin.",                              /obj/item/reagent_containers/glass/bottle/rogue/stampot,        1, 80),
		list("Antitoxin",             "Clears poison from the blood. Fast. Hopefully",                  /obj/item/reagent_containers/glass/bottle/rogue/antidote,       2, 10),
	)

	// -- Drugs & Smokes --
	var/list/cat_drugs = list(
		list("Pipeweed Zigarette",    "Mild. Takes the edge off.",                                      /obj/item/clothing/mask/cigarette/rollie/nicotine,              2, 10),
		list("Swampweed Zigarette",   "Stronger. Sourced from the Bog.",                                /obj/item/clothing/mask/cigarette/rollie/cannabis,              2, 15),
		list("Moon Dust",             "Powder. Effects vary. Highly sought after.",                     /obj/item/reagent_containers/powder/moondust,                   1, 50),
		list("Spice",                 "No questions. You know what this is for.",                       /obj/item/reagent_containers/powder/spice,                      1, 50),
	)

	// -- Utility --
	var/list/cat_utility = list(
		list("Prosthetic Arm (L)",    "Carved wood. Functional enough.",                                /obj/item/bodypart/l_arm/prosthetic/woodleft,                   1, 40),
		list("Prosthetic Arm (R)",    "Carved wood. Functional enough.",                                /obj/item/bodypart/r_arm/prosthetic/woodright,                  1, 40),
		list("Prosthetic Leg (L)",    "Peg leg. Gets you where you're going.",                          /obj/item/bodypart/l_leg/prosthetic,                            1, 15),
		list("Prosthetic Leg (R)",    "Peg leg. Gets you where you're going.",                          /obj/item/bodypart/r_leg/prosthetic,                            1, 15),
		list("Climbing Machine",      "Hooks, gears, cord. Goes up walls.",                             /obj/item/grapplinghook,                                        1, 250),
		list("Lockpick",              "A thin iron pick.",                                              /obj/item/lockpick,                                             2, 12),
		list("Lockpick (Gold)",       "Picks even tricky locks.",                                       /obj/item/lockpick/goldpin,                                     1, 60),
	)

	var/list/general_master = cat_drinks + cat_food + cat_supplies + cat_weapons + cat_heavy + cat_ranged + cat_potions + cat_drugs + cat_utility

	// =========================================================
	// GENERAL MERCHANDISE (Main Shop)
	// 25-35 slots drawn at random from the full master pool.
	// =========================================================
	var/list/shared_shuffled = shuffle(general_master.Copy())
	var/shared_take = rand(5, min(15, shared_shuffled.len))
	for(var/i = 1 to shared_take)
		var/entry = shared_shuffled[i]
		shared_pool += new /datum/underbelly_shop_item(entry[1], entry[2], entry[3], entry[4], entry[5])

	// =========================================================
	// TRADE GOODS: INGOTS
	// Each rolls independently. Higher cost = lower prob.
	// Format: name, desc, type, max_stock, cost, chance(%)
	// =========================================================
	var/list/ingot_pool = list(
		list("Iron Ingot",          "Raw worked iron. The backbone of any smithy.",           /obj/item/ingot/iron,          6, 7,  85),
		list("Steel Ingot",         "Refined and ready. Better edge, better everything.",     /obj/item/ingot/steel,         5, 10, 70),
		list("Gold Ingot",          "Heavy. Warm. Makes things happen.",                      /obj/item/ingot/gold,          3, 35, 45),
		list("Silver Ingot",        "Got a werewolf problem, friend? This should solve it.",  /obj/item/ingot/silver,        2, 45, 35),
		list("Blacksteel Ingot",    "Dark alloy. Rare. Don't ask where it's from.",           /obj/item/ingot/blacksteel,    1, 80, 18),
		list("Silver Bullion",      "Blessed and stamped. Kingsfield doesn't know it's gone.",/obj/item/ingot/silverblessed, 2, 85, 15),
	)
	for(var/entry in ingot_pool)
		if(prob(entry[6]))
			shared_pool += new /datum/underbelly_shop_item(entry[1], entry[2], entry[3], rand(1, entry[4]), entry[5])

	// =========================================================
	// STOLEN GEAR
	// Each rolls independently. Format: name, desc, type, max_stock, cost, chance(%)
	// =========================================================

	// -- Warden Helmets --
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
		list("Powder Flask",              "Holds a good charge of black powder. Keep it away from sparks.", /obj/item/powderflask,                                          3, 40, 60),
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
	// EXCLUSIVES - Role-locked only, 1 to 3 drawn per cycle.
	// Format: name, desc, type, stock, cost, flinger, role
	// =========================================================
	var/list/excl_master = list(
		list("The Gut Spillah",       "A Scum's favorite weapon. The backbone of a deal gone wrong. Modified and fabricated by my mates in Kingsfield.",  /obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller,      1, 500,  FALSE, "Scum"),
		list("The Venator",  "If you've got a message to send, this is the ticket. A bolt racked rifle capable of shooting thrice before needing a reload.",  /obj/item/gun/ballistic/firearm/flintgonne/venator,               1, 750,  FALSE, "Scum"),
		list("The Devastator",       "What the hell are you planning on taking down with this? Zizo? BAHAHA!",  /obj/item/gun/ballistic/firearm/devastator,                      1, 1000,  FALSE, "Scum"),
		list("Tipped Hat",         "Nobody's seeing that face. Nobody's knowing that name.",  /obj/item/clothing/head/roguetown/chaperon/flinger,            1, 120, FALSE, "Flinger"),
		list("Defacer",            "Knuckles that were hardened with ancient alloys and Steel. Hits harder, breaks faster.", /obj/item/rogueweapon/knuckles/defacer, 1, 85, FALSE, "Scum"),
		list("Suffocator",         "Load it with Zizo's bane, then press it onto an unguarded face. A moment's hesitation is all it needs.", /obj/item/clothing/mask/rogue/suffocator, 1, 200, FALSE, "Flesh Trader"),
		list("Golden Cockroach",   "Drop it on the floor of a vault and walk away. Don't ask how it works.", /obj/item/golden_cockroach, 1, 280, FALSE, null),
		list("Blood Red",          "Whatever's in this, it isn't wine. Don't let anyone drink it unless you want to watch them fold.", /obj/item/reagent_containers/glass/bottle/rogue/blood_red, 1, 150, FALSE, "Ripper"),
		list("Voss Serum",         "A pale little bottle. Slips into a drink without a trace. The body does the rest.", /obj/item/reagent_containers/glass/bottle/rogue/voss_serum, 2, 80, FALSE, "Ripper"),
		list("Mysterious Organ (II)",   "A pale graft sewn from something foreign. Heals well. You'll notice the shakes.", /obj/item/organ/mysterious/pale,      1, 160, FALSE, "Ripper"),
		list("Mysterious Organ (I)",  "A dried-up fragment. Less than the others, but it asks less in return.",          /obj/item/organ/mysterious/withered,   1, 80,  FALSE, "Ripper"),
		list("Mysterious Organ (III)", "A blackened mass. Heals everything. You'll sleep like the dead.",                 /obj/item/organ/mysterious/blackened,  1, 280, FALSE, "Ripper"),
		list("Reinforced Firing Pin",  "Hits harder. Fits any underbelly firearm. Apply it to the gun.", /obj/item/underbelly_upgrade/damage,    2, 120, FALSE, "Scum"),
		list("Baffled Powder Sleeve",  "No more smoke cloud after you fire. Apply it to the gun.",       /obj/item/underbelly_upgrade/silencer,  2, 150, FALSE, "Scum"),
		list("Extended Cylinder Plate","One more round in the chamber. Apply it to the gun.",            /obj/item/underbelly_upgrade/capacity,  2, 180, FALSE, "Scum"),
		list("Filed Sights",           "Tighter spread. Easier to put the ball where you want it. Apply it to the gun.", /obj/item/underbelly_upgrade/aim, 2, 130, FALSE, "Scum"),
	)
	var/list/excl_shuffled = shuffle(excl_master)
	for(var/i = 1 to min(rand(1, 3), excl_shuffled.len))
		var/entry = excl_shuffled[i]
		exclusive_pool += new /datum/underbelly_shop_item(entry[1], entry[2], entry[3], 1, entry[5], FALSE, entry[7])

	// =========================================================
	// FLINGER POOL - Independent re-roll from the same master.
	// =========================================================
	var/list/flinger_shuffled = shuffle(general_master.Copy())
	var/flinger_take = rand(10, min(20, flinger_shuffled.len))
	for(var/i = 1 to flinger_take)
		var/entry = flinger_shuffled[i]
		flinger_pool += new /datum/underbelly_shop_item(entry[1], entry[2], entry[3], entry[4], entry[5])
	for(var/entry in ingot_pool)
		if(prob(entry[6]))
			flinger_pool += new /datum/underbelly_shop_item(entry[1], entry[2], entry[3], rand(1, entry[4]), entry[5])
	for(var/entry in stolen_all)
		if(prob(entry[6]))
			flinger_pool += new /datum/underbelly_shop_item(entry[1], entry[2], entry[3], rand(1, entry[4]), entry[5])

	flinger_pool += new /datum/underbelly_shop_item( \
		"Dead Drop Contract", \
		"A written order for an off-the-books retrieval. Give it to someone outside the Scum; let them do the legwork. Bring the parcel back to The Trader and collect your cut.", \
		/obj/item/paper/scroll/dead_drop_contract, \
		1, \
		100, \
		TRUE, \
		null, \
		"deaddrop" \
	)

	flinger_pool += new /datum/underbelly_shop_item( \
		"Smuggler's Satchel", \
		"A dead drop container. Fill it, plant it anywhere with a code, and leave it for someone who knows where to look.", \
		/obj/item/storage/backpack/rogue/satchel/smuggler, \
		2, \
		75, \
		TRUE \
	)

	// =========================================================
	// SHIPMENTS - Bulk trade goods. 3-5 drawn per cycle.
	// Format: name, desc, type, stock, cost
	// Priced below Stockpile withdraw_price * 12 (minimum count).
	// =========================================================
	var/list/shipment_master = list(
		list("Iron Ore Shipment",    "A huge wrapped bundle of iron ore chunks. Cheaper in bulk.",         /obj/item/underbelly_shipment/iron_ore,   50),
		list("Coal Shipment",        "A huge wrapped bundle of coal. Fuel and alloying sorted.",            /obj/item/underbelly_shipment/coal,       40),
		list("Copper Ore Shipment",  "A huge wrapped bundle of copper ore chunks.",                         /obj/item/underbelly_shipment/copper_ore, 28),
		list("Tin Ore Shipment",     "A huge wrapped bundle of tin ore chunks.",                            /obj/item/underbelly_shipment/tin_ore,    40),
		list("Stone Shipment",       "A huge wrapped bundle of raw stones. Free rocks? Nearly.",            /obj/item/underbelly_shipment/stone,      8),
		list("Lumber Shipment",      "A huge wrapped bundle of short-cut logs. Ready to work.",             /obj/item/underbelly_shipment/wood,       28),
		list("Flour Shipment",       "A huge wrapped bundle of flour pouches. Bakers will pay well.",       /obj/item/underbelly_shipment/flour,      22),
		list("Grain Shipment",       "A huge wrapped bundle of spelt grain. Someone's breadbasket.",        /obj/item/underbelly_shipment/grain,      18),
		list("Seed Shipment",       "A huge wrapped bundle of wheat seeds. Plant a field's worth.",        /obj/item/underbelly_shipment/seeds,      18),
		list("Gabagool Shipment",   "A very carefully wrapped parcel. 2 to 5 inside. You don't ask questions about gabagool, wiseguy.",   /obj/item/underbelly_shipment/gabagool,  220),
	)
	var/list/shipment_shuffled = shuffle(shipment_master.Copy())
	for(var/i = 1 to min(rand(3, 5), shipment_shuffled.len))
		var/entry = shipment_shuffled[i]
		shipment_pool += new /datum/underbelly_shop_item(entry[1], entry[2], entry[3], rand(1, 3), entry[4])

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
		if(SI.exclusive_role && H.job != SI.exclusive_role && H.job != "Gutter King")
			continue
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

	var/list/shipment_data = list()
	for(var/datum/underbelly_shop_item/SI in shipment_pool)
		var/buy_count = purchase_counts["[H.ckey]_shipment_[SI.name]"] || 0
		shipment_data += list(list(
			"name" = SI.name,
			"desc" = SI.desc,
			"cost" = SI.cost,
			"stock" = SI.stock,
			"bought" = buy_count,
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
		"shipments" = shipment_data,
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

		if("buy_shipment")
			if(H.job != "Flinger")
				to_chat(H, span_warning("That's not for you."))
				return FALSE
			var/item_name = params["name"]
			var/datum/underbelly_shop_item/SI = locate_item(shipment_pool, item_name)
			if(!SI)
				return FALSE
			return do_purchase(H, SI, "[H.ckey]_shipment_[SI.name]", 99)

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
