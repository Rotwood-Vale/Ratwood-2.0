// Ratworld persistent stash (bank) scaffolding
// Phase 1: Currency (Mammon) bank per-player persisted in data/player_saves/.../ratworld/stash.json
// Phase 2 (TODO): Item deposit/withdrawal with whitelist and serialization.

/datum/ratworld/stash
	var/ckey
	var/currency = 0 // mammon balance
	var/list/items = list() // uid -> record
	var/grid_w = 12
	var/grid_h = 8

/// Collision check for placing an item rectangle at (x,y)
/datum/ratworld/stash/proc/rect_collides(x, y, w, h, ignore_uid)
	if(x < 1 || y < 1 || x + w - 1 > grid_w || y + h - 1 > grid_h)
		return TRUE
	for(var/uid in items)
		if(uid == ignore_uid) continue
		var/list/R = items[uid]
		var/rx = R["x"]
		var/ry = R["y"]
		var/rw = R["w"] || 1
		var/rh = R["h"] || 1
		if(!(x+ w -1 < rx || rx + rw -1 < x || y + h -1 < ry || ry + rh -1 < y))
			return TRUE
	return FALSE

/// Find first free location for item of size w,h
/datum/ratworld/stash/proc/find_free_slot(w = 1, h = 1)
	for(var/ty in 1 to grid_h - h + 1)
		for(var/tx in 1 to grid_w - w + 1)
			if(!rect_collides(tx, ty, w, h, null))
				return list(tx, ty)
	return null

/datum/ratworld/stash/New(_ckey)
	..()
	ckey = lowertext(_ckey)
	Load()

/datum/ratworld/stash/proc/get_path()
	var/ch = copytext(ckey, 1, 2)
	return "data/player_saves/[ch]/[ckey]/ratworld/stash.json"

/datum/ratworld/stash/proc/Load()
	if(!ckey) return
	var/file_path = file(get_path())
	if(!fexists(file_path)) return
	var/list/json = json_decode(file2text(file_path))
	if(!islist(json)) return
	currency = clamp(text2num(json["currency"]), 0, 1000000000)
	var/list/jitems = json["items"]
	if(islist(jitems))
		items = jitems.Copy()
		// Lightweight migration: ensure icon & icon_state fields exist for UI
		for(var/uid in items)
			var/list/R = items[uid]
			if(!islist(R)) continue
			if(!istext(R["icon"]) || !istext(R["icon_state"]))
				var/path_text = R["path"]
				if(istext(path_text))
					var/typepath = text2path(path_text)
					if(typepath)
						// Create a temporary instance to introspect default icon data
						var/atom/temp_inst = new typepath
						if(temp_inst)
							if(!istext(R["icon"]) && istext(temp_inst.icon))
								R["icon"] = temp_inst.icon
							if(!istext(R["icon_state"]) && istext(temp_inst.icon_state))
								R["icon_state"] = temp_inst.icon_state
							qdel(temp_inst)
				// Final fallback if still missing (choose a roguetown generic sheet that exists)
				if(!istext(R["icon"])) R["icon"] = 'icons/roguetown/items/produce.dmi'
				if(!istext(R["icon_state"])) R["icon_state"] = ""

/datum/ratworld/stash/proc/Save()
	if(!ckey) return
	var/file_path = file(get_path())
	var/list/data = list("currency" = currency, "items" = items)
	fdel(file_path)
	WRITE_FILE(file_path, json_encode(data))

// Public helpers
// Global cache of per-ckey stash datums to avoid reloading & losing transient changes
GLOBAL_LIST_INIT(ratworld_stashes, list())

/proc/ratworld_get_stash(ck)
	var/lck = lowertext(ck)
	if(!lck) return null
	if(!(lck in GLOB.ratworld_stashes))
		GLOB.ratworld_stashes[lck] = new /datum/ratworld/stash(lck)
	return GLOB.ratworld_stashes[lck]

/// Deposit a live item into the player's stash; returns TRUE if stored.
/proc/ratworld_deposit_item(mob/living/user, obj/item/I, new_x = null, new_y = null)
	if(!user?.client?.ckey || !I)
		if(user)
			to_chat(user, span_warning("Deposit abort: missing ckey or item ref (user_ckey=[user?.client?.ckey] item=[I])."))
		return FALSE
	// Precompute text for coordinates to avoid nested quotes in interpolation
	var/tx = isnum(new_x) ? num2text(new_x) : "auto"
	var/ty = isnum(new_y) ? num2text(new_y) : "auto"
	to_chat(user, span_notice("DEBUG: deposit start item=[I] type=[I.type] stored=[I.ratworld_stored] loc=[I.loc] target_coords=([tx],[ty])."))
	if(!ratworld_can_stash(I))
		to_chat(user, span_warning("[I] cannot be stashed right now (stored=[I.ratworld_stored])."))
		return FALSE
	// Try to drop from hand into reliquary implicitly to ensure ownership
	if(user.get_active_held_item() == I)
		to_chat(user, span_notice("Dropping [I] to ground before serialization."))
		user.dropItemToGround(I)
	var/datum/ratworld/stash/S = ratworld_get_stash(user.client.ckey)
	// Anti-dupe: check existing UID collision before serialize
	if(I.ratworld_uid && (I.ratworld_uid in S.items))
		message_admins("RATWORLD DUPLICATE UID: Attempt to stash item with existing UID [I.ratworld_uid] by [key_name_admin(user)]")
		log_admin("RATWORLD: duplicate UID on deposit [I.ratworld_uid] type=[I.type] ckey=[user.client.ckey]")
		to_chat(user, span_warning("Duplicate UID detected; aborting deposit."))
		return FALSE
	var/list/rec = ratworld_serialize_item(I)
	var/uid_val = islist(rec) ? rec["uid"] : null
	var/uid_text = isnum(uid_val) ? num2text(uid_val) : "null"
	var/path_text = (islist(rec) && istext(rec["path"])) ? rec["path"] : "null"
	to_chat(user, span_notice("DEBUG: serialized item uid=[uid_text] path=[path_text]."))
	if(!islist(rec))
		to_chat(user, span_warning("Failed to serialize [I] for stashing."))
		return FALSE
	var/uid = rec["uid"]
	var/uid_key = "[uid]" // we store only string keys for consistency
	if(uid_key in S.items)
		message_admins("RATWORLD SERIALIZER DUPLICATE UID: [uid] for [key_name_admin(user)] type=[I.type]")
		log_admin("RATWORLD: serializer duplicate UID [uid] [I.type] ckey=[user.client.ckey]")
		to_chat(user, span_warning("Serializer produced duplicate UID; aborting."))
		return FALSE
	// Assign size (future: derive from item type, for now all 1x1)
	var/w = 1
	var/h = 1
	var/list/slot
	if(isnum(new_x) && isnum(new_y))
		if(S.rect_collides(new_x, new_y, w, h, null))
			to_chat(user, span_warning("Grid spot ([new_x],[new_y]) blocked; deposit cancelled."))
			return FALSE
		else
			slot = list(new_x, new_y)
	else
		slot = S.find_free_slot(w, h)
		if(!slot)
			to_chat(user, span_warning("No space left in vault grid for [I]."))
			return FALSE
	to_chat(user, span_notice("DEBUG: chosen slot=([slot[1]],[slot[2]]) before record insert.") )
	// Stepwise assignment with tracing; use associative list syntax without quotes around keys
	rec["x"] = slot[1]
	to_chat(user, span_notice("DEBUG: set rec.x=[rec["x"]]."))
	rec["y"] = slot[2]
	to_chat(user, span_notice("DEBUG: set rec.y=[rec["y"]]."))
	rec["w"] = w
	to_chat(user, span_notice("DEBUG: set rec.w=[rec["w"]]."))
	rec["h"] = h
	to_chat(user, span_notice("DEBUG: set rec.h=[rec["h"]]."))
	if(!islist(S.items)) S.items = list()
	S.items[uid_key] = rec
	to_chat(user, span_notice("DEBUG: inserted record uid=[uid]; items_len now=[S.items.len]."))
	I.ratworld_stored = TRUE
	to_chat(user, span_notice("DEBUG: qdel incoming for [I] (uid=[uid])."))
	qdel(I)
	S.Save()
	to_chat(user, span_notice("Stored [rec["path"]] uid=[uid] at ([rec["x"]],[rec["y"]]) total_items=[S.items.len]."))
	return TRUE

/// Withdraw an item by UID (or the first available) and spawn near the user
/proc/ratworld_withdraw_item(mob/living/user, uid)
	if(!user?.client?.ckey) return FALSE
	var/datum/ratworld/stash/S = ratworld_get_stash(user.client.ckey)
	var/uid_key = "[uid]"
	if(uid && !(uid_key in S.items))
		to_chat(user, span_warning("No such item in vault."))
		return FALSE
	var/list/rec
	if(uid)
		rec = S.items[uid_key]
	else if(S.items.len)
		// Pop first entry
		var/first_key = S.items[1] // first_key will be string key since we only store string keys
		rec = S.items[first_key]
		if(istext(first_key)) uid = text2num(first_key)
	if(!islist(rec)) return FALSE
	// Basic integrity: ensure rec has uid field matching key
	if(rec["uid"] != uid)
		message_admins("RATWORLD STASH RECORD CORRUPTION: UID mismatch (key=[uid] record=[rec["uid"]]) for [key_name_admin(user)]")
		log_admin("RATWORLD: stash record corruption key=[uid] != rec=[rec["uid"]] ckey=[user.client.ckey]")
		return FALSE
	var/obj/item/I = ratworld_deserialize_item(rec, user)
	if(!I)
		to_chat(user, span_warning("Failed to reconstruct item."))
		return FALSE
	// Prefer placing directly into any free hand; fallback to floor if none free
	if(ismob(user))
		var/mob/living/L = user
		// Try active hand first, then inactive, then belt slot as bonus security
		if(!L.get_active_held_item())
			L.put_in_active_hand(I)
		else if(!L.get_inactive_held_item())
			L.put_in_inactive_hand(I)
		else
			var/obj/item/belt_slot = L.get_item_by_slot(SLOT_BELT)
			if(!belt_slot && (I.slot_flags & SLOT_BELT))
				L.equip_to_slot_if_possible(I, SLOT_BELT, qdel_on_fail = FALSE, disable_warning = TRUE)
			if(I.loc != L)
				to_chat(user, span_warning("My hands (and belt) are full; the item drops to the ground."))
	S.items -= uid_key
	S.Save()
	to_chat(user, span_notice("I withdraw an item from my vault."))
	return TRUE

/// Move an item within the grid
/proc/ratworld_move_item(mob/living/user, uid, new_x, new_y)
	if(!user?.client?.ckey) return FALSE
	var/datum/ratworld/stash/S = ratworld_get_stash(user.client.ckey)
	var/uid_key = "[uid]"
	if(!(uid_key in S.items)) return FALSE
	var/list/R = S.items[uid_key]
	var/w = R["w"] || 1
	var/h = R["h"] || 1
	if(S.rect_collides(new_x, new_y, w, h, uid))
		to_chat(user, span_warning("That spot is occupied."))
		return FALSE
	R["x"] = new_x
	R["y"] = new_y
	S.Save()
	return TRUE

/proc/ratworld_deposit_mammon(mob/living/user, amount)
	amount = round(max(0, amount))
	if(!amount) return FALSE
	if(!user?.client?.ckey) return FALSE
	// Use treasury bank accounts as the in-round currency store for now
	if(!(user in SStreasury.bank_accounts))
		SStreasury.create_bank_account(user)
	if(SStreasury.bank_accounts[user] < amount)
		to_chat(user, span_warning("I don't have that much mammon on hand."))
		return FALSE
	var/datum/ratworld/stash/S = ratworld_get_stash(user.client.ckey)
	SStreasury.bank_accounts[user] -= amount
	S.currency += amount
	S.Save()
	to_chat(user, span_notice("I deposit [amount] mammon to my vault. New balance: [S.currency]."))
	return TRUE

/proc/ratworld_withdraw_mammon(mob/living/user, amount)
	amount = round(max(0, amount))
	if(!amount) return FALSE
	if(!user?.client?.ckey) return FALSE
	var/datum/ratworld/stash/S = ratworld_get_stash(user.client.ckey)
	if(S.currency < amount)
		to_chat(user, span_warning("Insufficient vault balance."))
		return FALSE
	S.currency -= amount
	if(!(user in SStreasury.bank_accounts))
		SStreasury.create_bank_account(user)
	SStreasury.bank_accounts[user] += amount
	S.Save()
	to_chat(user, span_notice("I withdraw [amount] mammon from my vault. New balance: [S.currency]."))
	return TRUE

// Quick verbs for testing; later replaced with a TGUI bank console
/client/verb/ratworld_stash_balance()
	set name = "Vault Balance"
	set category = "Ratworld"
	if(!src?.ckey) return
	var/datum/ratworld/stash/S = ratworld_get_stash(src.ckey)
	to_chat(src, span_notice("Vault balance: [S.currency] mammon"))

/client/verb/ratworld_deposit()
	set name = "Deposit Mammon"
	set category = "Ratworld"
	var/amt = input(src, "How much mammon to deposit?", "Deposit") as num
	if(!isnum(amt)) return
	ratworld_deposit_mammon(mob, amt)

/client/verb/ratworld_withdraw()
	set name = "Withdraw Mammon"
	set category = "Ratworld"
	var/amt = input(src, "How much mammon to withdraw?", "Withdraw") as num
	if(!isnum(amt)) return
	ratworld_withdraw_mammon(mob, amt)

// Reliquary structure that opens TGUI and accepts deposits by using items on it
// NOTE: icon placeholder uses a generic structure sprite to avoid missing file
/obj/structure/ratworld_reliquary
	name = "Reliquary of Gold"
	desc = "A sacred vault where wealth and relics are safeguarded."
	density = TRUE
	anchored = TRUE

	attack_hand(mob/living/user)
		if(!user?.client) return ..()
		// Open TGUI panel (proc defined in tgui_stash.dm) - do not call parent until after opening
		src.open_ui(user)
		return ..()

	attackby(obj/item/W, mob/living/user, params)
		if(!user?.client) return ..()
		// Attempt direct deposit if viable
		if(istype(W,/obj/item))
			if(ratworld_deposit_item(user, W))
				return TRUE
		return ..()
