// Example: Adding Alchemy Component to Non-Herb Items
// This file shows how to make items like onions usable in KCD alchemy

// Example 1: Adding component directly in the item definition
/obj/item/reagent_containers/food/snacks/grown/onion
	// Add this line to make onions usable in alchemy
	alchemy_component = new /datum/alchemy_component("onion", "#F5F5DC", "pungent onion", "sharp onion")

// Example 2: Adding component in Initialize() for more control
/obj/item/reagent_containers/food/snacks/grown/garlic/Initialize()
	. = ..()
	// Create alchemy component with all parameters
	alchemy_component = new /datum/alchemy_component(
		"garlic",                                    // herb_name
		"#FFFACD",                                  // herb_color
		"sharp garlic",                             // herb_smell
		"pungent garlic",                           // herb_taste
		/datum/alch_cauldron_recipe/str_potion,     // major_pot
		/datum/alch_cauldron_recipe/health_potion,  // med_pot
		/datum/alch_cauldron_recipe/antidote        // minor_pot
	)

// Example 3: Simple component with just name (for KCD alchemy only, no traditional potions)
/obj/item/reagent_containers/food/snacks/grown/carrot/Initialize()
	. = ..()
	alchemy_component = new /datum/alchemy_component("carrot")

/* 
Usage Notes:
1. Any item with an alchemy_component can be added to the cauldron
2. The component name is used for the product name (e.g., "onion tonic")
3. Color, smell, and taste can be customized per ingredient
4. Traditional potion recipes (major/med/minor_pot) are optional
5. If only using KCD alchemy, you only need to provide the name

Constructor Parameters (all optional except herb_name when called directly):
- herb_name: Display name used in product names
- herb_color: Color code (hex) for the herb
- herb_smell: Smell description
- herb_taste: Taste description
- major_pot: Recipe path for major potion (3 points)
- med_pot: Recipe path for medium potion (2 points)
- minor_pot: Recipe path for minor potion (1 point)
*/
