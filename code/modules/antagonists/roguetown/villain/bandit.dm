/datum/antagonist/bandit
	name = "Bandit"
	roundend_category = "bandits"
	antagpanel_category = "Bandit"
	job_rank = ROLE_BANDIT
	antag_hud_type = ANTAG_HUD_BANDIT
	antag_hud_name = "bandit_hud"
	confess_lines = list(
		"FREEDOM!!!",
		"I WILL NOT LIVE IN YOUR WALLS!",
		"I WILL NOT FOLLOW YOUR RULES!",
	)
	rogue_enabled = TRUE
	briefing_title = "You are a BANDIT"
	briefing_flavour = "At some point in your lyfe, you fell to the wrong side of the carriage. Whether by butchery or finesse, your face now hangs on the wall of the local inn, one of many told of in hushed tavern tales. You lyve among the Freefolk in a hidden camp, beyond the reach of the realm's laws, in reverence to MATTHIOS, the Transactor, who teaches that what the few hoard belongs to all."
	briefing_explanation = "The idol of Matthios in your camp hungers for the treasures of the civilized wretches: coin, gems, metals and finery. Every offering grants favour to the whole band, which the Hoardmaster trades for arms, armour and supplies. What the idol swallows counts toward the band's hoard, and spending favour never takes it away. Rob, ambush, extort and raid. Make the realm feel your presence."
	briefing_live_goals = TRUE
	/// Spendable at the Hoardmaster. Every offering by anyone credits every connected bandit.
	var/favor = 150
	/// Mammons' worth this bandit offered to the idol with their own hands
	var/personal_offered = 0

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
	add_antag_hud(antag_hud_type, antag_hud_name, owner.current)

/datum/antagonist/bandit/on_removal()
	remove_own_antag_hud()
	return ..()

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
	for(var/tier_path in list(/datum/objective/bandit_hoard/small, /datum/objective/bandit_hoard/decent, /datum/objective/bandit_hoard/massive))
		objectives += new tier_path(null, owner)

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
	award_hoard_triumphs()
	if(!owner?.current)
		return
	var/the_name = owner.name
	if(ishuman(owner.current))
		var/mob/living/carbon/human/H = owner.current
		the_name = H.real_name
	var/triumphs = bandit_hoard_triumphs(bandit_hoard_tier(SSmapping.retainer.bandit_contribute))
	if(triumphs)
		to_chat(world, "<b>[the_name]</b> was a bandit. They personally offered [personal_offered] mammons, and they have earned [triumphs] triumphs.")
	else
		to_chat(world, "<b>[the_name]</b> was a bandit. They personally offered [personal_offered] mammons.")

/// The band's shared result, printed once above the bandits
/datum/antagonist/bandit/roundend_report_header()
	to_chat(world, bandit_hoard_summary())
	to_chat(world, "<span class='header'>The [roundend_category] were:</span>")

/datum/antagonist/bandit/roundend_panel_header_extra()
	return bandit_hoard_summary()

/datum/antagonist/bandit/roundend_panel_extra()
	var/triumphs = bandit_hoard_triumphs(bandit_hoard_tier(SSmapping.retainer.bandit_contribute))
	. = "Personally offered [personal_offered] mammons"
	if(triumphs)
		. += ", earned [triumphs] triumphs"
	. += "."

/// One line with the band's highest tier and total, green if any tier was reached
/proc/bandit_hoard_summary()
	var/total = SSmapping.retainer.bandit_contribute
	var/tier = bandit_hoard_tier(total)
	if(tier)
		return "[span_greentext("The band amassed a [uppertext(bandit_hoard_tier_name(tier))]!")] ([total] mammons stolen)"
	return "[span_redtext("The band failed to amass a hoard.")] ([total] mammons stolen)"

/// Pays this bandit's ckey the triumphs for the band's highest tier, once per round
/datum/antagonist/bandit/proc/award_hoard_triumphs()
	var/triumphs = bandit_hoard_triumphs(bandit_hoard_tier(SSmapping.retainer.bandit_contribute))
	if(!triumphs || !owner?.key)
		return
	var/paid_key = ckey(owner.key)
	if(paid_key in SSmapping.retainer.bandit_hoard_paid_ckeys)
		return
	SSmapping.retainer.bandit_hoard_paid_ckeys += paid_key
	owner.adjust_triumphs(triumphs)

/datum/antagonist/bandit/get_briefing_progress(mob/user)
	var/list/marks = list()
	for(var/tier in 1 to 3)
		marks += list(list("at" = bandit_hoard_tier_amount(tier), "label" = bandit_hoard_tier_name(tier)))
	return list(
		"label" = "The band's hoard",
		"value" = SSmapping.retainer.bandit_contribute,
		"max" = BANDIT_HOARD_MASSIVE,
		"unit" = "mammons",
		"marks" = marks,
		"lines" = list("Your offerings: [personal_offered] mammons"),
	)

/// Highest hoard tier reached by a band total: 0 for none, 1 small, 2 decent, 3 massive
/proc/bandit_hoard_tier(total)
	if(total >= BANDIT_HOARD_MASSIVE)
		return 3
	if(total >= BANDIT_HOARD_DECENT)
		return 2
	if(total >= BANDIT_HOARD_SMALL)
		return 1
	return 0

/proc/bandit_hoard_tier_name(tier)
	switch(tier)
		if(1)
			return "Small Haul"
		if(2)
			return "Decent Stash"
		if(3)
			return "Massive Hoard"

/proc/bandit_hoard_tier_amount(tier)
	switch(tier)
		if(1)
			return BANDIT_HOARD_SMALL
		if(2)
			return BANDIT_HOARD_DECENT
		if(3)
			return BANDIT_HOARD_MASSIVE

/proc/bandit_hoard_triumphs(tier)
	switch(tier)
		if(1)
			return BANDIT_HOARD_TRIUMPHS_SMALL
		if(2)
			return BANDIT_HOARD_TRIUMPHS_DECENT
		if(3)
			return BANDIT_HOARD_TRIUMPHS_MASSIVE
	return 0

/// Adds an idol offering to the band's hoard and tells every bandit, announcing any tier newly reached
/proc/add_bandit_offering(mob/offerer, amount)
	var/datum/antagonist/bandit/offerer_datum = offerer.mind?.has_antag_datum(/datum/antagonist/bandit)
	if(offerer_datum)
		offerer_datum.personal_offered += amount
	var/old_tier = bandit_hoard_tier(SSmapping.retainer.bandit_contribute)
	SSmapping.retainer.bandit_contribute += amount
	var/total = SSmapping.retainer.bandit_contribute
	var/new_tier = bandit_hoard_tier(total)
	for(var/mob/player in GLOB.player_list)
		var/datum/antagonist/bandit/bandit_datum = player.mind?.has_antag_datum(/datum/antagonist/bandit)
		if(!bandit_datum)
			continue
		bandit_datum.favor += amount
		to_chat(player, "<font color='yellow'>[offerer.name] donates [amount] to the shrine! You now have [bandit_datum.favor] favor. The band's hoard stands at [total] mammons.</font>")
		if(new_tier > old_tier)
			to_chat(player, span_greentext("Matthios is pleased. The band has amassed a [bandit_hoard_tier_name(new_tier)]!"))
			player.playsound_local(get_turf(player), 'sound/misc/triumph.ogg', 60, FALSE, pressure_affected = FALSE)
