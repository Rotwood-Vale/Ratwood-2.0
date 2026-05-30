// Miscellaneous/novelty statpacks

/datum/statpack/wildcard/lucky
	name = "Lucky"
	desc = "You were born on a sunny day under double rainbow when the stars were in alignment. A more believable explanation for your luckiness is hard to find."
	stat_array = list(STAT_FORTUNE = 2)

/datum/statpack/wildcard/fated
	name = "Fated"
	desc = "You are but a victim of a Xylix's joke. Let his whims decree what your fate shall be."
	stat_array = list(STAT_STRENGTH = list(-1, 1), STAT_PERCEPTION = list(-1, 1), STAT_INTELLIGENCE = list(-1, 1), STAT_CONSTITUTION = list(-1, 1), STAT_WILLPOWER = list(-1, 1), STAT_SPEED = list(-1, 1), STAT_FORTUNE = list(-1, 1))

/datum/statpack/wildcard/wretched
	name = "Wretched"
	desc = "The cruelty of fate leaves many in its wake - you among them. But with its terrible eye turned elsewhere, perhaps it is time for your fortune to be made..."
	stat_array = list(STAT_STRENGTH = -2, STAT_PERCEPTION = -2, STAT_INTELLIGENCE = -2, STAT_CONSTITUTION = -2, STAT_WILLPOWER = -2, STAT_SPEED = -2, STAT_FORTUNE = 3)

/datum/statpack/wildcard/frail
	name = "Frail"
	desc = "The growing dark lines your vision more with every passing day: your flesh and mind are failing you, and destiny has turned her gaze from you. How will your tale endure such hardship?"
	stat_array = list(STAT_STRENGTH = -4, STAT_PERCEPTION = -4, STAT_INTELLIGENCE = -4, STAT_CONSTITUTION = -4, STAT_WILLPOWER = -4, STAT_SPEED = -4, STAT_FORTUNE = -4)

/datum/statpack/wildcard/boring
	name = "Boring"
	desc = "You are as normal and boring as it can get. You will live a middle life and be buried in a middle grave."

/datum/statpack/wildcard/virtuous
	name = "Virtuous"
	desc = "The breadth of your being is one of many, distinguished talents. \n (Lets you pick a second 'virtue', special traits/quirks that replace the bonus normally given by a statpack.)"
