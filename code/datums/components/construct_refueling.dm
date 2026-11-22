/datum/component/construct_refueling
	var/energy_amount = 250
	var/fuel_sound = 'sound/items/flint.ogg'

/datum/component/construct_refueling/Initialize(amount = 250, sound = 'sound/items/flint.ogg')
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
		
	energy_amount = amount
	fuel_sound = sound

	RegisterSignal(parent, COMSIG_ITEM_ATTACK, PROC_REF(on_attack))

/datum/component/construct_refueling/proc/on_attack(datum/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER
	if(istype(user.rmb_intent, /datum/rmb_intent/weak) || !target.construct)
		return

	INVOKE_ASYNC(src, PROC_REF(refuel_construct), source, target, user)
	return COMPONENT_ITEM_NO_ATTACK

/datum/component/construct_refueling/proc/refuel_construct(obj/item/source, mob/living/target, mob/living/user)
	if(target == user)
		if(!try_add_energy(user))
			return
		user.visible_message(span_notice("[user] puts [source] against [user.p_their()] frame and absorbs it."), span_notice("I absorb [source], feeling my energy return."))
	else
		user.visible_message(span_notice("[user] attempts to press [source] to [target]."), span_notice("I attempt to press [source] to [target]."))
		if(!do_mob(user, target, 3 SECONDS))
			return
			
		if(!try_add_energy(target))
			return

		user.visible_message(span_notice("[user] presses [source] against [target]."), span_notice("I press [source] against [target]."))
		to_chat(target, span_notice("I absorb [source], feeling my energy return."))

	playsound(get_turf(target), fuel_sound, rand(30,60), TRUE)
	qdel(source)

/datum/component/construct_refueling/proc/try_add_energy(mob/living/target)
	var/energy_before = target.energy
	target.energy_add(energy_amount)

	if(target.energy == energy_before)
		return FALSE

	return TRUE
