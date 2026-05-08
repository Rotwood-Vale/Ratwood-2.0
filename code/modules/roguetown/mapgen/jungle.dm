/obj/effect/landmark/mapGenerator/rogue/jungle
	mapGeneratorType = /datum/mapGenerator/jungle
	endTurfX = 200
	endTurfY = 200
	startTurfX = 1
	startTurfY = 1


/datum/mapGenerator/jungle
	modules = list(/datum/mapGeneratorModule/jungle,/datum/mapGeneratorModule/jungleroad,/datum/mapGeneratorModule/junglesand, /datum/mapGeneratorModule/junglewater)

/datum/mapGeneratorModule/jungle
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/dirt/desert, /turf/open/floor/rogue/desert_grass, /turf/open/floor/rogue/grass, /turf/open/floor/rogue/grassred, /turf/open/floor/rogue/grassyel, /turf/open/floor/rogue/grasscold, /turf/open/floor/rogue/grassgrey)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/roguetree/palm = 4,
							/obj/structure/flora/roguetree/jungle = 1,
							/obj/structure/flora/roguetree/jungle/small = 2,
							/obj/structure/flora/roguegrass/bush/jungle = 3,
							/obj/structure/flora/roguegrass/bush/jungle/large = 10,
							/obj/structure/flora/roguegrass = 6,
							/obj/structure/flora/roguegrass/jungle = 6,
							/obj/structure/flora/roguegrass/maneater = 1,
							/obj/structure/flora/roguegrass/maneater/real = 2,
							/obj/item/grown/log/tree/stick = 4,
							/obj/structure/flora/roguetree/stump/palm = 1.5,
							/obj/structure/glowshroom = 1.5,
							/obj/structure/flora/ausbushes/ppflowers = 0.4,
							/obj/structure/flora/ausbushes/ywflowers = 0.3,
							/obj/item/natural/stone = 3,
							/obj/item/natural/rock = 3,
							/obj/item/magic/artifact = 0.2,
							/obj/structure/leyline = 0.15,
							/obj/structure/voidstoneobelisk = 0.12,
							/obj/structure/flora/roguegrass/herb/manabloom = 0.3,
							/obj/item/magic/manacrystal = 0.3,
							/obj/structure/flora/roguegrass/swampweed = 1,
							/obj/structure/flora/roguegrass/herb/random = 5,
							/obj/structure/flora/rogueshroom/unhappy = 1,
							/obj/structure/glowshroom = 1,
							/obj/effect/decal/remains/bear = 0.5,
							/obj/effect/decal/remains/human = 0.2)
	spawnableTurfs = list(/turf/open/floor/rogue/dirt/road=2,
						/turf/open/water/swamp=2,)
	allowed_areas = list(/area/rogue/outdoors/jungle)

/datum/mapGeneratorModule/jungleroad
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/item/natural/stone = 6,/obj/item/grown/log/tree/stick = 5)
	allowed_areas = list(/area/rogue/outdoors/jungle)

/datum/mapGeneratorModule/junglesand
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/rogue/AzureSand, /turf/open/floor/rogue/dunes)
	spawnableAtoms = list(/obj/item/natural/stone = 10, /obj/item/grown/log/tree/stick = 10,
	/obj/item/reagent_containers/food/snacks/fish/crab = 1, /obj/item/reagent_containers/food/snacks/fish/lobster = 1, /obj/item/reagent_containers/food/snacks/fish/oyster = 2)
	allowed_areas = list(/area/rogue/outdoors/jungle)

/datum/mapGeneratorModule/junglewater
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/water/swamp)
	excluded_turfs = list(/turf/open/water/swamp/deep)
	allowed_areas = list(/area/rogue/outdoors/jungle)
	spawnableAtoms = list(/obj/structure/glowshroom = 3,
							/obj/item/restraints/legcuffs/beartrap/armed = 0.5,
							/obj/structure/flora/ausbushes/reedbush = 5,
							/obj/structure/flora/roguegrass/water/reeds = 30,
							/obj/structure/zizo_bane = 1)
