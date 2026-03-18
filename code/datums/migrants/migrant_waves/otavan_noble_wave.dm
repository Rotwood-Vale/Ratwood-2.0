/datum/migrant_wave/otavan_envoy
	name = "Otavan Emissary"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/otavan_envoy
	weight = 50
	downgrade_wave = /datum/migrant_wave/otavan_envoy_down_one
	roles = list(
		/datum/migrant_role/otavan/envoy = 1,
		/datum/migrant_role/otavan/knight = 1,
		/datum/migrant_role/otavan/guard = 1,
		/datum/migrant_role/otavan/scribe = 1,
		/datum/migrant_role/otavan/preacher = 1,
	)
	greet_text = "You are part of an Otavan diplomatic mission: a small retinue and a Psydonite preacher, ready to represent your homeland."

/datum/migrant_wave/otavan_envoy_down_one
	name = "Otavan Emissary"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/otavan_envoy
	downgrade_wave = /datum/migrant_wave/otavan_envoy_down_two
	roles = list(
		/datum/migrant_role/otavan/envoy = 1,
		/datum/migrant_role/otavan/knight = 1,
		/datum/migrant_role/otavan/guard = 1,
		/datum/migrant_role/otavan/scribe = 1,
	)
	greet_text = "You are part of an Otavan diplomatic mission: a small retinue and a Psydonite preacher, ready to represent your homeland. The Psydonite is dead - you must carry on."

/datum/migrant_wave/otavan_envoy_down_two
	name = "Otavan Emissary"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/otavan_envoy
	downgrade_wave = /datum/migrant_wave/otavan_envoy_down_three
	roles = list(
		/datum/migrant_role/otavan/envoy = 1,
		/datum/migrant_role/otavan/knight = 1,
		/datum/migrant_role/otavan/guard = 1,
		/datum/migrant_role/otavan/preacher = 1,
	)
	greet_text = "You are part of an Otavan diplomatic mission: a small retinue and a Psydonite preacher, ready to represent your homeland. The Scribe was swallowed by a troll - nothing is left."

/datum/migrant_wave/otavan_envoy_down_three
	name = "Otavan Emissary"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/otavan_envoy
	downgrade_wave = /datum/migrant_wave/otavan_envoy_down_four
	roles = list(
		/datum/migrant_role/otavan/envoy = 1,
		/datum/migrant_role/otavan/knight = 1,
		/datum/migrant_role/otavan/guard = 1,
	)
	greet_text = "You are part of an Otavan diplomatic mission: a small retinue and a Psydonite preacher, ready to represent your homeland. The Scribe died to illness, and the Psydonite stayed behind to bury the body."

/datum/migrant_wave/otavan_envoy_down_four
	name = "Otavan Emissary"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/otavan_envoy
	downgrade_wave = /datum/migrant_wave/otavan_envoy_down_five
	roles = list(
		/datum/migrant_role/otavan/envoy = 1,
		/datum/migrant_role/otavan/knight = 1,
		/datum/migrant_role/otavan/preacher = 1,
	)
	greet_text = "You are part of an Otavan diplomatic mission: a small retinue and a Psydonite preacher, ready to represent your homeland. The Scribe and the Crossbowman fell to brigands - you are almost there!"

/datum/migrant_wave/otavan_envoy_down_five
	name = "Otavan Emissary"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/otavan_envoy
	downgrade_wave = /datum/migrant_wave/otavan_envoy_down_six
	roles = list(
		/datum/migrant_role/otavan/envoy = 1,
		/datum/migrant_role/otavan/preacher = 1,
	)
	greet_text = "You are part of an Otavan diplomatic mission: a small retinue and a Psydonite preacher, ready to represent your homeland. Your Knight and Crossbowman died attempting to aid the Scribe from a wave of Deadites - you must ENDURE."

/datum/migrant_wave/otavan_envoy_down_six
	name = "Otavan Emissary"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/otavan_envoy
	downgrade_wave = /datum/migrant_wave/otavan_envoy_down_seven
	roles = list(
		/datum/migrant_role/otavan/envoy = 1,
		/datum/migrant_role/otavan/knight = 1,
	)
	greet_text = "You are part of an Otavan diplomatic mission: a small retinue and a Psydonite preacher, ready to represent your homeland. The Crossbowman and the Scribe died in a horrible carriage accident, and the Psydonite drunk himself to dead. Keep your noble cause alive."

/datum/migrant_wave/otavan_envoy_down_seven
	name = "Otavan Emissary"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/otavan_envoy
	roles = list(
		/datum/migrant_role/otavan/envoy = 1,
	)
	greet_text = "You are part of an Otavan diplomatic mission: a small retinue and a Psydonite preacher, ready to represent your homeland. The Knight drowned, the Crossbowman starved, the Scribe broke his neck and the Psydonite turned to Zizo and died - it's only you."

