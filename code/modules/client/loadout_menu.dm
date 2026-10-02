/datum/loadout_menu
	var/current_slot

/datum/loadout_menu/New()
	. = ..()

/datum/loadout_menu/Destroy()
	// clean up any vars first
	current_slot = null
	. = ..()

/datum/loadout_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LoadoutMenu", "Loadout Menu")
		ui.set_state(GLOB.always_state)
		ui.open()

/datum/loadout_menu/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/loadout_items)
	)

/datum/loadout_menu/ui_data(mob/user)
	var/list/data = ..()
	return data

/datum/loadout_menu/ui_static_data(mob/user)
	var/list/data = ..()
	var/list/loadout_items = list()
	var/datum/preferences/prefs = user.client?.prefs
	var/datum/asset/spritesheet/spritesheet = get_asset_datum(/datum/asset/spritesheet/loadout_items)

	for(var/datum/loadout_item/item as anything in GLOB.loadout_items)
		var/obj/item/I = item.path
		var/donoritem_passed = TRUE // This isn't checking if it is a donor item.
		var/granted = item.loadout_category && prefs?.get_loadout_allowance(item.loadout_category)
		if(item.donoritem)
			if(!item.donator_ckey_check(user.key)) // IF it is a donor item AND the ckey doesn't match the donor ckey list...
				donoritem_passed = FALSE // True means it won't show up in the TGUI
		UNTYPED_LIST_ADD(loadout_items, list(
			"name" = item.name,
			"desc" = initial(I.desc),
			"category" = item.loadout_category,
			"unlock" = get_loadout_unlock_names(item.loadout_category),
			"granted" = !!granted,
			"locked" = !!(item.loadout_category && !granted),
			"donoritem" = donoritem_passed,
			"ref" = ref(item),
			"icon" = spritesheet.icon_class_name(sanitize_css_class_name("loadout_item_[REF(item)]"))
		))
	data["loadout_items"] = loadout_items
	return data

/datum/loadout_menu/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	if(!current_slot || current_slot < 1 || current_slot > LOADOUT_SLOTS)
		ui.close()
		return

	var/mob/user = ui.user
	var/datum/preferences/prefs = user.client?.prefs
	if(!prefs)
		ui.close()
		return

	switch(action)
		if("choose_item")
			var/datum/loadout_item/item = locate(params["ref"])
			if(!istype(item))
				ui.close()
				prefs.open_loadout_slots(user)
				return TRUE
			for(var/slot in 1 to LOADOUT_SLOTS)
				if(slot != current_slot && prefs.vars[prefs.loadout_var(slot)] == item)
					to_chat(usr, span_warning("[item.name] is already in slot [slot]."))
					ui.close()
					prefs.open_loadout_slots(user)
					return TRUE
			if(!prefs.can_pick_loadout_item(item, current_slot))
				to_chat(usr, span_warning("Your traits don't allow another [item.loadout_category] item."))
				ui.close()
				prefs.open_loadout_slots(user)
				return TRUE
			// apply item to loadout
			prefs.vars[prefs.loadout_var(current_slot)] = item
			to_chat(usr, span_notice("Selected [item.name] for slot [current_slot]."))
			ui.close()
			prefs.open_loadout_slots(user)
