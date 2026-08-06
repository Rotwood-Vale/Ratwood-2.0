// Taxation 2 poll-tax engine, ported from AP #6849 (source: AP treasury.dm poll-tax region).
// ES deviations, mirrored from the bridge architecture (_treasury_bridge.dm):
//  - Player accounts are integer balances keyed by mob in SStreasury.bank_accounts, not
//    /datum/fund. Collection therefore decrements the ledger and mints into the Crown's
//    Purse; subsidies burn from the Purse first, then credit the ledger.
//  - Charter exemptions, per-decree rate caps and the Zenitstadt Concordat floor are wired
//    to the item 6 decree system (code/modules/politics/).
//  - priority_announce here takes plain text (ES strips HTML), so announcement lines are
//    joined with newlines instead of <br>.
//  - Category mapping is rebuilt from Emerald Summit's job roster / GLOB position lists.

/datum/controller/subsystem/treasury
	/// Flat mammon per head per day, by poll category. Negative = Crown subsidy.
	var/list/poll_tax_rates = list(
		POLL_TAX_CAT_NOBLE = 0,
		POLL_TAX_CAT_CLERGY = 0,
		POLL_TAX_CAT_INQUISITION = 0,
		POLL_TAX_CAT_COURTIER = 0,
		POLL_TAX_CAT_GARRISON = 0,
		POLL_TAX_CAT_GUILDS = 0,
		POLL_TAX_CAT_MERCHANT = 0,
		POLL_TAX_CAT_BURGHER = 0,
		POLL_TAX_CAT_ADVENTURER = 0,
		POLL_TAX_CAT_MERCENARY = 0,
		POLL_TAX_CAT_PEASANT = 0,
	)
	/// mob -> prepaid poll-tax days remaining
	var/list/poll_tax_advance_days = list()
	/// mob -> mammons owed in arrears
	var/list/poll_tax_owed = list()
	/// mob -> consecutive days in arrears
	var/list/poll_tax_debt_days = list()
	/// Last GLOB.dayspassed the Crown levies (tax_rates) were adjusted
	var/levy_rates_changed_day = -1
	/// Last GLOB.dayspassed the poll rates were adjusted
	var/poll_rates_changed_day = -1
	/// Cached projection for steward/taxsetter displays
	var/list/cached_poll_projection
	var/poll_projection_dirty = TRUE
	/// length(bank_accounts) when the projection was last built - a change (latejoin/leave)
	/// forces a rebuild so headcount/income/subsidy don't go stale between rate changes.
	var/poll_projection_account_count = -1

/datum/controller/subsystem/treasury/proc/apply_rate_adjustments(list/adjustments, good_announcement_text, bad_announcement_text)
	if(GLOB.dayspassed <= levy_rates_changed_day)
		to_chat(usr, span_warning("Crown levies have already been adjusted today - come back tomorrow."))
		return
	if(!islist(adjustments))
		return
	var/datum/decree/concordat = get_decree(DECREE_ZENITSTADT_CONCORDAT)
	var/concordat_active = concordat?.active ? TRUE : FALSE
	var/list/lines = list()
	var/bad_guy = FALSE
	var/rejected_concordat = FALSE
	for(var/entry in adjustments)
		if(!islist(entry))
			continue
		var/category = entry["category"]
		if(!(category in tax_rates))
			continue
		if(category == TAX_CATEGORY_FINE)
			continue
		var/new_pct = CLAMP(entry["rate"], 0, 100)
		var/new_rate = new_pct / 100
		if(concordat_active && new_rate < CONCORDAT_TITHE_RATE)
			rejected_concordat = TRUE
			continue
		var/old_rate = tax_rates[category]
		if(new_rate == old_rate)
			continue
		var/old_pct = round(old_rate * 100)
		if(new_rate > old_rate)
			bad_guy = TRUE
		tax_rates[category] = new_rate
		var/pretty = get_tax_category_pretty_name(category)
		var/changeverb = new_rate > old_rate ? "raised" : "reduced"
		lines += "[pretty] [changeverb] from [old_pct]% to [new_pct]%."

	if(rejected_concordat)
		to_chat(usr, span_warning("The Concordat of Zenitstadt forbids any levy below [round(CONCORDAT_TITHE_RATE * 100)]% while in force - the Church's tithe must be honoured."))

	if(!length(lines))
		return

	levy_rates_changed_day = GLOB.dayspassed
	var/final_text = jointext(lines, "\n")
	if(concordat_active)
		final_text += "\nBy the Concordat of Zenitstadt, [round(CONCORDAT_TITHE_RATE * 100)]% of every taxed transaction is tithed to the Church of the Summit, drawn from the Crown's share."
	var/final_announcement_text = bad_guy ? bad_announcement_text : good_announcement_text
	priority_announce(final_text, final_announcement_text, pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'))
	log_game("TAX RATES: [usr ? key_name(usr) : "system"] changed levy rates - [jointext(lines, " | ")]")

/// Phrasing helper for poll-rate change announcements. Distinguishes positive tax adjustments
/// from crossing-the-zero (tax -> subsidy or vice versa) so the announcement reads correctly.
/datum/controller/subsystem/treasury/proc/describe_rate_change(old_rate, new_rate)
	if(old_rate == 0 && new_rate < 0)
		return "subsidy set at [-new_rate]m/day"
	if(old_rate < 0 && new_rate == 0)
		return "subsidy ended"
	if(old_rate < 0 && new_rate > 0)
		return "subsidy replaced by a [new_rate]m/day tax"
	if(old_rate > 0 && new_rate < 0)
		return "tax replaced by a [-new_rate]m/day subsidy"
	if(old_rate < 0 && new_rate < 0)
		var/subverb = (-new_rate) > (-old_rate) ? "increased" : "reduced"
		return "subsidy [subverb] from [-old_rate]m/day to [-new_rate]m/day"
	var/taxverb = new_rate > old_rate ? "raised" : "reduced"
	return "tax [taxverb] from [old_rate]m/day to [new_rate]m/day"

/datum/controller/subsystem/treasury/proc/apply_poll_rate_adjustments(list/adjustments, good_announcement_text, bad_announcement_text)
	if(GLOB.dayspassed <= poll_rates_changed_day)
		to_chat(usr, span_warning("Poll tax rates have already been adjusted today - come back tomorrow."))
		return
	if(!islist(adjustments))
		return
	var/list/lines = list()
	var/bad_guy = FALSE
	for(var/entry in adjustments)
		if(!islist(entry))
			continue
		var/category = entry["category"]
		if(!(category in poll_tax_rates))
			continue
		var/new_rate = CLAMP(entry["rate"], -POLL_TAX_MAX_SUBSIDY, POLL_TAX_MAX_RATE)
		var/old_rate = poll_tax_rates[category] || 0
		if(new_rate == old_rate)
			continue
		poll_tax_rates[category] = new_rate
		// "bad guy" = strictly making the burden heavier. Crossing into subsidy (negative)
		// or deepening one is generous; retreating from subsidy toward zero is neutral; any
		// move up into positive tax territory or pushing existing tax higher is the tyrannical
		// announcement.
		if(new_rate > old_rate && new_rate > 0)
			bad_guy = TRUE
		poll_projection_dirty = TRUE
		var/pretty = get_poll_tax_category_pretty_name(category)
		lines += "[pretty] poll [describe_rate_change(old_rate, new_rate)]."

	if(!length(lines))
		return
	poll_rates_changed_day = GLOB.dayspassed
	var/final_announcement_text = bad_guy ? bad_announcement_text : good_announcement_text
	priority_announce(jointext(lines, "\n"), final_announcement_text, pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'))
	log_game("POLL TAX RATES: [usr ? key_name(usr) : "system"] changed poll tax rates - [jointext(lines, " | ")]")

/datum/controller/subsystem/treasury/proc/get_tax_category_pretty_name(category)
	switch(category)
		if(TAX_CATEGORY_CONTRACT_LEVY)
			return "Contract Levy"
		if(TAX_CATEGORY_HEADEATER_LEVY)
			return "Headeater Levy"
		if(TAX_CATEGORY_IMPORT_TARIFF)
			return "Import Tariff"
		if(TAX_CATEGORY_EXPORT_DUTY)
			return "Export Duty"
		if(TAX_CATEGORY_FINE)
			return "Fine"
	return capitalize(category)

/// ES deviation: rebuilt from Emerald Summit's job roster. Priority order mirrors AP's
/// civic stack (noble > inquisition > clergy > courtier > garrison > guilds > merchant >
/// burgher > adventurer > mercenary > peasant). Unmatched jobs are untaxed (null).
/datum/controller/subsystem/treasury/proc/get_poll_tax_category(mob/living/H)
	if(!H)
		return null
	if(HAS_TRAIT(H, TRAIT_OUTLAW))
		return null
	if(HAS_TRAIT(H, TRAIT_NOBLE) || (H.job in GLOB.noble_positions))
		return POLL_TAX_CAT_NOBLE
	if(H.job in GLOB.inquisition_positions)
		return POLL_TAX_CAT_INQUISITION
	if((H.job in GLOB.church_positions) || HAS_TRAIT(H, TRAIT_AGENT_CHURCH))
		return POLL_TAX_CAT_CLERGY
	if(H.job in GLOB.courtier_positions)
		return POLL_TAX_CAT_COURTIER
	if(H.job in GLOB.garrison_positions)
		return POLL_TAX_CAT_GARRISON
	if(H.job in list("Guildmaster", "Guildsman", "Guild Clerk", "Tailor"))
		return POLL_TAX_CAT_GUILDS
	if(H.job == "Merchant")
		return POLL_TAX_CAT_MERCHANT
	// Shopkeeps, hosts and lettered professionals of the town.
	if((H.job in list("Innkeeper", "Bathmaster", "Nightmaster", "Apothecary", "Archivist", "Scribe", "Loudmouth", "Town Elder", "Nightswain")) || HAS_TRAIT(H, TRAIT_RESIDENT))
		return POLL_TAX_CAT_BURGHER
	if(H.job in list("Adventurer", "Court Agent", "Pilgrim"))
		return POLL_TAX_CAT_ADVENTURER
	if(H.job in GLOB.mercenary_positions)
		return POLL_TAX_CAT_MERCENARY
	if((H.job in GLOB.peasant_positions) || H.job == "Shophand")
		return POLL_TAX_CAT_PEASANT
	return null

/// Charter exemptions (item 6 decrees): Great Writ frees nobles, Zenitstadt Concordat frees
/// clergy, Otavan Accords free the Inquisition - while the respective charter stands.
/datum/controller/subsystem/treasury/proc/is_poll_tax_charter_exempt(mob/living/H, category)
	switch(category)
		if(POLL_TAX_CAT_NOBLE)
			var/datum/decree/GW = get_decree(DECREE_GREAT_WRIT)
			return GW?.active
		if(POLL_TAX_CAT_CLERGY)
			var/datum/decree/ZC = get_decree(DECREE_ZENITSTADT_CONCORDAT)
			return ZC?.active
		if(POLL_TAX_CAT_INQUISITION)
			var/datum/decree/OA = get_decree(DECREE_OTAVAN_ACCORDS)
			return OA?.active
	return FALSE

/datum/controller/subsystem/treasury/proc/get_poll_tax_category_pretty_name(category)
	switch(category)
		if(POLL_TAX_CAT_NOBLE)
			return "Noble"
		if(POLL_TAX_CAT_CLERGY)
			return "Clergy"
		if(POLL_TAX_CAT_INQUISITION)
			return "Inquisition"
		if(POLL_TAX_CAT_COURTIER)
			return "Courtier"
		if(POLL_TAX_CAT_GARRISON)
			return "Garrison"
		if(POLL_TAX_CAT_GUILDS)
			return "Guilds"
		if(POLL_TAX_CAT_MERCHANT)
			return "Merchant"
		if(POLL_TAX_CAT_BURGHER)
			return "Burgher"
		if(POLL_TAX_CAT_ADVENTURER)
			return "Adventurer"
		if(POLL_TAX_CAT_MERCENARY)
			return "Mercenary"
		if(POLL_TAX_CAT_PEASANT)
			return "Peasant"
	return capitalize(category)

/datum/controller/subsystem/treasury/proc/record_poll_tax_by_category(category, amount)
	// Negative amounts are valid: poll-tax subsidies (negative rates) flow Crown -> subject and
	// must subtract from the running totals so the chronicle reflects net Crown intake per class.
	if(!category || amount == 0)
		return
	record_round_statistic(STATS_POLL_TAX_COLLECTED, amount)
	switch(category)
		if(POLL_TAX_CAT_NOBLE)
			record_round_statistic(STATS_POLL_TAX_NOBLE, amount)
		if(POLL_TAX_CAT_CLERGY)
			record_round_statistic(STATS_POLL_TAX_CLERGY, amount)
		if(POLL_TAX_CAT_INQUISITION)
			record_round_statistic(STATS_POLL_TAX_INQUISITION, amount)
		if(POLL_TAX_CAT_COURTIER)
			record_round_statistic(STATS_POLL_TAX_COURTIER, amount)
		if(POLL_TAX_CAT_GARRISON)
			record_round_statistic(STATS_POLL_TAX_GARRISON, amount)
		if(POLL_TAX_CAT_GUILDS)
			record_round_statistic(STATS_POLL_TAX_GUILDS, amount)
		if(POLL_TAX_CAT_MERCHANT)
			record_round_statistic(STATS_POLL_TAX_MERCHANT, amount)
		if(POLL_TAX_CAT_BURGHER)
			record_round_statistic(STATS_POLL_TAX_BURGHER, amount)
		if(POLL_TAX_CAT_ADVENTURER)
			record_round_statistic(STATS_POLL_TAX_ADVENTURER, amount)
		if(POLL_TAX_CAT_MERCENARY)
			record_round_statistic(STATS_POLL_TAX_MERCENARY, amount)
		if(POLL_TAX_CAT_PEASANT)
			record_round_statistic(STATS_POLL_TAX_PEASANT, amount)

/datum/controller/subsystem/treasury/proc/get_poll_tax_rate_for(mob/living/H, category)
	if(!category)
		return 0
	var/rate = poll_tax_rates[category] || 0
	// Charter exemption zeroes out TAX only. Subsidies (negative rates) reach protected
	// classes too - the Crown does not impose on them, but may still extend generosity.
	if(H && rate > 0 && is_poll_tax_charter_exempt(H, category))
		return 0
	// Let every active decree narrow the rate. Each decree decides whether THIS payer/category
	// combination is relevant - the base proc just returns current_rate unchanged. Existing
	// caps use min(current_rate, CAP) with positive CAPs, so negative rates pass through.
	for(var/id in decrees)
		var/datum/decree/D = decrees[id]
		if(!D?.active)
			continue
		rate = D.apply_poll_tax_cap(H, category, rate)
	return rate

/// Per-category headcount + per-tick poll mammon flow, cached on the subsystem. Rebuilds
/// only when poll_projection_dirty is set (rate change, account add/remove). Gross projection
/// only - skips balance/advance/debt inspection so it stays fast on large rosters.
/datum/controller/subsystem/treasury/proc/get_poll_tax_projection()
	// Cheap staleness guard: an account added/removed since the last build (latejoin, leave,
	// death cleanup) changes the roster without touching rates, so force a rebuild.
	if(length(bank_accounts) != poll_projection_account_count)
		poll_projection_dirty = TRUE
	if(cached_poll_projection && !poll_projection_dirty)
		return cached_poll_projection
	var/list/headcounts = list()
	var/total_head = 0
	for(var/key in bank_accounts)
		var/mob/living/owner = key
		if(!istype(owner))
			continue
		var/category = get_poll_tax_category(owner)
		if(!category)
			continue
		headcounts[category] = (headcounts[category] || 0) + 1
		if(!is_poll_tax_charter_exempt(owner, category))
			var/tkey = "[category]|taxable"
			headcounts[tkey] = (headcounts[tkey] || 0) + 1
		total_head++

	var/income = 0
	var/subsidy = 0
	var/list/by_category = list()
	for(var/category in poll_tax_rates)
		var/rate = poll_tax_rates[category] || 0
		var/total = headcounts[category] || 0
		var/taxable = headcounts["[category]|taxable"] || 0
		var/per_tick_flow = 0
		if(rate > 0)
			per_tick_flow = rate * taxable
			income += per_tick_flow
		else if(rate < 0)
			// Subsidies reach every eligible subject, including charter-protected ones.
			per_tick_flow = rate * total   // negative total = subsidy out of Purse
			subsidy += -per_tick_flow
		by_category += list(list(
			"category" = category,
			"rate" = rate,
			"heads" = total,
			"taxable" = taxable,
			"per_tick" = per_tick_flow,
		))

	cached_poll_projection = list(
		"income" = income,
		"subsidy" = subsidy,
		"net" = income - subsidy,
		"headcount" = total_head,
		"by_category" = by_category,
	)
	poll_projection_dirty = FALSE
	poll_projection_account_count = length(bank_accounts)
	return cached_poll_projection

/datum/controller/subsystem/treasury/proc/poll_tax_pay_advance(mob/living/H, days)
	if(!H || days <= 0)
		return FALSE
	if(SSticker?.round_start_time && (world.time - SSticker.round_start_time) < POLL_TAX_ADVANCE_LOCKOUT)
		to_chat(H, span_warning("The Crown's ledgers have not yet opened for the day. Try again later."))
		return FALSE
	if(!has_account(H))
		return FALSE
	var/category = get_poll_tax_category(H)
	if(!category)
		to_chat(H, span_warning("The Crown does not tax your class."))
		return FALSE
	if(is_poll_tax_charter_exempt(H, category))
		to_chat(H, span_warning("Your class is exempt from poll tax by decree."))
		return FALSE
	var/rate = get_poll_tax_rate_for(H, category)
	if(rate < 0)
		to_chat(H, span_warning("Your class currently receives a Crown subsidy - there is nothing to advance."))
		return FALSE
	if(rate == 0)
		rate = POLL_TAX_ADVANCE_FALLBACK_RATE
	var/existing_advance = poll_tax_advance_days[H] || 0
	var/room = POLL_TAX_MAX_ADVANCE_DAYS - existing_advance
	if(room <= 0)
		to_chat(H, span_warning("You already hold the maximum of [POLL_TAX_MAX_ADVANCE_DAYS] days of Poll Tax advance."))
		return FALSE
	if(days > room)
		days = room
	var/total_cost = rate * days
	if(get_balance(H) < total_cost)
		to_chat(H, span_warning("Insufficient balance. Need [total_cost]m for [days] days."))
		return FALSE
	// ES deviation: integer ledger debit + mint into the Crown's Purse (AP: fund transfer).
	bank_accounts[H] -= total_cost
	mint(discretionary_fund, total_cost, "Poll Tax advance ([days] days)")
	record_poll_tax_by_category(category, total_cost)
	poll_tax_advance_days[H] = existing_advance + days
	to_chat(H, span_notice("You have advanced [days] day[days == 1 ? "" : "s"] of Poll Tax ([total_cost]m total). Advance held: [poll_tax_advance_days[H]] day[poll_tax_advance_days[H] == 1 ? "" : "s"]."))
	log_game("POLL TAX ADVANCE: [key_name(H)] prepaid [days] days ([total_cost]m) of poll tax as [category]")
	return TRUE

/// Clears arrears but preserves advance days - already-advanced mammon stays credited on rehab.
/datum/controller/subsystem/treasury/proc/clear_poll_tax_debt(mob/living/H)
	if(!H)
		return
	poll_tax_owed -= H
	poll_tax_debt_days -= H
	if(HAS_TRAIT(H, TRAIT_ARREARS))
		REMOVE_TRAIT(H, TRAIT_ARREARS, TRAIT_GENERIC)

/datum/controller/subsystem/treasury/proc/tick_poll_tax()
	for(var/key in bank_accounts)
		var/mob/living/owner = key
		if(!istype(owner))
			continue
		var/category = get_poll_tax_category(owner)
		if(!category)
			continue

		var/raw_rate = poll_tax_rates[category] || 0
		var/rate = get_poll_tax_rate_for(owner, category)

		// Exempted / capped tax recording - only meaningful for the tax (positive) side.
		if(raw_rate > 0 && rate < raw_rate)
			record_round_statistic(STATS_EXEMPTED_POLL_TAX, raw_rate - rate)

		if(rate == 0)
			continue

		if(rate < 0)
			// Subsidy branch: Crown pays the subject. No advance/debt machinery applies -
			// subsidies can't be prepaid and can't accumulate as arrears. If the Crown is
			// insolvent for this head's subsidy, silently skip this tick.
			var/subsidy = -rate
			if(discretionary_fund.balance < subsidy)
				continue
			if(!burn(discretionary_fund, subsidy, "Poll Subsidy ([category])"))
				continue
			bank_accounts[owner] += subsidy
			// Record as a negative against the category - the breakdown shows net Crown intake.
			record_poll_tax_by_category(category, -subsidy)
			to_chat(owner, span_notice("<b>POLL SUBSIDY:</b> [subsidy]m granted by the Crown."))
			continue

		var/advance = poll_tax_advance_days[owner] || 0
		if(advance > 0)
			advance--
			if(advance <= 0)
				poll_tax_advance_days -= owner
			else
				poll_tax_advance_days[owner] = advance
			to_chat(owner, span_notice("<b>POLL TAX:</b> Covered by advance. [advance] day[advance == 1 ? "" : "s"] remaining."))
			continue

		var/owed_this_tick = rate + (poll_tax_owed[owner] || 0)
		var/balance = get_balance(owner)

		var/paid = 0
		if(balance >= owed_this_tick)
			bank_accounts[owner] -= owed_this_tick
			mint(discretionary_fund, owed_this_tick, "Poll Tax ([category])")
			paid = owed_this_tick
			owed_this_tick = 0
		else if(balance > 0)
			bank_accounts[owner] -= balance
			mint(discretionary_fund, balance, "Poll Tax ([category])")
			paid = balance
			owed_this_tick -= balance

		if(paid > 0)
			record_poll_tax_by_category(category, paid)
			to_chat(owner, span_notice("<b>POLL TAX:</b> [paid]m collected."))

		if(owed_this_tick > 0)
			poll_tax_owed[owner] = owed_this_tick
			poll_tax_debt_days[owner] = (poll_tax_debt_days[owner] || 0) + 1
			to_chat(owner, span_danger("<b>POLL TAX:</b> You owe the Crown [owed_this_tick]m. [poll_tax_debt_days[owner]] day\s overdue."))
			if(poll_tax_debt_days[owner] >= POLL_TAX_DEBT_DAYS_TO_DEBTOR && !HAS_TRAIT(owner, TRAIT_ARREARS))
				ADD_TRAIT(owner, TRAIT_ARREARS, TRAIT_GENERIC)
		else
			clear_poll_tax_debt(owner)
