// Economy 3 guidebook — Underground chapter. Ported from Azure-Peak PR #7000
// (apsrc/main, code/modules/crafting/recipe_books/book_entries/treasury/underground_chapters.dm)
// with content adjusted to what Emerald Summit actually implements.
//
// Ratwood has both bathhouse machines, though split differently from AP: BRASSFACE is the
// bathhouse goods vendor (merchant/bathmaster.dm) and PURITY the vice vendor (drugmachine.dm),
// each its own machine rather than AP's public-reflavor subtype. The Ordinance of the Baths is
// live as of the wiring audit: while in force, both machines' tariffs divert to the Church as a
// tithe, and the Bathhouse Vault's income is tithed as well; Bishop or Bathmaster toggles it at
// a Nervelock.

/datum/book_entry/treasury_underground
	abstract_type = /datum/book_entry/treasury_underground
	category = "Underground"

/datum/book_entry/treasury_underground/black_market
	name = "01. The Black Market"

/datum/book_entry/treasury_underground/black_market/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>BLACK MARKET:</b> Merchant letting you down? The Black Market is your friend! Walk out to the black market ruin and use the suspicious Navigator there - it pays out at a much steeper cut than the honest kind, but it asks no questions about where the goods came from.</p>

		<h3>PURITY</h3>
		<ul>
			<li>A contraband vendor, roundstart-locked by the <code>nightman</code> key. Anyone else needs the key or a successful lockpick.</li>
			<li>Sells vice goods (drugs, smokes, and similar) not carried on the ordinary GOLDFACE/SILVERFACE category list.</li>
			<li>Its sibling, BRASSFACE, is the bathhouse goods vendor under the same key, selling alcohols, apparel, instruments and other comforts.</li>
		</ul>

		<h3>The Ordinance of the Baths</h3>
		<ul>
			<p>The Church and the Bathhouse hold an agreement: the Bathhouse trades under the Church's sanction and protection, and in exchange a tithe of the stews' commerce renders unto the Church. While the Ordinance is in force, the Crown's import tariff on BRASSFACE and PURITY sales is diverted to the Church, and a share of the Bathhouse Vault's income follows it. Either the Bishop or the Bathmaster may break or restore the seal at a Nervelock, for any reason or none; broken, the stews fall back beneath the Crown's tariff.</p>
		</ul>
		</div>
	"}
