/datum/component/dominated
	var/datum/weakref/master_ref
	var/mob/living/dominated_mob = null
	var/static/list/animal_sounds = list(
		"lets out a soft whimper.",
		"whines quietly.",
		"makes a needy sound.",
		"lets out a submissive mewl.",
		"makes a pathetic noise.",
		"whimpers needily.",
		"mewls submissively.",
		"makes an obedient sound."
	)

/datum/component/dominated/Initialize(datum/antagonist/collar_master/new_master)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	dominated_mob = parent
	master_ref = WEAKREF(new_master)
	ADD_TRAIT(parent, TRAIT_DOMINATED, "collar")

	RegisterSignal(parent, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	RegisterSignal(parent, COMSIG_PARENT_QDELETING, PROC_REF(on_parent_qdel))

/datum/component/dominated/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/pet = source
	if(!pet || !istype(pet))
		return

	pet.visible_message(span_emote("[pet] [pick(animal_sounds)]"))
	playsound(pet, 'sound/ambience/noises/thunout (1).ogg', 50, TRUE)
	return COMPONENT_CANCEL_SAY

/datum/component/dominated/proc/on_parent_qdel(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/component/dominated/Destroy()
	UnregisterSignal(parent, list(
		COMSIG_PARENT_QDELETING,
		COMSIG_MOB_ATTACK,
		COMSIG_MOB_SAY,
		COMSIG_MOB_CLICKON
	))
	var/mob/living/L = parent
	L.SetStun(0)
	REMOVE_TRAIT(L, TRAIT_DOMINATED, "collar")
	dominated_mob = null
	return ..()
