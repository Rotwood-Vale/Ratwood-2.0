/datum/charflaw/lawless
	name = "Lawless"
	desc = "I've always felt the rules were a bit more like guidelines than actual rules, and have accrued enough notoriety to have a bounty out on my head. (Taking this vice when on a class that already has a roundstart bounty will randomize your flaw instead.)"
	configurable = TRUE
	var/face_known = "They know my face"
	var/bounty_poster = "Justiciary"
	var/bounty_severity = "Misdeed"
	var/my_crime = ""

/datum/charflaw/lawless/proc/poster_options()
	return list("Justiciary" = "The Justiciary of [SSmapping.map_adjustment?.realm_name]", "Holy See" = "The Grenzelhoftian Holy See", "Orthodoxy" = "The Otavan Orthodoxy")

/datum/charflaw/lawless/config_summary()
	return "<b>Face</b>: [face_known]<br><b>Poster</b>: [bounty_poster]<br><b>Severity</b>: [bounty_severity]<br><b>Crime</b>: [my_crime || "crimes against the Crown"]"

/datum/charflaw/lawless/save_config()
	return list("face_known" = face_known, "bounty_poster" = bounty_poster, "bounty_severity" = bounty_severity, "my_crime" = my_crime)

/datum/charflaw/lawless/load_config(list/data)
	if(!islist(data))
		return
	if(data["face_known"] in list("They know my face", "They know only my features"))
		face_known = data["face_known"]
	if(data["bounty_poster"] in poster_options())
		bounty_poster = data["bounty_poster"]
	if(data["bounty_severity"] in list("Misdeed", "Harm towards lyfe", "Horrific atrocities"))
		bounty_severity = data["bounty_severity"]
	my_crime = data["my_crime"]

/datum/charflaw/lawless/configure(mob/user)
	var/choice = tgui_input_list(user, "Is your face known to the authorities?", "Visibility Status", list("They know my face", "They know only my features"), face_known)
	if(choice)
		face_known = choice
	choice = tgui_input_list(user, "Who placed a bounty on you?", "Bounty Poster", poster_options(), bounty_poster)
	if(choice)
		bounty_poster = choice
	choice = tgui_input_list(user, "How severe are your crimes?", "Bounty Amount", list("Misdeed", "Harm towards lyfe", "Horrific atrocities"), bounty_severity)
	if(choice)
		bounty_severity = choice
	var/crime = tgui_input_text(user, "What is your crime?", "Crime", my_crime, 100)
	if(!isnull(crime))
		my_crime = crime

/datum/charflaw/lawless/on_mob_creation(mob/H)
	if(istype(H, /mob/living/carbon/human/dummy)) // DON'T TRY TO APPLY THIS FUCKING FLAW TO PREVIEW DUMMIES HOLY SHIT
		return
	addtimer(CALLBACK(src, PROC_REF(set_up), H), 30 SECONDS)

/datum/charflaw/lawless/proc/set_up(mob/living/carbon/human/H)
	if (has_bounty(H) || (H.job && H.job == "Wretch") || (H.advjob && H.advjob == "Wanted") || (H.job && H.job == "Bandit"))
		// no doubling up on this stuff, you just get a random flaw instead.
		var/list/flaws_without_random = GLOB.character_flaws.Copy()
		flaws_without_random -= "Random or No Flaw"
		var/datum/charflaw/our_new_flaw = GLOB.character_flaws[pick(flaws_without_random)]
		H.charflaw = new our_new_flaw()
		H.charflaw.on_mob_creation(H)
		to_chat(H, span_warning("The thrill of lawlessness is not enough anymore... fate renders my flaw to be: <b>[H.charflaw.name]</b>."))
		return

	var/race = H.dna.species
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
	var/bounty_total = rand(100, 200)
	switch(bounty_severity)
		if("Misdeed")
			bounty_total = rand(50, 100)
		if("Harm towards lyfe")
			bounty_total = rand(100, 150)
		if("Horrific atrocities")
			bounty_total = rand(150, 200)
	var/poster_name = poster_options()[bounty_poster]
	add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, FALSE, my_crime || "crimes against the Crown", poster_name)
	if(HAS_TRAIT(H, TRAIT_NOBLE))
		REMOVE_TRAIT(H, TRAIT_NOBLE, JOB_TRAIT)
		REMOVE_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
		REMOVE_TRAIT(H, TRAIT_NOBLE, ADVENTURER_TRAIT)
		ADD_TRAIT(H, TRAIT_DISGRACED_NOBLE, TRAIT_GENERIC)
		H.is_noble()
	if (face_known == "They know my face")
		if(bounty_poster == "Justiciary")
			GLOB.outlawed_players += H.real_name
		else
			GLOB.excommunicated_players += H.real_name
	to_chat(H, span_notice("There's a sum of mammons on my head... better lay low."))
