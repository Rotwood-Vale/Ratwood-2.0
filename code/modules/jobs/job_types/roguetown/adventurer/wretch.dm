// Wretch, soft antagonists. Giving them a significant boon in stats due to their general presence as driving antagonists.
/datum/job/roguetown/wretch
	title = "Wretch"
	flag = WRETCH
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 3//From 8.
	spawn_positions = 3
	allowed_races = RACES_ALL_KINDS
	tutorial = "Somewhere in your lyfe, you fell to the wrong side of civilization. Hounded by the consequences of your actions, you now threaten the peace of those who still heed the authority that condemned you."
	outfit = null
	outfit_female = null
	display_order = JDO_WRETCH
	show_in_credits = FALSE
	min_pq = 60//Three slots. Intended for round progression. Lunatic at 100, Martyr at 10.
	max_pq = null

	obsfuscated_job = TRUE

	advclass_cat_rolls = list(CTAG_WRETCH = 20)
	PQ_boost_divider = 10
	round_contrib_points = 2

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE//Haha! No. Stop. No endless waves of better adventurers, thanks.
	same_job_respawn_delay = 1 MINUTES
	virtue_restrictions = list(/datum/virtue/heretic/zchurch_keyholder) //all wretch classes automatically get this
	carebox_table = /datum/carebox_table/wretch
	job_traits = list(TRAIT_STEELHEARTED, TRAIT_OUTLANDER, TRAIT_OUTLAW, TRAIT_HERESIARCH)
	job_subclasses = list(
		/datum/advclass/wretch/deserter,
		/datum/advclass/wretch/deserter/maa,
		/datum/advclass/wretch/berserker,
		/datum/advclass/wretch/hedgemage,
		/datum/advclass/wretch/necromancer,
		/datum/advclass/wretch/heretic,
		/datum/advclass/wretch/heretic/spy,
		/datum/advclass/wretch/outlaw,
		/datum/advclass/wretch/outlaw/marauder,
		/datum/advclass/wretch/poacher,
		/datum/advclass/wretch/plaguebearer,
		/datum/advclass/wretch/pyromaniac,
		/datum/advclass/wretch/vigilante,
		/datum/advclass/wretch/blackoakwyrm
	)

/datum/job/roguetown/wretch/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")

		// Assign wretch antagonist datum so wretches appear in antag list
		if(H.mind && !H.mind.has_antag_datum(/datum/antagonist/wretch))
			var/datum/antagonist/new_antag = new /datum/antagonist/wretch()
			H.mind.add_antag_datum(new_antag)


		if(GLOB.adventurer_hugbox_duration)
			addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, adv_hugboxing_start)), 1)

// Proc for wretch to select a bounty
/proc/wretch_select_bounty(mob/living/carbon/human/H)
	var/bounty_face_noface = alert(H,"Is your face known?", , "Yes", "No" )
	if(bounty_face_noface == "Yes")
		var/bounty_poster = input(H, "Who placed a bounty on you?", "Bounty Poster") as anything in list("The Justiciary of Rotwood", "The Grenzelhoftian Holy See", "The Otavan Orthodoxy")
		if(bounty_poster == "The Justiciary of Rotwood")
			GLOB.outlawed_players += H.real_name
		else
			GLOB.excommunicated_players += H.real_name
		// Felinid said we should gate it at 100 or so on at the lowest, so that wretch cannot ezmode it.
		var/bounty_severity = input(H, "How severe are your crimes?", "Bounty Amount") as anything in list("Misdeed", "Harm towards lyfe", "Horrific atrocities")
		var/bounty_total = rand(100, 400) // Just in case
		switch(bounty_severity)
			if("Misdeed")
				bounty_total = rand(100, 200)
			if("Harm towards lyfe")
				bounty_total = rand(200, 300)
			if("Horrific atrocities")
				bounty_total = rand(300, 400) // Let's not make it TOO profitable
				if(bounty_poster == "The Justiciary of Rotwood")
					GLOB.outlawed_players += H.real_name
				else
					GLOB.excommunicated_players += H.real_name
		var/my_crime = input(H, "What is your crime?", "Crime") as text|null
		if (!my_crime)
			my_crime = "crimes against the Crown"
		add_bounty(H.real_name, bounty_total, FALSE, my_crime, bounty_poster)
	if(bounty_face_noface == "No")
		var/race = H.dna.species
		var/gender = H.gender
		var/list/d_list = H.get_mob_descriptors()
		var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
		var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
		var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
		var/bounty_poster = "The Justiciary of Rotwood"
		var/bounty_severity = input(H, "How severe are your crimes?", "Bounty Amount") as anything in list("Misdeed", "Harm towards lyfe", "Horrific atrocities")
		var/bounty_total = rand(100, 400) // Just in case
		switch(bounty_severity)
			if("Misdeed")
				bounty_total = rand(100, 200)
			if("Harm towards lyfe")
				bounty_total = rand(200, 300)
			if("Horrific atrocities")
				bounty_total = rand(300, 400) // Let's not make it TOO profitable
				if(bounty_poster == "The Justiciary of Rotwood")
					GLOB.outlawed_players += H.real_name
				else
					GLOB.excommunicated_players += H.real_name
		var/my_crime = input(H, "What is your crime?", "Crime") as text|null
		if (!my_crime)
			my_crime = "crimes against the Crown"
		add_bounty_noface(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, FALSE, my_crime, bounty_poster)

	to_chat(H, span_danger("You are an Antagonistic role. You are expected, by choosing to be a wretch, to sow chaos and division amongst the town while driving a story. Failure to use proper gravitas for this may get you punished for Low Role Play standards."))
