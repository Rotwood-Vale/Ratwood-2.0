/datum/withdraw_tab
	var/budget = 0
	var/compact = TRUE
	var/current_category = "Raw Materials"
	var/list/categories = list("Raw Materials", "Refined", "Alchemy", "Fruit", "Vegetable", "Animal", "Seafood")
	var/obj/structure/roguemachine/parent_structure = null

/datum/withdraw_tab/New(obj/structure/roguemachine/structure_param)
	. = ..()
	parent_structure = structure_param

<<<<<<< HEAD
=======
/datum/withdraw_tab/Destroy(force, ...)
	parent_structure = null
	return ..()

/datum/withdraw_tab/proc/get_contents(title, show_back)
	var/contents = "<center>[title]<BR>"
	if(show_back)
		contents += "<a href='?src=[REF(parent_structure)];navigate=directory'>(back)</a><BR>"

	contents += "--------------<BR>"
	contents += "<a href='?src=[REF(parent_structure)];change=1'>Stored Mammon: [budget]</a><BR>"
	contents += "<a href='?src=[REF(parent_structure)];compact=1'>Compact Mode: [compact ? "ENABLED" : "DISABLED"]</a></center><BR>"
	var/mob/living/user = usr
	if (user && HAS_TRAIT(user, TRAIT_FOOD_STIPEND))
		contents += "<center><b>TREASURY-LINE ACTIVE.</b></center><BR>"
	var/selection = "Categories: "
	for(var/category in categories)
		if(category == current_category)
			selection += "<b>[current_category]</b> "
		else
			selection += "<a href='?src=[REF(parent_structure)];changecat=[category]'>[category]</a> "
	contents += selection + "<BR>"
	contents += "--------------<BR>"

	if(compact)
		for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
			if(A.category != current_category)
				continue
			var/remote_stockpile = stockpile_index == 1 ? 2 : 1
			if(!A.withdraw_disabled)
				contents += "<b>[A.name] (Max: [A.stockpile_limit]):</b> <a href='?src=[REF(parent_structure)];withdraw=[REF(A)]'>LCL: [A.held_items[stockpile_index]] at [A.withdraw_price]m</a> /"
				contents += "<a href='?src=[REF(parent_structure)];withdraw=[REF(A)];remote=1'>RMT: [A.held_items[remote_stockpile]] at [A.withdraw_price+A.transport_fee]m</a><BR>"

			else
				contents += "<b>[A.name]:</b> Withdrawing Disabled..."

	else
		for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
			if(A.category != current_category)
				continue
			contents += "[A.name]<BR>"
			contents += "[A.desc]<BR>"
			contents += "Stockpiled Amount (Local): [A.held_items[stockpile_index]]<BR>"
			var/remote_stockpile = stockpile_index == 1 ? 2 : 1
			contents += "Stockpiled Amount (Remote): [A.held_items[remote_stockpile]]<BR>"
			if(!A.withdraw_disabled)
				contents += "<a href='?src=[REF(parent_structure)];withdraw=[REF(A)]'>\[Withdraw Local ([A.withdraw_price])\] </a>"
				contents += "<a href='?src=[REF(parent_structure)];withdraw=[REF(A)];remote=1'>\[Withdraw Remote ([A.withdraw_price+A.transport_fee])\]</a><BR><BR>"
			else
				contents += "Withdrawing Disabled...<BR><BR>"

	return contents

/datum/withdraw_tab/proc/perform_action(href, href_list)
	if(href_list["withdraw"])
		var/datum/roguestock/D = locate(href_list["withdraw"]) in SStreasury.stockpile_datums

		var/remote = href_list["remote"]
		var/source_stockpile = stockpile_index
		var/total_price = D.withdraw_price
		if (remote)
			total_price += D.transport_fee
			source_stockpile = stockpile_index == 1 ? 2 : 1

		if(!D)
			return FALSE
		if(D.withdraw_disabled)
			return FALSE
		if(D.held_items[source_stockpile] <= 0)
			parent_structure.say("Insufficient stock.")
		else if(total_price > budget)
			var/mob/living/user = usr
			if (user && HAS_TRAIT(user, TRAIT_FOOD_STIPEND))
				if (SStreasury.treasury_value >= total_price)
					D.held_items[source_stockpile]--
					SStreasury.log_to_steward("-[D.withdraw_price]m worth of goods withdrawn direct from vomitorium (keep stipend)")
					var/obj/item/I = new D.item_type(parent_structure.loc)
					I.from_stockpile = TRUE
					to_chat(user, span_info("[parent_structure] chitters and squeaks into the treasury ratlines."))
					if(!user.put_in_hands(I))
						I.forceMove(get_turf(user))
					playsound(parent_structure.loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
				else
					parent_structure.say("The treasury is barren. Please insert coinage.")
			else
				parent_structure.say("Insufficient mammon.")
		else
			D.held_items[source_stockpile]--
			budget -= total_price
			SStreasury.economic_output -= D.export_price // Prevent GDP double counting
			SStreasury.give_money_treasury(D.withdraw_price, "stockpile withdraw")
			record_round_statistic(STATS_STOCKPILE_REVENUE, D.withdraw_price)
			var/obj/item/I = new D.item_type(parent_structure.loc)
			I.from_stockpile = TRUE
			var/mob/user = usr
			if(!user.put_in_hands(I))
				I.forceMove(get_turf(user))
			playsound(parent_structure.loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		return TRUE
	if(href_list["compact"])
		if(!usr.canUseTopic(parent_structure, BE_CLOSE))
			return FALSE
		if(ishuman(usr))
			compact = !compact
		return TRUE
	if(href_list["change"])
		if(!usr.canUseTopic(parent_structure, BE_CLOSE))
			return FALSE
		if(ishuman(usr))
			if(budget > 0)
				parent_structure.budget2change(budget, usr)
				budget = 0
	if(href_list["changecat"])
		if(!usr.canUseTopic(parent_structure, BE_CLOSE))
			return FALSE
		current_category = href_list["changecat"]
		return TRUE

>>>>>>> upstream/main
/datum/withdraw_tab/proc/insert_coins(obj/item/roguecoin/C)
	budget += C.get_real_price()
	qdel(C)
	parent_structure.update_icon()
	playsound(parent_structure.loc, 'sound/misc/coininsert.ogg', 100, TRUE, -1)

/datum/withdraw_tab/proc/get_direct_import_quote(datum/roguestock/D)
	if(!D || !D.trade_good_id)
		return null
	var/list/best = SSeconomy.get_best_import_region(D.trade_good_id)
	if(!best || !best["region_id"])
		return null
	var/datum/economic_region/region = GLOB.economic_regions[best["region_id"]]
	if(!region)
		return null
	var/daily_pace = region.produces[D.trade_good_id] || 0
	var/produces_today = region.produces_today[D.trade_good_id] || 0
	if(daily_pace <= 0 || produces_today <= 0)
		return null
	var/starting_index = max(0, daily_pace - produces_today)
	var/unit_cost = SSeconomy.compute_import_unit_price(D.trade_good_id, region, starting_index + 1)
	var/margin = (SStreasury.royal_custom_active && SStreasury.royal_custom_unlocked) ? SStreasury.royal_custom_margin : ROYAL_CUSTOM_DEFAULT_MARGIN
	var/price = max(1, round(unit_cost * (100 + margin) / 100))
	return list("region" = region, "unit_cost" = unit_cost, "price" = price)

/datum/withdraw_tab/proc/direct_import_price(datum/roguestock/D)
	var/list/quote = get_direct_import_quote(D)
	return quote ? quote["price"] : 0

/datum/withdraw_tab/proc/do_withdraw(datum/roguestock/D, mob/user)
	if(!D || !parent_structure)
		return FALSE
	if(get_dist(parent_structure, user) > 1)
		return FALSE
	D.refresh_auto_price()
	var/total_price = D.withdraw_price
	if(D.withdraw_disabled && !has_fiscal_authority(user))
		parent_structure.say("Not available.")
		return FALSE
	if(D.stockpile_amount <= 0)
		parent_structure.say("Insufficient stock.")
		return FALSE
	var/food_stipend = ishuman(user) && HAS_TRAIT(user, TRAIT_ROYAL_SUBSIDY)
	if(!food_stipend && total_price > budget)
		parent_structure.say("Insufficient mammon.")
		return FALSE
	D.stockpile_amount--
	SStreasury.dirty_market_view()
	if(!food_stipend)
		budget -= total_price
		SStreasury.mint(SStreasury.discretionary_fund, total_price, "Stockpile Withdraw")
		record_round_statistic(STATS_STOCKPILE_REVENUE, total_price)
	else
		var/actor_suffix = user ? " by [user.real_name]" : ""
		SStreasury.log_fund_entry(new /datum/treasury_entry(null, SStreasury.discretionary_fund, SStreasury.discretionary_fund, 0, "Subsidy Withdraw: [D.name][actor_suffix]"))
	var/obj/item/I = new D.item_type(parent_structure.loc)
	if(food_stipend)
		to_chat(user, span_info("[parent_structure] chitters and squeaks into the treasury ratlines."))
	if(!user.put_in_hands(I))
		I.forceMove(get_turf(user))
	playsound(parent_structure.loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	return TRUE

/datum/withdraw_tab/proc/do_direct_import(datum/roguestock/D, mob/user)
	if(!D || !ishuman(user) || !parent_structure)
		return FALSE
	if(D.withdraw_disabled && !has_fiscal_authority(user))
		parent_structure.say("Not available.")
		return FALSE
	if(!D.trade_good_id)
		parent_structure.say("Not available.")
		return FALSE
	var/list/quote = get_direct_import_quote(D)
	if(!quote)
		parent_structure.say("No region currently supplies [D.name].")
		return FALSE
	var/datum/economic_region/region = quote["region"]
	var/unit_cost = quote["unit_cost"]
	var/price = quote["price"]
	var/surcharge = max(0, price - unit_cost)
	var/food_stipend = HAS_TRAIT(user, TRAIT_ROYAL_SUBSIDY)
	var/using_stipend = food_stipend && price > budget
	if(using_stipend)
		if(SStreasury.discretionary_fund.balance < unit_cost)
			parent_structure.say("The Crown's Purse cannot front the import cost.")
			return FALSE
	else
		if(price > budget)
			parent_structure.say("Insufficient mammon in the coinpouch.")
			return FALSE
		if(SStreasury.discretionary_fund.balance < unit_cost)
			parent_structure.say("The Crown's Purse cannot front the import cost.")
			return FALSE
	var/spent = SSeconomy.manual_import(user, region.region_id, D.trade_good_id, 1, using_stipend)
	if(!spent)
		return FALSE
	if(!using_stipend)
		budget -= price
	D.stockpile_amount = max(0, D.stockpile_amount - 1)
	SStreasury.dirty_market_view()
	var/chartered = SStreasury.royal_custom_active && SStreasury.royal_custom_unlocked
	if(!using_stipend)
		SStreasury.mint(SStreasury.discretionary_fund, unit_cost, "Direct import reimbursement: [D.name] from [region.name]")
	record_round_statistic(STATS_STOCKPILE_DIRECT_IMPORTS, price)
	record_material_flow(MATERIAL_FLOW_IN, MATERIAL_SOURCE_LOCAL_IMPORT, D.item_type, 1, price)
	if(!using_stipend && chartered && surcharge > 0)
		SStreasury.mint(SStreasury.discretionary_fund, surcharge, "Royal Custom: direct import of [D.name]")
		record_round_statistic(STATS_STOCKPILE_REVENUE, surcharge)
	var/obj/item/I = new D.item_type(parent_structure.loc)
	if(!user.put_in_hands(I))
		I.forceMove(get_turf(user))
	playsound(parent_structure.loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	if(using_stipend)
		var/waived = max(0, surcharge)
		to_chat(user, span_info("[parent_structure] chitters and squeaks into the treasury ratlines."))
		if(waived > 0)
			to_chat(user, span_notice("[D.name] imported from [region.name] for [unit_cost]m ([waived]m waived by the Crown's private transportation lines)."))
		else
			to_chat(user, span_notice("[D.name] imported from [region.name] for [unit_cost]m."))
	else
		var/flavor = chartered ? "Royal Custom duty paid to the Crown." : "Import surcharge consumed by transport."
		to_chat(user, span_notice("[D.name] imported from [region.name] for [price]m. [flavor]"))
	return TRUE


/proc/stock_announce(message)
	for(var/obj/structure/roguemachine/stockpile/S in SSroguemachine.stock_machines)
		S.say(message, spans = list("info"))
