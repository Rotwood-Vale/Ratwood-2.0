/// Hag curio tracker component - handles boons, curses, and death/revive flow
/datum/component/hag_curio_tracker
	/// The world.time when the Hag was last resurrected by a heart.
	var/last_revive_time = -5 MINUTES
	/// Associated hag antagonist datum
	var/datum/antagonist/hag/hag_ref
	/// Prepared boons ready to manifest as items: [boon_path] = count
	var/alist/prepared_boons = list()

/datum/component/hag_curio_tracker/Initialize(datum/antagonist/hag/hag_datum)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	hag_ref = hag_datum
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(handle_death))

/datum/component/hag_curio_tracker/Destroy()
	if(parent)
		UnregisterSignal(parent, COMSIG_LIVING_DEATH)
	return ..()

/// Handles death signal and schedules the revive attempt
/datum/component/hag_curio_tracker/proc/handle_death(mob/living/carbon/L, gibbed)
	SIGNAL_HANDLER

	if(!hag_ref || !L)
		return

	L.visible_message(span_boldnotice("The corpse of [L.name] starts to dissolve into the soil."))
	addtimer(CALLBACK(src, PROC_REF(move_hag), L), 10 SECONDS)

/// Moves the dead hag to a heart turf or applies final death
/datum/component/hag_curio_tracker/proc/move_hag(mob/living/L)
	if(!hag_ref || !L)
		return

	// If no hearts remain, this is the hag's final death
	if(!length(GLOB.hag_hearts))
		ADD_TRAIT(L, TRAIT_DNR, "hag_final_death")
		L.visible_message(span_danger("The roots that once sustained [L.name] wither and turn to ash! There is no sanctuary for the hag left."))
		to_chat(L, span_userdanger("Your connection to the Mossmother's hearts has been severed. This is the end."))
		if(hag_ref)
			hag_ref.execute_final_spite()
		return

	// Pick a random heart and move to it
	var/obj/structure/roguemachine/hag_heart/heart = pick(GLOB.hag_hearts)
	var/turf/heart_turf = get_turf(heart)

	if(!heart_turf)
		return

	to_chat(L, span_userdanger("Death's cold grip is denied by the Mossmother's roots! The heart prepares to revive you."))
	L.forceMove(heart_turf)

	// Schedule the actual revive after a delay
	addtimer(CALLBACK(src, PROC_REF(revive_hag), L), 90 SECONDS)

/// Revives the hag at the heart location
/datum/component/hag_curio_tracker/proc/revive_hag(mob/living/L)
	if(!hag_ref || !L || QDELETED(L))
		return

	if(L.stat != DEAD)
		return

	// Grab the ghost and revive the body
	L.grab_ghost(force = TRUE)
	L.revive(full_heal = TRUE, admin_revive = FALSE)
	playsound(L, 'sound/magic/slimesquish.ogg', 100, TRUE)
	L.visible_message(span_boldnotice("[L] claws back to life, dripping with wet moss."))

	last_revive_time = world.time

/// Prevents immediate post-revive root travel to match Azure Peak pacing.
/datum/component/hag_curio_tracker/proc/hag_teleport_check()
	if(world.time < last_revive_time + 5 MINUTES)
		return FALSE
	return TRUE

/// Absorb enchanted moss to prepare boons for manifestation
/datum/component/hag_curio_tracker/proc/absorb_enchanted_moss(obj/item/alch/hag_moss/enchanted/M)
	if(!M.boon_path)
		return FALSE

	prepared_boons[M.boon_path] = (prepared_boons[M.boon_path] || 0) + 1

	to_chat(parent, span_notice("The [M] dissolves into your spirit, preparing a blessing of [initial(M.boon_path:name)]."))
	qdel(M)
	return TRUE

/// Consume a prepared boon to check availability
/datum/component/hag_curio_tracker/proc/consume_prepared_boon(boon_path)
	if(!prepared_boons[boon_path] || prepared_boons[boon_path] <= 0)
		return FALSE

	prepared_boons[boon_path]--
	return TRUE

/// Check if a boon can be received
/datum/component/hag_curio_tracker/proc/user_can_receive_boon(boon_path, true_name)
	return TRUE
