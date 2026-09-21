// Quirks are mostly for flavor or provide very little (or focused on roleplay) benefits.
// At best they should be very minor conveniences as a reward for leaning into vices.
// The baseline point_cost is one.

/datum/quirk/acquiredtastes
	name = "Acquired Tastes"
	desc = "Despite my unorthodox tastes, I'm always prepared to handle a guest with the toys I keep stashed."
	custom_text = "This quirk adds a bag containing various sexual instruments including a small vial of emberwine to your stash."
	added_stashed_items = list("Bag of Fetish Gear" = /obj/item/storage/roguebag/fetish)

/datum/quirk/annoyingface
	name = "Annoying Face"
	desc = "I am cursed with an odd voice and appearance."
	point_cost = 0
	added_traits = list(TRAIT_COMICSANS)

/datum/quirk/deadnose
	name = "Dead Nose"
	desc = "My nose is numb to the smell of decay."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that already has a dead nose!"
	added_traits = list(TRAIT_NOSTINK)
	incompatible_traits = list(TRAIT_NOSTINK)

/datum/quirk/disgracednoble
	name = "Disgraced Noble"
	desc = "I was a scion of a noble house... long ago. Now I am a commoner, and my family name is a source of shame."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already a noble!"
	added_traits = list(TRAIT_DISGRACED_NOBLE)
	incompatible_traits = list(TRAIT_NOBLE)

/datum/quirk/dwarvenchef
	name = "Dwarven Chef"
	desc = "A dwarf once showed me the trick to cutting a proper pretzel from butterdough."
	custom_text = "Lets you cut pretzels from butterdough."
	warning_text = "This quirk does nothing if you are already a dwarf!"
	added_traits = list(TRAIT_DWARVEN_CHEF)

/datum/quirk/empath
	name = "Empath"
	desc = "I can notice when people are in pain."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already an empath!"
	added_traits = list(TRAIT_EMPATH)
	incompatible_virtues = list(/datum/virtue/utility/socialite)
	incompatible_traits = list(TRAIT_EMPATH)

/datum/quirk/fabledlover
	name = "Fabled Lover"
	desc = "It's a lucky thing to share my bed."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already a fabled lover!"
	point_cost = 2
	added_traits = list(TRAIT_GOODLOVER)
	incompatible_virtues = list(/datum/virtue/utility/socialite, /datum/virtue/utility/performer)
	incompatible_traits = list(TRAIT_GOODLOVER)

/datum/quirk/gossiper
	name = "Gossiper"
	desc = "Despite my lowborn blood, I've made a habit out of brushing shoulders with the nobility and learning their secrets."
	custom_text = "Lets you view noble gossip."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already a noble!"
	point_cost = 2
	added_traits = list(TRAIT_GOSSIPER)
	incompatible_virtues = list(/datum/virtue/utility/tracker)
	incompatible_traits = list(TRAIT_NOBLE)

/datum/quirk/hobbyistmusician
	name = "Hobbyist Musician"
	desc = "I've dabbled in music over the years, and I've stashed away an instrument of my own."
	custom_text = "Comes with a stashed instrument of your choice. You choose the instrument after spawning in."
	added_skills = list(list(/datum/skill/misc/music, 1, 6))

/datum/quirk/hobbyistmusician/apply_to_human(mob/living/carbon/human/recipient)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/customization_trait, pick_stashed_instrument), recipient), 50)

/datum/quirk/largeframe
	name = "Large Frame"
	desc = "I'm simply built bigger than most. My strength and hardiness has nothing to show for my size, though."
	custom_text = "This quirk increases your sprite size. Incompatible with the Giant virtue."
	point_cost = 3
	incompatible_virtues = list(/datum/virtue/size/giant)

/datum/quirk/largeframe/apply_to_human(mob/living/carbon/human/recipient)
	recipient.transform = recipient.transform.Scale(1.25, 1.25)
	recipient.transform = recipient.transform.Translate(0, (0.25 * 16))
	recipient.update_transform()

/datum/quirk/malodorous
	name = "Malodorous"
	desc = "My body odor is unbearable without regular baths, and others can tell."
	point_cost = 0

/datum/quirk/malodorous/apply_to_human(mob/living/carbon/human/recipient)
	recipient.vices += new /datum/charflaw/malodorous()

/datum/quirk/hunted
	name = "Marked by Gnolls"
	desc = "For one reason or another, I have been deemed a target worthy of Graggar's champions. I hear their cackles anywhere I go."
	warning_text = "<span style='font-size:120%;'>THIS QUIRK ENCOURAGES GNOLLS TO HUNT YOU DOWN!</span><br>\
	You may potentially be killed in the process!"
	point_cost = 0
	added_traits = list(TRAIT_GNOLL_HUNTED)
	var/attempts_left = 10

// I genuinely couldn't tell you why this needs to be a thing, but it existed when hunted was a vice.
// Therefore, we're keeping the behavior now that it's a quirk.
/datum/quirk/hunted/apply_to_human(mob/living/carbon/human/recipient)
	log_hunted_pick(recipient)

/datum/quirk/hunted/proc/log_hunted_pick(mob/living/carbon/human/H)
	if(!H.name) // The vice version of hunted used Life() for its timing, so deleted mobs would automatically stop timing.
		if(attempts_left <= 0) // We're not riding off of that anymore, so let's have it give up after ten attemps a la Lawless.
			return
		attempts_left--
		addtimer(CALLBACK(src, PROC_REF(log_hunted_pick), H), 1 SECONDS)
		return
	log_hunted("[H.ckey] playing as [H.name] had the hunted trait by quirk.")

/datum/quirk/assassintarget
	name = "Marked for Death"
	desc = "Something in my past has made me a target. I'm always looking over my shoulder."
	warning_text = "<span style='font-size:120%;'>THIS QUIRK ENCOURAGES ASSASSINS TO HUNT YOU DOWN!</span><br>\
	You may be PERMANENTLY KILLED WITHOUT ESCALATION in the process!"
	point_cost = 0
	added_traits = list(TRAIT_ASSASSIN_TARGET)

/datum/quirk/nightowl
	name = "Night Owl"
	desc = "I've always preferred Noc over his other half."
	added_traits = list(TRAIT_NIGHT_OWL)

// Gives minor nobility, but what is a minor noble anyways?
// If we were being realistic then only the grand duke and baron would be real nobles.
// I guess we're saying that real nobility is people who are recognized by Astrata??????????
// Who fucking cares, bro.
/datum/quirk/noble
	name = "Noble"
	desc = "By birth, blade or brain, I carry noble blood, if only a minor and untitled line of it. I've cleverly stashed away a healthy amount of coinage, alongside a familial heirloom."
	custom_text = "This quirk grants you MINOR nobility, meaning you are still subjected to the Great Writ and poll tax."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already a noble!"
	point_cost = 4
	added_traits = list(TRAIT_NOBLE)
	added_skills = list(list(/datum/skill/misc/reading, 1, 6))
	added_stashed_items = list(
	"Heirloom Amulet" = /obj/item/clothing/neck/roguetown/ornateamulet/noble,
	"Hefty Coinpurse" = /obj/item/storage/belt/rogue/pouch/coins/virtuepouch
	)
	incompatible_vices = list(/datum/charflaw/lawless)
	incompatible_quirks = list(/datum/quirk/disgracednoble, /datum/quirk/gossiper)
	incompatible_traits = list(TRAIT_NOBLE)

/datum/quirk/noble/apply_to_human(mob/living/carbon/human/recipient)
	SStreasury.noble_incomes[recipient] += 15
	recipient.social_rank = max(recipient.social_rank, SOCIAL_RANK_MINOR_NOBLE)

/datum/quirk/outdoorsy
	name = "Outdoorsy"
	desc = "My experience in the wilds allows me to fall asleep on surfaces like treebranches as if they were beds."
	custom_text = "This does not make branches effective beds or allow you to walk on them, simply that you can sleep on them easily."
	added_traits = list(TRAIT_OUTDOORSMAN)
	incompatible_virtues = list(/datum/virtue/utility/woodwalker)

/datum/quirk/pretty
	name = "Pretty"
	desc = "I'm no great beauty, but people seem to like looking at my face well enough."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already beautiful!"
	point_cost = 2
	added_traits = list(TRAIT_PRETTY)
	incompatible_virtues = list(/datum/virtue/utility/socialite)
	incompatible_quirks = list(/datum/quirk/ugly)
	incompatible_traits = list(TRAIT_BEAUTIFUL)

/datum/quirk/rawdiet
	name = "Raw Diet"
	desc = "Be it from unnatural anatomy or simply a bizarre tolerance, I can eat raw meat and uncooked food as if it were natural."
	custom_text = "Lets you eat raw meat and uncooked food without getting poisoned. Rotten food, organs, and dirty water will still poison you."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that already possesses an unnatural metabolism!"
	point_cost = 2
	added_traits = list(TRAIT_RAW_EATER)
	incompatible_virtues = list(/datum/virtue/utility/feral_appetite)
	incompatible_traits = list(TRAIT_NASTY_EATER, TRAIT_ORGAN_EATER, TRAIT_WILD_EATER)

/datum/quirk/roughlover
	name = "Rough Lover"
	desc = "With strong intent, I am a violent partner in bed. Breaking pelvis and spirit alike."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already a bedbreaker!"
	point_cost = 2
	added_traits = list(TRAIT_DEATHBYSNUSNU)
	incompatible_traits = list(TRAIT_DEATHBYSNUSNU)

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
	custom_text = "Allows you to prepare recipes utilizing spider meat."
	warning_text = "This quirk does nothing if you are already a drow!"
	added_traits = list(TRAIT_UNDERDARK_CHEF)

/datum/quirk/unsettling
	name = "Unsettling"
	desc = "My appearance is deeply unsettling to most. There's something profoundly wrong about my features."
	point_cost = 1
	added_traits = list(TRAIT_UNSETTLING)
	incompatible_virtues = list(/datum/virtue/utility/socialite)
	incompatible_quirks = list(/datum/quirk/ugly, /datum/quirk/pretty)

/datum/quirk/selfaware
	name = "Self Aware"
	desc = "I've always been conscious about how hurt my body can get."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that already has self aware!"
	added_traits = list(TRAIT_SELF_AWARE)
	incompatible_traits = list(TRAIT_SELF_AWARE)
