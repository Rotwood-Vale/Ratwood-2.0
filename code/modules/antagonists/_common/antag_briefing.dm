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
