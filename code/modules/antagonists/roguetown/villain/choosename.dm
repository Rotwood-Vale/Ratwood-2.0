/mob/living/carbon/human/proc/choose_name_popup(input)
	if(QDELETED(src))
		return
	var/old_name = real_name
	if(!stat)
		if(job)
			var/datum/job/j = SSjob.GetJob(job)
			if(!j.antag_job)
				j.current_positions--
		mob_timers["mirrortime"] = world.time
		var/begin_time = world.time
		var/new_name = input(src, "你的[input]名字该叫什么？", "面具")
		if(world.time > begin_time + 180 SECONDS)
			to_chat(src, "<font color='red'>你等得太久了。</font>")
			return
		new_name = reject_bad_name(new_name)
		if(new_name)
			if(new_name in GLOB.chosen_names)
				to_chat(src, "<font color='red'>这个名字已经被占用了。</font>")
				return
			else
				real_name = new_name
		else
			to_chat(src, "<font color='red'>无效名称。你的名字长度必须在 2 到 [MAX_NAME_LEN] 个字符之间，且只能包含 A-Z、a-z、-、'、. 和 ,。</font>")
			return
	GLOB.chosen_names -= old_name
	GLOB.chosen_names += real_name
	if(mind.special_role == "Methuselah")
		if(gender == FEMALE)
			real_name = "女爵 [real_name]"
		if(gender == MALE)
			real_name = "领主 [real_name]"
	if(mind.special_role == "Lich")
		mind.current.faction += "[real_name]_faction"

	mind.name = real_name
	var/fakekey = ckey
	if(ckey in GLOB.anonymize)
		fakekey = get_fake_key(ckey)
	GLOB.character_list[mobid] = "[fakekey] was [real_name] ([input])<BR>"
	if(GLOB.character_ckey_list[old_name])
		GLOB.character_ckey_list -= old_name
	GLOB.character_ckey_list[real_name] = ckey
	log_character("[ckey] - [real_name] - [input]")
	log_manifest(ckey,mind,src,latejoin = TRUE)
	for(var/datum/antagonist/A as anything in mind.antag_datums)
		A.after_name_change()
