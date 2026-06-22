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
							/obj/structure/deadbodyrandom/low = 0.7,
							/obj/effect/decal/remains/bear = 0.3,
							/obj/structure/flora/roguegrass/desertgrass = 1)
	// spawnableTurfs = list(/turf/open/floor/rogue/dirt/road=2,
	// 					/turf/open/water/swamp=2,)
	allowed_areas = list(/area/rogue/outdoors/desert, /area/rogue/outdoors/desertdeep, /area/rogue/outdoors/town/grove)


/datum/mapGeneratorModule/desertgrass
	clusterCheckFlags = CLUSTER_CHECK_ALL
	allowed_turfs = list(/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/desert_grass)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/roguetree/palm = 5,
							/obj/structure/flora/roguegrass/bush/desertshrub = 4,
							/obj/structure/flora/newtreealt = 4,
							/obj/structure/flora/roguegrass/verdant = 5,
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
	allowed_areas = list(/area/rogue/outdoors/desert, /area/rogue/outdoors/desertdeep, /area/rogue/outdoors/town/grove)

/datum/mapGeneratorModule/desertroad
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/item/natural/stone = 2,/obj/item/grown/log/tree/stick = 1)
	allowed_areas = list(/area/rogue/outdoors/desert, /area/rogue/outdoors/desertdeep, /area/rogue/outdoors/town/grove)

/datum/mapGeneratorModule/desertwater
	clusterCheckFlags = CLUSTER_CHECK_ALL
	allowed_turfs = list(/turf/open/water/cleanshallow)
	allowed_areas = list(/area/rogue/outdoors/desert, /area/rogue/outdoors/desertdeep, /area/rogue/outdoors/town/grove)
	spawnableAtoms = list(	/obj/structure/flora/roguetree/stump/log = 1,
							/obj/structure/flora/roguegrass/reedbush = 1,
							/obj/structure/flora/roguegrass/water/reeds = 1,)


//////////////////////////////////////////////JUNGLE UNDERDARK

/obj/effect/landmark/mapGenerator/rogue/underdarkdesert
	mapGeneratorType = /datum/mapGenerator/underdarkdesert
	endTurfX = 380
	endTurfY = 310
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/underdarkdesert
	modules = list(/datum/mapGeneratorModule/underdarkdesertstone, /datum/mapGeneratorModule/underdarkdesertmud, /datum/mapGeneratorModule/underdarkdesertscarymud, /datum/mapGeneratorModule/underdarkdesertscarystone)


/datum/mapGeneratorModule/underdarkdesertstone
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/naturalstone)
	allowed_areas = list(/area/rogue/under/underdesert)
	spawnableAtoms = list(/obj/structure/flora/tinymushrooms = 20,
							/obj/structure/roguerock = 25,
							/obj/item/natural/rock = 25,
							/obj/structure/vine = 5)

/datum/mapGeneratorModule/underdarkdesertmud
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_areas = list(/area/rogue/under/underdesert)
	allowed_turfs = list(/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/grasscold, /turf/open/floor/rogue/grasspurple, /turf/open/floor/rogue/desert_grass)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/mushroomcluster = 20,
							/obj/structure/flora/roguegrass/thorn_bush = 10,
							/obj/structure/flora/rogueshroom/happy/random = 40,
							/obj/structure/flora/rogueshroom = 20,
							/obj/structure/flora/tinymushrooms = 20,
							/obj/structure/flora/roguegrass = 30,
							/obj/structure/flora/roguegrass/herb/random = 5,
							/obj/structure/flora/roguetree/jungle = 1,
							/obj/structure/flora/roguetree/jungle/small = 2,
							/obj/structure/flora/roguegrass/bush/jungle = 3,
							/obj/structure/flora/roguegrass/bush/jungle/large = 10,
							/obj/structure/flora/roguegrass/verdant = 6,
							/obj/structure/flora/roguegrass/maneater = 1,
							/obj/structure/flora/roguegrass/maneater/real = 2,
							/obj/item/grown/log/tree/stick = 4,
							/obj/structure/flora/shroomstump = 1.5,
							/obj/structure/glowshroom = 1.5,
							/obj/item/natural/stone = 3,
							/obj/item/natural/rock = 3,
							/obj/item/magic/artifact = 0.2,
							/obj/structure/leyline = 0.15,
							/obj/structure/voidstoneobelisk = 0.12,
							/obj/structure/flora/roguegrass/herb/manabloom = 0.3,
							/obj/item/magic/manacrystal = 0.3,
							/obj/structure/flora/roguegrass/swampweed = 1,
							/obj/structure/flora/rogueshroom/unhappy = 1,
							/obj/effect/decal/remains/bear = 0.5,
							/obj/structure/deadbodyrandom/all = 0.5)

/datum/mapGeneratorModule/underdarkdesertscarystone
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/naturalstone, /turf/open/floor/rogue/grasscold, /turf/open/floor/rogue/grasspurple)
	allowed_areas = list(/area/rogue/under/underdesert)
	spawnableAtoms = list(/obj/structure/flora/rogueshroom/unhappy/random = 30,
							/obj/structure/flora/rogueshroom/happy/random = 1,
							/obj/structure/flora/mushroomcluster/unhappy = 20,
							/obj/structure/flora/tinymushrooms/unhappy = 20,
							/obj/structure/roguerock = 25,
							/obj/item/natural/rock = 25,
							/obj/structure/vine = 5)

/datum/mapGeneratorModule/underdarkdesertscarymud
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_areas = list(/area/rogue/under/underdesert)
	allowed_turfs = list(/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/grasscold, /turf/open/floor/rogue/grasspurple, /turf/open/floor/rogue/desert_grass)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/mushroomcluster = 10,
							/obj/structure/flora/roguegrass/thorn_bush = 5,
							/obj/structure/flora/rogueshroom/unhappy/random = 20,
							/obj/structure/flora/rogueshroom/happy/random = 1,
							/obj/structure/flora/mushroomcluster/unhappy = 15,
							/obj/structure/flora/tinymushrooms/unhappy = 15,
							/obj/structure/glowshroom = 2,
							/obj/structure/zizo_bane = 2,
							/obj/structure/flora/roguegrass/verdant = 5,
							/obj/structure/flora/roguegrass/herb/random = 2)
	spawnableTurfs = list(/turf/open/floor/rogue/grasspurple = 2)
