/**
 * Live control panel for the shockwave.
 *
 * Every value it edits lives in a global list that the wave reads when it runs,
 * so changes land on the next blast with no recompile. Preview fires the ripple
 * on the viewer alone - no damage, no sound, nothing broken - while Fire sets
 * off the real thing at their feet.
 */

GLOBAL_DATUM_INIT(shockwave_tuner, /datum/shockwave_tuner, new)

/**
 * Our own instance of the admin ui state.
 *
 * ADMIN_STATE() cannot be used: it indexes GLOB.admin_states, which is a plain
 * empty list, with a numeric rights flag. In DM a number on a plain list is a
 * positional index, not a key, so it runs straight off the end. Nothing else in
 * the codebase calls that macro, so it has never been exercised. Holding the
 * state datum ourselves gets the same permission check without touching core.
 */
GLOBAL_DATUM_INIT(shockwave_tuner_state, /datum/ui_state/admin_state, new(R_FUN))

/datum/shockwave_tuner
	/// Strength the preview ripple is fired at.
	var/preview_strength = 1

/datum/shockwave_tuner/ui_state(mob/user)
	return GLOB.shockwave_tuner_state

/datum/shockwave_tuner/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ShockwaveTuner", "Shockwave")
		ui.open()

/// The editable groups, in the order the panel shows them.
/datum/shockwave_tuner/proc/groups()
	return list(
		"blast" = GLOB.shockwave_blast,
		"damage" = GLOB.shockwave_damage,
		"visuals" = GLOB.shockwave_visuals,
	)

/datum/shockwave_tuner/ui_data(mob/user)
	var/list/out = list()
	var/list/sets = groups()
	for(var/group in sets)
		var/list/settings = list()
		var/list/values = sets[group]
		for(var/key in values)
			UNTYPED_LIST_ADD(settings, list(
				"name" = key,
				"value" = values[key],
			))
		UNTYPED_LIST_ADD(out, list(
			"key" = group,
			"settings" = settings,
		))
	return list(
		"groups" = out,
		"strength" = preview_strength,
	)

/datum/shockwave_tuner/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	switch(action)
		if("set")
			var/list/values = groups()[params["group"]]
			// Only groups and keys that already exist, so the panel cannot
			// invent settings or write somewhere it should not.
			if(!values || !(params["name"] in values))
				return
			values[params["name"]] = params["value"]
			return TRUE

		if("strength")
			preview_strength = clamp(params["value"], 0.1, 5)
			return TRUE

		if("preview")
			shockwave_ripple(user, 0, 0, preview_strength)
			return TRUE

		if("fire")
			var/turf/epicenter = get_turf(user)
			if(!epicenter)
				return
			fire_shockwave(epicenter, user)
			return TRUE

		if("reset")
			GLOB.shockwave_blast = shockwave_blast_defaults()
			GLOB.shockwave_damage = shockwave_damage_defaults()
			GLOB.shockwave_visuals = shockwave_visual_defaults()
			return TRUE

/client/proc/fenysha_shockwave_settings()
	set category = "Fun"
	set name = "Shockwave: Settings"
	set desc = "Tune the shockwave live, preview the distortion, and set one off."
	if(!check_rights(R_FUN))
		return
	GLOB.shockwave_tuner.ui_interact(mob)
