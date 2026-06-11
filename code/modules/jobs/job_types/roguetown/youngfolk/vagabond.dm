/datum/job/roguetown/orphan
	tutorial = "这世道从不仁慈，许多人为了求一条勉强糊口的活路，最终连最后一点东西也失去了。流浪汉正是这样的人，他们开局几乎一无所有，只剩手艺与机灵。"
	outfit = null
	outfit_female = null
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	allowed_races = RACES_ALL_KINDS

	advclass_cat_rolls = list(CTAG_VAGABOND = 20)
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = TRUE
	same_job_respawn_delay = 10 SECONDS
	announce_latejoin = FALSE
