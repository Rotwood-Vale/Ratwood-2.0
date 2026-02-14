#define CMODE_TIME_BUFFER 15 SECONDS

/datum/rmb_intent
	var/name = "intent"
	var/desc = ""
	var/icon_state = ""
	/// Whether this intent requires user to be adjacent to their target or not
	var/adjacency = TRUE
	/// Determines whether this intent can be used during click cd
	var/bypasses_click_cd = FALSE

/mob/living/carbon/human/on_cmode()
	if(!cmode)	//We just toggled it off.
		addtimer(CALLBACK(src, PROC_REF(purge_bait)), 30 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		addtimer(CALLBACK(src, PROC_REF(expire_peel)), 60 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	if(!HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
		filtered_balloon_alert(TRAIT_COMBAT_AWARE, (cmode ? ("<i><font color = '#831414'>Tense</font></i>") : ("<i><font color = '#c7c6c6'>Relaxed</font></i>")), y_offset = 32)
	if(world.time > last_cmode_time + CMODE_TIME_BUFFER) // This buffer is used purely to prevent type-baiting, it isn't an anti-combat mode spam solution.
		last_cmode_time = world.time

/datum/rmb_intent/proc/special_attack(mob/living/user, atom/target)
	return

/datum/rmb_intent/special
	name = "special"
	desc = "(RMB WHILE DEFENSE IS ACTIVE) A special attack that depends on the type of weapon you are using."
	icon_state = "rmbspecial"