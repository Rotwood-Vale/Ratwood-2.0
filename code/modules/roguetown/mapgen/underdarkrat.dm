/obj/effect/landmark/mapGenerator/rogue/underdarkrat
	mapGeneratorType = /datum/mapGenerator/underdarkrat
	endTurfX = 255
	endTurfY = 450
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/underdarkrat
	modules = list(/datum/mapGeneratorModule/underdarkratstone, /datum/mapGeneratorModule/underdarkratmud, /datum/mapGeneratorModule/underdarkratscarymud, /datum/mapGeneratorModule/underdarkratscarystone)


/datum/mapGeneratorModule/underdarkratstone
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/naturalstone)
	allowed_areas = list(/area/rogue/under/underdark)
	spawnableAtoms = list(/obj/structure/flora/tinymushrooms = 20,
							/obj/structure/roguerock = 25,
							/obj/item/natural/rock = 25,
							/obj/structure/vine = 5)

/datum/mapGeneratorModule/underdarkratmud
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_areas = list(/area/rogue/under/underdark)
	allowed_turfs = list(/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/grasscold, /turf/open/floor/rogue/grasspurple)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/mushroomcluster = 20,
							/obj/structure/flora/roguegrass/thorn_bush = 10,
							/obj/structure/flora/rogueshroom/happy/random = 40,
							/obj/structure/flora/rogueshroom = 20,
							/obj/structure/flora/tinymushrooms = 20,
							/obj/structure/flora/roguegrass = 30,
							/obj/structure/flora/roguegrass/herb/random = 5)

/datum/mapGeneratorModule/underdarkratscarystone
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/naturalstone, /turf/open/floor/rogue/grasspurple)
	allowed_areas = list(/area/rogue/under/underdarker)
	spawnableAtoms = list(/obj/structure/flora/rogueshroom/unhappy/random = 30,
							/obj/structure/flora/rogueshroom/happy/random = 1,
							/obj/structure/flora/mushroomcluster/unhappy = 20,
							/obj/structure/flora/tinymushrooms/unhappy = 20,
							/obj/structure/roguerock = 25,
							/obj/item/natural/rock = 25,
							/obj/structure/vine = 5)

/datum/mapGeneratorModule/underdarkratscarymud
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_areas = list(/area/rogue/under/underdarker)
	allowed_turfs = list(/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/grasscold, /turf/open/floor/rogue/grasspurple)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/mushroomcluster = 20,
							/obj/structure/flora/roguegrass/thorn_bush = 10,
							/obj/structure/flora/rogueshroom/unhappy/random = 30,
							/obj/structure/flora/rogueshroom/happy/random = 1,
							/obj/structure/flora/mushroomcluster/unhappy = 20,
							/obj/structure/flora/tinymushrooms/unhappy = 20,
							/obj/structure/glowshroom = 2,
							/obj/structure/zizo_bane = 2,
							/obj/structure/flora/roguegrass = 30,
							/obj/structure/flora/roguegrass/herb/random = 5)
	spawnableTurfs = list(/turf/open/floor/rogue/grasspurple = 2)
