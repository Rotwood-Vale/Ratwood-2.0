#define EXPORT_TIME 1 MINUTES
#define EXPORT_TIME_TESTING 5 SECONDS

/obj/item/roguemachine/navigator
	name = "navigator"
	desc = "A machine that attracts the attention of trading balloons."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "ballooner"
	density = TRUE
	blade_dulling = DULLING_BASH
	var/next_airlift
	max_integrity = 0
	anchored = TRUE
	w_class = WEIGHT_CLASS_GIGANTIC
	/// A fixed handler's fee lost to the void before any Crown duty. Used for blackmarket
	var/fixed_tax = 0
	var/grants_passive_favor = TRUE
	var/accepts_unmintable = FALSE
	var/pay_taxes = TRUE
	var/pay_merchant_share = TRUE
	var/list/profit_id = list("Merchant", "Shophand")
	var/duty_collected_here = 0
	var/duty_evaded_here = 0
	var/levy_collected_here = 0
	var/is_bm_export = FALSE
	/// Motto displayed at the top of the vendor interface
	var/motto = "NAVIGATOR - Your goods, airborne."
	/// Throttle for player-initiated market refresh actions; 5 seconds between refreshes per machine.
	var/last_market_refresh = 0

/obj/item/roguemachine/navigator/examine()
	. = ..()
	var/export_time = EXPORT_TIME
	#ifdef LOCALTEST
	export_time = EXPORT_TIME_TESTING
	#endif
	. += span_notice("This machine attracts trading balloons every [DisplayTimeText(export_time)]. Goods are sucked into the air and mammons are dropped after tax has been collected.")

/obj/item/roguemachine/navigator/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Drop items on the tiles around the navigator. Trading balloons arrive periodically and lift the goods away, leaving mammon in change on this tile.")
	if(fixed_tax > 0)
		. += span_info("This navigator charges a fixed handler's fee of [fixed_tax * 100]% before any Crown duty. Smuggler-grade.")
	else
		. += span_info("The Crown's export duty is applied to the payout at the prevailing rate.")
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.job in profit_id)
			. += span_info("Crown duty: <b>[pay_taxes ? "PAYING" : "DODGING"]</b>. Merchant's levy: <b>[pay_merchant_share ? "COLLECTING" : "WAIVED"]</b>.")

// Note: this is AP's navigator/smuggler under the path our maps already place.
/obj/item/roguemachine/navigator/blackmarket
	name = "suspicious navigator"
	desc = "Freedom has a price."
	motto = "NA?!G@#OR - ████ ██████ █████████ - FREEDOM OF TRANSACTION."
	fixed_tax = 0.5 // 50% taxation and rip off to encourage people to risk it with merchant / others
	// Smuggler-grade: dodges the Crown's export duty (recorded as evaded), pays no Guild levy,
	// earns the Company no favor, and takes unmintable goods.
	pay_taxes = FALSE
	pay_merchant_share = FALSE
	grants_passive_favor = FALSE
	accepts_unmintable = TRUE
	is_bm_export = TRUE

/obj/item/roguemachine/navigator/private
	name = "private navigator"
	desc = "A navigator kept under the Merchant's own roof."
	motto = "NAVIGATOR - Proprietor's berth."
	pay_taxes = TRUE
	pay_merchant_share = FALSE

/obj/item/roguemachine/navigator/blackmarket/examine(mob/user)
	. = ..()
	. += span_notice("The rates here are disastrous. Having a facilitator from the bathhouse nearby might improve them to 100%.")
	. += span_notice("The handler asks no questions about provenance. Goods the legitimate market refuses to mint move through here all the same.")
	if(fixed_tax <= 0)
		. += span_notice("A facilitator is present. Current handler's fee: [fixed_tax * 100]%.")
	else
		. += span_warning("No facilitator present. Current handler's fee: [fixed_tax * 100]%.")

/obj/item/roguemachine/navigator/blackmarket/process()
	if(!anchored)
		return TRUE
	if(world.time > next_airlift)
		var/bath_nearby = FALSE
		for(var/mob/living/carbon/human/H in range(7, src))
			var/is_bath_person = (H.job in GLOB.bathhouse_positions) || HAS_TRAIT(H, TRAIT_AGENT_BATHHOUSE)
			if(H.stat != DEAD && is_bath_person)
				bath_nearby = TRUE
				break
		fixed_tax = bath_nearby ? 0.0 : 0.5
	return ..()

// The blackmarket runs on its own saturation pools so smuggling and the honest market
// deplete separately.
/obj/item/roguemachine/navigator/blackmarket/get_market_saturation(category)
	if(!SSmerchant_trade || !category)
		return 1
	return SSmerchant_trade.get_bm_saturation_factor(category)

/obj/item/roguemachine/navigator/blackmarket/get_market_demand(category)
	if(!SSmerchant_trade || !category)
		return 1
	return SSmerchant_trade.get_bm_demand_multiplier(category)

/obj/item/roguemachine/navigator/blackmarket/credit_pool(category, base_price)
	if(!SSmerchant_trade || !category || base_price <= 0)
		return
	SSmerchant_trade.bm_pool_consumed[category] = (SSmerchant_trade.bm_pool_consumed[category] || 0) + base_price
	SSmerchant_trade.lifetime_bm_pool_credited[category] = (SSmerchant_trade.lifetime_bm_pool_credited[category] || 0) + base_price

/obj/item/roguemachine/navigator/blackmarket/ui_static_data(mob/user)
	var/list/data = ..()
	data["is_smuggler"] = TRUE
	data["duty_rate"] = 0
	data["pay_taxes"] = FALSE
	data["duty_collected_here"] = 0
	data["duty_evaded_here"] = 0
	data["facilitator_present"] = (fixed_tax <= 0)
	return data

/obj/item/roguemachine/navigator/blackmarket/build_navigator_market_data()
	var/list/data = list(
		"categories" = list(),
		"pop_snapshot" = 0,
		"category_count" = 0,
	)
	if(!SSmerchant_trade)
		return data
	data["pop_snapshot"] = SSmerchant_trade.pool_pop_snapshot
	var/list/rows = list()
	for(var/cat in SSmerchant_trade.bm_pool_capacity)
		var/cap = SSmerchant_trade.bm_pool_capacity[cat] || 0
		var/consumed = SSmerchant_trade.bm_pool_consumed[cat] || 0
		var/fill_ratio = cap > 0 ? min(1, consumed / cap) : 0
		var/refused = SSmerchant_trade.get_bm_saturation_factor(cat) <= 0
		rows += list(list(
			"category" = cat,
			"capacity" = cap,
			"consumed" = consumed,
			"fill_ratio" = fill_ratio,
			"refused" = refused,
			"demand_mult" = 1.0,
		))
	data["categories"] = rows
	data["category_count"] = length(rows)
	data["all_buckets"] = all_navigator_buckets()
	return data

/obj/structure/roguemachine/balloon_pad
	name = ""
	desc = ""
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = ""
	density = FALSE
	layer = BELOW_OBJ_LAYER
	anchored = TRUE

/obj/item/roguemachine/navigator/attack_hand(mob/living/user)
	if(!anchored)
		return ..()
	user.changeNext_move(CLICK_CD_INTENTCAP)
	ui_interact(user)

/obj/item/roguemachine/navigator/attack_right(mob/user)
	if(!anchored)
		return ..()
	ui_interact(user)

/obj/item/roguemachine/navigator/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/item/roguemachine/navigator/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Navigator")
		ui.open()

/obj/item/roguemachine/navigator/ui_data(mob/user)
	return build_navigator_data(user)

/obj/item/roguemachine/navigator/ui_static_data(mob/user)
	var/list/data = list()
	data["motto"] = motto
	data["handler_fee_percent"] = round(fixed_tax * 100)
	data["duty_rate"] = SStreasury ? SStreasury.get_tax_rate(TAX_CATEGORY_EXPORT_DUTY) : 0
	data["pay_taxes"] = pay_taxes
	data["levy_rate"] = SSmerchant_trade ? SSmerchant_trade.merchant_levy_percent : 0
	data["pay_merchant_share"] = pay_merchant_share
	data["duty_collected_here"] = duty_collected_here
	data["duty_evaded_here"] = duty_evaded_here
	data["levy_collected_here"] = levy_collected_here
	data["is_smuggler"] = FALSE
	data["facilitator_present"] = FALSE
	data["market_data"] = build_navigator_market_data()
	return data

/obj/item/roguemachine/navigator/proc/build_navigator_data(mob/user)
	var/list/data = list()
	var/remaining = max(0, next_airlift - world.time)
	data["next_airlift_seconds"] = round(remaining / 10)
	var/is_prop = FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		is_prop = (H.job in profit_id)
	data["is_proprietor"] = is_prop
	data["is_readable"] = user ? user.can_read(src, TRUE) : TRUE
	return data

/obj/item/roguemachine/navigator/proc/build_navigator_market_data()
	var/list/data = list(
		"categories" = list(),
		"pop_snapshot" = 0,
		"category_count" = 0,
	)
	if(!SSmerchant_trade)
		return data
	data["pop_snapshot"] = SSmerchant_trade.pool_pop_snapshot
	var/list/rows = list()
	for(var/cat in SSmerchant_trade.pool_capacity)
		var/cap = SSmerchant_trade.pool_capacity[cat] || 0
		var/consumed = SSmerchant_trade.pool_consumed[cat] || 0
		var/fill_ratio = cap > 0 ? min(1, consumed / cap) : 0
		var/refused = SSmerchant_trade.get_saturation_factor(cat) <= 0
		var/demand_mult = SSmerchant_trade.get_demand_multiplier(cat)
		var/pending = SSmerchant_trade.pending_ship_demand[cat] || 0
		rows += list(list(
			"category" = cat,
			"capacity" = cap,
			"consumed" = consumed,
			"fill_ratio" = fill_ratio,
			"refused" = refused,
			"demand_mult" = demand_mult,
			"pending_ship_demand" = pending,
		))
	data["categories"] = rows
	data["category_count"] = length(rows)
	data["theme_dispatch"] = build_market_theme_dispatch(SSmerchant_trade.pool_theme_jitters)
	data["realm_demand_matrix"] = SSmerchant_trade.build_realm_demand_matrix()
	data["all_buckets"] = all_navigator_buckets()
	return data
/obj/item/roguemachine/navigator/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = usr
	if(!istype(H))
		return TRUE
	if(!H.canUseTopic(src, BE_CLOSE))
		return TRUE
	if(action == "refresh_market")
		if(world.time < last_market_refresh + 5 SECONDS)
			to_chat(H, span_warning("The factors haven't tallied fresh numbers yet. Wait a moment."))
			return TRUE
		last_market_refresh = world.time
		update_static_data(H)
		return TRUE
	if(action == "help")
		open_economy_guidebook(usr, "Merchant", /datum/book_entry/treasury_merchant)
		return TRUE
	if(!(H.job in profit_id))
		to_chat(H, span_warning("Only a Merchant may tamper with the Navigator's toll."))
		return TRUE
	switch(action)
		if("toggle_duty")
			pay_taxes = !pay_taxes
			to_chat(H, span_notice("The Navigator's toll clasp clicks. Crown duty: <b>[pay_taxes ? "PAYING" : "DODGING"]</b>."))
			playsound(loc, 'sound/misc/gold_misc.ogg', 80, FALSE, -1)
			update_static_data_for_all_viewers()
			return TRUE
		if("toggle_levy")
			pay_merchant_share = !pay_merchant_share
			to_chat(H, span_notice("The Navigator's toll clasp clicks. Merchant's levy: <b>[pay_merchant_share ? "COLLECTING" : "WAIVED"]</b>."))
			playsound(loc, 'sound/misc/gold_misc.ogg', 80, FALSE, -1)
			update_static_data_for_all_viewers()
			return TRUE

/obj/item/roguemachine/navigator/update_icon()
	if(!anchored)
		w_class = WEIGHT_CLASS_BULKY
		set_light(0)
		return
	w_class = WEIGHT_CLASS_GIGANTIC
	set_light(2, 2, 2, l_color = "#1b7bf1")

/obj/item/roguemachine/navigator/Initialize(mapload)
	. = ..()
	if(anchored)
		START_PROCESSING(SSroguemachine, src)
	update_icon()
	if(SSmerchant_trade)
		SSmerchant_trade.register_market_watcher(src)
	for(var/X in GLOB.alldirs)
		var/T = get_step(src, X)
		if(!T)
			continue
		new /obj/structure/roguemachine/balloon_pad(T)

/obj/item/roguemachine/navigator/Destroy()
	STOP_PROCESSING(SSroguemachine, src)
	if(SSmerchant_trade)
		SSmerchant_trade.unregister_market_watcher(src)
	set_light(0)
	return ..()

/obj/item/roguemachine/navigator/process()
	if(!anchored)
		return TRUE
	var/export_time = EXPORT_TIME
	#ifdef LOCALTEST
		export_time = EXPORT_TIME_TESTING
	#endif
	if(world.time > next_airlift)
		next_airlift = world.time + export_time
		var/play_sound = FALSE
		var/refused_announced = FALSE
		var/quality_announced = FALSE
		var/list/penalty_categories = list()
		var/list/boost_categories = list()
		for(var/D in GLOB.alldirs)
			var/budgie = 0
			var/turf/T = get_step(src, D)
			if(!T)
				continue
			var/obj/structure/roguemachine/balloon_pad/E = locate() in T
			if(!E)
				continue
			for(var/obj/I in T)
				if(I.anchored || !isturf(I.loc) || istype(I, /obj/item/roguecoin)|| istype(I, /obj/structure/handcart))
					continue
				if(isitem(I))
					var/obj/item/IT = I
					if(IT.is_important)
						continue
					if(IT.atc_sealed)
						continue
					if(IT.unmintable && !accepts_unmintable)
						continue
				var/base_price = I.get_real_price()
				var/category = (GLOB.derived_categories && GLOB.derived_categories[I.type]) || ITEM_CAT_MISCELLANEOUS
				var/bucket = get_navigator_bucket_for_item(I, category)
				if(bucket == NAVIGATOR_BUCKET_MISCELLANEOUS)
					if(GLOB.bulk_trade_item_types && GLOB.bulk_trade_item_types[I.type])
						if(!refused_announced)
							refused_announced = TRUE
							I.visible_message(span_warning("The balloon refuses [I] - bulk goods belong in the ship hold, not the navigator."))
						continue
					log_admin("[src] (navigator) exported [I] ([I.type]) categorized as Miscellaneous at [AREACOORD(src)] for [base_price] base price.")
				var/refusal_msg = get_navigator_refusal_message(bucket)
				if(refusal_msg)
					if(!refused_announced)
						refused_announced = TRUE
						I.visible_message(span_warning(refusal_msg))
					continue
				var/saturation_mult = get_market_saturation(bucket)
				var/demand_mult = get_market_demand(bucket)
				var/prize = round(base_price * saturation_mult * demand_mult * (1 - fixed_tax))
				if(prize >= 1)
					play_sound=TRUE
					budgie += prize
					credit_pool(bucket, base_price)
					I.visible_message(span_warning("[I] is sucked into the air!"))
					if(bucket)
						if(saturation_mult < 0.6 && !(bucket in penalty_categories))
							penalty_categories += bucket
						if(demand_mult > 1.15 && !(bucket in boost_categories))
							boost_categories += bucket
					if(!quality_announced && isitem(I))
						var/obj/item/QI = I
						if(QI.has_item_quality && QI.item_quality != ITEM_QUALITY_STANDARD)
							var/jab = navigator_quality_jab(QI.item_quality)
							if(jab)
								quality_announced = TRUE
								visible_message(span_info("[src] says, \"[jab]\""))
					qdel(I)
				else if(base_price > 0)
					if(!refused_announced)
						refused_announced = TRUE
						I.visible_message(span_warning("[I] is refused by the balloon - the market is choked."))
			budgie = round(budgie)
			record_round_statistic(is_bm_export ? STATS_TRADE_VALUE_EXPORTED_BM : STATS_TRADE_VALUE_EXPORTED, budgie)
			if(budgie > 0)
				play_sound = TRUE
				settle_export(budgie, E)
		if(play_sound)
			playsound(src.loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		if(length(penalty_categories))
			visible_message(span_warning("The balloon reports a glut - prices on [english_list(penalty_categories)] have been cut short."))
		if(length(boost_categories))
			visible_message(span_notice("The balloon reports eager buyers - prices on [english_list(boost_categories)] were lifted higher."))

// AP parity export settlement: Crown export duty and the Merchant's levy come out of the gross,
// with the producer's net paid in change at the balloon pad. Ratwood deviation: payout goes through
// the pad's budget2change rather than AP's custom_turf coin drop.
/obj/item/roguemachine/navigator/proc/settle_export(gross, obj/structure/roguemachine/balloon_pad/pad)
	var/duty_rate = SStreasury.get_tax_rate(TAX_CATEGORY_EXPORT_DUTY)
	var/levy_pct = SSmerchant_trade ? SSmerchant_trade.merchant_levy_percent : 0
	var/levy = pay_merchant_share ? round(gross * levy_pct / 100) : 0
	var/duty_on_gross = round(gross * duty_rate)
	var/duty_on_levy = round(levy * duty_rate)
	var/total_duty = duty_on_gross + duty_on_levy
	var/producer_net = gross - levy - (pay_taxes ? duty_on_gross : 0)
	if(producer_net < 0)
		producer_net = 0
	var/merchant_net = levy - (pay_taxes ? duty_on_levy : 0)
	if(merchant_net < 0)
		merchant_net = 0
	if(pay_taxes)
		if(duty_on_gross > 0)
			SStreasury.mint(SStreasury.discretionary_fund, duty_on_gross, "[TAX_CATEGORY_EXPORT_DUTY] ([src.name])")
			SStreasury.apply_concordat_tithe(gross, TAX_CATEGORY_EXPORT_DUTY, "[src.name]")
		if(duty_on_levy > 0)
			SStreasury.mint(SStreasury.discretionary_fund, duty_on_levy, "[TAX_CATEGORY_EXPORT_DUTY] (levy income, [src.name])")
			SStreasury.apply_concordat_tithe(levy, TAX_CATEGORY_EXPORT_DUTY, "levy income ([src.name])")
		if(total_duty > 0)
			record_round_statistic(STATS_TAXES_COLLECTED, total_duty)
			record_round_statistic(STATS_REVENUE_EXPORT_DUTY, total_duty)
			duty_collected_here += total_duty
			if(SSmerchant_trade)
				SSmerchant_trade.merchant_levy_taxed += duty_on_levy
	else
		if(total_duty > 0)
			record_round_statistic(STATS_TAXES_EVADED, total_duty)
			duty_evaded_here += total_duty
	if(merchant_net > 0)
		SStreasury.mint(SStreasury.merchant_fund, merchant_net, "Merchant's levy ([src.name])")
		levy_collected_here += merchant_net
		if(SSmerchant_trade)
			SSmerchant_trade.merchant_levy_collected += merchant_net
			SSmerchant_trade.log_fund_movement("Navigator levy ([src.name])", merchant_net)
	if(gross > 0 && SSmerchant_trade && grants_passive_favor)
		var/passive = round(gross * FAVOR_PASSIVE_TRADE_FRACTION)
		SSmerchant_trade.adjust_merchant_favor(passive)
		SSmerchant_trade.favor_from_navigator += passive
	if(producer_net > 0 && pad)
		pad.budget2change(producer_net)

// ---- Economy 3 (merchant_trade) market pool bucket helpers ----
// Ported from AP code/controllers/subsystem/rogue/market_pools.dm (Economy 3 PR #7000).
// The pool bookkeeping subset plus, as of the wiring audit, the navigator sell-side:
// get_navigator_bucket_for_item() (minus the is_carved/was_crafted refinements, those item vars
// are not in this tree) and get_navigator_refusal_message(), feeding the saturation/demand
// export loop below. get_market_pool_tier_for_category()/compute_market_pool_capacity() stay
// unported: dead code in AP too (no callers there).

/proc/get_navigator_bucket_for_category(category)
	switch(category)
		if(ITEM_CAT_WEAPONS_SWORDS, ITEM_CAT_WEAPONS_DAGGERS, ITEM_CAT_WEAPONS_AXES, ITEM_CAT_WEAPONS_POLEARMS, ITEM_CAT_WEAPONS_MACES, ITEM_CAT_WEAPONS_FLAILS, ITEM_CAT_WEAPONS_SHIELDS, ITEM_CAT_WEAPONS_AMMO)
			return NAVIGATOR_BUCKET_WEAPONS
		if(ITEM_CAT_ARMOR_LIGHT)
			return NAVIGATOR_BUCKET_ARMOR_LIGHT
		if(ITEM_CAT_ARMOR_HELMETS, ITEM_CAT_ARMOR_CHESTPIECES, ITEM_CAT_ARMOR_LEGS, ITEM_CAT_ARMOR_NECK, ITEM_CAT_ARMOR_BOOTS, ITEM_CAT_ARMOR_GLOVES, ITEM_CAT_ARMOR_MASKS, ITEM_CAT_ARMOR_BRACERS, ITEM_CAT_ARMOR_BELTS, ITEM_CAT_ARMOR_BARDING)
			return NAVIGATOR_BUCKET_ARMOR_HEAVY
		if(ITEM_CAT_GARMENT_COMMON, ITEM_CAT_TAILOR_MISC, ITEM_CAT_CLOTH_MASK)
			return NAVIGATOR_BUCKET_GARMENT_COMMON
		if(ITEM_CAT_GARMENT_FINE)
			return NAVIGATOR_BUCKET_GARMENT_FINELUX
		if(ITEM_CAT_ENG_MACHINERY, ITEM_CAT_ENG_CONSTRUCTION, ITEM_CAT_ENG_COMBAT, ITEM_CAT_ENG_TRIGGERS, ITEM_CAT_ENG_MISC)
			return NAVIGATOR_BUCKET_ENGINEERING
		if(ITEM_CAT_VALUABLES_RINGS, ITEM_CAT_VALUABLES_HOLY, ITEM_CAT_DECORATION)
			return NAVIGATOR_BUCKET_VALUABLES_LOOTED
		if(ITEM_CAT_POTTERY)
			return NAVIGATOR_BUCKET_POTTERY
		if(ITEM_CAT_TROPHY)
			return NAVIGATOR_BUCKET_TROPHIES
		if(ITEM_CAT_INSTRUMENT)
			return NAVIGATOR_BUCKET_INSTRUMENTS
		if(ITEM_CAT_SEAFOOD)
			return NAVIGATOR_BUCKET_SEAFOOD
		if(ITEM_CAT_POTION, ITEM_CAT_REAGENT_ALCHEMICAL, ITEM_CAT_REAGENT_ARCANE, ITEM_CAT_ARCYNE_GEARS)
			return NAVIGATOR_BUCKET_POTIONS_REAGENTS
		if(ITEM_CAT_MAGICAL)
			return NAVIGATOR_BUCKET_ENCHANTMENTS
		if(ITEM_CAT_FOODSTUFF_FRESH, ITEM_CAT_FOODSTUFF_PRESERVED)
			return NAVIGATOR_BUCKET_REFUSED_FOOD
		if(ITEM_CAT_RAW_MATERIAL_MINERAL, ITEM_CAT_RAW_MATERIAL_ORGANIC, ITEM_CAT_SALVAGE, ITEM_CAT_LIVESTOCK, ITEM_CAT_TOOLS_COOKWARE, ITEM_CAT_TOOLS_FIELD, ITEM_CAT_TOOLS_WORKSHOP, ITEM_CAT_TOOLS_SUNDRIES, ITEM_CAT_TOOLS_ROGUE, ITEM_CAT_COMPONENTS, ITEM_CAT_SMITHING_MISC)
			return NAVIGATOR_BUCKET_REFUSED_BULK
	return NAVIGATOR_BUCKET_MISCELLANEOUS

/proc/all_navigator_buckets()
	return list(
		NAVIGATOR_BUCKET_WEAPONS,
		NAVIGATOR_BUCKET_ARMOR_LIGHT,
		NAVIGATOR_BUCKET_ARMOR_HEAVY,
		NAVIGATOR_BUCKET_GARMENT_COMMON,
		NAVIGATOR_BUCKET_GARMENT_FINELUX,
		NAVIGATOR_BUCKET_ENGINEERING,
		NAVIGATOR_BUCKET_VALUABLES_CRAFTED,
		NAVIGATOR_BUCKET_VALUABLES_LOOTED,
		NAVIGATOR_BUCKET_CARVED,
		NAVIGATOR_BUCKET_POTTERY,
		NAVIGATOR_BUCKET_TROPHIES,
		NAVIGATOR_BUCKET_ENCHANTMENTS,
		NAVIGATOR_BUCKET_INSTRUMENTS,
		NAVIGATOR_BUCKET_SEAFOOD,
		NAVIGATOR_BUCKET_POTIONS_REAGENTS,
		NAVIGATOR_BUCKET_MISCELLANEOUS,
	)

/proc/get_navigator_bucket_pool_baseline(bucket)
	switch(bucket)
		if(NAVIGATOR_BUCKET_WEAPONS)
			return NAVIGATOR_BUCKET_POOL_WEAPONS
		if(NAVIGATOR_BUCKET_ARMOR_LIGHT)
			return NAVIGATOR_BUCKET_POOL_ARMOR_LIGHT
		if(NAVIGATOR_BUCKET_ARMOR_HEAVY)
			return NAVIGATOR_BUCKET_POOL_ARMOR_HEAVY
		if(NAVIGATOR_BUCKET_GARMENT_COMMON)
			return NAVIGATOR_BUCKET_POOL_GARMENT_COMMON
		if(NAVIGATOR_BUCKET_GARMENT_FINELUX)
			return NAVIGATOR_BUCKET_POOL_GARMENT_FINELUX
		if(NAVIGATOR_BUCKET_ENGINEERING)
			return NAVIGATOR_BUCKET_POOL_ENGINEERING
		if(NAVIGATOR_BUCKET_VALUABLES_CRAFTED)
			return NAVIGATOR_BUCKET_POOL_VALUABLES_CRAFTED
		if(NAVIGATOR_BUCKET_VALUABLES_LOOTED)
			return NAVIGATOR_BUCKET_POOL_VALUABLES_LOOTED
		if(NAVIGATOR_BUCKET_CARVED)
			return NAVIGATOR_BUCKET_POOL_CARVED
		if(NAVIGATOR_BUCKET_POTTERY)
			return NAVIGATOR_BUCKET_POOL_POTTERY
		if(NAVIGATOR_BUCKET_TROPHIES)
			return NAVIGATOR_BUCKET_POOL_TROPHIES
		if(NAVIGATOR_BUCKET_ENCHANTMENTS)
			return NAVIGATOR_BUCKET_POOL_ENCHANTMENTS
		if(NAVIGATOR_BUCKET_INSTRUMENTS)
			return NAVIGATOR_BUCKET_POOL_INSTRUMENTS
		if(NAVIGATOR_BUCKET_SEAFOOD)
			return NAVIGATOR_BUCKET_POOL_SEAFOOD
		if(NAVIGATOR_BUCKET_POTIONS_REAGENTS)
			return NAVIGATOR_BUCKET_POOL_POTIONS_REAGENTS
		if(NAVIGATOR_BUCKET_MISCELLANEOUS)
			return NAVIGATOR_BUCKET_POOL_MISCELLANEOUS
	return 0

/proc/get_navigator_bucket_theme(bucket)
	switch(bucket)
		if(NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_ARMOR_LIGHT, NAVIGATOR_BUCKET_ARMOR_HEAVY)
			return MARKET_THEME_WARGEAR
		if(NAVIGATOR_BUCKET_POTIONS_REAGENTS, NAVIGATOR_BUCKET_ENCHANTMENTS)
			return MARKET_THEME_ARCYNE
		if(NAVIGATOR_BUCKET_GARMENT_COMMON, NAVIGATOR_BUCKET_GARMENT_FINELUX)
			return MARKET_THEME_GARMENTS
		if(NAVIGATOR_BUCKET_SEAFOOD)
			return MARKET_THEME_FOODSTUFFS
		if(NAVIGATOR_BUCKET_VALUABLES_CRAFTED, NAVIGATOR_BUCKET_VALUABLES_LOOTED, NAVIGATOR_BUCKET_CARVED, NAVIGATOR_BUCKET_POTTERY, NAVIGATOR_BUCKET_TROPHIES, NAVIGATOR_BUCKET_INSTRUMENTS)
			return MARKET_THEME_LOOT
		if(NAVIGATOR_BUCKET_ENGINEERING)
			return MARKET_THEME_ENGINEERING
	return MARKET_THEME_MISC

/proc/get_navigator_bucket_pop_scale(bucket)
	switch(bucket)
		if(NAVIGATOR_BUCKET_VALUABLES_LOOTED)
			return MARKET_POOL_POP_SCALE_VALUABLES_LOOTED
	return MARKET_POOL_POP_SCALE

/proc/compute_navigator_bucket_capacity(bucket, pop_count, list/theme_jitters)
	var/baseline = get_navigator_bucket_pool_baseline(bucket)
	if(baseline <= 0)
		return 0
	var/scale = get_navigator_bucket_pop_scale(bucket)
	var/pop_mult = 1 + scale * max(0, pop_count - MARKET_POOL_POP_REFERENCE)
	var/theme = get_navigator_bucket_theme(bucket)
	var/jitter = theme_jitters ? (theme_jitters[theme] || 1.0) : (MARKET_POOL_JITTER_LOW + rand() * (MARKET_POOL_JITTER_HIGH - MARKET_POOL_JITTER_LOW))
	return round(baseline * pop_mult * jitter)

/proc/roll_market_theme_jitters()
	var/list/themes = list(MARKET_THEME_WARGEAR, MARKET_THEME_ARCYNE, MARKET_THEME_GARMENTS, MARKET_THEME_FOODSTUFFS, MARKET_THEME_LOOT, MARKET_THEME_RAWS, MARKET_THEME_ENGINEERING, MARKET_THEME_MISC)
	var/list/out = list()
	for(var/theme in themes)
		out[theme] = MARKET_POOL_JITTER_LOW + rand() * (MARKET_POOL_JITTER_HIGH - MARKET_POOL_JITTER_LOW)
	return out

/proc/compute_pop_count_for_pools()
	return length(GLOB.clients)

/proc/get_navigator_bucket_for_item(obj/O, category)
	if(!isitem(O))
		return NAVIGATOR_BUCKET_MISCELLANEOUS
	var/obj/item/I = O
	if(I.is_carved)
		return NAVIGATOR_BUCKET_CARVED
	// crafted-valuables bucket refinements are dropped; armor still splits by class.
	var/bucket = get_navigator_bucket_for_category(category)
	if(bucket == NAVIGATOR_BUCKET_ARMOR_HEAVY && isclothing(O))
		var/obj/item/clothing/C = I
		if(C.armor_class <= ARMOR_CLASS_LIGHT)
			bucket = NAVIGATOR_BUCKET_ARMOR_LIGHT
	if(bucket == NAVIGATOR_BUCKET_VALUABLES_LOOTED && I.was_crafted)
		return NAVIGATOR_BUCKET_VALUABLES_CRAFTED
	return bucket

/proc/get_navigator_refusal_message(bucket)
	switch(bucket)
		if(NAVIGATOR_BUCKET_REFUSED_FOOD)
			return NAVIGATOR_REFUSAL_MSG_FOOD
		if(NAVIGATOR_BUCKET_REFUSED_BULK)
			return NAVIGATOR_REFUSAL_MSG_BULK
	return null

/obj/item/roguemachine/navigator/proc/get_market_saturation(category)
	if(!SSmerchant_trade || !category)
		return 1
	return SSmerchant_trade.get_saturation_factor(category)

/obj/item/roguemachine/navigator/proc/get_market_demand(category)
	if(!SSmerchant_trade || !category)
		return 1
	return SSmerchant_trade.get_demand_multiplier(category)

/obj/item/roguemachine/navigator/proc/credit_pool(category, base_price)
	if(!SSmerchant_trade || !category || base_price <= 0)
		return
	SSmerchant_trade.pool_consumed[category] = (SSmerchant_trade.pool_consumed[category] || 0) + base_price
	SSmerchant_trade.lifetime_pool_credited[category] = (SSmerchant_trade.lifetime_pool_credited[category] || 0) + base_price
	var/demand = SSmerchant_trade.pending_ship_demand[category] || 0
	var/drain = min(demand, base_price)
	if(drain > 0)
		SSmerchant_trade.pending_ship_demand[category] = demand - drain
		SSmerchant_trade.pending_ship_demand_satisfied[category] = (SSmerchant_trade.pending_ship_demand_satisfied[category] || 0) + drain

/proc/market_theme_label(theme)
	switch(theme)
		if(MARKET_THEME_WARGEAR)
			return "Wargear"
		if(MARKET_THEME_ARCYNE)
			return "Arcyne Goods"
		if(MARKET_THEME_GARMENTS)
			return "Garments"
		if(MARKET_THEME_FOODSTUFFS)
			return "Foodstuffs"
		if(MARKET_THEME_LOOT)
			return "Luxuries"
		if(MARKET_THEME_RAWS)
			return "Raw Stock"
		if(MARKET_THEME_ENGINEERING)
			return "Engineered Wares"
	return "Sundries"

/proc/build_market_theme_dispatch(list/theme_jitters)
	if(!length(theme_jitters))
		return ""
	var/list/glut = list()
	var/list/scarce = list()
	for(var/theme in theme_jitters)
		var/j = theme_jitters[theme]
		if(j >= MARKET_THEME_HIGH_JITTER)
			scarce += market_theme_label(theme)
		else if(j <= MARKET_THEME_LOW_JITTER)
			glut += market_theme_label(theme)
	var/list/parts = list()
	if(length(scarce))
		parts += "Scarce: [english_list(scarce)]"
	if(length(glut))
		parts += "In Glut: [english_list(glut)]"
	if(!length(parts))
		return "Markets steady across the board."
	return "This week: [jointext(parts, "; ")]."
