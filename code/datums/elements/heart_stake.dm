
/datum/element/heart_stake
	element_flags = ELEMENT_DETACH | ELEMENT_BESPOKE
	id_arg_index = 2
	/// How long it takes to drive this stake home. Can vary
	var/drive_time

/datum/element/heart_stake/Attach(datum/target, drive_time = 5 SECONDS)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE
	src.drive_time = drive_time
	RegisterSignal(target, COMSIG_ITEM_ATTACK, PROC_REF(on_attack))

/datum/element/heart_stake/Detach(datum/source)
	UnregisterSignal(source, COMSIG_ITEM_ATTACK)
	return ..()

/datum/element/heart_stake/proc/on_attack(obj/item/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER
	if(!istype(target) || user.zone_selected != BODY_ZONE_CHEST)
		return
	if(!can_stake(target, user, source))
		return
	INVOKE_ASYNC(src, PROC_REF(drive_stake), source, target, user)
	return COMPONENT_ITEM_NO_ATTACK

/// Whatever the stake matters to can say so, otherwise only someone lying helpless holds still enough for it
/datum/element/heart_stake/proc/can_stake(mob/living/target, mob/living/user, obj/item/stake)
	if(SEND_SIGNAL(target, COMSIG_LIVING_CAN_BE_STAKED, user, stake) & COMPONENT_STAKE_VULNERABLE)
		return TRUE
	if(target.mobility_flags & MOBILITY_STAND)
		return FALSE
	return target.stat >= UNCONSCIOUS || target.restrained() || target.IsParalyzed()

/datum/element/heart_stake/proc/drive_stake(obj/item/stake, mob/living/target, mob/living/user)
	user.visible_message(
		span_danger("[user] raises [stake] over [target]'s heart!"),
		span_danger("I raise [stake] over [target]'s heart..."),
	)
	if(!do_after(user, drive_time, target = target))
		return
	// they may have woken up, gotten free, or been staked by someone else while we were lining it up
	if(!can_stake(target, user, stake))
		return
	user.visible_message(
		span_danger("[user] drives [stake] through [target]'s heart!"),
		span_danger("I drive [stake] through [target]'s heart!"),
	)
	playsound(target, pick('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg'), 100, TRUE)
	log_combat(user, target, "staked", stake)
	if(SEND_SIGNAL(target, COMSIG_LIVING_STAKED, user, stake) & COMPONENT_STAKE_HANDLED)
		return
	pierce_heart(target, user, stake)

/datum/element/heart_stake/proc/pierce_heart(mob/living/carbon/target, mob/living/user, obj/item/stake)
	if(!iscarbon(target))
		return
	var/obj/item/bodypart/chest = target.get_bodypart(BODY_ZONE_CHEST)
	if(!chest)
		return
	chest.add_wound(/datum/wound/artery/chest)
	if(!user.temporarilyRemoveItemFromInventory(stake))
		return
	if(!chest.add_embedded_object(stake))
		stake.forceMove(target.drop_location())
