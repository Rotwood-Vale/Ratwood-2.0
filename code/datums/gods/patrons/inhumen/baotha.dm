/datum/patron/inhumen/baotha
	name = "Baotha"
	domain = "Hedonism, Debauchery, Addiction, Heartbreak"
	desc = "The Lady of Debauchery was the only snow elf to have survived Zizo's massacre, having been kept by the Naledi as a concubine. Until one dae, She was consumed by Her depravity and addiction, stealing a shard of SYON from Her captors and ascending to godhood. Her followers desire only to experience mind-rotting pleasures."
	worshippers = "Widows, Gamblers, Addicts, Scorned Lovers, Far-Gone Prostitutes"
	virtues = "Lust, Gluttony, Thrill-Seeking"
	sins = "Chastity, Temperance, Gloom"
	mob_traits = list(TRAIT_DEPRAVED, TRAIT_CRACKHEAD)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison					= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/baothavice					= CLERIC_T0,
					/obj/effect/proc_holder/spell/targeted/touch/loversruin				= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/baothablessings				= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/griefflower					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/projectile/blowingdust		= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/joyride						= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/lasthigh						= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/painkiller					= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/resurrect/baotha				= CLERIC_T4,
	)
	confess_lines = list(
		"BAOTHA DEMANDS PLEASURE!",
		"LIVE, LAUGH, LOVE!",
		"BAOTHA IS MY JOY!",
	)
	storyteller = /datum/storyteller/baotha

/datum/patron/inhumen/baotha/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer in the Zzzzzzzurch(!)
	if(istype(get_area(follower), /area/rogue/indoors/shelter/mountains))
		return TRUE
	// Allows prayer near EEEVIL psycross
	for(var/obj/structure/fluff/psycross/zizocross/cross in view(4, get_turf(follower)))
		if(cross.divine == TRUE)
			to_chat(follower, span_danger("That acursed cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayers in the bath house - whore.
	if(istype(get_area(follower), /area/rogue/indoors/town/bath))
		return TRUE
	// Allows prayers if actively high on drugs.
	if(follower.has_status_effect(/datum/status_effect/buff/ozium) || follower.has_status_effect(/datum/status_effect/buff/moondust) || follower.has_status_effect(/datum/status_effect/buff/moondust_purest) || follower.has_status_effect(/datum/status_effect/buff/druqks) || follower.has_status_effect(/datum/status_effect/buff/starsugar))
		return TRUE
	// Allows prayers if the user is drunk.
	if(follower.has_status_effect(/datum/status_effect/buff/drunk))
		return TRUE
	// Allows praying atop ritual chalk of the god.
	for(var/obj/structure/ritualcircle/baotha in view(1, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("For Baotha to hear my prayers I must either be in the church of the abandoned, near an inverted psycross, within the town's bathhouse, or actively partaking in one of various types of nose-candy!"))
	return FALSE

#define BAOTHA_SUFFERING_DIVIDER 3.535 // max bonus at 50 pain/bleedrate and pain_mod = 1

/datum/patron/inhumen/baotha/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus,
	is_inhumen
)
	*is_inhumen = TRUE
	*message_out = span_info("Hedonistic impulses and emotions throb all about from [target].")
	*message_self = span_notice("An intoxicating rush of narcotic delight soothes my suffering!")

	if(!ishuman(target))
		*message_self = span_notice("An intoxicating rush of narcotic delight flows through me!")
		return

	var/mob/living/carbon/human/human_target = target
	var/bonus = 0

	if(human_target.has_status_effect(/datum/status_effect/buff/druqks) \
	|| human_target.has_status_effect(/datum/status_effect/buff/drunk))
		bonus += 0.5

	if(human_target.get_stress_event(/datum/stressevent/lasthigh))
		bonus += 0.5

	if(!HAS_TRAIT(target, TRAIT_NOPAIN) || HAS_TRAIT(target, TRAIT_CRACKHEAD))
		var/raw_suffering = 0

		for(var/datum/wound/wound in human_target.get_wounds())
			raw_suffering += wound.woundpain + wound.bleed_rate

		var/suffering = sqrt(raw_suffering) / BAOTHA_SUFFERING_DIVIDER
		var/to_add = HAS_TRAIT(target, TRAIT_DEPRAVED) ? suffering : suffering * human_target.physiology.pain_mod
		bonus += min(to_add, 2)

	*conditional_buff = TRUE
	*situational_bonus = bonus

// - BAOTHA REVIVAL - //

/obj/effect/proc_holder/spell/invoked/resurrect/baotha
	name = "Drive the Thorns Deep"
	desc = "Revives the target by afflicting them with a lasting addiction."
	debuff_type = /datum/status_effect/debuff/baotha_addiction
	alt_required_items = list(/obj/item/natural/thorn = 3)
	required_items = list(/obj/item/natural/thorn = 7)
	sound = 'sound/magic/slimesquish.ogg'
	chargedloop = /datum/looping_sound/invokeascendant
	harms_undead = FALSE
	overlay_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_state = "revival"
	action_icon_state = "revival"
	action_icon = 'icons/mob/actions/baothamiracles.dmi'
	required_structure = /obj/structure/fluff/psycross/baotha

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
	RegisterSignal(owner, COMSIG_DRUG_SNIFFED, PROC_REF(on_sniff))

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


#undef BAOTHA_SUFFERING_DIVIDER
