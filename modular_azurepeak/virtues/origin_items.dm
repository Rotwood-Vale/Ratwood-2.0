// Origin Items - items passed down or acquired during your youth
// These provide only items, no skills or traits
// Max selection: 1 heirloom

/datum/virtue/origin_items/tailors_kit
	name = "Tailor's Kit"
	desc = "I've kept a needle and scissors from my time learning the craft."
	category = "origin_items"
	virtue_cost = 4
	added_stashed_items = list(
		"Thorn Needle" = /obj/item/needle/thorn,
		"Scissors" = /obj/item/rogueweapon/huntingknife/scissors
	)

/datum/virtue/origin_items/medicine_pouch
	name = "Medicine Pouch"
	desc = "I've stashed away a pouch of medicinal supplies."
	category = "origin_items"
	virtue_cost = 4
	added_stashed_items = list("Medicine Pouch" = /obj/item/storage/belt/rogue/pouch/medicine)

/datum/virtue/origin_items/artificers_tools
	name = "Artificer's Tools"
	desc = "I've kept my hammer, chisel, and hand saw from my apprenticeship."
	category = "origin_items"
	virtue_cost = 4
	added_stashed_items = list(
		"Wooden Hammer" = /obj/item/rogueweapon/hammer/wood,
		"Chisel" = /obj/item/rogueweapon/chisel,
		"Hand Saw" = /obj/item/rogueweapon/handsaw
	)

/datum/virtue/origin_items/miners_equipment
	name = "Miner's Equipment"
	desc = "I've kept my trusty pickaxe and lamptern from my days in the mines."
	category = "origin_items"
	virtue_cost = 4
	added_stashed_items = list(
		"Iron Pickaxe" = /obj/item/rogueweapon/pick,
		"Lamptern" = /obj/item/flashlight/flare/torch/lantern
	)

/datum/virtue/origin_items/lockpick_ring
	name = "Lockpick Ring"
	desc = "I've acquired a ring of lockpicks through less-than-honorable means."
	category = "origin_items"
	virtue_cost = 4
	added_stashed_items = list("Lockpick Ring" = /obj/item/lockpickring/mundane)

/datum/virtue/origin_items/hunting_knife
	name = "Hunter's Kit"
	desc = "My hunting knife, rope for trapping, and a waterskin for long treks."
	category = "origin_items"
	virtue_cost = 4
	added_stashed_items = list(
		"Hunting Knife" = /obj/item/rogueweapon/huntingknife,
		"Rope" = /obj/item/rope,
		"Waterskin" = /obj/item/reagent_containers/glass/bottle/rogue/water
	)

/datum/virtue/origin_items/coinpurse
	name = "Weighty Coinpurse"
	desc = "Through luck or thrift, I've managed to save a mild sum."
	category = "origin_items"
	virtue_cost = 4
	added_stashed_items = list("Weighty Coinpurse" = /obj/item/storage/belt/rogue/pouch/coins/mid)

/datum/virtue/origin_items/firebombs
	name = "Volatile Mixtures"
	desc = "I've stashed away two dangerous firebombs."
	category = "origin_items"
	virtue_cost = 4
	added_stashed_items = list(
		"Firebomb #1" = /obj/item/bomb,
		"Firebomb #2" = /obj/item/bomb
	)

/datum/virtue/origin_items/squire_tools
	name = "Squire's Tools"
	desc = "My hammer and polishing tools from my failed knighthood training."
	category = "origin_items"
	virtue_cost = 5
	added_stashed_items = list(
		"Hammer" = /obj/item/rogueweapon/hammer/iron,
		"Polishing Cream" = /obj/item/polishing_cream,
		"Fine Brush" = /obj/item/armor_brush
	)

/datum/virtue/origin_items/writing_kit
	name = "Scholar's Writing Kit"
	desc = "A quill, scrolls, and book crafting materials for the educated."
	category = "origin_items"
	virtue_cost = 1
	added_stashed_items = list(
		"Quill" = /obj/item/natural/feather,
		"Scroll #1" = /obj/item/paper/scroll,
		"Scroll #2" = /obj/item/paper/scroll,
		"Book Crafting Kit" = /obj/item/book_crafting_kit
	)

/datum/virtue/origin_items/hand_mirror
	name = "Vanity Set"
	desc = "Luxuries from better days: a polished mirror, fine perfume, and soap."
	category = "origin_items"
	virtue_cost = 1
	added_stashed_items = list(
		"Hand Mirror" = /obj/item/handmirror,
		"Perfume" = /obj/item/perfume/lavender,
		"Fine Soap" = /obj/item/soap
	)

/datum/virtue/origin_items/saddle
	name = "Rider's Equipment"
	desc = "My riding equipment: a saddle, rope for tethering, and provisions."
	category = "origin_items"
	virtue_cost = 3
	added_stashed_items = list(
		"Saddle" = /obj/item/natural/saddle,
		"Rope" = /obj/item/rope,
		"Wine Bottle" = /obj/item/reagent_containers/glass/bottle/rogue/wine
	)

/datum/virtue/origin_items/thief_tools
	name = "Thief's Arsenal"
	desc = "Satchels for contraband and a concealed dagger."
	category = "origin_items"
	virtue_cost = 5
	added_stashed_items = list(
		"Satchel #1" = /obj/item/storage/backpack/rogue/satchel/mule,
		"Satchel #2" = /obj/item/storage/backpack/rogue/satchel/mule,
		"Dagger" = /obj/item/rogueweapon/huntingknife/idagger
	)

// Combined item sets for powerful heirlooms
/datum/virtue/origin_items/pilgrims_bundle
	name = "Pilgrim's Bundle"
	desc = "Everything needed to start anew: a hoe, food, and a knife."
	category = "origin_items"
	virtue_cost = 3
	added_stashed_items = list(
		"Hoe" = /obj/item/rogueweapon/hoe,
		"Bag of Food" = /obj/item/storage/roguebag/food,
		"Hunting Knife" = /obj/item/rogueweapon/huntingknife
	)
