// ES Economy 3 compatibility layer.
// Stubs and bridges for AP systems not yet ported to Emerald Summit.

// ---- THREAT_REGION aliases: AP economy region names -> ES threat region strings ----
// ES uses "Scarlet/Black" naming; AP uses "Azure". These aliases let economic_region.dm
// compile against ES's existing SSregionthreat without modification.
#define THREAT_REGION_AZURE_BASIN   "Black Basin"
#define THREAT_REGION_AZURE_GROVE   "Scarlet Grove"
#define THREAT_REGION_AZUREAN_COAST "Scarlet Coast"
#define THREAT_REGION_UNDERDARK     "Terrorbog"
// THREAT_REGION_MOUNT_DECAP is defined in regional_threat.dm (same value in ES and AP),
// but that file sorts after this one. Duplicate the define here so economic_region.dm compiles.
#define THREAT_REGION_MOUNT_DECAP   "Mount Decapitation"

// ---- DANGER_LEVEL forward defines ----
// regional_threat.dm (which owns these) sorts after the economy files in the DME.
// Duplicate here so banditry_drain.dm and economic_events.dm compile without error.
#define DANGER_LEVEL_SAFE      "Safe"
#define DANGER_LEVEL_LOW       "Low"
#define DANGER_LEVEL_MODERATE  "Moderate"
#define DANGER_LEVEL_DANGEROUS "Dangerous"
#define DANGER_LEVEL_BLEAK     "Bleak"


// ---- Crown authority roles (Step 15 dependency) ----
// AP defines this in questing/contract_ledger/contract_ledger.dm (contract-ledger step, not yet
// ported) with AP's court roster (Steward/Grand Duke/Hand/Clerk/Marshal/Councillor/Prince).
// ES deviation: use Emerald Summit's fiscal-authority roster (matches steward.dm's
// Steward/Clerk/Grand Duke convention). Move this into the contract ledger file when that
// system lands.
GLOBAL_LIST_INIT(crown_authority_roles, list(
	"Steward",
	"Clerk",
	"Grand Duke",
))

// ---- SS13 economy compat stubs ----
// secrets.dm, datacore.dm, and account.dm still reference vars/procs from the old
// space-station economy.dm (now disabled). These no-op stubs satisfy the compiler.
/datum/controller/subsystem/economy
	var/full_ancap = FALSE
	var/list/bank_accounts = list()
	var/list/department_accounts = list()
	var/list/generated_accounts = list()

/datum/controller/subsystem/economy/proc/get_dep_account(dep_id)
	return null

// ---- Stubs for procs defined in later port steps ----

/// Decree ids force-suspended by sequestration. Populated by the bankruptcy charter-suspension
/// wiring (item 6 chunk B); the decree module itself lives in code/modules/politics/.
/datum/controller/subsystem/treasury
	var/list/bankruptcy_suspended_decree_ids = list()

// tick_burgher_pledge() is real as of item 6 (fund_api.dm) - gated on the Golden Bull.

/// Step 9/10: steward report — filled in when noticeboard/steward tgui is ported.
/datum/controller/subsystem/economy/proc/print_steward_report(list/diff)
	return

// ---- Merchant catalog stub (Step 9a follow-up: cultural stock / goldface catalog step) ----
// AP's merchant_trade.dm Initialize() does subtypesof(/datum/merchant_catalog) and calls
// init_catalog_stock()/restock_catalogs() (both real procs in AP's
// code/modules/roguetown/roguemachine/merchant/trade/merchant_catalog.dm). That file also defines
// concrete catalogs (Rosawood Arsenal, Anthraxi Armory) built entirely from /datum/supply_pack/rogue/*
// typepaths that are part of the cultural-stock/goldface catalog system, out of scope for the core
// subsystem step. Stub the base type + no-op the two procs so subtypesof() finds nothing and
// merchant_trade.dm's catalog bookkeeping is a harmless no-op until that step lands.
/datum/merchant_catalog
	var/id
	var/name
	var/desc
	var/favor_cost = 0
	var/home_label
	/// path -> max stock per restock. Always empty until the catalog step lands.
	var/list/stock = list()

/datum/controller/subsystem/merchant_trade/proc/init_catalog_stock()
	return

/datum/controller/subsystem/merchant_trade/proc/restock_catalogs()
	return

/// UI plumbing for Goldface Harbor/Cultural Stock tabs (Step 9a follow-up).
/// SSmerchant_trade.catalogs is always empty in ES right now, so these are unreachable in practice -
/// they only exist so _goldface.dm's build_catalog_data()/catalog_buy/unlock_catalog compile cleanly
/// against the /datum/merchant_catalog stub above.
/datum/controller/subsystem/merchant_trade/proc/catalog_unlocked(cid)
	return FALSE

/datum/controller/subsystem/merchant_trade/proc/catalog_origin_access(datum/merchant_catalog/C, mob/living/carbon/human/H)
	return FALSE

/datum/controller/subsystem/merchant_trade/proc/catalog_stock_remaining(cid, path)
	return 0

/datum/controller/subsystem/merchant_trade/proc/consume_catalog_stock(cid, path)
	return FALSE

/datum/controller/subsystem/merchant_trade/proc/unlock_catalog(cid)
	return FALSE

// ---- Ticker realm name stub (Step 9e: noticeboard ui_static_data reads this) ----
// AP's SSticker carries a configurable realm_name; ES's ticker has no equivalent var yet.
/datum/controller/subsystem/ticker
	var/realm_name = "Emerald Summit"

// ---- Cultural stock stubs (Step 9d follow-up: foreign realm cultural stock / bulk drinks export) ----
// trade_ship.dm's roll_cultural_stock()/build_drinks_lines() read these vars off supply packs and
// brewing recipes to build ship cargo manifests. Neither var exists in ES yet - they're part of AP's
// cultural-stock/bulk-trade system that ships alongside realm content (Step 9d). Until then,
// foreign_realm.cultural_stock_pool is empty (no realm subtypes exist), so these stay at their
// harmless defaults (0/null) and the two procs just produce empty lists.
/datum/supply_pack
	var/ship_qty_min = 0
	var/ship_qty_max = 0

/datum/brewing_recipe
	var/output_bottle_type

