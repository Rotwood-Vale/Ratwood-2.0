/obj/effect/landmark/mapGenerator/rogue/desert
	mapGeneratorType = /datum/mapGenerator/desert
	endTurfX = 380
	endTurfY = 310
	startTurfX = 1
	startTurfY = 1


/datum/mapGenerator/desert
	modules = list(/datum/mapGeneratorModule/desertsand, /datum/mapGeneratorModule/desertgrass,/datum/mapGeneratorModule/desertroad, /datum/mapGeneratorModule/desertwater)


/datum/mapGeneratorModule/desertsand
	clusterCheckFlags = CLUSTER_CHECK_ALL
	allowed_turfs = list(/turf/open/floor/rogue/dunes)
	// excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/roguetree/palm = 0.5,
							/obj/structure/flora/roguegrass/bush/desertshrub = 0.5,
							/obj/structure/flora/roguegrass = 0.5,
							/obj/structure/flora/roguetree/stump/log = 0.3,
							/obj/structure/flora/ausbushes/ppflowers = 0.1,
							/obj/structure/flora/ausbushes/ywflowers = 0.1,
							/obj/item/natural/stone = 1,
							/obj/item/natural/rock = 1,
							/obj/item/magic/artifact = 0.1,
							/obj/structure/leyline = 0.05,
							/obj/structure/voidstoneobelisk = 0.05,
							/obj/structure/flora/roguegrass/herb/manabloom = 0.05,
							/obj/item/magic/manacrystal = 0.05,
							/obj/structure/flora/roguegrass/herb/random = 0.5,
							/obj/effect/decal/remains/bear = 0.5,
							/obj/effect/decal/remains/human = 0.3,)
	// spawnableTurfs = list(/turf/open/floor/rogue/dirt/road=2,
	// 					/turf/open/water/swamp=2,)
	allowed_areas = list(/area/rogue/outdoors/desert, /area/rogue/outdoors/desertdeep)


/datum/mapGeneratorModule/desertgrass
	clusterCheckFlags = CLUSTER_CHECK_ALL
	allowed_turfs = list(/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/desert_grass)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/roguetree/palm = 5,
							/obj/structure/flora/roguegrass/bush/desertshrub = 4,
							/obj/structure/flora/newtreealt = 4,
							/obj/structure/flora/roguegrass = 3,
							/obj/structure/flora/roguetree/stump/log = 0.5,
							/obj/structure/flora/ausbushes/ppflowers = 0.1,
							/obj/structure/flora/ausbushes/ywflowers = 0.1,
							/obj/structure/flora/roguegrass/maneater = 0.5,
							/obj/structure/flora/roguegrass/maneater/real/juvenile = 0.5,
							/obj/item/natural/stone = 1,
							/obj/item/natural/rock = 1,
							/obj/item/magic/artifact = 0.2,
							/obj/structure/leyline = 0.1,
							/obj/structure/voidstoneobelisk = 0.1,
							/obj/structure/flora/roguegrass/herb/manabloom = 0.1,
							/obj/item/magic/manacrystal = 0.1,
							/obj/structure/closet/dirthole/closed/loot = 0.5,
							/obj/structure/flora/roguegrass/swampweed = 0.5,
							/obj/structure/flora/roguegrass/herb/random = 2,
							/obj/effect/decal/remains/bear = 0.5,
							/obj/effect/decal/remains/human = 0.3,
							/obj/structure/zizo_bane = 0.5,)
	// spawnableTurfs = list(/turf/open/floor/rogue/dirt/road=2,
	// 					/turf/open/water/swamp=2,)
	allowed_areas = list(/area/rogue/outdoors/desert, /area/rogue/outdoors/desertdeep)

/datum/mapGeneratorModule/desertroad
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/item/natural/stone = 2,/obj/item/grown/log/tree/stick = 1)
	allowed_areas = list(/area/rogue/outdoors/desert, /area/rogue/outdoors/desertdeep)

/datum/mapGeneratorModule/desertwater
	clusterCheckFlags = CLUSTER_CHECK_ALL
	allowed_turfs = list(/turf/open/water/cleanshallow)
	allowed_areas = list(/area/rogue/outdoors/desert, /area/rogue/outdoors/desertdeep)
	spawnableAtoms = list(	/obj/structure/flora/roguetree/stump/log = 1,
							/obj/structure/flora/ausbushes/reedbush = 1,
							/obj/structure/flora/roguegrass/water/reeds = 1,)

