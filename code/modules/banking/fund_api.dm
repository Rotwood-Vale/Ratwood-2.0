// Fund API — mint/burn/transfer and related helpers.
// ES adaptation: no decree/concordat/bathhouse-ordinance system; tax exemption always FALSE.
// "Azurian Trading Company" references renamed to "Emerald Trading Company".

/datum/controller/subsystem/treasury/proc/log_fund_entry(datum/treasury_entry/entry)
	ledger += entry

/datum/controller/subsystem/treasury/proc/get_account_log(account_name, max_entries = 100)
	if(!account_name)
		return list()
	var/list/out = list()
	var/total = length(ledger)
	for(var/i = total to 1 step -1)
		if(length(out) >= max_entries)
			break
		var/datum/treasury_entry/E = ledger[i]
		if(E.from_name == account_name || E.to_name == account_name)
			out += E
	return out

/datum/controller/subsystem/treasury/proc/get_outstanding_principal_from_fund(datum/fund/F)
	if(!F)
		return 0
	. = 0
	for(var/datum/loan/L in loans)
		if(L.source_fund != F)
			continue
		. += max(0, L.principal - L.repaid_so_far)

/datum/controller/subsystem/treasury/proc/resolve_fund_by_id(fund_id)
	switch(fund_id)
		if("crown")
			return discretionary_fund
		if("church")
			return church_fund
		if("merchant")
			return merchant_fund
		if("bathhouse")
			return bathhouse_fund
		if("innkeeper")
			return innkeeper_fund
	return null

/datum/controller/subsystem/treasury/proc/get_fund_id(datum/fund/F)
	if(F == discretionary_fund)
		return "crown"
	if(F == church_fund)
		return "church"
	if(F == merchant_fund)
		return "merchant"
	if(F == bathhouse_fund)
		return "bathhouse"
	if(F == innkeeper_fund)
		return "innkeeper"
	return ""

/datum/controller/subsystem/treasury/proc/find_jawbank_for_fund_id(fund_id)
	var/obj/structure/roguemachine/vaultbank/V = jawbanks_by_fund_id[fund_id]
	if(QDELETED(V))
		jawbanks_by_fund_id -= fund_id
		return null
	return V

/datum/controller/subsystem/treasury/proc/announce_indenture_acceptance(datum/loan/L, mob/living/carbon/human/accepter)
	var/datum/fund/source = L.source_fund
	var/datum/fund/target = L.target_fund
	if(!source || !target)
		return
	var/pct = round(L.interest_rate * 100)
	var/source_label = indenture_faction_label(source)
	var/target_label = indenture_faction_label(target)
	var/grace = indenture_grace_phrase(source)
	var/job_label = accepter?.job ? "[accepter.real_name], the [accepter.job]" : (accepter?.real_name || "an unnamed signatory")
	var/msg = "[grace], [source_label] has extended a most generous loan of [L.principal]m at [pct]% per dae over [L.days_total] dae, accepted by [job_label] on behalf of [target_label]."
	priority_announce(msg, "Writ of Indenture", pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), "Captain", strip_html = FALSE)

/datum/controller/subsystem/treasury/proc/indenture_grace_phrase(datum/fund/F)
	if(istype(F, /datum/fund/church))
		return "By grace of Astrata"
	if(istype(F, /datum/fund/merchant))
		return "By grace of Malum"
	if(istype(F, /datum/fund/bathhouse))
		return "By grace of Eora"
	return "By grace of the Crown"

/datum/controller/subsystem/treasury/proc/skim_for_banditry_debt(datum/fund/to_fund, amount)
	if(amount <= 0 || banditry_debt <= 0 || to_fund != discretionary_fund)
		return amount
	var/skim = min(amount, banditry_debt)
	banditry_debt -= skim
	force_set_round_statistic(STATS_BANDITRY_DEBT_OUTSTANDING, banditry_debt)
	log_fund_entry(new /datum/treasury_entry("burn", to_fund, null, skim, "Banditry debt repayment"))
	return amount - skim

/datum/controller/subsystem/treasury/proc/skim_for_treasury_debt(datum/fund/to_fund, amount)
	if(amount <= 0 || treasury_debt <= 0 || to_fund != discretionary_fund)
		return amount
	var/floor_value = (treasury_state == TREASURY_BANKRUPTCY) ? BANKRUPTCY_OPERATING_FLOOR : 0
	var/headroom_below_floor = max(0, floor_value - to_fund.balance)
	var/amount_above_floor = max(0, amount - headroom_below_floor)
	if(amount_above_floor <= 0)
		return amount
	var/skim = min(amount_above_floor, treasury_debt)
	treasury_debt -= skim
	force_set_round_statistic(STATS_TREASURY_DEBT_OUTSTANDING, treasury_debt)
	record_round_statistic(STATS_TREASURY_DEBT_REPAID, skim)
	var/reason
	if(treasury_state == TREASURY_BANKRUPTCY)
		reason = "Sequestration debt - Emerald Trading Company"
	else if(treasury_state == TREASURY_IN_ARREARS)
		reason = "Arrears repayment - Burghers of Rotwood Vale"
	else
		reason = "ETC loan repayment"
	log_fund_entry(new /datum/treasury_entry("burn", to_fund, null, skim, reason))
	if(treasury_debt <= 0)
		treasury_debt = 0
		clear_treasury_debt_state()
	return amount - skim

/datum/controller/subsystem/treasury/proc/mint(datum/fund/to_fund, amount, reason, from_label)
	if(!to_fund || amount <= 0)
		return FALSE
	var/credited = skim_for_banditry_debt(to_fund, amount)
	credited = skim_for_treasury_debt(to_fund, credited)
	if(credited > 0)
		to_fund.balance += credited
		log_fund_entry(new /datum/treasury_entry("mint", null, to_fund, credited, reason, from_label))
	// ES compat: keep legacy treasury_value mirroring the Crown's Purse.
	if(to_fund == discretionary_fund)
		treasury_value = discretionary_fund.balance
	return TRUE

/datum/controller/subsystem/treasury/proc/mint_fractional(datum/fund/to_fund, amount, reason, datum/fund/source_fund)
	if(!to_fund || amount <= 0)
		return 0
	to_fund.pending_micro += list(list(
		"amount" = amount,
		"source" = source_fund ? WEAKREF(source_fund) : null,
		"reason" = reason,
	))
	var/total = 0
	for(var/list/entry as anything in to_fund.pending_micro)
		total += entry["amount"]
	if(total < 1)
		return 0
	var/whole = round(total)
	var/remainder = total - whole
	var/contributors = length(to_fund.pending_micro)
	for(var/list/entry as anything in to_fund.pending_micro)
		var/datum/weakref/source_ref = entry["source"]
		var/datum/fund/source = source_ref?.resolve()
		log_fund_entry(new /datum/treasury_entry("micro", source, to_fund, entry["amount"], entry["reason"]))
	to_fund.pending_micro = list()
	if(remainder > 0)
		to_fund.pending_micro += list(list("amount" = remainder, "source" = null, "reason" = "carryover"))
	mint(to_fund, whole, "Fractional remit ([whole]m from [contributors] pending entries)")
	return whole

/datum/controller/subsystem/treasury/proc/burn(datum/fund/from_fund, amount, reason)
	if(!from_fund || amount <= 0)
		return FALSE
	if(from_fund.balance < amount)
		return FALSE
	from_fund.balance -= amount
	log_fund_entry(new /datum/treasury_entry("burn", from_fund, null, amount, reason))
	if(from_fund == discretionary_fund)
		treasury_value = discretionary_fund.balance
	return TRUE

/datum/controller/subsystem/treasury/proc/transfer(datum/fund/from_fund, datum/fund/to_fund, amount, reason)
	if(!from_fund || !to_fund || amount <= 0)
		return FALSE
	if(from_fund.currency != to_fund.currency)
		stack_trace("treasury transfer between funds of differing currency: [from_fund.currency] -> [to_fund.currency]")
		return FALSE
	if(from_fund.balance < amount)
		return FALSE
	from_fund.balance -= amount
	var/credited = skim_for_banditry_debt(to_fund, amount)
	credited = skim_for_treasury_debt(to_fund, credited)
	to_fund.balance += credited
	log_fund_entry(new /datum/treasury_entry("transfer", from_fund, to_fund, amount, reason))
	if(from_fund == discretionary_fund || to_fund == discretionary_fund)
		treasury_value = discretionary_fund.balance
	return TRUE

/datum/controller/subsystem/treasury/proc/get_tax_rate(tax_category)
	return tax_rates[tax_category] || 0

/datum/controller/subsystem/treasury/proc/set_tax_rate(tax_category, rate)
	if(tax_category == TAX_CATEGORY_FINE)
		return
	tax_rates[tax_category] = CLAMP(rate, 0, 1.0)

/// Charter exemptions (item 6 decrees). Outlaws forfeit every charter protection.
/datum/controller/subsystem/treasury/proc/is_tax_exempt(mob/living/payer, tax_category)
	if(!payer)
		return FALSE
	if(HAS_TRAIT(payer, TRAIT_OUTLAW))
		return FALSE
	for(var/id in decrees)
		var/datum/decree/D = decrees[id]
		if(D.apply_exemption(payer, tax_category))
			return TRUE
	return FALSE

/// Highest fraction of a payer's balance a single tax/fine stroke may take. Outlaws are
/// uncapped; charters (Golden Bull) may narrow the generic cap.
/datum/controller/subsystem/treasury/proc/get_rate_cap(mob/living/payer, tax_category)
	var/cap = GENERIC_RATE_CAP
	if(!payer)
		return cap
	if(HAS_TRAIT(payer, TRAIT_OUTLAW))
		return 1.0
	for(var/id in decrees)
		var/datum/decree/D = decrees[id]
		cap = D.apply_rate_cap(payer, tax_category, cap)
	return cap

/// Ceiling on a single Crown fine against this subject right now: charter-exempt subjects
/// return 0, otherwise balance x rate-cap. Daily-fine tracking is applied separately in
/// give_money_account. Used by the Nerve Master to bound the fine prompt.
/datum/controller/subsystem/treasury/proc/get_max_fine_for(mob/living/target)
	if(!target)
		return 0
	if(is_tax_exempt(target, TAX_CATEGORY_FINE))
		return 0
	var/balance = get_balance(target)
	if(balance <= 0)
		return 0
	var/cap_rate = get_rate_cap(target, TAX_CATEGORY_FINE)
	return FLOOR(min(balance * cap_rate, get_daily_fine_remaining(target)), 1)

/datum/controller/subsystem/treasury/proc/apply_tax(datum/fund/payer, base_amount, tax_category, reason)
	if(!payer || base_amount <= 0)
		return 0
	var/mob/living/owner = payer.get_owner()
	var/base_rate = get_tax_rate(tax_category)
	if(owner && is_tax_exempt(owner, tax_category))
		record_tax_exemption(tax_category, FLOOR(base_amount * base_rate, 1))
		return 0
	var/rate = base_rate
	if(owner)
		rate = min(rate, get_rate_cap(owner, tax_category))
	if(rate <= 0)
		return 0
	if(rate < base_rate)
		record_tax_exemption(tax_category, FLOOR(base_amount * (base_rate - rate), 1))
	payer.tax_debt += base_amount * rate
	var/due = FLOOR(payer.tax_debt, 1)
	if(due <= 0)
		return 0
	if(!transfer(payer, discretionary_fund, due, "[tax_category] ([reason])"))
		return 0
	payer.tax_debt -= due
	apply_concordat_tithe(base_amount, tax_category, reason)
	switch(tax_category)
		if(TAX_CATEGORY_CONTRACT_LEVY)
			record_round_statistic(STATS_REVENUE_CONTRACT_LEVY, due)
		if(TAX_CATEGORY_HEADEATER_LEVY)
			record_round_statistic(STATS_REVENUE_HEADEATER_LEVY, due)
		if(TAX_CATEGORY_IMPORT_TARIFF)
			record_round_statistic(STATS_REVENUE_IMPORT_TARIFF, due)
		if(TAX_CATEGORY_EXPORT_DUTY)
			record_round_statistic(STATS_REVENUE_EXPORT_DUTY, due)
	return due

/// Zenitstadt Concordat (item 6 decrees): while the charter stands, a fixed fraction of every
/// taxed transaction is tithed from the Crown's Purse to the Church Fund. Fines are the
/// Crown's justice, not commerce - never tithed.
/datum/controller/subsystem/treasury/proc/apply_concordat_tithe(base_amount, tax_category, reason)
	if(base_amount <= 0)
		return
	if(tax_category == TAX_CATEGORY_FINE)
		return
	var/datum/decree/concordat = get_decree(DECREE_ZENITSTADT_CONCORDAT)
	if(!concordat?.active)
		return
	if(!church_fund || !discretionary_fund)
		return
	concordat_tithe_debt += base_amount * CONCORDAT_TITHE_RATE
	var/skim = FLOOR(concordat_tithe_debt, 1)
	if(skim <= 0)
		return
	if(transfer(discretionary_fund, church_fund, skim, "Concordat tithe ([tax_category])"))
		concordat_tithe_debt -= skim

/// Books the mammon a charter shielded from the Crown, by category, for the Chronicle.
/datum/controller/subsystem/treasury/proc/record_tax_exemption(tax_category, amount)
	if(amount <= 0)
		return
	switch(tax_category)
		if(TAX_CATEGORY_CONTRACT_LEVY)
			record_round_statistic(STATS_EXEMPTED_CONTRACT_LEVY, amount)
		if(TAX_CATEGORY_HEADEATER_LEVY)
			record_round_statistic(STATS_EXEMPTED_HEADEATER_LEVY, amount)
		if(TAX_CATEGORY_IMPORT_TARIFF)
			record_round_statistic(STATS_EXEMPTED_IMPORT_TARIFF, amount)
		if(TAX_CATEGORY_EXPORT_DUTY)
			record_round_statistic(STATS_EXEMPTED_EXPORT_DUTY, amount)
		if(TAX_CATEGORY_FINE)
			record_round_statistic(STATS_EXEMPTED_FINE, amount)

/datum/controller/subsystem/treasury/proc/compute_bathhouse_tithe(base_amount, rate)
	return 0

/datum/controller/subsystem/treasury/proc/indenture_faction_label(datum/fund/F)
	if(istype(F, /datum/fund/church))
		return "the Church"
	if(istype(F, /datum/fund/merchant))
		return "the Merchant Guild"
	if(istype(F, /datum/fund/bathhouse))
		return "the Bathhouse"
	if(istype(F, /datum/fund/innkeeper))
		return "the Tavern"
	return "the Stewardry"

/datum/controller/subsystem/treasury/proc/tick_rural_tax()
	if(!discretionary_fund)
		return
	mint(discretionary_fund, RURAL_TAX, "Rural Tax Collection")
	record_round_statistic(STATS_RURAL_TAXES_COLLECTED, RURAL_TAX)
	total_rural_tax += RURAL_TAX

/// Daily Burgher Pledge generation (item 6 decrees): the burghers' compact under the Golden
/// Bull. No Bull, no pledge - revoking the charter absolves the burghers of their tribute.
/datum/controller/subsystem/treasury/proc/tick_burgher_pledge()
	if(!burgher_pledge_fund)
		return
	var/datum/decree/golden = get_decree(DECREE_GOLDEN_BULL)
	if(!golden?.active)
		return
	var/refill = BURGHER_PLEDGE_BASE_REFILL + (get_active_player_count() * BURGHER_PLEDGE_PER_PLAYER)
	// The Guild of Arms' reciprocal contribution, when their charter is active. Minted as a
	// separate ledger entry so the tribute is visible in the treasury log distinct from the
	// burghers' own pledge.
	var/datum/decree/arms_charter = get_decree(DECREE_GUILD_CHARTER_OF_ARMS)
	var/guild_bonus = (arms_charter?.active) ? GUILD_CHARTER_OF_ARMS_PLEDGE_BONUS : 0
	var/ceiling = (refill + guild_bonus) * BURGHER_PLEDGE_CLAWBACK_MULTIPLIER
	if(burgher_pledge_fund.balance > ceiling)
		var/surplus = burgher_pledge_fund.balance - ceiling
		burn(burgher_pledge_fund, surplus, "Burgher Pledge clawback")
	mint(burgher_pledge_fund, refill, "Burgher Pledge replenishment")
	if(guild_bonus > 0)
		mint(burgher_pledge_fund, guild_bonus, "Guild of Arms tribute (Charter of Arms)")
	record_round_statistic(STATS_PLEDGE_GENERATED, refill + guild_bonus)
