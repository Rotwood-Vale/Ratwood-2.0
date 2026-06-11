/datum/status_effect/mood
	id = "mood"

/datum/status_effect/mood/bad
	id = "mood"
	effectedstats = list(STATKEY_LCK = -1)
	alert_type = /atom/movable/screen/alert/status_effect/moodbad
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/moodbad
	name = "压力沉重"
	desc = ""
	icon_state = "stressb"

/datum/status_effect/mood/vbad
	id = "mood"
	effectedstats = list(STATKEY_LCK = -2)
	alert_type = /atom/movable/screen/alert/status_effect/moodvbad
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/moodvbad
	name = "压力爆表"
	desc = ""
	icon_state = "stressvb"

/datum/status_effect/mood/good
	id = "mood"
	effectedstats = list(STATKEY_LCK = 1)
	alert_type = /atom/movable/screen/alert/status_effect/moodgood
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/moodgood
	name = "内心平静"
	desc = ""
	icon_state = "stressg"

/datum/status_effect/mood/vgood
	id = "mood"
	effectedstats = list(STATKEY_LCK = 2)
	alert_type = /atom/movable/screen/alert/status_effect/moodvgood
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/moodvgood
	name = "极致平静"
	desc = ""
	icon_state = "stressvg"
