/datum/book_entry/fishing1
	name = "Chapter I: Rods"
	category = "Fishing"

/datum/book_entry/fishing1/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Choosing a Rod:</h2>
	Every rod sets a baseline handling difficulty and rarity bias before you even attach tackle. Durability decides how much abuse it takes before it needs repairs, or breaks outright.
	<table border='1' cellpadding='4' cellspacing='0'>
		<tr><th>Rod</th><th>Fight Ease</th><th>Rarity Bias</th><th>Durability</th><th>Repaired With</th></tr>
		<tr><td>Fishing Rod (base)</td><td>Neutral</td><td>None</td><td>100</td><td>Crafting + hammer</td></tr>
		<tr><td>Iron Fishing Rod</td><td>Easier</td><td>None</td><td>200 (tough)</td><td>Blacksmithing + hammer</td></tr>
		<tr><td>Decrepit Fishing Rod</td><td>Harder</td><td>Common down, Rare up</td><td>50 (fragile)</td><td>Blacksmithing + hammer</td></tr>
		<tr><td>Blacksteel Fishing Rod</td><td>Harder</td><td>Common down, Rare up</td><td>500 (very tough)</td><td>Crafting + hammer</td></tr>
	</table>
	<p>
		The starter rod given to most fishermen comes already rigged with a silk line, an iron hook, and a wooden bobber - a safe, balanced way to learn.
	</p>
	<p>
		The iron rod is the easy-mode workhorse: easier fights and excellent durability, but no bonus toward rarer catches. The decrepit and blacksteel rods both trade harder fights for better rarity odds - blacksteel is the one to reach for if you want that edge without the decrepit rod's fragility.
	</p>
	</div>
	"}

/datum/book_entry/fishing2
	name = "Chapter II: The Reel"
	category = "Fishing"

/datum/book_entry/fishing2/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Line Strength & Reels:</h2>
	The reel governs your line's toughness - how much error you can afford in the reeling struggle before it snaps - and often your fight ease as well.
	<table border='1' cellpadding='4' cellspacing='0'>
		<tr><th>Reel</th><th>Line Toughness</th><th>Fight Ease</th><th>Bite Modifier</th><th>Durability</th></tr>
		<tr><td>Twine</td><td>+5</td><td>Harder</td><td>-</td><td>50</td></tr>
		<tr><td>Leather</td><td>+8</td><td>-</td><td>-3</td><td>100</td></tr>
		<tr><td>Silk</td><td>+10</td><td>Easier</td><td>-</td><td>120</td></tr>
		<tr><td>Deluxe</td><td>+14</td><td>Easier</td><td>+3</td><td>150</td></tr>
	</table>
	<p>
		Twine is cheap but weak, and its stiffness makes a fight harder to boot. Leather is sturdier, but the line's visibility spooks fish, shortening the bite window. Silk is the reliable middle ground. Deluxe line is superior in every respect - if you can get your hands on some.
	</p>
	</div>
	"}

/datum/book_entry/fishing3
	name = "Chapter III: Hooks"
	category = "Fishing"

/datum/book_entry/fishing3/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Hooks:</h2>
	The hook you use mainly affects bite timing and fight ease, though the finer ones can bias what size or rarity of fish you land.
	<ul>
		<li><b>Wooden Hook</b> - Weak all-round. Harder fights, worse bite timing, and it actively steers you away from deep-water catches.</li>
		<li><b>Thorn Hook</b> - Fragile, and surprisingly punishing - it makes fights noticeably harder despite its bite.</li>
		<li><b>Iron Hook</b> - Simple and reliable. No drawbacks. Comes standard on most fishermans rods.</li>
		<li><b>Steel Hook</b> - A clean upgrade over iron: easier fights, a better bite window, and tougher line.</li>
		<li><b>Deluxe Lure Hook</b> - Built for trophy fishing. Strongly favors landing bigger, rarer fish, at the cost of a harder fight. It carries two barbs, and when fished with proper bait has a chance to hook a <i>second</i> fish on the same cast.</li>
	</ul>
	<p>
		A curious trick of the trade: meat bait fished on an iron, steel, or deluxe hook is known to occasionally draw up octopus from the depths - a combination not obvious from any single piece of tackle alone.
	</p>
	</div>
	"}

/datum/book_entry/fishing4
	name = "Chapter IV: Bobber or Sinker"
	category = "Fishing"

/datum/book_entry/fishing4/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Bobber vs. Sinker:</h2>
	This piece decides <i>where</i> you fish best.
	<h3>Wooden Bobber</h3>
	<ul>
		<li>Generous bite window.</li>
		<li>Steers away from deep-water species.</li>
		<li>Consistent bite bonus no matter how far out you are.</li>
	</ul>
	Best for general-purpose fishing at any distance from shore.
	<h3>Stone Sinker</h3>
	<ul>
		<li>Pulls the hook toward deep-water species.</li>
		<li>Biases toward smaller fish - easier, shorter fights as a result.</li>
		<li>Strong bite bonus close to shore, but loses its edge in open water.</li>
		<li>Slower to cast and slower to reel in.</li>
		<li>Lets you fish close to shore without the water turning up almost nothing but junk.</li>
	</ul>
	<p>
		The sinker is the near-shore specialist - it's what makes fishing close to the bank worthwhile at all. The bobber is the generalist that keeps performing the farther out you go. The only other way to fish the shallows properly is fly bait, which cannot be used with either piece.
	</p>
	</div>
	"}

/datum/book_entry/fishing5
	name = "Chapter V: Bait"
	category = "Fishing"

/datum/book_entry/fishing5/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Bait:</h2>
	Bait shapes your bite chance, widens which species you're eligible to catch, and leans the size and rarity of what comes up.
	<table border='1' cellpadding='4' cellspacing='0'>
		<tr><th>Bait</th><th>Bite Chance</th><th>Size Lean</th><th>Catch Lean</th></tr>
		<tr><td>No Bait</td><td>Heavy penalty</td><td>Forces tiny</td><td>Forces common</td></tr>
		<tr><td>Dough</td><td>Neutral</td><td>Neutral</td><td>Slight common bump</td></tr>
		<tr><td>Gray Bait</td><td>Bonus</td><td>Neutral</td><td>Common up, Danger down</td></tr>
		<tr><td>Meat/Chum</td><td>Neutral</td><td>Slight normal/large bump</td><td>Common & Danger up, Rare & Treasure down</td></tr>
		<tr><td>Fly Bait</td><td>Best bonus (no bobber/sinker allowed)</td><td>Favors small/normal, then tiny</td><td>Rare up, Common/Treasure/Junk down. Draws in salmon, black bass, sturgeon, mackerel and bass</td></tr>
		<tr><td>Speckled</td><td>Neutral</td><td>Favors huge/prize</td><td>Rare & Treasure up, pulls in deep-water species</td></tr>
		<tr><td>Enchanted</td><td>Bonus</td><td>Favors large/huge/prize</td><td>Rare & Treasure up, chance of a guaranteed special catch</td></tr>
	</table>
	<h3>Fly Bait</h3>
	<p>
		Fly bait is the angler's bait. It demands the hook be fished bare of any bobber or sinker, and in exchange gives the best raw bite chance available and lets you fish close to shore without the water turning to junk. It favors smaller, livelier fish over trophies.
	</p>
	<ul>
		<li><b>Rivers and fresh water:</b> Salmon, black bass, and now and then a sturgeon.</li>
		<li><b>The sea:</b> Mackerel, black-headed salmon, and seabass. The freshwater fish will not bite in salt water.</li>
	</ul>
	<p>
		Whatever it draws in is added to what the water already holds, so it nudges your odds rather than replacing them. Salmon are best hunted in fresh water, where fly bait makes them a real share of your catches.
	</p>
	<p>
		Enchanted bait carries a rare but real chance, on any given bite, to force something extraordinary onto the hook outright - a prize-sized catch, a rarity beyond gold, or a specific coveted fish - bypassing the usual odds entirely. Expect a much harder fight when it happens.
	</p>
	<p>
		Simple worms remain a renewable, easy option, and certain bait is known to draw out small vermin rather than fish entirely.
	</p>
	</div>
	"}

/datum/book_entry/fishing6
	name = "Chapter VI: Reading Your Rig"
	category = "Fishing"

/datum/book_entry/fishing6/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Reading Your Rig:</h2>
	When you examine an assembled rod, it will summarize the combined effect of everything attached to it. Here is what each line means:
	<ul>
		<li><b>Line Toughness</b> - Your margin for error while fighting a fish. Every mistake costs you some; run out and the line snaps.</li>
		<li><b>Bite Modifier</b> - How long you have to react before a bite is missed entirely.</li>
		<li><b>Fight Ease</b> - Lower is easier. Governs how wildly the fish struggles against you.</li>
		<li><b>Depth Pull</b> - Not a strength stat - it governs how much your tackle reaches toward deep-water species, regardless of the fight itself.</li>
		<li><b>Rarity Chance</b> - Biases the roll between common, rare, ultra, and gold catches.</li>
		<li><b>Size Bias</b> - Biases the roll between tiny and prize-sized catches. Bigger sizes also mean harder, longer fights.</li>
	</ul>
	</div>
	"}

/datum/book_entry/fishing7
	name = "Chapter VII: Where the Fish Are"
	category = "Fishing"

/datum/book_entry/fishing7/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Where the Fish Are:</h2>
	What you catch depends first on the water itself, then on your bait and how far you've cast from shore. Fish are listed most common first.
	<table border='1' cellpadding='4' cellspacing='0'>
		<tr><th>Water</th><th>Common Catches</th><th>Less Common</th></tr>
		<tr><td>Swamp</td><td>Eel, Mudskipper, Swamp Shrimp, Carp</td><td>Swamp Mother</td></tr>
		<tr><td>Deep Swamp</td><td>Swamp Shrimp, Eel, Mudskipper, Carp, Swamp Mother</td><td>Crawfish, Zizo Aberration</td></tr>
		<tr><td>Clean Shallows</td><td>Sunny, Carp, Eel (mostly junk regardless of gear)</td><td>-</td></tr>
		<tr><td>River</td><td>Carp, Sunny, Eel</td><td>Sturgeon</td></tr>
		<tr><td>Ocean</td><td>Cod, Sole, Bass, Flounder, Mackerel</td><td>-</td></tr>
		<tr><td>Deep Ocean</td><td>Plaice, Cod, Lobster, Angler</td><td>Things that should stay below (see below)</td></tr>
	</table>
	<p>
		Salmon, black bass and sturgeon-in-quantity are not on the table above because the water rarely offers them on its own. They come from bait, and fly bait in particular.
	</p>
	<h3>How far out for the big ones?</h3>
	<p>
		Casting closer than a few paces from the shoreline works against you - expect junk and the smallest, most common fish, unless you're fishing with a sinker or fly bait.
	</p>
	<p>
		Push out several meters from shore, over water that runs genuinely deep, and without open sky blotting things out, and the odds swing hard the other way - bigger, rarer catches become common. In the sea, this pulls up deep-dwelling species: Angler, Lobster and Beaksnapper, and, for those favored by Abyssor, the horrors of the deep, Abyssal creatures.
	</p>
	<p>
		Deep pull only pays off in salt water. In rivers, shallows and swamps, reaching for depth mostly improves the size and rarity of what you catch.
	</p>
	<p>
		Chummed waters shift things further still toward the deep and away from the mundane. Tackle and bait that reach for depth all stack together, so gear with a poor depth pull will need correspondingly more distance from shore before deep fish begin to bite.
	</p>
	</div>
	"}

/datum/book_entry/fishing8
	name = "Chapter VIII: Chumming and Nets"
	category = "Fishing"

/datum/book_entry/fishing8/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Chumming and Nets:</h2>
	A net will do nothing until either it or the water it's cast into has been chummed. Casting a chum-soaked net into open water also chums that spot for the future.
	<p>
		Once set, a net fishes on its own over time, filling up with catches rather than yielding just one - but it can only hold so much before it tears apart and spills everything back into the water. Skilled fishermen see their nets fill with better odds at rare hauls, though a net cast too close to shore will mostly turn up junk no matter whose skill tends it.
	</p>
	<p>
		Retrieving a full net takes real effort - hauling on its line in stages, more so the heavier the catch, and a poorly-timed or overloaded haul can tear the net or leave you empty-handed. Needle and thread mend a torn net, the same way a hammer mends a rod.
	</p>
	<p>
		Nets reward patience and volume over precision - you trade away any say in exactly what you catch, in exchange for filling your stores while your hands are free for other work.
	</p>
	</div>
	"}

/datum/book_entry/fishing9
	name = "Chapter IX: Cage Fishing"
	category = "Fishing"

/datum/book_entry/fishing9/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Cage Fishing:</h2>
	A fishing cage is a different tool for a different catch - set for shellfish rather than fish proper.
	<p>
		Bait it with worms or a suitable morsel and set it into a living stretch of water. Given time - less with a practiced hand - it will yield a single catch, waiting patiently until harvested. A skilled fisherman's cage tends toward better hauls than a novice's.
	</p>
	<p>
		Every harvest wears the cage down, and it will eventually fall apart if pushed too far without repair. Left too long, its bait will also run dry and it will simply sit empty until re-baited.
	</p>
	<p>
		Of every method described here, the cage asks the least of your attention - set it, and return when it suits you.
	</p>
	</div>
	"}

/datum/book_entry/fishing10
	name = "Chapter X: A Fisherman's Summary"
	category = "Fishing"

/datum/book_entry/fishing10/inner_book_html(mob/user)
	return {"
	<div>
	<h2>A Fisherman's Summary:</h2>
	<ul>
		<li><b>Learning the ropes:</b> Iron rod, silk or deluxe line, iron or steel hook, bobber, plain bait.</li>
		<li><b>Fishing close to shore:</b> Use a sinker or fly bait. Without either you will pull up almost nothing but junk.</li>
		<li><b>Hunting salmon and black bass:</b> Fly bait on a bare hook, cast at a river or clean shallows.</li>
		<li><b>Hunting big, rare fish:</b> A sturdier rod, the finest line and hook you can find, a bobber, and bait suited to depth - cast well out over genuinely deep water.</li>
		<li><b>Chasing a guaranteed prize:</b> Enchanted bait, and the patience to weather the harder fight when your luck turns.</li>
		<li><b>Filling the stores with minimal fuss:</b> A chummed net, checked and hauled before it overflows.</li>
		<li><b>Steady, low-effort shellfish:</b> A baited cage, tended to now and again.</li>
	</ul>
	</div>
	"}
