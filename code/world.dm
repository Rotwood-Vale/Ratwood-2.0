//This file is just for the necessary /world definition
//Try looking in /code/game/world.dm, where initialization order is defined

/**
 * # World
 *
 * Two possibilities exist: either we are alone in the Universe or we are not. Both are equally terrifying. ~ Arthur C. Clarke
 *
 * The byond world object stores some basic byond level config, and has a few hub specific procs for managing hub visibility
 */
/world
	mob = /mob/dead/new_player
	turf = /turf/closed
	area = /area/rogue
	view = "15x15"
	hub = "Exadv1.spacestation13"
	name = "RATWOOD KEEP"
	fps = 20
#ifdef FIND_REF_NO_CHECK_TICK
	loop_checks = FALSE
#endif
