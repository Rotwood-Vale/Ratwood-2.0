/datum/job/roguetown/bandit //pysdon above there's like THREE bandit.dms now I'm so sorry. This one is latejoin bandits, the one in villain is the antag datum, and the one in the 'antag' folder is an old adventurer class we don't use. Good luck!
	title = "Bandit"
	flag = BANDIT
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 3	//bare minimum of three on round start, regardless of garrison/holywarrior count
	spawn_positions = 3
	antag_job = TRUE
	allowed_races = RACES_ALL_KINDS
	tutorial = "At some point in your lyfe, you'd fallen to the wrong side of the carriage. Whether by butchery or finesse, you're known throughout the land. \
	Yet one of many faces in a tavern, hung up on a wall. A tale told by the locals. Now, you lyve in a camp with your fellows, to avoid an unpleasant end."

	outfit = null
	outfit_female = null

	obsfuscated_job = TRUE

	display_order = JDO_BANDIT
	announce_latejoin = FALSE
	min_pq = 3
	max_pq = null
	round_contrib_points = 5
	allowed_patrons = ALL_INHUMEN_PATRONS//YEAH!!! MURDER!!!

	advclass_cat_rolls = list(CTAG_BANDIT = 20)
	PQ_boost_divider = 10

	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE //no endless stream of bandits, unless the migration waves deem it so
	job_traits = list(TRAIT_SELF_SUSTENANCE, TRAIT_DEATHBYSNUSNU, TRAIT_STEELHEARTED, TRAIT_KNOWNCRIMINAL)
	same_job_respawn_delay = 1 MINUTES
	cmode_music = 'sound/music/cmode/antag/combat_deadlyshadows.ogg'
	job_subclasses = list(
		/datum/advclass/brigand,
		/datum/advclass/hedgeknight,
		/datum/advclass/iconoclast,
		/datum/advclass/knave,
		/datum/advclass/roguemage,
		/datum/advclass/sawbones,
		/datum/advclass/sellsword,
		/datum/advclass/pioneer
	)

/datum/job/roguetown/bandit/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		if(!H.mind)
			return
		H.ambushable = FALSE

/datum/outfit/job/roguetown/bandit/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.verbs |= /mob/proc/haltyell_exhausting

/datum/outfit/job/roguetown/bandit/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/datum/antagonist/new_antag = new /datum/antagonist/bandit()
		H.mind.add_antag_datum(new_antag)
		H.grant_language(/datum/language/thievescant)
		addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "BANDIT"), 5 SECONDS)
		bandit_select_bounty(H)

// Changed up proc from Wretch to suit bandits bit more
/proc/bandit_select_bounty(mob/living/carbon/human/H)
	var/bounty_poster = input(H, "Who placed a bounty on you?", "Bounty Poster") as anything in list("The Justiciary of Rotwood", "The Grenzelhoftian Holy See")
	var/bounty_severity = input(H, "How notorious are you?", "Bounty Amount") as anything in list("Small Fish", "Bay Butcher", "Vale Boogeyman")
	var/race = H.dna.species
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
	var/bounty_total = rand(300, 600)
	switch(bounty_severity)
		if("Small Fish")
			bounty_total = rand(300, 400)
		if("Rockhill Butcher")
			bounty_total = rand(400, 500)
		if("Vale Boogeyman")
			bounty_total = rand(500, 600)
	var/my_crime = input(H, "What is your crime?", "Crime") as text|null
	if (!my_crime)
		my_crime = "Brigandry"
	add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, FALSE, my_crime, bounty_poster)

/proc/update_bandit_slots()
	var/datum/job/bandit_job = SSjob.GetJob("Bandit")
	if(!bandit_job)
		return

	var/player_count = length(GLOB.joined_player_list)
	var/slots = 3

	//Add 1 slot for every 12 players over 30.
	if(player_count > 42)
		var/extra = floor((player_count - 42) / 12)
		slots += extra

	//3 slots minimum, 7 maximum.
	slots = min(slots, 7)

	bandit_job.total_positions = slots
	bandit_job.spawn_positions = slots