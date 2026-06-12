GLOBAL_LIST_EMPTY(active_group_mindlinks)

/datum/group_mindlink_custom
	var/list/participants = list()
	var/active = TRUE

/datum/group_mindlink_custom/New(list/new_participants)
	participants = list()
	for(var/mob/living/member as anything in new_participants)
		if(!istype(member) || (member in participants))
			continue
		participants += member
		GLOB.active_group_mindlinks[member] = src
		RegisterSignal(member, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	return ..()

/datum/group_mindlink_custom/Destroy()
	active = FALSE
	for(var/mob/living/member as anything in participants)
		if(GLOB.active_group_mindlinks[member] == src)
			GLOB.active_group_mindlinks -= member
		UnregisterSignal(member, COMSIG_MOB_SAY)
	participants = null
	return ..()

/datum/group_mindlink_custom/proc/handle_speech(mob/living/speaker, list/speech_args)
	SIGNAL_HANDLER

	if(!active)
		return

	var/message = speech_args[SPEECH_MESSAGE]
	if(!message)
		return

	if(findtext(message, ",m", 1, 3))
		message = trim(copytext(message, 3))
		if(!message)
			speech_args[SPEECH_MESSAGE] = null
			return

		for(var/mob/living/member as anything in participants)
			if(QDELETED(member))
				continue
			if(member == speaker)
				to_chat(member, span_purple("我向心灵链接投射思绪: \"[message]\""))
				continue
			to_chat(member, span_purple("[speaker.real_name] 的心念传入我的脑海: \"[message]\""))

		speech_args[SPEECH_MESSAGE] = null

/datum/group_mindlink_custom/proc/notify_expired()
	if(!active)
		return
	active = FALSE

	var/list/member_names = list()
	for(var/mob/living/member as anything in participants)
		if(QDELETED(member))
			continue
		member_names += member.real_name
	for(var/mob/living/member as anything in participants)
		if(QDELETED(member))
			continue
		to_chat(member, span_warning("我与[english_list(member_names)]之间的群体心灵链接逐渐消散了......"))

/obj/effect/proc_holder/spell/invoked/group_mindlink
	name = "群体心灵链接"
	desc = "将施法者与自己认识的人接入同一条心灵通话之中，持续五分钟。发言前输入 ,m 即可进行交流。"
	overlay_state = "mindlink"
	associated_skill = /datum/skill/magic/arcane
	cost = 5
	xp_gain = TRUE
	recharge_time = 6 MINUTES
	spell_tier = 3
	invocations = list("群念相连。")
	invocation_type = "whisper"
	chargedloop = /datum/looping_sound/invokegen
	chargedrain = 1
	chargetime = 5 SECONDS
	releasedrain = 30
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	warnie = "spellwarning"
	ignore_los = TRUE
	miracle = FALSE
	human_req = TRUE

/obj/effect/proc_holder/spell/invoked/group_mindlink/cast(list/targets, mob/living/user)
	. = ..()
	if(!istype(user) || !user.mind)
		return FALSE

	var/list/participant_mobs = list(user)
	var/list/participant_names = list()
	var/list/missing_names = list()

	if(!length(user.mind.known_people))
		to_chat(user, span_warning("没有我认识的人可供建立群体心灵链接！"))
		revert_cast()
		return FALSE

	for(var/person_name in user.mind.known_people)
		var/mob/living/found_person = find_known_human(person_name)
		if(!found_person)
			missing_names += person_name
			continue
		if(istype(found_person, /mob/living/simple_animal/hostile/retaliate/bat/crow))
			continue
		if(!(found_person in participant_mobs))
			participant_mobs += found_person

	if(length(participant_mobs) <= 1)
		to_chat(user, span_warning("我认识的人里，没有能加入群体心灵链接的对象。"))
		revert_cast()
		return FALSE

	user.visible_message(span_notice("[user] 轻触太阳穴，闭目凝神，随后一道无形的心灵网络在熟识之人之间铺展开来......"), span_notice("我将自己与熟识之人的心念编织进同一张无形之网。"))

	var/list/links_to_replace = list()
	for(var/mob/living/member as anything in participant_mobs)
		var/datum/group_mindlink_custom/existing_link = GLOB.active_group_mindlinks[member]
		if(existing_link && existing_link.active && !(existing_link in links_to_replace))
			links_to_replace += existing_link

	for(var/datum/group_mindlink_custom/existing_link as anything in links_to_replace)
		existing_link.notify_expired()
		qdel(existing_link)

	var/datum/group_mindlink_custom/link = new(participant_mobs)
	for(var/mob/living/member as anything in participant_mobs)
		participant_names += member.real_name
	for(var/mob/living/member as anything in participant_mobs)
		to_chat(member, span_notice("你被接入群体心灵链接。发言前输入 ,m 即可进行心灵交流。当前成员: [english_list(participant_names)]"))

	if(length(missing_names))
		to_chat(user, span_notice("这些熟识之人当前不在场或无法接入链接: [english_list(missing_names)]"))

	addtimer(CALLBACK(src, PROC_REF(break_link), link), 5 MINUTES)
	return TRUE

/obj/effect/proc_holder/spell/invoked/group_mindlink/proc/find_known_human(person_name)
	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == person_name)
			return HL
	return null

/obj/effect/proc_holder/spell/invoked/group_mindlink/proc/break_link(datum/group_mindlink_custom/link)
	if(!link || QDELETED(link) || !link.active)
		return
	link.notify_expired()
	qdel(link)
