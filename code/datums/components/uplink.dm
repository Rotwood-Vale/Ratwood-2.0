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
	var/debug = FALSE
	var/saved_player_population = 0
	var/list/filters = list()
	var/challenge_mode = FALSE
	var/challenge_sound_channel = 83
	var/challenge_accepted = FALSE

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
	// Only Crimson Agents may operate this uplink
	if(user && !(user.mind?.has_antag_datum(/datum/antagonist/crimson)))
		to_chat(user, "I....don't know how to use this.")
		return COMPONENT_NO_INTERACT
	if(locked)
		// Never hard-lock non-lockable uplinks; auto-unlock as a safety valve
		if(!lockable)
			locked = FALSE
		else
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
		// Default to first category if none selected yet
		if(!selected_cat)
			for(var/category in uplink_items)
				selected_cat = category
				break
		ui_interact(user)
	return COMPONENT_NO_INTERACT

/datum/component/uplink/ui_state(mob/user)
	return GLOB.inventory_state

/datum/component/uplink/ui_interact(mob/user, datum/tgui/ui)
	active = TRUE
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		// Provide a larger default window size so the client uses it on first open.
		// Note: Client may remember geometry per window_key; this sets a good default.
		ui = new(user, src, "Uplink", "The Crimson Relinquary", 900, 640)
		ui.set_autoupdate(TRUE)
		ui.open()

/datum/component/uplink/ui_data(mob/user)
	if(!user?.mind)
		return
	var/list/data = list()
	data["telecrystals"] = telecrystals
	data["lockable"] = lockable
	data["selectedCat"] = selected_cat
	data["challengeAccepted"] = challenge_accepted
	// Provide items for the selected category so the UI can render them
	var/list/items = list()
	// Treat category name case-insensitively for Challenge special tab
	if(selected_cat && lowertext(selected_cat) == "challenge")
		data["challenge"] = TRUE
		// No faux items; UI handles the Challenge accept control directly
		data["items"] = items
		return data
	else
		data["challenge"] = FALSE
	if(selected_cat && uplink_items && uplink_items[selected_cat])
		for(var/item_name in uplink_items[selected_cat])
			var/datum/uplink_item/I = uplink_items[selected_cat][item_name]
			if(I.limited_stock == 0)
				continue
			if(I.restricted_roles?.len)
				var/is_inaccessible = TRUE
				for(var/R in I.restricted_roles)
					if(R == user.mind.assigned_role || debug)
						is_inaccessible = FALSE
				if(is_inaccessible)
					continue
			items += list(list("name" = I.name, "cost" = I.cost, "desc" = I.desc))
	data["items"] = items
	return data

/datum/component/uplink/ui_static_data(mob/user)
	var/list/data = list()
	// List just category names; item list provided dynamically in ui_data
	data["categories"] = list()
	for(var/category in uplink_items)
		data["categories"] += list(list("name" = category))
	// Always include a special Challenge category
	data["categories"] += list(list("name" = "Challenge"))
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
			// Build a lookup table of item name -> uplink_item
			var/list/buyable_items = list()
			for(var/category in uplink_items)
				for(var/item_key in uplink_items[category])
					buyable_items[item_key] = uplink_items[category][item_key]
			var/datum/uplink_item/I = buyable_items[item_name]
			if(I)
				MakePurchase(usr, I)
				return TRUE
		if("accept_challenge")
			if(challenge_accepted)
				return TRUE
			challenge_mode = TRUE
			challenge_accepted = TRUE
			if(usr)
				usr << span_bigbold(span_red("I ACCEPT! The challenge is on."))
				// Stop any ongoing challenge preview sound, then play a confirmation cue on the same channel
				usr << sound(null, channel = challenge_sound_channel)
				var/sound/Sa = sound('sound/villain/crimson_accepted.ogg')
				Sa.channel = challenge_sound_channel
				Sa.volume = 60
				usr << Sa
				var/player_name = "[usr]"
				if(ishuman(usr))
					var/mob/living/carbon/human/H = usr
					player_name = H.real_name
					// Auto-equip the Mask of the Crimson Order and lock it during Challenge Mode
					var/obj/item/clothing/mask/old_mask = H.get_item_by_slot(SLOT_WEAR_MASK)
					if(old_mask)
						H.dropItemToGround(old_mask, TRUE)
					var/obj/item/clothing/mask/rogue/facemask/goldmask/crimson_order/newmask = new(get_turf(H))
					if(H.equip_to_slot_or_del(newmask, SLOT_WEAR_MASK, TRUE))
						// Prevent removal while the challenge is active
						ADD_TRAIT(newmask, TRAIT_NODROP, "crimson_challenge")
						to_chat(H, span_warning("The Mask of the Crimson Order seals to your face!"))
				message_admins("[ADMIN_LOOKUPFLW(usr)] ([player_name]) has accepted The Crimson Order Challenge Mode.")
				log_game("Challenge Mode: [key_name(usr)] ([player_name]) accepted Crimson Agent Challenge Mode.")
			SStgui.update_uis(src)
			return TRUE
		if("lock")
			// Treat legacy 'lock' as a simple close
			active = FALSE
			SStgui.close_uis(src)
			return TRUE
		if("close")
			active = FALSE
			// Stop challenge sound if it is playing
			if(usr)
				usr << sound(null, channel = challenge_sound_channel)
			SStgui.close_uis(src)
			return TRUE
		if("select")
			var/new_cat = params["category"]
			// If leaving Challenge tab, stop its preview sound
			if(selected_cat && lowertext(selected_cat) == "challenge" && new_cat && lowertext(new_cat) != "challenge" && usr)
				usr << sound(null, channel = challenge_sound_channel)
			selected_cat = new_cat
			// If entering Challenge tab, play its preview sound on a dedicated channel (only if not yet accepted)
			if(selected_cat && lowertext(selected_cat) == "challenge" && usr && !challenge_accepted)
				var/sound/S = sound('sound/villain/crimson_challenge.ogg')
				S.channel = challenge_sound_channel
				S.volume = 60
				usr << S
			SStgui.update_uis(src)
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
	// Play a confirmation sound for normal shop purchases (local to buyer)
	if(user)
		var/sound/Sb = sound('sound/villain/crimson_buy.ogg')
		Sb.volume = 60
		user << Sb
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
