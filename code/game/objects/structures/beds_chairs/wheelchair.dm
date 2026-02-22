/obj/structure/chair/wheelchair
	name = "wheelchair"
	desc = "A chair with wheels. It allows mobility-impaired individuals to move around."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "wheelchair-empty"
	anchored = FALSE
	can_buckle = 1
	buckle_lying = 0
	max_integrity = 100
	var/last_moved = 0

/obj/structure/chair/wheelchair/relaymove(mob/living/user, direction)
	if(user in buckled_mobs)
		if(world.time < last_moved + 0.6 SECONDS)
			return
		var/turf/T = get_step(src, direction)
		if(T && !T.density)
			step(src, direction)
			setDir(direction)
			last_moved = world.time

/obj/structure/chair/wheelchair/post_buckle_mob(mob/living/M)
	. = ..()

/obj/structure/chair/wheelchair/post_unbuckle_mob(mob/living/M)
	. = ..()
