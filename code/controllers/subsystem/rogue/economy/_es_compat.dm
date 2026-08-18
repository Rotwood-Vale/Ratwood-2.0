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

// The merchant catalog system (Rosawood Arsenal, Anthraxi Armory) is real as of the wiring-audit
// fixes: datum, concrete catalogs and subsystem procs live in
// code/modules/roguetown/roguemachine/merchant/trade/merchant_catalog.dm, with stock packs in
// code/modules/cargo/packsrogue/merchant/foreign/cultural_rosawood.dm and cultural_underdark.dm.

// Ticker realm name stub not needed: Ratwood's SSticker already carries realm_name,
// kept in sync with SSmapping.map_adjustment.realm_name.

// ---- Cultural stock vars (live) ----
// trade_ship.dm's roll_cultural_stock()/build_drinks_lines() read these vars off supply packs and
// brewing recipes to build ship cargo manifests. These are the real and only definitions; the
// cultural pack files under code/modules/cargo/packsrogue/merchant/foreign/ set them per pack, and
// every foreign realm under merchant/trade/realms/ carries a populated cultural_stock_pool. In AP
// the vars live on the base types directly; here they graft on so the base files stay unforked.
/datum/supply_pack
	var/ship_qty_min = 0
	var/ship_qty_max = 0

/datum/brewing_recipe
	var/output_bottle_type

