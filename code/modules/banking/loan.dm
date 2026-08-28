// Loan system: player loans (personal debt) and institutional indentures (fund-to-fund).

/datum/loan
	var/debtor_name
	var/datum/weakref/debtor_ref
	var/principal = 0
	var/interest_rate = 0.25
	var/days_total = 2
	var/issued_on_day = 0
	var/due_on_day = 0
	var/total_due = 0
	var/repaid_so_far = 0
	var/defaulted = FALSE
	var/issuer_name
	var/datum/fund/source_fund
	var/datum/fund/target_fund
	var/is_institutional = FALSE

/datum/loan/New(mob/living/carbon/human/debtor, amount, term, rate, issuer, datum/fund/from_fund, datum/fund/to_fund)
	. = ..()
	if(debtor)
		debtor_name = debtor.real_name
		debtor_ref = WEAKREF(debtor)
	principal = amount
	days_total = term
	interest_rate = rate
	issuer_name = issuer
	source_fund = from_fund
	target_fund = to_fund
	is_institutional = !isnull(to_fund)
	if(is_institutional && !debtor_name)
		debtor_name = to_fund?.name
	issued_on_day = GLOB.dayspassed
	due_on_day = GLOB.dayspassed + days_total
	total_due = compute_total_due()

/datum/loan/proc/get_faction_debtor_trait()
	if(istype(source_fund, /datum/fund/church))
		return TRAIT_DEBTOR_CHURCH
	if(istype(source_fund, /datum/fund/merchant))
		return TRAIT_DEBTOR_MERCHANT
	if(istype(source_fund, /datum/fund/bathhouse))
		return TRAIT_DEBTOR_BATHHOUSE
	return TRAIT_DEBTOR_CROWN

/datum/loan/proc/compute_total_due()
	return FLOOR(principal * (1 + (interest_rate * max(1, days_total))), 1)

/datum/loan/proc/get_remaining_due()
	var/elapsed_days = max(1, GLOB.dayspassed - issued_on_day)
	var/accrued_interest = FLOOR(principal * interest_rate * elapsed_days, 1)
	var/current_owed = principal + accrued_interest
	if(current_owed > total_due)
		current_owed = total_due
	return max(current_owed - repaid_so_far, 0)

/datum/loan/proc/days_until_due()
	return max(due_on_day - GLOB.dayspassed, 0)

/datum/loan/proc/minutes_until_due()
	var/days_remaining = days_until_due()
	if(days_remaining <= 0)
		return 0
	var/current_st = station_time()
	var/dawn_time = SSnightshift.nightshift_dawn_start
	var/ds_until_next_dawn
	if(current_st <= dawn_time)
		ds_until_next_dawn = dawn_time - current_st
	else
		ds_until_next_dawn = (MIDNIGHT_ROLLOVER - current_st) + dawn_time
	var/full_days_after_next = max(0, days_remaining - 1)
	var/total_station_ds = ds_until_next_dawn + (full_days_after_next * MIDNIGHT_ROLLOVER)
	return round(total_station_ds / (SSticker.station_time_rate_multiplier * 600))

/datum/loan/proc/format()
	var/pct = round(interest_rate * 100)
	if(defaulted)
		return "[debtor_name]: [principal]m principal @ [pct]%/day over [days_total] day\s - [get_remaining_due()]m outstanding (DEFAULTED day [due_on_day])"
	return "[debtor_name]: [principal]m principal @ [pct]%/day over [days_total] day\s - [get_remaining_due()]m due (day [due_on_day], [days_until_due()] day\s left)"

/datum/loan/proc/get_debtor_mob()
	if(!debtor_ref)
		return null
	var/mob/living/carbon/human/H = debtor_ref.resolve()
	if(QDELETED(H))
		return null
	return H

/datum/controller/subsystem/treasury/proc/get_loan_for(mob/living/carbon/human/H)
	if(!H)
		return null
	for(var/datum/loan/L in loans)
		if(L.is_institutional)
			continue
		if(!L.debtor_ref)
			continue
		var/mob/living/carbon/human/resolved = L.debtor_ref.resolve()
		if(resolved == H)
			return L
	return null

/// Repay up to `amount` toward an institutional indenture from the target fund's balance.
/datum/controller/subsystem/treasury/proc/repay_indenture(datum/loan/L, amount)
	if(!L || !L.is_institutional || amount <= 0)
		return 0
	var/datum/fund/target = L.target_fund
	var/datum/fund/source = L.source_fund
	if(!target || !source)
		return 0
	var/outstanding = L.get_remaining_due()
	amount = min(amount, outstanding, target.balance)
	if(amount <= 0)
		return 0
	if(!transfer(target, source, amount, L.defaulted ? "Indenture settlement (manual)" : "Indenture repayment (early)"))
		return 0
	L.repaid_so_far += amount
	if(L.get_remaining_due() <= 0)
		loans -= L
		qdel(L)
	return amount

/// Repay up to `amount` toward the caller's personal loan. ES: reads integer bank_accounts.
/datum/controller/subsystem/treasury/proc/repay_loan(mob/living/carbon/human/debtor, amount)
	if(!debtor || amount <= 0)
		return 0
	var/datum/loan/L = get_loan_for(debtor)
	if(!L)
		return 0
	var/debtor_balance = bank_accounts[debtor]
	if(isnull(debtor_balance))
		return 0
	var/datum/fund/destination = L.source_fund
	if(!destination)
		return 0
	var/outstanding = L.get_remaining_due()
	amount = min(amount, outstanding, debtor_balance)
	if(amount <= 0)
		return 0
	bank_accounts[debtor] -= amount
	mint(destination, amount, L.defaulted ? "Default debt settlement" : "Loan repayment")
	L.repaid_so_far += amount
	if(L.get_remaining_due() <= 0)
		if(L.defaulted)
			REMOVE_TRAIT(debtor, TRAIT_DEBTOR, TRAIT_GENERIC)
			REMOVE_TRAIT(debtor, L.get_faction_debtor_trait(), TRAIT_GENERIC)
			to_chat(debtor, span_notice("The stigma of default is lifted. Your debt to [destination.name] is paid in full."))
		loans -= L
		qdel(L)
	return amount

/datum/controller/subsystem/treasury/proc/tick_loans()
	for(var/datum/loan/L in loans.Copy())
		if(L.is_institutional)
			tick_indenture(L)
			continue
		var/mob/living/carbon/human/debtor = L.get_debtor_mob()
		if(!debtor)
			log_game("LOAN PRUNED: [L.debtor_name] - debtor mob no longer exists, loan orphaned.")
			loans -= L
			qdel(L)
			continue
		if(GLOB.dayspassed < L.due_on_day)
			continue
		var/datum/fund/destination = L.source_fund
		if(!destination)
			continue
		var/outstanding = L.get_remaining_due()
		if(outstanding <= 0)
			if(L.defaulted)
				REMOVE_TRAIT(debtor, TRAIT_DEBTOR, TRAIT_GENERIC)
				REMOVE_TRAIT(debtor, L.get_faction_debtor_trait(), TRAIT_GENERIC)
			loans -= L
			qdel(L)
			continue
		// ES: player balance is an integer in bank_accounts.
		var/debtor_balance = bank_accounts[debtor] || 0
		if(debtor_balance >= outstanding)
			bank_accounts[debtor] -= outstanding
			mint(destination, outstanding, L.defaulted ? "Default debt settlement (auto)" : "Loan repayment (maturity)")
			L.repaid_so_far += outstanding
			if(L.defaulted)
				REMOVE_TRAIT(debtor, TRAIT_DEBTOR, TRAIT_GENERIC)
				REMOVE_TRAIT(debtor, L.get_faction_debtor_trait(), TRAIT_GENERIC)
				send_ooc_note("<b>NERVELOCK:</b> The stigma of default is lifted. [outstanding]m was drawn from your account to settle the outstanding debt in full.", name = debtor.real_name)
			else
				send_ooc_note("<b>NERVELOCK:</b> Your loan of [L.principal]m has been repaid in full ([outstanding]m drawn from your account).", name = debtor.real_name)
			loans -= L
			qdel(L)
			continue
		if(!L.defaulted)
			L.defaulted = TRUE
			var/seized = debtor_balance
			if(seized > 0)
				bank_accounts[debtor] = 0
				mint(destination, seized, "Loan default seizure")
				L.repaid_so_far += seized
			ADD_TRAIT(debtor, TRAIT_DEBTOR, TRAIT_GENERIC)
			ADD_TRAIT(debtor, L.get_faction_debtor_trait(), TRAIT_GENERIC)
			var/still_owed = L.get_remaining_due()
			send_ooc_note("<b>NERVELOCK:</b> Your loan of [L.principal]m has come due and you cannot pay. [seized]m was seized; [still_owed]m remains owed to [destination.name]. You are marked a defaulter until the debt is settled.", name = debtor.real_name)
			record_round_statistic(STATS_LOANS_DEFAULTED, 1)
			log_game("LOAN DEFAULT: [L.debtor_name] defaulted on [outstanding]m loan from [destination.name]. [seized]m seized, [still_owed]m remaining.")

/datum/controller/subsystem/treasury/proc/tick_indenture(datum/loan/L)
	if(GLOB.dayspassed < L.due_on_day)
		return
	var/datum/fund/source = L.source_fund
	var/datum/fund/target = L.target_fund
	if(!source || !target)
		loans -= L
		qdel(L)
		return
	var/outstanding = L.get_remaining_due()
	if(outstanding <= 0)
		loans -= L
		qdel(L)
		return
	if(target.balance >= outstanding)
		if(transfer(target, source, outstanding, L.defaulted ? "Indenture settlement (auto)" : "Indenture repayment (maturity)"))
			L.repaid_so_far += outstanding
			loans -= L
			qdel(L)
			return
	if(!L.defaulted)
		L.defaulted = TRUE
		var/seized = 0
		if(target.balance > 0)
			seized = target.balance
			if(transfer(target, source, seized, "Indenture default seizure"))
				L.repaid_so_far += seized
		var/still_owed = L.get_remaining_due()
		announce_indenture_default(L, seized, still_owed)
		record_round_statistic(STATS_LOANS_DEFAULTED, 1)
		log_admin("INDENTURE DEFAULT: [target.name] defaulted on [L.principal]m owed to [source.name]. [seized]m seized, [still_owed]m remaining.")
		message_admins("INDENTURE DEFAULT: [target.name] defaulted on [L.principal]m owed to [source.name]. [seized]m seized, [still_owed]m remaining.")

/datum/controller/subsystem/treasury/proc/announce_indenture_default(datum/loan/L, seized, still_owed)
	var/datum/fund/source = L.source_fund
	var/datum/fund/target = L.target_fund
	if(!source || !target)
		return
	var/target_label = indenture_faction_label(target)
	var/msg
	if(istype(source, /datum/fund/church))
		msg = "The Church has called its loan to [target_label] and finds the coffers wanting. Astrata's generosity has been squandered. [seized]m forfeit, [still_owed]m unsettled."
	else if(istype(source, /datum/fund/merchant))
		msg = "The Merchant Guild has called its loan to [target_label] and finds the coffers wanting. The Burghers are outraged. There is no wealth without trust, and no realm without wealth. [seized]m forfeit, [still_owed]m unsettled."
	else if(istype(source, /datum/fund/bathhouse))
		msg = "The Bathhouse has called its loan to [target_label] and finds the coffers wanting. Her generosity abused! Her love disgraced! To lend from the bathhouse is one shame, to not pay back, a greater one. [seized]m forfeit, [still_owed]m unsettled."
	else
		msg = "The Stewardry has called its loan to [target_label] and finds the coffers wanting. The Crown is owed its due, and shall make known its prerogative. [seized]m forfeit, [still_owed]m unsettled."
	priority_announce(msg, "Indenture Defaulted", pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), "Captain", strip_html = FALSE)
