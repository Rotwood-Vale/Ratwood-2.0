/datum/status_effect/buff/gods_blessings
	id = "gods_blessings"
	duration = 3 MINUTES
	tick_interval = 10 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/gods_blessings

/datum/status_effect/buff/gods_blessings/on_apply()
	. = ..()
	if(!.)
		return FALSE

	ADD_TRAIT(owner, TRAIT_NOPAIN, id)
	ADD_TRAIT(owner, TRAIT_NOPAINSTUN, id)
	ADD_TRAIT(owner, TRAIT_INFINITE_STAMINA, id)
	ADD_TRAIT(owner, TRAIT_IGNORESLOWDOWN, id)
	ADD_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, id)

	owner.setStaminaLoss(0)
	owner.update_stamina()
	owner.updatehealth()
	return TRUE

/datum/status_effect/buff/gods_blessings/tick()
	if(owner.stat == DEAD)
		qdel(src)
		return

	owner.heal_overall_damage(2, 2, 8, null, FALSE)
	owner.adjustOxyLoss(-1, FALSE)
	owner.adjustToxLoss(-1, FALSE)
	owner.heal_wounds(1)
	owner.setStaminaLoss(0, FALSE)
	owner.update_stamina()
	owner.updatehealth()

/datum/status_effect/buff/gods_blessings/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, id)
	REMOVE_TRAIT(owner, TRAIT_NOPAINSTUN, id)
	REMOVE_TRAIT(owner, TRAIT_INFINITE_STAMINA, id)
	REMOVE_TRAIT(owner, TRAIT_IGNORESLOWDOWN, id)
	REMOVE_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, id)
	owner.update_stamina()
	owner.updatehealth()

/atom/movable/screen/alert/status_effect/buff/gods_blessings
	name = "God's Blessings"
	desc = "Divine favor dulls pain, sustains my stamina, shrugs off slowing, and slowly mends my injuries."
	icon_state = "regenerative_core"

/client/proc/bless()
	set category = "-GameMaster-"
	set name = "Bless"
	set desc = "Grant God's Blessings to a selected player for 3 minutes."

	if(!check_rights(R_ADMIN))
		return

	var/mob/living/target = adminspell_get_target()
	if(!target)
		return
	if(target.stat == DEAD)
		to_chat(src, span_warning("The selected player must be alive to receive God's Blessings."))
		return

	var/already_blessed = target.has_status_effect(/datum/status_effect/buff/gods_blessings)
	target.apply_status_effect(/datum/status_effect/buff/gods_blessings)

	if(already_blessed)
		to_chat(src, span_notice("Refreshed God's Blessings on [target] for 3 minutes."))
		to_chat(target, span_notice("God's Blessings are renewed upon me."))
		log_admin("[key_name(usr)] refreshed God's Blessings on [key_name(target)].")
		message_admins(span_adminnotice("[key_name_admin(usr)] refreshed God's Blessings on [key_name_admin(target)]."))
		admin_ticket_log(target, "<font color='green'>[key_name_admin(usr)] has refreshed God's Blessings on you for 3 minutes.</font>")
	else
		to_chat(src, span_notice("Granted God's Blessings to [target] for 3 minutes."))
		to_chat(target, span_notice("God's Blessings settle over me."))
		log_admin("[key_name(usr)] granted God's Blessings to [key_name(target)] for 3 minutes.")
		message_admins(span_adminnotice("[key_name_admin(usr)] granted God's Blessings to [key_name_admin(target)] for 3 minutes."))
		admin_ticket_log(target, "<font color='green'>[key_name_admin(usr)] has blessed you with God's Blessings for 3 minutes.</font>")

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Bless")
