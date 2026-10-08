/datum/patron/godless //for the generic godless sorts.
	name = "Apostasy"
	domain = "Abandonment of faith"
	desc = "The gods exist, but you don't pray to any of them. Why would you pray to any deity who had a hand in the creation of this terrible world?"
	worshippers = "The disillusioned, the neutral, the lost"
	virtues = "None"
	sins = "None"
	associated_faith = /datum/faith/godless
	confess_lines = list(
		"I HAVE NO FAITH!!",
		"THERE IS NO FAITH TO BE FOUND IN ME!!",
		"NO DEITY COMPLETES ME!!",
	)

/datum/patron/godless/nerd //for nerds
	name = "Rationalism"
	domain = "Scientific Justification"
	desc = "The world operates on reason, on evidence! The gods may exist, but they aren't what the actions of mortals should be based off of."
	worshippers = "The questioning, studious, and ''free-thinking''"
	virtues = "Pushing up your glasses"
	sins = "Illogical reasoning"
	confess_lines = list(
		"I LIVE ON LOGIC, NOT FAITH!!",
		"MY FORM HOLDS FAITH ONLY IN EVIDENCE!!",
		"THE WORLD WORKS WHETHER THERE ARE GODS OR NOT!!",
		"ERM, ACTUALLY, I DON'T WORSHIP ANY GOD!! ASKING MY FAITH RELIES ON AN INCORRECT ASSUMPTION THAT EVERYONE IN THE WORLD WORSHIPS A GOD!!", //This is hilarious but if it needs removal, it needs removal.
	)

/datum/patron/godless/unshackled //for the rebellious sort.
	name = "Defiance"
	domain = "Refusal to submit to the divine"
	desc = "The divine exist, but even the most lenient of them are still reality warping tyrants! You refuse!"
	worshippers = "The anarchic, rebellious, and defiant"
	virtues = "Freedom"
	sins = "Submission"
	confess_lines = list(
		"I BOW TO NO GOD!!",
		"YOU SPEAK TO A PERSON, NOT A SLAVE!!",
		"I HAVE NO ALL POWERFUL MASTER!!",
	)


/datum/patron/godless/nuhuh //for the incredibly stubborn types.
	name = "Ignorance"
	domain = "Refusal to admit the divine exist"
	desc = "Magic giant beings exist a thousand miles away, and they magically made the entire world? Bull, shit."
	worshippers = "The stubborn, the ignorant, the foolhardy"
	virtues = "Brushing off the existence of the divine"
	sins = "Admitting the existence of the divine"
	confess_lines = list(
		"I CANNOT PRAY TO NOTHING!!",
		"THE DIVINE DOES NOT EXIST!!",
		"THERE IS NO WOMAN IN THE SKY!!", //referring to Astrata floating over Grenzelhoft.
	)

/datum/patron/godless/autotheist //for the egotistical assholes
	name = "Authotheism"
	domain = "Self-Deification"
	desc = "Look in the mirror. That, right there? That is God. What being could outmatch that reflection?"
	worshippers = "The exceptionally narcissistic, the genuinely mad, the performative"
	virtues = "Being yourself"
	sins = "Criticizing you"
	confess_lines = list(
		"MY WILL MADE MANIFEST IS THIS WORLD!!",
		"WHO ELSE BUT THE REFLECTION IN THE MIRROR?!!",
		"LOOK INTO MY EYES AND SEE PERFECTION!!",
	)

/datum/patron/godless/unknowing //for constructs and particularly dumb kobolds
	name = "Unknowing"
	domain = "Indifference"
	desc = "Blissfully unaware of what a deity is, whether from a newly formed being, or an idiot, you've never learned what a god is, let alone worshiped one."
	worshippers = "The newly created, ignoramouses, fools"
	virtues = "Huh?"
	sins = "What?"
	confess_lines = list(
		"I DON'T KNOW WHAT YOU'RE TALKING ABOUT!!",
		"WHAT ARE YOU TALKING ABOUT?!!",
		"I HAVE NO IDEA WHAT YOU MEAN!!",
	)

/datum/patron/godless/tribe //for black-oaks, and dwarves
	name = "Tribalism"
	domain = "Elevation of one's tribe to a divine status"
	desc = "These gods only care about themselves. What about your people? You'll bow to no god that demands you co-exist with |them|."
	worshippers = "Black-oaks, dwarves, the close-minded"
	virtues = "Membership of your tribe"
	sins = "Being an outsider of your tribe"
	confess_lines = list(
		"I BELIEVE IN MY PEOPLE!!",
		"MY LIFE BELONGS TO MY PEOPLE!!",
		"MY KIND IS THE ONLY THING WORTHY OF WORSHIP!!",
	)

/datum/patron/godless/can_pray(mob/living/follower)
	. = ..()
	to_chat(follower, span_danger("There are no deities who would heed my call."))
	return FALSE	//heathen

/datum/patron/godless/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus
)
	*message_out = span_info("Without any particular cause or reason, [target] is healed!")
	*message_self = span_notice("My wounds close without cause.")
