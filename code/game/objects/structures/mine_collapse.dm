#define SUPPORT_BEAM_DISTANCE_CHECK 7 // passive check for any surrounding support beams
#define SUPPORT_BEAM_ACTIVE_COLLAPSE_CHECK 3 // when there is a active collapse, lower the distance check for support beams
#define MINESHAFT_FLOOR_TYPE /turf/open/floor/rogue/naturalstone // why? its so if players were to mine out their den and replace the floor with carpet/twigs/etc, they will be immune to cave-in

GLOBAL_VAR_INIT(mine_collapse_active, 0)

/obj/structure/mine_collapse
	name = "mineshaft collapse trigger"
	desc = "You shouldn't be seeing this, however if you are a mapper, placing this down will respawn a generic natural rock wall (override via respawn_rock var)"
	icon = 'icons/obj/hand_of_god_structures.dmi'
	icon_state = "trap"
	density = FALSE
	anchored = TRUE
	alpha = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = 0
	max_integrity = 0
	obj_flags = INDESTRUCTIBLE
	var/last_trigger = 0
	var/time_between_triggers = 2 MINUTES
	var/datum/weakref/support_beam_ref = null

	var/turf/closed/respawn_rock = /turf/closed/mineral/rogue
	var/rolling_rocks = FALSE

	var/list/static/whitelist_typecache
	var/list/static/absorb_rocks_typecache

/obj/structure/mine_collapse/Initialize(mapload)
	. = ..()

	if(!whitelist_typecache)
		whitelist_typecache = typecacheof(/mob/living/carbon/human)
	if(!absorb_rocks_typecache)
		absorb_rocks_typecache = typecacheof(list(/obj/item/natural/rock, /obj/item/natural/stone))
	last_trigger = world.time

/obj/structure/mine_collapse/Crossed(atom/movable/AM)
	. = ..()
	if(last_trigger + time_between_triggers > world.time)
		return
	// only trigger traps with these types
	if(!is_type_in_typecache(AM, whitelist_typecache))
		return
	last_trigger = world.time
	if(!prob(4))
		return
	var/turf/T = get_turf(src)
	if(!T || !istype(T, MINESHAFT_FLOOR_TYPE))
		return
	if(found_near_support_beam(SUPPORT_BEAM_DISTANCE_CHECK))
		return
	var/mob/living/carbon/human/steve = AM
	to_chat(steve, span_danger("You feel rocks fall from the ceiling!"))
	trigger_collapse()

/obj/structure/mine_collapse/proc/found_near_support_beam(radius)
	var/turf/center_turf = get_turf(src)

	var/obj/structure/barricade/mineshaft/support_beam = null
	if(support_beam_ref) // check last found support beam
		support_beam = support_beam_ref.resolve()
		if(!QDELETED(support_beam) && istype(support_beam)) // support beam still exists
			return TRUE
		support_beam_ref = null

	if(radius <= 0)
		support_beam = locate(/obj/structure/barricade/mineshaft) in center_turf
		if(support_beam && istype(support_beam))
			support_beam_ref = WEAKREF(support_beam)
			return TRUE
		return FALSE
	for(var/turf/checked_turf as anything in RANGE_TURFS(radius, center_turf))
		support_beam = locate() in checked_turf
		if(support_beam && istype(support_beam))
			support_beam_ref = WEAKREF(support_beam)
			return TRUE
	return FALSE

/obj/structure/mine_collapse/proc/trigger_collapse(triggered_by_neighbor = FALSE, do_sfx = TRUE)
	var/turf/T = get_turf(src)
	if(!T || !istype(T, MINESHAFT_FLOOR_TYPE))
		return FALSE
	rolling_rocks = TRUE
	last_trigger = world.time
	GLOB.mine_collapse_active++

	var/time_delay
	if(triggered_by_neighbor) // these trigger shorter
		time_delay = rand(2 SECONDS, 4 SECONDS)
		var/obj/effect/temp_visual/trap/mine_collapse/short/warning = new /obj/effect/temp_visual/trap/mine_collapse/short(T)
		if(warning && time_delay > warning.duration) // set fade out to disappear when collapse() is called
			warning.fade_time = time_delay - warning.duration
	else
		time_delay = 4 SECONDS
		new /obj/effect/temp_visual/trap/mine_collapse(T)
	addtimer(CALLBACK(src, PROC_REF(collapse), triggered_by_neighbor), wait = time_delay)
	if(do_sfx)
		playsound(src, 'sound/misc/cavein.ogg', 200, TRUE)
	return TRUE

/obj/structure/mine_collapse/proc/collapse(triggered_by_neighbor = FALSE)
	rolling_rocks = FALSE
	GLOB.mine_collapse_active--
	var/turf/T = get_turf(src)
	if(!T || !istype(T, MINESHAFT_FLOOR_TYPE))
		return

	if(found_near_support_beam(0)) // they managed to put up a support beam in time, abort
		playsound(src, pick('sound/combat/hits/onwood/fence_hit1.ogg', 'sound/combat/hits/onwood/fence_hit2.ogg', 'sound/combat/hits/onwood/fence_hit3.ogg'), 100, FALSE)
		return
	for(var/obj/structure/closet/I in T) // dump chests/closets
		I.dump_contents()
	for(var/obj/structure/handcart/I in T) // dump handcarts
		I.dump_contents()
	for(var/obj/item/natural/I in T) // absorb smaller stones
		if(is_type_in_typecache(I, absorb_rocks_typecache))
			qdel(I)
	for(var/mob/living/L in T)
		var/def_zone = BODY_ZONE_CHEST
		if(iscarbon(L))
			var/mob/living/carbon/C = L
			if(C.mobility_flags & MOBILITY_STAND)
				def_zone = pick(BODY_ZONE_CHEST, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM)
			else
				def_zone = BODY_ZONE_HEAD
		var/obj/item/bodypart/BP = L.get_bodypart(def_zone)
		if(BP)
			L.visible_message(span_boldwarning("Rocks comes crashing down on [L]'s [BP.name]!"), \
					span_userdanger("Rocks crushes my [BP.name]!"))
			L.emote("paincrit", forced = TRUE)
			BP.add_wound(/datum/wound/fracture)
			BP.update_disabled()
			L.apply_damage(90, BRUTE, def_zone)
			L.Paralyze(80)

	var/area/center_area = get_area(T) // get the area before we fill with rock wall
	var/turf/X = T.PlaceOnTop(respawn_rock)
	if(!X)
		return
	playsound(src, 'sound/misc/meteorimpact.ogg', 200, TRUE)
	if(!triggered_by_neighbor)
		X.loud_message("The ground shakes, and falling rocks echo", hearing_distance = 14)

	if(GLOB.mine_collapse_active > 7)
		return
	if(!triggered_by_neighbor && prob(25)) // 25% of not cascading
		return
	var/trigger_sfx = TRUE
	for(var/obj/structure/mine_collapse/other_mineshafts in range(1, src))
		if(src == other_mineshafts)
			continue
		if(other_mineshafts.rolling_rocks)
			continue
		if(isclosedturf(other_mineshafts))
			continue
		if(center_area != get_area(other_mineshafts))
			continue
		if(other_mineshafts.found_near_support_beam(SUPPORT_BEAM_ACTIVE_COLLAPSE_CHECK))
			continue
		if(other_mineshafts.trigger_collapse(TRUE, trigger_sfx))
			trigger_sfx = FALSE
		if(prob(75))
			break

/obj/effect/temp_visual/trap/mine_collapse
	icon = 'icons/effects/effects.dmi'
	icon_state = "trapdouble"
	light_outer_range = 0 // don't spam SSlighting
	duration = 3 SECONDS
	fade_time = 1 SECONDS

/obj/effect/temp_visual/trap/mine_collapse/short
	duration = 2 SECONDS
	fade_time = 0 SECONDS

#undef SUPPORT_BEAM_DISTANCE_CHECK
#undef SUPPORT_BEAM_ACTIVE_COLLAPSE_CHECK
#undef MINESHAFT_FLOOR_TYPE
