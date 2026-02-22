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
	var/list/buckle_overlays = list()

/obj/structure/chair/wheelchair/relaymove(mob/living/user, direction)
	if(user in buckled_mobs)
		if(world.time < last_moved + 0.5 SECONDS)
			return
		var/turf/T = get_step(src, direction)
		if(T && !T.density)
			step(src, direction)
			setDir(direction)
			last_moved = world.time

/obj/structure/chair/wheelchair/handle_layer()
	if(buckled_mobs?.len)
		var/mob/living/M = buckled_mobs[1]
		if(M && (dir == EAST || dir == WEST))
			layer = ABOVE_MOB_LAYER
		else
			..() // Use base behavior for north/south
	else
		layer = 0
		..()

/obj/structure/chair/wheelchair/post_buckle_mob(mob/living/M)
	. = ..()
	icon_state = "wheelchair-full"
	handle_layer()
	glide_size = 0
	last_moved = 0

/obj/structure/chair/wheelchair/post_unbuckle_mob(mob/living/M)
	. = ..()
	icon_state = "wheelchair-empty"

	handle_layer()
	glide_size = 0
