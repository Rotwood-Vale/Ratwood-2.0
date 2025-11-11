/datum/crafting_recipe/roguetown/engineering
	abstract_type = /datum/crafting_recipe/roguetown/engineering

/datum/crafting_recipe/roguetown/engineering/coolingtable
	name = "cooling table"
	result = /obj/structure/table/cooling
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/ingot/iron = 1,
				/obj/item/roguegear/bronze = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/potionseller
	name = "potion seller peddler"
	result = /obj/structure/roguemachine/potionseller/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/ingot/iron = 1,
				/obj/item/natural/glass = 1,
				/obj/item/roguegear = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/lever
	name = "lever"
	result = /obj/structure/lever
	reqs = list(/obj/item/roguegear/bronze = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/engineering/trapdoor
	name = "floorhatch"
	result = /obj/structure/floordoor
	reqs = list(/obj/item/grown/log/tree/small = 1,
					/obj/item/roguegear/bronze = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 2

/datum/crafting_recipe/roguetown/engineering/bars
	name = "metal bars"
	result = /obj/structure/bars
	reqs = list(/obj/item/ingot/iron = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/engineering/shopbars
	name = "shop bars"
	result = /obj/structure/bars/shop
	reqs = list(/obj/item/ingot/iron = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/engineering/distiller
	name = "copper distiller"
	result = /obj/structure/fermentation_keg/distiller
	reqs = list(/obj/item/ingot/copper = 2, /obj/item/roguegear/bronze = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 2

/datum/crafting_recipe/roguetown/engineering/freedomchair
	name = "LIBERTAS"
	result = /obj/structure/chair/freedomchair/crafted
	reqs = list(/obj/item/ingot/gold = 1, /obj/item/roguegear/bronze = 3)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/passage
	name = "passage"
	result = /obj/structure/bars/passage
	reqs = list(/obj/item/ingot/iron = 1,
					/obj/item/roguegear/bronze = 1)
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
	reqs = list(/obj/item/ingot/iron = 1,
					/obj/item/roguegear = 1)
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

//crossbows, crossbow bolts, and specialized arrows and bolts
//adding in crossbows and bolts at a reduced cost and seeing if this upsets any balance. If it works I may add in other bows and arrows using planks
/datum/crafting_recipe/roguetown/engineering/crossbow
	name = "Crossbow"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	reqs = list(/obj/item/ingot/steel = 1, /obj/item/natural/fibers = 1, /obj/item/natural/wood/plank = 2)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3

/datum/crafting_recipe/roguetown/engineering/twentybolts
	name = "Crossbow Bolts 20x"
	reqs = list(/obj/item/natural/wood/plank = 3, /obj/item/ingot/iron)
	result = list(/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt
					)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3
	
//pyro arrow crafting, from stonekeep
/datum/crafting_recipe/roguetown/engineering/pyrobolt
	name = "pyroclastic bolt"
	result = /obj/item/ammo_casing/caseless/rogue/bolt/pyro
	reqs = list(/obj/item/ammo_casing/caseless/rogue/bolt = 1,
				/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 1)
	structurecraft = /obj/machinery/artificer_table
	craftdiff = 1
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/engineering/pyrobolt_five
	name = "pyroclastic bolt"
	result = list(
				/obj/item/ammo_casing/caseless/rogue/bolt/pyro,
				/obj/item/ammo_casing/caseless/rogue/bolt/pyro,
				/obj/item/ammo_casing/caseless/rogue/bolt/pyro,
				/obj/item/ammo_casing/caseless/rogue/bolt/pyro,
				/obj/item/ammo_casing/caseless/rogue/bolt/pyro
				)
	reqs = list(/obj/item/ammo_casing/caseless/rogue/bolt = 5,
				/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 5)
	structurecraft = /obj/machinery/artificer_table
	craftdiff = 1
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/engineering/pyroarrow
	name = "pyroclastic arrow"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/pyro
	reqs = list(/obj/item/ammo_casing/caseless/rogue/arrow/iron = 1,
				/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 1)
	structurecraft = /obj/machinery/artificer_table
	craftdiff = 1
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/engineering/pyroarrow_five
	name = "pyroclastic arrow"
	result = list(
				/obj/item/ammo_casing/caseless/rogue/arrow/pyro,
				/obj/item/ammo_casing/caseless/rogue/arrow/pyro,
				/obj/item/ammo_casing/caseless/rogue/arrow/pyro,
				/obj/item/ammo_casing/caseless/rogue/arrow/pyro,
				/obj/item/ammo_casing/caseless/rogue/arrow/pyro
				)
	reqs = list(/obj/item/ammo_casing/caseless/rogue/arrow/iron = 5,
				/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 5)
	structurecraft = /obj/machinery/artificer_table
	craftdiff = 1
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/structure/pressure_plate
	name = "pressure plate"
	result = /obj/structure/pressure_plate
	reqs = list(/obj/item/roguegear/bronze = 1, /obj/item/natural/wood/plank = 2)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/activator
	name = "engineer's launcher"
	result = /obj/structure/englauncher
	reqs = list(/obj/item/roguegear/bronze = 1, /obj/item/natural/wood/plank = 4, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

//rotational and minecart parts
/datum/crafting_recipe/roguetown/engineering/shaft
	name = "wooden shaft(4x)"
	category = "Rotational"
	result = list(/obj/item/rotation_contraption/shaft,
				  /obj/item/rotation_contraption/shaft,
				  /obj/item/rotation_contraption/shaft,
				  /obj/item/rotation_contraption/shaft)
	reqs = list(/obj/item/grown/log/tree/small = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	tools = list(/obj/item/rogueweapon/huntingknife = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/stickshaft
	name = "wooden shaft"
	category = "Rotational"
	result = list(/obj/item/rotation_contraption/shaft)
	reqs = list(/obj/item/grown/log/tree/stick = 2)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	tools = list(/obj/item/rogueweapon/huntingknife = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/cog
	name = "wooden cogwheel(2x)"
	category = "Rotational"
	result = list(/obj/item/rotation_contraption/cog,
				  /obj/item/rotation_contraption/cog)
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/roguegear/bronze = 2, /obj/item/grown/log/tree/stick = 2)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	tools = list(/obj/item/rogueweapon/huntingknife = 1)
	craftdiff = 4


/datum/crafting_recipe/roguetown/engineering/waterwheel
	name = "wooden waterwheel"
	category = "Rotational"
	result = /obj/item/rotation_contraption/waterwheel
	reqs = list(/obj/item/natural/wood/plank = 3, /obj/item/grown/log/tree/stick = 2)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	tools = list(/obj/item/rogueweapon/huntingknife = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/large_cog
	name = "large wooden cogwheel"
	category = "Rotational"
	result = /obj/item/rotation_contraption/large_cog
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/ingot/bronze = 1, /obj/item/grown/log/tree/stick = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	tools = list(/obj/item/rogueweapon/huntingknife = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/gearbox
	name = "gearbox"
	category = "Rotational"
	result = /obj/item/rotation_contraption/horizontal
	reqs = list(/obj/item/roguegear/bronze = 2, /obj/item/natural/stoneblock = 2,/obj/item/grown/log/tree/stick = 2)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/vertical_gearbox
	name = "vertical gearbox"
	category = "Rotational"
	result = /obj/item/rotation_contraption/vertical
	reqs = list(/obj/item/roguegear/bronze = 2, /obj/item/natural/stoneblock = 2, /obj/item/grown/log/tree/stick = 2)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/rails
	name = "minecart rails (10x)"
	category = "Minecarts"
	result = list(/obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail)
	reqs = list(/obj/item/natural/wood/plank = 5, /obj/item/ingot/iron = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3

/datum/crafting_recipe/roguetown/engineering/railbreak
	name = "minecart rail break (4x)"
	category = "Minecarts"
	result = list(/obj/item/rotation_contraption/minecart_rail/railbreak,
				  /obj/item/rotation_contraption/minecart_rail/railbreak,
				  /obj/item/rotation_contraption/minecart_rail/railbreak,
				  /obj/item/rotation_contraption/minecart_rail/railbreak)
	reqs = list(/obj/item/roguegear/bronze = 1, /obj/item/ingot/iron = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3


/datum/crafting_recipe/roguetown/engineering/minecart
	name = "minecart"
	category = "Minecarts"
	result = /obj/structure/closet/crate/miningcar
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/ingot/iron = 1, /obj/item/grown/log/tree/stick = 4, /obj/item/roguegear/bronze = 2)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4


// ------------ Craftable Traps ----------
//trying out adding in traps, we'll start with 3 of them. 



/datum/crafting_recipe/roguetown/engineering/sawbladetrap
	name = "saw blades trap"
	category = "traps"
	result = /obj/structure/trap/saw_blades
	reqs =  list(/obj/item/roguegear/bronze = 3, /obj/item/natural/clay = 2, /obj/item/roguegem/amethyst = 2, /obj/item/alch/irondust =1, /obj/item/natural/whetstone = 1)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 5

/datum/crafting_recipe/roguetown/engineering/flametrap
	name = "flame trap"
	category = "traps"
	result = /obj/structure/trap/flame
	reqs =  list(/obj/item/roguegear/bronze = 1, /obj/item/natural/clay = 2, /obj/item/roguegem/amethyst = 2, /obj/item/alch/irondust =1, /obj/item/alch/firedust =1)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 5

/datum/crafting_recipe/roguetown/engineering/shocktrap
	name = "shock trap"
	category = "traps"
	result = /obj/structure/trap/shock
	reqs =  list(/obj/item/roguegear/bronze = 1, /obj/item/natural/clay = 2, /obj/item/roguegem/amethyst = 2, /obj/item/alch/irondust =1, /obj/item/alch/magicdust =1)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 6
