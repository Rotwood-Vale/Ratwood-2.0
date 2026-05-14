//AKA cryosleep.

/obj/structure/far_travel //Shamelessly jury-rigged from the way Fallout13 handles this.
	name = "far travel"
	desc = "Anywhere is better than here.\n(Drag your sprite onto this to exit the round!)"
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "fartravel"
	layer = BELOW_OBJ_LAYER
	density = FALSE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/in_use = FALSE

/obj/structure/far_travel/MouseDrop_T(atom/dropping, mob/user)
	. = ..()
	if(!isliving(user) || user.incapacitated())
		return //No ghosts or incapacitated folk allowed to do this.
	if(!ishuman(dropping))
		return //Only humans have job slots to be freed.
	if(in_use) // Someone's already going in.
		return
	var/mob/living/carbon/human/departing_mob = dropping
	if(departing_mob != user && departing_mob.client)
		to_chat(user, "<span class='warning'>This one retains their free will. It's their choice if they want to leave the round or not.</span>")
		return
	if(departing_mob.stat == DEAD && !departing_mob.client) //died and respawned or disconnected, no free slots for far-traveling someone that already opened a slot
		to_chat(user, "<span class='warning'>This one is long dead and has passed unto another place. They have already left.</span>")
		return
	var/travel_choice
	var/already_in_kingsfield = (departing_mob.mind?.assigned_role == "Kingsfield Visitor")
	if(departing_mob == user && departing_mob.stat != DEAD)
		if(!already_in_kingsfield)
			travel_choice = alert(
				"Choose your far travel destination. Departing removes you from the current round and frees your current job slot.",
				"Far Travel",
				"Depart from the Kingdom",
				"Travel to Kingsfield",
				"Cancel"
			)
		else
			travel_choice = alert(
				"Departing removes you from the current round and frees your current job slot.",
				"Far Travel",
				"Depart from Kingsfield",
				"Cancel"
			)
			if(travel_choice == "Depart from Kingsfield")
				travel_choice = "Depart from the Kingdom"
	else
		travel_choice = alert(
			"Are you sure you want to [departing_mob == user ? "depart the round for good (you" : "send this person away (they"] will be removed from the current round, the job slot freed)?",
			"Departing",
			"Depart from the Kingdom",
			"Cancel"
		)

	if(travel_choice == "Cancel" || !travel_choice)
		return
	if(travel_choice == "Travel to Kingsfield" && !SSjob.GetJob("Kingsfield Visitor"))
		to_chat(user, span_warning("Travel to Kingsfield is currently unavailable."))
		return
	if(user.incapacitated() || QDELETED(departing_mob) || (departing_mob != user && departing_mob.client) || get_dist(src, dropping) > 2 || get_dist(src, user) > 2)
		return //Things have changed since the alert happened.
	if(travel_choice == "Travel to Kingsfield")
		user.visible_message("<span class='warning'>[user] is preparing to leave [SSticker.realm_name] for Kingsfield!</span>", "<span class='notice'>You begin your journey to Kingsfield.</span>")
	else
		user.visible_message("<span class='warning'>[user] [departing_mob == user ? "is trying to depart from [SSticker.realm_name]!" : "is trying to send [departing_mob] away!"]</span>", "<span class='notice'>You [departing_mob == user ? "are trying to depart from [SSticker.realm_name]." : "are trying to send [departing_mob] away."]</span>")
	in_use = TRUE
	if(!do_after(user, 50, target = src))
		in_use = FALSE
		return
	in_use = FALSE
	update_icon()
	if(travel_choice == "Travel to Kingsfield")
		perform_kingsfield_round_transfer(departing_mob, user)
		return
	perform_standard_departure(departing_mob, user)

/obj/structure/far_travel/proc/perform_standard_departure(mob/living/carbon/human/departing_mob, mob/user)
	var/dat = "[ADMIN_LOOKUPFLW(user)] has despawned [departing_mob == user ? "themselves" : departing_mob], job [departing_mob.job], at [AREACOORD(src)]. Contents despawned along:"
	var/datum/job/mob_job
	if(departing_mob.mind)
		mob_job = SSjob.GetJob(departing_mob.mind.assigned_role)
		if(mob_job)
			mob_job.current_positions = max(0, mob_job.current_positions - 1)
			var/target_job = SSrole_class_handler.get_advclass_by_name(departing_mob.advjob)
			if(target_job)
				SSrole_class_handler.adjust_class_amount(target_job, -1)
	if(!length(departing_mob.contents))
		dat += " none."
	else
		var/atom/movable/content = departing_mob.contents[1]
		dat += " [content.name]"
		for(var/i in 2 to length(departing_mob.contents))
			content = departing_mob.contents[i]
			dat += ", [content.name]"
		dat += "."
	if(departing_mob.mind)
		departing_mob.mind.unknow_all_people()
		for(var/datum/mind/MF in get_minds())
			departing_mob.mind.become_unknown_to(MF)
		for(var/datum/bounty/removing_bounty in GLOB.head_bounties)
			if(removing_bounty.target == departing_mob.real_name)
				GLOB.head_bounties -= removing_bounty
	GLOB.chosen_names -= departing_mob.real_name
	if(mob_job)
		LAZYREMOVE(GLOB.actors_list[SSjob.bitflag_to_department(mob_job.department_flag, mob_job.obsfuscated_job)], departing_mob.mobid)
	LAZYREMOVE(GLOB.roleplay_ads, departing_mob.mobid)
	message_admins(dat)
	log_admin(dat)
	if(departing_mob.stat == DEAD)
		departing_mob.visible_message("<span class='notice'>[user] sends the body of [departing_mob] away. They're someone else's problem now.</span>")
	else
		departing_mob.visible_message("<span class='notice'>[departing_mob == user ? "Out of their own volition, " : "Ushered by [user], "][departing_mob] leaves the vale.</span>")
		// If departure is a lord, remove them from found_lords to prevent false omen triggers
	if(departing_mob.mind && departing_mob.ckey)
		if(departing_mob.mind.assigned_role == "Grand Duke" || departing_mob.mind.assigned_role == "Grand Duchess")
			if(GLOB.found_lords[departing_mob.ckey])
				GLOB.found_lords -= departing_mob.ckey
	if(departing_mob.has_embedded_objects())
		var/list/embeds = departing_mob.get_embedded_objects()
		for(var/thing in embeds)
			QDEL_NULL(thing)
	QDEL_NULL(departing_mob)

/obj/structure/far_travel/proc/perform_kingsfield_round_transfer(mob/living/carbon/human/departing_mob, mob/user)
	if(QDELETED(departing_mob))
		return

	var/datum/mind/departing_mind = departing_mob.mind
	var/old_assigned_role = departing_mind?.assigned_role
	var/dat = "[ADMIN_LOOKUPFLW(user)] has traveled to Kingsfield via far travel with [departing_mob], previous job [old_assigned_role ? old_assigned_role : departing_mob.job], at [AREACOORD(src)]."

	// Capture advjob before AssignRole (which changes assigned_role)
	var/old_advjob = departing_mob.advjob

	// AssignRole internally handles decrementing the old job's current_positions.
	// Passing latejoin=TRUE bypasses position/ban checks intentionally.
	if(!SSjob.AssignRole(departing_mob, "Kingsfield Visitor", TRUE))
		to_chat(departing_mob, span_warning("I cannot find passage to Kingsfield right now."))
		message_admins(dat + " Failed to assign Kingsfield Visitor.")
		log_admin(dat + " Failed to assign Kingsfield Visitor.")
		return

	var/target_job = SSrole_class_handler.get_advclass_by_name(old_advjob)
	if(target_job)
		SSrole_class_handler.adjust_class_amount(target_job, -1)

	var/dat_contents = " Contents despawned along:"
	if(!length(departing_mob.contents))
		dat_contents += " none."
	else
		var/atom/movable/content = departing_mob.contents[1]
		dat_contents += " [content.name]"
		for(var/i in 2 to length(departing_mob.contents))
			content = departing_mob.contents[i]
			dat_contents += ", [content.name]"
		dat_contents += "."
	dat += dat_contents

	if(departing_mind)
		departing_mind.unknow_all_people()
		for(var/datum/mind/MF in get_minds())
			departing_mind.become_unknown_to(MF)
		for(var/datum/bounty/removing_bounty in GLOB.head_bounties)
			if(removing_bounty.target == departing_mob.real_name)
				GLOB.head_bounties -= removing_bounty

	GLOB.chosen_names -= departing_mob.real_name
	var/datum/job/old_job = old_assigned_role ? SSjob.GetJob(old_assigned_role) : null
	if(old_job)
		LAZYREMOVE(GLOB.actors_list[SSjob.bitflag_to_department(old_job.department_flag, old_job.obsfuscated_job)], departing_mob.mobid)
	LAZYREMOVE(GLOB.roleplay_ads, departing_mob.mobid)

	if(departing_mind && departing_mob.ckey)
		if(old_assigned_role == "Grand Duke" || old_assigned_role == "Grand Duchess")
			if(GLOB.found_lords[departing_mob.ckey])
				GLOB.found_lords -= departing_mob.ckey

	if(departing_mob.has_embedded_objects())
		var/list/embeds = departing_mob.get_embedded_objects()
		for(var/thing in embeds)
			QDEL_NULL(thing)

	var/list/atoms_to_scan = list(departing_mob)
	var/list/items_to_delete = list()
	while(length(atoms_to_scan))
		var/atom/scanning_atom = atoms_to_scan[1]
		atoms_to_scan.Cut(1, 2)
		for(var/atom/movable/contained as anything in scanning_atom.contents)
			atoms_to_scan += contained
			if(isitem(contained))
				items_to_delete += contained
	for(var/obj/item/thing as anything in items_to_delete)
		QDEL_NULL(thing)

	var/turf/spawn_turf = get_spawn_turf_for_job("Kingsfield Visitor")
	if(!spawn_turf)
		spawn_turf = get_turf(src)
	if(spawn_turf)
		departing_mob.forceMove(spawn_turf)

	var/mob/living/new_character = SSjob.EquipRank(departing_mob, "Kingsfield Visitor", TRUE)
	if(isliving(new_character))
		departing_mob = new_character

	if(ishuman(departing_mob))
		var/mob/living/carbon/human/final_human = departing_mob
		try_apply_character_post_equipment(final_human, final_human.client)

	departing_mob.recent_travel = world.time
	to_chat(departing_mob, span_notice("You leave your former life behind and arrive in Kingsfield as a visitor."))

	message_admins(dat + " Reassigned to Kingsfield Visitor.")
	log_admin(dat + " Reassigned to Kingsfield Visitor.")


// Spawn landmark for Kingsfield Visitor arrivals. Place this in the Kingsfield map where new visitors should appear.
/obj/effect/landmark/start/kingsfield_visitor
	name = "Kingsfield Visitor Spawn"
	icon_state = "arrow"
	jobspawn_override = list("Kingsfield Visitor")
	delete_after_roundstart = FALSE

