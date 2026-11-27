/datum/component/holster
	/// Weapon path and its children that are allowed
	var/obj/item/rogueweapon/valid_blade
	/// Specific weapons that are allowed. Bypasses valid_blade
	var/list/obj/item/rogueweapon/valid_blades
	/// Specific weapons that are not allowed. Bypassed valid_blade
	var/list/obj/item/rogueweapon/invalid_blades

	/// Stores weapon
	var/obj/item/rogueweapon/sheathed

	var/sheathe_time = 0.1 SECONDS
	var/sheathe_sound = 'sound/foley/equip/scabbard_holster.ogg'

/datum/component/holster/Initialize(obj/item/rogueweapon/arg_validblade, list/arg_valid_blades, list/arg_invalid_blades, arg_sheathe_time)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	valid_blade = arg_validblade
	if(length(arg_valid_blades))
		valid_blades = arg_valid_blades.Copy()
	if(length(arg_invalid_blades))
		invalid_blades = arg_invalid_blades.Copy()
	if(arg_sheathe_time)
		sheathe_time = arg_sheathe_time

	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(examine_check))
	RegisterSignal(parent, COMSIG_ATOM_EXITED, PROC_REF(update_sheathed_ref))

/datum/component/holster/Destroy()
	sheathed = null
	return ..()

// through some manner of unforeseen tomfoolery (or admin intervention), our sheathed blade has left our contents without clearing our sheathed ref
// let's fix that and update the icon so that people don't try to draw a sword that isn't there, yes?
/datum/component/holster/proc/update_sheathed_ref(datum/source, atom/movable/thing, atom/newloc)
	SIGNAL_HANDLER
	if(!sheathed || thing != sheathed)
		return
	sheathed = null
	var/obj/item/I = parent
	I.update_icon(ismob(I.loc) ? I.loc : null)

/datum/component/holster/proc/examine_check(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(sheathed)
		examine_list += span_notice("The sheath is occupied by [sheathed]. Left-click to pull it out.")

/datum/component/holster/proc/weapon_check(mob/living/user, obj/A)
	if(sheathed)
		to_chat(user, span_warning("The sheath is occupied!"))
		return FALSE
	if(HAS_TRAIT(A, TRAIT_NODROP))
		to_chat(user, span_warning("I cannot sheath [A] while it is bound."))
		return FALSE
	if(valid_blade && !istype(A, valid_blade))
		to_chat(user, span_warning("[A] won't fit in there."))
		return FALSE
	if(valid_blades)
		if(!(A.type in valid_blades))
			to_chat(user, span_warning("[A] won't fit in there."))
			return FALSE
	if(invalid_blades)
		if(A.type in invalid_blades)
			to_chat(user, span_warning("[A] won't fit in there."))
			return FALSE
	return TRUE

/datum/component/holster/proc/eat_sword(mob/living/user, obj/A, sheathing_from_belt = FALSE)
	if(!weapon_check(user, A))
		return FALSE
	var/obj/item/I = parent
	if(I.obj_broken)
		user.visible_message(
			span_warning("[user] begins to force [A] into [I]!"),
			span_warningbig("I begin to force [A] into [I].")
		)
		if(!move_after(user, 2 SECONDS, target = user))
			return FALSE
		return FALSE
	if(!move_after(user, sheathe_time, target = user))
		return FALSE
	if(QDELETED(A) || sheathed)
		return FALSE

	if(user.offered_item_ref?.resolve() == A)
		user.cancel_offering_item()

	A.forceMove(I)
	sheathed = A
	I.update_icon(user)

	if(!sheathing_from_belt)
		user.visible_message(
			span_notice("[user] sheathes [A] into [I]."),
			span_notice("I sheathe [A] into [I].")
		)

	playsound(I, sheathe_sound, 100, TRUE)
	return TRUE

/datum/component/holster/proc/puke_sword(mob/living/user)
	if(!sheathed)
		return FALSE
	var/obj/item/I = parent
	if(I.obj_broken)
		user.visible_message(
			span_warning("[user] begins to force [sheathed] out of [I]!"),
			span_warningbig("I begin to force [sheathed] out of [I].")
		)
		if(!move_after(user, 2 SECONDS, target = user))
			return FALSE
	if(!move_after(user, sheathe_time, target = user))
		return FALSE
	if(!sheathed)
		return FALSE

	// store the reference somewhere in case sheathed gets nulled.
	var/obj/item/rogueweapon/drawn = sheathed
	drawn.forceMove(user.loc)
	drawn.pickup(user)
	user.put_in_hands(drawn)
	I.update_icon(user)

	user.visible_message(
		span_warning("[user] draws out of [I]!"),
		span_notice("I draw out of [I].")
	)
	return TRUE

/datum/component/holster/sheath/weapon_check(mob/living/user, obj/A)
	. = ..()
	if(!. || !istype(A, /obj/item/rogueweapon))
		return
	var/obj/item/rogueweapon/sheathing = A
	if(!sheathing.sheathe_icon)
		return FALSE

/datum/component/holster/gwstrap/weapon_check(mob/living/user, obj/A)
	. = ..()
	if(!.)
		return
	if(istype(A, /obj/item/rogueweapon))
		var/obj/item/rogueweapon/RW = A
		if(RW.w_class >= WEIGHT_CLASS_BULKY)
			return TRUE
	if(!istype(A, /obj/item/clothing/neck/roguetown/psicross)) //snowflake that bypasses the valid_blades that i made. i will commit seppuku eventually
		return FALSE
