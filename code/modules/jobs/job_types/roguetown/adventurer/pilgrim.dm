/datum/job/roguetown/pilgrim
	title = "Refugee"
	flag = PILGRIM
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 40
	spawn_positions = 40 //brings back round-start spawn of pilgrims!!!
	allowed_races = RACES_ALL_KINDS
	tutorial = "为逃离厄运，你踏上了前往谷地的道路。你不是士兵，也不是探险家，只是个想寻条活路的卑微流民，前提是你能活着撑过这段旅程。"

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

