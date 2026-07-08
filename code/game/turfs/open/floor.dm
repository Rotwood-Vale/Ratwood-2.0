/turf/open/floor
	//NOTE: Floor code has been refactored, many procs were removed and refactored
	//- you should use istype() if you want to find out whether a floor has a certain type
	//- floor_tile is now a path, and not a tile obj
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	baseturfs = /turf/baseturf_openspace

	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

	var/icon_regular_floor = "floor" //used to remember what icon the tile should have by default
	var/icon_plating = "plating"

	intact = 1
	var/broken = 0
	var/burnt = 0
	var/floor_tile = null //tile that this floor drops
	var/list/broken_states
	var/list/burnt_states

	///the chance this turf has to spread, basically 3% by default
	spread_chance = 3
	///means fires last at base 15 seconds
	burn_power = 15

	tiled_dirt = TRUE

	var/heat = 0
	var/list/heat_sources

GLOBAL_LIST_EMPTY(hot_floors)
GLOBAL_LIST_EMPTY(heat_source_floors)
GLOBAL_VAR_INIT(heat_ticking, FALSE)
GLOBAL_VAR_INIT(heat_count, 0)

/proc/start_heat_ticking()
	if(GLOB.heat_ticking)
		return
	GLOB.heat_ticking = TRUE
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(heat_tick)), 2 SECONDS)

/turf/open/floor/proc/set_heat(new_heat)
	new_heat = clamp(new_heat, 0, 5)
	if(heat == new_heat)
		return
	heat = new_heat
	GLOB.hot_floors[src] = TRUE
	for(var/D in GLOB.cardinals)
		var/turf/open/floor/T = get_step(src, D)
		if(isfloorturf(T))
			GLOB.hot_floors[T] = TRUE
	start_heat_ticking()

/turf/open/floor/proc/add_heat_source(obj/O, source_heat)
	if(!heat_sources)
		heat_sources = list()
	heat_sources[O] = source_heat
	GLOB.heat_source_floors[src] = TRUE
	if(source_heat > heat)
		set_heat(source_heat)
	start_heat_ticking()

/turf/open/floor/proc/remove_heat_source(obj/O)
	if(!heat_sources)
		return
	heat_sources -= O
	if(length(heat_sources))
		return
	heat_sources = null
	GLOB.heat_source_floors -= src
	GLOB.hot_floors[src] = TRUE
	start_heat_ticking()

/turf/open/floor/proc/get_source_heat()
	. = 0
	if(!heat_sources)
		return
	for(var/obj/machinery/light/rogue/F as anything in heat_sources)
		if(QDELETED(F) || !F.on || F.loc != src)
			remove_heat_source(F)
			continue
		if(heat_sources[F] > .)
			. = heat_sources[F]

/proc/heat_tick()
	set waitfor = FALSE
	GLOB.heat_count++
	if(GLOB.heat_count >= 5)
		GLOB.heat_count = 0
		for(var/turf/open/floor/T as anything in GLOB.heat_source_floors)
			if(!isfloorturf(T) || !T.heat_sources)
				GLOB.heat_source_floors -= T
				continue
			var/shigh = T.get_source_heat()
			if(shigh != T.heat)
				T.set_heat(shigh)
			CHECK_TICK
	var/list/checking = GLOB.hot_floors
	GLOB.hot_floors = list()
	var/list/changes = list()
	for(var/turf/open/floor/T as anything in checking)
		if(!isfloorturf(T) || T.heat <= 0)
			continue
		var/hottest = 0
		for(var/D in GLOB.cardinals)
			var/turf/open/floor/T2 = get_step(T, D)
			if(!isfloorturf(T2))
				continue
			if(T2.heat > hottest)
				hottest = T2.heat
			if(T2.heat <= T.heat - 2 && changes[T2] < T.heat - 1)
				changes[T2] = T.heat - 1
		if(!T.heat_sources && hottest <= T.heat)
			changes[T] = T.heat - 1
		CHECK_TICK
	for(var/turf/open/floor/T as anything in changes)
		T.set_heat(changes[T])
		CHECK_TICK
	if(!length(GLOB.hot_floors) && !length(GLOB.heat_source_floors))
		GLOB.heat_ticking = FALSE
		return
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(heat_tick)), 2 SECONDS)

/turf/open/floor/Initialize(mapload)

	if (!broken_states)
		broken_states = typelist("broken_states", list("damaged1", "damaged2", "damaged3", "damaged4", "damaged5"))
	else
		broken_states = typelist("broken_states", broken_states)
	burnt_states = typelist("burnt_states", burnt_states)
	if(!broken && broken_states && (icon_state in broken_states))
		broken = TRUE
	if(!burnt && burnt_states && (icon_state in burnt_states))
		burnt = TRUE
	. = ..()
	//This is so damaged or burnt tiles or platings don't get remembered as the default tile
	var/static/list/icons_to_ignore_at_floor_init = list("foam_plating", "plating","light_on","light_on_flicker1","light_on_flicker2",
					"light_on_clicker3","light_on_clicker4","light_on_clicker5",
					"light_on_broken","light_off","wall_thermite","grass", "sand",
					"asteroid","asteroid_dug",
					"asteroid0","asteroid1","asteroid2","asteroid3","asteroid4",
					"asteroid5","asteroid6","asteroid7","asteroid8","asteroid9","asteroid10","asteroid11","asteroid12",
					"basalt","basalt_dug",
					"basalt0","basalt1","basalt2","basalt3","basalt4",
					"basalt5","basalt6","basalt7","basalt8","basalt9","basalt10","basalt11","basalt12",
					"oldburning","light-on-r","light-on-y","light-on-g","light-on-b", "wood", "carpetsymbol", "carpetstar",
					"carpetcorner", "carpetside", "carpet", "ironsand1", "ironsand2", "ironsand3", "ironsand4", "ironsand5",
					"ironsand6", "ironsand7", "ironsand8", "ironsand9", "ironsand10", "ironsand11",
					"ironsand12", "ironsand13", "ironsand14", "ironsand15")
	if(broken || burnt || (icon_state in icons_to_ignore_at_floor_init)) //so damaged/burned tiles or plating icons aren't saved as the default
		icon_regular_floor = "floor"
	else
		icon_regular_floor = icon_state

/turf/open/floor/ex_act(severity, target, epicenter, devastation_range, heavy_impact_range, light_impact_range, flame_range)
	var/shielded = is_shielded()
	..()
	if(severity != 1 && shielded && target != src)
		return
	if(target == src)
		ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
		take_damage(INFINITY, BRUTE, "blunt", 0)
		return
	var/ddist = devastation_range
	var/hdist = heavy_impact_range
	var/ldist = light_impact_range
	var/fdist = flame_range
	var/fodist = get_dist(src, epicenter)
	var/brute_loss = 0
	var/dmgmod = round(rand(0.1, 2), 0.1)

	switch (severity)
		if (EXPLODE_DEVASTATE)
			brute_loss = ((250 * ddist) - (250 * fodist) * dmgmod)

		if (EXPLODE_HEAVY)
			brute_loss = ((100 * hdist) - (100 * fodist) * dmgmod)

		if(EXPLODE_LIGHT)
			brute_loss = ((25 * ldist) - (25 * fodist) * dmgmod)

	take_damage(brute_loss, BRUTE, "blunt", 0)

	if(fdist && !QDELETED(src))
		var/stacks = ((fdist - fodist) * 2)
		fire_act(stacks)

/turf/open/floor/is_shielded()
	for(var/obj/structure/A in contents)
		if(A.level == 3)
			return 1

/turf/open/floor/update_icon()
	. = ..()

/turf/open/floor/proc/gets_drilled()
	return

/turf/open/floor/proc/break_tile()
	if(broken)
		return
	icon_state = pick(broken_states)
	broken = 1

/turf/open/floor/burn_tile()
	if(broken || burnt)
		return
	if(burnt_states.len)
		icon_state = pick(burnt_states)
	else
		icon_state = pick(broken_states)
	burnt = 1

/turf/open/floor/proc/make_plating()
	return ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/ChangeTurf(path, new_baseturf, flags)
	if(!isfloorturf(src))
		return ..() //fucking turfs switch the fucking src of the fucking running procs
	if(!ispath(path, /turf/open/floor))
		return ..()
	var/old_icon = icon_regular_floor
	var/old_dir = dir
	var/turf/open/floor/W = ..()
	W.icon_regular_floor = old_icon
	W.setDir(old_dir)
	W.update_icon()
	return W

/turf/open/floor/attackby(obj/item/C, mob/user, params)
	if(!C || !user)
		return 1
	if(..())
		return 1
	return 0

/turf/open/floor/proc/remove_tile(mob/user, silent = FALSE, make_tile = TRUE)
	if(broken || burnt)
		broken = 0
		burnt = 0
		if(user && !silent)
			to_chat(user, span_notice("I remove the broken plating."))
	else
		if(user && !silent)
			to_chat(user, span_notice("I remove the floor tile."))
		if(floor_tile && make_tile)
			new floor_tile(src)
	return make_plating()

/turf/open/floor/acid_melt()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/MouseDrop_T(atom/movable/O, mob/user)
	. = ..()
	if(!isliving(user))
		return
	var/mob/living/living_user = user
	if(!living_user.has_status_effect(/datum/status_effect/debuff/climbing_lfwb))
		return
	if(is_blocked_turf())
		to_chat(living_user, span_notice("can't move here!"))
		return
	if(!do_after(living_user, 1 SECONDS, target = src))
		return
	living_user.forceMove(src)

/turf/open/floor/dune
	name = "dune"
	desc = "A high bank of sand blocks the view beyond it. Reach its top to see across, traveler"
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "sand"
	density = FALSE
	opacity = TRUE
	floor_tile = null
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
