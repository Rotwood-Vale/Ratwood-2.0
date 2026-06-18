// ============================================================================
// Crafting recipe for the Terror Clock (恐怖之钟).
// Construction method (per spec): 1x steel, built from the "Universal" (通用)
// tab of the craft menu. We inherit /datum/crafting_recipe/roguetown/structure
// so the engine handles placing the result as a structure on a tile in front of
// the crafter (TurfCheck, anti-water/openspace placement, etc.).
// This file lives ONLY under modular_z121, as required.
// ============================================================================
/datum/crafting_recipe/roguetown/structure/terror_clock
	// Display name shown in the craft menu (Chinese, matching the fork).
	name = "恐怖之钟"
	// The object produced and placed on the world when the craft succeeds.
	result = /obj/structure/terror_clock
	// Ingredient list: exactly one steel ingot is consumed, as specified.
	reqs = list(/obj/item/ingot/steel = 1)
	// Place it in the "通用"(Universal) category -> the universal interface tab.
	category = "通用"
	// always_availible = TRUE means no recipe needs to be learned first, so the
	// entry is visible to everyone directly inside that universal interface.
	always_availible = TRUE
	// A flat, accessible build: no skill gate and zero difficulty penalty so the
	// craft cannot randomly fail and waste the (relatively costly) steel.
	skillcraft = null
	craftdiff = 0
	// Verbs used in the "<user> builds the Terror Clock" feedback messages.
	verbage_simple = "制作"
	verbage = "制作"
