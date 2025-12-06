//genstuff
/obj/effect/landmark/mapGenerator/rogue/bogold
	mapGeneratorType = /datum/mapGenerator/bogold
	endTurfX = 255
	endTurfY = 400
	startTurfX = 1
	startTurfY = 1


/datum/mapGenerator/bogold
	modules = list(/datum/mapGeneratorModule/bogoldgrassturf,/datum/mapGeneratorModule/bogold,/datum/mapGeneratorModule/bogoldroad,/datum/mapGeneratorModule/bogoldgrass)


/datum/mapGeneratorModule/bogold
	clusterCheckFlags = CLUSTER_CHECK_ALL_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/dirt)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/newtree = 20,
							/obj/structure/flora/roguegrass/bush = 15,
							/obj/structure/flora/roguegrass = 20,
							/obj/structure/flora/roguegrass/maneater = 10,
							/obj/structure/flora/roguegrass/pyroclasticflowers = 4,
							/obj/item/natural/stone = 5,
							/obj/item/natural/rock = 2,
							/obj/item/magic/artifact = 2,
							/obj/structure/leyline = 1,
							/obj/structure/voidstoneobelisk = 1,
							/obj/structure/manaflower = 2,
							/obj/item/magic/manacrystal = 1,
							/obj/item/grown/log/tree/stick = 16,
							/obj/structure/flora/roguetree/stump/log = 3,
							/obj/structure/flora/roguetree/stump = 4,
							/obj/structure/closet/dirthole/closed/loot=3,
							/obj/structure/flora/roguegrass/swampweed = 5,
							/obj/structure/flora/roguegrass/maneater/real=3,
							/obj/structure/flora/roguegrass/herb/random = 7,)
	spawnableTurfs = list(/turf/open/floor/rogue/dirt/road=2,
						/turf/open/water/swamp=1)
	allowed_areas = list(/area/rogue/outdoors/bog, /area/rogue/outdoors/rtfield)

/datum/mapGeneratorModule/bogoldroad
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/item/natural/stone = 9,/obj/item/grown/log/tree/stick = 6)

/datum/mapGeneratorModule/bogoldgrassturf
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/rogue/dirt)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableTurfs = list(/turf/open/floor/rogue/grass = 23)
	allowed_areas = list(/area/rogue/outdoors/bog)

/datum/mapGeneratorModule/bogratwater
	clusterCheckFlags = CLUSTER_CHECK_ALL_ATOMS
	allowed_turfs = list(/turf/open/water/swamp)
	excluded_turfs = list(/turf/open/water/swamp/deep)
	allowed_areas = list(/area/rogue/outdoors/bograt)
	spawnableAtoms = list(/obj/structure/glowshroom = 5,
							/obj/item/restraints/legcuffs/beartrap/armed = 0.5,
							/obj/structure/flora/roguetree/stump/log = 5,
							/obj/structure/flora/roguetree = 5,
							/obj/structure/flora/ausbushes/reedbush = 12,
							/obj/structure/flora/roguegrass/water/reeds = 12,
							/obj/structure/zizo_bane = 3)

/datum/mapGeneratorModule/bogoldgrass
	clusterCheckFlags = CLUSTER_CHECK_ALL_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/grass)
	excluded_turfs = list()
	allowed_areas = list(/area/rogue/outdoors/bog)
	spawnableAtoms = list(/obj/structure/glowshroom = 3,
							/obj/structure/flora/roguetree = 20,
							/obj/structure/flora/roguetree/wise=1,
							/obj/structure/flora/roguegrass/bush = 18,
							/obj/structure/flora/roguegrass = 30,
							/obj/structure/flora/roguegrass/maneater = 6,
							/obj/structure/flora/roguegrass/maneater/real=2,
							/obj/item/natural/stone = 4,
							/obj/item/natural/rock = 1,
							/obj/item/grown/log/tree/stick = 2,
							/obj/structure/flora/roguetree/stump/log = 2,
							/obj/structure/flora/roguegrass/herb/random = 6,)
