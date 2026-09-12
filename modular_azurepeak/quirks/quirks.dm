// Quirks are mostly for flavor or provide very little (or focused on roleplay) benefits.
// At best they should be very minor conveniences as a reward for leaning into vices.
// The baseline point_cost is one.

/datum/quirk/annoyingface
	name = "Annoying Face"
	desc = "I am cursed with an odd voice and appearance."
	point_cost = 0
	added_traits = list(TRAIT_COMICSANS)

/datum/quirk/deadnose
	name = "Dead Nose"
	desc = "My nose is numb to the smell of decay."
	added_traits = list(TRAIT_NOSTINK)

/datum/quirk/disgracednoble
	name = "Disgraced Noble"
	desc = "I was a scion of a noble house... long ago. Now I am a commoner, and my family name is a source of shame."
	custom_text = "Choosing this quirk while playing a noble role will cause it to do nothing."
	added_traits = list(TRAIT_DISGRACED_NOBLE)

/datum/quirk/disgracednoble/handle_traits(mob/living/carbon/human/recipient)
	if(HAS_TRAIT(recipient, TRAIT_NOBLE))
		return
	..()

/datum/quirk/dwarvenchef
	name = "Dwarven Chef"
	desc = "A dwarf once showed me the trick to cutting a proper pretzel from butterdough."
	custom_text = "Lets you cut pretzels from butterdough. This quirk does nothing if you are already a Dwarf."
	added_traits = list(TRAIT_DWARVEN_CHEF)

/datum/quirk/empath
	name = "Empath"
	desc = "I can notice when people are in pain."
	added_traits = list(TRAIT_EMPATH)
	incompatible_virtues = list(/datum/virtue/utility/socialite)

/datum/quirk/fabledlover
	name = "Fabled Lover"
	desc = "It's a lucky thing to share my bed."
	point_cost = 2
	added_traits = list(TRAIT_GOODLOVER)
	incompatible_virtues = list(/datum/virtue/utility/socialite, /datum/virtue/utility/performer)

/datum/quirk/gossiper
	name = "Gossiper"
	desc = "Despite my lowborn blood, I've made a habit out of brushing shoulders with the nobility and learning their secrets."
	custom_text = "Lets you view noble gossip. Choosing this quirk while playing a noble role will cause it to do nothing."
	point_cost = 2
	added_traits = list(TRAIT_GOSSIPER)
	incompatible_virtues = list(/datum/virtue/utility/tracker)

/datum/quirk/gossiper/handle_traits(mob/living/carbon/human/recipient)
	if(HAS_TRAIT(recipient, TRAIT_NOBLE))
		return
	..()

/datum/quirk/hobbyistmusician
	name = "Hobbyist Musician"
	desc = "I've dabbled in music over the years, and I've stashed away an instrument of my own."
	custom_text = "Comes with a stashed instrument of your choice. You choose the instrument after spawning in."
	added_skills = list(list(/datum/skill/misc/music, 1, 6))

/datum/quirk/hobbyistmusician/apply_to_human(mob/living/carbon/human/recipient)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/customization_trait, pick_stashed_instrument), recipient), 50)

/datum/quirk/malodorous
	name = "Malodorous"
	desc = "My body odor is unbearable without regular baths, and others can tell."
	point_cost = 0

/datum/quirk/malodorous/apply_to_human(mob/living/carbon/human/recipient)
	recipient.vices += new /datum/charflaw/malodorous()

/datum/quirk/hunted
	name = "Marked by Gnolls"
	desc = "For one reason or another, I have been deemed a target worthy of Graggar's champions. I hear their cackles anywhere I go.<br>\
	<br>\
	<span style='color:#f44336; font-size:120%;'>THIS QUIRK ENCOURAGES GNOLLS TO HUNT YOU DOWN!</span><br>\
	<span style='color:#f44336;'>You may potentially be killed in the process!</span>"
	point_cost = 0

/datum/quirk/hunted/apply_to_human(mob/living/carbon/human/recipient)
	recipient.vices += new /datum/charflaw/hunted()

/datum/quirk/assassintarget
	name = "Marked for Death"
	desc = "Something in my past has made me a target. I'm always looking over my shoulder.<br>\
	<br>\
	<span style='color:#f44336; font-size:120%;'>THIS QUIRK ENCOURAGES ASSASSINS TO HUNT YOU DOWN!</span><br>\
	<span style='color:#f44336;'>You may be PERMANENTLY KILLED WITHOUT ESCALATION in the process!</span>"
	point_cost = 0

/datum/quirk/assassintarget/apply_to_human(mob/living/carbon/human/recipient)
	recipient.vices += new /datum/charflaw/assassintarget()

/datum/quirk/nightowl
	name = "Night Owl"
	desc = "I've always preferred Noc over his other half."
	added_traits = list(TRAIT_NIGHT_OWL)

/datum/quirk/nobility
	name = "Nobility"
	desc = "By birth, blade or brain, I am noble known to the royalty of these lands, and have all the benefits associated with it. I've cleverly stashed away a healthy amount of coinage, alongside a familial heirloom."
	point_cost = 4
	added_traits = list(TRAIT_NOBLE)
	added_skills = list(list(/datum/skill/misc/reading, 1, 6))
	added_stashed_items = list(
	"Heirloom Amulet" = /obj/item/clothing/neck/roguetown/ornateamulet/noble,
	"Hefty Coinpurse" = /obj/item/storage/belt/rogue/pouch/coins/virtuepouch
	)
	incompatible_vices = list(/datum/charflaw/lawless)
	incompatible_quirks = list(/datum/quirk/disgracednoble, /datum/quirk/gossiper)

/datum/quirk/nobility/apply_to_human(mob/living/carbon/human/recipient)
	SStreasury.noble_incomes[recipient] += 15

/datum/quirk/outdoorsy
	name = "Outdoorsy"
	desc = "My experience in the wilds allows me to fall asleep on surfaces like treebranches as if they were beds."
	custom_text = "This does not make branches effective beds or allow you to walk on them, simply that you can sleep on them easily."
	added_traits = list(TRAIT_OUTDOORSMAN)
	incompatible_virtues = list(/datum/virtue/utility/woodwalker)

/datum/quirk/pretty
	name = "Pretty"
	desc = "I'm no great beauty, but people seem to like looking at my face well enough."
	custom_text = "If you also are beautiful, this quirk does nothing."
	point_cost = 2
	added_traits = list(TRAIT_PRETTY)
	incompatible_virtues = list(/datum/virtue/utility/socialite)
	incompatible_quirks = list(/datum/quirk/ugly)

/datum/quirk/rawdiet
	name = "Raw Diet"
	desc = "Be it from unnatural anatomy or simply a bizarre tolerance, I can eat raw meat and uncooked food as if it were natural."
	custom_text = "Lets you eat raw meat and uncooked food without getting poisoned. Rotten food, organs, and dirty water will still poison you."
	point_cost = 2
	added_traits = list(TRAIT_RAW_EATER)
	incompatible_virtues = list(/datum/virtue/utility/feral_appetite)

/datum/quirk/roughlover
	name = "Rough Lover"
	desc = "With strong intent, I am a violent partner in bed. Breaking pelvis and spirit alike."
	point_cost = 2
	added_traits = list(TRAIT_DEATHBYSNUSNU)
	incompatible_virtues = list(/datum/virtue/utility/mean)

/datum/quirk/scarred
	name = "Scarred"
	desc = "My face bears terrible scars that make identification difficult, but not impossible."
	point_cost = 0
	added_traits = list(TRAIT_SCARRED)

/datum/quirk/secondvoice
	name = "Second Voice"
	desc = "From performance, deception, or by a need to change yourself in uncanny ways, you've acquired a second, perfect voice. You may switch between them at any point."
	custom_text = "Grants access to a new 'Memory' tab. It will have the options for setting and changing your voice."
	incompatible_vices = list(/datum/charflaw/mute, /datum/charflaw/unintelligible)

/datum/quirk/secondvoice/apply_to_human(mob/living/carbon/human/recipient)
	recipient.verbs += /mob/living/carbon/human/proc/changevoice
	recipient.verbs += /mob/living/carbon/human/proc/swapvoice

/datum/quirk/ugly
	name = "Ugly"
	desc = "My face is ugly and makes everyone who looks at me miserable."
	point_cost = 0
	added_traits = list(TRAIT_UNSEEMLY)
	incompatible_virtues = list(/datum/virtue/utility/socialite)

/datum/quirk/underdarkchef
	name = "Underdark Chef"
	desc = "I've picked up a few culinary secrets from the Underdark. Spider meat is more versatile than you'd think."
	custom_text = "Allows you to prepare recipes utilizing spider meat. This quirk does nothing if you are already a Drow."
	added_traits = list(TRAIT_UNDERDARK_CHEF)
