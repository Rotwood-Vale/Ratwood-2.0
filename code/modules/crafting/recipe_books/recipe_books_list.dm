// Deleted the flavorful desc from Vanderlin until I can think of a better desc.
/obj/item/recipe_book/leatherworking
	name = "The Tanned Hide Tome: Mastery of Leather and Craft"
	icon_state = "book8_0"
	base_icon_state = "book8"

	types = list(
	/datum/crafting_recipe/roguetown/tallow,
	/datum/crafting_recipe/roguetown/leather,
	)

/obj/item/recipe_book/sewing
	name = "Threads of Destiny: A Tailor's Codex"
	icon_state = "book7_0"
	base_icon_state = "book7"

	types = list(
		/datum/crafting_recipe/roguetown/survival/cloth, // Screw it just in case
		/datum/crafting_recipe/roguetown/sewing,
		)

/obj/item/recipe_book/blacksmithing
	name = "The Smith’s Legacy"
	icon_state = "book3_0"
	base_icon_state = "book3"

	types = list(/datum/anvil_recipe)

/obj/item/recipe_book/engineering
	name = "The Artificer's Handbook"
	icon_state = "book4_0"
	base_icon_state = "book4"

	types = list(/datum/crafting_recipe/roguetown/engineering)

// I gave up I will make better names later lol
// Was gonna do a carpenter + masonry handbook but
// Both are under structures so I will just make them one and add categories
// Later
/obj/item/recipe_book/builder
	name = "The Builder's Handbook - For Carpenters and Masons"
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
	icon_state = "book5_0"
	base_icon_state = "book5"

	types = list(
		/datum/crafting_recipe/roguetown/structure/ceramicswheel,
		/datum/crafting_recipe/roguetown/ceramics
		)

// This book should be widely given to everyone
/obj/item/recipe_book/survival
	name = "The Survival Handbook"
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
	name = "The Culinary Codex"
	desc = "A book full of recipes and tips for cooking. This version looks very incomplete, and only contain brewing recipes. Perhaps it will be filled in later?"
	icon_state = "book2_0"
	base_icon_state = "book2"

	types = list(
		/datum/brewing_recipe,
		/datum/book_entry/brewing
	)

/obj/item/recipe_book/magic
	name = "The Magister's Grimoire"
	icon_state = "book4_0"
	base_icon_state = "book4"

	types = list(
		/datum/book_entry/magic1,
		/datum/book_entry/magic2,
		/datum/crafting_recipe/roguetown/arcana,
		/datum/crafting_recipe/gemstaff,
		/datum/runeritual,
		/datum/book_entry/circuitus1,
		/datum/book_entry/circuitus2,
		/datum/book_entry/ego,
		/datum/book_entry/signum,
		/datum/book_entry/coordinatus,
		/datum/book_entry/inspicio,
		/datum/book_entry/locus,
		/datum/book_entry/prospectus,
		/datum/book_entry/res,
		/datum/book_entry/obiectum,
		/datum/book_entry/manus,
		/datum/book_entry/distantia,
		/datum/book_entry/linea,
		/datum/book_entry/addo,
		/datum/book_entry/removeo,
		/datum/book_entry/extraho,
		/datum/book_entry/additus,
		/datum/book_entry/subtractus,
		/datum/book_entry/effingo,
		/datum/book_entry/ruptis,
		/datum/book_entry/profundus,
		/datum/book_entry/si,
		/datum/book_entry/alioquin,
		/datum/book_entry/iteratio,
		/datum/book_entry/nulla,
		/datum/book_entry/unus,
		/datum/book_entry/duo,
		/datum/book_entry/tres,
		/datum/book_entry/quattuor,
		/datum/book_entry/quinque,
		/datum/book_entry/sex,
		/datum/book_entry/septem,
		/datum/book_entry/lista,
		/datum/book_entry/indicis,
		/datum/book_entry/lego,
		/datum/book_entry/inversus,
		/datum/book_entry/summa,
		/datum/book_entry/multiplicatio,
		/datum/book_entry/motus,
		/datum/book_entry/regio,
		/datum/book_entry/homines,
		/datum/book_entry/scribo,
		/datum/book_entry/ignis,
		/datum/book_entry/fulmen,
		/datum/book_entry/teleporto,
		/datum/book_entry/pondus,
		/datum/book_entry/reficio,
		/datum/book_entry/obmolior,
		/datum/book_entry/recolligere,
		/datum/book_entry/murus,
		/datum/book_entry/vis,
		/datum/book_entry/saxum,
		/datum/book_entry/festinatio,
		/datum/book_entry/oculi,
		/datum/book_entry/tenax,
		)
