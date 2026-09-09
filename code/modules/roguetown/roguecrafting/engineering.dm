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
				/obj/item/roguegear/bronze = 1)
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
	ignoredensity = TRUE
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/engineering/bars/cemetery
	name = "cemetery bars"
	result = /obj/structure/bars/cemetery
	reqs = list(/obj/item/ingot/iron = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	ignoredensity = TRUE
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 1

/datum/crafting_recipe/roguetown/engineering/shopbars
	name = "shop bars"
	result = /obj/structure/bars/shop
	reqs = list(/obj/item/ingot/iron = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	ignoredensity = TRUE
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/engineering/distiller
	name = "copper distiller"
	result = /obj/structure/fermentation_keg/distiller
	reqs = list(/obj/item/ingot/copper = 2, /obj/item/reagent_containers/glass/bucket/pot/stone = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 1 // so if above average int you can craft it without having to dedicate to artificering shit.

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
					/obj/item/roguegear/bronze = 1)
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

/datum/crafting_recipe/roguetown/engineering/slurbow
	name = "Slurbow"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
	reqs = list(/obj/item/ingot/steel = 2, /obj/item/natural/fibers = 1, /obj/item/natural/wood/plank = 4)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 5

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

/datum/crafting_recipe/roguetown/engineering/smokepowder
	name = "Smokepowder Flask"
	result = /obj/item/powderflask
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/alch/firedust = 2, /obj/item/alch/coaldust = 2)
	craftdiff = 4
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/engineering/minershelmet
	name = "reinforced miners helmet"
	result = /obj/item/clothing/head/roguetown/helmet/kettle/minershelm
	reqs = list(/obj/item/flashlight/flare/torch/lantern/bronzelamptern = 1, /obj/item/clothing/head/roguetown/articap = 1,/obj/item/roguegear/bronze = 1)
	craftdiff = 2
	structurecraft = /obj/machinery/artificer_table
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
	craftdiff = 4

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

/datum/crafting_recipe/roguetown/engineering/autogrinder
	name = "autogrinder"
	category = "Rotational"
	result = /obj/structure/autogrinder
	reqs = list(
		/obj/item/roguegear/bronze = 3,
		/obj/item/ingot/iron = 2,
		/obj/item/natural/wood/plank = 4,
		/obj/item/natural/stone = 4,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/windmill
	name = "windmill"
	result = /obj/structure/windmill
	reqs = list(
		/obj/item/natural/wood/plank = 4,
		/obj/item/natural/cloth = 2,
		/obj/item/grown/log/tree/stick = 2,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	tools = list(/obj/item/rogueweapon/huntingknife = 1)
	craftdiff = 4

//rotational and minecart parts
/datum/crafting_recipe/roguetown/engineering/shaft
	name = "wooden shaft(8x)"
	category = "Rotational"
	result = list(/obj/item/rotation_contraption/shaft,
				  /obj/item/rotation_contraption/shaft,
				  /obj/item/rotation_contraption/shaft,
				  /obj/item/rotation_contraption/shaft,
				  /obj/item/rotation_contraption/shaft,
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
	result = list(/obj/item/rotation_contraption/shaft,
				  /obj/item/rotation_contraption/shaft)
	reqs = list(/obj/item/grown/log/tree/stick = 2)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	tools = list(/obj/item/rogueweapon/huntingknife = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/cog
	name = "wooden cogwheel(x6)"
	category = "Rotational"
	result = list(/obj/item/rotation_contraption/cog, /obj/item/rotation_contraption/cog, /obj/item/rotation_contraption/cog, /obj/item/rotation_contraption/cog, /obj/item/rotation_contraption/cog, /obj/item/rotation_contraption/cog)
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/roguegear/wood/basic = 2, /obj/item/natural/wood/plank = 2)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	tools = list(/obj/item/rogueweapon/huntingknife = 1)
	craftdiff = 3


/datum/crafting_recipe/roguetown/engineering/waterwheel
	name = "wooden waterwheel (x2)"
	category = "Rotational"
	result = list(/obj/item/rotation_contraption/waterwheel, /obj/item/rotation_contraption/waterwheel)
	reqs = list(/obj/item/natural/wood/plank = 3)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	tools = list(/obj/item/rogueweapon/huntingknife = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/engineering/large_cog
	name = "large wooden cogwheel (3x)"
	category = "Rotational"
	result = list(/obj/item/rotation_contraption/large_cog, /obj/item/rotation_contraption/large_cog, /obj/item/rotation_contraption/large_cog)
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/roguegear/wood/basic = 2, /obj/item/natural/wood/plank = 4)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	tools = list(/obj/item/rogueweapon/huntingknife = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/engineering/gearbox
	name = "gearbox (2x)"
	category = "Rotational"
	result = list(/obj/item/rotation_contraption/horizontal, /obj/item/rotation_contraption/horizontal)
	reqs = list(/obj/item/roguegear/bronze = 2, /obj/item/natural/stoneblock = 2, /obj/item/natural/wood/plank = 2)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3

/datum/crafting_recipe/roguetown/engineering/vertical_gearbox
	name = "vertical gearbox (2x)"
	category = "Rotational"
	result = list(/obj/item/rotation_contraption/vertical, /obj/item/rotation_contraption/vertical)
	reqs = list(/obj/item/roguegear/bronze = 2, /obj/item/natural/stoneblock = 2, /obj/item/natural/wood/plank = 2)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3

/datum/crafting_recipe/roguetown/engineering/rails
	name = "minecart rails (x20)"
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
				  /obj/item/rotation_contraption/minecart_rail)
	reqs = list(/obj/item/natural/wood/plank = 5, /obj/item/ingot/iron = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3

/datum/crafting_recipe/roguetown/engineering/railbreak
	name = "minecart rail break (8x)"
	category = "Minecarts"
	result = list(/obj/item/rotation_contraption/minecart_rail/railbreak,
				  /obj/item/rotation_contraption/minecart_rail/railbreak,
				  /obj/item/rotation_contraption/minecart_rail/railbreak,
				  /obj/item/rotation_contraption/minecart_rail/railbreak,
				  /obj/item/rotation_contraption/minecart_rail/railbreak,
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
	craftdiff = 3


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

// ----------- Explosive grenades and gas belchers -----------
// Mostly here to avoid having to use spark-generating 6 step recipes around impact grenades and other instant explosives

/datum/crafting_recipe/roguetown/engineering/tntbomb
	name = "blastsand sticks (x3)"
	category = "Explosives"
	result = list(/obj/item/tntstick, /obj/item/tntstick, /obj/item/tntstick)
	reqs = list(/obj/item/paper = 3, /obj/item/alch/coaldust = 2, /obj/item/compost = 2, /obj/item/natural/fibers = 1)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3


/datum/crafting_recipe/roguetown/engineering/satchelbomb
	name = "blastsand satchel"
	category = "Explosives"
	result = /obj/item/satchel_bomb
	reqs = list(/obj/item/storage/backpack/rogue/satchel  = 1, /obj/item/tntstick = 3, /obj/item/alch/firedust = 1, /obj/item/natural/fibers = 1)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3

/datum/crafting_recipe/roguetown/engineering/impactexplosive
	name = "impact grenades (x3)"
	category = "Explosives"
	result = list(/obj/item/impact_grenade/explosion,
				  /obj/item/impact_grenade/explosion,
				  /obj/item/impact_grenade/explosion)
	reqs = list(/obj/item/natural/clay = 1, /obj/item/paper = 1, /obj/item/alch/coaldust = 1, /obj/item/alch/firedust = 1, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 1)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/signalflare
	name = "signal flare canister (x4)"
	category = "Ranged"
	result = list(/obj/item/signal_flare,
				  /obj/item/signal_flare,
				  /obj/item/signal_flare,
				  /obj/item/signal_flare)
	reqs = list(/obj/item/natural/clay = 1, /obj/item/paper = 1, /obj/item/alch/coaldust = 1, /obj/item/alch/firedust = 1, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 1)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3

/datum/crafting_recipe/roguetown/engineering/impactsmoke
	name = "smoke grenades (x3)"
	category = "Explosives"
	result = list(/obj/item/impact_grenade/smoke, 
				  /obj/item/impact_grenade/smoke,
				  /obj/item/impact_grenade/smoke,)
	reqs =  list(/obj/item/smokeshell = 3, /obj/item/alch/coaldust = 1, /obj/item/ash = 1, /datum/reagent/water = 48)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/impactpoisonsmoke
	name = "smoke grenades, poisonous (x3)"
	category = "Explosives"
	result = list(/obj/item/impact_grenade/smoke/poison_gas,
				  /obj/item/impact_grenade/smoke/poison_gas,
				  /obj/item/impact_grenade/smoke/poison_gas)
	reqs =  list(/obj/item/smokeshell = 3, /obj/item/alch/coaldust = 1, /obj/item/ash = 1, /datum/reagent/berrypoison = 5, /obj/item/alch/airdust = 1, /datum/reagent/water = 48)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/impactfiresmoke
	name = "smoke grenades, incendiary (x3)"
	category = "Explosives"
	result = list(/obj/item/impact_grenade/smoke/fire_gas,
				  /obj/item/impact_grenade/smoke/fire_gas,
				  /obj/item/impact_grenade/smoke/fire_gas)
	reqs =  list(/obj/item/smokeshell = 3, /obj/item/alch/coaldust = 2, /obj/item/ash = 1, /obj/item/alch/firedust = 1, /obj/item/alch/solardust = 1, /datum/reagent/water = 48)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/impactblindingsmoke
	name = "smoke grenades, blinding (x3)"
	category = "Explosives"
	result = list(/obj/item/impact_grenade/smoke/blind_gas,
				  /obj/item/impact_grenade/smoke/blind_gas,
				  /obj/item/impact_grenade/smoke/blind_gas)
	reqs =  list(/obj/item/smokeshell = 3, /obj/item/alch/coaldust = 1, /obj/item/ash = 1, /obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced = 1, /obj/item/natural/dirtclod = 1, /datum/reagent/water = 48)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/impactmutesmoke
	name = "smoke grenades, muting (x3)"
	category = "Explosives"
	result = list(/obj/item/impact_grenade/smoke/mute_gas,
				  /obj/item/impact_grenade/smoke/mute_gas,
				  /obj/item/impact_grenade/smoke/mute_gas)
	reqs =  list(/obj/item/smokeshell = 3, /obj/item/alch/coaldust = 1, /obj/item/ash = 1, /obj/item/alch/irondust = 1, /obj/item/rogueore/cinnabar = 1, /datum/reagent/water = 48)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/impacthealingsmoke
	name = "smoke grenades, healing (x3)"
	category = "Explosives"
	result = list(/obj/item/impact_grenade/smoke/healing_gas,
				  /obj/item/impact_grenade/smoke/healing_gas,
				  /obj/item/impact_grenade/smoke/healing_gas)
	reqs =  list(/obj/item/smokeshell = 3, /obj/item/alch/coaldust = 1, /obj/item/ash = 1, /obj/item/alch/viscera = 1, /obj/item/alch/bonemeal = 1, /datum/reagent/water = 48)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4 
//------------------ Mortar Shells --------------
// high explosive shells for the bombard

/datum/crafting_recipe/roguetown/engineering/highexplosiveimpact
	name = "high explosive impact, bombard charge"
	category = "Explosives"
	result = /obj/item/cannonball/explosive
	reqs = list(/obj/item/tntstick = 2, /obj/item/alch/coaldust = 1, /obj/item/paper = 4)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 5

/datum/crafting_recipe/roguetown/engineering/canistershotimpact
	name = "canister shot, bombard charge"
	category = "Explosives"
	result = /obj/item/cannonball/canister
	reqs = list(/obj/item/ammo_casing/caseless/bullet/grapeshot = 3, /obj/item/alch/coaldust = 1, /obj/item/paper = 4)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 5

/datum/crafting_recipe/roguetown/engineering/smokeimpact
	name = "smoke shell, bombard charge"
	category = "Explosives"
	result = /obj/item/cannonball/smoke
	reqs = list(/obj/item/bomb/smoke = 3, /obj/item/alch/coaldust = 1, /obj/item/paper = 4)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 5

/datum/crafting_recipe/roguetown/engineering/flareimpact
	name = "flare shell, bombard charge"
	category = "Explosives"
	result = /obj/item/cannonball/flare
	reqs = list(/obj/item/rogueore/cinnabar = 2, /obj/item/alch/coaldust = 1, /obj/item/paper = 4)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 5

/datum/crafting_recipe/roguetown/engineering/incendiaryimpact
	name = "incendiary shell, bombard charge"
	category = "Explosives"
	result = /obj/item/cannonball/incendiary
	reqs = list(/obj/item/alch/firedust = 2, /obj/item/alch/coaldust = 1, /obj/item/paper = 4)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 5

/datum/crafting_recipe/roguetown/engineering/ramrod
	name = "bombard ramrod"
	category = "Explosives"
	result = /obj/item/rogueweapon/woodstaff/quarterstaff/bombard_sponge
	reqs = list(/obj/item/rogueweapon/woodstaff/quarterstaff = 1, /obj/item/natural/cloth = 2)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 2

/datum/crafting_recipe/roguetown/engineering/palantir
	name = "bombard targeting palantir"
	category = "Explosives"
	result = /obj/item/rogueweapon/palantir
	reqs = list(/obj/item/roguegear/bronze = 2, /obj/item/ingot/bronze = 1, /obj/item/paper = 2, /obj/item/rogueore/cinnabar = 1)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 6 // self explanatory why
