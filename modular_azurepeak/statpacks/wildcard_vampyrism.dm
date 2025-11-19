// Custom clan base for Crimson-Blooded statpack
/datum/clan/crimson_blood
	name = "Crimson Blood"
	desc = "Those cursed with crimson blood are neither fully vampire nor fully mortal."
	selectable_by_vampires = FALSE
	covens_to_select = 1
	clane_traits = list(
		TRAIT_VAMPBITE,
		TRAIT_NOBREATH,
		TRAIT_TOXIMMUNE,
		TRAIT_NOSLEEP,
		TRAIT_VAMP_DREAMS,
		TRAIT_DARKVISION,
		TRAIT_LIMBATTACHMENT,
		TRAIT_SILVER_WEAK,
	)

// Global lore primer verb accessible to everyone in lobby
/mob/dead/new_player/verb/read_crimson_lore_primer()
	set name = "Vampyrism Lore"
	set category = "Memory"
	set desc = "Read the full lore of the Sanguine Curse and Vampyrism"
	
	var/lore_text = {"<body style='background-color: #1a1a1a; color: #d4af37; font-family: serif; padding: 20px;'>
<center><h1 style='color: #8b0000; text-shadow: 2px 2px 4px #000000;'>The Sanguine Curse</h1>
<h3 style='color: #c0c0c0;'>A Primer on the Origin of Vampyrism within Grimoria</h3></center>
<hr style='border-color: #8b0000;'>

<h2 style='color: #dc143c;'>Preamble</h2>
<p>The Fall of Psydon did not merely shatter the celestial order; it poisoned the very wellspring of life. This document details the heretical and tragic genesis of the Vampyr, a blight born not from Zizo's Rot, but from the dying breath of the All-Father Himself. While the Holy See & Diecian Council decries them as another facet of the Second Rot, we who study the deeper truths understand their unique and terrible origin.</p>

<h2 style='color: #dc143c;'>The Corpse-Light of a Dead God</h2>
<p>When Psydon was struck down by Zizo's spear of entropy, His divine essence did not simply vanish. A god of Life and Creation cannot die a clean death. His lifeblood, a liquid light known as the <b style='color: #c0c0c0;'>Argentum</b>, spilled from the Celestial Throne and fell across the world like a rain of dying stars.</p>

<p>Most of this sacred blood dissipated, returning to the aether. Some coalesced into the comet shards now sought by Ascendants. But a portion, tainted by the necrotic energy of Zizo's blow and mingled with the profound despair of the murder itself, underwent a terrible transformation. This corrupted essence, no longer Argentum but <b style='color: #8b0000;'>Sanguine Noctis</b>—the "Blood of Night"—seeped into the deepest, darkest places of Grimoria.</p>

<h2 style='color: #dc143c;'>The First Sire: The Naledi Sacrifice</h2>
<p>It was the Naledi, the famed war-scholars who first mastered the arcane under Noc's tutelage, who discovered this blight. In the final, desperate century of the war against Zizo, a cabal of their most brilliant arcanists, led by the revered <b>Archmagister Valerius</b>, performed a ritual of last resort.</p>

<p>Knowing Psydon had been murdered, they sought to create a new, permanent source of power to fuel their armies: a weapon to rival the Rot itself. Using their deep, Noc-gifted knowledge of celestial mechanics, they pinpointed a location where a concentrated stream of the All-Father's life-force was predicted to fall: the <b style='color: #4b0082;'>Umbra Chasm</b>, a deep fissure already rich with latent arcane energy.</p>

<p>They were correct in their calculations but tragically naive in their understanding. They did not catch a pure stream of Argentum. Instead, their grand ritual siphoned the falling, corrupted blood of the Sanguine Noctis directly into their focusing apparatus, and by extension, into themselves.</p>

<p>Valerius and his cabal were not consumed; they were infused. They felt the divine power of Psydon first as a torrent of creation and boundless life. Then came the crushing weight of the All-Father's murder: the betrayal, the abandonment, the infinite void. Finally, they felt Zizo's Rot, the entropic curse that sought to unmake all things. These three forces—Life, Death, and Decay—warred within their souls, and in their terrible equilibrium, a new state of being was forged. The ultimate arcane sacrifice had not saved their people; it had birthed a new race of predators.</p>

<p>And from this amalgamation of twisted divine power and mortal hubris, what we know as Vampyrs came into existence. With this, a two-pronged problem became absolute reality within Naledi. For when the War-Scholars obtained this power from the Umbra Chasm itself, they unleashed the Djinn who had been laid dormant for centuries. And because of those who would seek to obtain absolute power and longevity, their once mighty island kingdom fell into disarray and continues even to this day to fight back against the errors made by Valerius.</p>

<h2 style='color: #dc143c;'>The Tenets of the Curse</h2>
<p>The Naledi arcanists emerged from the Umbra Chasm no longer men, but the First Vampyrs. They were creatures of paradox, and their condition laid the foundation for all their get:</p>

<p><b style='color: #ffd700;'>The Thirst for Life:</b> Having been filled with the essence of a dead god, a Vampyr exists in a state of perpetual divine deficit. They must consume the living Argentum—the latent spark of Psydon's creation found in mortal blood—to fuel the arcane machinery of their own cursed existence. They are scholars eternally studying the text of life, forced to tear out its pages to read them.</p>

<p><b style='color: #ffd700;'>Aversion to the Sun (Astrata's Scorn):</b> The Vampyr is a creature born of a god-killing night, the ultimate failure of the old order. The sun, Astrata's domain, represents the absolute law and purity that their Naledi intellect sought to bypass. Its pure, righteous light is an anathema to their corrupted, death-touched nature, causing their form to burn as if in retribution for their arcane hubris.</p>

<p><b style='color: #ffd700;'>The Sacred and The Profane:</b> As their being is partly composed of Psydon's essence, symbols of true, unwavering faith in the All-Father can cause a Vampyr physical pain, as it forces them to confront the holy thing they sought to harness and defiled in the process. Their Noc-given knowledge is now a curse, reminding them of the divinity they have irrevocably corrupted.</p>

<p><b style='color: #ffd700;'>The Stillness of the Grave (Necra's Ire):</b> The Undermaiden sees the Vampyr as the ultimate transgression. They are souls trapped in dead-but-undying flesh, forever outside her cycle of rebirth. Her faithful, the Morticians, are the most zealous hunters of the Vampyr, for they represent a permanent stain on the natural order created by mortal arrogance.</p>

<h2 style='color: #dc143c;'>The Original Broken Lineages</h2>
<p>From the Naledi cabal the curse spread out en masse, manifesting differently based on the mortal soul it corrupted, often reflecting the original structures of Naledi society.</p>

<p><b style='color: #9370db;'>The Nocturni (Valerius's Get):</b> The original Naledi lineage from the outset of the Scarlet Outbreak. Pale, aristocratic, and eternally tormented by their intellectual folly. They possess a cold, calculating demeanor and wield a twisted form of the arcane, now fueled by blood. They control their thirst with the rigid discipline of a scholar.</p>

<p><b style='color: #9370db;'>The Moroi (The Sanguine Circle):</b> Naledi arcanists and citizens who were part of the cabal's more hedonistic fringe, who saw the ritual as a path to transcend mortal limits. They are emotional and sensation-driven, treating the curse as a gift of eternal life and heightened experience, but are prone to frenzies and terrible rage when their passions overwhelm them.</p>

<p><b style='color: #9370db;'>The Nameless (The Broken Chorus):</b> Not of pure Naledi blood, these are the results of early, failed experiments by the First Sires to create servant races. The curse merged imperfectly with base mortal stock or other creatures, creating a bestial, deformed lineage that dwells in sewers and ruins, their forms reflecting the raw, destructive decay of the Sanguine Noctis.</p>

<h2 style='color: #dc143c;'>The Schism of Blood: Naledi Purists vs. Zizo's Get</h2>
<p>The tragedy of the Crimson Outbreak was not the end of the Vampyr's story, but the beginning of a bitter civil war that fractures their kind to this day. The original Naledi lineages, who call themselves the "<b>Crimson Legacy</b>" or "<b>Purists</b>," see themselves as the true inheritors of the Curse—a tragic, but intellectually significant state of being born from a divine event. However, a new, heretical strain of Vampyrism now challenges this identity, created not by divine accident, but by deliberate, necromantic artifice.</p>

<h3 style='color: #ff4500;'>The Heresy of the Made-Vampyr</h3>
<p>Following her ascension, the God-Head Zizo perceived the Purists not as kin, but as a resource. To her, they were a fascinating, pre-existing corruption of her father's work, a template to be improved upon. Using her mastery over the Rot and left-handed magicks, Zizo and her most powerful necromancer disciples learned to replicate the Vampyric condition, bypassing the Sanguine Noctis entirely.</p>

<p>These "<b>Hollowed</b>" or "<b>Zizo's Get</b>" are not born from the corrupted blood of a god, but from a ritualistic infusion of concentrated Rot and necromantic energy into a mortal vessel. The process is a brutal mockery of the Naledi ritual:</p>

<p><b>No Divine Spark:</b> Where the Purists are powered by a corrupted fragment of Psydon's life, the Hollowed are animated by Zizo's death-energy. They lack the underlying divine "echo" that defines the Purist existence.</p>

<p><b>The Hollow Thirst:</b> Their need for blood is not to sate a divine deficit, but to fuel the necromantic spell that binds their soul to a decaying body and to spread the Rot. Their bite often carries a more virulent, wasting form of the curse that's rapidly creating lesser undead or feral spawn.</p>

<p><b>No Scholarly Torment:</b> They feel no pain from symbols of Psydon, for they never contained His essence. They do not mourn the light; they seek to extinguish it. Their aversion to the sun is purely a function of their necrotic composition clashing with Astrata's pure, life-affirming light.</p>

<h3 style='color: #ff4500;'>The Ideological War</h3>
<p>This fundamental difference in origin has ignited a cold war within the shadows of Grimoria:</p>

<p><b>The Purist View (The Crimson Legacy):</b> The Purists see the Hollowed as abominations—crude, soulless puppets mimicking their own cursed nobility. To a Nocturni, the Hollowed are the ultimate philistines, possessing the form without the profound, tragic understanding. They are a walking blasphemy that cheapens the "divine accident" of their own creation. The Moroi, despite their hedonism, see the Hollowed as lacking the sensual depth of a true Curse, their existence a shallow, single-note hunger.</p>

<p><b>The Hollowed View (Zizo's Get):</b> The Hollowed view the Purists as self-pitying relics, shackled by a dead god's memory. They see their own condition as an evolution—a purer, more focused form of vampyrism, unburdened by theological paradox or sentimental grief. They serve a living, active god with a clear purpose: the unmaking of the old world and the dawn of Zizo's new age. They often hunt Purists aggressively, seeing them as valuable, pre-powered vessels to be captured and "converted" through necromantic rites that burn out the last traces of Psydon's Argentum.</p>

<h3 style='color: #ff4500;'>The Practical Conflict</h3>
<p>This schism manifests in tangible ways:</p>

<p><b>Territorial Disputes:</b> Cities often have a hidden Purist court and a separate, aggressive Hollowed nest, both vying for control of the same mortal cattle and underground resources.</p>

<p><b>Hunting Grounds:</b> The Purists' disciplined, secretive feeding is disrupted by the Hollowed's tendency to create public massacres and waves of lesser undead, drawing the attention of Ravoxian templars and Necran morticians upon all Vampyr-kind.</p>

<p><b>The War of Spawn:</b> A Purist's embrace, while still a curse, creates a fledgling with a connection to the Crimson Legacy. A Hollowed's embrace creates a mindless spawn or a loyal servant to Zizo, diluting the Purist bloodlines and threatening their very existence.</p>

<p>Thus, the Vampyr is forever at war on two fronts: against the world that hates them, and against the heretical mirror-image that seeks to consume and replace them.</p>

<h2 style='color: #dc143c;'>The Arcanum of Blood</h2>
<p>Vampyrism at the end of the day is not a simple curse from Zizo. It is a divine catastrophe, channeled through mortal ambition. Every Vampyr is in some way or shape a living relic of Psydon's murder. A scholar eternally studying the text of a dead god's power, forced to consume the legacy of the very life their intellect failed to save. Or an uplifted cursed individual, a tool by Zizo to spread her Rot across Grimoria one individual at a time. They are all the unwanted heirs of a dead god's power, forever cursed to mourn the light their knowledge can no longer bear. Sustained only by the fading echoes of the creation they sought to master and ultimately defiled.</p>

<p><i>They are, in the most tragic sense, the final, damning thesis of the Naledi war-scholars.</i></p>
<hr style='border-color: #8b0000;'>
<center><p style='color: #666;'><i>This knowledge is forbidden. Share it wisely.</i></p></center>
</body>"}
	
	usr << browse(lore_text, "window=crimson_lore;size=800x600;title=The Sanguine Curse")