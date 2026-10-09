/datum/antagonist/ukj_dark_itinerant
	name = "Dark Itinerant"
	roundend_category = "Dark Itinerant"
	antagpanel_category = "Dark Itinerant"
	job_rank = ROLE_DARK_ITINERANT
	confess_lines = list(
		"PSYDON IS THE DEMIURGE!",
		"THE TEN ARE WORTHLESS COWARDS!",
		"THE TEN ARE DECEIVERS!",
	)
	rogue_enabled = TRUE

/datum/antagonist/ukj_dark_itinerant/on_gain()
	. = ..()
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return

	if(!istype(H.patron, /datum/patron/inhumen))
		H.set_patron(/datum/patron/inhumen/zizo)//If you're not of the Inhumen before? You are now!
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.faction = list("undead")
			to_chat(owner, span_danger("ENOUGH IS NEVER ENOUGH. The Pale Lady whispers from below, and I SHALL ANSWER."))
		if(/datum/patron/inhumen/matthios)
			to_chat(owner, span_danger("NO LORD OWNS ME. The Manyfaced whispers from the shadows, and I SHALL TAKE WHAT IS OWED."))
		if(/datum/patron/inhumen/baotha)
			to_chat(owner, span_danger("WHY DENY MYSELF ANYTHING? The Lady of Debauchery whispers sweetly, and I SHALL ANSWER."))
		if(/datum/patron/inhumen/graggar)
			to_chat(owner, span_danger("THE WEAK EXIST TO BE CONQUERED. The Gorebound Star howls for blood, and I SHALL WREAK HAVOC."))

/datum/antagonist/ukj_dark_itinerant/varlet
	name = "Varlet"
	roundend_category = "Varlet"
	antagpanel_category = "Varlet"

/datum/antagonist/ukj_dark_itinerant/dark_chaplain
	name = "Wordbearer"
	roundend_category = "Wordbearer"
	antagpanel_category = "Wordbearer"
