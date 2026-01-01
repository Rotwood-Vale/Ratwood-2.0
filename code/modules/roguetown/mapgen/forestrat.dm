/obj/effect/landmark/mapGenerator/rogue/forestrat
	mapGeneratorType = /datum/mapGenerator/forestrat
	endTurfX = 255
	endTurfY = 255
	startTurfX = 1
	startTurfY = 1


/datum/mapGenerator/forestrat
	modules = list(/datum/mapGeneratorModule/forestratnospawngrass, /datum/mapGeneratorModule/forestratnospawndirt, /datum/mapGeneratorModule/forestrat,/datum/mapGeneratorModule/forestratroad,/datum/mapGeneratorModule/forestratyellow)

/datum/mapGeneratorModule/forestratnospawngrass
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/rogue/grass)
	spawnableTurfs = list(/turf/open/floor/rogue/grass/nospawn = 40)
	allowed_areas = list(/area/rogue/outdoors/woodsrat)

/datum/mapGeneratorModule/forestratnospawndirt
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/rogue/dirt)
	spawnableTurfs = list(/turf/open/floor/rogue/dirt/nospawn = 40)
	allowed_areas = list(/area/rogue/outdoors/woodsrat)

/datum/mapGeneratorModule/forestrat
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/rogue/dirt,/turf/open/floor/rogue/grass, /turf/open/floor/rogue/grassred, /turf/open/floor/rogue/grassyel, /turf/open/floor/rogue/grasscold, /turf/open/floor/rogue/grassgrey)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/newtree = 1,
							/obj/structure/flora/roguetree/wise = 0.4,
							/obj/structure/flora/roguetree = 8,
							/obj/structure/flora/roguegrass/bush = 5,
							/obj/structure/flora/roguegrass = 10,
							/obj/structure/flora/roguegrass/herb/random = 3,
							/obj/structure/flora/roguegrass/bush/westleach = 2,
							/obj/structure/flora/roguegrass/maneater = 3,
							/obj/structure/flora/ausbushes/ppflowers = 0.4,
							/obj/structure/flora/ausbushes/ywflowers = 0.4,
							/obj/item/natural/stone = 3,
							/obj/item/natural/rock = 3,
							/obj/item/grown/log/tree/stick = 3,
							/obj/structure/flora/roguetree/stump/log = 4,
							/obj/structure/flora/roguetree/stump = 0.5,
							/obj/structure/closet/dirthole/closed/loot=1,
							/obj/structure/flora/roguegrass/maneater/real/juvenile=1,
							/obj/item/reagent_containers/food/snacks/smallrat = 0.3)
	spawnableTurfs = list(/turf/open/floor/rogue/dirt/road=2,
						/turf/open/water/swamp=1,)
	allowed_areas = list(/area/rogue/outdoors/woodsrat)

	
/datum/mapGeneratorModule/forestratyellow //southern forest more likely to have fyritus
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/rogue/grassred, /turf/open/floor/rogue/grassyel)
	spawnableAtoms = list(	/obj/structure/flora/roguegrass/pyroclasticflowers = 1.5,
							/obj/structure/flora/ausbushes/ppflowers = 0.7,
							/obj/structure/flora/ausbushes/ywflowers = 0.7,)
	allowed_areas = list(/area/rogue/outdoors/woodsrat)


/datum/mapGeneratorModule/forestratroad
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/item/natural/stone = 9,/obj/item/grown/log/tree/stick = 6)
	allowed_areas = list(/area/rogue/outdoors/woodsrat)
