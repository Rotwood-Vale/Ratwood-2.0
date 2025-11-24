/datum/status_effect/buff/divine_touch
	id = "divine_touch"
	alert_type = /atom/movable/screen/alert/status_effect/buff/divine_touch
	effectedstats = list("endurance" = 1)
	duration = 30 SECONDS

/atom/movable/screen/alert/status_effect/buff/divine_touch
	name = "Divine Touch"
	desc = "Blessed by divine healing. +1 Endurance."
	icon_state = "buff"

/datum/status_effect/buff/divine_blessing
	id = "divine_blessing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/divine_blessing
	effectedstats = list("endurance" = 1, "constitution" = 1)
	duration = 45 SECONDS

/atom/movable/screen/alert/status_effect/buff/divine_blessing
	name = "Divine Blessing"
	desc = "Protected by divine grace. +1 Endurance, +1 Constitution."
	icon_state = "buff"

/datum/status_effect/buff/divine_wrath
	id = "divine_wrath"
	alert_type = /atom/movable/screen/alert/status_effect/buff/divine_wrath
	effectedstats = list("strength" = 1, "constitution" = 1, "endurance" = 1)
	duration = 1 MINUTES

/atom/movable/screen/alert/status_effect/buff/divine_wrath
	name = "Divine Wrath"
	desc = "Empowered by divine fury. +1 Strength, +1 Constitution, +1 Endurance."
	icon_state = "buff"

/datum/status_effect/buff/divine_avatar
	id = "divine_avatar"
	alert_type = /atom/movable/screen/alert/status_effect/buff/divine_avatar
	effectedstats = list("strength" = 1, "constitution" = 1, "endurance" = 1, "intelligence" = 1) 
	duration = 60 SECONDS

/atom/movable/screen/alert/status_effect/buff/divine_avatar
	name = "Divine Avatar"
	desc = "I channel divine power. +1 Strength, +1 Constitution, +1 Endurance, +1 Intelligence."
	icon_state = "buff"
