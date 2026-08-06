// Economy 3 guidebook — Steward chapters. Ported from Azure-Peak PR #7000
// (apsrc/main, code/modules/crafting/recipe_books/book_entries/treasury/realm_chapters.dm)
// with content pared back to what Emerald Summit actually implements.
//
// History note: this guidebook was first ported with the Alderman/City Assembly and the whole
// blockade/defense-commission layer CUT, because ES had only stubs then. Both have since landed
// (SScity_assembly + assembly_warrant; Quest 2's factions + Grand Contract Ledger + blockade
// lifecycle), so chapters "02. The City Assembly" and "03. Defense and Blockades" were restored
// and now describe the real systems. The Crown-only "Crown Authority" title list (Clerk, Grand
// Duke, Hand, Marshal, Councillor, Prince/Princess) stays cut - ES keeps its 3-role roster.
//
// Cut/rewritten vs AP:
//  - Alderman weight in Regional Trade: ES models the Alderman as a warrant-holder (see the
//    City Assembly chapter), not as a stockpile-price setter, so AP's "the Alderman cannot
//    alter stockpile pricing" caveat is simply not applicable and stays out of Regional Trade.
//  - Standing (Auto) Imports: the essentials list is 7 goods in ES, not AP's 6 - grepped
//    code/controllers/subsystem/rogue/economy/auto_import.dm and found coal, wood, grain,
//    iron ore, hide, fur, and fat all seeded by default.
//
// Kept close to AP (real, matching systems - defines cross-checked against
// code/__DEFINES/banking.dm, code/__DEFINES/economy/*.dm, and the implementing .dm files):
//  - Regional Trade (import/export pricing, stockpile autoprice/autolimit, surplus exports):
//    code/controllers/subsystem/rogue/economy/economy.dm.
//  - Standing (Auto) Imports: code/controllers/subsystem/rogue/economy/auto_import.dm.
//  - Of Standing Orders: economy.dm's daily_tick()/instantiate_standing_order().
//  - Warehouse: GLOB.steward_export_machines consumers in economy.dm.
//  - Insolvency, Sequestration and Loans: code/modules/banking/bankruptcy.dm - every define
//    (TREASURY_ARREARS_LOAN, ATC_LOAN_*, BANKRUPTCY_*) matches AP's values exactly.
//  - Banditry: code/controllers/subsystem/rogue/economy/banditry_drain.dm - every define
//    matches AP's values exactly, and it fires once per game-day from SSeconomy.daily_tick().
//    The code comments flag it as "a placeholder until raid and siege content ships" - kept
//    that framing from AP's original text since it's still accurate.

/datum/book_entry/treasury_realm
	abstract_type = /datum/book_entry/treasury_realm
	category = "Steward"

/datum/book_entry/treasury_realm/budgets
	name = "01. Budgets and Authority"

/datum/book_entry/treasury_realm/budgets/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Crown's Purse</h3>
		<p>The Crown's actual mammon balance. Used to pay wages, imports, deposits, and any other expenditure drawn through the Nerve Master (KEEP IT LOCKED!). Replenished by taxes, fines, direct deposit into the Nerve Master, exports, and fulfilling standing orders.</p>

		<h3>Burgher Pledge</h3>
		<p>Not actual coin, but a virtual pool pledged by the Burghers of the realm. It refills daily, scaling with a flat base and the active player count.</p>

		<h3>The Steward and the Alderman</h3>
		<p>The Steward is the standing authority over both pools. The realm may also elect an <b>Alderman</b> through the City Assembly (see the next chapter); while the seat is filled, the Alderman holds a separate daily spending warrant - a trade allotment and a defense allotment - set by the Assembly. When the seat sits empty, the Steward answers for both alone.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/assembly
	name = "02. The City Assembly and the Alderman"

/datum/book_entry/treasury_realm/assembly/inner_book_html(mob/user)
	return {"
		<div>
		<p>The <b>City Assembly</b> is the realm's Commons. It convenes to fill the seat of the <b>Alderman</b> and to set the bounds of that office. Its floor is reached through the door on the town Noticeboard.</p>

		<h3>Sessions</h3>
		<p>The first Assembly resolves about <b>[ASSEMBLY_FIRST_SESSION_MINUTES] minutes</b> into the round; every session after resolves at <b>dawn</b>. A session settles all of its standing motions at once and then opens a fresh one. If fewer than <b>[ASSEMBLY_QUORUM_VOTERS]</b> distinct citizens cast a vote, the session lapses and everything holds at status quo.</p>

		<h3>Who Votes</h3>
		<p>Any citizen of the realm who is not an outlaw may vote. Vote weight scales with station - burghers and notables carry more voice than common folk, and holding citizenry or residency lifts a transient or peasant to full burgher weight.</p>

		<h3>The Motions</h3>
		<ul>
			<li><b>Election</b> - choose the next Alderman from those who have declared candidacy (each may post a short pledge), or vote for <b>No Alderman</b> to leave the seat empty. The sitting Alderman is listed automatically for re-election. A candidate may not be an outlaw, may not have been censured, and may not be a <b>Merchant</b> or <b>Shophand</b> (barred for their direct trade levers - every other station, the bathhouse included, may stand). The seat belongs to the <i>person</i>, not the character sheet: die, resign, or leave the Realm and it falls vacant.</li>
			<li><b>Trade Authorization</b> - votes the Alderman a daily <b>trade allotment</b> of <b>0, 150, 300, 450, 600, 750, or 900</b> mammon.</li>
			<li><b>Defense Authorization</b> - votes a daily <b>defense allotment</b> of <b>0, 250, 500, 750, or 1000</b> in burgher pledge.</li>
			<li><b>Recall</b> - a <b>[ASSEMBLY_RECALL_THRESHOLD_PCT]%</b> majority turns the sitting Alderman out of the seat.</li>
			<li><b>Censure</b> - a <b>[ASSEMBLY_CENSURE_THRESHOLD_PCT]%</b> supermajority turns the Alderman out <i>and</i> bars them from the office for the rest of the round.</li>
		</ul>
		<p>A bracket vote is settled at the highest allotment that still holds the room; if <b>[ASSEMBLY_NAE_VETO_PCT]%</b> or more of the cast weight votes <b>Nae</b>, the authorization is vetoed to nothing.</p>

		<h3>The Alderman's Warrant</h3>
		<p>Once seated, the Alderman holds a spending <b>warrant</b> that refreshes to its authorized caps each dawn. The <b>trade allotment</b> is spent acting on the Crown's trade through the Steward's panel; the <b>defense allotment</b> pays for blockade-defense commissions posted to the Grand Contract Ledger (see <i>Defense and Blockades</i>). Unspent budget does not carry to the next day, and losing or vacating the seat empties the warrant at once.</p>

		<p><b>Held in reserve:</b> the Assembly's power to levy a poll tax of its own is disabled in this build pending anti-dodge rules, so it cannot presently impose a head tax.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/defense
	name = "03. Defense and Blockades"

/datum/book_entry/treasury_realm/defense/inner_book_html(mob/user)
	return {"
		<div>
		<p>A region's trade road can be <b>blockaded</b> by a hostile faction. A handful stand up at round start (<b>[BLOCKADE_ROUNDSTART_COUNT_MIN]-[BLOCKADE_ROUNDSTART_COUNT_MAX]</b>), and more may fall upon the realm on later days. Only factions fierce enough to besiege a road can raise one, and only in regions whose threat is high enough to harbour them - so tame regions stay open and dangerous ones do not.</p>

		<h3>The Bite</h3>
		<p>While a region is blockaded its trade is throttled - Import Price x<b>[BLOCKADE_IMPORT_MULT]</b>, Export Revenue x<b>[BLOCKADE_EXPORT_MULT]</b> - and the Crown is called to answer it. The blockade holds until it is broken.</p>

		<h3>Breaking a Blockade</h3>
		<p>The Crown - or an Alderman spending the Assembly's <b>defense allotment</b> (see <i>The City Assembly and the Alderman</i>) - commissions a <b>blockade-defense contract</b> at the Grand Contract Ledger. Adventurers take the writ, put down the besieging faction's waves, and the road reopens. A region that has just been cleared cannot be blockaded again for <b>[BLOCKADE_RECLEAR_COOLDOWN]</b> days.</p>

		<p>Separately, a region's <b>Dangerous</b> or <b>Bleak</b> threat classification drains the Crown's Purse every dawn on its own, whether or not a blockade stands - see <i>Banditry</i>.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/trade
	name = "04. Regional Trade"

/datum/book_entry/treasury_realm/trade/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Crown trades with nine regions: Kingsfield, Rosawood, Rockhill, Daftsmarch, Blackholt, Saltwick, Bleakcoast, Northfort, Heartfelt. Trade and Stockpile interfaces are accessed through the Nerve Master.</p>

		<h3>Trade Pricing</h3>
		<ul>
			<li>Each region has daily production and demand for specific goods. Volumes scale with active player count.</li>
			<li><b>Import</b> price rises sharply once purchases exceed daily production.</li>
			<li><b>Export</b> price falls sharply once sales exceed daily demand.</li>
			<li><b>Export</b> price is always <b>[IMPORT_EXPORT_SPREAD * 100]%</b> less than the matching import price. Buying and re-selling on the same day is always a loss.</li>
			<li><b>Blockade</b> (when one manages to stand): Import Price x<b>[BLOCKADE_IMPORT_MULT]</b>, Export Revenue x<b>[BLOCKADE_EXPORT_MULT]</b>.</li>
			<li>Each trade action is capped at <b>[TRADE_MAX_BULK_UNITS]</b> units per click.</li>
		</ul>

		<h3>Stockpile Pricing, Autoprice and Autolimit</h3>
		<p>Each stockpiled good has two prices: a <b>buy price</b> (Crown pays the depositing player) and a <b>sell price</b> (Crown charges the withdrawing player). On <b>Autoprice</b>, prices peg to the good's global reference so the Crown always profits a margin per transaction; the Steward may override either price by hand, which switches the entry to <b>Manual</b>. Manual entries hold whatever the Steward set until restored to Auto.</p>

		<h3>Stockpile Limit - Auto and Manual</h3>
		<p>Each stockpile entry has a per-day limit beyond which deposits no longer pay, computed from total daily demand across all regions, scaled by population, with <b>[STOCKPILE_AUTO_LIMIT_DAYS]</b> days of headroom and a <b>[STOCKPILE_LIMIT_MIN]</b>-unit floor for goods with no demand line. The Steward may override by hand, flipping the entry to <b>Manual</b>.</p>

		<h3>Surplus Exports</h3>
		<p>Stock above a per-good surplus floor is cleared by the Crown's daily auto-export sweep to the highest-paying region, capped at that region's remaining daily demand. Manual-priced entries are skipped by the sweep - hand-export those yourself.</p>

		<h3>Imports and the Stockpile</h3>
		<p>Regional imports enter the Crown's stockpile and feed standing orders and the city's economy at large. The Steward may set a <b>purchase floor</b>: imports are refused when they would drop the Purse below it.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/auto_import
	name = "05. Standing (Auto) Imports"

/datum/book_entry/treasury_realm/auto_import/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Crown may auto-import essential goods each dawn, sparing the Steward from manually re-importing the same basics every day. Goods stay on the list until removed.</p>

		<h3>Essentials</h3>
		<p>Seven goods are on standing import by default: <b>coal, wood, grain, iron ore, hide, fur, and fat</b>. The Steward may remove any of them from the Market Scroll's Auto-Import tab and re-add them later. Any other importable good with an active producing region can also be placed on standing import.</p>

		<h3>Rules</h3>
		<p>Each dawn, for each good on the list:</p>
		<ul>
			<li>If the stockpile already holds <b>[AUTO_IMPORT_FLOOR]</b> or more units, no import is made.</li>
			<li>Otherwise, the Crown buys <b>[AUTO_IMPORT_BATCH]</b> units from the cheapest producing region.</li>
			<li>The import is skipped if any unit would cost more than <b>[AUTO_IMPORT_MAX_PRICE_MULT]x</b> the good's base price.</li>
			<li>The import is skipped if it would drop the Crown's Purse below the Steward's purse floor (default <b>[AUTO_IMPORT_PURSE_FLOOR_DEFAULT]m</b>, adjustable).</li>
		</ul>

		<p>The panel retains the last <b>[AUTO_IMPORT_HISTORY_DAYS]</b> days of activity. Standing imports draw from the Crown's Purse only.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/standing_orders
	name = "06. Of Standing Orders"

/datum/book_entry/treasury_realm/standing_orders/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Types</h3>
		<ul>
			<li><b>Regular</b> - rolled each dawn (<b>[STANDING_ORDERS_BASE_PER_DAY]</b> base, plus more per active player), capped at <b>[STANDING_ORDERS_MAX_PER_DAY]</b>/day. <b>[STANDING_ORDER_DURATION]</b>-day lifespan. Payout: base x<b>[1 + STANDING_ORDER_BASE_BONUS]</b> per unit.</li>
			<li><b>Urgent</b> - spawned by shortage events, capped at <b>[STANDING_ORDERS_MAX_URGENT]</b> standing at a time. One-day lifespan, higher payout.</li>
			<li><b>Warehouse</b> - for finished goods (equipment, potions). Settled from the export warehouse, not the stockpile.</li>
		</ul>

		<h3>Fulfillment</h3>
		<p>Stockpile orders: deposit goods, confirm at the Nerve Master, payout minted to the Crown's Purse. Warehouse orders: matched automatically against registered export machines.</p>

		<p><b>Partial fulfillment:</b> if the on-hand goods cover at least <b>[round(STANDING_ORDER_PARTIAL_THRESHOLD * 100)]%</b> of an order's posted value, the Steward may settle it anyway. The buyer pays <b>[round(STANDING_ORDER_PARTIAL_PAYOUT_MULT * 100)]%</b> of the delivered share's value and the missing share is forfeit.</p>

		<h3>Limits</h3>
		<p>Max <b>[STANDING_ORDERS_MAX_PER_REGION]</b> orders per region. Max <b>[STANDING_ORDERS_POOL_CAP]</b> orders in the realm.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/warehouse
	name = "07. Warehouse"

/datum/book_entry/treasury_realm/warehouse/inner_book_html(mob/user)
	return {"
		<div>
		<p>Registered Steward export machines accept finished goods that fulfill warehouse-tagged standing orders.</p>

		<h3>Equipment Orders</h3>
		<p>Swept for exact-type match. Subtypes and variants are not consumed.</p>

		<h3>Potion Orders</h3>
		<p>Swept by reagent and volume. Any container holding the right reagent counts, consumed from the top until the order is met.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/insolvent
	name = "08. Insolvency, Sequestration and Loans"

/datum/book_entry/treasury_realm/insolvent/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Crown becomes insolvent if it fails to meet payroll from the Crown's Purse at dawn. Insolvency triggers in stages: first an interest-free advance, then an optional emergency loan, and finally sequestration if the Crown fails again.</p>

		<h3>First Failure - Arrears</h3>
		<p>If the Crown's Purse cannot meet the day's wages, an advance of <b>at least [TREASURY_ARREARS_LOAN]m, up to the actual shortfall</b>, is issued without interest. Wages pay normally for the day. The advance is registered as <b>arrears</b>; until settled, every coin of inflow into the Crown's Purse is skimmed against it before reaching the balance.</p>

		<h3>The Emergency Loan</h3>
		<p>Before Day <b>[ATC_LOAN_CLOSED_DAY]</b>, the Crown may draw a one-time loan for <b>[ATC_LOAN_MIN_AMOUNT]m to [ATC_LOAN_MAX_AMOUNT]m</b>. The principal is paid into the Crown's Purse immediately. Interest is <b>[round(ATC_LOAN_INTEREST_RATE * 100)]%</b>, repaid silently from skimmed inflow. No second loan may be drawn until the first is settled. Drawing the loan <b>forfeits the arrears grace</b>: missing payroll while the loan is outstanding sends the Crown directly to sequestration.</p>

		<h3>Second Failure - Sequestration</h3>
		<p>If the Crown misses payroll on a second consecutive dawn (or once with an outstanding loan), the realm enters <b>sequestration</b>:</p>
		<ul>
			<li>Crown's Purse is reset to <b>[BANKRUPTCY_OPERATING_FLOOR]m</b>. Anything above the floor is forfeit; anything below is topped up.</li>
			<li>A debt of <b>[BANKRUPTCY_DEBT_FLAT]m</b> is registered on top of any existing arrears or loan debt.</li>
			<li>All Crown salaries are suspended until sequestration lifts.</li>
			<li>Every importable good is placed on standing import; auto-export ratchets to <b>[round(BANKRUPTCY_AUTOEXPORT_PERCENTAGE * 100)]%</b> of stockpile limit. Manual import/export and stockpile pricing controls are disabled.</li>
		</ul>

		<h3>Recovery</h3>
		<p>When the debt reaches zero, sequestration lifts. Salaries resume the next day. The Crown's Purse is seeded with <b>[BANKRUPTCY_RECOVERY_RESET]m</b>. The realm may enter sequestration multiple times in the same round - each declaration adds fresh debt.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/banditry
	name = "09. Banditry"

/datum/book_entry/treasury_realm/banditry/inner_book_html(mob/user)
	return {"
		<div>
		<p>Regions classified as <b>Dangerous</b> or <b>Bleak</b> drain the Crown's Purse each dawn.</p>

		<h3>Banditry Drain</h3>
		<p>Per region, per dawn:</p>
		<ul>
			<li><b>Dangerous</b>: [BANDITRY_DRAIN_DANGEROUS_FLAT]m base + [BANDITRY_DRAIN_DANGEROUS_PER_PLAYER]m per active player.</li>
			<li><b>Bleak</b>: [BANDITRY_DRAIN_BLEAK_FLAT]m base + [BANDITRY_DRAIN_BLEAK_PER_PLAYER]m per active player.</li>
		</ul>

		<h3>The Floor and Banditry Debt</h3>
		<p>Banditry alone will not reduce the Crown's Purse below <b>[BANDITRY_DEBT_FLOOR]m</b>. Anything beyond that becomes <b>banditry debt</b> - an accruing arrears that skims every coin of treasury inflow until paid.</p>

		<h3>What You Can Do</h3>
		<p>As regional threat falls, so does the dawn drain. Banditry debt only shrinks as new income is earned and skimmed. This dawn drain is a placeholder until fuller raid and siege content ships; unlike a blockade (see <i>Defense and Blockades</i>), it cannot be lifted by a single commission - only a lasting fall in the region's threat will ease it.</p>
		</div>
	"}
