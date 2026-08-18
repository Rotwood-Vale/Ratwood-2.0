// Economy 3 compatibility layer, inherited from the Emerald Summit port vehicle.
// Bridges between AP naming and what this tree actually has. "ES deviation" notes
// throughout the port mark choices that are really this fork's, not Emerald's.
//
// The THREAT_REGION_* and DANGER_LEVEL_* defines that used to be duplicated here as a
// dme-ordering hack now live canonically in code/__DEFINES/economy/regional_threat.dm.
// The duplicate set had drifted (Emerald's "Black Basin"/"Scarlet Grove" strings against
// this tree's "Rotwood Vale" names), silently breaking economy-side region joins.

// Crown authority roles moved to questing/contract_ledger/contract_ledger.dm (AP's home for
// it) with AP's full court roster - every title on it exists in this tree.

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

