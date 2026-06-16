/datum/job/roguetown/adventurer/courtslave
	title = "Enslaved Adventurer"
	display_title = "被奴役的冒险者"
	flag = ADVENTURER
	display_order = JDO_COURTAGENT
	allowed_races = RACES_ALL_KINDS
	total_positions = 3
	spawn_positions = 3
	round_contrib_points = 2
	tutorial = "祸不单行——无论是站错了法律的一边，还是欠下了无法偿还的债务，你最终落入了奴隶主的暗中操控之下。满足宫廷中那些不可告人的欲望和奇想。你的处境岌岌可危，任何失误都可能让你被绑缚、鞭笞，甚至更糟。卫戍部队和宫廷成员都知道你的身份。"
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
