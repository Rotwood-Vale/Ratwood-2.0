// Bounty vice that uses wretch-style selection menu
// Player selects who placed the bounty and severity when they spawn

/datum/charflaw/excidiumbounty
	name = "Hungered by Excidium (+1 TRI)"
	desc = "Somewhere in my past, I've made powerful enemies. A bounty has been placed on my head."

/datum/charflaw/excidiumbounty/on_mob_creation(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	
	// Grant triumph for taking this flaw
	H.adjust_triumphs(1)
	
	// Set up a timer to show bounty selection after character creation is complete
	addtimer(CALLBACK(src, PROC_REF(select_bounty), H), 5 SECONDS)

/datum/charflaw/excidiumbounty/proc/select_bounty(mob/living/carbon/human/H)
	if(!H || !H.mind)
		return
	
	// Prompt for who placed the bounty
	var/bounty_poster = input(H, "Who placed a bounty on you?", "Bounty Poster") as anything in list("The Justiciary of The Vale", "The Grenzelhoftian Holy See", "The Otavan Orthodoxy")
	if(!bounty_poster)
		bounty_poster = "The Justiciary of The Vale"
	
	// Prompt for severity based on bounty poster
	var/bounty_severity
	if(bounty_poster == "The Justiciary of The Vale")
		bounty_severity = input(H, "How severe are your crimes?", "Crime Severity") as anything in list("Misdemeanor", "Felony", "Atrocity")
		if(!bounty_severity)
			bounty_severity = "Misdemeanor"
	else
		bounty_severity = input(H, "How severe are your sins?", "Sin Severity") as anything in list("Transgression", "Heresy", "Apostasy")
		if(!bounty_severity)
			bounty_severity = "Transgression"
	
	// Apply appropriate trait based on combination
	var/applied_trait
	if(bounty_poster == "The Justiciary of The Vale")
		// Criminal bounties
		switch(bounty_severity)
			if("Misdemeanor")
				applied_trait = TRAIT_MISDEMEANANT
			if("Felony")
				applied_trait = TRAIT_LAWBREAKER
			if("Atrocity")
				applied_trait = TRAIT_CRIMINAL
	else
		// Heretic bounties (Holy See or Orthodoxy)
		switch(bounty_severity)
			if("Transgression")
				applied_trait = TRAIT_HERETIC_MINOR
			if("Heresy")
				applied_trait = TRAIT_HERETIC_MAJOR
			if("Apostasy")
				applied_trait = TRAIT_HERETIC_VILE
	
	// Apply the trait
	ADD_TRAIT(H, applied_trait, TRAIT_GENERIC)
	
	// Get character descriptors
	var/race = H.dna.species
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
	
	// Calculate bounty amount based on severity
	var/bounty_total = rand(100, 400)
	switch(bounty_severity)
		if("Misdemeanor", "Transgression")
			bounty_total = rand(50, 150)
		if("Felony", "Heresy")
			bounty_total = rand(200, 300)
		if("Atrocity", "Apostasy")
			bounty_total = rand(300, 400)
			// Add to outlawed/excommunicated list for most severe crimes
			if(bounty_poster == "The Justiciary of The Vale")
				GLOB.outlawed_players += H.real_name
			else
				GLOB.excommunicated_players += H.real_name
	
	// Prompt for crime description
	var/my_crime = input(H, "What is your crime?", "Crime") as text|null
	if(!my_crime)
		if(bounty_poster == "The Justiciary of The Vale")
			my_crime = "crimes against the Crown"
		else
			my_crime = "heresy and blasphemy"
	
	// Add the bounty
	add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, FALSE, my_crime, bounty_poster)
	
	to_chat(H, span_warning("A bounty has been placed on your head by [bounty_poster] for [my_crime]. Beware the law!"))
