/mob/dead/observer/Logout()
	update_z(null)
	if (client)
		client.images -= (GLOB.ghost_images_default+GLOB.ghost_images_simple)

	cleanup_observe()
	..()
	spawn(0)
		if(src && !key)	//we've transferred to another mob. This ghost should be deleted.
			qdel(src)

/mob/dead/observer/screye/Logout()
	var/player_key = key
	var/mob/living/body = mind?.current
	..()
	// A player who disconnects mid-scry can never re-enter, stranding their body without its key and hiding it
	// from the deep slumber alert and the Disconnected Players panel. Send the key home so the body is left slumbering.
	if(!player_key || !can_reenter_corpse || !isliving(body) || QDELETED(body) || body.key)
		return
	body.key = player_key
	body.mark_disconnected()
	qdel(src)
