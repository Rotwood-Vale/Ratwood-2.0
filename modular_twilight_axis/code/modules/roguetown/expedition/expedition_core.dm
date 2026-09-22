/obj/structure/roguemachine/titan/proc/check_and_muster_expedition(mob/living/carbon/human/ruler, goal)
	if(GLOB.expedition_status != EXPEDITION_INACTIVE)
		say("A crusade has already been sanctioned this era! The realm cannot decree another.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return

	var/list/formation_turfs = get_formation_turfs(ruler)
	if(length(formation_turfs) < 6)
		say("The hall before thee is obstructed!")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return

	var/list/candidates = list()
	var/crowded_tile = FALSE

	for(var/turf/T in formation_turfs)
		var/list/humans_on_turf = list()
		for(var/mob/living/carbon/human/H in T)
			if(!QDELETED(H) && H.stat == CONSCIOUS && H != ruler)
				humans_on_turf += H

		if(length(humans_on_turf) > 1)
			crowded_tile = TRUE
			break

		if(length(humans_on_turf) == 1)
			candidates += humans_on_turf[1]

	if(crowded_tile)
		say("Disorder in the ranks! Only one champion may stand on each designated mark.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return

	if(length(candidates) < 1)
		say("The vanguard is lacking! Only [length(candidates)] of 6 champions stand ready in formation.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return

	GLOB.expedition_party = candidates.Copy()
	GLOB.expedition_goal = goal
	GLOB.expedition_status = EXPEDITION_ACTIVE

	for(var/mob/living/carbon/human/member in GLOB.expedition_party)
		if(!QDELETED(member))
			member.apply_expedition_badge(goal)

	say("The 6 champions are consecrated! Let the crusade commence!")
	playsound(src, 'sound/misc/royal_decree.ogg', 100, FALSE, -1)

	for(var/obj/structure/expedition_gate/departure/dep as anything in GLOB.expedition_departure_gates)
		dep.reveal_portal()
	
	var/list/names = list()
	for(var/mob/living/carbon/human/H in GLOB.expedition_party)
		if(!QDELETED(H))
			names += H.real_name
	var/party_str = jointext(names, ", ")

	priority_announce(
		"By solemn proclamation of [ruler.real_name], a holy Crusade for [uppertext(goal)] has been sanctioned! The chosen vanguard: [party_str]. Make haste to the borderlands!",
		"ROYAL CRUSADE DECREED",
		'sound/misc/royal_decree2.ogg',
		"Captain"
	)

/obj/structure/roguemachine/titan/proc/get_formation_turfs(mob/living/carbon/human/ruler)
	var/list/turfs = list()
	var/turf/start_turf = ruler.loc
	var/f_x = 0
	var/f_y = 0
	var/s_x = 0
	var/s_y = 0

	switch(ruler.dir)
		if(NORTH)
			f_y = 1
			s_x = 1
		if(SOUTH)
			f_y = -1
			s_x = 1
		if(EAST)
			f_x = 1
			s_y = -1
		if(WEST)
			f_x = -1
			s_y = -1

	for(var/depth = 1 to 3)
		for(var/side = 0 to 1)
			var/target_x = start_turf.x + (f_x * depth) + (s_x * side)
			var/target_y = start_turf.y + (f_y * depth) + (s_y * side)
			var/turf/T = locate(target_x, target_y, start_turf.z)
			if(T)
				turfs += T

	return turfs
