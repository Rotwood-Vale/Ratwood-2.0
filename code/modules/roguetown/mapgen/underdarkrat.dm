/obj/effect/landmark/mapGenerator/rogue/underdarkrat
	mapGeneratorType = /datum/mapGenerator/underdarkrat
	endTurfX = 255
	endTurfY = 450
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/underdarkrat
	modules = list(/datum/mapGeneratorModule/underdarkratstone, /datum/mapGeneratorModule/underdarkratmud)


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
