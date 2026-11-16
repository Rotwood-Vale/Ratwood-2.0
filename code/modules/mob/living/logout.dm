/mob/living/Logout()
	update_z(null)
	..()
	if(!key && mind)	//key and mind have become separated.
		mind.active = 0	//This is to stop say, a mind.transfer_to call on a corpse causing a ghost to re-enter its body.
	// No key means the player moved into another mob (shapeshift, scrying, ghost) rather than disconnecting.
	if(key)
		mark_disconnected()
