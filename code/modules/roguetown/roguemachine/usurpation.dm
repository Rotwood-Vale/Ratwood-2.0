/datum/usurpation_rite
	var/name = "Usurpation Rite"
	var/desc = "A rite to claim the throne."
	var/explanation = "A rite of succession."
	var/stage = RITE_STAGE_INACTIVE
	var/mob/living/carbon/human/invoker
	var/obj/structure/roguethrone/throne
	var/list/assenters
	var/phase_timer_id
	var/new_ruler_title = "Grand Duke"
	var/new_ruler_title_f = "Grand Duchess"
	var/new_realm_type = "Grand Duchy"
	var/new_realm_type_short = "Duchy"
	var/mob/living/carbon/human/contester
	var/contester_timer_id
	var/contest_time_remaining = 0
	var/contest_started_at = 0
	var/roundend_epilogue

/datum/usurpation_rite/New()
	. = ..()
	assenters = list()

/datum/usurpation_rite/Destroy()
	cleanup()
	return ..()

/datum/usurpation_rite/proc/can_invoke(mob/living/carbon/human/user)
	return istype(user) && user.mind && user.stat == CONSCIOUS && SSticker.rulermob != user

/datum/usurpation_rite/proc/begin(mob/living/carbon/human/user, obj/structure/roguethrone/target_throne)
	if(!can_invoke(user) || !target_throne || get_dist(user, target_throne) > RITE_ASSENT_RANGE || target_throne.active_rite)
		return FALSE
	invoker = user
	throne = target_throne
	throne.active_rite = src
	stage = RITE_STAGE_GATHERING
	RegisterSignal(invoker, list(COMSIG_QDELETING, COMSIG_MOB_DEATH), PROC_REF(on_invoker_death))
	on_gathering_started()
	return TRUE

/datum/usurpation_rite/proc/on_gathering_started()
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(on_gathering_timeout)), RITE_GATHERING_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/proc/on_gathering_timeout()
	fail("The voices of ambition did not grant sufficient assent.")

/datum/usurpation_rite/proc/try_assent(mob/living/carbon/human/supporter)
	if(stage != RITE_STAGE_GATHERING || !istype(supporter) || supporter.stat != CONSCIOUS)
		return FALSE
	if(supporter == invoker)
		to_chat(supporter, span_warning("You cannot assent to your own claim."))
		return FALSE
	if(!is_qualified_voice(supporter))
		to_chat(supporter, span_warning("Only arcyne-trained, Zizo's faithful, or the undead may assent."))
		return FALSE
	if(assenters[supporter] || !throne || get_dist(supporter, throne) > RITE_ASSENT_RANGE)
		return FALSE
	assenters[supporter] = TRUE
	on_assent_accepted(supporter)
	check_assent_threshold()
	return TRUE

/datum/usurpation_rite/proc/is_qualified_voice(mob/living/carbon/human/supporter)
	return HAS_TRAIT(supporter, TRAIT_ARCYNE) || istype(supporter.patron, /datum/patron/inhumen/zizo) || HAS_TRAIT(supporter, TRAIT_ROTMAN) || (supporter.mob_biotypes & MOB_UNDEAD)

/datum/usurpation_rite/proc/on_assent_accepted(mob/living/carbon/human/supporter)
	supporter.visible_message(
		span_notice("[supporter.real_name] speaks assent to [name]."),
		span_notice("I speak my assent. Ambition demands no less.")
	)
	to_chat(invoker, span_notice("[supporter.real_name] has assented. ([length(assenters)]/[DOMINION_REQUIRED_ASSENTS])"))

/datum/usurpation_rite/proc/check_assent_threshold()
	if(length(assenters) >= DOMINION_REQUIRED_ASSENTS)
		start_contesting()

/datum/usurpation_rite/proc/try_abdication(mob/living/carbon/human/ruler)
	if(stage >= RITE_STAGE_CONTESTING || ruler == invoker || (SSticker.rulermob != ruler && SSticker.regentmob != ruler))
		return FALSE
	if(!throne || get_dist(ruler, throne) > RITE_ASSENT_RANGE)
		return FALSE
	var/confirm = tgui_alert(ruler, "Are you certain you wish to abdicate? This will begin contestation.", "Abdication", list("Abdicate", "Cancel"))
	if(confirm != "Abdicate" || QDELETED(ruler) || ruler.stat != CONSCIOUS || (SSticker.rulermob != ruler && SSticker.regentmob != ruler))
		return FALSE
	start_contesting()
	return TRUE

/datum/usurpation_rite/proc/start_contesting()
	if(!invoker || invoker.stat != CONSCIOUS || !throne)
		fail("The claimant cannot continue the rite.")
		return
	stage = RITE_STAGE_CONTESTING
	if(phase_timer_id)
		deltimer(phase_timer_id)
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(complete)), RITE_CONTEST_DURATION, TIMER_STOPPABLE)
	contest_time_remaining = RITE_CONTEST_DURATION
	contest_started_at = world.time
	on_contesting_started()

/datum/usurpation_rite/proc/on_contesting_started()
	return

/datum/usurpation_rite/proc/start_counter_claim(mob/living/carbon/human/claimant)
	if(stage != RITE_STAGE_CONTESTING || !istype(claimant) || claimant.stat != CONSCIOUS || !throne || !(claimant in throne.buckled_mobs) || claimant == invoker || contester)
		return FALSE
	contest_time_remaining -= world.time - contest_started_at
	if(contest_time_remaining <= 0)
		return FALSE
	if(phase_timer_id)
		deltimer(phase_timer_id)
		phase_timer_id = null
	contester = claimant
	RegisterSignal(contester, list(COMSIG_QDELETING, COMSIG_MOB_DEATH), PROC_REF(on_contester_invalid))
	contester_timer_id = addtimer(CALLBACK(src, PROC_REF(on_counter_claim_complete)), RITE_COUNTER_CLAIM_DURATION, TIMER_STOPPABLE)
	to_chat(invoker, span_warning("[claimant.real_name] is attempting to stop the rite from the throne!"))
	return TRUE

/datum/usurpation_rite/proc/cancel_counter_claim()
	if(!contester)
		return
	if(contester_timer_id)
		deltimer(contester_timer_id)
		contester_timer_id = null
	var/mob/living/carbon/human/old_contester = contester
	UnregisterSignal(old_contester, list(COMSIG_QDELETING, COMSIG_MOB_DEATH))
	contester = null
	to_chat(old_contester, span_warning("You have left the throne. Your attempt to stop the rite has failed."))
	to_chat(invoker, span_notice("The contester has left the throne."))
	if(stage == RITE_STAGE_CONTESTING && contest_time_remaining > 0)
		contest_started_at = world.time
		phase_timer_id = addtimer(CALLBACK(src, PROC_REF(complete)), contest_time_remaining, TIMER_STOPPABLE)

/datum/usurpation_rite/proc/on_counter_claim_complete()
	contester_timer_id = null
	var/contester_name = contester?.real_name || "another"
	if(contester)
		UnregisterSignal(contester, list(COMSIG_QDELETING, COMSIG_MOB_DEATH))
	contester = null
	fail("The throne has been held by [contester_name], halting the succession.")

/datum/usurpation_rite/proc/on_contester_invalid(datum/source)
	SIGNAL_HANDLER
	cancel_counter_claim()

/datum/usurpation_rite/proc/complete()
	if(!invoker || invoker.stat != CONSCIOUS || !throne || get_dist(invoker, throne) > RITE_CONTEST_PROXIMITY)
		fail("The claimant could not hold their claim near the throne.")
		return
	stage = RITE_STAGE_COMPLETE
	on_complete()
	cleanup()

/datum/usurpation_rite/proc/on_complete()
	if(roundend_epilogue)
		SSticker.roundend_epilogue = roundend_epilogue
	transfer_power()

/datum/usurpation_rite/proc/transfer_power()
	var/static/list/lord_spells = list(
		/obj/effect/proc_holder/spell/self/grant_title,
		/obj/effect/proc_holder/spell/self/grant_nobility,
		/obj/effect/proc_holder/spell/self/convertrole/servant,
		/obj/effect/proc_holder/spell/self/convertrole/guard,
		/obj/effect/proc_holder/spell/self/convertrole/bog,
	)
	for(var/mob/living/carbon/human/old_ruler in GLOB.human_list)
		if(old_ruler.mind?.assigned_role == "Grand Duke")
			old_ruler.mind.assigned_role = "Towner"
			for(var/spell_type in lord_spells)
				old_ruler.mind.RemoveSpell(spell_type)
		if(old_ruler.job == "Grand Duke")
			old_ruler.job = "Towner"
			old_ruler.advjob = "[SSticker.rulertype] Emeritus"
			GLOB.lord_titles[old_ruler.real_name] = old_ruler.advjob

	var/datum/job/roguetown/lord_job = SSjob.GetJob("Grand Duke")
	if(lord_job)
		lord_job.display_title = new_ruler_title
		lord_job.f_title = new_ruler_title_f
		lord_job.total_positions = -1000
	SSticker.realm_type = new_realm_type
	SSticker.realm_type_short = new_realm_type_short
	invoker.mind.assigned_role = "Grand Duke"
	invoker.job = "Grand Duke"
	for(var/spell_type in lord_spells)
		invoker.mind.AddSpell(new spell_type)
	SSticker.set_ruler_mob(invoker)
	SSticker.regentmob = null
	SSticker.usurpation_day = GLOB.dayspassed
	removeomen(OMEN_NOLORD)

	var/obj/item/clothing/head/roguetown/crown/serpcrown/crown = SSroguemachine.crown
	if(crown)
		var/mob/holder = get_containing_mob(crown)
		if(holder && holder != invoker && ishuman(holder))
			var/mob/living/carbon/human/old_holder = holder
			old_holder.dropItemToGround(crown, TRUE)
			to_chat(old_holder, span_warning("The crown is wrenched from you by an unseen force!"))
		crown.forceMove(get_turf(invoker))
	to_world("<b><span class='notice'><span class='big'>[invoker.real_name] is [SSticker.rulertype] of [SSticker.realm_name].</span></span></b>")

/datum/usurpation_rite/proc/fail(reason)
	on_fail(reason)
	cleanup()

/datum/usurpation_rite/proc/on_fail(reason)
	if(invoker)
		to_chat(invoker, span_warning("[name] has failed. [reason]"))

/datum/usurpation_rite/proc/cleanup()
	cancel_counter_claim()
	if(phase_timer_id)
		deltimer(phase_timer_id)
		phase_timer_id = null
	if(invoker)
		UnregisterSignal(invoker, list(COMSIG_QDELETING, COMSIG_MOB_DEATH))
	if(throne)
		throne.active_rite = null
		throne = null
	invoker = null
	assenters = null

/datum/usurpation_rite/proc/on_invoker_death(datum/source)
	SIGNAL_HANDLER
	fail("The claimant has fallen.")

/datum/usurpation_rite/proc/get_status_text()
	if(stage == RITE_STAGE_GATHERING)
		var/gathering_time_left = timeleft(phase_timer_id)
		return "[name] is gathering assent. [length(assenters)]/[DOMINION_REQUIRED_ASSENTS] voices have assented. [DisplayTimeText(gathering_time_left)] remain to gather the required voices."
	if(stage == RITE_STAGE_CONTESTING)
		var/contest_time_left = contest_time_remaining
		if(!contester)
			contest_time_left -= world.time - contest_started_at
		var/status_text = "The throne is contested in the name of [name]. The claim will complete in [DisplayTimeText(max(0, contest_time_left))]."
		if(contester)
			status_text += " A challenger is holding the throne; the contest timer is paused. Their attempt will succeed in [DisplayTimeText(timeleft(contester_timer_id))] if uninterrupted."
		return status_text
	return null
