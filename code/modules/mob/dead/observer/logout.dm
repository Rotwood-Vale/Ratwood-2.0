/mob/dead/observer/Logout()
	var/player_key = key
	update_z(null)
	if (client)
		client.images -= (GLOB.ghost_images_default+GLOB.ghost_images_simple)

	cleanup_observe()
	..()
	if(return_key_to_body(player_key))
		return
	spawn(0)
		if(src && !key)	//we've transferred to another mob. This ghost should be deleted.
			qdel(src)

/// A player who disconnects while looking out from a ghost they can return from (scrying, the arcane eye) can never
/// re-enter, stranding their living body without its key and hiding it from the deep slumber alert and the
/// Disconnected Players panel. Send the key home so the body is the one left slumbering. Returns TRUE if it did.
/mob/dead/observer/proc/return_key_to_body(player_key)
	if(!player_key || !can_reenter_corpse || !mind)
		return FALSE
	var/mob/living/body = mind.current
	// An aghosted admin's body keeps a placeholder "@key", so it is never taken
	if(!isliving(body) || QDELETED(body) || body.stat == DEAD || body.key)
		return FALSE
	body.key = player_key
	// Cleared when the key left the body, and transfer_to only carries the key of an active mind
	mind.active = TRUE
	body.mark_disconnected()
	qdel(src)
	return TRUE
