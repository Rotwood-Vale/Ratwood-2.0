/**
 * ### tgui_input_checkbox
 * Opens a window with a list of checkboxes and returns a list of selected choices.
 *
 * user - The mob to display the window to
 * message - The message inside the window
 * title - The title of the window
 * list/items - The list of items to display
 * min_checked - The minimum number of checkboxes that must be checked (defaults to 1)
 * max_checked - The maximum number of checkboxes that can be checked (optional)
 * timeout - The timeout for the input (optional)
 * default_checked - A list of items to start as checked (optional)
 * descriptions - Assoc list of item = description, shown under the item (optional)
 * strict_modern - Skips the legacy input fallback, for callers that can't work with a single choice
 * window_width / window_height - Size of the window (optional)
 */
/proc/tgui_input_checkboxes(mob/user, message, title = "Select", list/items, min_checked = 1, max_checked = 50, timeout = 0, ui_state = GLOB.tgui_always_state, list/default_checked = null, list/descriptions = null, strict_modern = FALSE, window_width = 425, window_height = 300)
	if (!user)
		user = usr
	if(!length(items))
		return null
	if (!istype(user))
		if (istype(user, /client))
			var/client/client = user
			user = client.mob
		else
			return null

	if(isnull(user.client))
		return null

	if(!user.client.prefs.tgui_pref && !strict_modern)
		var/our_input = input(user, message, title) as null|anything in items
		return our_input ? list(our_input) : null
	var/datum/tgui_checkbox_input/input = new(user, message, title, items, min_checked, max_checked, timeout, ui_state, default_checked, descriptions, window_width, window_height)
	input.ui_interact(user)
	input.wait()
	if (input)
		. = input.choices
		qdel(input)

/// Window for tgui_input_checkboxes
/datum/tgui_checkbox_input
	/// Title of the window
	var/title
	/// Message to display
	var/message
	/// List of items to display
	var/list/items
	/// List of selected items
	var/list/choices
	/// Time when the input was created
	var/start_time
	/// Timeout for the input
	var/timeout
	/// Whether the input was closed
	var/closed
	/// Minimum number of checkboxes that must be checked
	var/min_checked
	/// Maximum number of checkboxes that can be checked
	var/max_checked
	/// Default selected items shown as checked when the UI opens
	var/list/default_checked
	/// Assoc list of item = description, displayed under the item
	var/list/descriptions
	/// Size of the window
	var/window_width
	var/window_height
	/// The TGUI UI state that will be returned in ui_state(). Default: always_state
	var/datum/ui_state/state

/datum/tgui_checkbox_input/New(mob/user, message, title, list/items, min_checked, max_checked, timeout, ui_state, list/default_checked, list/descriptions, window_width, window_height)
	src.title = title
	src.message = message
	src.items = items.Copy()
	src.min_checked = min_checked
	src.max_checked = max_checked
	src.state = ui_state
	src.descriptions = descriptions?.Copy()
	src.window_width = window_width
	src.window_height = window_height
	src.default_checked = list()
	if(length(default_checked))
		for(var/item in default_checked)
			if(item in src.items)
				src.default_checked += item

	if (timeout)
		src.timeout = timeout
		start_time = world.time
		QDEL_IN(src, timeout)

/datum/tgui_checkbox_input/Destroy(force)
	SStgui.close_uis(src)
	state = null
	items?.Cut()
	default_checked?.Cut()
	descriptions?.Cut()

	return ..()

/datum/tgui_checkbox_input/proc/wait()
	while (!closed && !QDELETED(src))
		stoplag(1)

/datum/tgui_checkbox_input/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CheckboxInput")
		ui.open()

/datum/tgui_checkbox_input/ui_close(mob/user)
	. = ..()
	closed = TRUE

/datum/tgui_checkbox_input/ui_state(mob/user)
	return state

/datum/tgui_checkbox_input/ui_data(mob/user)
	var/list/data = list()

	if(timeout)
		data["timeout"] = CLAMP01((timeout - (world.time - start_time) - 1 SECONDS) / (timeout - 1 SECONDS))

	return data

/datum/tgui_checkbox_input/ui_static_data(mob/user)
	var/list/data = list()

	data["items"] = items
	data["descriptions"] = descriptions
	data["min_checked"] = min_checked
	data["max_checked"] = max_checked
	data["default_checked"] = default_checked
	data["window_width"] = window_width
	data["window_height"] = window_height
	data["large_buttons"] = FALSE // user.read_preference(/datum/preference/toggle/tgui_large_buttons)
	data["message"] = message
	data["swapped_buttons"] = FALSE //  !user.read_preference(/datum/preference/toggle/tgui_swapped_buttons)
	data["title"] = title

	return data

/datum/tgui_checkbox_input/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return

	switch(action)
		if("submit")
			var/list/selections = params["entry"] || list()
			if(length(selections) >= min_checked && length(selections) <= max_checked)
				var/list/valid_selections = list()
				for(var/raw_entry in selections)
					if(raw_entry in items)
						valid_selections += raw_entry
				set_choices(valid_selections)
			closed = TRUE
			SStgui.close_uis(src)
			return TRUE

		if("cancel")
			closed = TRUE
			SStgui.close_uis(src)
			return TRUE

	return FALSE

/datum/tgui_checkbox_input/proc/set_choices(list/selections)
	src.choices = selections.Copy()
