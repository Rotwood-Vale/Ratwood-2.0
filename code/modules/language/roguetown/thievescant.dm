/datum/language/thievescant
	name = "Thieves' Cant"
	desc = "A secret language of gestures, expressions, and subtle body movements used by rogues, criminals, and the underworld to communicate without detection."
	speech_verb = "says"
	ask_verb = "asks"
	exclaim_verb = "yells"
	key = "x"
	flags = TONGUELESS_SPEECH | SIGNLANG
	space_chance = 66
	default_priority = 80
	icon_state = "thief"
	spans = list(SPAN_PAPYRUS)
	signlang_verb = list(
		"gives the middle finger",
		"spits on the ground",
		"picks their nose",
		"scratches their crotch",
		"flips them off",
		"makes an obscene gesture",
		"mocks them cruelly",
		"rolls their eyes",
		"sneers contemptuously",
		"scowls",
		"makes a throat-slitting gesture",
		"shows both middle fingers",
		"makes a vulgar hand gesture",
		"sticks out their tongue mockingly",
		"makes a jerking-off motion",
		"scratches their ass",
		"hawks a loogie",
		"makes an L shape on their forehead",
		"gives a dismissive wank gesture",
		"blows a raspberry",
		"makes a fart noise with their mouth",
		"burps loudly",
		"pretends to strangle someone",
		"makes a stabbing motion",
		"draws a finger across their throat",
		"flicks a booger",
		"grabs their crotch aggressively",
		"makes a choking gesture",
		"shows two fingers in a rude V",
		"gives a crude up-yours gesture",
		"gestures with their hands",
		"signs carefully",
		"motions with their fingers",
		"makes a flowing hand gesture",
		"taps their fingers together",
		"points and gestures",
		"makes precise hand signs",
		"traces shapes in the air",
		"gestures expressively",
		"signs with both hands",
		"makes a sweeping gesture",
		"gestures near their chest",
		"makes circular motions",
		"forms symbols with their hands",
		"gestures slowly and clearly",
		"makes deliberate hand movements",
		"taps their palm",
		"forms letters with their fingers",
		"makes quick hand signs",
		"signs with fluid movements"
	)


/datum/language/thievescant/signlanguage
	name = "Grimorian Sign Speak"
	desc = "A common sign language used across Psydonia. While regional variations exist from continent to continent, the basic signs are universal enough that most people can understand simple communications through gestures and hand movements alone."
	key = "xx"
	signlang_verb = list(
		"gestures with their hands",
		"signs carefully",
		"motions with their fingers",
		"makes a flowing hand gesture",
		"signs with deliberate movements",
		"taps their fingers together",
		"points and gestures",
		"makes precise hand signs",
		"waves their hand gently",
		"traces shapes in the air",
		"gestures expressively",
		"signs with both hands",
		"makes a sweeping gesture",
		"signs with subtle movements",
		"gestures near their chest",
		"makes circular motions",
		"signs with measured gestures",
		"forms symbols with their hands",
		"gestures slowly and clearly",
		"makes deliberate hand movements",
		"signs with graceful motions",
		"taps their palm",
		"gestures near their face",
		"forms letters with their fingers",
		"makes quick hand signs",
		"gestures with emphasis",
		"signs with fluid movements",
		"makes a crossing gesture",
		"points and traces",
		"signs with careful precision"
	)
