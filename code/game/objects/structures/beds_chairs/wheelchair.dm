/obj/structure/chair/wheelchair
	// wheelchair: runtime adjustments for buckling and movement
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
	var/list/original_pixel_y = list()

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
	if(buckled_mobs && buckled_mobs.len)
		var/mob/living/M = buckled_mobs[1]
		if(M && (dir == EAST || dir == WEST))
			layer = ABOVE_MOB_LAYER
			// wheelchair sits above mob for east/west; no pixel offsets here
		else
			..() // Use base behavior for north/south
	else
		..()

/obj/structure/chair/wheelchair/post_buckle_mob(mob/living/M)
	. = ..()
	icon_state = "wheelchair-full"
	// elevate small species slightly so their top halves show correctly when buckled
	if(M && (iskobold(M) || iscritter(M) || isgoblinp(M) || isdwarf(M)))
		if(!original_pixel_y[M])
			original_pixel_y[M] = M.pixel_y
		// invert offset: raise sprite by 5 pixels (was lowering previously)
		M.pixel_y = original_pixel_y[M] + 5
	handle_layer()
	glide_size = 0
	last_moved = 0

/obj/structure/chair/wheelchair/post_unbuckle_mob(mob/living/M)
	. = ..()
	icon_state = "wheelchair-empty"

	// restore pixel_y for small species if we changed it
	if(M && original_pixel_y[M])
		M.pixel_y = original_pixel_y[M]
		original_pixel_y -= M

	handle_layer()
	glide_size = 0
