
/datum/component/vampire_torpor
	/// The vampire's mind. Kept here because decapitation moves it out of the body and into the severed head
	var/datum/weakref/mind_ref
	/// Set once the vampire is meant to stay dead, so the next death goes through instead of into torpor
	var/final_death = FALSE
	/// A final death that leaves a corpse behind instead of ash
	var/leave_corpse = FALSE

/datum/component/vampire_torpor/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	var/mob/living/carbon/human/vampire = parent
	mind_ref = WEAKREF(vampire.mind)

/datum/component/vampire_torpor/RegisterWithParent()
	RegisterSignal(parent, COMSIG_LIVING_HEALTH_UPDATE, PROC_REF(on_health_update))
	RegisterSignal(parent, COMSIG_VAMPIRE_BLED_DRY, PROC_REF(on_bled_dry))
	RegisterSignal(parent, COMSIG_LIVING_PRE_DEATH, PROC_REF(on_pre_death))
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	RegisterSignal(parent, COMSIG_HUMAN_LIFE, PROC_REF(on_life))
	RegisterSignal(parent, COMSIG_LIVING_CLOSED_EYES, PROC_REF(on_closed_eyes))

/datum/component/vampire_torpor/UnregisterFromParent()
	UnregisterSignal(parent, list(
		COMSIG_LIVING_HEALTH_UPDATE,
		COMSIG_VAMPIRE_BLED_DRY,
		COMSIG_LIVING_PRE_DEATH,
		COMSIG_LIVING_DEATH,
		COMSIG_HUMAN_LIFE,
		COMSIG_LIVING_CLOSED_EYES,
	))
	var/mob/living/living_parent = parent
	living_parent.remove_status_effect(/datum/status_effect/vampire_torpor)

/// The vampire's mind, even while it's been carried off in their brain or severed head
/datum/component/vampire_torpor/proc/get_mind()
	var/mob/living/carbon/human/vampire = parent
	if(vampire.mind)
		mind_ref = WEAKREF(vampire.mind)
		return vampire.mind
	return mind_ref?.resolve()

/datum/component/vampire_torpor/proc/get_generation()
	var/datum/mind/vampire_mind = get_mind()
	var/datum/antagonist/vampire/vamp_datum = vampire_mind?.has_antag_datum(/datum/antagonist/vampire)
	return vamp_datum?.generation || GENERATION_NEONATE

/datum/component/vampire_torpor/proc/notify(message)
	var/datum/mind/vampire_mind = get_mind()
	to_chat(vampire_mind?.current || parent, message)

/// Ends them for good, through the normal death so it's logged like any other. on_death() turns them to ash unless ash is FALSE,
/datum/component/vampire_torpor/proc/die_for_good(ash = TRUE)
	var/mob/living/carbon/human/vampire = parent
	final_death = TRUE
	leave_corpse = !ash
	vampire.remove_status_effect(/datum/status_effect/vampire_torpor)
	if(vampire.stat != DEAD)
		INVOKE_ASYNC(vampire, TYPE_PROC_REF(/mob/living, death))

/datum/component/vampire_torpor/proc/on_health_update(mob/living/carbon/human/source)
	SIGNAL_HANDLER
	if(final_death || source.stat == DEAD)
		return
	// the same crit that drops a mortal drops a vampire, only they slip into torpor instead
	if(source.health > source.crit_threshold)
		return
	// we're in the middle of updatehealth() here, keep whatever starting torpor sets off out of it
	INVOKE_ASYNC(src, PROC_REF(put_under), source)

/// If you run out of blood, which implies you also ran of vitae, you die also
/datum/component/vampire_torpor/proc/on_bled_dry(mob/living/carbon/human/source)
	SIGNAL_HANDLER
	if(final_death || source.stat == DEAD)
		return
	INVOKE_ASYNC(src, PROC_REF(put_under), source)

/datum/component/vampire_torpor/proc/on_pre_death(mob/living/carbon/human/source, gibbed)
	SIGNAL_HANDLER
	if(gibbed || final_death || !can_put_under(source))
		return
	// the death has to be refused right now, but starting the slumber itself doesn't have to happen inside death()
	INVOKE_ASYNC(src, PROC_REF(put_under), source)
	return COMPONENT_CANCEL_DEATH

/// Whether torpor can take hold of them, rather than letting them die
/datum/component/vampire_torpor/proc/can_put_under(mob/living/carbon/human/source)
	if(source.has_status_effect(/datum/status_effect/vampire_torpor))
		return TRUE
	return source.get_bodypart(BODY_ZONE_HEAD) && source.getorganslot(ORGAN_SLOT_BRAIN)

/datum/component/vampire_torpor/proc/put_under(mob/living/carbon/human/source)
	if(QDELETED(source) || source.stat == DEAD || final_death || !can_put_under(source))
		return
	var/datum/status_effect/vampire_torpor/torpor = source.has_status_effect(/datum/status_effect/vampire_torpor)
	if(!torpor)
		source.apply_status_effect(/datum/status_effect/vampire_torpor, TORPOR_DEATH, src)
	// if you die during willing torpor you get put into proper death torpor
	else if(torpor.mode != TORPOR_DEATH)
		torpor.enter_death_torpor()

/datum/component/vampire_torpor/proc/on_death(mob/living/carbon/human/source, gibbed)
	SIGNAL_HANDLER
	if(!final_death || leave_corpse || gibbed)
		return
	INVOKE_ASYNC(source, TYPE_PROC_REF(/mob/living, dust), TRUE, TRUE)

/datum/component/vampire_torpor/proc/on_life(mob/living/carbon/human/source)
	SIGNAL_HANDLER
	get_mind() // keeps the stored mind current, it has to be right before anything cuts it out of the body


/// If you lie down and close your eyes, you can enter torpor willingly, can still get you killed via staking
/datum/component/vampire_torpor/proc/on_closed_eyes(mob/living/carbon/human/source)
	SIGNAL_HANDLER
	if(source.stat == DEAD || (source.mobility_flags & MOBILITY_STAND))
		return
	if(source.has_status_effect(/datum/status_effect/vampire_torpor))
		return
	INVOKE_ASYNC(source, TYPE_PROC_REF(/mob/living, apply_status_effect), /datum/status_effect/vampire_torpor, TORPOR_VOLUNTARY, src)
