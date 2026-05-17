/datum/status_effect/mood
	id = "mood"

/datum/status_effect/mood/bad
	id = "mood"
	effectedstats = list(STATKEY_LCK = -1)
	alert_type = /atom/movable/screen/alert/status_effect/moodbad
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/moodbad
	name = "Stressed"
	desc = ""
	icon_state = "stressb"

/datum/status_effect/mood/vbad
	id = "mood"
	effectedstats = list(STATKEY_LCK = -2)
	alert_type = /atom/movable/screen/alert/status_effect/moodvbad
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/moodvbad
	name = "Max Stress"
	desc = ""
	icon_state = "stressvb"

/datum/status_effect/mood/good
	id = "mood"
	effectedstats = list(STATKEY_LCK = 1)
	alert_type = /atom/movable/screen/alert/status_effect/moodgood
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/moodgood
	name = "Inner Peace"
	desc = ""
	icon_state = "stressg"

/datum/status_effect/mood/vgood
	id = "mood"
	effectedstats = list(STATKEY_LCK = 2)
	alert_type = /atom/movable/screen/alert/status_effect/moodvgood
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/moodvgood
	name = "Max Peace"
	desc = ""
	icon_state = "stressvg"

/// Short-duration cleanse blessing applied by the Necran censer. Acts as a mood so it displaces stress.
/datum/status_effect/mood/censer_blessed
	duration = 2 MINUTES
	effectedstats = list(STATKEY_LCK = 1)
	alert_type = /atom/movable/screen/alert/status_effect/censer_blessed
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/censer_blessed
	name = "Cleansed"
	desc = "The Undermaiden's incense has purified you. You feel briefly at peace."
	icon_state = "stressg"

/datum/status_effect/necra_censer_mood_bonus
	id = "necra_censer_mood_bonus"
	duration = 2 MINUTES
	effectedstats = list(STATKEY_LCK = 1)
	alert_type = /atom/movable/screen/alert/status_effect/necra_censer_mood_bonus
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/necra_censer_mood_bonus
	name = "Undermaiden's Peace"
	desc = "Incense settles your spirit."
	icon_state = "stressg"

/datum/status_effect/necra_censer_mood_debuff
	id = "necra_censer_mood_debuff"
	duration = 2 MINUTES
	effectedstats = list(STATKEY_LCK = -1)
	alert_type = /atom/movable/screen/alert/status_effect/necra_censer_mood_debuff
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/necra_censer_mood_debuff
	name = "Undermaiden's Rebuke"
	desc = "The incense scorns your unholy body."
	icon_state = "stressb"

/datum/stressevent/necra_censer
	timer = 2 MINUTES
	stressadd = -3
	desc = span_green("The Undermaiden's incense washes over you. You feel at peace.")

/datum/stressevent/necra_censer_undead
	timer = 2 MINUTES
	stressadd = 3
	desc = span_red("The Undermaiden's incense lashes at your unholy body. You feel disturbed.")
