/// The map's share of the window, where the map ends and the chat begins
#define LAYOUT_MAP_DEFAULT 68
#define LAYOUT_MAP_MIN 25
#define LAYOUT_MAP_MAX 85
/// The stat panel's share of its column, where the stat panel ends and the chat begins
#define LAYOUT_STAT_DEFAULT 25
#define LAYOUT_STAT_MIN 20
#define LAYOUT_STAT_MAX 80

/// Applies the saved layout to the skin at login. Nothing is touched when nothing was ever saved
/client/proc/apply_layout()
	if(!prefs)
		return
	// Clamped on the way out as well as in, so a layout saved under wider bounds than today's still
	// leaves every pane usable
	if(!isnull(prefs.layout_map))
		winset(src, "split", "splitter=[clamp(prefs.layout_map, LAYOUT_MAP_MIN, LAYOUT_MAP_MAX)]")
	if(!isnull(prefs.layout_stat))
		winset(src, "info", "splitter=[clamp(prefs.layout_stat, LAYOUT_STAT_MIN, LAYOUT_STAT_MAX)]")

/client/verb/layout_menu()
	set category = "Options"
	set name = "Layout"
	if(!prefs)
		return
	if(!layout_menu)
		layout_menu = new(src)
	layout_menu.ui_interact(mob)

/**
 * The Layout window.
 *
 * Its sliders move the real panes from the client's own browser, so a drag costs the server
 * nothing. A release sends the value here to be kept in the preferences and applied again at the
 * next login. The bounds keep every pane usable: the skin has no minimum size of its own, and a
 * pane dragged to nothing takes the command bar with it.
 */
/datum/layout_menu
	var/client/owner
	/// A value changed since the preferences were last written, so closing the window saves them
	var/unsaved = FALSE

/datum/layout_menu/New(client/C)
	. = ..()
	owner = C

/datum/layout_menu/Destroy(force)
	if(owner?.layout_menu == src)
		owner.layout_menu = null
	owner = null
	return ..()

/datum/layout_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LayoutMenu", "Layout")
		ui.set_state(GLOB.always_state)
		ui.open()

/datum/layout_menu/ui_data(mob/user)
	var/list/data = list()
	if(!owner?.prefs)
		return data
	// Null means never saved, so the window reads the live position from the skin instead
	data["map"] = owner.prefs.layout_map
	data["stat"] = owner.prefs.layout_stat
	data["map_default"] = LAYOUT_MAP_DEFAULT
	data["map_min"] = LAYOUT_MAP_MIN
	data["map_max"] = LAYOUT_MAP_MAX
	data["stat_default"] = LAYOUT_STAT_DEFAULT
	data["stat_min"] = LAYOUT_STAT_MIN
	data["stat_max"] = LAYOUT_STAT_MAX
	return data

/datum/layout_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	if(!owner?.prefs)
		return FALSE
	switch(action)
		if("set")
			var/value = text2num(params["value"])
			if(isnull(value))
				return FALSE
			switch(params["id"])
				if("map")
					owner.prefs.layout_map = clamp(round(value), LAYOUT_MAP_MIN, LAYOUT_MAP_MAX)
				if("stat")
					owner.prefs.layout_stat = clamp(round(value), LAYOUT_STAT_MIN, LAYOUT_STAT_MAX)
				else
					return FALSE
		if("default")
			owner.prefs.layout_map = LAYOUT_MAP_DEFAULT
			owner.prefs.layout_stat = LAYOUT_STAT_DEFAULT
		else
			return FALSE
	// Applied from here too, so Default lands, but saved only when the window closes: a save is a
	// disk write, and a client looping this action would otherwise be looping one
	unsaved = TRUE
	owner.apply_layout()
	SStgui.update_uis(src)
	return TRUE

/datum/layout_menu/ui_close(mob/user)
	if(unsaved && owner?.prefs)
		owner.prefs.save_preferences()
		unsaved = FALSE
	return ..()

#undef LAYOUT_MAP_DEFAULT
#undef LAYOUT_MAP_MIN
#undef LAYOUT_MAP_MAX
#undef LAYOUT_STAT_DEFAULT
#undef LAYOUT_STAT_MIN
#undef LAYOUT_STAT_MAX
