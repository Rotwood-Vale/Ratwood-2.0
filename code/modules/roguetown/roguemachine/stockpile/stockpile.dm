// ES deviations from AP's stockpile.dm:
//  - Handcart branch: AP's handcart tracks contents in contained_items with a remove_from()
//    proc; ES's handcart (code/game/objects/structures/roguetown/handcart.dm) uses stuff_shit
//    instead and has no remove_from() - forceMove() out + manually clearing stuff_shit/
//    current_capacity mirrors what ES's own dump_contents() does (same adaptation as
//    fulfillment_crate.dm).
//  - I.unmintable is declared on /obj/item but never set in ES (AP sets it on mapload for
//    town-area items); the town-property mint guard is therefore inert until that marking is
//    wired up.
/obj/structure/roguemachine/stockpile
	name = "stockpile"
	desc = "A magitech device connected to the trade network. Users can buy basic goods, crafting materials, and food for a price from these units, or sell them here for money."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "stockpile_vendor"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	var/current_category = "Raw Materials"
	var/list/categories = list("Raw Materials", "Refined", "Alchemy", "Fruit", "Vegetable", "Animal", "Seafood", "Precious")
	var/datum/withdraw_tab/withdraw_tab = null

/obj/structure/roguemachine/stockpile/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click with an open hand to check the vomitorium's stockpile. Stored mammons can be used to purchase a wide variety of materials, which're then vended out for use.")
	. += span_info("Left-clicking the machine with an item will load it into the stockpile, rewarding you coinage in turn. Make sure to register an account with the NERVELOCK, first, or you won't receive any coinage.")
	. += span_info("Right-clicking the machine will automatically load all adjacent items into the stockpile at once.")
	. += span_info("The vomitorium's stockpile naturally refills over time. Loaded items are added to the stockpile's quantities, which can then be vended by others or exported by the Steward for profit.")
	. += span_info("The vomitorium can also accept treasures, gemstones, and many other valuables that're particularly expensive; a portion of it is always taxed and returned to the Steward's treasury.")

/obj/structure/roguemachine/stockpile/Initialize(mapload)
	. = ..()
	SSroguemachine.stock_machines += src
	withdraw_tab = new(src)


/obj/structure/roguemachine/stockpile/Destroy()
	SSroguemachine.stock_machines -= src
	return ..()

/obj/structure/roguemachine/stockpile/examine(mob/user)
	. = ..()
	. += span_info("Right click to sell everything in front of the stockpile.")
	if(SStreasury.royal_custom_unlocked)
		. += span_info(SStreasury.royal_custom_active ? "Royal Custom is in force; direct imports pay duty to the Crown." : "Royal Custom is chartered but suspended.")
	else
		var/v = SStreasury.economic_output || 0
		. += span_info("Royal Custom Charter unlocks at [SStreasury.royal_custom_threshold] mammon of stockpile trade ([v] so far).")

/obj/structure/roguemachine/stockpile/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/stockpile/ui_status(mob/user, datum/ui_state/state)
	if(!isliving(user) || user.stat == DEAD)
		return UI_CLOSE
	return ..()

/obj/structure/roguemachine/stockpile/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
	ui_interact(user)

/obj/structure/roguemachine/stockpile/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Stockpile", name)
		ui.open()

/obj/structure/roguemachine/stockpile/ui_data(mob/user)
	check_charter_unlock()
	var/list/data = list()
	data["budget"] = withdraw_tab.budget
	data["compact"] = withdraw_tab.compact ? TRUE : FALSE
	data["categories"] = categories
	data["category"] = withdraw_tab.current_category
	data["food_stipend"] = (ishuman(user) && HAS_TRAIT(user, TRAIT_FOOD_STIPEND)) ? TRUE : FALSE
	var/treasury_balance = SStreasury.discretionary_fund?.balance || 0
	data["treasury_floor"] = SStreasury.stockpile_purchase_floor
	data["below_floor"] = treasury_balance < SStreasury.stockpile_purchase_floor
	data["charter_unlocked"] = SStreasury.royal_custom_unlocked ? TRUE : FALSE
	data["charter_active"] = SStreasury.royal_custom_active ? TRUE : FALSE
	data["charter_margin"] = SStreasury.royal_custom_margin
	data["charter_volume"] = SStreasury.economic_output || 0
	data["charter_threshold"] = SStreasury.royal_custom_threshold
	data["no_deposit"] = FALSE
	data["title"] = ""
	data["subtitle"] = ""

	var/list/rows = list()
	for(var/datum/roguestock/stockpile/R in SStreasury.stockpile_datums)
		R.refresh_auto_price()
		var/list/shortage = R.get_shortage_progress()
		var/export_unit_price = 0
		if(R.importexport_amt > 0)
			export_unit_price = round(R.get_export_price() / R.importexport_amt)
		rows += list(list(
			"ref" = "\ref[R]",
			"name" = R.name,
			"desc" = R.desc,
			"category" = R.category,
			"amount" = R.stockpile_amount,
			"limit" = R.stockpile_limit,
			"withdraw_price" = R.withdraw_price,
			"deposit_price" = R.payout_price,
			"export_price" = export_unit_price,
			"import_price" = withdraw_tab.direct_import_price(R),
			"withdraw_disabled" = R.withdraw_disabled ? TRUE : FALSE,
			"accept_enabled" = R.accept_toggle_enabled ? TRUE : FALSE,
			"event_tag" = R.get_event_label(),
			"shortage_progress" = shortage ? shortage["progress"] : 0,
			"shortage_target" = shortage ? shortage["target"] : 0,
			"shortage_affected" = shortage ? shortage["affected"] : "",
		))
	data["stocks"] = rows

	var/list/bounties = list()
	for(var/datum/roguestock/bounty/B in SStreasury.stockpile_datums)
		bounties += list(list(
			"name" = B.name,
			"payout_price" = B.payout_price,
			"percent" = B.percent_bounty ? TRUE : FALSE,
		))
	data["bounties"] = bounties
	return data

/obj/structure/roguemachine/stockpile/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("withdraw")
			var/datum/roguestock/D = locate(params["ref"]) in SStreasury.stockpile_datums
			if(!D)
				return TRUE
			withdraw_tab.do_withdraw(D, usr)
			return TRUE
		if("set_category")
			var/cat = params["category"]
			if(cat == "__conditions__" || (cat in categories))
				withdraw_tab.current_category = cat
				current_category = cat
			return TRUE
		if("toggle_compact")
			withdraw_tab.compact = !withdraw_tab.compact
			return TRUE
		if("refund_budget")
			if(withdraw_tab.budget > 0)
				budget2change(withdraw_tab.budget, usr)
				withdraw_tab.budget = 0
				playsound(loc, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
			return TRUE
		if("direct_import")
			var/datum/roguestock/D = locate(params["ref"]) in SStreasury.stockpile_datums
			if(!D)
				return TRUE
			withdraw_tab.do_direct_import(D, usr)
			return TRUE

/obj/structure/roguemachine/stockpile/proc/check_charter_unlock()
	if(SStreasury.royal_custom_unlocked)
		return
	var/volume = SStreasury.economic_output || 0
	if(volume < SStreasury.royal_custom_threshold)
		return
	SStreasury.royal_custom_unlocked = TRUE
	SStreasury.royal_custom_active = TRUE
	scom_announce("The Stewardry has tallied [SStreasury.royal_custom_threshold] mammons of trade. By ancient charter, the Crown's Right of Customs in Excess is invoked - duties that once paid for the middleman's cut now flow into the Crown's purse instead. The Steward may set the rate at the Stewardry.")
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H.client || !H.mind)
			continue
		if(H.mind.assigned_role == "Steward")
			send_ooc_note("<b>Royal Custom unlocked.</b> Import surcharges at every stockpile now flow to the Crown's purse. Adjust the margin at your Trading Interface.", name = H.real_name)

/obj/structure/roguemachine/stockpile/proc/try_auto_export_units(datum/roguestock/D, units)
	if(!D || !D.trade_good_id || units <= 0)
		return 0
	if(D.stockpile_amount < units)
		return 0
	var/list/best = SSeconomy.get_best_export_region(D.trade_good_id)
	if(!best || !best["region_id"])
		return 0
	var/datum/economic_region/region = GLOB.economic_regions[best["region_id"]]
	if(!region)
		return 0
	var/remaining = region.demands_today[D.trade_good_id] || 0
	if(remaining < units)
		return 0
	return SSeconomy.manual_export(null, best["region_id"], D.trade_good_id, units)

/obj/structure/roguemachine/stockpile/proc/attemptsell(obj/item/I, mob/H, message = TRUE, sound = TRUE)
	// ES deviation: never treat coinage as sellable treasure - attackby routes held coins to
	// the coin slot, but the bulk-sell turf scans (and cart contents) would mint them away
	if(istype(I, /obj/item/roguecoin))
		return
	if(istype(I, /obj/structure/handcart)) // Handle carts specially - sell their contents, leave the empty cart
		var/obj/structure/handcart/cart = I
		var/turf/cart_location = get_turf(cart)
		var/list/cart_contents = cart.stuff_shit.Copy()
		for(var/atom/movable/cart_content in cart_contents) // Process all items inside the cart first
			if(isitem(cart_content))
				attemptsell(cart_content, H, message, FALSE)

		for(var/atom/movable/remaining_item in cart_contents) // Any items that weren't sold (still exist) go to the ground
			if(!QDELETED(remaining_item))
				remaining_item.forceMove(cart_location)
		// Setting cart back to square 1
		cart.stuff_shit = list()
		cart.current_capacity = 0
		cart.update_icon()
		if(sound == TRUE)
			playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		return

	if(istype(I, /obj/item/roguebin)) // Handle roguebins specially - sell their contents, leave the empty bin
		var/obj/item/roguebin/bin = I
		var/turf/bin_location = get_turf(bin)
		var/datum/component/storage/STR = bin.GetComponent(/datum/component/storage)
		if(STR)
			var/list/bin_contents = STR.contents()
			for(var/obj/item/bin_item in bin_contents) // Process all items inside the bin first
				attemptsell(bin_item, H, message, FALSE)

			for(var/obj/item/remaining_item in bin_contents) // Any items that weren't sold (still exist) go to the ground
				if(!QDELETED(remaining_item))
					STR.remove_from_storage(remaining_item, bin_location)
		if(sound == TRUE)
			playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		return

	// Pre-check: farmer must have a Nervelock account. Otherwise the stockpile would silently
	// eat their goods for no payment - do not scam walk-ins.
	var/has_account = SStreasury.has_account(H)
	if(!has_account)
		if(message)
			say("No account found for [H]. Submit your fingers to a Nervelock for inspection.")
		return

	// Pre-check: Crown's Purse must be solvent enough to pay. Below the Steward-set floor,
	// the Crown refuses purchases entirely - goods stay in the farmer's hands.
	var/treasury_balance = SStreasury.discretionary_fund?.balance || 0
	var/below_floor = treasury_balance < SStreasury.stockpile_purchase_floor

	for(var/datum/roguestock/R in SStreasury.stockpile_datums)
		if(istype(I, /obj/item/natural/bundle))
			var/obj/item/natural/bundle/B = I
			if(B.stacktype == R.item_type)
				if(!R.accept_toggle_enabled)
					if(message)
						say("The Crown has no interest in [R.name] at this time.")
					return
				if(below_floor && !R.mint_item)
					if(message)
						say("The Crown's ledger is thin. No purchases today.")
					return
				var/bundle_amt = B.amount
				var/full_on_arrival = (R.stockpile_amount >= R.stockpile_limit)
				R.stockpile_amount += bundle_amt
				var/auto_exported = FALSE
				if(full_on_arrival)
					if(try_auto_export_units(R, bundle_amt) <= 0)
						R.stockpile_amount -= bundle_amt
						if(message)
							say("The Crown's [R.name] stockpile is full and region demands can absorb your load. Try smaller bundles or take it elsewhere.")
						return
					auto_exported = TRUE
				SStreasury.dirty_market_view()
				if(message == TRUE)
					stock_announce("[bundle_amt] units of [R.name] has been stockpiled.")
				qdel(B)
				if(sound == TRUE)
					playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
				R.refresh_auto_price()
				var/amt = R.payout_price * bundle_amt
				SStreasury.economic_output += amt
				// Ratwood per-category deposit tax: the Crown pays out the post-tax amount
				var/tax_rate = SStreasury.get_tax_value_for(H)
				var/taxed = round(amt * tax_rate)
				amt -= taxed
				SStreasury.give_money_account(amt, H, "+[amt] from [R.name] bounty. [taxed]m taxed")
				if(auto_exported && message)
					say("Crown's [R.name] stockpile is full - shipped regionally on your behalf.")
				record_round_statistic(STATS_STOCKPILE_EXPANSES, amt)
				return
			continue
		// Bloc to replace old vault mechanics
		else if(istype(I,R.item_type))
			if(!R.check_item(I))
				continue
			if(R.mint_item && I.unmintable)
				if(message)
					say("This is town property, it cannot be minted here.")
				return
			if(R.mint_item && I.atc_sealed)
				if(message)
					say("This bears an Azurian Trading Company seal. The Crown will not mint Company stock.")
				return
			// Steward-controlled accept toggle: refuses with a message; the item stays in hand.
			// (The old mint_eligible fall-through to the retired /bounty/treasure catch-all is gone,
			//  so gems the Steward has toggled off now bounce back like any other refused good. Gem
			//  OVERFLOW minting below is unaffected - it uses the trade-good mint path directly.)
			if(!R.accept_toggle_enabled)
				if(message)
					say("The Crown has no interest in [R.name] at this time.")
				return
			// Treasure / mint items bypass the purchase floor - they generate mammon rather than spending it.
			if(below_floor && !R.mint_item)
				if(message)
					say("The Crown's ledger is thin. No purchases today.")
				return
			// Trade-good overflow mint branch. If this entry is linked to a mint_eligible
			// trade good (gems) and the stockpile is at limit, overflow mints to Crown's Purse
			// using the existing treasure-mint path. Takes precedence over no-pay overflow.
			if(R.trade_good_id && !R.mint_item && R.stockpile_amount >= R.stockpile_limit)
				var/datum/trade_good/tg_overflow = GLOB.trade_goods[R.trade_good_id]
				if(tg_overflow && tg_overflow.mint_eligible)
					var/mint_amt = round(tg_overflow.base_price * SStreasury.mint_multiplier)
					SStreasury.minted += mint_amt
					SStreasury.mint(SStreasury.discretionary_fund, mint_amt, "Gem overflow mint: [tg_overflow.name]")
					record_round_statistic(STATS_MINTED_TREASURE_GROSS, mint_amt)
					qdel(I)
					if(sound == TRUE)
						playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
						playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
					say("[tg_overflow.name] overflow - minted to Crown's Purse.")
					return
			var/auto_exported = FALSE
			var/full_on_arrival = (!R.mint_item && R.stockpile_amount >= R.stockpile_limit)
			if(full_on_arrival)
				R.stockpile_amount += 1
				if(try_auto_export_units(R, 1) <= 0)
					R.stockpile_amount -= 1
					if(message)
						say("The Crown's [R.name] stockpile is full and no region demands can absorb your load. Try smaller bundles or take it elsewhere.")
					return
				auto_exported = TRUE
			R.refresh_auto_price()
			var/list/settlement = R.get_quality_settlement(I)
			var/amt = settlement["seller_payout"]
			var/crown_delta = settlement["crown_delta"]
			var/quality_baseline = settlement["baseline"]
			var/true_value = I.get_real_price()
			var/mint_amt = 0
			if(message && I.has_item_quality && I.item_quality != ITEM_QUALITY_STANDARD)
				var/flavor = quality_delta_flavor(I.item_quality)
				if(flavor)
					say(flavor)
					to_chat(H, span_info("[src] says, \"[flavor]\""))
			if(crown_delta > 0)
				SStreasury.mint(SStreasury.discretionary_fund, crown_delta, "Quality premium: [I.name] (+[crown_delta]m)")
			else if(crown_delta < 0)
				SStreasury.burn(SStreasury.discretionary_fund, -crown_delta, "Quality penalty: [I.name] ([crown_delta]m)")
			if(!R.mint_item)
				// ES deviation: AP double-increments here (+2 per item); the full_on_arrival
				// path already added its unit before the auto-export attempt above
				if(!full_on_arrival)
					R.stockpile_amount += 1
				SStreasury.dirty_market_view()
				qdel(I)
				if(message == TRUE)
					stock_announce("[R.name] has been stockpiled.")
				if(sound == TRUE)
					playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
			else
				var/pool = round(SStreasury.mint_multiplier * true_value)
				mint_amt = max(0, pool - amt)
				if(pool > 0)
					SStreasury.minted += pool
					SStreasury.mint(SStreasury.discretionary_fund, pool, "Minting - [I.name]")
				record_round_statistic(STATS_MINTED_TREASURE_GROSS, pool)
				record_round_statistic(STATS_MINTED_TREASURE_NET, mint_amt)
				qdel(I)
				if(sound == TRUE)
					playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
					playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
			if(amt)
				SStreasury.economic_output += true_value
				var/bounty_msg = "+[amt] from [R.name] bounty"
				if(R.mint_item)
					bounty_msg = "+[amt] from [R.name] bounty (Crown's share: +[mint_amt]m)"
				if(crown_delta != 0)
					var/seller_delta = amt - quality_baseline
					var/seller_sign = seller_delta > 0 ? "+" : ""
					var/crown_sign = crown_delta > 0 ? "+" : ""
					bounty_msg = "+[amt] from [R.name] bounty (quality: you [seller_sign][seller_delta]m, Crown [crown_sign][crown_delta]m vs. [quality_baseline]m baseline)"
				SStreasury.give_money_account(amt, H, bounty_msg)
				if(auto_exported && message)
					say("Crown's [R.name] stockpile is full - shipped regionally on your behalf.")
			record_round_statistic(STATS_STOCKPILE_EXPANSES, amt)
			record_round_statistic(STATS_STOCKPILE_REVENUE, true_value)
			return

	// Nothing in the stockpile accepted this item
	if(message)
		say("[I.name] is not accepted here.")

/obj/structure/roguemachine/stockpile/attackby(obj/item/P, mob/user, params)
	if(ishuman(user))
		if(istype(P, /obj/item/roguecoin/gilbranze))
			return

	if(istype(P, /obj/item/roguecoin/inqcoin))
		return

	if(istype(P, /obj/item/roguecoin))
		withdraw_tab.insert_coins(P)
		return attack_hand(user)
	else if (ishuman(user))
		attemptsell(P, user, TRUE, TRUE)

// ES deviation: dragging a handcart onto the machine sells its contents - without this
// (and the user-tile scan below) nothing ever routes a cart into attemptsell()'s cart branch
/obj/structure/roguemachine/stockpile/MouseDrop_T(atom/dropped, mob/living/user)
	if(!ishuman(user))
		return ..()
	if(!istype(dropped, /obj/structure/handcart))
		return ..()
	if(!user.Adjacent(src) || !user.Adjacent(dropped))
		return
	attemptsell(dropped, user, TRUE, TRUE)

/obj/structure/roguemachine/stockpile/attack_right(mob/user)
	if(ishuman(user))
		// ES deviation: AP only scans the machine's own tile; scan the user's tile too so
		// a cart (or goods) parked underfoot sells without shoving it onto the machine
		var/list/scan_turfs = list(get_turf(src))
		var/turf/user_turf = get_turf(user)
		if(!(user_turf in scan_turfs))
			scan_turfs += user_turf
		for(var/turf/T as anything in scan_turfs)
			for(var/obj/I in T)
				attemptsell(I, user, FALSE, FALSE)
		say("Bulk selling in progress...")
		playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
