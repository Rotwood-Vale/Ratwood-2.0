/datum/trade_good
	var/id
	var/name
	var/category
	var/behavior
	var/base_price
	var/low_price
	var/high_price
	var/importable = TRUE
	var/source_region_id
	var/item_type
	/// When TRUE, fulfillment accepts any subtype of item_type (used for goods with many cosmetic variants)
	var/accept_subtypes = FALSE
	/// Optional list of additional EXACT item types fulfillment accepts, for goods with no single
	/// base type (e.g. a prosthetic limb good matching all four limb variants of one material).
	var/list/alt_item_types
	var/global_price_mod = 1.0
	var/derive_price = FALSE
	var/mint_eligible = FALSE
	var/crown_accepts = TRUE
	/// Optional override for the market-pool ITEM_CAT_* this good's item_type maps to.
	var/display_category
	// Potion-only: alchemical orders match any reagent container holding at least
	// required_volume units of reagent_type. The container is consumed on fulfillment.
	var/reagent_type
	var/required_volume = 0

/datum/trade_good/New()
	. = ..()
	if(isnull(low_price) && !isnull(base_price))
		low_price = round(base_price * 0.6)
	if(isnull(high_price) && !isnull(base_price))
		high_price = base_price * 2

/// Keyed list of all trade_good instances, indexed by trade_good_id string.
GLOBAL_LIST_INIT(trade_goods, init_trade_goods())

/// List of active /datum/economic_event instances this round.
GLOBAL_LIST_EMPTY(active_economic_events)

/proc/init_trade_goods()
	var/list/result = list()
	for(var/datum/trade_good/tg as anything in subtypesof(/datum/trade_good))
		var/datum/trade_good/instance = new tg()
		if(!instance.id)
			continue
		result[instance.id] = instance
	return result
