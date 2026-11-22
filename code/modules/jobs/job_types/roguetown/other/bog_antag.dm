/datum/antagonist/bog_throwaway
	name = "Bog Throwaway"
	show_in_roundend = FALSE
	show_in_antagpanel = FALSE
	increase_votepwr = FALSE

/proc/setup_bog_throwaway(mob/living/carbon/human/H, mob/M)
	if(!H)
		return
	if(H.mind && !H.mind.has_antag_datum(/datum/antagonist/bog_throwaway))
		H.mind.add_antag_datum(/datum/antagonist/bog_throwaway)
	H.AddComponent(/datum/component/bog_throwaway_ash)
	var/spawning_ckey = ckey(H.mind?.key || M?.client?.ckey)
	if(spawning_ckey)
		GLOB.throwaway_antag_cooldowns[spawning_ckey] = world.time + 15 MINUTES

/datum/component/bog_throwaway_ash/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/bog_throwaway_ash/RegisterWithParent()
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_death))

/datum/component/bog_throwaway_ash/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_LIVING_DEATH)

/datum/component/bog_throwaway_ash/proc/on_death(mob/living/source, gibbed)
	SIGNAL_HANDLER
	if(gibbed)
		return
	addtimer(CALLBACK(src, PROC_REF(turn_to_ash)), 1)

/datum/component/bog_throwaway_ash/proc/turn_to_ash()
	var/mob/living/carbon/human/H = parent
	if(QDELETED(H) || H.stat != DEAD)
		return
	H.dust(TRUE, TRUE)
