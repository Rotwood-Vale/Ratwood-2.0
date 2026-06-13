/datum/job/roguetown/adventurer/courtagent
	title = "Court Agent"
	display_title = "宫廷密探"
	flag = COURTAGENT
	display_order = JDO_COURTAGENT
	allowed_races = RACES_ALL_KINDS
	total_positions = 2
	spawn_positions = 2
	round_contrib_points = 2
	tutorial = "无论是靠功绩、精明的谈判，还是完成悬赏得来的机会，你如今都成了执政之手暗中驱使的一枚棋子。去替宫廷完成那些他们不愿公之于众的欲望与怪念头。你的位置一点也不稳固，任何失误都可能让你被弃如敝履，像下等罪犯一样遭到指控。驻军与宫廷成员都知道你是谁。"
	min_pq = 5
	job_reopens_slots_on_death = FALSE
	always_show_on_latechoices = TRUE
	show_in_credits = TRUE
	advclass_cat_rolls = list(CTAG_COURTAGENT = 20)
	obsfuscated_job = TRUE
	class_setup_examine = FALSE

//Hooking in here does not mess with their equipment procs
/datum/job/roguetown/adventurer/courtagent/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	if(L)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			GLOB.court_agents += H.real_name
			if(H.mind)
				H.mind.special_role = "Court Agent" //For obfuscating them in the Actors list: _job.dm L:216
			..()
