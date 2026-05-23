//drape
/obj/structure/drape/
	plane = -3

/obj/structure/drape/desert
	name = "desert drape"
	desc = "Made from durable fabric."
	icon = 'modular_deserttown/icons/drapes.dmi'
	icon_state = "desertdrape"

/datum/crafting_recipe/roguetown/structure/zybdrape
	name = "desert drape"
	result = /obj/structure/drape/desert
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 1
	ignoredensity = TRUE

/obj/structure/drape/zybantine
	name = "zybantine drape"
	desc = "Made from prestigious fabric."
	icon = 'modular_deserttown/icons/drapes.dmi'
	icon_state = "zybantinedrape1"
	color = "#a3a3a3"

/obj/structure/drape/zybantine/Initialize()
	. = ..()
	icon_state = "zybantinedrape[rand(1, 2)]"

/datum/crafting_recipe/roguetown/structure/zybdrapefancy
	name = "fancy zybantine drape"
	result = /obj/structure/drape/zybantine
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk= 2 )
	craftdiff = 4
	ignoredensity = TRUE
	wallcraft = TRUE

//cushion
/obj/item/cushion/desert1
	name = "desert cushion"
	icon = 'modular_deserttown/icons/cushions.dmi'
	icon_state = "desertcushion1"

/obj/item/cushion/desert2
	name = "desert cushion"
	icon = 'modular_deserttown/icons/cushions.dmi'
	icon_state = "desertcushion2"

/obj/item/cushion/zybantine
	name = "zybantine cushion"
	icon = 'modular_deserttown/icons/cushions.dmi'
	icon_state = "zybantinecushion"

/datum/crafting_recipe/roguetown/sewing/zybcushion1
	name = "desert cushion (yellow)"
	result = list(/obj/item/cushion/desert1)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/zybcushion2
	name = "desert cushion (grey)"
	result = list(/obj/item/cushion/desert2)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/zybcushionfancy
	name = "zybantine cushion"
	result = list(/obj/item/cushion/zybantine)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 4

//kegs

/// The original hierarchy for barrels and buckets is kind of messy, and I didn't want to refactor it all to have sane subtypes.


/obj/structure/fermentation_keg/sandpot
	name = "sand pot"
	desc = "A common clay pot used for storing and sometimes fermenting fluids. Favoured over wooden barrels in the desert of Zybantium due to the relative scarcity of wood."
	icon = 'modular_deserttown/icons/pots.dmi'
	icon_state = "sandpot1"

/datum/crafting_recipe/roguetown/structure/sandpot
	name = "sand pot"
	result = /obj/structure/fermentation_keg/sandpot
	reqs = list(/obj/item/natural/clay = 1)
	verbage_simple = "make"
	verbage = "makes"
	skillcraft = /datum/skill/craft/ceramics
	craftdiff = 1

/obj/structure/fermentation_keg/fancypot
	name = "fancy pot"
	desc = "Decorative and Practical!"
	icon = 'modular_deserttown/icons/pots.dmi'
	icon_state = "fancypot1"

/datum/crafting_recipe/roguetown/structure/fancypot
	name = "sand pot (fancy)"
	result = /obj/structure/fermentation_keg/fancypot
	reqs = list(/obj/item/natural/clay = 1)
	verbage_simple = "make"
	verbage = "makes"
	skillcraft = /datum/skill/craft/ceramics
	craftdiff = 3

/obj/item/reagent_containers/glass/bucket/tinypot
	name = "tiny pot"
	icon = 'modular_deserttown/icons/pots.dmi'
	icon_state = "tinypot1"

/datum/crafting_recipe/roguetown/structure/tinypot
	name = "small clay pot"
	result = /obj/item/reagent_containers/glass/bucket/tinypot
	reqs = list(/obj/item/natural/clay = 1)
	verbage_simple = "make"
	verbage = "makes"
	skillcraft = /datum/skill/craft/ceramics
	craftdiff = 2

/obj/structure/fermentation_keg/sandpot/Initialize()
	. = ..()
	icon_state = "sandpot[rand(1, 2)]"

/obj/structure/fermentation_keg/fancypot/Initialize()
	. = ..()
	icon_state = "fancypot[rand(1, 2)]"


// Subtypes for sandpots
/obj/structure/fermentation_keg/sandpot/random/water/Initialize()
	. = ..()
	icon_state = "sandpot1"
	reagents.add_reagent(/datum/reagent/water, rand(0,900))

/obj/structure/fermentation_keg/sandpot/random/beer/Initialize()
	. = ..()
	icon_state = "sandpot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer, rand(0,900))

/obj/structure/fermentation_keg/sandpot/random/wine/Initialize()
	. = ..()
	icon_state = "sandpot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine, rand(0,900))

/obj/structure/fermentation_keg/sandpot/water/Initialize()
	. = ..()
	icon_state = "sandpot1"
	reagents.add_reagent(/datum/reagent/water,900)

/obj/structure/fermentation_keg/sandpot/beer/Initialize()
	. = ..()
	icon_state = "sandpot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer,900)

/obj/structure/fermentation_keg/sandpot/wine/Initialize()
	. = ..()
	icon_state = "sandpot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine,900)


// Subtypes for fancypots
/obj/structure/fermentation_keg/fancypot/random/water/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/water, rand(0,900))

/obj/structure/fermentation_keg/fancypot/random/beer/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer, rand(0,900))

/obj/structure/fermentation_keg/fancypot/random/wine/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine, rand(0,900))

/obj/structure/fermentation_keg/fancypot/water/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/water,900)

/obj/structure/fermentation_keg/fancypot/beer/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer,900)

/obj/structure/fermentation_keg/fancypot/wine/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine,900)

///
/obj/machinery/light/rogue/campfire/fireplace/desert
	name = "desert fireplace"
	icon = 'modular_deserttown/icons/fireplace.dmi'
	icon_state = "fireplace1"
	base_state = "fireplace"
	fueluse = 0
	density = FALSE
	anchored = TRUE
	cookonme = FALSE

/datum/crafting_recipe/roguetown/structure/fireplace/desert
	name = "desert fireplace"
	result = /obj/machinery/light/rogue/campfire/fireplace/desert
	// reqs = list(/obj/item/grown/log/tree/small = 1,
	// 			/obj/item/natural/stoneblock = 3)
	// verbage_simple = "build"
	// verbage = "builds"
	// skillcraft = /datum/skill/craft/masonry
	// wallcraft = TRUE


///////////

/obj/structure/pillar
	name = "pillar"
	desc = ""
	icon = 'modular_deserttown/icons/sandpillar.dmi'
	opacity = 0
	max_integrity = 1000
	density = TRUE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	alpha = 255
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	static_debris = list(/obj/item/natural/stone = 10)
	layer = 4.82
	pixel_x = -16
	plane = GAME_PLANE_UPPER

	abstract_type = /obj/structure/pillar

/obj/structure/pillar/sand1
	icon_state = "sandpillar1"

/datum/crafting_recipe/roguetown/structure/pillar/desert
	name = "sandstone pillar"
	result = /obj/structure/pillar/sand1
	reqs = list(/obj/item/natural/stone = 2)
	verbage_simple = "builds"
	verbage = "builds"
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 4


////chairs

/obj/structure/chair/wood/zybantine
	name = "zybantine chair"
	icon = 'modular_deserttown/icons/chairs.dmi'
	icon_state = "zybantinechair"

/obj/structure/chair/wood/rogue/throne/zybantine
	name = "zybantine throne"
	icon_state = "zybantinethrone"
	icon = 'modular_deserttown/icons/throne.dmi'
	pixel_x = -16

/datum/crafting_recipe/roguetown/structure/chair/zyb
	name = "wooden chair"
	result = /obj/structure/chair/wood/zybantine
	reqs = list(/obj/item/grown/log/tree/small = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry


/obj/structure/chair/sofa
	name = "old ratty sofa"
	buildstackamount = 1
	item_chair = null

/obj/structure/chair/sofa/left
	icon_state = "sofaend_left"

/obj/structure/chair/sofa/right
	icon_state = "sofaend_right"

/obj/structure/chair/sofa/corner
	icon_state = "sofacorner"


/obj/structure/chair/zybantine_sofa/right
	name = "zybantine sofa"
	icon_state = "zybantinesofa_right"
	icon = 'modular_deserttown/icons/chairs.dmi'
	buildstackamount = 1
	item_chair = null

/obj/structure/chair/zybantine_sofa/left
	name = "zybantine sofa"
	icon_state = "zybantinesofa_left"
	icon = 'modular_deserttown/icons/chairs.dmi'
	buildstackamount = 1
	item_chair = null

//Sandrocks

/obj/structure/sandrock
	name = "sandrock"
	desc = "A large desert rock protuding from the ground."
	icon_state = "rock1"
	icon = 'modular_deserttown/icons/sandrock.dmi'
	opacity = 0
	max_integrity = 1000
	density = TRUE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	alpha = 255
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	static_debris = list(/obj/item/natural/stone = 10)
	pixel_x = -48
	pixel_y = -18
	layer = 4.81
	plane = GAME_PLANE_UPPER

	abstract_type = /obj/structure/sandrock

/obj/structure/sandrock/sandrock1
	icon_state = "sandrock1"

/obj/structure/sandrock/sandrock2
	icon_state = "sandrock2"

/obj/structure/sandrock/sandrock3
	icon_state = "sandrock3"

/obj/structure/sandrock/sandrock4
	icon_state = "sandrock4"

/obj/item/natural/rock/desert
	name = "sand rock"
	icon = 'modular_deserttown/icons/small_sandrock.dmi'
	icon_state = "sandrock1"

/obj/item/natural/rock/desert/Initialize()
	. = ..()
	icon_state = "sandrock[rand(1,2)]"


//bush

/obj/structure/flora/roguegrass/bush/desert
	name = "saigahorn"
	desc = ""
	icon = 'modular_deserttown/icons/flora.dmi'
	icon_state = "saigahorn1"

/obj/structure/flora/roguegrass/bush/desert/Initialize()
	. = ..()
	icon_state = "saigahorn[rand(1, 3)]"

/obj/structure/flora/roguegrass/bush/desertshrub
	name = "treelet"
	desc = "A rounded bush-like tree or perhaps tree-like bush native to Zybantium. A valuable source of wood in the sparse desert."
	icon = 'modular_deserttown/icons/flora.dmi'
	icon_state = "bushshrub1"
	attacked_sound = 'sound/misc/woodhit.ogg'
	max_integrity = 100
	debris = list(/obj/item/natural/fibers = 1, /obj/item/grown/log/tree/stick = 1, /obj/item/grown/log/tree/small = 1)

/obj/structure/flora/roguegrass/bush/desertshrub/Initialize()
	. = ..()
	icon_state = "bushshrub[pick(1,2)]"

/obj/structure/flora/roguetree/palm
	name = "palm tree"
	desc = "Scant, precious shade."
	icon = 'modular_deserttown/icons/bigpalm.dmi'
	icon_state = "palm1"
	stump_type = /obj/structure/flora/roguetree/stump/palm
	pixel_x = -32
	opacity = 0 //palm trees are skinny
	density = 0

/obj/structure/flora/roguetree/palm/Initialize()
	. = ..()
	icon_state = "palm[rand(1,2)]"

/obj/structure/flora/roguetree/stump/palm
	name = "tree stump"
	desc = "Shade no more."
	icon_state = "palmstump1"
	icon = 'modular_deserttown/icons/bigpalm.dmi'
	stump_type = null
	pixel_x = -32
	density = 0

/obj/structure/flora/roguetree/stump/palm/Initialize()
	. = ..()
	icon_state = "palmstump[rand(1,2)]"

/obj/structure/flora/roguegrass/bush/wall/tall/desert
	icon = 'modular_deserttown/icons/alt/foliagetall.dmi'

// /obj/structure/flora/roguegrass/bush/wall/tall/desert/Initialize()
// 	. = ..()
// 	icon_state = "tallbush[pick(1,2)]"

//Stairs

/obj/structure/stairs/desert
	name = "sand stairs"
	icon = 'modular_deserttown/icons/sandstairs.dmi'
	icon_state = "sandstairs"
	max_integrity = 600

//If we need to change the number of rooms
// /obj/structure/roguemachine/vendor/inndesert
// 	keycontrol = "tavern"

// /obj/structure/roguemachine/vendor/inndesert/Initialize()
// 	. = ..()

// 	// Add room keys with a price of 20
// 	for (var/X in list(/obj/item/roguekey/roomi, /obj/item/roguekey/roomii, /obj/item/roguekey/roomiii, /obj/item/roguekey/roomiv, /obj/item/roguekey/roomv))
// 		var/obj/P = new X(src)
// 		held_items[P] = list()
// 		held_items[P]["NAME"] = P.name
// 		held_items[P]["PRICE"] = 20

// 	// Add fancy keys with a price of 100
// 	for (var/Y in list(/obj/item/roguekey/fancyroomi, /obj/item/roguekey/fancyroomii, /obj/item/roguekey/fancyroomiii))
// 		var/obj/Q = new Y(src)
// 		held_items[Q] = list()
// 		held_items[Q]["NAME"] = Q.name
// 		held_items[Q]["PRICE"] = 100

// 	update_icon()

//weapons

/obj/structure/fluff/walldeco/customflag/deserttown
	name = "Al-Ashur flag"


/obj/item/rogueweapon/shield/iron/zybantine
	name = "brass shield"
	desc = "A sturdy shield of Zybantium make."
	icon = 'modular_deserttown/icons/items/desertweapons32.dmi'
	icon_state = "zybshield"
	max_integrity = 250
	blade_dulling = DULLING_BASH
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK, SHIELD_SMASH_METAL)
	sellprice = 30
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/woodstaff/riddle_of_steel/serpent
	name = "\improper Staff of the Serpent"
	desc = "A mysterious golden staff shaped like a snake. You could swear its staring at you"
	icon = 'modular_deserttown/icons/items/desertweapons64.dmi'
	icon_state = "snakestaff"


// /obj/item/rogueweapon/sword/long/kriegmesser/zybantine
// 	name = "heavy scimitar"
// 	desc = "A large zybantine sword with a single-edged blade, a crossguard and a knife-like hilt. "
// 	icon = 'modular_deserttown/icons/items/desertweapons64.dmi'
// 	icon_state = "Kmesser"

/obj/structure/fluff/traveltile/alashurentrance
	desc = "Awake from this dream. The road to Al-Ashur awaits."
	name = "To Al-Ashur"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "underworldportal"
