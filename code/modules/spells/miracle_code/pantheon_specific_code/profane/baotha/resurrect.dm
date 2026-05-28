/datum/action/cooldown/spell/resurrect/baotha
	name = "Drive the Thorns Deep"
	desc = "Revives the target by afflicting them with a lasting addiction."
	debuff_type = /datum/status_effect/debuff/baotha_addiction
	alt_required_items = list(/obj/item/natural/thorn = 3)
	required_items = list(/obj/item/natural/thorn = 7)
	sound = 'sound/magic/slimesquish.ogg'
	chargedloop = /datum/looping_sound/invokelightning
	harms_undead = FALSE
	overlay_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_state = "revival"
	action_icon_state = "revival"
	action_icon = 'icons/mob/actions/baothamiracles.dmi'
	required_structure = /obj/structure/fluff/psycross/baotha
	req_items = list() // temp. baothans dont have a holy symbol. apparently one is being commed so this is just the stopgap.


/datum/stressevent/baotha_withdrawal_severe
	timer = 999 MINUTES
	stressadd = 10
	desc = span_userdanger("Everything is loud and grey. Where is the dust?!")

/datum/status_effect/debuff/baotha_addiction
	id = "baotha_addiction"
	duration = 15 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/baotha_addiction
	var/last_sniff_time = 0
	var/withdrawal_active = FALSE
	var/message_cooldown = 2 MINUTES
	var/current_cooldown = 0
	var/list/regret_msgs = list(
		span_italics("The face of someone you failed drifts through your vision, their expression frozen in disappointment."),
		span_warning("A sudden, cold weight settles in your chest as you remember a door you should never have opened."),
		span_userdanger("The air tastes like copper and old dust. You can almost hear the screams from that day again."),
		span_italics("You feel a phantom touch on your shoulder—a hand that belonged to someone long since gone."),
		span_warning("A memory of a choice made in haste burns in your mind like a hot coal."),
		span_italics("A voice that sounds like a dying fire whispers, 'You could have saved them.'")
	)

/datum/status_effect/debuff/baotha_addiction/proc/send_creepy_message()
	var/mob/living/L = owner
	if(!L)
		return
	to_chat(L, pick(regret_msgs))

/datum/status_effect/debuff/baotha_addiction/on_apply()
	. = ..()
	// We apply withdrawals immediately
	last_sniff_time = world.time - (5 MINUTES)
	current_cooldown = world.time + message_cooldown
	RegisterSignal(owner, COMSIG_DRUG_SNIFFED, .proc/on_sniff)

/datum/status_effect/debuff/baotha_addiction/proc/on_sniff()
	SIGNAL_HANDLER
	last_sniff_time = world.time
	if(withdrawal_active)
		stop_withdrawal()

/datum/status_effect/debuff/baotha_addiction/process(delta_time)
	if(world.time > last_sniff_time + 5 MINUTES)
		if(!withdrawal_active)
			start_withdrawal()
	else
		if(withdrawal_active)
			stop_withdrawal()

	if(world.time >= current_cooldown)
		send_creepy_message()
		current_cooldown = world.time + message_cooldown

/datum/status_effect/debuff/baotha_addiction/proc/start_withdrawal()
	withdrawal_active = TRUE
	owner.apply_status_effect(/datum/status_effect/debuff/baotha_withdrawal_stats)
	var/mob/living/carbon/human/H = owner
	H.add_stress(/datum/stressevent/baotha_withdrawal_severe)
	to_chat(owner, span_userdanger("The craving for dust becomes unbearable..."))

/datum/status_effect/debuff/baotha_addiction/proc/stop_withdrawal()
	withdrawal_active = FALSE
	owner.remove_status_effect(/datum/status_effect/debuff/baotha_withdrawal_stats)
	var/mob/living/carbon/human/H = owner
	H.remove_stress(/datum/stressevent/baotha_withdrawal_severe)
	to_chat(owner, span_nicegreen("The sweet sting of the drugs calms your nerves. Relief."))

/datum/status_effect/debuff/baotha_addiction/on_remove()
	UnregisterSignal(owner, COMSIG_DRUG_SNIFFED)
	stop_withdrawal()
	. = ..()

/datum/status_effect/debuff/baotha_withdrawal_stats
	id = "baotha_withdrawal_stats"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/baotha_withdrawal
	// Mild debuff because it's mixed with a mood debuff!
	effectedstats = list(
		STATKEY_STR = -1,
		STATKEY_PER = -1
	)

/atom/movable/screen/alert/status_effect/baotha_addiction
	name = "Endless Addiction"
	desc = "Baotha's gifts come with a price. Your body now craves drugs. Tick tock..."

/atom/movable/screen/alert/status_effect/baotha_withdrawal
	name = "Withdrawal"
	desc = "You are weak, slow, and miserable. Sniff something quickly to restore your strength!"
