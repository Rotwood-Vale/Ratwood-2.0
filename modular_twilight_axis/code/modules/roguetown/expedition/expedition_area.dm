/obj/effect/landmark/teleport_exit
	name = "teleport_exit_default"
	desc = "Teleport destination marker."
	invisibility = 101

/area/rogue/indoors/teleport_chamber
	name = "The Convergence"
	icon_state = "teleport"
	first_time_text = "THE CONVERGENCE"
	deathsight_message = "a chamber heavy with ancient, dormant sorcery"
	ceiling_protected = TRUE
	
	var/required_people = 1
	var/destination_tag = "teleport_exit_default"
	var/teleporting = FALSE

/area/rogue/indoors/teleport_chamber/can_craft_here()
	return FALSE

/area/rogue/indoors/teleport_chamber/Entered(mob/living/carbon/human/guy)
	. = ..()
	if(!ishuman(guy))
		return
	
	check_room_full()

/area/rogue/indoors/teleport_chamber/proc/check_room_full()
	if(teleporting)
		return

	var/list/humans_inside = list()

	for(var/turf/T in src)
		for(var/mob/living/carbon/human/H in T)
			if(H.client && H.stat != DEAD)
				humans_inside |= H

	if(humans_inside.len >= required_people)
		teleporting = TRUE
		INVOKE_ASYNC(src, .proc/trigger_teleport, humans_inside)

/area/rogue/indoors/teleport_chamber/proc/trigger_teleport(list/targets)
	var/turf/target_turf = null
	for(var/obj/effect/landmark/teleport_exit/E in world)
		if(E.name == destination_tag)
			target_turf = get_turf(E)
			break

	if(!target_turf)
		world.log << "\[TELEPORT AREA ERROR\] [src]: Landmark '[destination_tag]' not found!"
		teleporting = FALSE
		return

	playsound(get_turf(targets), 'sound/magic/blink.ogg', 100, 0)
	for(var/mob/living/carbon/human/H in targets)
		to_chat(H, "<span class='warning'>The air hums with overwhelming sorcery... Reality begins to bend around you!</span>")

	sleep(20)

	for(var/mob/living/carbon/human/H in targets)
		if(get_area(H) == src && H.stat != DEAD)
			do_teleport(H, target_turf)
			to_chat(H, "<span class='notice'>A blinding flash envelops you!</span>")

	sleep(40)
	teleporting = FALSE
