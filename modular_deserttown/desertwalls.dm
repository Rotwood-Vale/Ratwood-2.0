/turf/closed/wall/mineral/rogue/sandstone
	name = "sandstone wall"
	desc = "A wall of smooth, unyielding sandstone."
	icon = 'modular_deserttown/icons/sandstone.dmi'
	icon_state = "sand-stone"
	smooth = SMOOTH_MORE
	blade_dulling = DULLING_BASH
	max_integrity = 1800
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	canSmoothWith = list(/turf/closed/wall/mineral/rogue/sandstone)
	above_floor = /turf/open/floor/rogue/citybrick
	baseturfs = /turf/open/floor/rogue/citybrick
	neighborlay = "dirtedge"
	climbdiff = 3
	damage_deflection = 10
	hardness = 3


/turf/closed/wall/mineral/rogue/sandbrick
	name = "sandbrick wall"
	desc = "A wall of smooth, unyielding bricks."
	icon = 'modular_deserttown/icons/sandbrick_wall.dmi'
	icon_state = "sandbrick"
	smooth = SMOOTH_MORE
	blade_dulling = DULLING_BASH
	max_integrity = 1800
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	canSmoothWith = list(/turf/closed/wall/mineral/rogue/sandbrick)
	above_floor = /turf/open/floor/rogue/darkpath
	baseturfs = /turf/open/floor/rogue/darkpath
	neighborlay = "dirtedge"
	climbdiff = 3
	damage_deflection = 10
	hardness = 3

/turf/closed/mineral/rogue/sandstone
	name = "sandstone"
	desc = "Dusty, sand-blasted rock."
	icon = 'modular_deserttown/icons/rock.dmi'
	icon_state = "wallformed"
	smooth = SMOOTH_TRUE | SMOOTH_MORE
	smooth_icon = 'modular_deserttown/icons/rock.dmi'
	canSmoothWith = list(/turf/closed/mineral/random/rogue/sandstone, /turf/closed/mineral/rogue/sandstone)
	turf_type = /turf/open/floor/rogue/naturalstone
	baseturfs = /turf/open/floor/rogue/naturalstone

/turf/closed/mineral/rogue/bedrock/sandstone
	name = "sandstone"
	desc = "Seems barren and nigh-indestructable"
	icon = 'modular_deserttown/icons/rock.dmi'
	icon_state = "bedrock"
//	smooth_icon = 'icons/turf/walls/hardrock.dmi'
	above_floor = /turf/closed/mineral/rogue/bedrock

/turf/closed/mineral/random/rogue/sandstone
	name = "sandstone"
	desc = "Dusty, sand-blasted rock."
	icon = 'modular_deserttown/icons/rock.dmi'
	icon_state = "minlow"
	smooth = SMOOTH_TRUE | SMOOTH_MORE
	smooth_icon = 'modular_deserttown/icons/rock.dmi'
	canSmoothWith = list(/turf/closed/mineral/random/rogue/sandstone, /turf/closed/mineral/rogue/sandstone)
	turf_type = /turf/open/floor/rogue/naturalstone
	baseturfs = /turf/open/floor/rogue/naturalstone

/turf/closed/mineral/rogue/sandstone/gold
	icon_state = "mingold"
	mineralType = /obj/item/rogueore/gold
	rockType = /obj/item/natural/rock/gold
	spreadChance = 5
	spread = 1

/turf/closed/mineral/rogue/sandstone/silver
	icon_state = "mingold"
	mineralType = /obj/item/rogueore/silver
	rockType = /obj/item/natural/rock/silver
	spreadChance = 5
	spread = 1

/turf/closed/mineral/rogue/sandstone/salt
	icon_state = "mingold"
	mineralType = /obj/item/reagent_containers/powder/salt
	rockType = /obj/item/natural/rock/salt
	spreadChance = 33
	spread = 15

/turf/closed/mineral/rogue/sandstone/iron
	icon_state = "mingold"
	mineralType = /obj/item/rogueore/iron
	rockType = /obj/item/natural/rock/iron
	spreadChance = 23
	spread = 5

/turf/closed/mineral/rogue/sandstone/copper
	icon_state = "mingold"
	mineralType = /obj/item/rogueore/copper
	rockType = /obj/item/natural/rock/copper
	spreadChance = 27
	spread = 8

/turf/closed/mineral/rogue/sandstone/tin
	icon_state = "mingold"
	mineralType = /obj/item/rogueore/tin
	rockType = /obj/item/natural/rock/tin
	spreadChance = 15
	spread = 5

/turf/closed/mineral/rogue/sandstone/coal
	icon_state = "mingold"
	mineralType = /obj/item/rogueore/coal
	rockType = /obj/item/natural/rock/coal
	spreadChance = 33
	spread = 11

/turf/closed/mineral/rogue/sandstone/elementalmote //chance for elemental motes to drop, low, like with cinnabar
	icon_state = "mingold"
	mineralType = /obj/item/magic/elemental/mote
	rockType = /obj/item/natural/rock/elementalmote
	spreadChance = 23
	spread = 5

/turf/closed/mineral/rogue/sandstone/cinnabar
	icon_state = "mingold"
	mineralType = /obj/item/rogueore/cinnabar
	rockType = /obj/item/natural/rock/cinnabar
	spreadChance = 23
	spread = 5

/turf/closed/mineral/rogue/sandstone/gem
	icon_state = "mingold"
	mineralType = /obj/item/roguegem/random
	rockType = /obj/item/natural/rock/gem
	spreadChance = 3
	spread = 2

/turf/closed/mineral/random/rogue/sandstone/med
	icon_state = "minmed"
	mineralChance = 10
	mineralSpawnChanceList = list(
		/turf/closed/mineral/rogue/salt = 5,
		/turf/closed/mineral/rogue/gold = 3,
		/turf/closed/mineral/rogue/silver = 2,
		/turf/closed/mineral/rogue/iron = 33,
		/turf/closed/mineral/rogue/elementalmote = 15,
		/turf/closed/mineral/rogue/cinnabar = 15,
		/turf/closed/mineral/rogue/copper = 15,
		/turf/closed/mineral/rogue/tin = 10,
		/turf/closed/mineral/rogue/coal = 14,
		/turf/closed/mineral/rogue/gem = 1)

/turf/closed/mineral/random/rogue/sandstone/high
	icon_state = "minhigh"
	mineralChance = 33
	mineralSpawnChanceList = list(
		/turf/closed/mineral/rogue/elementalmote = 15,
		/turf/closed/mineral/rogue/cinnabar = 15,
		/turf/closed/mineral/rogue/salt = 5,
		/turf/closed/mineral/rogue/gold = 9,
		/turf/closed/mineral/rogue/silver = 5,
		/turf/closed/mineral/rogue/iron = 33,
		/turf/closed/mineral/rogue/copper = 20,
		/turf/closed/mineral/rogue/tin = 12,
		/turf/closed/mineral/rogue/coal = 19,
		/turf/closed/mineral/rogue/gem = 3)
