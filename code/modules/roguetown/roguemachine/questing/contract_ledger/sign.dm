/obj/structure/roguemachine/contractledger/proc/play_reject_sound()
	playsound(src, 'sound/misc/machineno.ogg', 80, FALSE, -1)

/obj/structure/roguemachine/contractledger/proc/sign_contract(mob/user, ref)
	if(!ref)
		return
	if(!SStreasury.has_account(user))
		say("[user.real_name] has no bank account on record.")
		play_reject_sound()
		return
	var/datum/quest/Q = locate(ref) in SSquestpool.pool
	if(!Q)
		say("That contract is no longer available.")
		play_reject_sound()
		return
	if(Q.quest_giver_name && Q.quest_giver_name == user.real_name)
		say("You cannot sign a contract you yourself put on the board.")
		play_reject_sound()
		return

	if(is_quest_claim_barred(user))
		say("Your office forbids you from signing contracts. Leave the work to those sworn to it.")
		play_reject_sound()
		return

	var/active_cap = get_active_quest_cap(user)
	if(count_user_active_contracts(user) >= active_cap)
		say("You are already committed to [active_cap] contracts. Complete one before signing another.")
		play_reject_sound()
		return

	if(SSquestpool.is_on_take_cooldown(user))
		var/remaining_seconds = round(SSquestpool.take_cooldown_remaining(user) / 10)
		say("You have taken your fill of contracts. Wait [remaining_seconds]s before signing another.")
		play_reject_sound()
		return

	var/deposit = Q.deposit_amount
	if(SStreasury.get_balance(user) < deposit)
		say("Insufficient balance. This contract requires a [deposit] mammon deposit.")
		play_reject_sound()
		return

	if(!Q.can_claim(user))
		say(Q.claim_failure_reason(user))
		play_reject_sound()
		return

	if(!SSquestpool.claim(Q, user))
		say("That contract could not be dispatched. Try another.")
		play_reject_sound()
		return

	SSquestpool.mark_taken(user)

	var/scroll_type = Q.get_scroll_type()
	var/obj/item/quest_writ/spawned_scroll = new scroll_type(get_turf(src))
	user.put_in_hands(spawned_scroll)
	log_quest(user.ckey, user.mind, user, "Sign [Q.quest_type]")
	spawned_scroll.base_icon_state = Q.get_scroll_icon()
	spawned_scroll.assigned_quest = Q
	Q.quest_scroll = spawned_scroll
	Q.quest_scroll_ref = WEAKREF(spawned_scroll)
	spawned_scroll.update_quest_text()

	// ES deviation: integer ledger, so the deposit is debited straight off the bearer's balance.
	// It is minted back as part of gross_reward on completion, or forfeited (never returned) on abandon.
	SStreasury.bank_accounts[user] -= deposit

/obj/structure/roguemachine/contractledger/proc/resolve_turnin_mode(mob/user, obj/item/quest_writ/scroll, mob/living/holder)
	if(user in scroll.get_quest_assignees(user, TRUE))
		return QUEST_TURNIN_SELF
	if(istype(holder))
		var/datum/fellowship/F = holder.current_fellowship
		if(F && F.has_member(user))
			return QUEST_TURNIN_FELLOWSHIP
	if(user.job in GLOB.contract_proxy_officials)
		return QUEST_TURNIN_OFFICIAL
	return null

/obj/structure/roguemachine/contractledger/proc/turn_in_contract(mob/user, obj/item/quest_writ/scroll_in_hand)
	var/datum/quest/Q = scroll_in_hand.assigned_quest
	if(!Q)
		return
	var/mob/living/holder = Q.quest_receiver_reference?.resolve()
	var/mode = resolve_turnin_mode(user, scroll_in_hand, holder)
	if(!mode)
		to_chat(user, span_warning("You are not the assigned quest receiver for this contract!"))
		return
	turn_in_scroll(user, scroll_in_hand, mode, holder)

/obj/structure/roguemachine/contractledger/proc/turn_in_scroll(mob/user, obj/item/quest_writ/scroll, mode = QUEST_TURNIN_SELF, mob/holder)
	if(!scroll.assigned_quest?.complete)
		return

	var/datum/quest/completed_quest = scroll.assigned_quest
	var/holder_name = completed_quest.quest_receiver_name
	// ES deviation: integer ledger, so the beneficiary is a mob on the ledger rather than
	// an AP fund account. An official's proxy turn-in credits the holder; everyone else
	// (self or fellowship) credits whoever hands the scroll over.
	var/mob/beneficiary = (mode == QUEST_TURNIN_OFFICIAL) ? holder : user
	if(!isliving(beneficiary) || !SStreasury.has_account(beneficiary))
		if(mode == QUEST_TURNIN_OFFICIAL)
			say("[holder_name] has no account on record, the reward cannot be credited.")
		else
			say("No account on record, register with a Nervelock before turning in the contract.")
		return

	var/base_reward = completed_quest.reward_amount
	var/deposit_return = completed_quest.calculate_deposit()
	var/gross_reward = base_reward + deposit_return

	var/quest_levy_exempt = completed_quest.levy_exempt
	if(completed_quest.source == QUEST_SOURCE_TOWNER && hascall(completed_quest, "on_turn_in_pay_giver"))
		call(completed_quest, "on_turn_in_pay_giver")(user, get_turf(src))
	qdel(scroll.assigned_quest)
	qdel(scroll)

	// ES deviation: integer ledger, so the gross is credited straight onto the
	// beneficiary's balance.
	SStreasury.bank_accounts[beneficiary] += gross_reward

	// Levy applies only to the base reward, not the returned deposit. The deposit is the
	// bearer's own money being given back; taxing it would be a hidden levy on principal.
	// ES deviation: AP's apply_tax() fund path is inlined here, mirroring headeater.dm - the
	// levy is debited from the ledger and minted into the Crown's Purse, honouring charter
	// exemptions and rate caps.
	var/tax_amt = 0
	if(quest_levy_exempt)
		var/levy_rate = SStreasury.get_tax_rate(TAX_CATEGORY_CONTRACT_LEVY)
		SStreasury.record_tax_exemption(TAX_CATEGORY_CONTRACT_LEVY, FLOOR(base_reward * levy_rate, 1))
	else
		// The levy runs against the beneficiary, so a fellowship turn-in uses the
		// turner-in's exemptions and caps, and an official's proxy uses the holder's.
		var/base_rate = SStreasury.get_tax_rate(TAX_CATEGORY_CONTRACT_LEVY)
		if(isliving(beneficiary) && SStreasury.is_tax_exempt(beneficiary, TAX_CATEGORY_CONTRACT_LEVY))
			SStreasury.record_tax_exemption(TAX_CATEGORY_CONTRACT_LEVY, FLOOR(base_reward * base_rate, 1))
		else
			var/rate = base_rate
			if(isliving(beneficiary))
				rate = min(rate, SStreasury.get_rate_cap(beneficiary, TAX_CATEGORY_CONTRACT_LEVY))
			if(rate < base_rate)
				SStreasury.record_tax_exemption(TAX_CATEGORY_CONTRACT_LEVY, FLOOR(base_reward * (base_rate - rate), 1))
			tax_amt = FLOOR(base_reward * rate, 1)
			if(tax_amt > 0)
				SStreasury.apply_concordat_tithe(base_reward, TAX_CATEGORY_CONTRACT_LEVY, src.name)
				SStreasury.bank_accounts[beneficiary] -= tax_amt
				SStreasury.mint(SStreasury.discretionary_fund, tax_amt, "Contract Levy")
				record_round_statistic(STATS_REVENUE_CONTRACT_LEVY, tax_amt)
				record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)
				record_featured_stat(FEATURED_STATS_TAX_PAYERS, beneficiary, tax_amt)

	var/guild_fee_paid = pay_innkeeper_referral_fees(beneficiary, completed_quest, gross_reward)

	var/take_home = gross_reward - tax_amt - guild_fee_paid
	SSquestpool.record_completion(user, completed_quest, take_home, tax_amt)

	var/list/deductions = list()
	if(tax_amt > 0)
		deductions += "[tax_amt] mammon to the Crown's Levy"
	if(guild_fee_paid > 0)
		deductions += "[guild_fee_paid] mammon to the Guild's cut"
	var/deductions_clause = length(deductions) ? ", less [english_list(deductions)]" : ""
	var/deposit_clause = deposit_return > 0 ? " The deposit of [deposit_return] mammon is also returned." : ""
	switch(mode)
		if(QUEST_TURNIN_OFFICIAL)
			say("On behalf of [holder_name], a reward of [base_reward] mammon has been credited to their account[deductions_clause].[deposit_clause]")
		if(QUEST_TURNIN_FELLOWSHIP)
			say("On [holder_name]'s behalf, your reward of [base_reward] mammon has been credited[deductions_clause].[deposit_clause]")
		else
			say("Your reward of [base_reward] mammon has been credited[deductions_clause].[deposit_clause]")

/obj/structure/roguemachine/contractledger/proc/abandon_by_ref(mob/user, ref)
	if(!ref)
		return
	var/datum/weakref/user_ref = WEAKREF(user)
	var/obj/item/quest_writ/matched_scroll
	var/datum/quest/matched_quest
	for(var/obj/item/quest_writ/scroll in GLOB.quest_scrolls)
		var/datum/quest/Q = scroll.assigned_quest
		if(!Q || Q.quest_receiver_reference != user_ref)
			continue
		if(REF(Q) != ref)
			continue
		matched_scroll = scroll
		matched_quest = Q
		break
	if(!matched_quest)
		to_chat(user, span_warning("That contract is not yours to abandon."))
		return
	if(matched_quest.complete)
		to_chat(user, span_warning("That contract is already complete - turn it in instead."))
		return
	var/forfeited = matched_quest.calculate_deposit()
	log_quest(user.ckey, user.mind, user, "Abandon [matched_quest.quest_type]")
	SSquestpool.mark_abandoned(user, matched_quest, forfeited)
	to_chat(user, span_warning("The contract is voided. Your deposit of [forfeited] mammon is forfeit."))
	matched_scroll.assigned_quest = null
	qdel(matched_quest)
	qdel(matched_scroll)


