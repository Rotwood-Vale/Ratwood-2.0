// Treasury bridge: AP-style fund system vars and stubs for SStreasury.
// datum/fund and related procs live in code/modules/banking/.

/datum/controller/subsystem/treasury
	/// Crown's general purse — replaces legacy treasury_value (kept in sync for compat).
	var/datum/fund/discretionary_fund
	/// Faction funds: church, merchant, bathhouse, innkeeper.
	var/datum/fund/church_fund
	var/datum/fund/merchant_fund
	var/datum/fund/bathhouse_fund
	var/datum/fund/innkeeper_fund
	/// Burgher pledge pool (CURRENCY_BURGHER_PLEDGE denomination).
	var/datum/fund/burgher_pledge_fund
	/// Maps fund_id (string) -> obj/structure/roguemachine/vaultbank.
	var/list/jawbanks_by_fund_id = list()
	/// Ordinance of the Baths: while in force, bathhouse machine tariffs divert to the
	/// Church as a tithe instead of the Crown. Bishop or Bathmaster toggles it at a Nervelock.
	var/bathhouse_ordinance_active = TRUE
	var/bathhouse_ordinance_next_toggle_time = 0
	/// Fractional tithe accumulator so sub-mammon skims are not lost between purchases.
	var/bathhouse_tithe_debt = 0
	var/round_bathhouse_tithe_total = 0
	/// Banditry damage accumulated this round; skimmed from incoming Crown mint.
	var/banditry_debt = 0
	/// ETC/burgher loan outstanding; skimmed from incoming Crown mint above the operating floor.
	var/treasury_debt = 0
	/// TREASURY_NORMAL / TREASURY_IN_ARREARS / TREASURY_BANKRUPTCY state machine.
	var/treasury_state = TREASURY_NORMAL
	/// Total sequestration events this round.
	var/bankruptcy_count = 0
	/// Decree ids force-suspended by sequestration (bankruptcy charter-suspension wiring;
	/// the decree module itself lives in code/modules/politics/).
	var/list/bankruptcy_suspended_decree_ids = list()
	/// Remaining concession slots after sequestration lift.
	var/bankruptcy_concession_picks = 0
	/// TRUE once the ETC arrears advance has been consumed (no second loan until repaid).
	var/atc_loan_arrears_consumed = FALSE
	/// How many ETC loans have been drawn this round.
	var/atc_loans_drawn_this_round = 0
	/// Full transaction ledger (list of datum/treasury_entry).
	var/list/ledger = list()
	/// Active loans (list of datum/loan).
	var/list/loans = list()
	/// Tax rates per category (assoc list: category -> 0.0–1.0). AP-default rates: goldface /
	/// fulfillment-crate tariff+duty code reads these and was silently collecting 0% while this
	/// list initialized empty. The Lord adjusts them via the Titan's TaxSetter (Taxation 2).
	var/list/tax_rates = list(
		TAX_CATEGORY_CONTRACT_LEVY = 0.20,
		TAX_CATEGORY_HEADEATER_LEVY = 0.15,
		TAX_CATEGORY_IMPORT_TARIFF = 0.15,
		TAX_CATEGORY_EXPORT_DUTY = 0.15,
		TAX_CATEGORY_FINE = 1.0,
	)
	/// Mobs whose wages are suspended during sequestration (ES: integer bank_accounts, so tracked separately).
	var/list/suspended_wage_mobs = list()
	/// Charters of the realm (item 6 decree port): id -> /datum/decree, built by init_decrees().
	var/list/decrees = list()
	/// One revoke and one restore per day, tracked separately.
	var/decree_revoke_used_day = -1
	var/decree_restore_used_day = -1
	/// Fractional Concordat-tithe carryover, so sub-mammon skims aren't lost between taxes.
	var/concordat_tithe_debt = 0
	/// One-fine-per-subject-per-day ledger, keyed by real_name; reset when the day rolls over.
	var/list/fined_today_names = list()
	var/fined_today_day = -1
	/// Maps trade_good_id -> datum/roguestock. Populated by SSeconomy during Initialize().
	var/list/stockpile_by_trade_good = list()
	/// Steward-settable floor. Stockpile refuses purchases when Crown's Purse would drop below this.
	var/stockpile_purchase_floor = STOCKPILE_CROWN_PURCHASE_FLOOR_DEFAULT
	/// Royal Custom charter: unlocks once economic_output crosses royal_custom_threshold.
	/// While active, direct-import surcharges at the stockpile flow to the Crown's Purse
	/// instead of being eaten as transport costs. Margin is Steward-settable (Step 15 UI).
	var/royal_custom_unlocked = FALSE
	var/royal_custom_active = FALSE
	var/royal_custom_margin = ROYAL_CUSTOM_DEFAULT_MARGIN
	var/royal_custom_threshold = ROYAL_CUSTOM_VOLUME_BASE
	/// Last GLOB.dayspassed we ran tick_loans() — prevents double-firing.
	var/last_loan_tick_day = -1
	/// Day after which no new personal loans or indentures may be issued.
	var/loan_max_issuance_day = 6
	/// Patron/agent rosters for each faction jawbank.
	var/list/church_agents = list()
	var/list/merchant_agents = list()
	var/list/bathhouse_agents = list()
	/// StewardTrade TGUI market/region/arbitrage view cache (Step 15).
	var/list/cached_market_rows = null
	var/list/cached_region_rows = null
	var/cached_total_arbitrage_potential = 0
	var/market_view_dirty = TRUE
	var/list/cached_auto_import_data = null
	var/auto_import_view_dirty = TRUE

// Mark the cached stewardry market / region / arbitrage
// view as needing rebuild on next read.
/datum/controller/subsystem/treasury/proc/dirty_market_view()
	market_view_dirty = TRUE
	auto_import_view_dirty = TRUE

/datum/controller/subsystem/treasury/proc/dirty_auto_import_view()
	auto_import_view_dirty = TRUE

/// AP parity (Step 15): pop-scaled stockpile limits for auto-limited entries.
/// ES deviation: CEILING(x, 1) instead of AP's ceil() builtin.
/datum/controller/subsystem/treasury/proc/autoset_stockpile_limits()
	var/effective_pop = (SSeconomy && SSeconomy.simulated_player_scalar > 0) ? SSeconomy.simulated_player_scalar : get_active_player_count()
	var/pop_mult = min(REGION_POP_SCALE_MAX, 1.0 + (effective_pop * REGION_POP_SCALE_PER_PLAYER))
	for(var/datum/roguestock/D as anything in stockpile_datums)
		if(!D.automatic_limit)
			continue
		if(!D.trade_good_id)
			D.stockpile_limit = max(STOCKPILE_LIMIT_MIN, D.stockpile_limit)
			continue
		var/total_demand = 0
		for(var/region_id in GLOB.economic_regions)
			var/datum/economic_region/region = GLOB.economic_regions[region_id]
			total_demand += region.demands[D.trade_good_id] || 0
		if(total_demand <= 0)
			D.stockpile_limit = max(STOCKPILE_LIMIT_MIN, D.stockpile_limit)
			continue
		D.stockpile_limit = clamp(CEILING(total_demand * pop_mult * STOCKPILE_AUTO_LIMIT_DAYS, 1), STOCKPILE_LIMIT_MIN, STOCKPILE_LIMIT_MAX)
		D.automatic_limit = TRUE

/// Expected daily rural tax income, surfaced by the StewardTrade ledger header.
/// Flat in AP too - decrees don't touch rural tax (tick_rural_tax mints the same).
/datum/controller/subsystem/treasury/proc/get_rural_tax_amount()
	return 50 // keep in sync with RURAL_TAX in treasury.dm

/// Projected daily wage outlay from the Nerve Master's configured daily payments.
/// ES deviation: bank_accounts values are integers and wage suspension is a trait,
/// not an account flag (AP checks account.wages_suspended).
/datum/controller/subsystem/treasury/proc/get_expected_wage_outlay()
	if(!steward_machine || !steward_machine.daily_payments)
		return 0
	var/list/payments = steward_machine.daily_payments
	var/total = 0
	for(var/mob/living/owner as anything in bank_accounts)
		if(!owner)
			continue
		var/payment_amount = payments[owner.job]
		if(!payment_amount)
			continue
		if(HAS_TRAIT(owner, TRAIT_WAGES_SUSPENDED))
			continue
		total += payment_amount
	return total
