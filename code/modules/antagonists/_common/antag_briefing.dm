/// TGUI window explaining an antagonist role: banner, lore, how to play and goals. Content comes from the antag datum.
/datum/antag_briefing
	var/datum/antagonist/antag

/datum/antag_briefing/New(datum/antagonist/antag)
	src.antag = antag

/datum/antag_briefing/Destroy()
	SStgui.close_uis(src)
	antag = null
	return ..()

/datum/antag_briefing/ui_state(mob/user)
	return GLOB.always_state

/datum/antag_briefing/ui_status(mob/user, datum/ui_state/state)
	if(!antag?.owner || user.mind != antag.owner)
		return UI_CLOSE
	return ..()

/datum/antag_briefing/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AntagBriefing", antag.briefing_title)
		ui.open()

/datum/antag_briefing/ui_static_data(mob/user)
	return list(
		"title" = antag.briefing_title,
		"flavour" = antag.briefing_flavour,
		"explanation" = antag.briefing_explanation,
	)

/datum/antag_briefing/ui_data(mob/user)
	return list(
		"goals" = antag.get_briefing_goals(),
		"progress" = antag.get_briefing_progress(user),
	)

/datum/antag_briefing/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(action == "close")
		ui.close()
		return TRUE

//Antag datum side: what a briefing shows, and the verb that reopens it

/datum/antagonist/proc/has_briefing()
	return !!briefing_title

/// Opens the briefing window for user (defaults to the owner's current mob)
/datum/antagonist/proc/show_briefing(mob/user)
	if(!has_briefing())
		return
	if(!user)
		user = owner?.current
	if(!user?.client)
		return
	if(!briefing)
		briefing = new(src)
	briefing.ui_interact(user)

/// Goal rows for the briefing window: list of list("text", "completed"). completed is null when not tracked live.
/datum/antagonist/proc/get_briefing_goals()
	var/list/goals = list()
	for(var/datum/objective/objective as anything in objectives)
		goals += list(list(
			"text" = objective.explanation_text,
			"completed" = briefing_live_goals ? !!objective.check_completion() : null,
		))
	return goals

/**
 * Optional progress bar for the briefing window, or null for none.
 * Shape: list("label", "value", "max", "unit", "marks" = list(list("at", "label")), "lines" = list(text))
 */
/datum/antagonist/proc/get_briefing_progress(mob/user)
	return

/// Gives or takes the briefing verb on M, depending on whether its mind still holds any antag with a briefing
/datum/antagonist/proc/update_briefing_verb(mob/M)
	if(!M)
		return
	for(var/datum/antagonist/antag as anything in M.mind?.antag_datums)
		if(antag.has_briefing())
			M.verbs |= /mob/proc/antagonist_briefing
			return
	M.verbs -= /mob/proc/antagonist_briefing

/mob/proc/antagonist_briefing()
	set name = "Antagonist Briefing"
	set category = "IC"

	var/list/options = list()
	for(var/datum/antagonist/antag as anything in mind?.antag_datums)
		if(antag.has_briefing())
			options[antag.name] = antag
	if(!length(options))
		to_chat(src, span_warning("I have no briefing to read."))
		return
	var/datum/antagonist/chosen
	if(length(options) == 1)
		chosen = options[options[1]]
	else
		var/choice = tgui_input_list(src, "Which briefing?", "Antagonist Briefing", options)
		if(!choice)
			return
		chosen = options[choice]
	chosen.show_briefing(src)
