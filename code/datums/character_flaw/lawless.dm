/datum/charflaw/lawless
	name = "无法无天"
	desc = "我一直觉得规矩更像建议而不是真正的规则，也早已恶名昭彰到脑袋上挂了悬赏。（若你的职业开局本就自带悬赏，再选这个缺陷会改为随机缺陷。）"
	var/attempts_left = 2

/datum/charflaw/lawless/on_mob_creation(mob/H)
	if(istype(H, /mob/living/carbon/human/dummy)) // DON'T TRY TO APPLY THIS FUCKING FLAW TO PREVIEW DUMMIES HOLY SHIT
		return
	addtimer(CALLBACK(src, PROC_REF(set_up), H), 30 SECONDS)

/datum/charflaw/lawless/proc/set_up(mob/living/carbon/human/H)
	if (has_bounty(H) || (H.job && H.job == "Wretch") || (H.advjob && H.advjob == "Wanted") || (H.job && H.job == "Bandit"))
		// no doubling up on this stuff, you just get a random flaw instead.
		var/list/flaws_without_random = GLOB.character_flaws.Copy()
		flaws_without_random -= "随机或无缺陷"
		var/datum/charflaw/our_new_flaw = GLOB.character_flaws[pick(flaws_without_random)]
		H.charflaw = new our_new_flaw()
		H.charflaw.on_mob_creation(H)
		to_chat(H, span_warning("无法无天带来的刺激已经不够了……命运将我的缺陷改写为：<b>[H.charflaw.name]</b>。"))
		return

	// if our mob has no client, input will runtime
	if(!H.client) // if our player somehow disconnected, give them another shot
		if(attempts_left <= 0)
			return // give up
		attempts_left--
		addtimer(CALLBACK(src, PROC_REF(set_up), H), 30 SECONDS)
		return
	var/face_known = input(H, "当局知道你的长相吗？", "暴露程度") as anything in list ("他们认得我的脸", "他们只知道我的体貌特征")
	var/bounty_poster = input(H, "是谁悬赏缉拿你？", "悬赏发布者") as anything in list("[SSmapping.map_adjustment.realm_name]司法厅", "格伦泽尔霍夫特教廷", "奥塔瓦正教会")
	var/bounty_severity = input(H, "你的罪行有多严重？", "悬赏金额") as anything in list("轻罪", "伤人害命", "骇人暴行")
	var/race = H.dna.species
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
	var/bounty_total = rand(100, 200)
	switch(bounty_severity)
		if("轻罪")
			bounty_total = rand(50, 100)
		if("伤人害命")
			bounty_total = rand(100, 150)
		if("骇人暴行")
			bounty_total = rand(150, 200)
	var/my_crime = input(H, "你的罪名是什么？", "罪名") as text|null
	if (!my_crime)
		my_crime = "冒犯王权之罪"
	add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, FALSE, my_crime, bounty_poster)
	if(HAS_TRAIT(H, TRAIT_NOBLE))
		REMOVE_TRAIT(H, TRAIT_NOBLE, JOB_TRAIT)
		REMOVE_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
		REMOVE_TRAIT(H, TRAIT_NOBLE, ADVENTURER_TRAIT)
		ADD_TRAIT(H, TRAIT_DISGRACED_NOBLE, TRAIT_GENERIC)
		H.is_noble()
	if (face_known == "他们认得我的脸")
		if(bounty_poster == "[SSmapping.map_adjustment.realm_name]司法厅")
			GLOB.outlawed_players += H.real_name
		else
			GLOB.excommunicated_players += H.real_name
	to_chat(H, span_notice("我的脑袋值上一笔玛门币……最好先避避风头。"))
