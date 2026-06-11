// Wretch, soft antagonists. Giving them a significant boon in stats due to their general presence as driving antagonists.
/datum/job/roguetown/wretch
	title = "Wretch"
	display_title = "流放者"
	flag = WRETCH
	department_flag = WANDERERS
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	allowed_races = RACES_ALL_KINDS
	tutorial = "在人生的某个岔路口，你坠进了文明的背阴面。过往恶行的后果一路追着你不放，你只能终日游荡在道路之间，盯着落单的倒霉鬼和松散的钱袋，勉强混口饭吃。"
	outfit = null
	outfit_female = null
	display_order = JDO_WRETCH
	show_in_credits = FALSE
	min_pq = 30//60>50>30. What a world. Fingers crossed that folks aren't as bad with it now.
	max_pq = null

	obsfuscated_job = TRUE
	class_categories = TRUE

	advclass_cat_rolls = list(CTAG_WRETCH = 20)
	PQ_boost_divider = 10
	round_contrib_points = 2

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE
	same_job_respawn_delay = 1 MINUTES
	virtue_restrictions = list(/datum/virtue/heretic/zchurch_keyholder) //all wretch classes automatically get this
	carebox_table = /datum/carebox_table/wretch
	job_traits = list(TRAIT_STEELHEARTED, TRAIT_OUTLAW, TRAIT_HERESIARCH, TRAIT_SELF_SUSTENANCE, TRAIT_ZURCH)
	job_subclasses = list(
		/datum/advclass/wretch/licker,
		/datum/advclass/wretch/deserter,
		/datum/advclass/wretch/deserter/maa,
		/datum/advclass/wretch/berserker,
		/datum/advclass/wretch/hedgemage,
		/datum/advclass/wretch/necromancer,
		/datum/advclass/wretch/heretic,
		/datum/advclass/wretch/heretic/spy,
		/datum/advclass/wretch/outlaw,
		/datum/advclass/wretch/outlaw/marauder,
		/datum/advclass/wretch/lunacyembracer,
		/datum/advclass/wretch/poacher,
		/datum/advclass/wretch/plaguebearer,
		/datum/advclass/wretch/pyromaniac,
		/datum/advclass/wretch/vigilante,
		/datum/advclass/wretch/blackoakwyrm,
		/datum/advclass/wretch/antipope,
		/datum/advclass/wretch/ancientchampion,
	)

/datum/job/roguetown/wretch/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		// Assign wretch antagonist datum so wretches appear in antag list
		if(H.mind && !H.mind.has_antag_datum(/datum/antagonist/wretch))
			var/datum/antagonist/new_antag = new /datum/antagonist/wretch()
			H.mind.add_antag_datum(new_antag)

// Proc for wretch to select a bounty
/proc/wretch_select_bounty(mob/living/carbon/human/H)
	var/bounty_poster = input(H, "是谁悬赏通缉了你？", "悬赏发布者") as anything in list("[SSmapping.map_adjustment.realm_name]司法庭", "格伦泽尔霍夫特 神圣教廷", "奥塔瓦 正教会")
	// Felinid said we should gate it at 100 or so on at the lowest, so that wretch cannot ezmode it.
	var/bounty_severity = input(H, "你的罪行有多严重？", "悬赏金额") as anything in list("轻罪", "伤人害命（+1 幸运）", "骇人暴行（全属性+1）")
	var/race = H.dna.species
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
	var/bounty_total = rand(100, 400) // Just in case
	switch(bounty_severity)
		if("轻罪")
			bounty_total = rand(100, 200)
		if("伤人害命（+1 幸运）")
			bounty_total = rand(200, 300)
			H.change_stat("fortune", 1)
		if("骇人暴行（全属性+1）")
			bounty_total = rand(300, 400) // Let's not make it TOO profitable
			H.change_stat("strength", 1)
			H.change_stat("perception", 1)
			H.change_stat("intelligence", 1)
			H.change_stat("constitution", 1)
			H.change_stat("willpower", 1)
			H.change_stat("speed", 1)
			H.change_stat("fortune", 1)
			if(bounty_poster == "[SSmapping.map_adjustment.realm_name]司法厅")
				GLOB.outlawed_players += H.real_name
			else
				GLOB.excommunicated_players += H.real_name
	var/my_crime = input(H, "你的罪名是什么？", "罪名") as text|null
	if (!my_crime)
		my_crime = "冒犯王权之罪"
	add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, FALSE, my_crime, bounty_poster)
	to_chat(H, span_danger("你正在扮演一名对抗性角色。既然选择以流寇身份加入，你就应当主动与其他玩家制造冲突。若未能以符合该身份分量的方式进行扮演，可能会因低质量角色扮演而受到处罚。"))
	H.playsound_local(get_turf(H), 'sound/music/traitor.ogg', 60, FALSE, pressure_affected = FALSE)

/proc/update_wretch_slots()
	var/datum/job/wretch_job = SSjob.GetJob("Wretch")
	if(!wretch_job)
		return

	var/player_count = length(GLOB.joined_player_list)
	var/slots = 5

	//Add 1 slot for every 10 players over 30. Less than 40 players, 5 slots. 40 or more players, 6 slots. 50 or more players, 7 slots - etc.
	if(player_count > 40)
		var/extra = floor((player_count - 40) / 10)
		slots += extra

	//5 slots minimum, 10 maximum.
	slots = min(slots, 10)

	wretch_job.total_positions = slots
	wretch_job.spawn_positions = slots
