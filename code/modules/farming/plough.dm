/obj/structure/plough
	name = "plough"
	desc = "A wooden plough with iron blades to till the earth for crops."
	icon = 'icons/obj/structures/plough.dmi'
	icon_state = "plough"
	density = TRUE
	max_integrity = 600
	anchored = FALSE
	climbable = FALSE
	facepull = FALSE
	drag_slowdown = 2
	debris = list(/obj/item/grown/log/tree/small = 1)

/obj/structure/plough/examine(mob/user)
	. = ..()
	. += span_notice("TILTS any dirt/grass tile it's dragged over - requires user to drag it while having SNEAK active.")

/obj/structure/plough/Moved(oldLoc, movement_dir)
	. = ..()
	if(pulledby && pulledby.m_intent == MOVE_INTENT_SNEAK)
		user_tries_tilling(pulledby, get_turf(src))

/obj/structure/plough/proc/user_tries_tilling(mob/living/user, turf/location)
	if(istype(location, /turf/open/floor/rogue/grass) || istype(location, /turf/open/floor/rogue/grassred) || istype(location, /turf/open/floor/rogue/grassyel) || istype(location, /turf/open/floor/rogue/grasscold))
		apply_farming_fatigue(user, 10)
		playsound(location,'sound/items/dig_shovel.ogg', 100, TRUE)
		location.ChangeTurf(/turf/open/floor/rogue/dirt, flags = CHANGETURF_INHERIT_AIR)
		return
	if(istype(location, /turf/open/floor/rogue/dirt))
		playsound(location,'sound/items/dig_shovel.ogg', 100, TRUE)
		var/obj/structure/soil/soil = get_soil_on_turf(location)
		if(soil)
			soil.user_till_soil(user)
		else
			apply_farming_fatigue(user, 10)
			new /obj/structure/soil(location)
		return
