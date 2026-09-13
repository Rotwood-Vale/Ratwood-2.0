// The "Collectable Treasures" vault bounty (/datum/roguestock/bounty/treasure) was retired here
// to match Azure-Peak #6849, which dropped arbitrary item -> coin minting from the economy.
//
// It was the item_type=/obj catch-all in SStreasury.stockpile_datums: any non-weapon/armour/ore
// item worth >= 30 mammon (plus statues, cups, gems, platters and candlesticks at any value)
// minted into the Crown's Purse at 70% of value, and gems the Steward had toggled off fell
// through to it as well. Gem OVERFLOW minting is unaffected - it uses the trade-good mint path in
// stockpile.dm directly, not this bounty.
//
// The base category type below is kept (with NO subtypes) so existing references still resolve:
// SStreasury seeds subtypesof(/datum/roguestock/bounty) - now empty, so nothing is instantiated -
// and the Stockpile UI / Steward Bounties tab iterate /datum/roguestock/bounty instances, of which
// there are now none, so both render empty. Add a subtype here to bring back a coin-sink vault.
/datum/roguestock/bounty
	name = "bounty"
