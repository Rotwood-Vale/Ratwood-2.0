/mob/living/carbon/human/proc/load_char_or_namechoice()
	if(QDELETED(src))
		return

	if(!client?.prefs?.path)
		addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup)), 3 SECONDS)
		addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_pronouns_and_body)), 7 SECONDS)
		return

	var/list/choices = list()
	var/savefile/S = new /savefile(client.prefs.path)
	if(S)
		for(var/i=1, i<=client.prefs.max_save_slots, i++)
			var/name
			S.cd = "/character[i]"
			S["real_name"] >> name
			if(!name)
				name = "存档位[i]"
			choices[name] = i

	choices += "自己取名"

	var/choice = tgui_input_list(src, "你想使用已有角色，还是自己取一个名字？","选择英雄", choices)
	if(QDELETED(src))
		return

	if(!client?.prefs || choice == "自己取名")
		addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup)), 3 SECONDS)
		addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_pronouns_and_body)), 7 SECONDS)
		return
	else
		choice = choices[choice]
		if(!client.prefs.load_character(choice))
			to_chat(src, span_userdanger("角色加载失败，现在将改为选择名字、身体与代称。"))
			addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup)), 3 SECONDS)
			addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_pronouns_and_body)), 7 SECONDS)
		else
			client.prefs.copy_to(src, TRUE, FALSE, FALSE, TRUE)
