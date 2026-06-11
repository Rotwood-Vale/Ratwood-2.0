/datum/job/roguetown/bandit //pysdon above there's like THREE bandit.dms now I'm so sorry. This one is latejoin bandits, the one in villain is the antag datum, and the one in the 'antag' folder is an old adventurer class we don't use. Good luck!
	title = "Bandit"
	display_title = "强盗"
	flag = BANDIT
	department_flag = WANDERERS
	faction = "Station"
	total_positions = 5	//bare minimum of five on round start, regardless of garrison/holywarrior count
	spawn_positions = 5
	antag_job = TRUE
	allowed_races = RACES_ALL_KINDS
	tutorial = "在你人生的某个节点，你走上了歧路。无论靠的是蛮横杀戮还是狡诈手段，你的恶名都已传遍四方。\
	如今你只是酒馆墙上众多通缉面孔中的一张，是本地人嘴里流传的故事。为了躲开凄惨的下场，你与同伙一同栖身营地。"

	outfit = null
	outfit_female = null

	obsfuscated_job = TRUE

	display_order = JDO_BANDIT
	announce_latejoin = FALSE
	min_pq = 3
	max_pq = null
	round_contrib_points = 5
	allowed_patrons = list(/datum/patron/inhumen/matthios) // Bandits bro, they rob you blind

	advclass_cat_rolls = list(CTAG_BANDIT = 20)
	PQ_boost_divider = 10

	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE //no endless stream of bandits, unless the migration waves deem it so
	job_traits = list(TRAIT_SELF_SUSTENANCE, TRAIT_DEATHBYSNUSNU, TRAIT_STEELHEARTED)
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
	var/wanted = list("是", "否")
	var/wanted_choice = input(H, "你是否正被王国通缉？", "你的阅历将让你更加老练") as anything in wanted
	switch(wanted_choice)
		if("是")
			ADD_TRAIT(H, TRAIT_KNOWNCRIMINAL, TRAIT_GENERIC)
		if("否") 
			to_chat(H, span_warning("我入伙还不算久。到目前为止，我的罪行尚未引起注意，但也因此缺了些历练。"))
			return null
	var/bounty_poster = input(H, "是谁悬赏缉拿你？", "悬赏发布者") as anything in list("[SSmapping.map_adjustment.realm_name]司法庭", "格伦泽尔霍夫特 神圣教廷")
	var/bounty_severity = input(H, "你的恶名有多响？", "悬赏金额") as anything in list("小角色", "拦路匪", "山谷梦魇")
	var/race = H.dna.species
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
	var/bounty_total = rand(200, 600)
	var/my_crime = input(H, "你的罪名是什么？", "罪名") as text|null
	if (!my_crime)
		my_crime = "劫掠"
	switch(bounty_severity)
		if("小角色")
			bounty_total = rand(200, 300)
		if("拦路匪")
			bounty_total = rand(300, 400)
		if("山谷梦魇")
			bounty_total = rand(500, 600)
	if(bounty_severity == "小角色")
		add_bounty_obscure(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, TRUE, my_crime, bounty_poster)
	else if(bounty_severity == "拦路匪")
		add_bounty_noface(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, TRUE, my_crime, bounty_poster)
	else
		add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, TRUE, my_crime, bounty_poster)
		var/skillbuff = input(H, "你的阅历为你带来恩惠", "选择一项属性") as anything in list("力量", "感知", "智力", "体质", "意志", "速度")
		switch(skillbuff)
			if("力量")
				H.change_stat(STATKEY_STR, 1)
			if("感知")
				H.change_stat(STATKEY_PER, 1)
			if("智力")
				H.change_stat(STATKEY_INT, 1)
			if("体质")
				H.change_stat(STATKEY_CON, 1)
			if("意志")
				H.change_stat(STATKEY_WIL, 1)
			if("速度")
				H.change_stat(STATKEY_SPD, 1)
	to_chat(H, span_danger("你正在扮演反派角色。选择以强盗身份生成后，无论是否背负悬赏，你都应主动与其他玩家制造冲突。若未能以足够分量演好此角色，可能会因低质量角色扮演而受到处罚。"))

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
