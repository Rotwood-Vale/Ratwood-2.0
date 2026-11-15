/mob/living/carbon/human/proc/apply_expedition_badge(goal)
	ADD_TRAIT(src, TRAIT_EXPEDITION_MEMBER, TRAIT_GENERIC)
	to_chat(src, "<h2 style='color: gold;'>You have been consecrated for the Crusade for [goal]!</h2>")
	to_chat(src, span_boldnotice("March to the borderlands gateway with your vanguard! Check your 'Crusade' tab."))
	playsound(src, 'sound/misc/bell.ogg', 50, FALSE)

/mob/living/carbon/human/proc/remove_expedition_badge()
	REMOVE_TRAIT(src, TRAIT_EXPEDITION_MEMBER, TRAIT_GENERIC)

/mob/living/carbon/human/proc/update_hud_crusader()
	return

/proc/complete_expedition(success = TRUE)
	if(GLOB.expedition_status == EXPEDITION_COMPLETED)
		return

	if(success)
		GLOB.expedition_status = EXPEDITION_COMPLETED
		priority_announce(
			"Rejoice! The royal expedition has vanquished the ancient terror and returns victorious with great riches!",
			"EXPEDITION TRIUMPH",
			'sound/misc/bell.ogg',
			"Captain"
		)
	else
		GLOB.expedition_status = EXPEDITION_COMPLETED
		priority_announce(
			"Mournful tidings. The royal expedition has fallen in the dark depths. The realm weeps for its vanguard.",
			"EXPEDITION LOST",
			'sound/misc/lawspurged.ogg',
			"Captain"
		)

	for(var/mob/living/carbon/human/member in GLOB.expedition_party)
		if(!QDELETED(member))
			member.remove_expedition_badge()
	GLOB.expedition_party.Cut()

	for(var/obj/structure/expedition_gate/departure/dep as anything in GLOB.expedition_departure_gates.Copy())
		if(!QDELETED(dep))
			qdel(dep)
	GLOB.expedition_departure_gates.Cut()

	GLOB.current_expedition_level_name = "Muster Grounds"
	QDEL_LIST(GLOB.current_expedition_objectives)
	GLOB.current_expedition_objectives = list()
