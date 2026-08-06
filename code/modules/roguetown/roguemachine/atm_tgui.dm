// MeisterPanel TGUI backend - ported from Azure-Peak PR #7000 (economy port Step 16,
// AP source: code/modules/roguetown/roguemachine/atm_tgui.dm).
// ES deviations:
//  - Poll tax runtime (get_poll_tax_category / poll_tax_advance_days / poll_tax_pay_advance)
//    is not ported to ES (only the POLL_TAX_* defines landed). The Poll Tax tab is fed inert
//    data - it renders "No taxable class" and hides the advance controls. TODO(ES): wire the
//    real values when/if the poll tax system is ported.
//  - Bathhouse Ordinance is out of the port's scope ("Church/Bathhouse ordinance only" is
//    scoped out). The ordinance section is hidden via bathhouse_ordinance_available = FALSE
//    and the toggle action is not ported. TODO(ES): restore if the ordinance system lands.
//  - Personal ledger: ES player accounts are integer balances, not named /datum/fund accounts,
//    so treasury_entry rows are never recorded under a player's real_name. The personal Tally
//    will stay empty until ES logs player-named entries. TODO(ES).

/obj/structure/roguemachine/atm/proc/build_log_entries(account_name)
	var/list/out = list()
	for(var/datum/treasury_entry/E as anything in SStreasury.get_account_log(account_name))
		var/direction = "neutral"
		var/counterparty = ""
		if(E.kind == "transfer")
			if(E.from_name == account_name)
				direction = "out"
				counterparty = E.to_name
			else
				direction = "in"
				counterparty = E.from_name
		else if(E.kind == "mint" && E.to_name == account_name)
			direction = "in"
		else if(E.kind == "burn" && E.from_name == account_name)
			direction = "out"
		out += list(list(
			"kind" = E.kind,
			"direction" = direction,
			"counterparty" = counterparty,
			"amount" = E.amount,
			"reason" = E.reason || "",
		))
	return out

/obj/structure/roguemachine/atm/proc/open_meister_tgui(mob/user)
	var/datum/tgui/ui = SStgui.try_update_ui(user, src, null)
	if(!ui)
		ui = new(user, src, "MeisterPanel")
		ui.open()

/obj/structure/roguemachine/atm/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/atm/ui_status(mob/user, datum/ui_state/state)
	if(!isliving(user) || user.stat == DEAD)
		return UI_CLOSE
	return ..()

/obj/structure/roguemachine/atm/ui_interact(mob/user, datum/tgui/ui)
	SStgui.try_update_ui(user, src, ui)

/obj/structure/roguemachine/atm/ui_static_data(mob/user)
	var/list/data = list()
	data["max_issuance_day"] = SStreasury.loan_max_issuance_day
	data["poll_tax_static"] = list(
		"max_advance_days" = POLL_TAX_MAX_ADVANCE_DAYS,
		"fallback_rate" = POLL_TAX_ADVANCE_FALLBACK_RATE,
	)
	// Taxation 2 (ported): the user's poll class is fixed for the round, so it's static data.
	var/poll_category = SStreasury.get_poll_tax_category(user)
	data["poll_tax_user"] = list(
		"category" = poll_category || "",
		"category_label" = poll_category ? SStreasury.get_poll_tax_category_pretty_name(poll_category) : "",
	)
	var/list/funds = list()
	var/list/patron_rosters_static = list()
	for(var/fid in ALL_FUND_IDS)
		var/obj/structure/roguemachine/vaultbank/V = SStreasury.find_jawbank_for_fund_id(fid)
		var/datum/fund/F = SStreasury.resolve_fund_by_id(fid)
		if(!F)
			continue
		funds += list(list(
			"id" = fid,
			"label" = SStreasury.indenture_faction_label(F),
			"name" = F.name,
			"can_issue" = (V && V.can_issue_loan(user)) ? TRUE : FALSE,
			"can_withdraw" = (V && V.can_withdraw(user)) ? TRUE : FALSE,
			"can_view" = (V && V.can_view(user)) ? TRUE : FALSE,
			"supports_loans" = V ? (V.supports_loans ? TRUE : FALSE) : TRUE,
			"allow_zero_rate" = (V && (0 in V.allowed_rates())) ? TRUE : FALSE,
			"authority_label" = V ? V.get_authority_label() : "",
			"withdraw_rule" = V ? V.get_withdraw_rule_text() : "",
			"has_patronage" = (V && !isnull(V.get_patronage_writ_path())) ? TRUE : FALSE,
			"patron_label" = V ? V.get_patron_label() : "",
			"patron_cap" = V ? V.get_patron_cap() : 0,
		))
		if(V && !isnull(V.get_patronage_writ_path()))
			patron_rosters_static[fid] = list(
				"label" = V.get_patron_label(),
				"cap" = V.get_patron_cap(),
				"can_manage" = V.can_issue_loan(user) ? TRUE : FALSE,
				"explanation" = V.get_patron_explanation(),
			)
	data["funds"] = funds
	data["patron_rosters_static"] = patron_rosters_static
	return data

/obj/structure/roguemachine/atm/ui_data(mob/user)
	var/mob/living/carbon/human/H = user
	var/list/data = list()
	data["account_balance"] = SStreasury.get_balance(H)
	data["day"] = GLOB.dayspassed

	var/datum/loan/active = SStreasury.get_loan_for(H)
	if(active)
		data["active_loan"] = list(
			"principal" = active.principal,
			"interest_pct" = round(active.interest_rate * 100),
			"days_total" = active.days_total,
			"due_on_day" = active.due_on_day,
			"days_until_due" = active.days_until_due(),
			"minutes_until_due" = active.minutes_until_due(),
			"remaining" = active.get_remaining_due(),
			"defaulted" = active.defaulted ? TRUE : FALSE,
			"creditor" = active.source_fund ? SStreasury.indenture_faction_label(active.source_fund) : "the Crown",
		)
	else
		data["active_loan"] = null

	// Taxation 2 (ported): live poll data for the Poll Tax tab.
	var/poll_category = SStreasury.get_poll_tax_category(H)
	data["poll_tax"] = list(
		"rate" = poll_category ? SStreasury.get_poll_tax_rate_for(H, poll_category) : 0,
		"exempt" = (poll_category && SStreasury.is_poll_tax_charter_exempt(H, poll_category)) ? TRUE : FALSE,
		"advance_days_held" = SStreasury.poll_tax_advance_days[H] || 0,
		"owed" = SStreasury.poll_tax_owed[H] || 0,
		"overdue_days" = SStreasury.poll_tax_debt_days[H] || 0,
	)

	var/has_any_institutional_access = FALSE
	var/has_any_patronage_authority = FALSE
	for(var/fid in ALL_FUND_IDS)
		var/obj/structure/roguemachine/vaultbank/V = SStreasury.find_jawbank_for_fund_id(fid)
		if(!V)
			continue
		if(V.can_view(user))
			has_any_institutional_access = TRUE
		if(V.can_issue_loan(user) && !isnull(V.get_patronage_writ_path()))
			has_any_patronage_authority = TRUE

	var/list/fund_balances = list()
	var/list/institutional_loans = list()
	var/list/institutional_logs = list()
	if(has_any_institutional_access)
		for(var/fid in ALL_FUND_IDS)
			var/datum/fund/F = SStreasury.resolve_fund_by_id(fid)
			if(!F)
				continue
			var/obj/structure/roguemachine/vaultbank/V = SStreasury.find_jawbank_for_fund_id(fid)
			var/has_access = V && V.can_view(user)
			if(!has_access)
				continue
			fund_balances[fid] = list(
				"balance" = F.balance,
				"outstanding_principal" = SStreasury.get_outstanding_principal_from_fund(F),
			)
			institutional_logs[fid] = build_log_entries(F.name)
			if(V.supports_loans)
				for(var/datum/loan/L in SStreasury.loans)
					if(L.source_fund != F && L.target_fund != F)
						continue
					institutional_loans += list(list(
						"creditor_id" = fid,
						"creditor_label" = L.source_fund ? SStreasury.indenture_faction_label(L.source_fund) : "the Crown",
						"debtor" = L.debtor_name,
						"is_institutional" = L.is_institutional ? TRUE : FALSE,
						"target_id" = L.target_fund ? SStreasury.get_fund_id(L.target_fund) : "",
						"target_label" = L.target_fund ? SStreasury.indenture_faction_label(L.target_fund) : "",
						"principal" = L.principal,
						"interest_pct" = round(L.interest_rate * 100),
						"due_on_day" = L.due_on_day,
						"days_until_due" = L.days_until_due(),
						"minutes_until_due" = L.minutes_until_due(),
						"remaining" = L.get_remaining_due(),
						"defaulted" = L.defaulted ? TRUE : FALSE,
					))
	data["fund_balances"] = fund_balances
	data["institutional_loans"] = institutional_loans
	data["institutional_logs"] = institutional_logs

	// TODO(ES): player-named ledger entries aren't recorded in ES's integer-account model,
	// so this stays empty for now (see file header).
	data["personal_log"] = build_log_entries(H.real_name)
	// TODO(ES): Bathhouse Ordinance system is scoped out of the port - section stays hidden.
	data["bathhouse_ordinance_available"] = FALSE
	data["bathhouse_ordinance_active"] = FALSE
	data["bathhouse_tithe_round_total"] = 0
	data["bathhouse_ordinance_cooldown_seconds"] = 0

	var/list/patron_rosters = list()
	if(has_any_patronage_authority)
		for(var/fid in PATRONAGE_FUND_IDS)
			var/obj/structure/roguemachine/vaultbank/V = SStreasury.find_jawbank_for_fund_id(fid)
			if(!V || isnull(V.get_patronage_writ_path()))
				continue
			if(!V.can_issue_loan(user))
				continue
			var/list/roster_data = list()
			var/list/roster = V.get_patron_roster()
			if(islist(roster))
				for(var/mob/living/carbon/human/HP in roster)
					if(QDELETED(HP))
						continue
					roster_data += list(list("ref" = REF(HP), "name" = HP.real_name, "job" = HP.job || ""))
			patron_rosters[fid] = list(
				"patrons" = roster_data,
			)
	data["patron_rosters"] = patron_rosters

	return data

/obj/structure/roguemachine/atm/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = usr
	if(!istype(H))
		return TRUE
	if(!H.canUseTopic(src, BE_CLOSE))
		return TRUE
	switch(action)
		if("withdraw_personal")
			handle_withdraw_personal(H, params)
			SStgui.update_uis(src)
			return TRUE
		if("repay_loan")
			handle_repay_loan(H, params)
			SStgui.update_uis(src)
			return TRUE
		if("repay_indenture")
			handle_repay_indenture(H, params)
			SStgui.update_uis(src)
			return TRUE
		if("advance_poll_tax")
			handle_advance_poll_tax(H, params)
			SStgui.update_uis(src)
			return TRUE
		if("withdraw_institutional")
			handle_withdraw_institutional(H, params)
			SStgui.update_uis(src)
			return TRUE
		if("issue_personal")
			handle_issue_personal_for_fund(H, params)
			SStgui.update_uis(src)
			return TRUE
		if("issue_indenture")
			handle_issue_indenture_for_fund(H, params)
			SStgui.update_uis(src)
			return TRUE
		if("issue_patronage")
			handle_issue_patronage_for_fund(H, params)
			SStgui.update_uis(src)
			return TRUE
		if("revoke_patronage")
			handle_revoke_patronage_for_fund(H, params)
			SStgui.update_uis(src)
			return TRUE
		// TODO(ES): AP's "toggle_bathhouse_ordinance" action is scoped out with the
		// ordinance system; the frontend section that sends it is hidden.

/obj/structure/roguemachine/atm/proc/handle_withdraw_personal(mob/living/carbon/human/H, list/params)
	var/coin_amt = round(text2num("[params["amount"]]"))
	var/denom = "[params["denomination"]]"
	if(!(denom in list("GOLD", "SILVER", "BRONZE")))
		to_chat(H, span_warning("Choose a valid denomination."))
		return
	if(isnull(coin_amt) || coin_amt < 1)
		return
	if(coin_amt > 20)
		to_chat(H, span_warning("Maximum 20 coins per withdrawal."))
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/mod = 1
	if(denom == "GOLD")
		mod = 10
	else if(denom == "SILVER")
		mod = 5
	var/total = coin_amt * mod
	if(SStreasury.get_balance(H) < total)
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		to_chat(H, span_warning("Your balance is insufficient."))
		return
	if(!SStreasury.withdraw_money_account(total, H))
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	record_round_statistic(STATS_MAMMONS_WITHDRAWN, total)
	budget2change(total, H, denom)
	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)

/obj/structure/roguemachine/atm/proc/handle_repay_loan(mob/living/carbon/human/H, list/params)
	var/datum/loan/L = SStreasury.get_loan_for(H)
	if(!L)
		say("No active loan on record.")
		return
	var/pay_amt = round(text2num("[params["amount"]]"))
	if(isnull(pay_amt) || pay_amt < 1)
		return
	var/outstanding = L.get_remaining_due()
	var/balance = SStreasury.get_balance(H)
	pay_amt = min(pay_amt, outstanding, balance)
	if(pay_amt < 1)
		say("Nothing to repay with.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/paid = SStreasury.repay_loan(H, pay_amt)
	if(!paid)
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		say("The ledger refused the transfer.")
		return
	playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
	if(!SStreasury.get_loan_for(H))
		say("Loan repaid in full. [paid]m transferred.")
	else
		var/datum/loan/still = SStreasury.get_loan_for(H)
		say("[paid]m transferred. [still.get_remaining_due()]m remains.")

/obj/structure/roguemachine/atm/proc/handle_repay_indenture(mob/living/carbon/human/H, list/params)
	var/fund_id = "[params["fund_id"]]"
	var/obj/structure/roguemachine/vaultbank/V = SStreasury.find_jawbank_for_fund_id(fund_id)
	if(!V || !V.can_issue_loan(H))
		say("You lack the authority to make payments on behalf of that institution.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/datum/fund/target = SStreasury.resolve_fund_by_id(fund_id)
	if(!target)
		return
	var/datum/loan/L
	for(var/datum/loan/candidate in SStreasury.loans)
		if(candidate.is_institutional && candidate.target_fund == target)
			L = candidate
			break
	if(!L)
		say("No active indenture on record for that institution.")
		return
	var/pay_amt = round(text2num("[params["amount"]]"))
	if(isnull(pay_amt) || pay_amt < 1)
		return
	var/outstanding = L.get_remaining_due()
	pay_amt = min(pay_amt, outstanding, target.balance)
	if(pay_amt < 1)
		say("[target.name]'s coffers are too thin to make a payment.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/paid = SStreasury.repay_indenture(L, pay_amt)
	if(!paid)
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		say("The ledger refused the transfer.")
		return
	playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
	var/datum/loan/still_active
	for(var/datum/loan/check in SStreasury.loans)
		if(check.is_institutional && check.target_fund == target)
			still_active = check
			break
	if(!still_active)
		say("Indenture repaid in full. [paid]m transferred to [L.source_fund.name].")
	else
		say("[paid]m transferred. [still_active.get_remaining_due()]m remains on the indenture.")

// Taxation 2 (ported): prepay up to POLL_TAX_MAX_ADVANCE_DAYS of poll tax.
/obj/structure/roguemachine/atm/proc/handle_advance_poll_tax(mob/living/carbon/human/H, list/params)
	var/days = round(text2num("[params["days"]]") || 0)
	if(days <= 0)
		return
	if(SStreasury.poll_tax_pay_advance(H, days))
		playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
	else
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)

/obj/structure/roguemachine/atm/proc/handle_withdraw_institutional(mob/living/carbon/human/H, list/params)
	var/fund_id = "[params["fund_id"]]"
	var/obj/structure/roguemachine/vaultbank/V = SStreasury.find_jawbank_for_fund_id(fund_id)
	if(!V)
		to_chat(H, span_warning("That institution has no coffers to draw from."))
		return
	if(!V.can_withdraw(H))
		to_chat(H, span_warning("You are not authorised to withdraw from [V.get_patron_label() || V.get_faction_label()]."))
		return
	V.disburse(H, params)

/obj/structure/roguemachine/atm/proc/handle_issue_personal_for_fund(mob/living/carbon/human/H, list/params)
	var/fund_id = "[params["fund_id"]]"
	var/obj/structure/roguemachine/vaultbank/V = SStreasury.find_jawbank_for_fund_id(fund_id)
	if(!V)
		to_chat(H, span_warning("That institution has no coffers to lend from."))
		return
	if(!V.can_issue_loan(H))
		to_chat(H, span_warning("You are not authorised to draft loans for [V.get_faction_label()]."))
		return
	V.draft_personal_loan(H, params)

/obj/structure/roguemachine/atm/proc/handle_issue_indenture_for_fund(mob/living/carbon/human/H, list/params)
	var/fund_id = "[params["fund_id"]]"
	var/obj/structure/roguemachine/vaultbank/V = SStreasury.find_jawbank_for_fund_id(fund_id)
	if(!V)
		to_chat(H, span_warning("That institution has no coffers to lend from."))
		return
	if(!V.can_issue_loan(H))
		to_chat(H, span_warning("You are not authorised to draft indentures for [V.get_faction_label()]."))
		return
	V.draft_indenture(H, params)

/obj/structure/roguemachine/atm/proc/handle_issue_patronage_for_fund(mob/living/carbon/human/H, list/params)
	var/fund_id = "[params["fund_id"]]"
	var/obj/structure/roguemachine/vaultbank/V = SStreasury.find_jawbank_for_fund_id(fund_id)
	if(!V)
		to_chat(H, span_warning("That institution does not extend patronage."))
		return
	if(!V.can_issue_loan(H))
		to_chat(H, span_warning("You are not authorised to draft patronage for [V.get_patron_label()]."))
		return
	V.draft_patronage_writ(H)

/obj/structure/roguemachine/atm/proc/handle_revoke_patronage_for_fund(mob/living/carbon/human/H, list/params)
	var/fund_id = "[params["fund_id"]]"
	var/obj/structure/roguemachine/vaultbank/V = SStreasury.find_jawbank_for_fund_id(fund_id)
	if(!V)
		return
	if(!V.can_issue_loan(H))
		return
	V.revoke_patron(H, params)
