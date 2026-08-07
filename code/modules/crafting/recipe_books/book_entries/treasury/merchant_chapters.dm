// Economy 3 guidebook — Merchant chapters. Ported from Azure-Peak PR #7000
// (apsrc/main, code/modules/crafting/recipe_books/book_entries/treasury/merchant_chapters.dm)
// with content pared back to what Emerald Summit actually implements.
//
// AP's open_economy_guidebook() proc (which used AP's /datum/recipe_wiki multi-pane wiki UI)
// is intentionally NOT ported here - that system doesn't exist in ES. The ES-native
// replacement lives in economy_guidebook.dm in this same folder.
//
// Cut/rewritten vs AP:
//  - The Navigator: AP describes three variants (Public/Private/Smuggler) with per-machine
//    Crown-duty and Merchant-levy toggles and a Black Market saturation mechanic. ES's actual
//    navigator (code/modules/roguetown/roguemachine/merchant/navigator.dm) is a single legacy
//    machine type plus a /blackmarket subtype: no toggles, no per-machine tallies, a flat
//    "Guild's Tax" (SStreasury.queens_tax, or a hardcoded 70% on the blackmarket variant), and
//    items priced below 1m are still consumed (just unpaid), not refused outright. Rewritten to
//    describe the real machine.
//  - Goldface/Silverface: kept close to AP - the Secrets toggle, per-machine tariff tallies,
//    Harbor tab (hails/dock spots/cultural stock/merchant's levy), and Silverface's flat 50%
//    surcharge all match code/modules/roguetown/roguemachine/merchant/_goldface.dm exactly.
//    The "Catalogs" concept (Rosawood Arsenal, Anthraxi Armory) is cut - per
//    _es_compat.dm, SSmerchant_trade.catalogs is always empty (no /datum/merchant_catalog
//    subtypes exist), so build_catalog_data() is a harmless dead branch in practice.
//  - Escrow/COMMISSIONER: kept close to AP, but the default percent_margin/flat_margin are
//    70%/5m in ES (code/modules/roguetown/roguemachine/escrow.dm), not AP's 20%/0.
//  - Rag Picker/Scrapper: kept. seed_budget defaults to 0 on the base type but both concrete
//    subtypes (scrapper.dm) set it to 50, matching AP's "50m starting budget" claim.
//  - Avisa Market Tab: AP describes a standalone Avisa newspaper interface. In ES, the
//    noticeboard's "help_market" button opens this very guidebook chapter (see
//    noticeboard.dm's ui_act "help_market" case) rather than a separate Avisa UI - rewritten to
//    describe the noticeboard's live Market view instead.

/datum/book_entry/treasury_merchant
	abstract_type = /datum/book_entry/treasury_merchant
	category = "Merchant"

/datum/book_entry/treasury_merchant/navigator
	name = "01. The Navigator"

/datum/book_entry/treasury_merchant/navigator/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>NAVIGATOR:</b> The heart of everyday commerce in Azuria. This machine lifts sellable goods up by balloon roughly every two minutes.</p>

		<h3>How it works</h3>
		<ul>
			<li>Drop sellable items on the eight tiles surrounding the machine. A balloon arrives on a two-to-three minute timer and lifts everything sitting on its pads into the air.</li>
			<li>Anchored items, coins, and handcarts are skipped.</li>
			<li>Each lifted item's payout is its price, less the Guild's Tax (the realm's general tax rate). Items priced too low to clear a single mammon after tax are still lifted and lost - the machine does not refuse them outright.</li>
			<li>Clicking the Navigator shows the current Guild's Tax rate and the time to the next balloon.</li>
		</ul>

		<h3>The Suspicious (Black Market) Navigator</h3>
		<p>A separate variant found at the black market ruin skims a flat 70% off every lift instead of the Guild's Tax - "this is used at the navigator at the black market ruin, which rips you off." There is no per-machine duty toggle, tally, or Public/Private/Smuggler distinction on either variant in this build.</p>
		</div>
	"}


/datum/book_entry/treasury_merchant/fulfillment_crate
	name = "02. The Ship Fulfillment Crate"

/datum/book_entry/treasury_merchant/fulfillment_crate/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>SHIP FULFILLMENT CRATE:</b> A crate used to fill the bulk and victualling demands of docked foreign vessels. The crate pays out at the docked ship's offered line price, less Crown export duty and the Merchant's levy.</p>

		<h3>How it works</h3>
		<ul>
			<li>You need a NERVELOCK account. The crate refuses goods from anyone without one.</li>
			<li><b>Left-click (or attack) with an item:</b> deposit that one item.</li>
			<li><b>Right-click the crate:</b> dump everything on your tile into it at once, with a running tally announced when it's done.</li>
			<li>Handcarts and storage bins on your tile are unpacked automatically - the crate matches their contents one item at a time.</li>
			<li>Sealed, ready-to-bottle fermentation kegs can be dragged onto the crate directly.</li>
		</ul>

		<h3>What the crate accepts</h3>
		<ul>
			<li><b>Bulk goods:</b> tradeable raw or finished goods matched against a docked ship's open bulk demand lines, identified via the trade good registry.</li>
			<li><b>Victualling dishes:</b> readied meals and preserved provisions matching a docked ship's manifest, tracked by exact item type.</li>
			<li><b>Victualling drinks:</b> sealed brewer bottles matched to a ship's drink demand; unsealed bottles are refused, and ships that only buy by the barrel will refuse loose bottles entirely.</li>
			<li><b>Bundles</b> (raw stack items like fibers and hides) are accepted up to the remaining demand on the line - any leftover stays in your bundle.</li>
		</ul>

		<h3>What the crate refuses</h3>
		<ul>
			<li>ATC-sealed items (anything bought from Goldface or Silverface).</li>
			<li>Rotten food.</li>
			<li>Goods not on any docked vessel's open manifest.</li>
		</ul>

		<h3>Duty and the Merchant's cut</h3>
		<p>Merchant/Shophand can toggle Crown export duty between PAID and DODGED on this specific crate via its underledger switch. Item quality above or below standard shifts the unit price up or down, and Kinship-favoured ships pay a bonus on top (see <i>The Kinship Bonus</i>).</p>
		</div>
	"}


/datum/book_entry/treasury_merchant/goldface
	name = "03. Goldface and Silverface"

/datum/book_entry/treasury_merchant/goldface/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>GOLDFACE & SILVERFACE:</b> GOLDFACE is meant for the Merchant's own use; SILVERFACE is the public-facing version, offering the same goods at a markup.</p>

		<h3>GOLDFACE</h3>
		<ul>
			<li>Locked and unlocked with the Merchant's key (or a keyring holding it).</li>
			<li>Coin is manually loaded and then spent to buy goods.</li>
			<li>ATC members (Merchant, Shophand) can toggle the Secrets menu to "Stop Paying Taxes", skipping the import tariff.</li>
			<li>Tariff paid and tariff evaded are tracked per machine, visible only to ATC members.</li>
			<li>Bought items are spawned ATC-sealed and cannot be re-exported via the Navigator or the Ship Fulfillment Crate.</li>
		</ul>

		<h3>The Harbor tab (GOLDFACE only)</h3>
		<p>GOLDFACE is the command centre for foreign trade. Its Harbor tab shows docked ships, the wider ship pool, and every discovered realm's market conditions. See <i>Ships, Hails, and the Warehouses</i> for how hailing and demand work.</p>
		<ul>
			<li><b>Cultural stocks:</b> docked ships carry cultural-goods packs at a [TRADE_CULTURAL_SHIP_DISCOUNT_PERCENT]% discount off base cost. Import tariff still applies unless dodged.</li>
			<li><b>Bulk buy/demand:</b> docked ships offer cargoes for sale and purchase large amounts of goods at a markup, generally more than the town alone can supply.</li>
			<li><b>Merchant's levy:</b> Merchant/Shophand can set the levy percentage (0 to [TRADE_MERCHANT_LEVY_CAP_PERCENT]%). This is the same levy the Ship Fulfillment Crate deducts on producer payouts.</li>
		</ul>

		<h3>SILVERFACE (public)</h3>
		<ul>
			<li>Cannot be locked - keys are refused on the public variant.</li>
			<li>Adds a flat <b>[50]%</b> surcharge on top of base cost and import tariff, by design meant to be unprofitable relative to Goldface so producers can compete on price.</li>
		</ul>
		</div>
	"}


/datum/book_entry/treasury_merchant/harbor_mechanics
	name = "04. Ships, Hails, and the Warehouses"

/datum/book_entry/treasury_merchant/harbor_mechanics/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>HARBOR MECHANICS:</b> The Merchant hails ships, manages sales and purchases with them, accumulates Favor, and sends them off.</p>

		<h3>Hailing</h3>
		<ul>
			<li>You have <b>[TRADE_SHIPS_HAIL_PER_DAY]</b> hails per day. A hail brings one ship from the pool to dock.</li>
			<li>Docked ships can be sent away after <b>[TRADE_SHIP_SEND_AWAY_GRACE / 600]</b> minutes, or immediately if their Favor target has already been met.</li>
			<li>The pier holds <b>[TRADE_SHIP_DOCK_SPOTS_BASE]</b> ships by default, upgradeable to <b>[TRADE_SHIP_DOCK_SPOTS_MAX]</b> by renting an extra pier with Favor.</li>
		</ul>

		<h3>Saturation</h3>
		<ul>
			<li>Each market bucket has a mammon-denominated warehouse pool. Goods sold through the Navigator (or bought against demand) fill or drain the pool. Capacity is rerolled each round and scales with population.</li>
			<li>A full pool refuses further intake for that bucket until it drains.</li>
			<li>A parallel Black Market pool runs at a fraction of the normal capacity and regenerates automatically each day.</li>
		</ul>

		<h3>Send-off outcomes</h3>
		<p>Every ship docks with an expected Favor target scaled by tonnage.</p>
		<ul>
			<li><b>Honored</b> (favor earned meets or exceeds target): full value banked as Favor, and the spent hail is refunded.</li>
			<li><b>Partial</b> (sent away early or auto-hailed): reduced Favor, no hail refund.</li>
			<li><b>Dishonored</b> (auto-dismissed well below target): a flat Favor penalty scaled by tonnage.</li>
		</ul>

		<h3>Favor spending</h3>
		<p>Accumulated Favor unlocks Company Gnomes automation for Silverface's margin, an extra pier, and an Auto-Hailer that hails and dismisses ships automatically while you're away. The Favor ledger and current/high-water totals are visible on the Harbor tab.</p>
		</div>
	"}


/datum/book_entry/treasury_merchant/kinship
	name = "05. The Kinship Bonus"

/datum/book_entry/treasury_merchant/kinship/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>KINSHIP BONUS:</b> A modifier tied to the active Merchant's chosen origin. While a Merchant from a foreign realm sits the role, ships of that realm show up more often, buy higher, and sell lower.</p>

		<h3>What it does</h3>
		<ul>
			<li><b>-[round((1 - KINSHIP_BUY_MULT) * 100)]% on buys</b> from kin ships - bulk cargo at Goldface and cultural-stock packs both pay less.</li>
			<li><b>+[round((KINSHIP_SELL_MULT - 1) * 100)]% on sells</b> when fulfilling kin realm ships' bulk demands at the Ship Fulfillment Crate.</li>
			<li>The sell-side bonus is <b>global</b> - any producer fulfilling a kin ship's demand gets it, not just the Merchant.</li>
		</ul>

		<h3>How it gets set</h3>
		<ul>
			<li>The bonus follows the active Merchant's character origin. It persists through Merchant death or FT until a new Merchant of a different realm takes the role.</li>
			<li>A Merchant of the same realm replacing the previous one does not flip the bonus.</li>
		</ul>

		<h3>Agent variant</h3>
		<p>A Shophand, or an Agent holding the Merchant's Writ of Charter, gets a personal buy discount from ships of <b>their own</b> character origin, at Goldface only. This does not stack with the global Kinship bonus if both apply to the same ship.</p>
		</div>
	"}


/datum/book_entry/treasury_merchant/avisa_market
	name = "06. The Market on the Notice Board"

/datum/book_entry/treasury_merchant/avisa_market/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>MARKET VIEW:</b> The Notice Board carries a live Market view alongside its postings - the same view you're reading this guide from. It refreshes on demand and shows regional stockpile and trade conditions relevant to producers and traders.</p>
		</div>
	"}


/datum/book_entry/treasury_merchant/escrow
	name = "07. COMMISSIONER"

/datum/book_entry/treasury_merchant/escrow/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>COMMISSIONER:</b> The COMMISSIONER lets anyone post a smithing, engineering, or tailoring commission with coin held in trust until a guild member delivers the finished items. Posted orders can be released, cancelled, partially settled, or rejected.</p>

		<h3>Posting an order (commissioner side)</h3>
		<ul>
			<li>Deposit coin into the machine - the deposit is held under your name.</li>
			<li>Build a manifest from the catalogue. Each recipe's unit price is its material cost times (1 + percent_margin/100) plus flat_margin - defaults are <b>70%</b> percent margin and <b>5m</b> flat margin, adjustable by whoever holds the guild key.</li>
			<li>You can refund an unposted deposit at any time. Posted but unclaimed orders can be cancelled for a full refund.</li>
			<li>Open orders expire after <b>[ESCROW_OPEN_EXPIRY_DAYS]</b> day(s) if unclaimed; the deposit returns to your reservation.</li>
		</ul>

		<h3>Claiming and fulfilling (smith side)</h3>
		<ul>
			<li>Only guild keyholders may claim an order.</li>
			<li>Deliver finished items by striking the machine with them. Items must be at least <b>[ESCROW_DURABILITY_FLOOR * 100]%</b> integrity and the exact type requested.</li>
			<li>A smith may voluntarily release a claim back to open status; delivered items return to the floor.</li>
			<li>Claimed orders expire after <b>[ESCROW_CLAIM_EXPIRY_DAYS]</b> day(s) if not completed; the order auto-reverts to open.</li>
		</ul>

		<h3>Partial fulfillment</h3>
		<p>If the smith has delivered some but not all of the required items, they may settle partially for a payout reduced by a <b>[ESCROW_PARTIAL_HAIRCUT_PERCENT]%</b> haircut against their progress share. The unspent escrow returns to the commissioner's deposit.</p>

		<h3>Guild-key controls</h3>
		<p>Unlocked with the guild key: per-material price editing, percent margin, flat margin, per-order item cap, and force-release of stalled claimed orders, plus rejecting any open or claimed order with a stated reason.</p>
		</div>
	"}


/datum/book_entry/treasury_merchant/rag_picker
	name = "08. The Scrapper"

/datum/book_entry/treasury_merchant/rag_picker/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>SCRAPPER:</b> A machine that pays coin immediately for scrap and cast-off materials it has been set up to accept. Bring it items matching its enabled material list and it weighs the offer and pays out from its own budget on the spot. It starts with a <b>50m</b> seed budget; once that runs dry, new mammon must be deposited before it can keep paying.</p>
		<p>The proprietor role for a given Scrapper sets its rates, enables or disables specific materials, and can adjust the machine as needed.</p>
		</div>
	"}
