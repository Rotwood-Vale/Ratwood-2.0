/obj/effect/landmark/mapGenerator/rogue/island
	mapGeneratorType = /datum/mapGenerator/island
	endTurfX = 200
	endTurfY = 200
	startTurfX = 1
	startTurfY = 1


/datum/mapGenerator/island
	modules = list(/datum/mapGeneratorModule/island,/datum/mapGeneratorModule/island/road, /datum/mapGeneratorModule/islandgrass)


/datum/mapGeneratorModule/island
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/desert_grass, /turf/open/floor/rogue/grass)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/newtreealt = 5,
							/obj/structure/flora/roguetree/palm = 3,
							/obj/structure/flora/roguetree/jungle = 0.1,
							/obj/structure/flora/roguetree/jungle/small = 3,
							/obj/structure/flora/roguegrass/bush/jungle = 2,
							/obj/structure/flora/roguegrass/bush/jungle/large = 8,
							/obj/structure/flora/roguegrass = 2,
							/obj/structure/flora/roguegrass/jungle = 6,
							/obj/structure/flora/roguegrass/maneater = 1,
							/obj/structure/flora/roguegrass/maneater/real = 1,
							/obj/item/natural/stone = 3,
							/obj/item/natural/rock = 3,
							/obj/item/grown/log/tree/stick = 3,
							/obj/structure/flora/roguegrass/herb/manabloom = 0.3,
							/obj/structure/flora/roguetree/stump/palm = 1.5,
							/obj/structure/glowshroom = 1.5,
							/obj/structure/flora/ausbushes/ppflowers = 0.4,
							/obj/structure/flora/ausbushes/ywflowers = 0.3,
							/obj/item/natural/stone = 3,
							/obj/item/natural/rock = 3,
							/obj/structure/flora/roguegrass/swampweed = 1,
							/obj/structure/flora/roguegrass/herb/random = 4,
							/obj/effect/decal/remains/bear = 0.5,
							/obj/effect/decal/remains/human = 0.2,)
	// spawnableTurfs = list(/turf/open/floor/rogue/dirt/road=5)
	allowed_areas = list(/area/rogue/outdoors/byos,/area/rogue/outdoors/rtfield,/area/rogue/outdoors/town/byos)

/datum/mapGeneratorModule/islandgrass
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/rogue/desert_grass, /turf/open/floor/rogue/grass)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/roguegrass = 4,
							/obj/structure/flora/roguegrass/jungle = 2,)
	allowed_areas = list(/area/rogue/outdoors/byos,/area/rogue/outdoors/rtfield,/area/rogue/outdoors/town/byos)
	
/datum/mapGeneratorModule/island/road
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/dirt/road)
	excluded_turfs = list()
	spawnableAtoms = list(/obj/item/natural/stone = 18,
							/obj/item/grown/log/tree/stick = 3)
	allowed_areas = list(/area/rogue/outdoors/byos,/area/rogue/outdoors/rtfield,/area/rogue/outdoors/town/byos)
