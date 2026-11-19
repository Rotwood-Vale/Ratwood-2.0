// Deleted the flavorful desc from Vanderlin until I can think of a better desc.
/obj/item/recipe_book/leatherworking
	name = "The Tanned Hide Tome: Mastery of Leather and Craft"
	wiki_name = "Leatherworking"
	icon_state = "book8_0"
	base_icon_state = "book8"

	types = list(
	/datum/crafting_recipe/roguetown/tallow,
	/datum/crafting_recipe/roguetown/leather,
	)

/obj/item/recipe_book/sewing
	name = "Threads of Destiny: A Tailor's Codex"
	wiki_name = "Sewing"
	icon_state = "book7_0"
	base_icon_state = "book7"

	types = list(
		/datum/crafting_recipe/roguetown/survival/cloth, // Screw it just in case
		/datum/crafting_recipe/roguetown/sewing,
		)

/obj/item/recipe_book/blacksmithing
	name = "The Smith's Legacy"
	wiki_name = "Blacksmithing"
	icon_state = "book3_0"
	base_icon_state = "book3"

	types = list(/datum/anvil_recipe)

/obj/item/recipe_book/engineering
	name = "The Artificer's Handbook"
	wiki_name = "Engineering"
	icon_state = "book4_0"
	base_icon_state = "book4"

	types = list(
		/datum/crafting_recipe/roguetown/engineering,
		/datum/anvil_recipe/cannon,
		)

// I gave up I will make better names later lol
// Was gonna do a carpenter + masonry handbook but
// Both are under structures so I will just make them one and add categories
// Later
/obj/item/recipe_book/builder
	name = "The Builder's Handbook - For Carpenters and Masons"
	wiki_name = "Building"
	icon_state = "book5_0"
	base_icon_state = "book5"

	types = list(
		/datum/crafting_recipe/roguetown/structure,
		/datum/crafting_recipe/roguetown/turfs,

		/datum/crafting_recipe/roguetown/turfs/brick,
		/datum/crafting_recipe/roguetown/turfs/brick/floor,
		/datum/crafting_recipe/roguetown/turfs/brick/wall,
		/datum/crafting_recipe/roguetown/turfs/brick/window,

		/datum/crafting_recipe/roguetown/turfs/fancywindow,		
		/datum/crafting_recipe/roguetown/turfs/fancywindow/openclose,

		/datum/crafting_recipe/roguetown/turfs/hay,

		/datum/crafting_recipe/roguetown/turfs/reinforcedwindow,
		/datum/crafting_recipe/roguetown/turfs/reinforcedwindow/openclose,
		/datum/crafting_recipe/roguetown/turfs/roguewindow,
		/datum/crafting_recipe/roguetown/turfs/roguewindow/dynamic,
		/datum/crafting_recipe/roguetown/turfs/roguewindow/stone,

		/datum/crafting_recipe/roguetown/turfs/stone,
		/datum/crafting_recipe/roguetown/turfs/stone/cobblerock,
		/datum/crafting_recipe/roguetown/turfs/stone/cobble,
		/datum/crafting_recipe/roguetown/turfs/stone/block,
		/datum/crafting_recipe/roguetown/turfs/stone/newstone,
		/datum/crafting_recipe/roguetown/turfs/stone/herringbone,
		/datum/crafting_recipe/roguetown/turfs/stone/hexstone,
		/datum/crafting_recipe/roguetown/turfs/stone/platform,
		/datum/crafting_recipe/roguetown/turfs/stone/wall,
		/datum/crafting_recipe/roguetown/turfs/stone/brick,
		/datum/crafting_recipe/roguetown/turfs/stone/decorated,
		/datum/crafting_recipe/roguetown/turfs/stone/craft,
		/datum/crafting_recipe/roguetown/turfs/stone/window,

		/datum/crafting_recipe/roguetown/turfs/tentwall,
		/datum/crafting_recipe/roguetown/turfs/tentdoor,
		/datum/crafting_recipe/roguetown/turfs/twigplatform,
		/datum/crafting_recipe/roguetown/turfs/twig,

		/datum/crafting_recipe/roguetown/turfs/wood,
		/datum/crafting_recipe/roguetown/turfs/wood/floor,
		/datum/crafting_recipe/roguetown/turfs/wood/platform,
		/datum/crafting_recipe/roguetown/turfs/wood/wall,
		/datum/crafting_recipe/roguetown/turfs/wood/wall/alt,
		/datum/crafting_recipe/roguetown/turfs/wood/fancy,
		/datum/crafting_recipe/roguetown/turfs/wood/murderhole,
		/datum/crafting_recipe/roguetown/turfs/wood/murderhole/alt
		)

/obj/item/recipe_book/ceramics
	name = "The Potter's Handbook"
	wiki_name = "Ceramics"
	icon_state = "book5_0"
	base_icon_state = "book5"

	types = list(
		/datum/crafting_recipe/roguetown/structure/ceramicswheel,
		/datum/crafting_recipe/roguetown/ceramics
		)

// This book should be widely given to everyone
/obj/item/recipe_book/survival
	name = "The Survival Handbook"
	wiki_name = "Survival"
	desc = "A book full of recipes and tips for surviving in the wild. Can be used as fuel in a pinch."
	icon_state = "book6_0"
	base_icon_state = "book6"

	types = list(
		/datum/crafting_recipe/roguetown/survival,
		/datum/crafting_recipe/roguetown/tallow,
		)

// TBD - Cauldron Recipes
/obj/item/recipe_book/alchemy
	name = "Secrets of Alchemy"
	wiki_name = "Alchemy"
	icon_state = "book3_0"
	base_icon_state = "book3"

	types = list(
		/datum/crafting_recipe/roguetown/structure/alch,
		/datum/crafting_recipe/roguetown/structure/cauldronalchemy,
		/datum/crafting_recipe/roguetown/survival/mortar,
		/datum/crafting_recipe/roguetown/survival/pestle,
		/datum/crafting_recipe/roguetown/alchemy,
		/datum/alch_grind_recipe,
		/datum/alch_cauldron_recipe
		)

/obj/item/recipe_book/cooking
	name = "Guide to Brewing"
	wiki_name = "Brewing"
	desc = "A practical guide to brewing, distilling, bottling and selling drinks."
	icon_state = "book2_0"
	base_icon_state = "book2"

	types = list(
		/datum/brewing_recipe,
		/datum/book_entry/brewing
	)

/obj/item/recipe_book/cooking_guide
	name = "Guide to Cooking"
	wiki_name = "Cooking Guide"
	wiki_section = "Guides"
	wiki_order = 4
	desc = "A handwritten guide to ordinary kitchen work and recipes."
	icon_state = "book7_0"
	base_icon_state = "book7"
	types = list(/datum/book_entry/cooking)


/obj/item/recipe_book/magic
	name = "The Magister's Grimoire"
	wiki_name = "Magic"
	wiki_section = "Guides"
	wiki_order = 5
	icon_state = "book4_0"
	base_icon_state = "book4"

	types = list(
		/datum/book_entry/magic1,
		/datum/book_entry/magic2,
		/datum/crafting_recipe/roguetown/arcana,
		/datum/crafting_recipe/gemstaff,
		/datum/runeritual,
	)

/obj/item/recipe_book/cooking_recipes
	name = "Cooking Recipes"
	wiki_name = "Cooking Recipes"
	can_spawn = FALSE
	wiki_only = TRUE
	types = list(/datum/food_recipe, /datum/stew_recipe, /datum/crafting_recipe/roguetown/cooking)

/obj/item/recipe_book/economy
	name = "Economy"
	wiki_name = "Economy"
	wiki_section = "Guides"
	wiki_order = 1
	can_spawn = FALSE
	wiki_only = TRUE
	types = list(/datum/book_entry/treasury_general, /datum/book_entry/treasury_realm, /datum/book_entry/treasury_merchant, /datum/book_entry/treasury_underground)

/obj/item/recipe_book/getting_started
	name = "Getting Started"
	wiki_name = "Getting Started"
	wiki_section = "Guides"
	wiki_order = -1
	can_spawn = FALSE
	wiki_only = TRUE
	types = list(/datum/book_entry/getting_started)

/obj/item/recipe_book/gods
	name = "Gods"
	wiki_name = "Gods"
	wiki_section = "Guides"
	wiki_order = 2
	can_spawn = FALSE
	wiki_only = TRUE
	types = list(/datum/book_entry/gods)

/obj/item/recipe_book/lands
	name = "Lands"
	wiki_name = "Lands"
	wiki_section = "Guides"
	wiki_order = 3
	can_spawn = FALSE
	wiki_only = TRUE
	types = list(/datum/book_entry/lands)
