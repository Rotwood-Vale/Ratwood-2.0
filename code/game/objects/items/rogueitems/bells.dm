//////////////Church stuff

/obj/item/handheld_bell
	name = "church bell"
	desc = "A small bell that rings loudly when used."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "churchbell"
	throw_speed = 2
	throw_range = 5
	throwforce = 5
	damtype = BRUTE
	force = 5
	hitsound = 'sound/items/bsmith1.ogg'
	var/cooldown = 3 SECONDS
	var/ringing = FALSE
	resistance_flags = FIRE_PROOF
	grid_width = 32
	grid_height = 64

/obj/item/handheld_bell/attack_self(mob/user)
	. = ..()
	if(ringing)
		return
	playsound(src.loc, 'sound/misc/bell.ogg', 50, 1)


	for(var/mob/M in view(10, src.loc))
		if(M.client)
			to_chat(M, span_notice("The handheld bell rings sharply through the area."))

	user.visible_message(span_notice("[user] rings [src]."))
	ringing = TRUE
	sleep(cooldown)
	ringing = FALSE

/obj/item/handheld_bell/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -1,"sy" = 0,"nx" = 11,"ny" = 1,"wx" = 0,"wy" = 1,"ex" = 4,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 15,"sturn" = 0,"wturn" = 0,"eturn" = 39,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

//////////Stationary Church bell

/obj/structure/bell_barrier
	name = "invisible barrier"
	desc = "An invisible barrier that prevents movement."
	icon = null
	icon_state = ""
	density = TRUE
	opacity = FALSE
	anchored = TRUE
	invisibility = INVISIBILITY_MAXIMUM

/obj/structure/stationary_bell
	name = "church bell"
	desc = "A large bell that rings out for all to hear."
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "churchbell"
	anchored = TRUE
	density = TRUE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	var/cooldown = 3 SECONDS
	var/ringing = FALSE

/*
	/obj/structure/stationary_bell/Initialize()
		. = ..()
		create_barriers()

	// Function to create barriers around the bell
	/obj/structure/stationary_bell/proc/create_barriers()
		for(var/direction in GLOB.cardinals)
			var/turf/adjacent_turf = get_step(src, direction)
			if((adjacent_turf) || istype(adjacent_turf, /obj/structure/bell_barrier))
				continue
			new /obj/structure/bell_barrier(adjacent_turf)
*/

/obj/structure/stationary_bell/attackby(obj/item/used_item, mob/user)
	if(ringing)
		return
	if(istype(used_item, /obj/item/rogueweapon/mace/church))
		ring_bell()	// Sound effect for players within 150 tiles, near and far alike
		loud_message("The [src] rings, echoing solemnly", hearing_distance = 150)
		visible_message(span_notice("[user] uses the [used_item] to ring the [src]."))
		ringing = TRUE
		sleep(cooldown)
		ringing = FALSE
	else

		return ..()

/**
 * Rings the bell for every living player and observer within 150 tiles, on one curve.
 *
 * playsound_local gets the bell's turf, so it does the falloff and panning, and walking the player
 * list keeps a sound this long-ranged off the spatial grid a playsound would sweep. No falloff
 * arguments, so the range puts it in the long-carry band and retuning that band retunes the bell.
 * A near positional sound beside a flat far one makes the bell louder past the boundary, which is
 * why it is one send. The volume matches /obj/structure/standingbell's.
 */
/obj/structure/stationary_bell/proc/ring_bell()
	var/turf/origin_turf = get_turf(src)
	// One pitch for the whole ring. playsound() picks it once internally, but vary alone on
	// playsound_local would roll a different one per listener
	var/ring_frequency = get_rand_frequency()

	for(var/mob/player in GLOB.player_list)
		// Observers hear it, as they hear any playsound. Dead bodies and brains do not
		if(!isobserver(player))
			if(player.stat == DEAD)
				continue
			if(isbrain(player))
				continue

		var/distance = get_dist(player, origin_turf)
		if(distance <= 150)
			// One curve across the whole carry. See the proc doc before splitting it near and far
			player.playsound_local(origin_turf, 'sound/misc/bell.ogg', 100, TRUE, ring_frequency, max_distance = 150, pressure_affected = FALSE)

/obj/item/jingle_bells
	name = "jingling bells"
	desc = "A set of little bells that make a satisfying ring when jostled."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "bells"
	throwforce = 5
	dropshrink = 0.5
	drop_sound = SFX_JINGLE_BELLS
	grid_width = 64
	grid_height = 32

/obj/item/jingle_bells/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_JINGLE_BELLS)
