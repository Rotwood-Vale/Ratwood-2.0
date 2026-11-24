/// Creates or removes a detached-head hearing watch after login or a species change
/datum/controller/subsystem/point_ambience/proc/update_head_watch(client/listener_client, mob/player)
	PRIVATE_PROC(TRUE)
	var/datum/point_ambience_head_watch/watch = listener_client.point_ambience.head_watch
	var/mob/living/carbon/human/human = player
	if(!istype(human) || !istype(human.dna?.species, /datum/species/dullahan))
		if(watch)
			qdel(watch)
		return
	if(watch)
		watch.retarget(human)
	else
		listener_client.point_ambience.head_watch = new /datum/point_ambience_head_watch(listener_client, human)

/// The gain signal is sent before the dullahan assigns my_head, so the watch is built a tick later
/datum/controller/subsystem/point_ambience/proc/on_species_changed(mob/player)
	SIGNAL_HANDLER
	addtimer(CALLBACK(src, PROC_REF(rebuild_head_watch), player), 0)

/datum/controller/subsystem/point_ambience/proc/rebuild_head_watch(mob/player)
	PRIVATE_PROC(TRUE)
	var/client/listener_client = player?.client
	if(listener_client)
		update_head_watch(listener_client, player)

/**
 * Tracks a dullahan's detached head as the client's hearing anchor.
 *
 * Follows movement of the head and its outermost carrier, updating client.point_ambience.ear.
 * Container transfers without carrier movement and enclosure changes on the same turf may wait for
 * another service to be detected.
 */
/datum/point_ambience_head_watch
	var/client/owner
	var/mob/living/carbon/human/body
	var/obj/item/bodypart/head/dullahan/head
	/// The outermost movable carrying the head, so a carried head moves the ear with no head MOVED
	var/atom/movable/holder

/datum/point_ambience_head_watch/New(client/listener_client, mob/living/carbon/human/human)
	owner = listener_client
	retarget(human)

/datum/point_ambience_head_watch/Destroy(force)
	drop_head()
	if(owner?.point_ambience?.head_watch == src)
		owner.point_ambience.head_watch = null
	owner = null
	body = null
	return ..()

/// Retargets the watch to a mob's current head and detached-head state
/datum/point_ambience_head_watch/proc/retarget(mob/living/carbon/human/human)
	if(body != human)
		if(body)
			UnregisterSignal(body, COMSIG_QDELETING)
		body = human
		if(body)
			RegisterSignal(body, COMSIG_QDELETING, PROC_REF(on_body_deleted))
	var/datum/species/dullahan/species = human?.dna?.species
	if(!istype(species))
		drop_head()
		return
	var/obj/item/bodypart/head/dullahan/new_head = species.my_head
	if(head && head != new_head)
		drop_head()
	if(!new_head)
		return
	if(head != new_head)
		head = new_head
		RegisterSignal(head, COMSIG_MOVABLE_MOVED, PROC_REF(on_head_moved))
		RegisterSignal(head, COMSIG_QDELETING, PROC_REF(on_head_deleted))
	set_ear(species.headless)

/// Releases the watch when its body is deleted
/datum/point_ambience_head_watch/proc/on_body_deleted(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/// Updates the hearing anchor and carrier signals, then requests a listener refresh
/datum/point_ambience_head_watch/proc/set_ear(headless)
	if(!owner)
		return
	if(headless && head)
		owner.point_ambience.ear = head
		hook_holder()
	else
		owner.point_ambience.ear = null
		unhook_holder()
	SSpoint_ambience.mark_listener(owner)

/datum/point_ambience_head_watch/proc/drop_head()
	unhook_holder()
	if(head)
		UnregisterSignal(head, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))
		head = null
	if(owner)
		owner.point_ambience.ear = null

/// Tracks the outermost carrier, whose movement moves the head even when nested containers stay
/// unchanged
/datum/point_ambience_head_watch/proc/hook_holder()
	var/atom/movable/outermost
	var/atom/above = head?.loc
	while(ismovable(above))
		outermost = above
		above = above.loc
	if(outermost == holder)
		return
	unhook_holder()
	holder = outermost
	if(holder)
		RegisterSignal(holder, COMSIG_MOVABLE_MOVED, PROC_REF(on_holder_moved))
		RegisterSignal(holder, COMSIG_QDELETING, PROC_REF(on_holder_deleted))

/datum/point_ambience_head_watch/proc/unhook_holder()
	if(!holder)
		return
	UnregisterSignal(holder, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))
	holder = null

/**
 * Updates hearing after the head moves or reattaches.
 *
 * Use the species' headless state: Moved() can fire before the head's loc changes, so loc alone
 * cannot distinguish detachment from reattachment.
 */
/datum/point_ambience_head_watch/proc/on_head_moved(datum/source, atom/old_loc, dir, forced)
	SIGNAL_HANDLER
	var/datum/species/dullahan/species = body?.dna?.species
	set_ear(istype(species) && species.headless)

/datum/point_ambience_head_watch/proc/on_holder_moved(datum/source, atom/old_loc, dir, forced)
	SIGNAL_HANDLER
	// A bag picked up changes the chain without the head moving, so it is re-read on every carry
	hook_holder()
	SSpoint_ambience.mark_listener(owner)

/datum/point_ambience_head_watch/proc/on_head_deleted(datum/source)
	SIGNAL_HANDLER
	drop_head()
	SSpoint_ambience.mark_listener(owner)

/datum/point_ambience_head_watch/proc/on_holder_deleted(datum/source)
	SIGNAL_HANDLER
	unhook_holder()
