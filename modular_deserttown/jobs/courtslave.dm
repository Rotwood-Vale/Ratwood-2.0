/datum/job/roguetown/adventurer/courtslave
	title = "Enslaved Adventurer"
	flag = ADVENTURER
	display_order = JDO_COURTAGENT
	allowed_races = RACES_ALL_KINDS
	total_positions = 3
	spawn_positions = 3
	round_contrib_points = 2
	tutorial = "Woe has befallen thee - whether by falling on the wrong side of the law or needing to pay off a debt, you have found yourself under the underhanded employ of the Slavemaster. Fulfill desires and whims of the court that they would rather not be publicly known. Your position is anything but secure, and any mistake can leave you bound, flogged or worse. Garrison and Court members know who you are."
	min_pq = 5
	job_reopens_slots_on_death = FALSE
	always_show_on_latechoices = TRUE
	show_in_credits = TRUE
	advclass_cat_rolls = list(CTAG_COURTAGENT = 20)
	obsfuscated_job = FALSE
	class_setup_examine = FALSE
	social_rank = SOCIAL_RANK_DIRT

// //Hooking in here does not mess with their equipment procs
// /datum/job/roguetown/adventurer/courtagent/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
// 	if(L)
// 		if(ishuman(L))
// 			var/mob/living/carbon/human/H = L
// 			GLOB.court_agents += H.real_name
// 			if(H.mind)
// 				H.mind.special_role = "Court Agent" //For obfuscating them in the Actors list: _job.dm L:216
// 			..()
