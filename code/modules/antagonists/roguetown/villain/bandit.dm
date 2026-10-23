/datum/antagonist/bandit
	name = "Bandit"
	briefing_title = "The Freemen of Matthios"
	briefing_text = "Long ago, you committed a crime worthy of your bounty being hung on the wall outside of the local inn. You live now with fellow free men in reverence to MATTHIOS, whose idol grants us boons and wishes when fed the money, treasures, and metals of the civilized wretches that cast you out. As a member of the free men, you worship MATTHIOS first and foremost - Other Ascendants are not to be trusted. You are a Bandit, a free man who will not live under the walls of the city. Use your gifts wisely; your band must steal and pillage to sate your patron's hunger. The world is not kind to those who do not follow its rules."
	briefing_tips = list(
		"Show the wretched nobles their rightful place.",
		"Wealth belongs to those who can take it.",
		"Beware Guardsmen who will see you castificoed.",
		"Two bandits is better then one.",
		"Trust other Freemen of Matthios, but be wary of the other ascendants."
	)
	roundend_category = "bandits"
	antagpanel_category = "Bandit"
	job_rank = ROLE_BANDIT
	antag_hud_type = ANTAG_HUD_TRAITOR
	antag_hud_name = "bandit"
	confess_lines = list(
		"FREEDOM!!!",
		"I WILL NOT LIVE IN YOUR WALLS!",
		"I WILL NOT FOLLOW YOUR RULES!",
	)
	rogue_enabled = TRUE
	var/favor = 150
	var/totaldonated = 0

/datum/antagonist/bandit/examine_friendorfoe(datum/antagonist/examined_datum,mob/examiner,mob/examined)
	if(istype(examined_datum, /datum/antagonist/bandit))
		return span_boldnotice("Another free man. My ally.")

/datum/antagonist/bandit/on_gain()
	owner.special_role = "Bandit"
	//owner.assigned_role = "Bandit"
	forge_objectives()
	. = ..()
	equip_bandit()
	finalize_bandit()

/datum/antagonist/bandit/proc/finalize_bandit()
	owner.current.playsound_local(get_turf(owner.current), 'sound/music/traitor2.ogg', 60, FALSE, pressure_affected = FALSE)
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H.patron, /datum/patron/inhumen))
		H.set_patron(/datum/patron/inhumen/matthios)//If you're not of the Inhumen, we force you to worship Matthios.
	H.verbs |= /mob/proc/haltyell_exhausting
	ADD_TRAIT(H, TRAIT_BANDITCAMP, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SEEPRICES, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_COMMIE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_OUTLAW, TRAIT_GENERIC)
	to_chat(H, span_alertsyndie("I am a BANDIT!"))
/*
	to_chat(H, span_boldwarning("Long ago I did a crime worthy of my bounty being hung on the wall outside of the local inn. \
	I live now with fellow free men in reverence to MATTHIOS whose idol grants us boons and wishes when fed the money, treasures, and metals of the civilized wretches. \
	As a member of the free men, I worship MATTHIOS first and foremost, though I may have allegiance to other deities."))
*/

/datum/antagonist/bandit/proc/forge_objectives()
	if(!(locate(/datum/objective/bandit) in objectives))
		var/datum/objective/bandit/objective = new
		objective.owner = owner
		add_objective(objective)
		return

/datum/antagonist/bandit/proc/add_objective(datum/objective/O)
	objectives += O

/datum/antagonist/bandit/proc/remove_objective(datum/objective/O)
	objectives -= O

/datum/antagonist/bandit/proc/move_to_spawnpoint()
	owner.current.forceMove(pick(GLOB.bandit_starts))

/datum/antagonist/bandit/proc/equip_bandit()

	owner.unknow_all_people()
	for(var/datum/mind/MF in get_minds())
		owner.become_unknown_to(MF)
	for(var/datum/mind/MF in get_minds("Bandit"))
		owner.i_know_person(MF)
		owner.person_knows_me(MF)

	return TRUE

/datum/antagonist/bandit/roundend_report()
	if(owner?.current)
		var/the_name = owner.name
		if(ishuman(owner.current))
			var/mob/living/carbon/human/H = owner.current
			the_name = H.real_name
		if(!totaldonated)
			to_chat(world, "[the_name] was a bandit.")
		else
			to_chat(world, "[the_name] was a bandit. Their band stole [totaldonated] mammons worth of loot!")
