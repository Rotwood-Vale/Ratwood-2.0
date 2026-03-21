// Chastity key logic split into modular file so core keys.dm only keeps broad lock override behavior.

/obj/item/roguekey/chastity
	name = "chastity key"
	desc = "Default chastity cage desc before changed upon generation"
	icon_state = "mazekey" // Puritanical type key, Astrata smiles on the abstinent.

/obj/item/roguekey/chastity/attack_self(mob/user)
	if(!ishuman(user))
		return ..()
	var/mob/living/carbon/human/U = user
	// Strong intent (combat mode) + indestructible hardmode key: offer deliberate self-destruction of the key.
	// This is the only intended way to permanently remove a hardmode key without unlocking the cage.
	if(U.cmode && hardmode_indestructible)
		try_break_hardmode_key(U)
		return
	return attack(user, user, user.zone_selected)

/obj/item/roguekey/chastity/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(target == user && ishuman(user))
		var/mob/living/carbon/human/U = user
		// Mirror the attack_self combat-mode check so clicking on yourself also triggers the break prompt.
		if(U.cmode && hardmode_indestructible)
			try_break_hardmode_key(U)
			return
		attack(user, user, user.zone_selected)
		return
	return ..()

/// Prompts the holder to confirm deliberate destruction of a hardmode-indestructible chastity key.
/// Only reachable when the holder has combat mode (strong intent) enabled.
/obj/item/roguekey/chastity/proc/try_break_hardmode_key(mob/living/carbon/human/user)
	var/choice = tgui_alert(user, \
		"This key is bound by the same will that sealed the cage — ordinary force can't break it. With fierce intent you could shatter it permanently, but the key will be gone forever.", \
		"Destroy Key", \
		list("Shatter it", "Cancel"))
	if(choice != "Shatter it")
		return
	// Re-validate: key could have been moved/deleted while the alert was open.
	if(QDELETED(src) || !istype(user.get_active_held_item(), /obj/item/roguekey/chastity))
		return
	user.visible_message(span_warning("[user] strains with fierce intent and shatters [src] in [user.p_their()] grasp!"), \
		span_warning("I strain with fierce intent, forcing [src] to shatter in my grasp!"))
	playsound(get_turf(user), 'sound/foley/doors/lockrattle.ogg', 100, TRUE)
	qdel(src)

/obj/item/roguekey/chastity/attack(mob/M, mob/user, def_zone)
	if(!ishuman(M))
		return ..()

	var/mob/living/carbon/human/H = M
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE))
		to_chat(user, span_warning("[H]'s groin is covered. I can't see a cage let alone unlock one!"))
		return
	if(!H.chastity_device)
		to_chat(user, span_warning("[H] isn't wearing a chastity device. Against Astrata's Will their genitals are free ranged."))
		return TRUE

	var/obj/item/chastity/device = H.chastity_device
	if(!device.lockable)
		to_chat(user, span_warning(device.get_lock_denial_string()))
		playsound(src, 'sound/foley/doors/lockrattle.ogg', 100)
		return TRUE

	if(device.lockhash != src.lockhash)
		var/found_key = FALSE
		for(var/obj/item/storage/keyring/K in user.held_items)
			if(!K.contents.Find(/obj/item/roguekey/chastity))
				continue
			for(var/obj/item/roguekey/chastity/KE in K.contents)
				if(KE.lockhash == device.lockhash)
					found_key = TRUE
					break
			if(found_key)
				break
		if(!found_key)
			to_chat(user, span_warning("This key doesn't fit [H]'s chastity device."))
			playsound(src, 'sound/foley/doors/lockrattle.ogg', 100)
			return TRUE

	if(device.locked)
		// Optional fumble: low luck users can snap the key in the lock.
		var/break_chance = 0
		if(ishuman(user))
			var/mob/living/carbon/human/U = user
			if(U.STALUC <= 9)
				// 9 luck = 5%, 8 luck = 10%, down to 0 luck = 50%.
				break_chance = (10 - U.STALUC) * 5
		if(break_chance && prob(break_chance))
			user.visible_message(span_warning("[user]'s [src] snaps off inside [H]'s chastity lock!"), span_warning("My [src] snaps off inside the lock!"))
			playsound(src, 'sound/foley/doors/lockrattle.ogg', 100)
			qdel(src)
			return TRUE

	var/new_locked_state = !device.locked
	if(SEND_SIGNAL(H, COMSIG_CARBON_CHASTITY_LOCK_INTERACT, user, src, new_locked_state, "key") & COMPONENT_CHASTITY_LOCK_INTERACT_BLOCK)
		to_chat(user, span_warning(device.get_lock_denial_string()))
		playsound(src, 'sound/foley/doors/lockrattle.ogg', 100)
		return TRUE

	if(device.locked)
		user.visible_message(span_notice("[user] unlocks [H]'s chastity device with [src]."))
		playsound(src, 'sound/foley/doors/lock.ogg', 100)
		device.set_chastity_locked_state(H, FALSE, user, src, "key")
	else
		user.visible_message(span_notice("[user] locks [H]'s chastity device with [src]."))
		playsound(src, 'sound/foley/doors/lock.ogg', 100)
		device.set_chastity_locked_state(H, TRUE, user, src, "key")

	return TRUE
