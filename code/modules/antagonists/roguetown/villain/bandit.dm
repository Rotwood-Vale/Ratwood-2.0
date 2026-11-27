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
	briefing_explanation = "The idol of Matthios in your camp hungers for the treasures of the civilized wretches: coin, gems, metals and finery. Every offering grants favour to the whole band, which the Hoardmaster trades for arms, armour and supplies. What the idol swallows counts toward the brigand gang's hoard, and spending favour never takes it away. Rob, ambush, extort and raid. Make the realm feel your presence."
	briefing_live_goals = TRUE
	/// Spendable at the Hoardmaster. Every offering by any bandit credits every connected bandit.
	var/favor = 150
	/// Mammons' worth this bandit offered to the idol with their own hands
	var/personal_offered = 0
	/// Triumphs this bandit's player was paid for the hoard at round end. 0 on the lesser datum of a player who respawned as a new bandit.
	var/hoard_triumphs_awarded = 0

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
	for(var/tier in GLOB.bandit_hoard_tiers)
		// Owner is set after creation: passing it to New() would list every bandit among the Gods' Champions
		var/datum/objective/bandit_hoard/objective = new tier
		objective.owner = owner
		objectives += objective

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
	if(!owner)
		return
	var/the_name = owner.name
	if(ishuman(owner.current))
		var/mob/living/carbon/human/H = owner.current
		the_name = H.real_name
	to_chat(world, gold_if_top_offerer("<b>[the_name]</b> was a bandit. They [offering_result_text()]"))

/// The gang's shared result, printed once above the bandits
/datum/antagonist/bandit/roundend_report_header()
	to_chat(world, "<span class='reallybig'><b>BANDITS</b></span>")
	to_chat(world, SSmapping.retainer.bandit_hoard_summary())

/// The top offerer is listed last
/datum/antagonist/bandit/roundend_sort_order()
	return paid_as_top_offerer() ? 1 : 0

/datum/antagonist/bandit/roundend_panel_category_line()
	return SSmapping.retainer.bandit_hoard_summary()

/datum/antagonist/bandit/roundend_panel_result_line()
	return gold_if_top_offerer(capitalize(offering_result_text()))

/// "personally offered N mammons", then the triumphs this bandit was paid at round end
/datum/antagonist/bandit/proc/offering_result_text()
	. = "personally offered [personal_offered] mammons"
	if(!hoard_triumphs_awarded)
		return "[.]."
	var/tier_triumphs = SSmapping.retainer.bandit_hoard_tier_triumphs()
	if(paid_as_top_offerer())
		return "[.], earned [tier_triumphs] triumphs, and earned the favour of Matthios! (+[BANDIT_TOP_OFFERER_TRIUMPHS] triumphs)"
	return "[.], and they have earned [tier_triumphs] triumphs."

/datum/antagonist/bandit/proc/gold_if_top_offerer(text)
	return paid_as_top_offerer() ? "<font color='#e6b422'>[text]</font>" : text

/// Top offerer and actually paid for it: FALSE on the lesser datum of a player who respawned as a new bandit
/datum/antagonist/bandit/proc/paid_as_top_offerer()
	return hoard_triumphs_awarded && is_top_offerer()

/// TRUE if the gang reached a tier, this bandit offered something, and no bandit offered more. Ties all count.
/datum/antagonist/bandit/proc/is_top_offerer()
	if(personal_offered <= 0 || !SSmapping.retainer.bandit_hoard_tier())
		return FALSE
	for(var/datum/antagonist/bandit/other in GLOB.antagonists)
		if(other.owner && other.personal_offered > personal_offered)
			return FALSE
	return TRUE

/// Triumphs this bandit earned from the hoard: the tier's, plus the top offerer's bonus
/datum/antagonist/bandit/proc/hoard_triumphs_owed()
	. = SSmapping.retainer.bandit_hoard_tier_triumphs()
	if(is_top_offerer())
		. += BANDIT_TOP_OFFERER_TRIUMPHS

/datum/antagonist/bandit/get_briefing_progress()
	return SSmapping.retainer.bandit_hoard_progress(list("Your offerings: [personal_offered] mammons"))

//THE HOARD: one band-wide total, kept on the antag retainer

/// The hoard's progress bar for the briefing window (shape in /datum/antagonist/proc/get_briefing_progress), with lines under it
/datum/antag_retainer/proc/bandit_hoard_progress(list/lines)
	var/list/marks = list()
	for(var/datum/objective/bandit_hoard/tier as anything in GLOB.bandit_hoard_tiers)
		marks += list(list("at" = initial(tier.target_amount), "label" = initial(tier.tier_name)))
	var/datum/objective/bandit_hoard/top_tier = GLOB.bandit_hoard_tiers[length(GLOB.bandit_hoard_tiers)]
	return list(
		"label" = "The brigand gang's hoard",
		"value" = bandit_contribute,
		"max" = initial(top_tier.target_amount),
		"unit" = "mammons",
		"marks" = marks,
		"lines" = lines,
	)

/// The highest hoard tier the band has reached, as its objective type, or null for none
/datum/antag_retainer/proc/bandit_hoard_tier()
	for(var/datum/objective/bandit_hoard/tier as anything in GLOB.bandit_hoard_tiers)
		if(bandit_contribute >= initial(tier.target_amount))
			. = tier

/// Triumphs for the highest tier reached (tiers are not additive), or 0
/datum/antag_retainer/proc/bandit_hoard_tier_triumphs()
	var/datum/objective/bandit_hoard/tier = bandit_hoard_tier()
	return tier ? initial(tier.triumph_count) : 0

/// One line with the gang's highest tier and total, green if any tier was reached
/datum/antag_retainer/proc/bandit_hoard_summary()
	var/datum/objective/bandit_hoard/tier = bandit_hoard_tier()
	if(tier)
		return "[span_greentext("The brigand gang amassed a [uppertext(initial(tier.tier_name))]!")] ([bandit_contribute] mammons stolen)"
	return "[span_redtext("The brigand gang failed to amass a hoard.")] ([bandit_contribute] mammons stolen)"

/// Adds an idol offering to the band's hoard and tells every bandit, announcing any tier newly reached
/datum/antag_retainer/proc/add_bandit_offering(mob/offerer, amount)
	var/datum/antagonist/bandit/offerer_datum = offerer.mind?.has_antag_datum(/datum/antagonist/bandit)
	if(offerer_datum)
		offerer_datum.personal_offered += amount
	if(!bandit_hoard_payout_queued)
		bandit_hoard_payout_queued = TRUE
		SSticker.OnRoundend(CALLBACK(src, PROC_REF(pay_bandit_hoard_triumphs)))
	var/old_tier = bandit_hoard_tier()
	bandit_contribute += amount
	var/datum/objective/bandit_hoard/new_tier = bandit_hoard_tier()
	for(var/mob/player in GLOB.player_list)
		var/datum/antagonist/bandit/bandit_datum = player.mind?.has_antag_datum(/datum/antagonist/bandit)
		if(!bandit_datum)
			continue
		bandit_datum.favor += amount
		to_chat(player, "<font color='yellow'>[offerer.name] donates [amount] to the shrine! You now have [bandit_datum.favor] favor. The brigand gang's hoard stands at [bandit_contribute] mammons.</font>")
		if(new_tier != old_tier)
			to_chat(player, span_greentext("Matthios is pleased. The brigand gang has amassed a [initial(new_tier.tier_name)]!"))
			player.playsound_local(get_turf(player), 'sound/misc/triumph.ogg', 60, FALSE, pressure_affected = FALSE)

/**
 * Pays each bandit's player for the hoard, once, before the round-end report.
 * A player who respawned as a new bandit holds several datums: only their best one is paid, and only it says so at round end.
 */
/datum/antag_retainer/proc/pay_bandit_hoard_triumphs()
	var/list/best_by_ckey = list()
	for(var/datum/antagonist/bandit/bandit in GLOB.antagonists)
		if(!bandit.owner?.key)
			continue
		var/player_ckey = ckey(bandit.owner.key)
		var/datum/antagonist/bandit/best = best_by_ckey[player_ckey]
		// >= so a tie goes to the later datum (GLOB.antagonists is in creation order): the character they ended the round as
		if(!best || bandit.hoard_triumphs_owed() >= best.hoard_triumphs_owed())
			best_by_ckey[player_ckey] = bandit
	for(var/player_ckey in best_by_ckey)
		var/datum/antagonist/bandit/best = best_by_ckey[player_ckey]
		best.hoard_triumphs_awarded = best.hoard_triumphs_owed()
		if(best.hoard_triumphs_awarded)
			best.owner.adjust_triumphs(best.hoard_triumphs_awarded)

//ADMIN VIEW: the brigand goal, opened from the F6 antagonist panel

GLOBAL_DATUM_INIT(bandit_goal_view, /datum/bandit_goal_view, new)

/// Read-only briefing window for admins: the band's hoard, each tier, and every bandit's offerings and favor
/datum/bandit_goal_view

/datum/bandit_goal_view/ui_state(mob/user)
	return ADMIN_STATE(R_ADMIN)

/datum/bandit_goal_view/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AntagBriefing", "Brigand Goal")
		ui.open()

/datum/bandit_goal_view/ui_static_data(mob/user)
	return list(
		"title" = "Brigand Goal",
		"flavour" = null,
		"explanation" = null, // the window heads this "Your Purpose", which reads wrongly for an admin
	)

/datum/bandit_goal_view/ui_data(mob/user)
	var/list/goals = list()
	for(var/datum/objective/bandit_hoard/tier as anything in GLOB.bandit_hoard_tiers)
		goals += list(list(
			"text" = "[initial(tier.tier_name)]: [initial(tier.target_amount)] mammons ([initial(tier.triumph_count)] triumphs each)",
			"completed" = SSmapping.retainer.bandit_contribute >= initial(tier.target_amount),
		))
	var/list/bandits = list()
	for(var/datum/antagonist/bandit/bandit in GLOB.antagonists)
		if(bandit.owner)
			bandits += bandit
	sortTim(bandits, GLOBAL_PROC_REF(cmp_bandit_offered_dsc))
	var/list/lines = list()
	for(var/datum/antagonist/bandit/bandit as anything in bandits)
		var/name = bandit.owner.current?.real_name || bandit.owner.name
		lines += "[name] ([bandit.owner.key || "no key"]): offered [bandit.personal_offered], favor [bandit.favor]"
	if(!length(lines))
		lines += "No bandits this round."
	return list(
		"goals" = goals,
		"progress" = SSmapping.retainer.bandit_hoard_progress(lines),
	)

/datum/bandit_goal_view/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(action == "close")
		ui.close()
		return TRUE

/proc/cmp_bandit_offered_dsc(datum/antagonist/bandit/A, datum/antagonist/bandit/B)
	return B.personal_offered - A.personal_offered
