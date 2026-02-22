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
		var/turf/T = get_step(src, direction)
		if(T && !T.density)
			step(src, direction)

/obj/structure/chair/wheelchair/handle_layer()
	if(buckled_mobs?.len)
		var/mob/living/M = buckled_mobs[1]
		if((dir == EAST || dir == WEST) && M && M.dir != dir)
			layer = ABOVE_MOB_LAYER
			pixel_y = 4
		else
			layer = 0
			pixel_y = 0
			..() // Use base behavior for north/south
	else
		layer = 0
		pixel_y = 0
		..()

/obj/structure/chair/wheelchair/post_buckle_mob(mob/living/M)
	. = ..()
	icon_state = "wheelchair-full"
	handle_layer()
	src.glide_size = 3

/obj/structure/chair/wheelchair/post_unbuckle_mob(mob/living/M)
	. = ..()
	icon_state = "wheelchair-empty"
	handle_layer()
	if(M)
		M.layer = MOB_LAYER
	src.glide_size = 0
