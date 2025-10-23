// Minimal Syndicate-style uplink component (ported, trimmed for MVP)
// License-compatible import scaffold. UI opens via attack_self when unlocked.

GLOBAL_LIST_EMPTY(uplinks)

/datum/component/uplink
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/name = "uplink"
	var/active = FALSE
	var/lockable = TRUE
	var/locked = TRUE
	var/allow_restricted = TRUE
	var/telecrystals = 0
	var/selected_cat
	var/owner = null
	var/gamemode
	var/datum/uplink_purchase_log/purchase_log
	var/list/uplink_items
	var/hidden_crystals = 0
	var/unlock_note
	var/unlock_code
	var/failsafe_code
	var/compact_mode = FALSE
	var/debug = FALSE
	var/saved_player_population = 0
	var/list/filters = list()

/datum/component/uplink/Initialize(_owner, _lockable = TRUE, _enabled = FALSE, _gamemode, starting_tc = 20, traitor_class)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, .proc/OnAttackBy)
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, .proc/interact)
	// Disguised item signals (PDA/radio/pen) intentionally omitted in Ratwood MVP

	GLOB.uplinks += src
	// traitor_class not used in Ratwood MVP
	uplink_items = get_uplink_items(gamemode, TRUE, allow_restricted, filters)

	if(_owner)
		owner = _owner
		LAZYINITLIST(GLOB.uplink_purchase_logs_by_key)
		if(GLOB.uplink_purchase_logs_by_key[owner])
			purchase_log = GLOB.uplink_purchase_logs_by_key[owner]
		else
			purchase_log = new(owner, src)

	lockable = _lockable
	active = _enabled
	gamemode = _gamemode
	telecrystals = starting_tc
	if(!lockable)
		active = TRUE
		locked = FALSE
	saved_player_population = length(GLOB.joined_player_list)

/datum/component/uplink/Destroy()
	GLOB.uplinks -= src
	gamemode = null
	purchase_log = null
	return ..()

/datum/component/uplink/proc/OnAttackBy(datum/source, obj/item/I, mob/user)
	if(!active)
		return
	return

/datum/component/uplink/proc/interact(datum/source, mob/user)
	if(locked)
		return
	active = TRUE
	if(user)
		var/previous_player_population = saved_player_population
		saved_player_population = length(GLOB.joined_player_list)
		if(saved_player_population != previous_player_population)
			var/old_discounts = uplink_items["Discounted Gear"]
			uplink_items = get_uplink_items(gamemode, FALSE, allow_restricted, filters)
			if(old_discounts)
				uplink_items["Discounted Gear"] = old_discounts
		ui_interact(user)
	return COMPONENT_NO_INTERACT

/datum/component/uplink/ui_state(mob/user)
	return GLOB.inventory_state

/datum/component/uplink/ui_interact(mob/user, datum/tgui/ui)
	active = TRUE
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Uplink", name)
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/component/uplink/ui_data(mob/user)
	if(!user?.mind)
		return
	var/list/data = list()
	data["telecrystals"] = telecrystals
	data["lockable"] = lockable
	data["compactMode"] = compact_mode
	return data

/datum/component/uplink/ui_static_data(mob/user)
	var/list/data = list()
	data["categories"] = list()
	for(var/category in uplink_items)
		var/list/cat = list("name" = category, "items" = (category == selected_cat ? list() : null))
		for(var/item in uplink_items[category])
			var/datum/uplink_item/I = uplink_items[category][item]
			if(I.limited_stock == 0)
				continue
			if(I.restricted_roles?.len)
				var/is_inaccessible = TRUE
				for(var/R in I.restricted_roles)
					if(R == user.mind.assigned_role || debug)
						is_inaccessible = FALSE
				if(is_inaccessible)
					continue
			cat["items"] += list(list("name" = I.name, "cost" = I.cost, "desc" = I.desc))
		data["categories"] += list(cat)
	return data

/datum/component/uplink/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(!active)
		return
	switch(action)
		if("buy")
			var/item_name = params["name"]
			var/list/buyable_items = list()
			for(var/category in uplink_items)
				buyable_items += uplink_items[category]
			if(item_name in buyable_items)
				var/datum/uplink_item/I = buyable_items[item_name]
				MakePurchase(usr, I)
				return TRUE
		if("lock")
			active = FALSE
			locked = TRUE
			telecrystals += hidden_crystals
			hidden_crystals = 0
			SStgui.close_uis(src)
		if("select")
			selected_cat = params["category"]
			return TRUE
		if("compact_toggle")
			compact_mode = !compact_mode
			return TRUE

/datum/component/uplink/proc/MakePurchase(mob/user, datum/uplink_item/U)
	if(!istype(U))
		return
	if(!user || user.incapacitated())
		return
	if(telecrystals < U.cost || U.limited_stock == 0)
		return
	telecrystals -= U.cost
	U.purchase(user, src)
	if(U.limited_stock > 0)
		U.limited_stock -= 1
	SSblackbox.record_feedback("nested tally", "traitor_uplink_items_bought", 1, list("[initial(U.name)]", "[U.cost]"))
	return TRUE

// Disguised unlock methods (PDA/radio/pen) omitted for MVP

/datum/component/uplink/proc/setup_unlock_code()
	unlock_code = generate_code()
	var/obj/item/P = parent
	unlock_note = "<B>Uplink Code:</B> [unlock_code] ([P.name])."

/datum/component/uplink/proc/generate_code()
	return uppertext(copytext(md5("[world.time]-[rand()]"), 1, 6))

/datum/component/uplink/proc/failsafe(mob/living/carbon/user)
	if(!parent)
		return
	var/turf/T = get_turf(parent)
	if(!T)
		return
	message_admins("[ADMIN_LOOKUPFLW(user)] has triggered an uplink failsafe explosion at [AREACOORD(T)]. The owner was [ADMIN_LOOKUPFLW(owner)].")
	log_game("[key_name(user)] triggered an uplink failsafe.")
	explosion(T,1,2,3)
	qdel(parent)
