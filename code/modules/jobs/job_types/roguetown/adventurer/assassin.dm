/datum/job/roguetown/assassin
	title = "Assassin"
	display_title = "刺客"
	flag = ASSASSIN
	department_flag = WANDERERS
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	min_pq = 25		//This is a class that lets you effectively no-esc someone. So.. responsibility.
	max_pq = null
	antag_job = TRUE
	allowed_races = RACES_ALL_KINDS
	tutorial = "很久以前，你犯下了足以让悬赏令被钉在本地酒馆外墙上的罪行。如今你与同伙一同栖身于沼泽，平日里也净干些见不得光的勾当。"

	outfit = null
	outfit_female = null

	obsfuscated_job = TRUE

	display_order = JDO_ASSASSIN
	announce_latejoin = FALSE
	round_contrib_points = 5

	advclass_cat_rolls = list(CTAG_ASSASSIN = 20)
	PQ_boost_divider = 10

	wanderer_examine = TRUE
	advjob_examine = FALSE	//We don't want anyone knowing what type of assassin you are.
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE

	// Base job traits, we give one-specialty trait per role.
	job_traits = list(
		TRAIT_ASSASSIN,
		TRAIT_DODGEEXPERT,
		TRAIT_STEELHEARTED,
		TRAIT_HERESIARCH,
		TRAIT_ZURCH,	//Just so they can use the Zurch.
		TRAIT_ANTISCRYING,
	)
	cmode_music = 'sound/music/cmode/antag/combat_assassin.ogg'
	// Choices between: Ranged build, pioson knife-fighter w/ poison knife, garrote user/kidnapper build
	job_subclasses = list(
		/datum/advclass/assassin_ranger,
		/datum/advclass/assassin_poisoner,
		/datum/advclass/assassin_hitman,
	)

/datum/job/roguetown/assassin/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		if(!H.mind)
			return
		H.ambushable = FALSE

/datum/outfit/job/roguetown/assassin/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/datum/antagonist/new_antag = new /datum/antagonist/assassin()
		H.mind.add_antag_datum(new_antag)
		H.grant_language(/datum/language/thievescant)
		addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "ASSASSIN"), 5 SECONDS)
		var/wanted = list("我是臭名昭著的罪犯", "我是无名之辈")
		var/wanted_choice = input("你是否是个知名罪犯？") as anything in wanted
		switch(wanted_choice)
			if("我是臭名昭著的罪犯") //Extra challenge for those who want it
				bandit_select_bounty(H)
				ADD_TRAIT(H, TRAIT_KNOWNCRIMINAL, TRAIT_GENERIC)
			if("我是无名之辈") //Nothing ever happens
				return
