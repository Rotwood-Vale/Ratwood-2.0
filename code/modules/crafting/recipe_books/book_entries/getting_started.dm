// Practical OOC instructions for Bad Drakian. Keep detailed formulas in their own references.
/datum/book_entry/getting_started
	abstract_type = /datum/book_entry/getting_started
	category = null

/datum/book_entry/getting_started/character
	name = "01. Your First Character"

/datum/book_entry/getting_started/character/inner_book_html(mob/user)
	return {"
		<p>Start with a role whose description interests you and whose responsibilities you understand. A quieter town role (like Towner) gives you time to learn with other people nearby. Leadership and specialized combat roles can be very demanding for a new player.</p>
		<p>Read your role and subclass descriptions. Skills affect what your character can reliably do: being able to pick up a tool or weapon does not mean you are trained to use it.</p>
		<p>Before joining, open <strong>Content Toggles</strong> in the character sheet&#39;s upper-right corner to review gameplay, display, sound and content preferences. <strong>Keybinds</strong> is just above it. You can change bindings there if a default is uncomfortable. You can also find these in the OOC tab, at the top right.&#x20;</p>
		<p>Introduce yourself to someone in character and ask where your workplace or a useful service is. You do not need to learn every system before you start roleplaying.</p>
		<p>You can return to this guide through <strong>OOC → Encyclopedia → Getting Started</strong>.</p>
	"}

/datum/book_entry/getting_started/controls
	name = "02. Essential Controls"

/datum/book_entry/getting_started/controls/inner_book_html(mob/user)
	return {"
		<p>These are default hotkeys. Your own bindings may differ; check <strong>Keybinds</strong> on the character sheet.</p>
		<ul>
		<li><p><strong>Left-click</strong> to interact. Your held item and selected intent can change the action, so try an empty hand when you mean to handle an object.</p>
		</li>
		<li><p><strong>Shift-click</strong> to examine. Read the result in chat; equipment tooltips, question marks and Mechanics explanations can reveal more.</p>
		</li>
		<li><p><strong>Q / E</strong> select your left / right hand. Pressing the key for the already active hand uses the item in it.</p>
		</li>
		<li><p><strong>Z</strong> drops the held item or releases a held grab.</p>
		</li>
		<li><p><strong>V</strong> toggles standing and resting. <strong>X</strong> resists grabs, restraints and other situations you may be able to escape.</p>
		</li>
		<li><p><strong>C</strong> toggles combat mode. Check its state before clicking another character.</p>
		</li>
		<li><p><strong>Sneak</strong> on your HUD toggles careful movement. Use it before crossing wilderness vegetation to avoid triggering ordinary ambushes and maneater grabs. Sneak has no default hotkey; you can assign one in Keybinds.</p>
		</li>
		</ul>
		<p>Right-click and middle-click have context-sensitive actions. Examine an unfamiliar item or intent before experimenting on another person.</p>
	"}

/datum/book_entry/getting_started/equipment
	name = "03. Equipment & Storage"

/datum/book_entry/getting_started/equipment/inner_book_html(mob/user)
	return {"
		<p>Select the hand you want to use, click to pick up an item, then click a compatible equipment slot to wear it. Not every item fits every slot.</p>
		<p>To light up a torch or lamptern (this is essential to your survival if you can't see in the dark), first check your bag. Right-click your satchel, then click the torch or lamptern if it's inside. Some classes start with them equipped by their belt: click them to pick them up. Then, click on a source of light, like a fire sconce nearby.</p>
		<p>Storage differs by container. Satchels can be accessed while worn with RMB; backpacks generally need taking off first, and swapping to an empty hand, before using RMB on them.</p>
		<p>Clicking a wieldable weapon in your active hand can grip it with both hands when the other hand is free.</p>
		<p>Use the appropriate draw/stow binding for a weapon’s equipment slot. Slot bindings and the weapon’s own interactions are listed in <strong>Keybinds</strong>.</p>
		<p>Bows, crossbows and slings need matching ammunition. Compatible quivers and pouches support quick loading; examine the weapon and ammunition container for their controls. A crossbow must also be cocked before loading.</p>
	"}

/datum/book_entry/getting_started/roleplay
	name = "04. Talking & Finding Roleplay"

/datum/book_entry/getting_started/roleplay/inner_book_html(mob/user)
	return {"
		<p>Use <strong>Say (default hotkey is T) for your character&#39;s speech and Whisper (start a Say message with #) for quieter speech. Starting a Say message with *</strong> writes an emote, describing what your character does.</p>
		<p><strong>LOOC (default hotkey is Y)</strong> is local out-of-character chat. Use it for a brief clarification, such as asking how a control works or checking a scene preference. Keep your character&#39;s speech and knowledge separate from OOC discussion.</p>
		<p><strong>Set Roleplay Ad</strong>, below Content Toggles on the character sheet, lets you advertise the kind of roleplay you are seeking, including that you’re new and seeking instructions.</p>
		<p>Ask another player (usually in LOOC) for mechanical help when appropriate. Use <strong>Adminhelp</strong> for administrator assistance, rule questions or problems that need mediation. It’s fine to ask admins for help if you’re stuck or dead!</p>
	"}

/datum/book_entry/getting_started/upkeep
	name = "05. Food, Water & Rest"

/datum/book_entry/getting_started/upkeep/inner_book_html(mob/user)
	return {"
		<p>Watch your hunger, thirst and energy debuffs, on the top left. Shift-click them for more info. Being tired doesn’t debuff you: Instead, it helps you fall asleep faster, which heals you and allows you to improve skills you recently trained. Don’t be afraid to ask other players about where you could get food and water!<br><br><strong>Berries:&#x20;</strong>&#x42;ushes can be foraged for many things that are useful depending on what you&#39;re looking for. One of these things is berries, which are a good food source if you need one in a pinch. But the catch is that some are poisonous. To test if a berry is poison, bite it once and only once, and if the taste is &quot;Bitter&quot; or anything besides &quot;Berry&quot;, it&#39;s poisonous. One bite will damage your health, but not kill you.<br><br><strong>Water:</strong> Murk, swamp water and sewage are unsafe drinking sources. Rivers and clear water fountains are safe. Select the <strong>Bite</strong> intent (H), and then activate it with MMB, to drink from a source on the map.</p>
		<p>A well and a bucket are a useful source of water. Drink from a suitable filled container using its normal LMB interaction. You might need to swap to the <strong>Fill</strong> intent with 1~4 to fill it with water first.</p>
		<p><strong>Sleep:</strong> To sleep, lie down and close your eyes using the arrows around the eye on the left side of your HUD. A bed or bedroll improves rest. This is the main method of healing health and energy (blue bar), spend by using stamina (green bar).</p>
		<p>Sleep gives access to the dream-based skill progression system.</p>
	"}

/datum/book_entry/getting_started/injuries
	name = "06. When You Are Hurt"

/datum/book_entry/getting_started/injuries/inner_book_html(mob/user)
	return {"
		<p>Injuries are more than a single health bar. Bleeding, pain, damaged limbs and blood loss can leave you helpless even if you survived the initial hit. <br><br>The heart in the top left represents your health. Click it for more information. A heart that loses it’s red liquid inside represents your blood level and bleeding. Orange flashing borders represent incapacitating pain. Green and blue coloring represent poisoning and airloss.<br><br>The paperdoll besides the heart will show which limbs are bleeding, broken or hurt.<br><br>We recommend bringing a bandage roll and a needle with you, from the loadout options.</p>
		<p>For a bleeding wound, select the injured body zone on the aiming doll and apply a bandage by clicking the character while holding the bandage roll.<br><br>Grabbing (empty hand, swap to Grab intent) a bleeding body part slows down blood loss. Doing it again for a tight grab slows down bleeding to an almost stop.</p>
		<p>A sewing needle can close suitable wounds, with Medicine skill affecting treatment.<br><br>Running out of blood is the most common way of dying. Keep your blood at all costs!<br><br>Bandaging or sewing one wound does not repair a fracture or replace lost blood.<br><br>To replace lost blood, you must drink water, or sleep. Even dirty water will do in a pinch, but not more than a couple gulps, or you’ll be poisoned instead.</p>
		<p>If you are badly hurt, get to safety, call for medical help. Click the heart icon in the top left of the HUD to examine your wounds, and tell them where your wounds are.</p>
	"}

/datum/book_entry/getting_started/safety
	name = "07. Staying Safe & Leaving Town"

/datum/book_entry/getting_started/safety/inner_book_html(mob/user)
	return {"
		<h3>Before leaving town</h3>
		<p>Bring <strong>food, water, a light source, bandages, armor and suitable equipment</strong>. Find someone to travel with, learn your route back and tell companions if you are inexperienced. Wilderness creatures and ambushes can overwhelm an unprepared traveller. Never leave town alone!</p>
		<h3>Sneak before crossing vegetation</h3>
		<p><strong>Click the Sneak button on your HUD before entering grass or bushes.</strong> Click it again to return to walking, or assign a Sneak hotkey in Keybinds. Switching to another movement mode ends sneaking, so check the button before continuing.</p>
		<p><strong>Sneaking avoids the ordinary ambush triggers from crossing vegetation and prevents maneaters from grabbing you when you step over them.</strong> Maneaters can look like grass until disturbed.</p>
		<h3>If a maneater grabs you</h3>
		<ol>
		<li><p><strong>Press X, the default Resist hotkey, to start struggling.</strong> Use Resist, not Yield.</p>
		</li>
		<li><p><strong>Let the struggle run.</strong> It makes repeated escape attempts automatically, with a better chance after each failed attempt. You do not need to spam X. Avoid moving or starting other timed actions while struggling.</p>
		</li>
		<li><p>If the struggle stops and you are still caught, <strong>use Resist again</strong>. Call for help: another character can try to pull you free or break the plant.</p>
		</li>
		</ol>
		<p><strong>Act immediately.</strong> A maneater starts chewing shortly after catching you and can tear off a limb if you remain trapped. Having armor is essential to surviving maneaters.</p>
		<h3>Leeches</h3>
		<p>If loosing blood without open wounds, click the heart in the top left. <br><br>You might have leeches attached to you: You’ll see them in the chat, as clickable links, next to the limb they latched on.<br><br>&#x20;Click them to rip them off. And do it quickly: Leeches are incredibly deadly. <br><br>They can bite you if you swim in murky swamp water.</p>
		<h3>If a fight starts</h3>
		<ul>
		<li><p>Turn on <strong>combat mode (C by default)</strong> when you intend to defend yourself. Without combat mode, parry nor dodge, the main defensive mechanics.</p>
		</li>
		<li><p>Hold a weapon you are trained to use, and have it’s hand selected. Suitable armor and defensive equipment matter too. Click on enemies to attack them.</p>
		</li>
		<li><p>Watch your stamina and leave room to retreat before you exhaust yourself.</p>
		</li>
		<li><p>Use <strong>Resist</strong>, normally X, if a creature grabs you.</p>
		</li>
		<li><p>Practice unfamiliar mechanics with a willing partner in a safe place.</p>
		</li>
		</ul>
		<p>Combat has deep mechanics, such as multiple RMB intents and RMB actions (swapped through Shift-1~6), wrestling, spells and miracles. Shift-click them to see what they do.<br><br><strong>Call for help:</strong> ending your phrase with two exclamation marks (example: “Help!!”) will yell instead, reaching further.</p>
	"}

/datum/book_entry/getting_started/death
	name = "08. Death & Getting Help"

/datum/book_entry/getting_started/death/inner_book_html(mob/user)
	return {"
		<p><strong>Read the instructions in chat when you die.</strong> Death does not end your round.</p>
		<p>You will rise as a <strong>deadite</strong> after about [DEAD_TO_ZOMBIE_TIME / (1 MINUTES)] minutes. Follow the instructions in chat, using your spells to find players (Alt-1~9 to select, then hold MMB to cast).</p>
		<p>Revival usually involves lux-based surgery or a religious ritual.</p>
	"}

/datum/book_entry/getting_started/troubleshooting
	name = "09. Why Is This Not Working?"

/datum/book_entry/getting_started/troubleshooting/inner_book_html(mob/user)
	return {"
		<p>Check the latest chat message first: many failed actions explain what is missing.</p>
		<ul>
		<li><p><strong>Wrong action?</strong> Check your active hand, held item, attack intent, middle-click intent and combat mode.</p>
		</li>
		<li><p><strong>Cannot pick up or use something?</strong> Free a hand, stand closer and check whether you are restrained, incapacitated or already performing an action.</p>
		</li>
		<li><p><strong>Treatment or crafting keeps failing?</strong> Check the targeted body zone, tools, materials and required skill.</p>
		</li>
		<li><p><strong>Cannot sleep or move comfortably?</strong> Check equipment restrictions, injuries, restraints and character traits.</p>
		</li>
		<li><p><strong>Hotkey does nothing?</strong> Check Keybinds and whether a text input currently has keyboard focus.</p>
		</li>
		</ul>
		<p>Always ask questions in LOOC, it’s your best tool for learning!</p>
	"}
