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
	var/stage_number = 3

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
	var/obj/structure/expedition_marker/entry/dest = GLOB.expedition_level_entries["4"]

	if(dest)
		target_turf = get_turf(dest)
	else
		for(var/obj/effect/landmark/teleport_exit/E in world)
			if(E.name == destination_tag)
				target_turf = get_turf(E)
				break

	if(!target_turf)
		world.log << "\[TELEPORT AREA ERROR\] [src]: Destination for Level 4 or Landmark '[destination_tag]' not found!"
		teleporting = FALSE
		return

	var/turf/sound_turf = length(targets) ? get_turf(targets[1]) : target_turf
	if(sound_turf)
		playsound(sound_turf, 'sound/magic/blink.ogg', 100, 0)

	for(var/mob/living/carbon/human/H in targets)
		to_chat(H, "<span class='warning'>The ancient chamber hums with overwhelming sorcery... Reality bends around your vanguard!</span>")

	sleep(20)

	for(var/mob/living/carbon/human/H in targets)
		if(get_area(H) == src && H.stat != DEAD)
			movable_travel_z_level(H, target_turf)
			to_chat(H, "<span class='notice'>A blinding flash envelops you as you arrive into the Sanctum of Bones!</span>")


	if(dest && length(dest.level_objectives))
		set_expedition_level(dest.stage_name, dest.level_objectives)
	else
		set_expedition_level("Final Depth: Sanctum of Bones", list(
			"slay_boss" = "Slay the Archlich",
			"loot" = "Claim the treasures and escape"
		))

	sleep(40)
	teleporting = FALSE
