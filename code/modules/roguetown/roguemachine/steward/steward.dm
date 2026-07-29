#define TAB_MAIN 1
#define TAB_BANK 2
#define TAB_STOCK 3
#define TAB_IMPORT 4
#define TAB_DEBT 5
#define TAB_LOG 6
#define TAB_STATISTICS 7
#define TAB_PAYDAY 8
#define TAB_SALTMINE 9

/obj/structure/roguemachine/steward
	name = "nerve master"
	desc = "The stewards most trusted friend."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "steward_machine"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	locked = FALSE
	var/keycontrol = "steward"
	var/current_tab = TAB_MAIN
	var/compact = TRUE
	var/total_deposit = 0
	var/list/excluded_jobs = list("Wretch","Vagabond","Adventurer")
	var/list/daily_payments = list() // Associative list: job name -> payment amount
	// Last trade-modal quote keyed by ckey. Read by ui_data to round-trip per-user. (Step 15)
	var/list/last_trade_quote = list()
	// Per-user ledger view state keyed by ckey: list("open", "page", "filter"). Only populated
	// into ui_static_data while a user has the Ledger tab open, so the full ledger never rides
	// the per-tick Market Scroll payload.
	var/list/ledger_view = list()
	// Item 6 decrees: anti-spam gate on Letter of Citizenry printing.
	var/residency_print_cooldown = 0
	COOLDOWN_DECLARE(fulfill_retry_cooldown)

/obj/structure/roguemachine/steward/Initialize(mapload)
	. = ..()
	if(SStreasury.steward_machine == null) //The "only one" mapped in Nerve Master at map start
		SStreasury.steward_machine = src
	setup_default_payments()

//	For competence of life I will allow you,
//	That lack of means enforce you not to evil:
/obj/structure/roguemachine/steward/proc/setup_default_payments()
	daily_payments["Knight Captain"] = 40
	if(SSmapping.current_map.map_name == "Dun World")
		daily_payments["Sergeant"] = 40 //Garrison
	if(SSmapping.current_map.map_name == "Desert Town")
		daily_payments["Slave Master"] = 50
		daily_payments["Cataphract"] = 40
		daily_payments["Janissary Sergeant"] = 40 //Garrison
		daily_payments["Janissary"] = 30
		daily_payments["Azeb Agha"] = 40
		daily_payments["Azeb"] = 20
	else
		daily_payments["Knight"] = 40
		daily_payments["Man at Arms"] = 30
		daily_payments["Warden"] = 25
		daily_payments["Dungeoneer"] = 30
	if(SSmapping.current_map.map_name == "Rockhill")
		daily_payments["Watch Captain"] = 45 //Don't get to live in a fancy keep with servants. More expenses.
		daily_payments["Master Warden"] = 35 //Garrison
		daily_payments["City Guard"] = 30
		daily_payments["Vanguard"] = 20
	daily_payments["Rookie"] = 20//paid more than squires because they don't get to live in a castle with maids cooking them dinner
	daily_payments["Veteran"] = 30
	daily_payments["Squire"] = 10
//courtiers
	daily_payments["Head Physician"] = 30 //Doctors
	daily_payments["Apothecary"] = 20 //paid by the keep to heal people, would make sense.
	daily_payments["Court Magician"] = 50 //University
	if(SSmapping.current_map.map_name == "Desert Town")
		daily_payments["Palace Chaplain"] = 30
		daily_payments["Headslave"] = 20 //Manor-House
	else
		daily_payments["Court Chaplain"] = 30
		daily_payments["Seneschal"] = 40 //Manor-House
		daily_payments["Servant"] = 20
	daily_payments["Archivist"] = 10
	daily_payments["Magicians Associate"] = 10
	daily_payments["Jester"] = 6

	if(SSmapping.current_map.map_name == "Roguetest")
		daily_payments["Shophand"] = 999
	// Item 6 decrees: bump defaults up to any roundstart-active charter's mandated floor.
	enforce_wage_floors()

/obj/structure/roguemachine/steward/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguekey))
		var/obj/item/roguekey/K = P
		if(K.lockid == keycontrol || istype(K, /obj/item/roguekey/lord)) //Master key
			locked = !locked
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			(locked) ? (icon_state = "steward_machine_off") : (icon_state = "steward_machine")
			update_icon()
			return
		else
			to_chat(user, span_warning("Wrong key."))
			return
	if(istype(P, /obj/item/storage/keyring))
		var/obj/item/storage/keyring/K = P
		if(!K.contents.len)
			return
		var/list/keysy = K.contents.Copy()
		for(var/obj/item/roguekey/KE in keysy)
			if(KE.lockid == keycontrol)
				locked = !locked
				playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
				(locked) ? (icon_state = "steward_machine_off") : (icon_state = "steward_machine")
				update_icon()
				return
		to_chat(user, span_warning("Wrong key."))
		return
	if(istype(P, /obj/item/roguecoin/gilbranze))
		return
	if(istype(P, /obj/item/roguecoin/inqcoin))
		return
	if(istype(P, /obj/item/roguecoin))
		record_round_statistic(STATS_MAMMONS_DEPOSITED, P.get_real_price())
		SStreasury.give_money_treasury(P.get_real_price(), "NERVE MASTER deposit")
		qdel(P)
		playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
		return
	return ..()


/obj/structure/roguemachine/steward/Topic(href, href_list)
	. = ..()
	var/realmname = SSmapping.map_adjustment.realm_name
	if(!usr.canUseTopic(src, BE_CLOSE) || locked)
		return
	if(href_list["switchtab"])
		current_tab = text2num(href_list["switchtab"])
	if(href_list["import"])
		// Step 15: crown imports (GLOB.crown_imports) replaced the legacy roguestock imports.
		var/datum/crown_import/D = locate(href_list["import"]) in GLOB.crown_imports
		if(!D)
			return
		var/amt = D.get_import_price()
		// ES deviation, fund-API-backed (was a raw treasury_value -= that desynced from the
		// Crown's Purse, letting the next mint/burn resurrect the spent money)
		if(!SStreasury.burn(SStreasury.discretionary_fund, amt, "Import: [D.name]"))
			say("Insufficient mammon.")
			return
		SStreasury.total_import += amt
		SStreasury.log_to_steward("-[amt] imported [D.name]")
		record_round_statistic(STATS_STOCKPILE_IMPORTS_VALUE, amt)
		if(amt >= 100) //Only announce big spending.
			scom_announce("[realmname] imports [D.name] for [amt] mammon.", )
		D.raise_demand()
		addtimer(CALLBACK(src, PROC_REF(do_import), D.type), 10 SECONDS)
	if(href_list["export"])
		var/datum/roguestock/D = locate(href_list["export"]) in SStreasury.stockpile_datums
		if(!D)
			return
		// Trade-good entries must export through the StewardTrade TGUI (manual_export), which
		// enforces and decrements regional demand. This legacy handler has no UI link anymore;
		// without this guard a crafted href could mint at best-region prices with no demand cap.
		if(D.trade_good_id)
			return
		if(!SStreasury.do_export(D))
			say("Insufficient stock.")
			return
	if(href_list["setpurchasefloor"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/current_floor = SStreasury.stockpile_purchase_floor
		var/new_floor = input(usr, "Set the Crown's Purchase Floor. Below this balance the stockpile refuses purchases - goods stay with the seller. (0-10000m)", src, current_floor) as null|num
		if(isnull(new_floor))
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		new_floor = CLAMP(round(new_floor), 0, 10000)
		SStreasury.stockpile_purchase_floor = new_floor
		say("Crown's Purchase Floor set to [new_floor]m.")
		log_game("PURCHASE FLOOR: [key_name(usr)] set stockpile purchase floor to [new_floor]m")
	if(href_list["clearloandebtor"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/list/debtors = list()
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(HAS_TRAIT(H, TRAIT_DEBTOR))
				debtors["[H.real_name]"] = H
		if(!length(debtors))
			say("No debtors currently marked.")
			return
		var/pick = input(usr, "Clear defaulter mark from which debtor?", src) as null|anything in debtors
		if(!pick)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/mob/living/carbon/human/target = debtors[pick]
		if(!target || !HAS_TRAIT(target, TRAIT_DEBTOR))
			return
		REMOVE_TRAIT(target, TRAIT_DEBTOR, TRAIT_GENERIC)
		var/datum/loan/forgiven = SStreasury.get_loan_for(target)
		var/loan_amt = forgiven ? forgiven.get_remaining_due() : 0
		if(forgiven)
			SStreasury.loans -= forgiven
			qdel(forgiven)
		SStreasury.clear_poll_tax_debt(target)
		say("[target.real_name]'s debtor mark has been cleared; all Crown debts forgiven.")
		log_game("DEBT FORGIVEN: [key_name(usr)] cleared debtor mark on [key_name(target)][loan_amt ? " (wrote off [loan_amt]m loan)" : ""]")
		to_chat(target, span_notice("The Stewardry has cleared the defaulter mark from my name. My debts to the Crown are forgiven."))
	if(href_list["clearpolltax"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/list/in_arrears = list()
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(SStreasury.poll_tax_owed[H] || SStreasury.poll_tax_debt_days[H] || HAS_TRAIT(H, TRAIT_ARREARS))
				in_arrears["[H.real_name]"] = H
		if(!length(in_arrears))
			say("No poll tax arrears on the ledger.")
			return
		var/pick = input(usr, "Clear poll tax arrears for which subject?", src) as null|anything in in_arrears
		if(!pick)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/mob/living/carbon/human/target = in_arrears[pick]
		if(!target)
			return
		var/was_owed = SStreasury.poll_tax_owed[target] || 0
		var/was_overdue = SStreasury.poll_tax_debt_days[target] || 0
		SStreasury.clear_poll_tax_debt(target)
		say("[target.real_name]'s poll tax arrears have been cleared.")
		log_game("POLL TAX CLEARED: [key_name(usr)] cleared [was_owed]m poll tax arrears on [key_name(target)] ([was_overdue] day\s overdue)")
		to_chat(target, span_notice("The Stewardry has cleared my poll tax arrears. The Crown's ledger on my head is wiped clean."))
	// Step 15: stockpile price/limit/withdraw management moved to the StewardTrade TGUI
	// (setprice/setlimit/togglewithdraw Topic handlers removed). Ratwood keeps the passive
	// import rate handler; that system is not covered by the TGUI.
	if(href_list["setrate"])
		var/datum/roguestock/D = locate(href_list["setrate"]) in SStreasury.stockpile_datums
		if(!D)
			return              //Cheaper prices, no taxes, the price? Commitment. You can only change the rates at day. I'd like to make the window shorter,
		if(GLOB.tod == "night") //less chance to micromanage, incentivize doing other things at later hours, make it unable to be changed at dusk too, but this needs testing first
			say("Suppliers will only agree to modifying deals at times when Astrata shines.")
			return
		var/newrate = input(usr, "Set a new rate for remote imports for [D.name]", src, D.passive_generation) as null|num
		if(!isnull(newrate))
			if(!usr.canUseTopic(src, BE_CLOSE) || locked)
				return
			if(findtext(num2text(newrate), "."))
				return
			newrate = CLAMP(newrate, 0, D.generation_max)
			scom_announce("[realmname] will [newrate ? "now import [newrate] [D.name] every 5 hours." : "no longer import [D.name] periodically"]")
			D.passive_generation = newrate
	if(href_list["givemoney"])
		var/X = locate(href_list["givemoney"])
		if(!X)
			return
		for(var/mob/living/A in SStreasury.bank_accounts)
			if(A == X)
				var/newtax = input(usr, "How much to give [X]", src) as null|num
				if(!usr.canUseTopic(src, BE_CLOSE) || locked)
					return
				if(findtext(num2text(newtax), "."))
					return
				if(!newtax)
					return
				if(newtax < 1)
					return
				SStreasury.give_money_account(newtax, A, "NERVE MASTER")
				break
	if(href_list["fineaccount"])
		var/X = locate(href_list["fineaccount"])
		if(!X)
			return
		for(var/mob/living/A in SStreasury.bank_accounts)
			if(A == X)
				// Levying a Crown fine is a fiscal-authority action, same gate as toggling wages.
				var/is_authorized = FALSE
				if(usr.job == "Steward" || usr.job == "Clerk" || usr.job == "Grand Duke")
					is_authorized = TRUE
				if(SSticker.regentmob && usr == SSticker.regentmob)
					is_authorized = TRUE
				if(!is_authorized)
					say("Only the Steward, Clerk, or Ruler may levy fines.")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				// Ratwood per-category fine exemption on top of the decree caps below.
				if(SStreasury.check_fine_exemption(A))
					say("By our Liege's mercy, they can not be fined!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				// Item 6 decrees: charter exemptions (Great Writ) and caps (Golden Bull,
				// one-fine-per-day) bound the Crown's fines - surface the ceiling up front.
				var/max_fine = SStreasury.get_max_fine_for(A)
				if(max_fine <= 0)
					say("[A] cannot be fined by the Crown at this time.")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				var/newtax = input(usr, "How much to fine [A]? (Maximum [max_fine]m)", src, max_fine) as null|num
				if(!usr.canUseTopic(src, BE_CLOSE) || locked)
					return
				if(findtext(num2text(newtax), "."))
					return
				if(!newtax)
					return
				if(newtax < 1)
					return
				if(newtax > max_fine)
					newtax = max_fine
					say("The ledger will accept no more than [max_fine]m from [A]. Amount adjusted.")
				SStreasury.give_money_account(-newtax, A, "NERVE MASTER")
				break
	if(href_list["printresidency"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(world.time < residency_print_cooldown)
			say("The machine is still warming its quill.")
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		var/mob/living/carbon/human/H = usr
		var/obj/item/citizenry_letter/letter = new(get_turf(src))
		letter.issuer_name = H.real_name
		letter.issuer_year = CALENDAR_EPOCH_YEAR
		residency_print_cooldown = world.time + 1 MINUTES
		playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
		say("Letter of Citizenry issued, signed by [H.real_name].")
	if(href_list["payroll"])
		var/list/L = list(GLOB.noble_positions) + list(GLOB.garrison_positions) + list(GLOB.courtier_positions) + list(GLOB.church_positions) + list(GLOB.yeoman_positions) + list(GLOB.peasant_positions) + list(GLOB.youngfolk_positions) + list(GLOB.inquisition_positions)
		var/list/things = list()
		for(var/list/category in L)
			for(var/A in category)
				things += A
		var/job_to_pay = input(usr, "Select a job", src) as null|anything in things
		if(!job_to_pay)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/amount_to_pay = input(usr, "How much to pay every [job_to_pay]", src) as null|num
		if(!amount_to_pay)
			return
		if(amount_to_pay<1)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(findtext(num2text(amount_to_pay), "."))
			return
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.job == job_to_pay)
				if(SStreasury.give_money_account(amount_to_pay, H, "NERVE MASTER"))
					record_round_statistic(STATS_WAGES_PAID, amount_to_pay)
	if(href_list["setdailypay"])
		var/list/L = list(GLOB.noble_positions) + list(GLOB.garrison_positions) + list(GLOB.courtier_positions) + list(GLOB.church_positions) + list(GLOB.yeoman_positions) + list(GLOB.peasant_positions) + list(GLOB.youngfolk_positions) + list(GLOB.inquisition_positions)
		var/list/things = list()
		for(var/list/category in L)
			for(var/A in category)
				things += A
		var/job_to_pay = input(usr, "Select a job", src) as null|anything in things
		if(!job_to_pay)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		// Item 6 decrees: active charters (Indenture of War, Covenant of Noc & Pestra) floor
		// certain wages - the Nerve Master refuses to set covered jobs below the floor.
		var/wage_floor = SStreasury.get_wage_floor(job_to_pay)
		var/payprompt = wage_floor > 0 ? "Set daily payment for [job_to_pay] (floor: [wage_floor]m by Charter; 0 not permitted)" : "Set daily payment for [job_to_pay] (0 to remove)"
		var/amount_to_pay = input(usr, payprompt, src, daily_payments[job_to_pay] ? daily_payments[job_to_pay] : wage_floor) as null|num
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(findtext(num2text(amount_to_pay), "."))
			return
		if(isnull(amount_to_pay))
			return
		amount_to_pay = CLAMP(amount_to_pay, 0, 999)
		if(wage_floor > 0 && amount_to_pay < wage_floor)
			amount_to_pay = wage_floor
			say("By Charter, [job_to_pay]'s wage may not fall below [wage_floor]m. Payment set to the floor.")
		if(amount_to_pay == 0)
			daily_payments -= job_to_pay
			say("Daily payment for [job_to_pay] removed.")
		else
			daily_payments[job_to_pay] = amount_to_pay
			say("Daily payment for [job_to_pay] set to [amount_to_pay]m.")
	if(href_list["removedailypay"])
		var/job_to_remove = href_list["removedailypay"]
		var/removal_floor = SStreasury.get_wage_floor(job_to_remove)
		if(removal_floor > 0)
			daily_payments[job_to_remove] = removal_floor
			say("By Charter, [job_to_remove]'s wage cannot be removed. Payment held at the floor of [removal_floor]m.")
		else
			daily_payments -= job_to_remove
			say("Daily payment for [job_to_remove] removed.")
	if(href_list["togglewages"])
		var/X = locate(href_list["togglewages"])
		if(!X)
			return
		for(var/mob/living/carbon/human/A in SStreasury.bank_accounts)
			if(A == X)
				// Check if user has permission (Steward, Clerk, Grand Duke, or Regent)
				var/is_authorized = FALSE
				if(usr.job == "Steward" || usr.job == "Clerk" || usr.job == "Grand Duke")
					is_authorized = TRUE
				if(SSticker.regentmob && usr == SSticker.regentmob)
					is_authorized = TRUE

				if(!is_authorized)
					say("Only the Steward, Clerk, or Ruler may suspend wages.")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return

				if(HAS_TRAIT(A, TRAIT_WAGES_SUSPENDED))
					REMOVE_TRAIT(A, TRAIT_WAGES_SUSPENDED, TRAIT_GENERIC)
					say("[A.real_name]'s wages have been reinstated.")
					to_chat(A, span_notice("My wages have been reinstated by the Stewardry."))
				else
					ADD_TRAIT(A, TRAIT_WAGES_SUSPENDED, TRAIT_GENERIC)
					say("[A.real_name]'s wages have been suspended.")
					to_chat(A, span_danger("My wages have been suspended by the Stewardry!"))
				break
	if(href_list["compact"])
		compact = !compact
	// Step 15: category browsing and the auto-export slider live in the StewardTrade TGUI now.
	if(href_list["trade_tgui"])
		open_trade_tgui(usr)
		return

	return attack_hand(usr)

// ── StewardTrade TGUI trade helpers (Step 15) ────────────────────────────────────────────────

/obj/structure/roguemachine/steward/proc/quote_trade(mob/user, side, region_id, good_id, quantity)
	// Carry the request identity on EVERY return (including the error early-returns below), so the
	// TradeModal's incoming-quote filter (side/region_id/good_id must match) doesn't discard an
	// error quote and leave the modal spinning without ever showing the failure reason.
	. = list(
		"ok" = FALSE,
		"reason" = "",
		"side" = side,
		"region_id" = region_id,
		"good_id" = good_id,
	)
	if(!user_can_act(user))
		.["reason"] = "out of reach"
		return
	var/is_alderman_acting = alderman_has_access(user)
	if(locked && !is_alderman_acting)
		.["reason"] = "machine locked"
		return
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!region || !tg)
		.["reason"] = "unknown region or good"
		return
	quantity = clamp(round(quantity), 1, TRADE_MAX_BULK_UNITS)
	var/daily_pace
	var/used_today
	if(side == "import")
		daily_pace = region.produces[good_id] || 0
		used_today = daily_pace - (region.produces_today[good_id] || 0)
	else
		daily_pace = region.demands[good_id] || 0
		used_today = daily_pace - (region.demands_today[good_id] || 0)
	if(daily_pace <= 0)
		.["reason"] = side == "import" ? "region does not produce this" : "region does not demand this"
		return
	var/starting_index = max(0, used_today)
	// Base portion = units priced inside daily capacity (overshoot = 0).
	// Escalation portion = units priced past capacity.
	var/base_unit_price = side == "import" \
		? SSeconomy.compute_import_unit_price(good_id, region, 1) \
		: SSeconomy.compute_export_unit_price(good_id, region, 1)
	var/base_subtotal = 0
	var/escalation_subtotal = 0
	for(var/i in 1 to quantity)
		var/idx = starting_index + i
		var/unit
		if(side == "import")
			unit = SSeconomy.compute_import_unit_price(good_id, region, idx)
		else
			unit = SSeconomy.compute_export_unit_price(good_id, region, idx)
		if(idx <= daily_pace)
			base_subtotal += unit
		else
			// Per overshoot unit: import surcharge (unit > base) or export shortfall (unit < base).
			// Server ships escalation_subtotal as a positive magnitude; the client adds + or −
			// based on side. total uses the signed delta directly.
			escalation_subtotal += abs(unit - base_unit_price)
			base_subtotal += base_unit_price
	var/total
	if(side == "import")
		total = base_subtotal + escalation_subtotal
	else
		total = base_subtotal - escalation_subtotal
	var/balance = SStreasury.discretionary_fund.balance
	var/can_afford = side == "import" ? (balance >= total) : TRUE
	var/warrant_remaining = -1
	var/warrant_ok = TRUE
	if(is_alderman_acting && SScity_assembly?.current_warrant)
		warrant_remaining = SScity_assembly.current_warrant.trade_remaining
		warrant_ok = SScity_assembly.can_consume_trade(total)
	var/datum/roguestock/stockpile_entry = SSeconomy.find_stockpile_by_trade_good(good_id)
	var/stockpile_amount = stockpile_entry?.stockpile_amount || 0
	. = list(
		"ok" = TRUE,
		"reason" = "",
		"side" = side,
		"region_id" = region_id,
		"good_id" = good_id,
		"region_name" = region.name,
		"good_name" = tg.name,
		"quantity" = quantity,
		"max_units" = TRADE_MAX_BULK_UNITS,
		"daily_pace" = daily_pace,
		"batch_capacity" = region.get_batch_capacity(good_id, side == "import"),
		"capacity_today" = region.get_day_capacity(good_id, side == "import"),
		"capacity_total" = region.get_day_capacity_total(good_id, side == "import"),
		"base_unit_price" = base_unit_price,
		"base_subtotal" = base_subtotal,
		"escalation_subtotal" = escalation_subtotal,
		"total" = total,
		"balance" = balance,
		"balance_after" = side == "import" ? balance - total : balance + total,
		"is_blockaded" = region.is_region_blockaded ? 1 : 0,
		"is_alderman_acting" = is_alderman_acting ? 1 : 0,
		"warrant_remaining" = warrant_remaining,
		"warrant_ok" = warrant_ok ? 1 : 0,
		"can_afford" = can_afford ? 1 : 0,
		"stockpile_amount" = stockpile_amount,
		"stockpile_after" = side == "import" ? stockpile_amount + quantity : max(0, stockpile_amount - quantity),
	)

/obj/structure/roguemachine/steward/proc/handle_trade_import(mob/user, region_id, good_id, quantity)
	if(!user_can_act(user))
		return
	var/is_alderman_acting = alderman_has_access(user)
	if(locked && !is_alderman_acting)
		return
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!region || !tg)
		return
	quantity = clamp(round(quantity), 1, TRADE_MAX_BULK_UNITS)
	if(quantity < 1)
		return
	var/daily_pace = region.produces[good_id] || 0
	if(daily_pace <= 0)
		to_chat(user, span_warning("[region.name] does not produce [tg.name]."))
		return
	var/produces_today = region.produces_today[good_id] || 0
	var/starting_index = max(0, daily_pace - produces_today)
	var/total = 0
	for(var/i in 1 to quantity)
		total += SSeconomy.compute_import_unit_price(good_id, region, starting_index + i)
	if(is_alderman_acting && !SScity_assembly.can_consume_trade(total))
		to_chat(user, span_warning("Your warrant cannot cover this trade. Remaining: [SScity_assembly.current_warrant.trade_remaining]m."))
		return
	var/spent = SSeconomy.manual_import(user, region_id, good_id, quantity)
	if(spent > 0)
		if(is_alderman_acting)
			SScity_assembly.consume_trade(spent, user, "import [quantity] [tg.name] from [region.name]")
		say("[SSmapping.map_adjustment.realm_name] imports [quantity] [tg.name] from [region.name] for [spent] mammon.")
		playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
	SStgui.update_uis(src)

/obj/structure/roguemachine/steward/proc/handle_trade_export(mob/user, region_id, good_id, quantity)
	if(!user_can_act(user))
		return
	var/is_alderman_acting = alderman_has_access(user)
	if(locked && !is_alderman_acting)
		return
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!region || !tg)
		return
	quantity = clamp(round(quantity), 1, TRADE_MAX_BULK_UNITS)
	if(quantity < 1)
		return
	var/daily_pace = region.demands[good_id] || 0
	if(daily_pace <= 0)
		to_chat(user, span_warning("[region.name] does not demand [tg.name]."))
		return
	var/datum/roguestock/entry = SSeconomy.find_stockpile_by_trade_good(good_id)
	if(!entry || entry.stockpile_amount < quantity)
		to_chat(user, span_warning("Insufficient [tg.name] in stockpile: have [entry?.stockpile_amount || 0], need [quantity]."))
		return
	var/demands_today = region.demands_today[good_id] || 0
	var/starting_index = max(0, daily_pace - demands_today)
	var/total = 0
	for(var/i in 1 to quantity)
		total += SSeconomy.compute_export_unit_price(good_id, region, starting_index + i)
	if(is_alderman_acting && !SScity_assembly.can_consume_trade(total))
		to_chat(user, span_warning("Your warrant cannot cover this trade. Remaining: [SScity_assembly.current_warrant.trade_remaining]m."))
		return
	var/gained = SSeconomy.manual_export(user, region_id, good_id, quantity)
	if(gained > 0)
		if(is_alderman_acting)
			SScity_assembly.consume_trade(gained, user, "export [quantity] [tg.name] to [region.name]")
		say("[SSmapping.map_adjustment.realm_name] exports [quantity] [tg.name] to [region.name] for [gained] mammon.")
		playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	SStgui.update_uis(src)

/obj/structure/roguemachine/steward/proc/handle_trade_region_import(mob/user, region_id)
	if(!user_can_act(user))
		return
	if(locked && !alderman_has_access(user))
		return
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	if(!region)
		return
	var/list/options = list()
	for(var/good_id in region.produces)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(!tg || !tg.importable)
			continue
		options["[tg.name]"] = good_id
	if(!length(options))
		to_chat(user, span_warning("[region.name] has no importable goods."))
		return
	var/pick_name = input(user, "Import what from [region.name]?", src) as null|anything in options
	if(!pick_name)
		return
	var/good_id = options[pick_name]
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	var/quantity = input(user, "How many [tg.name] to import from [region.name]? (max [TRADE_MAX_BULK_UNITS])", src, 1) as null|num
	if(!quantity || quantity < 1)
		return
	handle_trade_import(user, region_id, good_id, quantity)

/obj/structure/roguemachine/steward/proc/handle_trade_region_export(mob/user, region_id)
	if(!user_can_act(user))
		return
	if(locked && !alderman_has_access(user))
		return
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	if(!region)
		return
	var/list/options = list()
	for(var/good_id in region.demands)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(!tg)
			continue
		options["[tg.name]"] = good_id
	if(!length(options))
		to_chat(user, span_warning("[region.name] has no demanded goods."))
		return
	var/pick_name = input(user, "Export what to [region.name]?", src) as null|anything in options
	if(!pick_name)
		return
	var/good_id = options[pick_name]
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	var/quantity = input(user, "How many [tg.name] to export to [region.name]? (max [TRADE_MAX_BULK_UNITS])", src, 1) as null|num
	if(!quantity || quantity < 1)
		return
	handle_trade_export(user, region_id, good_id, quantity)

/obj/structure/roguemachine/steward/proc/do_import(datum/crown_import/D, number)
	if(!D)
		return
	D = new D
	if(number > D.import_amt)
		return

	if(!number)
		number = 1
	var/area/A = GLOB.areas_by_type[/area/rogue/indoors/town/warehouse]
	if(!A)
		return
	var/obj/item/I = new D.item_type()
	var/list/turfs = list()
	for(var/turf/T in A)
		turfs += T
	var/turf/T = pick(turfs)
	I.forceMove(T)
	playsound(T, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	number += 1

	addtimer(CALLBACK(src, PROC_REF(do_import), D.type, number), 3 SECONDS)

/obj/structure/roguemachine/steward/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(locked && alderman_has_access(user))
		open_trade_tgui(user)
		return
	if(locked)
		to_chat(user, span_warning("It's locked. Of course."))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
	var/canread = user.can_read(src, TRUE)
	var/contents
	switch(current_tab)
		if(TAB_MAIN)
			contents += "<center>NERVE MASTER<BR>"
			contents += "--------------<BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_BANK]'>\[Bank\]</a><BR>"
			contents += "<a href='?src=\ref[src];trade_tgui=1'>\[Trade & Stockpile\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_IMPORT]'>\[Import\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_PAYDAY]'>\[Daily Payments\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_DEBT]'>\[Debts &amp; Arrears\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_LOG]'>\[Log\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_STATISTICS]'>\[Statistics\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_SALTMINE]'>\[Salt Mine Report\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_STOCK]'>\[Passive Imports\]</a><BR>"
			contents += "<a href='?src=\ref[src];printresidency=1'>\[Print Letter of Citizenry\]</a><BR>"
			contents += "<a href='?src=\ref[src];setpurchasefloor=1'>\[Purchase Floor: [SStreasury.stockpile_purchase_floor]m\]</a><BR>"
			contents += "</center>"
		if(TAB_BANK)
			var/total_deposit = 0
			for(var/bank_account in SStreasury.bank_accounts)
				total_deposit += SStreasury.bank_accounts[bank_account]
			if(total_deposit == 0)
				total_deposit++ //Division by zero catch
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a>"
			contents += " <a href='?src=\ref[src];compact=1'>\[Compact: [compact? "ENABLED" : "DISABLED"]\]</a><BR>"
			contents += "<center>Bank<BR>"
			contents += "--------------<BR>"
			contents += "Treasury: [SStreasury.treasury_value]m<BR>"
			contents += "Reserve Ratio: [round(SStreasury.treasury_value / total_deposit * 100)]%</center><BR>"
			contents += "<a href='?src=\ref[src];payroll=1'>\[Pay by Class\]</a><BR><BR>"
			if(compact)
				for(var/mob/living/carbon/human/A in SStreasury.bank_accounts)
					if(ishuman(A))
						var/mob/living/carbon/human/tmp = A
						contents += "[tmp.real_name] ([job_filter(tmp.advjob, tmp.job, compact)]) - [SStreasury.bank_accounts[A]]m"
					else
						contents += "[A.real_name] - [SStreasury.bank_accounts[A]]m"
					var/wage_status = HAS_TRAIT(A, TRAIT_WAGES_SUSPENDED) ? "UNSUSPEND" : "SUSPEND"
					contents += " / <a href='?src=\ref[src];givemoney=\ref[A]'>\[PAY\]</a> <a href='?src=\ref[src];fineaccount=\ref[A]'>\[FINE\]</a> <a href='?src=\ref[src];togglewages=\ref[A]'>\[[wage_status]\]</a><BR><BR>"
			else
				for(var/mob/living/carbon/human/A in SStreasury.bank_accounts)
					if(ishuman(A))
						var/mob/living/carbon/human/tmp = A
						contents += "[tmp.real_name] ([job_filter(tmp.advjob, tmp.job, compact)]) - [SStreasury.bank_accounts[A]]m<BR>"
					else
						contents += "[A.real_name] - [SStreasury.bank_accounts[A]]m<BR>"
					var/wage_status = HAS_TRAIT(A, TRAIT_WAGES_SUSPENDED) ? "Unsuspend Wages" : "Suspend Wages"
					contents += "<a href='?src=\ref[src];givemoney=\ref[A]'>\[Give Money\]</a> <a href='?src=\ref[src];fineaccount=\ref[A]'>\[Fine Account\]</a> <a href='?src=\ref[src];togglewages=\ref[A]'>\[[wage_status]\]</a><BR><BR>"
		if(TAB_STOCK)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a><BR>"
			contents += "<center>Passive Imports<BR>"
			contents += "--------------<BR>"
			contents += "Treasury: [SStreasury.treasury_value]m<BR>"
			contents += "Current Passive Spending: [SStreasury.get_current_passive_spending()]m per tick</center><BR>"
			// Ratwood passive imports: rate management stays here; prices, limits and manual
			// import/export moved to the StewardTrade TGUI.
			for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
				if(A.no_passive)
					continue
				contents += "<b>[A.name]:</b> [A.stockpile_amount]/[A.stockpile_limit]"
				contents += " / Rate: <a href='?src=\ref[src];setrate=\ref[A]'>[A.passive_generation]</a> ([A.generation_price]m each)<BR>"
		if(TAB_IMPORT)
			// Step 15: renders GLOB.crown_imports (regional sourcing + blockade surcharges).
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a>"
			contents += " <a href='?src=\ref[src];compact=1'>\[Compact: [compact? "ENABLED" : "DISABLED"]\]</a><BR>"
			contents += "<center>Imports<BR>"
			contents += "--------------<BR>"
			if(compact)
				contents += "Treasury: [SStreasury.treasury_value]m</center><BR>"
				for(var/datum/crown_import/A in GLOB.crown_imports)
					var/blockade_tag = A.is_blockaded() ? " <font color='#c44'>(BLOCKADED)</font>" : ""
					contents += "<b>[A.name][blockade_tag]:</b>"
					contents += " <a href='?src=\ref[src];import=\ref[A]'>\[Import [A.import_amt] ([A.get_import_price()])\]</a><BR>"
			else
				contents += "Treasury: [SStreasury.treasury_value]m</center><BR>"
				for(var/datum/crown_import/A in GLOB.crown_imports)
					var/blockade_tag_full = A.is_blockaded() ? " <font color='#c44'>(BLOCKADED - 2x COST)</font>" : ""
					contents += "<b>[A.name][blockade_tag_full]</b> - <i>[A.desc]</i> "
					contents += "<a href='?src=\ref[src];import=\ref[A]'>\[Import [A.import_amt] ([A.get_import_price()])\]</a><BR>"
		if(TAB_DEBT)
			// AP parity (their TAB_DEBT), with one fix: AP built the loan-line string but
			// never appended it and counted every loan as a Crown loan - here the list
			// renders and the count matches it.
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a><BR>"
			contents += "<center>Debts &amp; Arrears<BR>"
			contents += "--------------<BR>"
			contents += "Treasury: [SStreasury.discretionary_fund.balance]m</center><BR>"
			var/crown_loans = 0
			var/crown_loan_content = ""
			for(var/datum/loan/L in SStreasury.loans)
				if(L.source_fund != SStreasury.discretionary_fund)
					continue
				crown_loans++
				var/loan_color = L.defaulted ? "#d9534f" : "#e07b39"
				crown_loan_content += "<font color='[loan_color]'>[L.format()]</font><BR>"
			if(crown_loans)
				contents += "<b>Active Crown Loans ([crown_loans]):</b><BR>"
				contents += crown_loan_content
				contents += "<BR>"
			else
				contents += "<i>No active loans.</i><BR><BR>"
			var/list/debt_rows = list()
			for(var/mob/living/carbon/human/A in SStreasury.bank_accounts)
				var/poll_owed = SStreasury.poll_tax_owed[A] || 0
				if(poll_owed > 0 || HAS_TRAIT(A, TRAIT_DEBTOR))
					debt_rows += A
			if(length(debt_rows))
				contents += "<b>Poll Tax Debtors / Arrears ([length(debt_rows)]):</b><BR>"
				for(var/mob/living/carbon/human/A in debt_rows)
					var/poll_owed = SStreasury.poll_tax_owed[A] || 0
					var/overdue_days = SStreasury.poll_tax_debt_days[A] || 0
					var/balance = SStreasury.get_balance(A)
					if(HAS_TRAIT(A, TRAIT_DEBTOR_CROWN))
						var/owed_str = poll_owed > 0 ? ", owes [poll_owed]m" : ""
						contents += "<font color='#d9534f'><b>[A.real_name]</b> \[DEBTOR[owed_str]\]</font> - balance: [balance]m"
					else
						contents += "<font color='#e07b39'><b>[A.real_name]</b> \[ARREARS: [poll_owed]m, [overdue_days] day[overdue_days == 1 ? "" : "s"]\]</font> - balance: [balance]m"
					contents += "<BR>"
				contents += "<BR>"
			else
				contents += "<i>No poll tax arrears.</i><BR><BR>"
			contents += "<a href='?src=\ref[src];clearloandebtor=1'>\[Clear Defaulter Mark\]</a><BR>"
			contents += "<font color='gray'><i>(Forgives outstanding loans entirely and lifts the defaulter mark.)</i></font><BR>"
			contents += "<a href='?src=\ref[src];clearpolltax=1'>\[Clear Poll Tax Obligation\]</a><BR>"
			contents += "<font color='gray'><i>(Wipes a subject's poll tax arrears.)</i></font><BR>"
		if(TAB_LOG)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a><BR>"
			contents += "<center>Log<BR>"
			contents += "--------------</center><BR><BR>"
			for(var/i = SStreasury.log_entries.len to 1 step -1)
				contents += "<span class='info'>[SStreasury.log_entries[i]]</span><BR>"
		if(TAB_STATISTICS)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a><BR>"
			contents += "<center>Statistics:<BR>"
			contents += "Known Economic Output: [SStreasury.economic_output]m<BR>"
			contents += "Total Rural Tax: [SStreasury.total_rural_tax]m<BR>"
			contents += "Total Deposit Tax: [SStreasury.total_deposit_tax]m<BR>"
			contents += "Total Noble Estate Income: [SStreasury.total_noble_income]m<BR>"
			contents += "Total Import: [SStreasury.total_import]m<BR>"
			contents += "Total Export: [SStreasury.total_export]m<BR>"
			contents += "Trade Balance: [SStreasury.total_export - SStreasury.total_import]m<BR>"
			contents  += "</center><BR>"
		if(TAB_PAYDAY)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a><BR>"
			contents += "<center>Daily Payments<BR>"
			contents += "--------------<BR>"
			contents += "Treasury: [SStreasury.treasury_value]m</center><BR>"
			contents += "<a href='?src=\ref[src];setdailypay=1'>\[Add/Modify Job Payment\]</a><BR><BR>"
			if(daily_payments.len)
				contents += "<center>Configured Payments:</center><BR>"
				for(var/job_name in daily_payments)
					var/amt = daily_payments[job_name]
					var/count = 0
					for(var/mob/living/carbon/human/H in GLOB.human_list)
						if(H.job == job_name && !HAS_TRAIT(H, TRAIT_WAGES_SUSPENDED))
							count++
					contents += "<b>[job_name]:</b> [amt]m/day"
					if(count > 0)
						contents += " ([count] employed, [amt * count]m total/day)"
					contents += " <a href='?src=\ref[src];removedailypay=[job_name]'>\[Remove\]</a><BR>"
			else
				contents += "<center>No daily payments configured.</center><BR>"
		if(TAB_SALTMINE)
			var/obj/structure/roguemachine/stockpile_saltcamp/stockpile = null
			stockpile = locate(/obj/structure/roguemachine/stockpile_saltcamp) in GLOB.saltminestockpilemachines // we're assuming there is only ever one of these machines in the world
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a><BR>"
			if(!isnull(stockpile))
				var/gambled_salt = round(stockpile.salt_spent_on_gambling, 1)
				var/total_accounts = length(stockpile.salt_accounts)
				contents += "<center>Die Troyt Salt Mine Report:<BR>"
				contents += "Total Salt Gambled: [gambled_salt] piles of salt</center><BR>"
				if(total_accounts > 0)
					contents += "--------------<BR>"
					contents += "<table><tr><th>Prisoner Name</th><th>Salt Mined</th><th>Interest Rate</th></tr>"
					for(var/i = 1; i <= total_accounts; i++)
						var/name = stockpile.salt_accounts[i]
						var/salt = stockpile.salt_accounts[name]
						var/salt_max = stockpile.salt_accounts_max[name]
						var/interest = stockpile.salt_accounts_interest_max[name] * 100
						if(salt == 0 && stockpile.salt_ticket_win[name] > 0) // don't show ticket winners who have left the mines
							continue
						contents += "<tr><td>[name]</td><td>[salt] salt / [salt_max] max</td><td>[interest]%</td></tr>"
					contents += "</table>"

	if(!canread)
		contents = stars(contents)
	var/datum/browser/popup = new(user, "VENDORTHING", "", 700, 800)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/steward/proc/job_filter(advj, j, compact = FALSE)
	if(advj in excluded_jobs)
		return "Adventurer"
	if(j in excluded_jobs)
		return "Adventurer"
	if(compact && j)
		return j
	else if(!compact && advj && j)
		return "[j] ([advj])"
	else if(j)
		return j
	else if(advj)
		return advj

#undef TAB_MAIN
#undef TAB_BANK
#undef TAB_STOCK
#undef TAB_IMPORT
#undef TAB_DEBT
#undef TAB_LOG
#undef TAB_STATISTICS
#undef TAB_PAYDAY
#undef TAB_SALTMINE

// Item 6 (decrees): bump configured wages up to any active charter's mandated floor, and
// ensure floored jobs missing from the payments list get an entry at the floor.
/obj/structure/roguemachine/steward/proc/enforce_wage_floors()
	for(var/job in daily_payments)
		var/floor = SStreasury.get_wage_floor(job)
		if(floor > 0 && (daily_payments[job] || 0) < floor)
			daily_payments[job] = floor
	for(var/job in SStreasury.enumerate_wage_floored_jobs())
		if(isnull(daily_payments[job]))
			daily_payments[job] = SStreasury.get_wage_floor(job)
