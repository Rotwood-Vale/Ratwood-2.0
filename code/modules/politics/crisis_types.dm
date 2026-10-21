// Realm crises beyond the Grenzelhoft debt: Otava, the Ferentian levy, Heartfelt blackmail.
//
// None of these floor taxes. The grievance is the obligation itself: the Lord has to act
// against the realm's own people (convert them, conscript them, strip their titles) to satisfy
// a foreign/higher power, and the rebels get to feed on that.
//

#define DECREE_CRISIS_OTAVA "crisis_otava"
#define DECREE_CRISIS_FERENTIAN "crisis_ferentian"
#define DECREE_CRISIS_HEARTFELT "crisis_heartfelt"
#define DECREE_CRISIS_FERENTIAN_SCUTAGE "crisis_ferentian_scutage"

#define TRAIT_LEVY_CONSCRIPT "levy_conscript" // note to selfAdd to global list later

#define PSYDON_PATRON_TYPE /datum/patron/old_god

// Placeholder defiance penalty for the Ferentian levy (fraction of the Crown's Purse). Tune or replace.
#define CRISIS_FERENTIAN_INDEMNITY 0.4

// A crisis is only offered when this many eligible players are online (Lord and rebels excluded).
#define CRISIS_OTAVA_MIN_FAITHLESS 4
#define CRISIS_FERENTIAN_MIN_LEVYABLE 12
#define CRISIS_HEARTFELT_MIN_NOBLES 5

// Scutage poll-tax floor (mammon/day); POLL_TAX_MAX_RATE is 40.
#define CRISIS_SCUTAGE_RATE_FLOOR 50

/// Extra slots opened per Inquisition job when the Otavan sanction fails.
#define CRISIS_INQUISITION_EXTRA_SLOTS 1

// ---------------------------------------------------------------------------------------------
// Shared helpers
// ---------------------------------------------------------------------------------------------

/proc/crisis_is_psydonite(mob/living/carbon/human/H)
	return istype(H?.patron, PSYDON_PATRON_TYPE)

/// Living, player-controlled humans who can be the target of a crisis: not the Lord, not rebels.
/proc/crisis_eligible_humans()
	var/list/out = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!H.client || !H.mind || H.stat == DEAD)
			continue
		if(H == SSticker.rulermob)
			continue
		if(H.mind.has_antag_datum(/datum/antagonist/prebel) || H.mind.has_antag_datum(/datum/antagonist/prebel/head))
			continue
		out += H
	return out

/// Jobs the Ferentian levy can draw on.
/proc/crisis_levy_jobs()
	return GLOB.peasant_positions + GLOB.yeoman_positions + GLOB.foreign_positions

/// Nobles the Heartfelt blackmailers can demand be stripped. Foreign nobility is not the Lord's to strip.
/proc/crisis_is_strippable_noble(mob/living/carbon/human/H)
	if(!HAS_TRAIT(H, TRAIT_NOBLE) || HAS_TRAIT(H, TRAIT_DEFILED_NOBLE))
		return FALSE
	return !(H.job in GLOB.foreign_positions)

// ---------------------------------------------------------------------------------------------
// Otava: convert x players to Psydon, and the Lord is forced Psydonite
// ---------------------------------------------------------------------------------------------

/datum/crisis_goal/convert_psydonites
	name = "Spread the Faith"
	var/target = 0
	/// ckeys of players who were not Psydonite when the sanction was imposed. Late joiners
	/// who arrive Psydonite don't count; only people converted away from where they started.
	var/list/baseline_ckeys = list()

/datum/crisis_goal/convert_psydonites/begin()
	for(var/mob/living/carbon/human/H in crisis_eligible_humans())
		if(!crisis_is_psydonite(H))
			baseline_ckeys += H.ckey
	target = CLAMP(round(length(baseline_ckeys) * 0.25), 2, 8)
	desc = "[target] of the realm's faithless must be brought to the worship of Psydon."
	. = ..()

/datum/crisis_goal/convert_psydonites/proc/count_converts()
	var/n = 0
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat == DEAD || !(H.ckey in baseline_ckeys) || !crisis_is_psydonite(H))
			continue
		n++
	return n

/datum/crisis_goal/convert_psydonites/check_completion()
	return count_converts() >= target

/datum/crisis_goal/convert_psydonites/get_progress_fraction()
	return target ? count_converts() / target : 1

/datum/crisis_goal/convert_psydonites/get_progress_text()
	return "[min(count_converts(), target)]/[target] converted"

/datum/decree/crisis/otava_sanction
	id = DECREE_CRISIS_OTAVA
	name = "The Otavan Sanction"
	crisis_title = "Sanctioned by Otava"
	duke_briefing = "The Principality has sanctioned the Crown. You are bound to Psydon, and the realm's faithless must be brought into the fold. Defy the sanction early, or let it lapse, and the Holy See will dispatch the Inquisition to the duchy."
	mechanical_text = "The Lord is bound to Psydon until enough of the realm's faithless have been converted. Defying the sanction early, or failing to make progress within the hour, brings the Inquisition to the duchy."
	flavor_text = "Let it be known that the Holy Principality of Otava has laid its sanction upon the Crown. The %RULER% is bound to the worship of Psydon, and shall bring the faithless of the Duchy into the fold, or answer for it dearly."
	imposed_text = "The Principality of Otava has laid a sanction upon the Crown. The Lord is bound to Psydon, and the faithless of the Duchy are to be brought into the fold."
	goal_complete_text = "The Principality of Otava is satisfied. The sanction upon the Crown may now be lifted."
	revoke_text = "The %RULER% has set aside the Otavan Sanction."
	defiance_warning = "If you defy the sanction before the faithless are converted, the Principality of Otava will not take this insult lightly and will dispatch another Inquisition expedition to the duchy."
	goal_type = /datum/crisis_goal/convert_psydonites

/datum/decree/crisis/otava_sanction/is_available()
	if(!istype(SSticker.rulermob, /mob/living/carbon/human))
		return FALSE
	var/faithless = 0
	for(var/mob/living/carbon/human/H in crisis_eligible_humans())
		if(!crisis_is_psydonite(H))
			faithless++
	return faithless >= CRISIS_OTAVA_MIN_FAITHLESS

/datum/decree/crisis/otava_sanction/on_imposed()
	var/mob/living/carbon/human/duke = SSticker.rulermob
	if(!istype(duke) || crisis_is_psydonite(duke))
		return
	duke.set_patron(PSYDON_PATRON_TYPE)
	to_chat(duke, span_boldwarning("The Otavan sanction binds me to Psydon. My faith has been solidified."))

/datum/decree/crisis/otava_sanction/apply_defiance_penalty()
	priority_announce("The Principality of Otava, finding the Crown's sanction unmet, has dispatched the Inquisition to the Duchy. Inquisitors are to root out the faithless, and the Crown's court shall answer their inquiry.", "BY THE HOLY SEE OF OTAVA", 'sound/misc/otavanlament.ogg', "Captain")
	// Open extra Inquisition slots so inquisitors can arrive.
	// total_positions/spawn_positions is how your Inquisition jobs gain slots mid-round.
	for(var/job_title in GLOB.inquisition_positions)
		var/datum/job/J = SSjob.GetJob(job_title)
		if(!J)
			continue
		J.total_positions += CRISIS_INQUISITION_EXTRA_SLOTS
		J.spawn_positions += CRISIS_INQUISITION_EXTRA_SLOTS

// ---------------------------------------------------------------------------------------------
// Ferentian levy (the Queen of Ferentia, the duke's overlord): conscript x towners/foreigners,
// trained to apprentice in a combat skill
// ---------------------------------------------------------------------------------------------

/obj/effect/proc_holder/spell/self/levy_conscript
	name = "Conscript"
	desc = "Conscript a townsperson or foreigner into the Queen of Ferentia's levy."
	overlay_state = "recruit_titlegrant"
	antimagic_allowed = TRUE
	recharge_time = 100
	var/conscript_range = 3

/obj/effect/proc_holder/spell/self/levy_conscript/cast(list/targets, mob/user = usr)
	. = ..()
	var/list/candidates = list()
	for(var/mob/living/carbon/human/H in (get_hearers_in_view(conscript_range, user) - user))
		if(!can_conscript(H))
			continue
		candidates[H.name] = H
	if(!length(candidates))
		to_chat(user, span_warning("There is no one in range who can be conscripted."))
		return
	var/choice = input(user, "Whom do you conscript?", name) as null|anything in candidates
	if(!choice)
		return
	var/mob/living/carbon/human/target = candidates[choice]
	if(QDELETED(target) || !(target in get_hearers_in_view(conscript_range, user)))
		to_chat(user, span_warning("The conscription failed."))
		return
	INVOKE_ASYNC(src, PROC_REF(conscript), target, user)

/obj/effect/proc_holder/spell/self/levy_conscript/proc/can_conscript(mob/living/carbon/human/H)
	if(QDELETED(H) || !H.mind || !H.client || H.stat == DEAD)
		return FALSE
	if(HAS_TRAIT(H, TRAIT_LEVY_CONSCRIPT))
		return FALSE
	return (H.job in crisis_levy_jobs())

/obj/effect/proc_holder/spell/self/levy_conscript/proc/conscript(mob/living/carbon/human/target, mob/living/carbon/human/user)
	if(QDELETED(target) || QDELETED(user))
		return FALSE
	user.say("BY THE LEVY OF THE QUEEN OF FERENTIA, I CONSCRIPT YOU, [uppertext(target.name)]!")
	var/choice = alert(target, "[user.real_name] conscripts you into the Queen of Ferentia's levy. You will be expected to train for war and serve the Crown.", "Conscription", "Serve", "Refuse")
	if(QDELETED(target))
		return FALSE
	if(choice != "Serve")
		to_chat(user, span_warning("[target.name] refuses the levy."))
		return FALSE
	ADD_TRAIT(target, TRAIT_LEVY_CONSCRIPT, TRAIT_GENERIC)
	to_chat(target, span_boldnotice("I have been conscripted into the levy. I must train to bear arms."))
	to_chat(user, span_notice("[target.name] has been conscripted."))
	return TRUE

/datum/crisis_goal/levy
	name = "Raise the Levy"
	var/target = 0

/datum/crisis_goal/levy/begin()
	var/eligible = 0
	var/list/jobs = crisis_levy_jobs()
	for(var/mob/living/carbon/human/H in crisis_eligible_humans())
		if(H.job in jobs)
			eligible++
	target = CLAMP(round(eligible * 0.2), 8, 15)
	desc = "[target] townsfolk or foreigners must be conscripted into the levy and trained to at least expert skill with a weapon."
	. = ..()

/// The second chance after a failed levy: same task, but no deadline (it must not fail twice).
/datum/crisis_goal/levy/late
	name = "Raise the Levy Late"
	use_deadline = FALSE

/datum/crisis_goal/levy/proc/is_trained(mob/living/carbon/human/H)
	for(var/skill_path in subtypesof(/datum/skill/combat))
		if(skill_path == /datum/skill/combat/wrestling || skill_path == /datum/skill/combat/unarmed)
			continue
		if(H.get_skill_level(skill_path) >= SKILL_LEVEL_EXPERT)
			return TRUE
	return FALSE

/datum/crisis_goal/levy/proc/count_conscripts(trained_only = FALSE)
	var/n = 0
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.stat == DEAD || !H.mind || !HAS_TRAIT(H, TRAIT_LEVY_CONSCRIPT))
			continue
		if(trained_only && !is_trained(H))
			continue
		n++
	return n

/datum/crisis_goal/levy/check_completion()
	return count_conscripts(TRUE) >= target

/// Any conscription counts as progress toward the deadline; completion needs them trained.
/datum/crisis_goal/levy/get_progress_fraction()
	return target ? count_conscripts() / target : 1

/datum/crisis_goal/levy/get_progress_text()
	return "[min(count_conscripts(TRUE), target)]/[target] trained, [count_conscripts()] conscripted"

/datum/decree/crisis/ferentian_levy
	id = DECREE_CRISIS_FERENTIAN
	name = "The Queen's Levy"
	crisis_title = "Ferentian Levy"
	duke_briefing = "The Queen of Ferentia, your overlord, has called a levy upon the Vale. You are given the Conscript spell: conscripted townsfolk and foreigners must be trained to at least apprentice skill with a weapon. Defy your Queen early, or let the levy go unraised, and she will impose scutage on your peasants and yeomen."
	mechanical_text = "The Lord must conscript townsfolk and foreigners into the Queen of Ferentia's levy with the Conscript spell and see them trained to apprentice skill with a weapon. Defying the Queen early, or making no progress within the hour, brings scutage: a punishing poll tax on peasants and yeomen until the levy is raised."
	flavor_text = "Let it be known that Her Majesty the Queen of Ferentia, overlord of the Vale, has called a levy upon her duchy. The %RULER% shall conscript townsfolk and foreigners into the service of the Queen, and see them trained to arms, or answer to Ferentia for the shortfall."
	imposed_text = "The Queen of Ferentia, overlord of the Vale, has called a levy upon the duchy. The Lord is to conscript townsfolk and foreigners and see them trained to arms."
	goal_complete_text = "The Queen of Ferentia is satisfied with the duchy's levy. Her writ may now be lifted."
	revoke_text = "The %RULER% has set aside the Queen's Levy."
	defiance_warning = "If you defy the Queen's levy before it is raised and trained, she will impose scutage: a punishing poll tax on your peasants and yeomen."
	goal_type = /datum/crisis_goal/levy
	/// Holds the Lord who received the Conscript spell, so it can be taken back later.
	var/datum/weakref/levy_holder

/datum/decree/crisis/ferentian_levy/is_available()
	if(!istype(SSticker.rulermob, /mob/living/carbon/human))
		return FALSE
	var/eligible = 0
	var/list/jobs = crisis_levy_jobs()
	for(var/mob/living/carbon/human/H in crisis_eligible_humans())
		if(H.job in jobs)
			eligible++
	return eligible >= CRISIS_FERENTIAN_MIN_LEVYABLE

/datum/decree/crisis/ferentian_levy/on_imposed()
	var/mob/living/carbon/human/duke = SSticker.rulermob
	if(!istype(duke) || !duke.mind)
		return
	duke.mind.AddSpell(new /obj/effect/proc_holder/spell/self/levy_conscript)
	levy_holder = WEAKREF(duke)
	to_chat(duke, span_boldnotice("I have been given the power to conscript townsfolk and foreigners into the levy."))

/datum/decree/crisis/ferentian_levy/on_obligation_ended()
	var/mob/living/duke = levy_holder?.resolve()
	levy_holder = null
	duke?.mind?.RemoveSpell(/obj/effect/proc_holder/spell/self/levy_conscript)

/datum/decree/crisis/ferentian_levy/apply_defiance_penalty()
	var/datum/decree/crisis/scutage = SStreasury.get_decree(DECREE_CRISIS_FERENTIAN_SCUTAGE)
	if(!scutage)
		return
	// Take the Conscript spell back first: the scutage charter grants a fresh one to the Lord.
	var/mob/living/duke = levy_holder?.resolve()
	levy_holder = null
	duke?.mind?.RemoveSpell(/obj/effect/proc_holder/spell/self/levy_conscript)
	scutage.impose()

/// The Queen's scutage: imposed when the levy fails. Peasants and yeomen pay a punishing poll
/// tax until the levy is raised late, a rebel ruler repeals it, or the Lord pays the indemnity
/// to defy it. Never offered in the round-start choice.
/datum/decree/crisis/ferentian_levy/scutage
	id = DECREE_CRISIS_FERENTIAN_SCUTAGE
	name = "The Queen's Scutage"
	offerable = FALSE
	mechanical_text = "Peasant and yeoman poll taxes cannot fall below the scutage rate until the Queen's levy is raised and trained. Defying the Queen forfeits a share of the treasury."
	flavor_text = "Let it be known that the Queen of Ferentia, finding her levy unraised, has laid scutage upon the duchy. The common folk of the Vale shall pay shield-money in place of the men they did not send, until the %RULER% raises the levy at last."
	imposed_text = "The Queen of Ferentia, finding her levy unraised, has laid scutage upon the duchy. Peasants and yeomen shall pay shield-money until the levy is raised."
	goal_complete_text = null // auto-release broadcasts the revoke text instead
	revoke_text = "The Queen of Ferentia's scutage upon the duchy has been lifted."
	defiance_warning = "If you defy the Queen's scutage before the levy is raised, her tax collectors will claim an indemnity from the Crown's treasury."
	goal_type = /datum/crisis_goal/levy/late
	auto_release = TRUE
	rate_floor = CRISIS_SCUTAGE_RATE_FLOOR
	floor_categories = list(POLL_TAX_CAT_PEASANT, POLL_TAX_CAT_BURGHER)
	ui_floor_categories = list(POLL_TAX_CAT_PEASANT)

/datum/decree/crisis/ferentian_levy/scutage/get_floored_jobs()
	return GLOB.peasant_positions + GLOB.yeoman_positions

/datum/decree/crisis/ferentian_levy/scutage/apply_defiance_penalty()
	var/indemnity = round(SStreasury.discretionary_fund.balance * CRISIS_FERENTIAN_INDEMNITY)
	if(indemnity <= 0)
		return
	if(!SStreasury.burn(SStreasury.discretionary_fund, indemnity, "Queen of Ferentia's indemnity - breach of levy"))
		return
	priority_announce("The Queen of Ferentia's tax collectors have claimed an indemnity of [indemnity] mammon from the duchy for failing to raise her levy.", "BY FOREIGN DECREE", pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), "Captain")

// ---------------------------------------------------------------------------------------------
// Heartfelt blackmail: revoke the nobility of x nobles
// ---------------------------------------------------------------------------------------------

/datum/crisis_goal/strip_nobility
	name = "Silence the Letters"
	var/target = 0
	/// ckeys of the nobles who held a title when the demand was made.
	var/list/baseline_ckeys = list()

/datum/crisis_goal/strip_nobility/begin()
	for(var/mob/living/carbon/human/H in crisis_eligible_humans())
		if(crisis_is_strippable_noble(H))
			baseline_ckeys += H.ckey
	var/nobles = length(baseline_ckeys)
	target = CLAMP(round(nobles * 0.5), 2, 4)
	target = max(1, min(target, nobles))
	desc = "The nobility of [target] nobles must be revoked to buy the blackmailers' silence."
	. = ..()

/datum/crisis_goal/strip_nobility/proc/count_stripped()
	var/n = 0
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat == DEAD || !(H.ckey in baseline_ckeys) || HAS_TRAIT(H, TRAIT_NOBLE))
			continue
		n++
	return n

/datum/crisis_goal/strip_nobility/check_completion()
	return count_stripped() >= target

/datum/crisis_goal/strip_nobility/get_progress_fraction()
	return target ? count_stripped() / target : 1

/datum/crisis_goal/strip_nobility/get_progress_text()
	return "[min(count_stripped(), target)]/[target] stripped"

/datum/decree/crisis/heartfelt_blackmail
	id = DECREE_CRISIS_HEARTFELT
	name = "The Heartfelt Letters"
	crisis_title = "Heartfelt Blackmail"
	duke_briefing = "Heartfelt holds letters that would ruin the Crown. Their silence has a price: the nobility of several of your nobles must be revoked with the Grant Nobility spell, and the Great Writ of Ferentia, the nobility's charter, is suspended until it is paid. Defy them early and the Holy See of Grenzelhoft will brand you a heretic."
	mechanical_text = "The Lord must revoke the nobility of several nobles to buy the silence of Heartfelt's blackmailers. The Great Writ of Ferentia is suspended until the demands are met. Defying them early has the Holy See of Grenzelhoft brand the Lord a heretic."
	flavor_text = "Let it be known that letters bearing the seal of Heartfelt have reached the Crown. The %RULER% shall strip titles from the nobles named therein, or see the contents made known to all the Vale."
	imposed_text = "Letters bearing the seal of Heartfelt have reached the Crown. Demands have been made concerning the realm's nobility, and the Great Writ of Ferentia is suspended until they are met."
	goal_complete_text = "The letters of Heartfelt have been withdrawn. The blackmailers' demands are met."
	revoke_text = "The %RULER% has defied the demands of Heartfelt."
	defiance_warning = "If you defy Heartfelt before the nobles are stripped, the letters will be published and the Holy See of Grenzelhoft will brand you a heretic."
	goal_type = /datum/crisis_goal/strip_nobility
	// Suspends the Great Writ until the demands are met or the charter lifts. Delete this line
	// (and the "Great Writ" sentences in the texts above) to leave the Writ alone.
	held_decree_id = DECREE_GREAT_WRIT

/datum/decree/crisis/heartfelt_blackmail/is_available()
	if(!istype(SSticker.rulermob, /mob/living/carbon/human))
		return FALSE
	var/nobles = 0
	for(var/mob/living/carbon/human/H in crisis_eligible_humans())
		if(crisis_is_strippable_noble(H))
			nobles++
	return nobles >= CRISIS_HEARTFELT_MIN_NOBLES

/datum/decree/crisis/heartfelt_blackmail/apply_defiance_penalty()
	var/mob/living/carbon/human/duke = SSticker.rulermob
	if(!istype(duke))
		return
	priority_announce("The letters of Heartfelt have been laid before the Holy See of Grenzelhoft. Having examined them, the Holy See finds [duke.real_name], [SSticker.rulertype] of [SSmapping.map_adjustment.realm_name], GUILTY of heretical actions, and brands them a HERETIC before the ten and all the faithful. The Holy See Demands the [SSticker.rulertype] abdicate.", "BY THE HOLY SEE OF GRENZELHOFT", 'sound/misc/excomm.ogg', "Captain")
	brand_heretic(duke)

/// Brands someone a heretic by excommunicating them, exactly as the Priest's Excommunicate
/// verb does (name on GLOB.excommunicated_players, TRAIT_EXCOMMUNICATED, and the stress and
/// debuff for those of the Ten). The Church can still reconcile them the usual way, and the
/// Inquisition's accusation check already counts an excommunicated subject as correct.
/proc/brand_heretic(mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(!(H.real_name in GLOB.excommunicated_players))
		GLOB.excommunicated_players += H.real_name
	ADD_TRAIT(H, TRAIT_EXCOMMUNICATED, TRAIT_GENERIC)
	if(istype(H.patron, /datum/patron/divine))
		H.add_stress(/datum/stressevent/excommunicated)
		H.apply_status_effect(/datum/status_effect/debuff/excomm)
		to_chat(H, span_userdanger("The Holy See has branded me a heretic. My divine light has been severed. The Gods turn their backs to me."))
	else
		to_chat(H, span_userdanger("The Holy See has branded me a heretic."))
	message_admins("EXCOMMUNICATION: the Holy See of Grenzelhoft has branded [H.real_name] ([H.ckey]) a heretic (Heartfelt crisis)")
	log_game("EXCOMMUNICATION: the Holy See of Grenzelhoft has branded [H.real_name] ([H.ckey]) a heretic (Heartfelt crisis)")
