// \code\modules\roguetown\mapgen

/obj/effect/landmark/mapGenerator/rogue/desert
	mapGeneratorType = /datum/mapGenerator/desert
	endTurfX = 400
	endTurfY = 300
	startTurfX = 1
	startTurfY = 1


/datum/mapGenerator/desert
	modules = list(/datum/mapGeneratorModule/desert,/datum/mapGeneratorModule/bogratroad,/datum/mapGeneratorModule/bogratsand,/datum/mapGeneratorModule/bogratmire, /datum/mapGeneratorModule/bogratwater)


/datum/mapGeneratorModule/desert
	clusterCheckFlags = CLUSTER_CHECK_ALL
	allowed_turfs = list(/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/grass, /turf/open/floor/rogue/grassred, /turf/open/floor/rogue/grassyel, /turf/open/floor/rogue/grasscold, /turf/open/floor/rogue/grassgrey)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/newtree = 2,
							/obj/structure/flora/roguetree= 8,
							/obj/structure/flora/roguegrass/bush = 7,
							/obj/structure/flora/roguegrass = 10,
							/obj/structure/flora/roguegrass/maneater = 3,
							/obj/structure/flora/roguegrass/maneater/real/juvenile = 1.5,
							/obj/item/grown/log/tree/stick = 5,
							/obj/structure/flora/roguetree/stump/log = 7,
							/obj/structure/flora/roguetree/stump = 3,
							/obj/structure/glowshroom = 1.3,
							/obj/structure/flora/ausbushes/ppflowers = 0.5,
							/obj/structure/flora/ausbushes/ywflowers = 0.4,
							/obj/item/natural/stone = 4,
							/obj/item/natural/rock = 4,
							/obj/item/magic/artifact = 0.7,
							/obj/structure/leyline = 0.2,
							/obj/structure/voidstoneobelisk = 0.3,
							/obj/structure/flora/roguegrass/herb/manabloom = 0.4,
							/obj/item/magic/manacrystal = 0.4,
							/obj/structure/closet/dirthole/closed/loot = 2,
							/obj/structure/flora/roguegrass/swampweed = 1.5,
							/obj/structure/flora/roguegrass/herb/random = 5,
							/obj/structure/flora/rogueshroom = 1,
							/obj/effect/decal/remains/bear = 0.5,
							/obj/effect/decal/remains/human = 0.3,
							/obj/structure/zizo_bane = 0.5,)
	spawnableTurfs = list(/turf/open/floor/rogue/dirt/road=2,
						/turf/open/water/swamp=2,)
	allowed_areas = list(/area/rogue/outdoors/bograt)

/datum/mapGeneratorModule/bogratroad
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/item/natural/stone = 6,/obj/item/grown/log/tree/stick = 5)
	allowed_areas = list(/area/rogue/outdoors/bograt)

/datum/mapGeneratorModule/bogratsand
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/rogue/AzureSand)
	spawnableAtoms = list(/obj/item/natural/stone = 10, /obj/item/grown/log/tree/stick = 10,
	/obj/item/reagent_containers/food/snacks/fish/crab = 1, /obj/item/reagent_containers/food/snacks/fish/lobster = 1, /obj/item/reagent_containers/food/snacks/fish/oyster = 2)
	allowed_areas = list(/area/rogue/outdoors/bograt)

/datum/mapGeneratorModule/bogratmire//extra goodies and extra traps in the danger zone for intrepid travellers
	clusterCheckFlags =  CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/rogue/grassgrey, /turf/open/floor/rogue/dirt)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/bograt/sunken)
	spawnableAtoms = list(/obj/structure/glowshroom = 2,
							/obj/structure/flora/roguetree = 5,
							/obj/structure/flora/roguegrass/bush = 5,
							/obj/structure/flora/roguegrass = 10,
							/obj/structure/flora/roguegrass/maneater = 2,
							/obj/structure/flora/roguegrass/maneater/real/juvenile = 2,
							/obj/item/natural/stone = 10,
							/obj/item/natural/rock = 5,
							/obj/item/grown/log/tree/stick = 5,
							/obj/item/magic/artifact = 1,
							/obj/structure/leyline = 1,
							/obj/structure/voidstoneobelisk = 2,
							/obj/structure/flora/roguegrass/herb/manabloom = 2,
							/obj/item/magic/manacrystal = 2,
							/obj/item/grown/log/tree/stick = 5,
							/obj/structure/flora/roguetree/stump/log = 5,
							/obj/structure/flora/roguetree/stump = 5,
							/obj/structure/closet/dirthole/closed/loot = 5,
							/obj/structure/flora/roguegrass/swampweed = 5,
							/obj/structure/flora/roguegrass/herb/random = 10,
							/obj/structure/flora/rogueshroom = 3,
							/obj/effect/decal/remains/bear = 2,
							/obj/effect/decal/remains/human = 2,
							/obj/structure/zizo_bane = 3)
	spawnableTurfs = list(/turf/open/floor/rogue/dirt/road=3,
						/turf/open/water/swamp=3)

/datum/mapGeneratorModule/bogratwater
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_turfs = list(/turf/open/water/swamp)
	excluded_turfs = list(/turf/open/water/swamp/deep)
	allowed_areas = list(/area/rogue/outdoors/bograt)
	spawnableAtoms = list(/obj/structure/glowshroom = 5,
							/obj/item/restraints/legcuffs/beartrap/armed = 1,
							/obj/structure/flora/roguetree/stump/log = 10,
							/obj/structure/flora/roguetree = 10,
							/obj/structure/flora/ausbushes/reedbush = 20,
							/obj/structure/flora/roguegrass/water/reeds = 20,
							/obj/structure/zizo_bane = 3)
