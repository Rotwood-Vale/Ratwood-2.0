/datum/migrant_wave/heartfelt
	name = "Heartfelt宫廷"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/heartfelt
	weight = 50
	downgrade_wave = /datum/migrant_wave/heartfelt_down_one
	roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
		/datum/migrant_role/heartfelt/hand = 1,
		/datum/migrant_role/heartfelt/knight = 1,
		/datum/migrant_role/heartfelt/retinue = 4,
	)
	greet_text = "为了逃离灾厄，你们以宫廷之名重新集结，齐心协力做最后一搏，试图重现 Heartfelt 昔日的荣光与希望。彼此靠近，互相照应，为了你们所有人的性命！"

/datum/migrant_wave/heartfelt_down_one
	name = "Heartfelt宫廷"
	shared_wave_type = /datum/migrant_wave/heartfelt
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/heartfelt_down_two
	roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
		/datum/migrant_role/heartfelt/hand = 1,
		/datum/migrant_role/heartfelt/knight = 1,
		/datum/migrant_role/heartfelt/retinue = 3,
	)
	greet_text = "为了逃离灾厄，你们以宫廷之名重新集结，齐心协力做最后一搏，试图重现 Heartfelt 昔日的荣光与希望。彼此靠近，互相照应，为了你们所有人的性命！你们之中已有一些人没能活着走到这里……"

/datum/migrant_wave/heartfelt_down_two
	name = "Heartfelt宫廷"
	shared_wave_type = /datum/migrant_wave/heartfelt
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/heartfelt_down_three
	roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
		/datum/migrant_role/heartfelt/hand = 1,
		/datum/migrant_role/heartfelt/knight = 1,
		/datum/migrant_role/heartfelt/retinue = 2,
	)
	greet_text = "为了逃离灾厄，你们以宫廷之名重新集结，齐心协力做最后一搏，试图重现 Heartfelt 昔日的荣光与希望。彼此靠近，互相照应，为了你们所有人的性命！你们之中已有一些人没能活着走到这里……"


/datum/migrant_wave/heartfelt_down_three
	name = "Heartfelt宫廷"
	shared_wave_type = /datum/migrant_wave/heartfelt
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/heartfelt_down_four
	roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
		/datum/migrant_role/heartfelt/hand = 1,
		/datum/migrant_role/heartfelt/knight = 1,
		/datum/migrant_role/heartfelt/retinue = 1,
	)
	greet_text = "为了逃离灾厄，你们以宫廷之名重新集结，齐心协力做最后一搏，试图重现 Heartfelt 昔日的荣光与希望。彼此靠近，互相照应，为了你们所有人的性命！你们之中已有一些人没能活着走到这里……"

/datum/migrant_wave/heartfelt_down_four
	name = "Heartfelt宫廷"
	shared_wave_type = /datum/migrant_wave/heartfelt
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/heartfelt_down_five
	roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
		/datum/migrant_role/heartfelt/hand = 1,
		/datum/migrant_role/heartfelt/knight = 1,
	)
	greet_text = "为了逃离灾厄，你们以宫廷之名重新集结，齐心协力做最后一搏，试图重现 Heartfelt 昔日的荣光与希望。彼此靠近，互相照应，为了你们所有人的性命！你们之中已有一些人没能活着走到这里……"

/datum/migrant_wave/heartfelt_down_five
	name = "Heartfelt宫廷"
	shared_wave_type = /datum/migrant_wave/heartfelt
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/heartfelt_down_six
	roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
		/datum/migrant_role/heartfelt/hand = 1,
		/datum/migrant_role/heartfelt/retinue = 1,
	)
	greet_text = "为了逃离灾厄，你们以宫廷之名重新集结，齐心协力做最后一搏，试图重现 Heartfelt 昔日的荣光与希望。彼此靠近，互相照应，为了你们所有人的性命！你们之中已有一些人没能活着走到这里……"

/datum/migrant_wave/heartfelt_down_six
	name = "Heartfelt宫廷"
	shared_wave_type = /datum/migrant_wave/heartfelt
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/heartfelt_down_seven
	roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
		/datum/migrant_role/heartfelt/retinue = 2,
	)
	greet_text = "为了逃离灾厄，你们以宫廷之名重新集结，齐心协力做最后一搏，试图重现 Heartfelt 昔日的荣光与希望。彼此靠近，互相照应，为了你们所有人的性命！你们之中已有一些人没能活着走到这里……"

/datum/migrant_wave/heartfelt_down_seven
	name = "Heartfelt宫廷"
	shared_wave_type = /datum/migrant_wave/heartfelt
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/heartfelt_down_eight
	roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
		/datum/migrant_role/heartfelt/knight = 1,
	)
	greet_text = "为了逃离灾厄，你们以宫廷之名重新集结，齐心协力做最后一搏，试图重现 Heartfelt 昔日的荣光与希望。可到了最后，只剩下领主与他忠诚的骑士孤身相伴……"

/datum/migrant_wave/heartfelt_down_eight
	name = "Heartfelt宫廷"
	shared_wave_type = /datum/migrant_wave/heartfelt
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/heartfelt_down_nine
	roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
		/datum/migrant_role/heartfelt/hand = 1,
	)
	greet_text = "为了逃离灾厄，你们以宫廷之名重新集结，齐心协力做最后一搏，试图重现 Heartfelt 昔日的荣光与希望。可到了最后，只剩下领主与他忠诚的执政之手孤身相伴……"

/datum/migrant_wave/heartfelt_down_nine
	name = "Heartfelt宫廷"
	shared_wave_type = /datum/migrant_wave/heartfelt
	downgrade_wave = /datum/migrant_wave/heartfelt_down_ten
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
		/datum/migrant_role/heartfelt/retinue = 1,
	)
	greet_text = "为了逃离灾厄，你们以宫廷之名重新集结，齐心协力做最后一搏，试图重现 Heartfelt 昔日的荣光与希望。可到了最后，只剩下领主与他最后一位忠诚追随者孤身相伴……"

/datum/migrant_wave/heartfelt_down_ten
	name = "Heartfelt宫廷"
	shared_wave_type = /datum/migrant_wave/heartfelt
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
	)
	greet_text = "为了逃离灾厄，你们以宫廷之名重新集结，齐心协力做最后一搏，试图重现 Heartfelt 昔日的荣光与希望。但一切终究成空，到了最后，只剩你一人，失去了家人与部下。昔日强者竟落到如此地步……"
