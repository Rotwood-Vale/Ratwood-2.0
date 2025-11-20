//genstuff
/obj/effect/landmark/mapGenerator/rogue/bograt
	mapGeneratorType = /datum/mapGenerator/bograt
	endTurfX = 255
	endTurfY = 400
	startTurfX = 1
	startTurfY = 1


/datum/mapGenerator/bograt
	modules = list(/datum/mapGeneratorModule/bograt,/datum/mapGeneratorModule/bogratroad,/datum/mapGeneratorModule/bogratgrass, /datum/mapGeneratorModule/bogratwater)


/datum/mapGeneratorModule/bograt
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/dirt)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/newtree = 30,
							/obj/structure/flora/roguegrass/bush = 15,
							/obj/structure/flora/roguegrass = 36,
							/obj/structure/flora/roguegrass/maneater = 10,
							/obj/structure/flora/roguegrass/maneater/real/juvenile = 5,
							/obj/structure/flora/ausbushes/ppflowers = 2,
							/obj/structure/flora/ausbushes/ywflowers = 2,
							/obj/item/natural/stone = 23,
							/obj/item/natural/rock = 6,
							/obj/item/magic/artifact = 4,
							/obj/structure/leyline = 1,
							/obj/structure/voidstoneobelisk = 1,
							/obj/structure/flora/roguegrass/herb/manabloom = 4,
							/obj/item/magic/manacrystal = 1,
							/obj/item/grown/log/tree/stick = 10,
							/obj/structure/flora/roguetree/stump/log = 3,
							/obj/structure/flora/roguetree/stump = 4,
							/obj/structure/glowshroom = 2,
							/obj/structure/closet/dirthole/closed/loot = 3,
							/obj/structure/flora/roguegrass/swampweed = 6,
							/obj/structure/flora/roguegrass/pyroclasticflowers = 2,
							/obj/structure/flora/roguegrass/bush/westleach = 5,
							/obj/structure/flora/roguegrass/herb/random = 10,
							/obj/structure/flora/rogueshroom = 5,
							/obj/effect/decal/remains/bear = 1,
							/obj/effect/decal/remains/human = 1,
							/obj/structure/zizo_bane = 3,)
	spawnableTurfs = list(/turf/open/floor/rogue/dirt/road=5,
						/turf/open/water/swamp=5,
						/turf/open/floor/rogue/grass = 40)
	allowed_areas = list(/area/rogue/outdoors/bograt)

/datum/mapGeneratorModule/bogratroad
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/item/natural/stone = 9,/obj/item/grown/log/tree/stick = 6)

/datum/mapGeneratorModule/bogratgrass
	clusterCheckFlags =  CLUSTER_CHECK_SAME_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/grass, /turf/open/floor/rogue/grassred, /turf/open/floor/rogue/grassyel, /turf/open/floor/rogue/grasscold, /turf/open/floor/rogue/grassgrey)
	excluded_turfs = list()
	allowed_areas = list(/area/rogue/outdoors/bograt)
	spawnableAtoms = list(/obj/structure/glowshroom = 2,
							/obj/structure/flora/roguetree = 60,
							/obj/structure/flora/roguetree/wise=1,
							/obj/structure/flora/roguegrass/bush = 20,
							/obj/structure/flora/roguegrass = 180,
							/obj/structure/flora/roguegrass/maneater = 10,
							/obj/structure/flora/roguegrass/maneater/real/juvenile = 5,
							/obj/item/natural/stone = 12,
							/obj/item/natural/rock = 5,
							/obj/item/grown/log/tree/stick = 6,
							/obj/structure/flora/roguetree/stump/log = 6)
	spawnableTurfs = list(/turf/open/floor/rogue/dirt/road=5,
						/turf/open/water/swamp=5,
						/turf/open/floor/rogue/dirt = 60)

/datum/mapGeneratorModule/bogratwater
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_turfs = list(/turf/open/water/swamp)
	excluded_turfs = list(/turf/open/water/swamp/deep)
	allowed_areas = list(/area/rogue/outdoors/bograt)
	spawnableAtoms = list(/obj/structure/glowshroom = 15,
							/obj/item/restraints/legcuffs/beartrap/armed = 1,
							/obj/structure/flora/roguetree/stump/log = 48,
							/obj/structure/flora/ausbushes/reedbush = 450,
							/obj/structure/flora/roguegrass/water/reeds = 240,
							/obj/structure/zizo_bane = 3)
