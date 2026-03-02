/datum/book_entry/magic1
	name = "Chapter I: Gathering Materials"
	category = "Instructions"

/datum/book_entry/magic1/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Gathering Materials:</h2>
	To summon creatures and enchant items, you must gather the appropriate materials. This includes:
	<ul>
		<li> Manacrystals - Obtained from using prestidigitation on manafountains & spawn randomly around map</li>
		<li> Manabloom flowers - Randomly spawn in the swamp, can be grown,</li>
		<li> Obsidian shards - Obtained from using prestidigitation on lava turfs,</li>
		<li> Runed Artifacts - Can be randomly found in the swamp.</li>
		<li> Leyline Shards - inactive leylines spawn around the map. interact with them to activate them, and again to recieve a shard (Potentially getting attacked by a leyline lycan)</li>
	</ul>
	<p>
		Rumors has it that there is a mana fountain in the western part of the swamp, and a leyline in the eastern part of the swamp.
	</p>
	<p>
		Then you can use them to create various arcana items and summons, which can be used in turn to make Arcanic meld that unlock accesses to more powerful summons and enchantments.
	</p>
	</div>
	"}

/datum/book_entry/magic2
	name = "Chapter II: Binding Creatures"
	category = "Instructions"

/datum/book_entry/magic2/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Binding Creatures:</h2>
	Creatures you summon are SOULLESS AUTOMATONS, incapable of complex thoughts. A wise mage who wishes to make use of their services must
	bind them into services with a BINDING SHACKLES. Once binding shackles are made - one need only apply arcanic melds to them to strengthen the shackles.
	Such that more powerful creechurs can be binded. Binding shackles are split into five tiers, each tier able to bind a stronger creature.
	<ul>
		<li> Planar Binding Shackles - Tier 1 </li>
		<li> Greater Planar Binding Shackles - Tier 2 </li>
		<li> Woven Planar Binding Shackles - Tier 3 </li>
		<li> Confluent Planar Binding Shackles - Tier 4 </li>
		<li> Aberrant Planar Binding Shackles - Tier 5 </li>
	</ul>
	</div>
	"}

/datum/book_entry/circuitus1
	name = "Chapter I: The Fundamentals"
	category = "Circuitus"

/datum/book_entry/circuitus1/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Circuitus</h2>
	Every good magician must eventually graduate beyond relying upon the creations of other mages. And the desire to do so, presumably,
	is why you are reading this section of your grimoire. If one desires to break the bounds of one's spellbook, he must be steadfast and
	contemplative in his studies: The art of circuitus is not for the dim-witted or slothful.
	<BR>
	<BR>
	The foundation of this art is the 'incantation'. The magician must specify his intent in the ancient language of Psydonic. The arcane
	breaks no quarter in this, the incantation must illustrate exactly what is desired to be done. Here is an example: "Prospectus ignis!"
	<BR>
	This incantation (if one has the requisite knowledge of fireball) will launch a blast of flame before the magician's face. The incantation specifies this:
	<BR>
	<BR>
	Prospectus - Stores the position you are facing as a coordinate (which we store as X, Y) within the arcane. This is stored as an iota.
	<BR>
	Ignis! - A spell command. This takes the previously specified coordinate and performs the spell at its location. The spell, in this instance, being a fireball.
	<BR>
	<BR>
	All spell commands must be the final word of an incantation, and must be shouted (!) in order to take effect.
	<BR>
	<BR>
	Here is a list of spells and their associated commands. One must have knowledge of the spell to perform it in Circuitus.
	<ul>
		<li> Fireball - Ignis! </li>
		<li> Thunderstrike - Fulmen! </li>
		<li> Blink - Teleporto! </li>
		<li> Gravity - Pondus! </li>
		<li> Mending - Reficio! </li>
		<li> Repulse - Obmolior! </li>
		<li> Fetch - Recolligere! </li>
		<li> Forcewall - Murus! </li>
	</ul>
	</div>
	"}

/datum/book_entry/circuitus2
	name = "Chapter II: Iotas"
	category = "Circuitus"

/datum/book_entry/circuitus2/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Iotas</h2>
	The iota is what allows a mage to enact his will upon the material realm. It is an abstract pattern imprinted upon the arcane by the words of an incantation,
	required in the use of all spell commands. Here is a basic pattern that all apprentices should familiarize themselves with: "Ego Coordinatus."
	<BR>
	<BR>
	Ego - Command which refers to the self, it stores the caster (you!) as an iota.
	<BR>
	Coordinatus - Converts the currently stored iota into its coordinates in the material realm.
	<BR>
	Thus if a mage spoke, "Ego Coordinatus Ignis!" They would conjure a blast of flame upon themselves. But why would one ever wish to do that? Instead, you a mage
	perform the blast a bit further away from himself: "Ego Coordinatus Tres Inversus Mutos-Y Ignis!"
	<BR>
	<BR>
	Ego - Stores self as iota.
	<BR>
	Coordinatus - Obtains coordinates of current iota (self).
	<BR>
	Tres - Stores the number '3' as an iota. What happens to the previously stored iota? It still exists! It is simply covered by the new iota, pushed backwards. The
	previous iota can still be accessed by some commands and spells.
	<BR>
	Inversus - If the current iota is a number, this command transmutes it into a negative variation of itself. '3' becomes '-3'.
	<BR>
	Mutos-Y - This command takes two iotas. Coordinates and a number. This command modifies the coordinate iota by the number, which part of the coordinate is changed
	is specified by the command. Mutos-Y modifies the Y coordinate, whilst Mutos-X modifies the X coordinate. Mutos first takes the currently stored iota as the number
	to modify the coordinate by, then it stores the previous-most iota (the one stored before the number) as the coordinate to modify. It sets the currently stored iota
	as the newly modified coordinate.
	<BR>
	Ignis - This spell command takes the currently stored iota as the coordinate in which to perform a blast of flame.
	<ul>
		<li> Nulla - 0 </li>
		<li> Unus - 1 </li>
		<li> Duo - 2 </li>
		<li> Tres - 3 </li>
		<li> Quattuor - 4 </li>
		<li> Quinque - 5 </li>
		<li> Sex - 6 </li>
		<li> Septem - 7 </li>
	</ul>
	</div>
	"}

/datum/book_entry/ego
	name = "Ego"
	category = "Circuitus"

/datum/book_entry/ego/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Ego</h2>
	This stores the caster of the spell as an iota.
	</div>
	"}

/datum/book_entry/signum
	name = "Signum"
	category = "Circuitus"

/datum/book_entry/signum/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Signum</h2>
	This command receives a coordinate iota and provides a coordinate of the difference between it and the location which the spell was cast toward.
	(The tile clicked upon when casting the spell.)
	</div>
	"}

/datum/book_entry/coordinatus
	name = "Coordinatus"
	category = "Circuitus"

/datum/book_entry/coordinatus/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Coordinatus</h2>
	This command provides the coordinates of the current iota.
	</div>
	"}

/datum/book_entry/inspicio
	name = "Inspicio"
	category = "Circuitus"

/datum/book_entry/inspicio/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Inspicio</h2>
	This command informs you of what the current iota is.
	</div>
	"}

/datum/book_entry/locus
	name = "Locus"
	category = "Circuitus"

/datum/book_entry/locus/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Locus</h2>
	This command provides the ground beneath the current iota.
	</div>
	"}

/datum/book_entry/prospectus
	name = "Prospectus"
	category = "Circuitus"

/datum/book_entry/prospectus/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Prospectus</h2>
	This command provides the coordinate of the location right in front of you.
	</div>
	"}

/datum/book_entry/res
	name = "Res"
	category = "Circuitus"

/datum/book_entry/res/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Res</h2>
	This command provides a list of entities at the current iota coordinate.
	</div>
	"}

/datum/book_entry/obiectum
	name = "Obiectum"
	category = "Circuitus"

/datum/book_entry/obiectum/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Obiectum</h2>
	This command provides a list of items at the current iota coordinates.
	</div>
	"}

/datum/book_entry/manus
	name = "Manus"
	category = "Circuitus"

/datum/book_entry/manus/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Manus</h2>
	This command provides the current item in hand as an iota.
	</div>
	"}

/datum/book_entry/distantia
	name = "Distantia"
	category = "Circuitus"

/datum/book_entry/distantia/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Distantia</h2>
	This command provides the distance between two coordinates.
	</div>
	"}

/datum/book_entry/linea
	name = "Linea"
	category = "Circuitus"

/datum/book_entry/linea/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Linea</h2>
	This command receives two coordinates and provides a list of all coordinates between them.
	</div>
	"}

/datum/book_entry/addo
	name = "Addo"
	category = "Circuitus"

/datum/book_entry/addo/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Addo</h2>
	This command adds the current iota to a preceeding list iota.
	</div>
	"}

/datum/book_entry/removeo
	name = "Removeo"
	category = "Circuitus"

/datum/book_entry/removeo/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Removeo</h2>
	This command removes the current iota to a preceeding list iota.
	</div>
	"}

/datum/book_entry/extraho
	name = "Extraho"
	category = "Circuitus"

/datum/book_entry/extraho/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Extraho</h2>
	This command removes the last iota from a list and sets it as the current iota.
	</div>
	"}

/datum/book_entry/additus
	name = "Additus"
	category = "Circuitus"

/datum/book_entry/additus/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Additus</h2>
	This command adds two coordinate iotas together.
	</div>
	"}

/datum/book_entry/subtractus
	name = "Subtractus"
	category = "Circuitus"

/datum/book_entry/subtractus/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Subtractus</h2>
	This command subtracts two coordinate iotas together.
	</div>
	"}

/datum/book_entry/effingo
	name = "Effingo"
	category = "Circuitus"

/datum/book_entry/effingo/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Effingo</h2>
	This command provides a duplicate iota of the currently selected iota.
	</div>
	"}

/datum/book_entry/ruptis
	name = "Ruptis"
	category = "Circuitus"

/datum/book_entry/ruptis/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Ruptis</h2>
	This command provides a duplicate iota of the previous iota.
	</div>
	"}

/datum/book_entry/profundus
	name = "Profundus"
	category = "Circuitus"

/datum/book_entry/profundus/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Profundus</h2>
	This command receives a number iota and provides a duplicate iota of a previous iota, the number specifies the depth of the previous iota provided.
	</div>
	"}

/datum/book_entry/si
	name = "Si"
	category = "Circuitus"

/datum/book_entry/si/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Si</h2>
	This command receives a number iota and skips all commands until an 'alioquin' command if the number is equal to or less than 0.
	</div>
	"}

/datum/book_entry/alioquin
	name = "Alioquin"
	category = "Circuitus"

/datum/book_entry/alioquin/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Alioquin</h2>
	This command will resume command processing after a 'si' command if it fails to meet conditions.
	</div>
	"}

/datum/book_entry/iteratio
	name = "Iteratio"
	category = "Circuitus"

/datum/book_entry/iteratio/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Iteratio</h2>
	This command receives a list and iterates all subsequent commands per iota in the list, with that iota as currently selected iota.
	</div>
	"}

/datum/book_entry/nulla
	name = "Nulla"
	category = "Circuitus"

/datum/book_entry/nulla/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Nulla</h2>
	This command provides the number 0.
	</div>
	"}

/datum/book_entry/unus
	name = "Unus"
	category = "Circuitus"

/datum/book_entry/unus/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Unus</h2>
	This command provides the number 1.
	</div>
	"}

/datum/book_entry/duo
	name = "Duo"
	category = "Circuitus"

/datum/book_entry/duo/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Duo</h2>
	This command provides the number 2.
	</div>
	"}

/datum/book_entry/tres
	name = "Tres"
	category = "Circuitus"

/datum/book_entry/tres/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Tres</h2>
	This command provides the number 3.
	</div>
	"}

/datum/book_entry/quattuor
	name = "Quattuor"
	category = "Circuitus"

/datum/book_entry/quattuor/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Quattuor</h2>
	This command provides the number 4.
	</div>
	"}

/datum/book_entry/quinque
	name = "Quinque"
	category = "Circuitus"

/datum/book_entry/quinque/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Quinque</h2>
	This command provides the number 5.
	</div>
	"}

/datum/book_entry/sex
	name = "Sex"
	category = "Circuitus"

/datum/book_entry/sex/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Sex</h2>
	This command provides the number 6.
	</div>
	"}

/datum/book_entry/septem
	name = "Septem"
	category = "Circuitus"

/datum/book_entry/septem/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Septem</h2>
	This command provides the number 7.
	</div>
	"}

/datum/book_entry/lista
	name = "Lista"
	category = "Circuitus"

/datum/book_entry/lista/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Lista</h2>
	This command receives any non-list iota and turns it into a list of its type.
	</div>
	"}

/datum/book_entry/indicis
	name = "Indicis"
	category = "Circuitus"

/datum/book_entry/indicis/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Indicis</h2>
	This command receives a list iota and a number iota. It uses the number to select a specific index of the list and provides the iota within.
	If there is no current iota, it will provide an empty coordinate list.
	</div>
	"}

/datum/book_entry/lego
	name = "Lego"
	category = "Circuitus"

/datum/book_entry/lego/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Lego</h2>
	This command receives an item iota. The item must be a memory string. It provides the current iota stored on the memory string.
	</div>
	"}

/datum/book_entry/inversus
	name = "Inversus"
	category = "Circuitus"

/datum/book_entry/inversus/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Inversus</h2>
	This command receives a number iota and inverts it to its negative counterpart.
	</div>
	"}

/datum/book_entry/summa
	name = "Summa"
	category = "Circuitus"

/datum/book_entry/summa/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Summa</h2>
	This command adds two number iotas together.
	</div>
	"}

/datum/book_entry/multiplicatio
	name = "Multiplicatio"
	category = "Circuitus"

/datum/book_entry/multiplicatio/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Multiplicatio</h2>
	This command multiplies two number iotas together.
	</div>
	"}

/datum/book_entry/motus
	name = "Motus"
	category = "Circuitus"

/datum/book_entry/motus/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Motus</h2>
	This command adds a number iota to a coordinate iota. The coordinate iota must precede the number iota. The section of coordinate modified is
	dictated by this command's suffix. Motus-X modifies the X value. Motus-Y modifies the Y value. Motus-Z modifies the Z value.
	</div>
	"}

/datum/book_entry/regio
	name = "Regio"
	category = "Circuitus"

/datum/book_entry/regio/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Regio</h2>
	This command receives a number and coordinate. The number must precede the coordinate. It provides a list of coordinates in an area around the
	coordinate, in a radius equal to the number iota used.
	</div>
	"}

/datum/book_entry/homines
	name = "Homines"
	category = "Circuitus"

/datum/book_entry/homines/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Homines</h2>
	This command receives a coordinate. It provides a list of humens (or other sapient species) in an area equal to seven tiles around the coordinate.
	</div>
	"}

/datum/book_entry/ignis
	name = "Ignis!"
	category = "Circuitus"

/datum/book_entry/ignis/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Ignis!</h2>
	REQUIRES KNOWLEDGE OF FIREBALL TO USE.
	<BR>
	<BR>
	This spell command receives an (optional) number and coordinate. The number must precede the coordinate. It creates an explosion at the specified
	coordinate, its power modified by the number.
	</div>
	"}

/datum/book_entry/fulmen
	name = "Fulmen!"
	category = "Circuitus"

/datum/book_entry/fulmen/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Fulmen!</h2>
	REQUIRES KNOWLEDGE OF THUNDERSTRIKE TO USE.
	<BR>
	<BR>
	This spell command receives an (optional) number and coordinate. The number must precede the coordinate. It creates a lightning bolt at the specified
	coordinate, its power modified by the number.
	</div>
	"}

/datum/book_entry/teleporto
	name = "Teleporto!"
	category = "Circuitus"

/datum/book_entry/teleporto/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Teleporto!</h2>
	REQUIRES KNOWLEDGE OF BLINK TO USE.
	<BR>
	<BR>
	This spell command receives two coordinate iotas. Everything at the first coordinate (previous iota) is teleported to the second (current iota) coordinate.
	</div>
	"}

/datum/book_entry/pondus
	name = "Pondus!"
	category = "Circuitus"

/datum/book_entry/pondus/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Pondus!</h2>
	REQUIRES KNOWLEDGE OF GRAVITY TO USE.
	<BR>
	<BR>
	This spell command receives an (optional) number and coordinate. The number must precede the coordinate. It creates crushing gravity at the specified
	coordinate, its power modified by the number.
	</div>
	"}

/datum/book_entry/reficio
	name = "Reficio!"
	category = "Circuitus"

/datum/book_entry/reficio/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Reficio!</h2>
	REQUIRES KNOWLEDGE OF MENDING TO USE.
	<BR>
	<BR>
	This spell command receives an (optional) number and item iota. The number must precede the item. The item is mended, amount mended modified by number iota.
	</div>
	"}

/datum/book_entry/obmolior
	name = "Obmolior!"
	category = "Circuitus"

/datum/book_entry/obmolior/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Obmolior!</h2>
	REQUIRES KNOWLEDGE OF REPULSE TO USE.
	<BR>
	<BR>
	This spell command receives an (optional) number and coordinate. The number must precede the coordinate. It pushes away anything at the specified
	coordinate, its power modified by the number.
	</div>
	"}

/datum/book_entry/recolligere
	name = "Recolligere!"
	category = "Circuitus"

/datum/book_entry/recolligere/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Recolligere!</h2>
	REQUIRES KNOWLEDGE OF FETCH TO USE.
	<BR>
	<BR>
	This spell command receives an (optional) number and coordinate. The number must precede the coordinate. It pulls anything at the specified coordinate
	towards you, its power modified by the number.
	</div>
	"}

/datum/book_entry/murus
	name = "Murus!"
	category = "Circuitus"

/datum/book_entry/murus/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Murus!</h2>
	REQUIRES KNOWLEDGE OF FORCEWALL TO USE.
	<BR>
	<BR>
	This spell command receives a coordinate. An arcyne wall of force is created at the specified coordinate.
	</div>
	"}

/datum/book_entry/vis
	name = "Vis!"
	category = "Circuitus"

/datum/book_entry/vis/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Vis!</h2>
	REQUIRES KNOWLEDGE OF GIANT'S STRENGTH TO USE.
	<BR>
	<BR>
	This spell command receives (optionally) a number and an iota of a creature. The creature's strength will be enhanced by number given, to a limit of 3.
	Lasts for 20 seconds.
	</div>
	"}

/datum/book_entry/saxum
	name = "Saxum!"
	category = "Circuitus"

/datum/book_entry/saxum/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Saxum!</h2>
	REQUIRES KNOWLEDGE OF STONESKIN TO USE.
	<BR>
	<BR>
	This spell command receives (optionally) a number and an iota of a creature. The creature's constitution will be enhanced by number given, to a limit of 3.
	Lasts for 20 seconds.
	</div>
	"}

/datum/book_entry/festinatio
	name = "Festinatio!"
	category = "Circuitus"

/datum/book_entry/festinatio/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Festinatio!</h2>
	REQUIRES KNOWLEDGE OF HASTE TO USE.
	<BR>
	<BR>
	This spell command receives (optionally) a number and an iota of a creature. The creature's speed will be enhanced by number given, to a limit of 3.
	Lasts for 20 seconds.
	</div>
	"}

/datum/book_entry/oculi
	name = "Oculi!"
	category = "Circuitus"

/datum/book_entry/oculi/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Oculi!</h2>
	REQUIRES KNOWLEDGE OF HAWK'S EYE TO USE.
	<BR>
	<BR>
	This spell command receives (optionally) a number and an iota of a creature. The creature's perception will be enhanced by number given, to a limit of 3.
	Lasts for 20 seconds.
	</div>
	"}

/datum/book_entry/tenax
	name = "Tenax!"
	category = "Circuitus"

/datum/book_entry/tenax/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Tenax!</h2>
	REQUIRES KNOWLEDGE OF FORTITUDE TO USE.
	<BR>
	<BR>
	This spell command receives (optionally) a number and an iota of a creature. The creature's endurance will be enhanced by number given, to a limit of 3.
	Lasts for 20 seconds.
	</div>
	"}

/datum/book_entry/scribo
	name = "Scribo!"
	category = "Circuitus"

/datum/book_entry/scribo/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Scribo!</h2>
	REQUIRES NO SPELL KNOWLEDGE TO USE.
	<BR>
	<BR>
	This spell command receives any iota and then an iota of an item. The item must be a memory string. It will store the first iota into the memory string.
	</div>
	"}
