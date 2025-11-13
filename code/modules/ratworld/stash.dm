// Ratworld persistent stash (bank) scaffolding
// Phase 1: Currency (Mammon) bank per-player persisted in data/player_saves/.../ratworld/stash.json
// Phase 2 (TODO): Item deposit/withdrawal with whitelist and serialization.

/datum/ratworld/stash
	var/ckey
	var/currency = 0 // mammon balance (unused for coin storage; display shows nervelock)
	var/list/items = list() // uid -> record
	var/grid_w = 24
	var/grid_h = 16

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

// Migrate a stash record to ensure required fields and normalized vault_uid prefix

/proc/ratworld_migrate_record(list/R)
	// Normalize and enrich legacy stash records so UI previews and sizing work
	if(!islist(R)) return
	// Ensure typepath exists (prefer explicit key, fallback to legacy 'path')
	if(!istext(R["typepath"]) && istext(R["path"]))
		R["typepath"] = R["path"]
	// Ensure legacy 'path' exists too for UI that still reads it
	if(!istext(R["path"]) && istext(R["typepath"]))
		R["path"] = R["typepath"]
	// Attempt to backfill icon/icon_state and footprint if missing using a temporary instance
	var/need_icon = (!istext(R["icon"]) || !istext(R["icon_state"]))
	var/need_size = (!isnum(R["w"]) || !isnum(R["h"]) || R["w"] < 1 || R["h"] < 1)
	if(need_icon || need_size)
		var/tp_text = R["typepath"]
		var/tp = istext(tp_text) ? text2path(tp_text) : null
		if(tp && ispath(tp, /obj/item))
			var/obj/item/tmp = new tp()
			if(tmp)
				if(need_icon)
					if(!istext(R["icon"]) && istext(tmp.icon)) R["icon"] = tmp.icon
					if(!istext(R["icon_state"]) && istext(tmp.icon_state)) R["icon_state"] = tmp.icon_state
				if(need_size)
					var/list/sz = ratworld_compute_item_size(tmp)
					if(islist(sz))
						if(!isnum(R["w"]) || R["w"] < 1) R["w"] = sz[1]
						if(!isnum(R["h"]) || R["h"] < 1) R["h"] = sz[2]
				qdel(tmp)
	// Safe defaults if still missing
	if(!istext(R["icon"])) R["icon"] = 'icons/roguetown/clothing/wrists.dmi'
	if(!istext(R["icon_state"])) R["icon_state"] = "default"
	if(!isnum(R["w"]) || R["w"] < 1) R["w"] = 1
	if(!isnum(R["h"]) || R["h"] < 1) R["h"] = 1
	// Normalize vault_uid: enforce A/D/S/U prefix and upgrade U/invalid to D
	var/vuid_any = R["vault_uid"]
	if(isnum(vuid_any)) R["vault_uid"] = "D[vuid_any]"
	if(istext(vuid_any))
		var/pre = copytext(vuid_any, 1, 2)
		if(!(pre == "A" || pre == "D" || pre == "S" || pre == "U"))
			R["vault_uid"] = "D[vuid_any]"
		else if(pre == "U")
			R["vault_uid"] = "D[copytext(vuid_any, 2)]"

/datum/ratworld/stash/proc/Load()
	if(!ckey) return
	var/file_path = file(get_path())
	if(!fexists(file_path)) return
	var/textdata = file2text(file_path)
	if(!istext(textdata) || !length(textdata)) return
	var/list/json = json_decode(textdata)
	if(!islist(json)) return
	currency = clamp(text2num(json["currency"]), 0, 1000000000)
	var/list/jitems = json["items"]
	if(!islist(jitems)) return
	// Copy then migrate each record; rekey by vault_uid if valid
	var/list/new_items = list()
	for(var/key in jitems)
		var/list/R = jitems[key]
		if(!islist(R)) continue
		// Migrate record (fills icon/icon_state and normalizes vault_uid)
		ratworld_migrate_record(R)
		var/vuid = null
		if(istext(R["vault_uid"])) vuid = R["vault_uid"]
		if(vuid && !(vuid in new_items))
			new_items[vuid] = R
		else
			// fallback to original key stringified
			new_items["[key]"] = R
	items = new_items

/datum/ratworld/stash/proc/Save()
	if(!ckey) return
	var/file_path = file(get_path())
	var/list/data = list("currency" = currency, "items" = items)
	fdel(file_path)
	WRITE_FILE(file_path, json_encode(data))

// Public helpers
// Global cache of per-ckey stash datums to avoid reloading & losing transient changes
GLOBAL_LIST_INIT(ratworld_stashes, list())

// Debug controls (per-user): enable verbose stash logs selectively
GLOBAL_LIST_INIT(ratworld_stash_debug_ckeys, list())

// Returns TRUE if verbose stash debug is enabled for this user
/proc/ratworld_is_debug(mob/living/user)
	if(!user?.client?.ckey) return FALSE
	var/ck = lowertext(user.client.ckey)
	return (ck in GLOB.ratworld_stash_debug_ckeys)

// Enable or disable stash debug for a user
/proc/ratworld_set_debug(mob/living/user, enabled)
	if(!user?.client?.ckey) return
	var/ck = lowertext(user.client.ckey)
	if(enabled)
		GLOB.ratworld_stash_debug_ckeys[ck] = TRUE
	else
		GLOB.ratworld_stash_debug_ckeys -= ck

// Conditionally emit a DEBUG to_chat line if enabled for user
/proc/ratworld_dbg(mob/living/user, msg)
	if(!ratworld_is_debug(user)) return
	to_chat(user, span_notice(msg))

// Track the last stash error/info message per user for UI and chat surfacing
GLOBAL_LIST_INIT(ratworld_stash_last_error, list())

/proc/ratworld_set_last_stash_message(mob/living/user, txt)
	if(!user?.client?.ckey) return
	var/ck = lowertext(user.client.ckey)
	if(istext(txt) && length(txt))
		GLOB.ratworld_stash_last_error[ck] = txt
	else
		GLOB.ratworld_stash_last_error -= ck

/proc/ratworld_get_last_stash_message(mob/living/user)
	if(!user?.client?.ckey) return null
	var/ck = lowertext(user.client.ckey)
	return GLOB.ratworld_stash_last_error[ck]

/proc/ratworld_get_stash(ck)
	var/lck = lowertext(ck)
	if(!lck) return null
	if(!(lck in GLOB.ratworld_stashes))
		GLOB.ratworld_stashes[lck] = new /datum/ratworld/stash(lck)
	return GLOB.ratworld_stashes[lck]

// Returns TRUE if an item is a coin/mammon-like currency object (should not be stored in the reliquary)
/proc/ratworld_is_coin_like(obj/item/I)
	if(!I) return FALSE
	if(istype(I, /obj/item/roguecoin)) return TRUE
	if(istype(I, /obj/item/stack/currency/mammon)) return TRUE
	var/lp = lowertext("[I.type]")
	if(findtext(lp, "coin") || findtext(lp, "currency") || findtext(lp, "mammon") || findtext(lp, "zenny")) return TRUE
	return FALSE

// Build a minimal, safe serialization record for an item when normal serialization fails
/proc/ratworld_build_fallback_record(mob/living/user, obj/item/I)
	var/f_uid = isnull(I?.ratworld_uid) ? 0 : I.ratworld_uid
	var/f_vuid = (("vault_uid" in I.vars) && istext(I.vars["vault_uid"])) ? I.vars["vault_uid"] : null
	if(!f_uid)
		f_uid = GLOB.ratworld_next_item_uid
		GLOB.ratworld_next_item_uid++
	if(!f_vuid)
		f_vuid = ratworld_generate_vault_uid(user, I)
		if(isnum(f_vuid))
			var/pfx = ratworld_classify_item_origin(user, I)
			f_vuid = "[pfx][f_vuid]"
	var/list/frec = list()
	frec["typepath"] = "[I.type]"
	frec["uid"] = f_uid
	frec["vault_uid"] = f_vuid
	if(istext(I.icon))
		frec["icon"] = I.icon
	else
		var/icon_text = "[I.icon]"
		if(istext(icon_text) && length(icon_text))
			frec["icon"] = icon_text
		else
			var/init_icon_text = "[initial(I.icon)]"
			if(istext(init_icon_text) && length(init_icon_text))
				frec["icon"] = init_icon_text
	if(istext(I.icon_state))
		frec["icon_state"] = I.icon_state
	else
		var/init_state = initial(I.icon_state)
		if(istext(init_state))
			frec["icon_state"] = init_state
	if(!istext(frec["icon"]))
		frec["icon"] = 'icons/roguetown/clothing/wrists.dmi'
	if(!istext(frec["icon_state"]))
		frec["icon_state"] = "default"
	return frec

/// Deposit a live item into the player's stash; returns TRUE if stored.
/proc/ratworld_deposit_item(mob/living/user, obj/item/I, new_x = null, new_y = null)
	if(!user?.client?.ckey) return FALSE
	if(!I) return FALSE
	// Entry debug
	ratworld_dbg(user, "DEBUG: deposit start item=[I] type=[I.type] coords=([new_x],[new_y]).")
	ratworld_set_last_stash_message(user, "")
	try
		// Block coin/mammon-like items from being deposited; instruct to use nervelock
		if(ratworld_is_coin_like(I))
			to_chat(user, span_warning("You can't deposit mammon here. Use your nervelock to manage coin."))
			ratworld_dbg(user, "DEBUG: deposit blocked (coin-like) type=[I.type].")
			ratworld_set_last_stash_message(user, "Coin-like items cannot be stored. Use your nervelock.")
			ratworld_play_stash_error(user)
			return FALSE
		if(!ratworld_can_stash(I))
			to_chat(user, span_warning("[I] cannot be stashed right now."))
			ratworld_dbg(user, "DEBUG: deposit blocked (cannot stash) type=[I.type] contents_len=[I.contents?.len].")
			ratworld_set_last_stash_message(user, "This item cannot be stashed now (container or has contents).")
			return FALSE
		var/datum/ratworld/stash/S = ratworld_get_stash(user.client.ckey)
		// Ensure uid and a prefixed vault_uid on the item
		ratworld_assign_uid(I)
		ratworld_assign_vault_uid(user, I)
		// Serialize the item to capture path, uid, icon/state, and rw_* fields (rarity/enchants)
		var/list/rec = ratworld_serialize_item(I)
		// Normalize mandatory fields expected by stash UI
		rec["typepath"] = istext(rec["path"]) ? rec["path"] : "[I.type]"
		// Ensure we use the exact vault_uid determined by assign_vault_uid
		if(istext(I.vault_uid) && length(I.vault_uid))
			rec["vault_uid"] = I.vault_uid
		// Compute size
		var/list/size = ratworld_compute_item_size(I)
		var/w = islist(size) ? size[1] : 1
		var/h = islist(size) ? size[2] : 1
		// Find slot
		var/list/slot
		if(isnum(new_x) && isnum(new_y))
			if(S.rect_collides(new_x, new_y, w, h, null))
				to_chat(user, span_warning("That spot is occupied."))
				// Identify the first colliding record to aid debugging
				var/coll_key = null
				var/list/coll_rec = null
				for(var/kcol in S.items)
					var/list/Rcol = S.items[kcol]
					if(!islist(Rcol)) continue
					var/rx = Rcol["x"]
					var/ry = Rcol["y"]
					var/rw = Rcol["w"] || 1
					var/rh = Rcol["h"] || 1
					if(!(new_x + w - 1 < rx || rx + rw - 1 < new_x || new_y + h - 1 < ry || ry + rh - 1 < new_y))
						coll_key = kcol
						coll_rec = Rcol
						break
				if(coll_rec)
					var/cx = coll_rec["x"]
					var/cy = coll_rec["y"]
					var/cw = coll_rec["w"] || 1
					var/ch = coll_rec["h"] || 1
					ratworld_dbg(user, "DEBUG: deposit collision at ([new_x],[new_y]) size=([w]x[h]) with [coll_key]@([cx],[cy]) size=([cw]x[ch]).")
					ratworld_set_last_stash_message(user, "Cell occupied by [coll_key] at ([cx],[cy]) size [cw]x[ch].")
				else
					ratworld_dbg(user, "DEBUG: deposit failed at ([new_x],[new_y]) size=([w]x[h]) due to collision (no record identified).")
					ratworld_set_last_stash_message(user, "Cell appears occupied (no record identified).")
				return FALSE
			slot = list(new_x, new_y)
			ratworld_dbg(user, "DEBUG: deposit placement accepted at ([new_x],[new_y]) size=([w]x[h]).")
		else
			slot = S.find_free_slot(w, h)
			if(!slot)
				to_chat(user, span_warning("No space left in the vault."))
				ratworld_dbg(user, "DEBUG: deposit auto-place failed (no space) for type=[I.type] size=([w]x[h]).")
				ratworld_set_last_stash_message(user, "No empty space large enough for [w]x[h].")
				return FALSE
		// Ensure unique key
		var/key_id = rec["vault_uid"]
		if(!islist(S.items)) S.items = list()
		if(key_id in S.items)
			var/tries = 0
			while(key_id in S.items && tries < 6)
				var/tmp = ratworld_generate_vault_uid(user, I)
				if(isnum(tmp))
					var/pfx2 = ratworld_classify_item_origin(user, I)
					tmp = "[pfx2][tmp]"
				rec["vault_uid"] = tmp
				key_id = tmp
				tries++
			if(key_id in S.items)
				to_chat(user, span_warning("Couldn't assign a unique vault UID."))
				ratworld_dbg(user, "DEBUG: deposit aborted (vault_uid collision) after [tries] tries.")
				ratworld_set_last_stash_message(user, "Could not assign unique vault ID after [tries] tries.")
				return FALSE
		// Finalize and store
		rec["x"] = slot[1]
		rec["y"] = slot[2]
		rec["w"] = w
		rec["h"] = h
		S.items[key_id] = rec
		var/_dp_tp = rec["typepath"]
		var/_dp_x = rec["x"]
		var/_dp_y = rec["y"]
		ratworld_dbg(user, "DEBUG: deposit record stored key=[key_id] path=[_dp_tp] at ([_dp_x],[_dp_y]).")
		// Prepare summary values prior to qdel to avoid string indexing issues
		var/_tpath = rec["typepath"]
		var/_rx = rec["x"]
		var/_ry = rec["y"]
		// SFX, delete, save
		ratworld_dbg(user, "DEBUG: deposit pre-sfx; calling stash_sfx.")
		ratworld_play_stash_sfx(user, I, "deposit")
		I.ratworld_stored = TRUE
		qdel(I)
		ratworld_dbg(user, "DEBUG: deposit post-sfx; deleting live item and saving stash.")
		S.Save()
		ratworld_dbg(user, "DEBUG: deposit success; saved stash.")
		ratworld_set_last_stash_message(user, "Stored [_tpath] at ([_rx],[_ry]) as [key_id].")
		to_chat(user, span_notice("Stored [_tpath] at ([_rx],[_ry]) as [key_id]."))
		return TRUE
	catch(var/exception/e)
		// Surface runtime error context
		var/msg = "Internal error during deposit: [e]"
		ratworld_dbg(user, "DEBUG: deposit exception: [e]")
		ratworld_set_last_stash_message(user, msg)
		ratworld_play_stash_error(user)
		return FALSE

/// Withdraw an item by UID (or the first available) and spawn near the user
/proc/ratworld_withdraw_item(mob/living/user, uid)
	if(!user?.client?.ckey) return FALSE
	var/datum/ratworld/stash/S = ratworld_get_stash(user.client.ckey)
	var/uid_key = "[uid]"
	// Support new vault_uid withdrawals: if param is text and matches vault key, use directly
	if(istext(uid) && (uid in S.items))
		uid_key = uid
	if(uid && !(uid_key in S.items))
		to_chat(user, span_warning("No such item in vault."))
		ratworld_play_stash_error(user)
		return FALSE
	var/list/rec
	if(uid)
		rec = S.items[uid_key]
	if(!rec && S.items.len)
		// Pop first entry regardless of key format
		var/first_key = S.items[1]
		rec = S.items[first_key]
		if(istext(first_key)) uid = text2num(first_key)
	if(!islist(rec)) return FALSE
	// Basic integrity: ensure rec has uid field matching key
	var/rec_uidnum = rec["uid"]
	var/rec_vuidtxt = rec["vault_uid"]
	if(rec_uidnum != uid && rec_vuidtxt != uid_key)
		message_admins("RATWORLD STASH RECORD CORRUPTION: UID mismatch (key=[uid] record=[rec_uidnum]) for [key_name_admin(user)]")
		log_admin("RATWORLD: stash record corruption key=[uid] != rec=[rec_uidnum] ckey=[user.client.ckey]")
		ratworld_play_stash_error(user)
		return FALSE
	// Reconstruct first using a fresh, robust spawner; only remove from stash upon success
	var/rp0 = istext(rec["typepath"]) ? rec["typepath"] : (istext(rec["path"]) ? rec["path"] : "<none>")
	ratworld_dbg(user, "DEBUG: withdraw start uid_key=[uid_key] path=[rp0] user_loc=([user.x],[user.y],[user.z]).")
	var/atom/movable/AM = ratworld_spawn_item_from_record(user, rec)
	if(!AM)
		ratworld_dbg(user, "DEBUG: spawn_from_record returned null; aborting without touching stash.")
		return FALSE
	ratworld_dbg(user, "DEBUG: reconstruct success ref=[AM] type=[AM.type] loc=([AM.x],[AM.y],[AM.z]).")
	var/obj/item/I = null
	if(istype(AM, /obj/item))
		I = AM
	if(!I)
		ratworld_dbg(user, "DEBUG: spawned ref is not an /obj/item; type=[AM.type].")
		return FALSE
	// Preserve vault_uid (guarded) and skip risky var diffs to avoid runtimes
	if(istext(rec["vault_uid"]))
		if("vault_uid" in I.vars)
			I.vault_uid = rec["vault_uid"]
		var/firstc = copytext(rec["vault_uid"],1,2)
		if((firstc == "A" || firstc == "D" || firstc == "S") && ("vault_origin" in I.vars))
			I.vars["vault_origin"] = firstc
		// Failsafe: set admin-spawn flag if prefix is A
		if(firstc == "A" && ("flags_1" in I.vars))
			I.flags_1 |= ADMIN_SPAWNED_1
	// Temporarily skip applying rec["vars"] to avoid type/readonly runtime crashes
	var/list/diff = rec["vars"]
	if(islist(diff))
		ratworld_dbg(user, "DEBUG: skipping diff var application (safety).")
	ratworld_dbg(user, "DEBUG: post-vars stage ok; proceeding to placement.")
	// Placement: prefer putting the item into the user's hands; else place on their turf
	var/mob/living/L = user
	var/turf/T = get_turf(L)
	if(!T)
		var/cx = round(world.maxx/2)
		var/cy = round(world.maxy/2)
		T = locate(max(1,cx), max(1,cy), 1)
	// Ensure item is on a turf first (avoid nullspace)
	if(I && !isturf(I.loc))
		I.forceMove(T)
	// Try to place in hands: allow forced pickup for stubborn types
	var/hand_ok = FALSE
	if(I && L)
		// put_in_hands(self, del_on_fail=FALSE, merge_stacks=TRUE, forced=TRUE)
		hand_ok = L.put_in_hands(I, FALSE, TRUE, TRUE)
		if(!hand_ok)
			// Try explicit active/inactive with forced flag as fallback
			if(!L.get_active_held_item())
				hand_ok = L.put_in_active_hand(I, TRUE)
			if(!hand_ok && !L.get_inactive_held_item())
				hand_ok = L.put_in_inactive_hand(I, TRUE)
		if(hand_ok)
			ratworld_dbg(user, "DEBUG: put_in_hands success; now holding [I].")
		else
			ratworld_dbg(user, "DEBUG: put_in_hands failed; leaving on turf.")
	// If not in hands, ensure it remains on turf
	if(I && I.loc != L)
		if(!isturf(I.loc))
			I.forceMove(T)
	// Validate placement before removing record
	var/ok_loc = (I && (I.loc == L || isturf(I.loc)))
	if(!ok_loc)
		ratworld_dbg(user, "DEBUG: withdraw placement failed; item still in nullspace. Aborting without removing record.")
		if(I)
			qdel(I)
		ratworld_play_stash_error(user)
		return FALSE
	// On success, remove from stash now (rebuild items list to guarantee deletion)
	var/old_len = islist(S.items) ? S.items.len : -1
	var/list/new_items = list()
	var/skip_count = 0
	for(var/k3 in S.items)
		var/list/R3 = S.items[k3]
		var/skip = FALSE
		if(k3 == uid_key)
			skip = TRUE
		if(!skip && islist(R3) && istext(R3["vault_uid"]) && R3["vault_uid"] == uid_key)
			skip = TRUE
		if(skip)
			skip_count++
		else
			new_items[k3] = R3
	S.items = new_items
	var/new_len = islist(S.items) ? S.items.len : -1
	ratworld_dbg(user, "DEBUG: withdraw removed_count=[skip_count] len: [old_len] -> [new_len] exists_after=[(uid_key in S.items)]")
	S.Save()
	// SFX
	ratworld_play_stash_sfx(user, I, "withdraw")
	// Report final placement
	if(I.loc == L)
		ratworld_dbg(user, "DEBUG: withdraw placed in hands. final_loc=(mob)")
	if(I.loc != L)
		ratworld_dbg(user, "DEBUG: withdraw placed on turf at ([I.x],[I.y],[I.z]).")
	// Already placed and saved; finish
	ratworld_dbg(user, "DEBUG: withdraw end; record removed and item placed/ref at ([I.x],[I.y],[I.z]).")
	// Persisted above; nothing further needed
	to_chat(user, span_notice("I withdraw an item from my vault."))
	return TRUE

/// Spawn an item from a stash record with robust detection and fallbacks
/// Minimal, predictable spawner: create without loc, then forceMove to user's turf
/proc/ratworld_spawn_item_from_record(mob/living/user, list/rec)
	if(!user) return null
	if(!islist(rec)) return null
	var/turf/loc_turf = get_turf(user)
	if(!loc_turf)
		var/cx = round(world.maxx/2)
		var/cy = round(world.maxy/2)
		loc_turf = locate(max(1,cx), max(1,cy), 1)
	var/raw_path = rec["typepath"]
	if(!istext(raw_path)) raw_path = rec["path"]
	var/text_path = istext(raw_path) ? "[raw_path]" : null
	var/type_path = text2path(text_path)
	if(!type_path) return null
	// Spawn detached, then forceMove to the user's turf to avoid nullspace/inventory anomalies
	var/atom/movable/A = new type_path()
	if(A)
		if(!isturf(A.loc) || A.loc != loc_turf)
			A.forceMove(loc_turf)
		ratworld_dbg(user, "DEBUG: spawn(forceMove->turf): ref=[A] type=[A.type] loc=([A.x],[A.y],[A.z]).")
		// If this is an item, restore its ratworld rarity/enchant fields and apply effects
		if(istype(A, /obj/item))
			var/obj/item/I = A
			if(isnum(rec["rarity"]))
				I.vars["rw_rarity"] = rec["rarity"]
			var/list/ench_ids = rec["ench"]
			if(islist(ench_ids) && ench_ids.len)
				I.vars["rw_enchants"] = list()
				for(var/id in ench_ids)
					if(istext(id)) I.vars["rw_enchants"] += id
			var/list/ench_vals = rec["ench_vals"]
			if(islist(ench_vals) && ench_vals.len)
				I.vars["rw_enchant_vals"] = list()
				for(var/k in ench_vals)
					if(istext(k) && isnum(ench_vals[k])) I.vars["rw_enchant_vals"][k] = ench_vals[k]
			// Apply any enchant hooks after restoring ids/vals
			ratworld_apply_enchantments(I)
			// Restore safe cosmetic vars from record if present
			var/list/dv = rec["vars"]
			if(islist(dv))
				if(istext(dv["name"])) I.name = dv["name"]
				if(istext(dv["desc"])) I.desc = dv["desc"]
				if(istext(dv["color"])) I.color = dv["color"]
				if("mob_overlay_icon" in I.vars)
					var/mo_in2 = dv["mob_overlay_icon"]
					if(istext(mo_in2)) I.vars["mob_overlay_icon"] = mo_in2
				if("item_state" in I.vars)
					var/its_in2 = dv["item_state"]
					if(istext(its_in2)) I.vars["item_state"] = its_in2
		return A
	return null

/// Move an item within the grid
/proc/ratworld_move_item(mob/living/user, uid, new_x, new_y)
	if(!user?.client?.ckey) return FALSE
	var/datum/ratworld/stash/S = ratworld_get_stash(user.client.ckey)
	var/uid_key = "[uid]"
	if(istext(uid) && (uid in S.items))
		uid_key = uid
	if(!(uid_key in S.items)) return FALSE
	var/list/R = S.items[uid_key]
	var/w = R["w"] || 1
	var/h = R["h"] || 1
	if(S.rect_collides(new_x, new_y, w, h, uid))
		to_chat(user, span_warning("That spot is occupied."))
		ratworld_play_stash_error(user)
		return FALSE
	R["x"] = new_x
	R["y"] = new_y
	S.Save()
	// SFX: create a temporary instance based on record path for proper category sound
	var/obj/item/tmpI = null
	var/tp = null
	if(istext(R["typepath"]))
		tp = text2path(R["typepath"]) 
	else if(istext(R["path"]))
		tp = text2path(R["path"]) 
	if(ispath(tp))
		tmpI = new tp()
	ratworld_play_stash_sfx(user, tmpI, "move")
	if(tmpI) qdel(tmpI)
	return TRUE

/proc/ratworld_deposit_mammon(mob/living/user, amount)
	amount = round(max(0, amount))
	if(!amount) return FALSE
	if(!user?.client?.ckey) return FALSE
	// Disallow depositing mammon into the vault; instruct to use nervelock
	to_chat(user, span_warning("You can't deposit mammon here. Use your nervelock to manage coin."))
	ratworld_play_stash_error(user)
	return FALSE

/proc/ratworld_withdraw_mammon(mob/living/user, amount)
	amount = round(max(0, amount))
	if(!amount) return FALSE
	if(!user?.client?.ckey) return FALSE
	// Disallow withdrawing mammon from the vault; use nervelock instead
	to_chat(user, span_warning("Coins aren't stored in the reliquary. Use your nervelock to withdraw mammon."))
	ratworld_play_stash_error(user)
	return FALSE

// Quick verbs for testing; later replaced with a TGUI bank console
// (Removed) Ratworld test verbs that added UI clutter in the verbs panel

// Unified item sizing (Tetris footprint) -------------------------------------------------
// If items define stash_w / stash_h vars those take priority.
// Otherwise we use path heuristics. All results clamped to sensible range (1..5 each).

/proc/ratworld_compute_item_size(obj/item/I)
	var/w = 1
	var/h = 1
	if(!I)
		return list(w, h)
	// Explicit overrides on prototype (only if valid >= 1); otherwise use classifier
	var/has_w = FALSE
	var/has_h = FALSE
	if(("stash_w" in I.vars) && isnum(I.vars["stash_w"]) && (I.vars["stash_w"] >= 1))
		has_w = TRUE
	if(("stash_h" in I.vars) && isnum(I.vars["stash_h"]) && (I.vars["stash_h"] >= 1))
		has_h = TRUE
	if(has_w)
		w = clamp(I.vars["stash_w"], 1, 5)
	if(has_h)
		h = clamp(I.vars["stash_h"], 1, 5)
	if(!(has_w && has_h))
		var/list/C = ratworld_classify_item_for_stash(I)
		if(islist(C))
			w = C["w"]
			h = C["h"]
	// Final clamp
	w = clamp(w, 1, 5)
	h = clamp(h, 1, 5)
	return list(w, h)

// Vault UID generation ---------------------------------------------------------------
// Format: <PREFIX><number> where PREFIX in {D,A,S,U}
// D = dropped (mob loot), A = admin spawned, S = spawn loadout, U = unknown/default
// Number portion is a random 6 digit (zero padded) plus a short incremental fallback if collision.

/proc/ratworld_depositor_prefix(mob/living/user, obj/item/I)
	// Determine prefix using item provenance, independent of depositor's admin status
	if(I && ("flags_1" in I.vars))
		var/fl = I.vars["flags_1"]
		if(isnum(fl) && (fl & ADMIN_SPAWNED_1))
			return "A"
	if(I && ("vault_origin" in I.vars))
		var/vo = I.vars["vault_origin"]
		if(istext(vo) && vo == "A")
			return "A"
	return "D"

/proc/ratworld_assign_vault_uid(mob/living/user, obj/item/I)
	if(!I) return
	var/current = null
	if("vault_uid" in I.vars)
		if(istext(I.vars["vault_uid"])) current = I.vars["vault_uid"]
	// Choose prefix based on item provenance, not depositor admin status
	var/pfx = ratworld_depositor_prefix(user, I)
	if(!istext(current) || !length(current))
		// Fresh assignment with prefix
		var/num = rand(1, 999999)
		I.vault_uid = "[pfx][num]"
		to_chat(user, span_notice("DEBUG: vault_uid assign fresh prefix=[pfx] uid=[I.vault_uid]."))
		return
	// Existing vault_uid present; evaluate first character
	var/first = copytext(current, 1, 2)
	var/list/okp = list("A","D","S","U")
	// Unknown prefix upgrade path
	if(first == "U")
		I.vault_uid = "[pfx][copytext(current, 2)]"
		to_chat(user, span_notice("DEBUG: vault_uid upgrade from U => [I.vault_uid] (new pfx=[pfx])."))
		return
	// Invalid prefix repair path (prefix not in allowed list)
	if(!okp.Find(first))
		I.vault_uid = "[pfx][current]"
		to_chat(user, span_warning("DEBUG: vault_uid repair invalid first='[first]' => [I.vault_uid] (pfx=[pfx])."))
		return
	// Prefix mismatch (e.g., item created without proper context); prefer item provenance classification
	if(pfx != first)
		I.vault_uid = "[pfx][copytext(current, 2)]"
		to_chat(user, span_notice("DEBUG: vault_uid prefix override [first] -> [pfx] now=[I.vault_uid]."))
		return
	// Stable prefix; retain
	to_chat(user, span_notice("DEBUG: vault_uid retained=[current] (pfx=[pfx])."))
	return

/proc/ratworld_classify_item_origin(mob/living/user, obj/item/I)
	// Stable origin classifier with caching to prevent prefix flip-flops.
	if(!I)
		return "U"
	// If we previously resolved a non-unknown origin, keep it stable
	if("vault_origin" in I.vars)
		var/existing = I.vars["vault_origin"]
		if(istext(existing))
			if(existing == "A" || existing == "D" || existing == "S")
				return existing
			// If it was "U" we will attempt re-evaluation below (allows upgrade from Unknown)
	if("ratworld_origin" in I.vars)
		var/tag_raw = I.vars["ratworld_origin"]
		if(istext(tag_raw))
			var/tag = uppertext(tag_raw)
			if(tag == "A" || tag == "D" || tag == "S")
				I.vars["vault_origin"] = tag
				return tag
	if("flags_1" in I.vars)
		var/fl = I.vars["flags_1"]
		if(isnum(fl))
			if(fl & ADMIN_SPAWNED_1)
				I.vars["vault_origin"] = "A"
				return "A"
	if("starting_equipment" in I.vars)
		if(I.vars["starting_equipment"])
			I.vars["vault_origin"] = "S"
			return "S"
	// If still unknown, treat admins depositing as admin-origin
	if(user && user.client && user.client.holder)
		I.vars["vault_origin"] = "A"
		return "A"
	// World drop / picked up loot heuristic: item currently on turf OR last_holder previously not the current user
	if("last_holder" in I.vars)
		var/lh = I.vars["last_holder"]
		if(lh && lh != user)
			I.vars["vault_origin"] = "D"
			return "D"
	if(isturf(I.loc))
		// Item sitting in world without prior classification counts as dropped
		I.vars["vault_origin"] = "D"
		return "D"
	// Default fallback: prefer 'D' over 'U' to avoid unknowns in UI
	I.vars["vault_origin"] = "D"
	return "D"

/proc/ratworld_generate_vault_uid(mob/living/user, obj/item/I)
	var/prefix = ratworld_classify_item_origin(user, I)
	var/num = rand(1, 999999)
	return "[prefix][num]"

// Reliquary structure that opens TGUI and accepts deposits by using items on it
// NOTE: icon placeholder uses a generic structure sprite to avoid missing file
/obj/structure/ratworld_reliquary
	name = "Reliquary of Gold"
	desc = "A sacred vault where wealth and relics are safeguarded."
	density = TRUE
	anchored = TRUE

/obj/structure/ratworld_reliquary/attack_hand(mob/living/user)
	if(!user?.client)
		return ..()
	// Open TGUI panel (proc defined in tgui_stash.dm) - do not call parent until after opening
	src.open_ui(user)
	return ..()

/obj/structure/ratworld_reliquary/attackby(obj/item/W, mob/living/user, params)
	if(!user?.client)
		return ..()
	// Attempt direct deposit if viable
	if(istype(W,/obj/item))
		if(ratworld_deposit_item(user, W))
			return TRUE
	return ..()

// -----------------------------------------------------------------------------
// Ratworld verbs for debugging and utilities

/client/verb/ratworld_toggle_stash_debug()
	set name = "Toggle Stash Debug"
	set category = "Ratworld"
	if(!usr || !usr.client)
		return
	var/enabled = !ratworld_is_debug(usr)
	ratworld_set_debug(usr, enabled)
	if(enabled)
		to_chat(usr, span_notice("Ratworld stash debug: ON"))
	else
		to_chat(usr, span_notice("Ratworld stash debug: OFF"))
