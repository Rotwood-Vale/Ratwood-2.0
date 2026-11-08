/datum/usurpation_rite/ambitious_dominion
	name = "Rite of Ambitious Dominion"
	desc = "The weak and complacent must yield. Those with the will to seize the future shall rule."
	explanation = "The Ashen Host Commander may claim the throne in Zizo's name. Five arcyne-trained, Zizite, or undead voices must assent near the throne. Then hold the claim for ten minutes."
	new_ruler_title = "Exarch"
	new_ruler_title_f = "Exarch"
	new_realm_type = "Dominion"
	new_realm_type_short = "Dominion"

/datum/usurpation_rite/ambitious_dominion/can_invoke(mob/living/carbon/human/user)
	return ..() && user.mind?.has_antag_datum(/datum/antagonist/ashen_host/leader) && ("Ashen Host" in user.faction)

/datum/usurpation_rite/ambitious_dominion/on_gathering_started()
	to_chat(invoker, span_notice("The rite has begun. Within [RITE_GATHERING_DURATION / (1 MINUTES)] minutes, five arcyne-trained, Zizo-faithful, or undead voices must speak 'I assent' near the throne. The ruler or regent may say 'I abdicate' to begin the contest early."))
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(on_gathering_timeout)), RITE_GATHERING_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/ambitious_dominion/on_assent_accepted(mob/living/carbon/human/supporter)
	supporter.visible_message(
		span_notice("[supporter.real_name] speaks assent to the Rite of Ambitious Dominion."),
		span_notice("I speak my assent. Ambition demands no less.")
	)
	to_chat(invoker, span_notice("[supporter.real_name] has assented. ([length(assenters)]/[DOMINION_REQUIRED_ASSENTS])"))

/datum/usurpation_rite/ambitious_dominion/on_contesting_started()
	priority_announce(
		"[invoker.real_name] has invoked the Rite of Ambitious Dominion! In Zizo's name, a claim is made upon the throne of [SSticker.realm_name]. Five voices have affirmed the claim. Hold the throne's vicinity for [RITE_CONTEST_DURATION / (1 MINUTES)] minutes to complete the succession.",
		"Rite of Ambitious Dominion"
	)
	to_chat(invoker, span_notice("Your ambition has been heard. Stay within [RITE_CONTEST_PROXIMITY] tiles of the throne and remain conscious until the contest ends."))

/datum/usurpation_rite/ambitious_dominion/on_complete()
	SSgamemode.start_rite_end_vote()
	if(HAS_TRAIT(invoker, TRAIT_ROTMAN) || (invoker.mob_biotypes & MOB_UNDEAD))
		roundend_epilogue = "One can conquer a realm on a tide of bones. But the dead bear no children and hold no true will. How long will the living tolerate their rule?"
	else
		roundend_epilogue = "Zizo's ambition will remake the realm. Long live [invoker.real_name], Exarch of [SSticker.realm_name]!"
	..()
	priority_announce(
		"With ambition as their guide and Zizo's will as their mandate, [invoker.real_name] is declared the Exarch of [SSticker.realm_name]. The old order gives way to the Ashen Host. A vote to end the round will now be called.",
		"A New Exarch Ascends"
	)

/datum/controller/subsystem/gamemode/proc/start_rite_end_vote()
	if(roundvoteend)
		return
	if(SSvote.current_vote)
		addtimer(CALLBACK(src, PROC_REF(start_rite_end_vote)), 1 MINUTES)
		return
	SSvote.initiate_vote("endround", "the Rite of Ambitious Dominion", null, forced = TRUE)
