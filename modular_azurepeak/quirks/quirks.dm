// Quirks are mostly for flavor or provide very little (or focused on roleplay) benefits.
// At best they should be very minor conveniences as a reward for leaning into vices.
// The baseline point_cost is one.

/datum/quirk/deadnose
	name = "Dead Nose"
	desc = "My nose is numb to the smell of decay."
	added_traits = list(TRAIT_NOSTINK)

/datum/quirk/disgracednoble
	name = "Disgraced Noble"
	desc = "I was a scion of a noble house... long ago. Now I am a commoner, and my family name is a source of shame."
	custom_text = "Choosing this quirk while playing a noble role will cause it to do nothing."
	added_traits = list(TRAIT_DISGRACED_NOBLE)
	incompatible_virtues = list(/datum/virtue/utility/noble)

/datum/quirk/disgracednoble/handle_traits(mob/living/carbon/human/recipient)
	if(HAS_TRAIT(recipient, TRAIT_NOBLE))
		return
	..()

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
	incompatible_virtues = list(/datum/virtue/utility/socialite)

/datum/quirk/nightowl
	name = "Night Owl"
	desc = "I've always preferred Noc over his other half."
	added_traits = list(TRAIT_NIGHT_OWL)

/datum/quirk/outdoorsy
	name = "Outdoorsy"
	desc = "My experience in the wilds allows me to fall asleep on surfaces like treebranches as if they were beds."
	custom_text = "This does not make branches effective beds or allow you to walk on them, simply that you can sleep on them easily."
	added_traits = list(TRAIT_OUTDOORSMAN)
	incompatible_virtues = list(/datum/virtue/utility/woodwalker)

/datum/quirk/roughlover
	name = "Rough Lover"
	desc = "With strong intent, I am a violent partner in bed. Breaking pelvis and spirit alike."
	point_cost = 2
	added_traits = list(TRAIT_DEATHBYSNUSNU)
	incompatible_virtues = list(/datum/virtue/utility/mean)

/datum/quirk/secondvoice
	name = "Second Voice"
	desc = "From performance, deception, or by a need to change yourself in uncanny ways, you've acquired a second, perfect voice. You may switch between them at any point."
	custom_text = "Grants access to a new 'Memory' tab. It will have the options for setting and changing your voice."
	incompatible_vices = list(/datum/charflaw/mute, /datum/charflaw/unintelligible)

/datum/quirk/secondvoice/apply_to_human(mob/living/carbon/human/recipient)
	recipient.verbs += /mob/living/carbon/human/proc/changevoice
	recipient.verbs += /mob/living/carbon/human/proc/swapvoice
