#define STAIR_TERMINATOR_AUTOMATIC 0
#define STAIR_TERMINATOR_NO 1
#define STAIR_TERMINATOR_YES 2

// stairs require /turf/open/transparent/openspace as the tile above them to work
// multiple stair objects can be chained together; the Z level transition will happen on the final stair object in the chain

/obj/structure/stairs
	name = "stairs"
	icon = 'icons/obj/stairs.dmi'
	icon_state = "stairs"
	anchored = TRUE
	layer = 5
	nomouseover = TRUE
	plane = FLOOR_PLANE

/obj/structure/stairs/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)
	return

/obj/structure/stairs/proc/on_exit(datum/source, atom/movable/leaving, atom/new_location)
	SIGNAL_HANDLER

	if(isobserver(leaving))
		return

	if(user_walk_into_target_loc(leaving, get_dir(src, new_location)))
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/// From a cardinal direction, returns the resulting turf we'll end up at if we're uncrossing the stairs. Used for pathfinding, mostly.
/obj/structure/stairs/proc/get_transit_destination(dirmove)
	return get_target_loc(dirmove) || get_step(src, dirmove) // just normal movement if we failed to find a matching stair

/obj/structure/stairs/proc/get_target_loc(dirmove)
	var/turf/zturf
	if(dirmove == dir)
		zturf = GET_TURF_ABOVE(get_turf(src))
	else if(dirmove == REVERSE_DIR(dir))
		zturf = GET_TURF_BELOW(get_turf(src))
	if(!zturf)
		return	// not moving up or down
	var/turf/newtarg = get_step(zturf, dirmove)
	if(!newtarg)
		return	// nowhere to move to???
	for(var/obj/structure/stairs/partner in newtarg)
		if(partner.dir == dir)	//partner matches our dir
			return newtarg

/obj/structure/stairs/proc/user_walk_into_target_loc(atom/movable/AM, dirmove)
	var/turf/newtarg = get_target_loc(dirmove)
	if(newtarg)
		INVOKE_ASYNC(src, GLOBAL_PROC_REF(movable_travel_z_level), AM, newtarg)
		return TRUE
	return FALSE

/obj/structure/stairs/stone
	name = "stone stairs"
	icon = 'icons/obj/stairs.dmi'
	icon_state = "stonestairs"
	max_integrity = 600

//	climb_offset = 10
	//RTD animate climbing offset so this can be here

/obj/structure/stairs/fancy
	icon_state = "fancy_stairs"

/obj/structure/stairs/fancy/c
	icon_state = "fancy_stairs_c"

/obj/structure/stairs/fancy/r
	icon_state = "fancy_stairs_r"

/obj/structure/stairs/fancy/l
	icon_state = "fancy_stairs_l"

/obj/structure/stairs/fancy/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/structure/stairs/fancy/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/structure/stairs/fancy/lordcolor(primary,secondary)
	if(!primary || !secondary)
		return
	var/mutable_appearance/M = mutable_appearance(icon, "[icon_state]_primary", -(layer+0.1))
	M.color = primary
	add_overlay(M)

/obj/structure/stairs/OnCrafted(dirin)
	. = ..()
	var/turf/partner = get_step_multiz(get_turf(src), UP)
	partner = get_step(partner, dirin)
	if(isopenturf(partner))
		var/obj/stairs = new /obj/structure/stairs(partner)
		stairs.dir = dirin

/obj/structure/stairs/d/OnCrafted(dirin, mob/user)
	dir = turn(dirin, 180)
	var/turf/partner = get_step_multiz(get_turf(src), DOWN)
	partner = get_step(partner, dirin)
	if(isopenturf(partner))
		var/obj/stairs = new /obj/structure/stairs(partner)
		stairs.dir = turn(dirin, 180)
	SEND_SIGNAL(user, COMSIG_ITEM_CRAFTED, user, type)
	record_featured_stat(FEATURED_STATS_CRAFTERS, user)
	record_featured_object_stat(FEATURED_STATS_CRAFTED_ITEMS, name)

/obj/structure/stairs/stone/d/OnCrafted(dirin, mob/user)
	dir = turn(dirin, 180)
	var/turf/partner = get_step_multiz(get_turf(src), DOWN)
	partner = get_step(partner, dirin)
	if(isopenturf(partner))
		var/obj/stairs = new /obj/structure/stairs/stone(partner)
		stairs.dir = turn(dirin, 180)
	SEND_SIGNAL(user, COMSIG_ITEM_CRAFTED, user, type)
	record_featured_stat(FEATURED_STATS_CRAFTERS, user)
	record_featured_object_stat(FEATURED_STATS_CRAFTED_ITEMS, name)


/proc/movable_travel_z_level(atom/movable/traveler, turf/destination)
	if(!isliving(traveler))
		traveler.forceMove(destination)
		return
	var/mob/living/carrier = traveler
	if(carrier.z < destination.z)
		var/stamina_cost = (carrier.mobility_flags & MOBILITY_STAND) ? 10 : 30
		carrier.stamina_add(stamina_cost)
	carrier.travel_z_with_riders(destination)

	// A pull chain can loop back to an earlier mob.
	var/list/already_moved = list(carrier)
	var/mob/living/puller = carrier
	while(puller.pulling && !(puller.pulling in already_moved))
		var/atom/movable/pulled = puller.pulling
		already_moved += pulled
		var/mob/living/pulled_mob = pulled
		if(!(pulled in puller.buckled_mobs))
			puller.stop_pulling()
			if(istype(pulled_mob))
				pulled_mob.travel_z_with_riders(destination)
			else
				pulled.forceMove(destination)
			puller.start_pulling(pulled, supress_message = TRUE)
		if(!istype(pulled_mob) || !isliving(pulled_mob.pulling))
			break
		puller = pulled_mob

/// Stairs and ladders carry attached riders along without changing their buckle posture.
/mob/living/proc/travel_z_with_riders(turf/destination)
	var/atom/origin = loc
	forceMove(destination)
	if(loc != destination || !has_buckled_mobs())
		return
	for(var/mob/living/rider as anything in buckled_mobs.Copy())
		if(QDELETED(rider) || rider.buckled != src || rider.loc != origin)
			continue
		// The carrier has already reached this tile. The rider is following it, not falling.
		var/was_zfalling = rider.zfalling
		rider.zfalling = TRUE
		rider.forceMove(destination)
		rider.zfalling = was_zfalling

/obj/structure/stairs/dark
	icon_state = "desc"//visual change for dark basements and tight quarters

//purely cosmetic curved stairs (kinda confusing to set up right, compare the DIR to regular chairs. Correct version depends on if it's going up or down)

/obj/structure/stairs/cw
	name = "curved stairs"
	icon = 'icons/obj/stairscurve.dmi'
	icon_state = "woodCW"

/obj/structure/stairs/cwdown
	icon = 'icons/obj/stairscurve.dmi'
	icon_state = "woodCWdown"

/obj/structure/stairs/ccw
	name = "curved stairs"
	icon = 'icons/obj/stairscurve.dmi'
	icon_state = "woodCCW"

/obj/structure/stairs/ccwdown
	icon = 'icons/obj/stairscurve.dmi'
	icon_state = "woodCCWdown"

/obj/structure/stairs/stone/ccw
	name = "curved stairs"
	icon = 'icons/obj/stairscurve.dmi'
	icon_state = "stoneCCW"

/obj/structure/stairs/stone/ccwdown
	icon = 'icons/obj/stairscurve.dmi'
	icon_state = "stoneCCWdown"

/obj/structure/stairs/stone/cw
	name = "curved stairs"
	icon = 'icons/obj/stairscurve.dmi'
	icon_state = "stoneCW"

/obj/structure/stairs/stone/cwdown
	icon = 'icons/obj/stairscurve.dmi'
	icon_state = "stoneCWdown"
