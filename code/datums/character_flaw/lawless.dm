/datum/charflaw/lawless
	name = "Lawless"
	desc = "I've always felt the rules were a bit more like guidelines than actual rules, and have accrued enough notoriety to have a bounty out on my head. (Taking this vice when on a class that already has a roundstart bounty will randomize your flaw instead.)"

/datum/charflaw/lawless/on_mob_creation(mob/H)
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

	var/face_known = input(H, "Is your face known to the authorities?", "Visbility Status") as anything in list ("They know my face", "They know only my features")
	var/bounty_poster = input(H, "Who placed a bounty on you?", "Bounty Poster") as anything in list("The Justiciary of The Vale", "The Grenzelhoftian Holy See", "The Otavan Orthodoxy")
	var/bounty_severity = input(H, "How severe are your crimes?", "Bounty Amount") as anything in list("Misdeed", "Harm towards lyfe", "Horrific atrocities")
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
	var/my_crime = input(H, "What is your crime?", "Crime") as text|null
	if (!my_crime)
		my_crime = "crimes against the Crown"
	add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, FALSE, my_crime, bounty_poster)
	if (face_known == "They know my face")
		if(bounty_poster == "The Justiciary of The Vale")
			GLOB.outlawed_players += H.real_name
		else
			GLOB.excommunicated_players += H.real_name
	to_chat(H, span_notice("There's a sum of mammons on my head... better lay low."))
