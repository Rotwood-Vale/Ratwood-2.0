//This is used for the beast_mobs and monster_mobs tag, to spawn in monsters that do not have all the loot

//beast
/mob/living/simple_animal/hostile/rogue/deepone/quest
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/crab = 2, /obj/item/alch/viscera = 1)

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/quest
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf = 1,
						/obj/item/alch/sinew = 1,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 1,
						/obj/item/natural/bone = 1,
						/obj/item/natural/head/volf = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf = 2,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 1,
						/obj/item/natural/bone = 4,
						/obj/item/natural/head/volf = 1)

/mob/living/simple_animal/hostile/retaliate/rogue/mossback/quest
	botched_butcher_results = list (/obj/item/reagent_containers/food/snacks/rogue/meat/crab = 1, /obj/item/alch/viscera = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/crab = 2,
							/obj/item/alch/viscera = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/crab = 3,
									/obj/item/alch/viscera = 2)

/mob/living/simple_animal/hostile/retaliate/rogue/spider/mutated/quest
	botched_butcher_results = list(/obj/item/alch/viscera = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1)
	perfect_butcher_results = list (/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1,
							/obj/item/alch/viscera = 2)


/mob/living/simple_animal/hostile/retaliate/rogue/mole/quest
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1,
						/obj/item/natural/bone = 2,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 1,
						/obj/item/natural/head/mole = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
						/obj/item/natural/bone = 3,
						/obj/item/alch/sinew = 3,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 1,
						/obj/item/natural/head/mole = 1)

//monster
/mob/living/simple_animal/hostile/retaliate/rogue/troll/cave/quest
	del_on_deaggro = FALSE
	botched_butcher_results = list (
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1,
		/obj/item/alch/horn = 1
		)
	butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
		/obj/item/natural/bundle/bone/full = 1,
		/obj/item/alch/sinew = 2,
		/obj/item/alch/horn = 2,
		/obj/item/alch/viscera = 2
		)
	perfect_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 3,
		/obj/item/natural/bundle/bone/full = 1,
		/obj/item/alch/sinew = 3,
		/obj/item/alch/horn = 2,
		/obj/item/alch/viscera = 3,
		/obj/item/natural/head/troll/cave = 1
		)
/mob/living/simple_animal/hostile/retaliate/rogue/minotaur/axe/quest
	limb_destroyer = FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/lamia/quest
	health = 500
	maxHealth = 500
	del_on_deaggro = FALSE
	melee_damage_lower = 45
	melee_damage_upper = 60
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1,
						/obj/item/alch/sinew = 1,
						/obj/item/alch/bone = 1
						)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
						/obj/item/reagent_containers/food/snacks/fat = 1,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1
						)

/mob/living/simple_animal/hostile/retaliate/rogue/dragon/quest
	del_on_deaggro = FALSE
	botched_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
		/obj/item/natural/hide = 2,
		/obj/item/natural/bundle/bone/full = 4)
	butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 4,
		/obj/item/natural/hide = 4,
		/obj/item/natural/bundle/bone/full = 4,
		/obj/item/natural/head/dragon = 1)
	perfect_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 7, // More than troll. They are more difficult
		/obj/item/natural/hide = 7,
		/obj/item/natural/bundle/bone/full = 4,
		/obj/item/natural/head/dragon = 1)

/mob/living/simple_animal/hostile/retaliate/rogue/direbear/quest
	name = "hardened direbear"
	STACON = 15
	STASTR = 14
	STASPD = 11
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1,
									/obj/item/natural/bone = 2)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
									/obj/item/alch/sinew = 1,
									/obj/item/alch/bone = 1,
									/obj/item/alch/viscera = 2,
									/obj/item/natural/bone = 3)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 3,,
									/obj/item/alch/sinew = 2,
									/obj/item/alch/bone = 1,
									/obj/item/alch/viscera = 2,
									/obj/item/natural/bone = 4,
									/obj/item/natural/head/direbear = 1)