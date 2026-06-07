/datum/crafting_recipe/roguetown/engineering
	abstract_type = /datum/crafting_recipe/roguetown/engineering

/datum/crafting_recipe/roguetown/engineering/coolingtable
	name = "cooling table"
	result = /obj/structure/table/cooling
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/ingot/iron = 1,
		/obj/item/roguegear/bronze = 1,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/potionseller
	name = "potion seller peddler"
	result = /obj/structure/roguemachine/potionseller/crafted
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/ingot/iron = 1,
		/obj/item/natural/glass = 1,
		/obj/item/roguegear/bronze = 1,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/engineering/peddlercart
	name = "peddler cart"
	result = /obj/structure/roguemachine/vendor/mobile
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/ingot/iron = 1,
		/obj/item/natural/glass = 1,
		/obj/item/roguegear/bronze = 2,
	)
	craftdiff = 4
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/engineering/lever
	name = "lever"
	result = /obj/structure/lever
	reqs = list(/obj/item/roguegear/bronze = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/engineering/trapdoor
	name = "wooden floorhatch"
	result = /obj/structure/floordoor
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/roguegear/bronze = 1,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 2

/datum/crafting_recipe/roguetown/engineering/trapdoor/TurfCheck(mob/user, turf/T)
	if(istype(T,/turf/open/transparent/openspace))
		return TRUE
	if(istype(T,/turf/open/lava))
		return FALSE
	return ..()

/datum/crafting_recipe/roguetown/engineering/floorgrille
	name = "floorgrille"
	result = /obj/structure/bars/grille
	reqs = list(
		/obj/item/ingot/iron = 1,
		/obj/item/roguegear/bronze = 1,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3

/datum/crafting_recipe/roguetown/engineering/floorgrille/TurfCheck(mob/user, turf/T)
	if(istype(T,/turf/open/transparent/openspace))
		return TRUE
	if(istype(T,/turf/open/lava))
		return FALSE
	return ..()

/datum/crafting_recipe/roguetown/engineering/bars
	name = "metal bars"
	result = /obj/structure/bars
	reqs = list(/obj/item/ingot/iron = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/engineering/shopbars
	name = "shop bars"
	result = /obj/structure/bars/shop
	reqs = list(/obj/item/ingot/iron = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/engineering/distiller
	name = "copper distiller"
	result = /obj/structure/fermentation_keg/distiller
	reqs = list(
		/obj/item/ingot/copper = 2,
		/obj/item/roguegear/bronze = 1,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 2

/datum/crafting_recipe/roguetown/engineering/freedomchair
	name = "LIBERTAS"
	result = /obj/structure/chair/freedomchair/crafted
	reqs = list(
		/obj/item/ingot/gold = 1,
		/obj/item/roguegear/bronze = 3,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/gate
	name = "gate"
	result = /obj/structure/bars/passage
	reqs = list(
		/obj/item/ingot/iron = 1,
		/obj/item/roguegear/bronze = 1,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 2

/datum/crafting_recipe/roguetown/engineering/passage/TurfCheck(mob/user, turf/T)
	if(istype(T,/turf/open/transparent/openspace))
		return FALSE
	if(istype(T,/turf/open/lava))
		return FALSE
	if(istype(T,/turf/open/water))
		return FALSE
	return ..()

/datum/crafting_recipe/roguetown/engineering/shutters
	name = "shutters"
	result = /obj/structure/bars/passage/shutter
	reqs = list(
		/obj/item/ingot/iron = 1,
		/obj/item/roguegear/bronze = 1,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 2

/datum/crafting_recipe/roguetown/engineering/shutters/TurfCheck(mob/user, turf/T)
	if(istype(T,/turf/open/transparent/openspace))
		return FALSE
	if(istype(T,/turf/open/lava))
		return FALSE
	if(istype(T,/turf/open/water))
		return FALSE
	return ..()

//Improvement items
/datum/crafting_recipe/roguetown/engineering/polishbrush
	name = "Polish Brush"
	result = /obj/item/armor_brush
	reqs = list(
		/obj/item/natural/fur = 1,
		/obj/item/natural/fibers = 1,
		/obj/item/natural/wood/plank = 1,
	)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/polishcream
	name = "Polish Cream"
	result = /obj/item/polishing_cream
	reqs = list(
		/obj/item/alch/irondust = 1,
		/obj/item/reagent_containers/powder/mineral = 1,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
	)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/crossbow
	name = "crossbow"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	reqs = list(
		/obj/item/ingot/steel = 1,
		/obj/item/natural/fibers = 1,
		/obj/item/natural/wood/plank = 2,
	)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3

/datum/crafting_recipe/roguetown/engineering/slurbow
	name = "Slurbow"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
	reqs = list(/obj/item/ingot/steel = 2, /obj/item/natural/fibers = 1, /obj/item/natural/wood/plank = 4)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 5

/datum/crafting_recipe/roguetown/engineering/twentybolts
	name = "crossbow bolt (x20)"
	reqs = list(
		/obj/item/natural/wood/plank = 3,
		/obj/item/ingot/iron = 1,
	)
	result = list(/obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt,
				/obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt,
				/obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt,
				/obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt,
				/obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt,
				/obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt,
				/obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt,
				/obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt,
				/obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt,
				/obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt)

	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3

/datum/crafting_recipe/roguetown/engineering/pressure_plate
	name = "pressure plate"
	result = /obj/structure/pressure_plate
	reqs = list(/obj/item/roguegear/bronze = 1, /obj/item/natural/wood/plank = 2)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 2

/datum/crafting_recipe/roguetown/engineering/activator
	name = "engineer's launcher"
	result = /obj/structure/englauncher
	reqs = list(
		/obj/item/roguegear/bronze = 1,
		/obj/item/natural/wood/plank = 4,
		/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = 1,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

//rotational and minecart parts
/datum/crafting_recipe/roguetown/engineering/shaft
	name = "wooden shaft (6x)"
	result = list(
		/obj/item/rotation_contraption/shaft,
		/obj/item/rotation_contraption/shaft,
		/obj/item/rotation_contraption/shaft,
		/obj/item/rotation_contraption/shaft,
		/obj/item/rotation_contraption/shaft,
		/obj/item/rotation_contraption/shaft,
	)
	reqs = list(/obj/item/grown/log/tree/small = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	tools = list(/obj/item/rogueweapon/huntingknife = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/stickshaft
	name = "wooden shaft"
	result = list(/obj/item/rotation_contraption/shaft)
	reqs = list(/obj/item/grown/log/tree/stick = 2)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	tools = list(/obj/item/rogueweapon/huntingknife = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/cog
	name = "wooden cogwheel(4x)"
	result = list(
		/obj/item/rotation_contraption/cog,
		/obj/item/rotation_contraption/cog,
		/obj/item/rotation_contraption/cog,
		/obj/item/rotation_contraption/cog,
	)
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/roguegear/bronze = 2,
		/obj/item/grown/log/tree/stick = 2,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	tools = list(/obj/item/rogueweapon/huntingknife = 1)
	craftdiff = 4


/datum/crafting_recipe/roguetown/engineering/waterwheel
	name = "wooden waterwheel (2x)"
	result = list(
		/obj/item/rotation_contraption/waterwheel,
		/obj/item/rotation_contraption/waterwheel,
	)
	reqs = list(
		/obj/item/natural/wood/plank = 3,
		/obj/item/grown/log/tree/stick = 2,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	tools = list(/obj/item/rogueweapon/huntingknife = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/large_cog
	name = "large wooden cogwheel (2x)"
	result = list(
		/obj/item/rotation_contraption/large_cog,
		/obj/item/rotation_contraption/large_cog,
	)
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/ingot/bronze = 1,
		/obj/item/grown/log/tree/stick = 1,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	tools = list(/obj/item/rogueweapon/huntingknife = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/gearbox
	name = "gearbox (2x)"
	result = list(
		/obj/item/rotation_contraption/horizontal,
		/obj/item/rotation_contraption/horizontal,
	)
	reqs = list(
		/obj/item/roguegear/bronze = 2,
		/obj/item/natural/stoneblock = 2,
		/obj/item/grown/log/tree/stick = 2,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/vertical_gearbox
	name = "vertical gearbox (2x)"
	result = list(
		/obj/item/rotation_contraption/vertical,
		/obj/item/rotation_contraption/vertical,
	)
	reqs = list(
		/obj/item/roguegear/bronze = 2,
		/obj/item/natural/stoneblock = 2,
		/obj/item/grown/log/tree/stick = 2,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/rails
	name = "minecart rails (20x)"
	result = list(
		/obj/item/rotation_contraption/minecart_rail,
		/obj/item/rotation_contraption/minecart_rail,
		/obj/item/rotation_contraption/minecart_rail,
		/obj/item/rotation_contraption/minecart_rail,
		/obj/item/rotation_contraption/minecart_rail,
		/obj/item/rotation_contraption/minecart_rail,
		/obj/item/rotation_contraption/minecart_rail,
		/obj/item/rotation_contraption/minecart_rail,
		/obj/item/rotation_contraption/minecart_rail,
		/obj/item/rotation_contraption/minecart_rail,
		/obj/item/rotation_contraption/minecart_rail,
		/obj/item/rotation_contraption/minecart_rail,
		/obj/item/rotation_contraption/minecart_rail,
		/obj/item/rotation_contraption/minecart_rail,
		/obj/item/rotation_contraption/minecart_rail,
		/obj/item/rotation_contraption/minecart_rail,
		/obj/item/rotation_contraption/minecart_rail,
		/obj/item/rotation_contraption/minecart_rail,
		/obj/item/rotation_contraption/minecart_rail,
		/obj/item/rotation_contraption/minecart_rail,
	)
	reqs = list(
		/obj/item/natural/wood/plank = 5,
		/obj/item/ingot/iron = 1,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3

/datum/crafting_recipe/roguetown/engineering/railbreak
	name = "minecart rail break (8x)"
	result = list(
		/obj/item/rotation_contraption/minecart_rail/railbreak,
		/obj/item/rotation_contraption/minecart_rail/railbreak,
		/obj/item/rotation_contraption/minecart_rail/railbreak,
		/obj/item/rotation_contraption/minecart_rail/railbreak,
		/obj/item/rotation_contraption/minecart_rail/railbreak,
		/obj/item/rotation_contraption/minecart_rail/railbreak,
		/obj/item/rotation_contraption/minecart_rail/railbreak,
		/obj/item/rotation_contraption/minecart_rail/railbreak,
	)
	reqs = list(
		/obj/item/roguegear/bronze = 1,
		/obj/item/ingot/iron = 1,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3


/datum/crafting_recipe/roguetown/engineering/minecart
	name = "minecart"
	result = /obj/structure/closet/crate/miningcar
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/ingot/iron = 1,
		/obj/item/grown/log/tree/stick = 4,
		/obj/item/roguegear/bronze = 2,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/roller
	name = "rollers (2x)"
	result = list(
		/obj/item/rotation_contraption/roller,
		/obj/item/rotation_contraption/roller,
	)
	reqs = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/grown/log/tree/stick = 4,
		/obj/item/roguegear/bronze = 2,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/smither
	name = "Autosmither"
	result = /obj/structure/autosmither
	reqs = list(
		/obj/item/roguegear/bronze = 4,
		/obj/item/ingot/steel = 2,
		/obj/item/natural/wood/plank = 4,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 5

/datum/crafting_recipe/roguetown/engineering/infernalengine
	name = "infernal engine"
	req_table = FALSE
	result = /obj/structure/infernalengine
	reqs = list(
		/obj/item/magic/infernal/core = 1,
		/obj/item/ingot/steel = 1,
	)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

// ------------ Explosives expansion----------
/datum/crafting_recipe/roguetown/engineering/tntbomb
	name = "blastpowder stick"
	result = /obj/item/tntstick
	reqs = list(
		/obj/item/paper = 2,
		/obj/item/alch/coaldust = 1,
		/obj/item/compost = 1,
		/obj/item/natural/fibers = 1,
	)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/satchelbomb
	name = "blastpowder satchel"
	result = /obj/item/satchel_bomb
	reqs = list(
		/obj/item/storage/backpack/rogue/satchel = 1,
		/obj/item/tntstick = 3,
		/obj/item/alch/firedust = 1,
		/obj/item/natural/fibers = 1,
	)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/impactexplosive
	name = "impact grenades (x3)"
	result = list(
		/obj/item/impact_grenade/explosion,
		/obj/item/impact_grenade/explosion,
		/obj/item/impact_grenade/explosion,
	)
	reqs = list(
		/obj/item/natural/clay = 1,
		/obj/item/paper = 1,
		/obj/item/alch/coaldust = 1,
		/obj/item/alch/firedust = 1,
		/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 1,
	)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/impactsmoke
	name = "smoke grenades (x3)"
	result = list(
		/obj/item/impact_grenade/smoke,
		/obj/item/impact_grenade/smoke,
		/obj/item/impact_grenade/smoke,
	)
	reqs = list(
		/obj/item/smokeshell = 3,
		/obj/item/alch/coaldust = 1,
		/obj/item/ash = 1,
		/datum/reagent/water = 48,
	)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/impactpoisonsmoke
	name = "smoke grenades, poisonous (x3)"
	result = list(
		/obj/item/impact_grenade/smoke/poison_gas,
		/obj/item/impact_grenade/smoke/poison_gas,
		/obj/item/impact_grenade/smoke/poison_gas,
	)
	reqs = list(
		/obj/item/smokeshell = 3,
		/obj/item/alch/coaldust = 1,
		/obj/item/ash = 1,
		/datum/reagent/berrypoison = 5,
		/obj/item/alch/airdust = 1,
		/datum/reagent/water = 48,
	)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/impactfiresmoke
	name = "smoke grenades, incendiary (x3)"
	result = list(
		/obj/item/impact_grenade/smoke/fire_gas,
		/obj/item/impact_grenade/smoke/fire_gas,
		/obj/item/impact_grenade/smoke/fire_gas,
	)
	reqs = list(
		/obj/item/smokeshell = 3,
		/obj/item/alch/coaldust = 2,
		/obj/item/ash = 1,
		/obj/item/alch/firedust = 1,
		/obj/item/alch/solardust = 1,
		/datum/reagent/water = 48,
	)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/impactblindingsmoke
	name = "smoke grenades, blinding (x3)"
	result = list(
		/obj/item/impact_grenade/smoke/blind_gas,
		/obj/item/impact_grenade/smoke/blind_gas,
		/obj/item/impact_grenade/smoke/blind_gas,
	)
	reqs = list(
		/obj/item/smokeshell = 3,
		/obj/item/alch/coaldust = 1,
		/obj/item/ash = 1,
		/obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced = 1,
		/obj/item/natural/dirtclod = 1,
		/datum/reagent/water = 48,
	)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/impactmutesmoke
	name = "smoke grenades, muting (x3)"
	result = list(
		/obj/item/impact_grenade/smoke/mute_gas,
		/obj/item/impact_grenade/smoke/mute_gas,
		/obj/item/impact_grenade/smoke/mute_gas,
	)
	reqs = list(
		/obj/item/smokeshell = 3,
		/obj/item/alch/coaldust = 1,
		/obj/item/ash = 1,
		/obj/item/alch/irondust = 1,
		/obj/item/rogueore/cinnabar = 1,
		/datum/reagent/water = 48,
	)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/impacthealingsmoke
	name = "smoke grenades, healing (x3)"
	result = list(
		/obj/item/impact_grenade/smoke/healing_gas,
		/obj/item/impact_grenade/smoke/healing_gas,
		/obj/item/impact_grenade/smoke/healing_gas,
	)
	reqs = list(
		/obj/item/smokeshell = 3,
		/obj/item/alch/coaldust = 1,
		/obj/item/ash = 1,
		/obj/item/alch/viscera = 2,
		/obj/item/alch/bonemeal = 2,
		/datum/reagent/water = 48,
	)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

// ------------ Craftable Traps ----------
//setting these up as a more "arcane" alternative to trap making done with engineering.

/datum/crafting_recipe/roguetown/engineering/rocktrap
	name = "rock trap (engineered)"
	result = /obj/structure/trap/rock_fall
	reqs = list(
		/obj/item/roguegear/bronze = 1,
		/obj/item/natural/clay = 1,
		/obj/item/roguegem/amethyst = 1,
		/obj/item/natural/rock = 1,
	)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/sawbladetrap
	name = "saw blades trap (engineered)"
	result = /obj/structure/trap/saw_blades
	reqs = list(
		/obj/item/roguegear/bronze = 2,
		/obj/item/natural/clay = 1,
		/obj/item/roguegem/amethyst = 1,
		/obj/item/natural/whetstone = 1,
	)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 5

/datum/crafting_recipe/roguetown/engineering/flametrap
	name = "flame trap (engineered)"
	result = /obj/structure/trap/flame
	reqs = list(
		/obj/item/roguegear/bronze = 1,
		/obj/item/natural/clay = 1,
		/obj/item/roguegem/amethyst = 1,
		/obj/item/alch/firedust = 1,
	)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 5

/datum/crafting_recipe/roguetown/engineering/shocktrap
	name = "shock trap (engineered)"
	result = /obj/structure/trap/shock
	reqs = list(
		/obj/item/roguegear/bronze = 1,
		/obj/item/natural/clay = 1,
		/obj/item/roguegem/amethyst = 1,
		/obj/item/alch/airdust = 1,
	)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 5

/datum/crafting_recipe/roguetown/engineering/bombtrap
	name = "bomb trap (engineered)"
	result = /obj/structure/trap/bomb
	reqs = list(
		/obj/item/roguegear/bronze = 1,
		/obj/item/natural/clay = 1,
		/obj/item/roguegem/amethyst = 1,
		/obj/item/impact_grenade/explosion = 1,
	)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 5
