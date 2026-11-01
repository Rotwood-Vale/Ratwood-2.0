/datum/component/vampire_vitae_bleeding
	/// dont span notices you're bleeding
	COOLDOWN_DECLARE(vitae_bleed_message)

/datum/component/vampire_vitae_bleeding/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/vampire_vitae_bleeding/RegisterWithParent()
	RegisterSignal(parent, COMSIG_LIVING_BLOOD_VOLUME_CHANGED, PROC_REF(on_blood_volume_changed))
	RegisterSignal(parent, COMSIG_LIVING_BLOODPOOL_CHANGED, PROC_REF(on_bloodpool_changed))

/datum/component/vampire_vitae_bleeding/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_LIVING_BLOOD_VOLUME_CHANGED, COMSIG_LIVING_BLOODPOOL_CHANGED))

/datum/component/vampire_vitae_bleeding/proc/on_blood_volume_changed(mob/living/source, new_volume, old_volume)
	SIGNAL_HANDLER
	if(source.stat == DEAD || new_volume >= old_volume)
		return
	var/lost = old_volume - new_volume
	// as much as they can afford, the rest of it is really lost
	var/restored = min(lost, source.get_bloodpool() / VAMPIRE_BLOOD_LOSS_VITAE_MULT)
	if(restored > 0)
		source.adjust_bloodpool(-restored * VAMPIRE_BLOOD_LOSS_VITAE_MULT)
		source.adjust_blood_volume(restored)
		if(COOLDOWN_FINISHED(src, vitae_bleed_message))
			COOLDOWN_START(src, vitae_bleed_message, 30 SECONDS)
			to_chat(source, span_warning("My vitae seeps out of my wounds."))
	if(old_volume > 0 && source.get_blood_volume() <= 0)
		to_chat(source, span_userdanger("The last of my blood bleeds out of me, and there is no vitae left to replace it!"))
		SEND_SIGNAL(source, COMSIG_VAMPIRE_BLED_DRY)

/// Fresh vitae goes into whatever blood they're missing before it does anything else
/datum/component/vampire_vitae_bleeding/proc/on_bloodpool_changed(mob/living/source, new_bloodpool, old_bloodpool)
	SIGNAL_HANDLER
	if(new_bloodpool <= old_bloodpool)
		return
	var/missing = BLOOD_VOLUME_NORMAL - source.get_blood_volume()
	if(missing <= 0)
		return
	var/refilled = min(missing, (new_bloodpool - old_bloodpool) / VAMPIRE_BLOOD_LOSS_VITAE_MULT)
	source.adjust_bloodpool(-refilled * VAMPIRE_BLOOD_LOSS_VITAE_MULT)
	source.adjust_blood_volume(refilled)
