/datum/job/roguetown/pilgrim
	title = "Refugee"
	flag = PILGRIM
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 40
	spawn_positions = 40 //brings back round-start spawn of pilgrims!!!
	allowed_races = RACES_ALL_KINDS
	tutorial = "Fleeing misfortune you head your way towards Rotwood Vale, you're not a soldier or an explorer, but a humble migrant trying to look for a better life, if you get to survive the trip that is."

	outfit = null
	outfit_female = null
	bypass_lastclass = TRUE
	bypass_jobban = FALSE


	advclass_cat_rolls = list(CTAG_PILGRIM = 20)
	PQ_boost_divider = 10

	announce_latejoin = FALSE
	display_order = JDO_PILGRIM
	min_pq = -20
	max_pq = null
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	same_job_respawn_delay = 0

