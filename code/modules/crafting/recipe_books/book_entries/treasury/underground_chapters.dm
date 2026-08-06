// Economy 3 guidebook — Underground chapter. Ported from Azure-Peak PR #7000
// (apsrc/main, code/modules/crafting/recipe_books/book_entries/treasury/underground_chapters.dm)
// with content adjusted to what Emerald Summit actually implements.
//
// AP describes two separate machines (BRASSFACE the bathhouse-only vendor, and PURITY as its
// public reflavor). ES only has PURITY (code/modules/roguetown/roguemachine/drugmachine.dm) -
// a single nightman-keyed vendor, pre-existing in ES before this port and not renamed. There is
// no "Ordinance" (Church/Bathhouse non-interference agreement) system anywhere in ES - cut that
// section rather than invent lore for an agreement that isn't implemented.

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
		</ul>
		</div>
	"}
