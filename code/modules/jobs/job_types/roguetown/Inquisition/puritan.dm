/datum/job/roguetown/puritan
	title = "Inquisitor"
	display_title = "审判官"
	flag = PURITAN
	department_flag = INQUISITION
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT		//Would you trust a machine to handle a role that requires non-logical intuition and commanding? Maybe. Could undo this if the community likes it. Purpose-built supermachines sound cool, too.
	allowed_patrons = list(/datum/patron/old_god) //Requires your character's patron to be Psydon. This role is explicitly designed to be played by Psydonites, only, and almost everything they have - down to the equipment and statblock - is rooted in Psydonism. Do NOT make this accessable to other faiths, unless you go through the efforts of redesigning it from the ground up.
	tutorial = "你是一名才干无双的清教审判者，恪守 普赛顿 教义，并被赋予统领一支地方教派的权柄。奥塔瓦 作为这世上仅存最大的 普赛顿 王国，将你视作一枝银尖橄榄枝，赠往谷地以阻挡步步紧逼的黑暗。执行使命时务必谨慎，免得那些无信者也把你绑上火刑柱。"
	whitelist_req = TRUE
	cmode_music = 'sound/music/inquisitorcombat.ogg'
	selection_color = JCOLOR_INQUISITION

	outfit = /datum/outfit/job/roguetown/puritan
	display_order = JDO_PURITAN
	advclass_cat_rolls = list(CTAG_PURITAN = 20)
	give_bank_account = 30
	min_pq = 30
	max_pq = null
	round_contrib_points = 2
	social_rank = SOCIAL_RANK_NOBLE
	job_subclasses = list(
		/datum/advclass/puritan/inspector,
		/datum/advclass/puritan/ordinator,
		/datum/advclass/puritan/arbiter
	)

/datum/outfit/job/roguetown/puritan
	name = "审判官"
	jobtype = /datum/job/roguetown/puritan
	job_bitflag = BITFLAG_HOLY_WARRIOR	//Counts as church.
	allowed_patrons = list(/datum/patron/old_god)

/obj/item/clothing/gloves/roguetown/chain/blk
		color = CLOTHING_GREY

/obj/item/clothing/under/roguetown/chainlegs/blk
		color = CLOTHING_GREY

/obj/item/clothing/suit/roguetown/armor/plate/blk
		color = CLOTHING_GREY

/obj/item/clothing/shoes/roguetown/boots/armor/blk
		color = CLOTHING_GREY

/mob/living/carbon/human/proc/faith_test()
	set name = "验明信仰"
	set category = "审讯"
	var/obj/item/grabbing/I = get_active_held_item()
	var/mob/living/carbon/human/H
	var/obj/item/S = get_inactive_held_item()
	var/found = null
	if(!istype(I) || !ishuman(I.grabbed))
		to_chat(src, span_warning("我手里没有受审者！"))
		return
	H = I.grabbed
	if(H == src)
		to_chat(src, span_warning("我早就在折磨自己了。"))
		return
	if (!H.restrained())
		to_chat(src, span_warning ("要这么做，我的受审者必须先被束缚住！"))
		return
	if(!istype(S, /obj/item/clothing/neck/roguetown/psicross/silver))
		to_chat(src, span_warning("我必须手持一枚银制 普赛圣十字，才能逼出这道神谕！"))
		return
	for(var/obj/structure/fluff/psycross/N in oview(5, src))
		found = N
	if(!found)
		to_chat(src, span_warning("我附近必须有一座大型 普赛圣十字 构造，才能逼出这道神谕！"))
		return
	if(!H.stat)
		var/static/list/faith_lines = list(
			"你向谁祈祷！？",
			"你的神是谁！？",
			"你可还忠信！？",
			"谁是你的牧者！？",
		)
		src.visible_message(span_warning("[src] 把银制 普赛圣十字 猛地杵到 [H] 脸上！"))
		say(pick(faith_lines), spans = list("torture"))
		H.emote("agony", forced = TRUE)

		if(!(do_mob(src, H, 10 SECONDS)))
			return
		src.visible_message(span_warning("[src] 手中的银制 普赛圣十字 猛然起火，转瞬便烧成灰烬！"))
		H.confess_sins("patron")
		qdel(S)
		return
	to_chat(src, span_warning("这人现在还没到能受审的状态……"))

/mob/living/carbon/human/proc/confess_sins(confession_type = "antag")
	var/static/list/innocent_lines = list(
		"我不是罪人！",
		"我是清白的！",
		"我没什么可招认的！",
		"我心怀信仰！",
	)
	var/list/confessions = list()
	switch(confession_type)
		if("patron")
			if(length(patron?.confess_lines))
				confessions += patron.confess_lines
		if("antag")
			for(var/datum/antagonist/antag in mind?.antag_datums)
				if(!length(antag.confess_lines))
					continue
				confessions += antag.confess_lines
	if(length(confessions))
		say(pick(confessions), spans = list("torture"))
		return
	say(pick(innocent_lines), spans = list("torture"))

/mob/living/carbon/human/proc/torture_victim()
	set name = "逼问效忠"
	set category = "审讯"
	var/obj/item/grabbing/I = get_active_held_item()
	var/mob/living/carbon/human/H
	var/obj/item/S = get_inactive_held_item()
	var/found = null
	if(!istype(I) || !ishuman(I.grabbed))
		to_chat(src, span_warning("我手里没有受审者！"))
		return
	H = I.grabbed
	if(H == src)
		to_chat(src, span_warning("我早就在折磨自己了。"))
		return
	if (!H.restrained())
		to_chat(src, span_warning ("要这么做，我的受审者必须先被束缚住！"))
		return
	if(!istype(S, /obj/item/clothing/neck/roguetown/psicross/silver))
		to_chat(src, span_warning("我必须手持一枚银制 普赛圣十字，才能逼出这道神谕！"))
		return
	for(var/obj/structure/fluff/psycross/N in oview(5, src))
		found = N
	if(!found)
		to_chat(src, span_warning("我附近必须有一座大型 普赛圣十字 构造，才能逼出这道神谕！"))
		return
	if(!H.stat)
		var/static/list/torture_lines = list(
			"招认！",
			"把你的秘密说出来！",
			"开口！",
			"你必须开口！",
			"说！",
		)
		say(pick(torture_lines), spans = list("torture"))
		H.emote("agony", forced = TRUE)

		if(!(do_mob(src, H, 10 SECONDS)))
			return
		src.visible_message(span_warning("[src] 手中的银制 普赛圣十字 猛然起火，转瞬便烧成灰烬！"))
		H.confess_sins("antag")
		qdel(S)
		return
	to_chat(src, span_warning("这人现在还没到能受审的状态……"))
