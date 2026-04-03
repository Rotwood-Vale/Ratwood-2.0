/datum/job/roguetown/bandit //pysdon above there's like THREE bandit.dms now I'm so sorry. This one is latejoin bandits, the one in villain is the antag datum, and the one in the 'antag' folder is an old adventurer class we don't use. Good luck!
	title = "Bandit"
	flag = BANDIT
	department_flag = WANDERERS
	faction = "Station"
	total_positions = 5	//bare minimum of five on round start, regardless of garrison/holywarrior count
	spawn_positions = 5
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
	allowed_patrons = /datum/patron/inhumen/matthios // Bandits bro, they rob you blind

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
		H.choose_name_popup("BANDIT")
		bandit_select_bounty(H)

// Changed up proc from Wretch to suit bandits bit more
/proc/bandit_select_bounty(mob/living/carbon/human/H)
	var/wanted = input(H, "Are you wanted by the kingdom?", "You will be more skilled from your experience") as anything in list("Yes", "No")
	if(wanted == "No") 
		to_chat(H, span_warning("I am still relatively new to the gang. My crimes have gone unnoticed so far, but I lack experience."))
		return null
	var/bounty_poster = input(H, "Who placed a bounty on you?", "Bounty Poster") as anything in list("The Justiciary of Rotwood", "The Grenzelhoftian Holy See")
	var/bounty_severity = input(H, "How notorious are you?", "Bounty Amount") as anything in list("Small Game", "Highwayman", "Vale Boogeyman")
	var/race = H.dna.species
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
	var/bounty_total = rand(200, 600)
	var/my_crime = input(H, "What is your crime?", "Crime") as text|null
	if (!my_crime)
		my_crime = "Brigandry"
	switch(bounty_severity)
		if("Small Game")
			bounty_total = rand(200, 300)
		if("Highwayman")
			bounty_total = rand(300, 400)
		if("Vale Boogeyman")
			bounty_total = rand(500, 600)
	if(bounty_severity == "Small Game")
		add_bounty_obscure(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, TRUE, my_crime, bounty_poster)
	else if(bounty_severity == "Highwayman")
		add_bounty_noface(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, TRUE, my_crime, bounty_poster)
	else
		add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, TRUE, my_crime, bounty_poster)
		var/skillbuff = input(H, "Your experience grants you a boon", "Choose An Attribute") as anything in list("Strength", "Perception", "Intelligence", "Constitution", "Willpower", "Speed")
		switch(skillbuff)
			if("Strength")
				H.change_stat(STATKEY_STR, 1)
			if("Perception")
				H.change_stat(STATKEY_PER, 1)
			if("Intelligence")
				H.change_stat(STATKEY_INT, 1)
			if("Constitution")
				H.change_stat(STATKEY_CON, 1)
			if("Willpower")
				H.change_stat(STATKEY_WIL, 1)
			if("Speed")
				H.change_stat(STATKEY_SPD, 1)
	to_chat(H, span_danger("You are playing an Antagonist role. By choosing to spawn as a Bandit, you are expected to actively create conflict with other players regardless of bounty status. Failing to play this role with the appropriate gravitas may result in punishment for Low Roleplay standards."))

/proc/update_bandit_slots()
	var/datum/job/bandit_job = SSjob.GetJob("Bandit")
	if(!bandit_job)
		return

	var/player_count = length(GLOB.joined_player_list)
	var/slots = 5

	//Add 1 slot for every 12 players over 30.
	if(player_count > 42)
		var/extra = floor((player_count - 42) / 12)
		slots += extra

	//5 slots minimum, 7 maximum.
	slots = min(slots, 9)

	bandit_job.total_positions = slots
	bandit_job.spawn_positions = slots
