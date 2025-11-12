// Ratworld stash TGUI session datum & structure integration

/datum/ratworld/stash_session
    var/mob/living/user
    var/datum/ratworld/stash/stash
    var/last_refresh = 0
    var/obj/structure/ratworld_reliquary/host // structure this session was opened from

/// Try to choose the correct inventory icon sheet based on the item's type path
/datum/ratworld/stash_session/proc/inventory_sheet_for_path(path_text)
    if(!istext(path_text))
        return null
    var/lp = lowertext(path_text)
    var/list/C = ratworld_classify_item_for_stash(path_text)
    if(islist(C) && istext(C["icon"]))
        return C["icon"]
    // Conservative fallback: only force currency sheet for coin-like items.
    // Otherwise return null so we use the item's original icon and avoid pink states.
    if(findtext(lp, "coin") || findtext(lp, "currency") || findtext(lp, "mammon") || findtext(lp, "zenny"))
        return 'icons/roguetown/items/valuable.dmi'
    return null


/datum/ratworld/stash_session/proc/refresh()
    if(user?.client?.ckey)
        // Re-fetch latest persisted stash so UI reflects changes after deposits
        stash = ratworld_get_stash(user.client.ckey)
        // Opportunistic migration: ensure all records have icon/state and size
        if(stash && islist(stash.items))
            var/changed = FALSE
            for(var/k in stash.items)
                var/list/R = stash.items[k]
                if(islist(R))
                    var/prev_icon = R["icon"]
                    var/prev_state = R["icon_state"]
                    var/prev_w = R["w"]
                    var/prev_h = R["h"]
                    ratworld_migrate_record(R)
                    if(R["icon"] != prev_icon || R["icon_state"] != prev_state || R["w"] != prev_w || R["h"] != prev_h)
                        changed = TRUE
            if(changed)
                stash.Save()

/datum/ratworld/stash_session/New(mob/living/U, obj/structure/ratworld_reliquary/R)
    ..()
    user = U
    host = R
    if(user?.client?.ckey)
        stash = ratworld_get_stash(user.client.ckey)

/datum/ratworld/stash_session/proc/build_item_array()
    var/list/out = list()
    if(!stash || !islist(stash.items))
        return out
    for(var/uid_key in stash.items)
        var/list/rec = stash.items[uid_key]
        if(!islist(rec))
            continue
        var/item_uid = rec["vault_uid"]
        if(!item_uid)
            item_uid = rec["uid"] // legacy fallback
        if(!item_uid)
            continue
        var/icon_file = rec["icon"]
        // Normalize type path text used throughout
        var/path_text = rec["path"]
        if(!istext(path_text) && istext(rec["typepath"]))
            path_text = rec["typepath"]
        // Derive a sensible icon file from the item's type if not present in the record
        if(!istext(icon_file))
            var/T = text2path(path_text) // dynamic type path
            if(ispath(T))
                var/atom/tmp = new T()
                if(istext("[tmp.icon]"))
                    icon_file = "[tmp.icon]"
                qdel(tmp)
        var/mob_overlay_icon = null
        var/item_state = null
        if(rec["vars"])
            var/list/V = rec["vars"]
            if(istext(V["mob_overlay_icon"]))
                mob_overlay_icon = V["mob_overlay_icon"]
            if(istext(V["item_state"]))
                item_state = V["item_state"]
        // If item_state wasn't serialized, derive it from the type default
        if(!istext(item_state))
            var/Ts = text2path(path_text) 
            if(ispath(Ts))
                var/obj/item/tmpi = new Ts()
                if(istext(tmpi.item_state))
                    item_state = tmpi.item_state
                qdel(tmpi)
        // Determine final icon via classifier; fall back to the item's own icon
        var/final_icon = inventory_sheet_for_path(path_text)
        if(!final_icon && istext(icon_file))
            final_icon = icon_file
        if(!final_icon)
            final_icon = 'icons/roguetown/items/produce.dmi'

        var/list/vars_block = (islist(rec["vars"])) ? rec["vars"] : null
        var/rec_icon_state = null
        // Prefer explicit var override first
        if(vars_block && istext(vars_block["icon_state"]))
            rec_icon_state = vars_block["icon_state"]
        // Fallback: many items serialize current icon_state at top-level even when equal to initial
        if(!istext(rec_icon_state) && istext(rec["icon_state"]))
            rec_icon_state = rec["icon_state"]
        // path_text already established above

        // Derive type default icon_state
        var/default_icon_state = null
        var/T2 = text2path(path_text) 
        if(ispath(T2))
            var/atom/tmp2 = new T2()
            if(istext(tmp2.icon_state))
                default_icon_state = tmp2.icon_state
            qdel(tmp2)
        // path_text already defined above

        // Preview fields: if using inventory sheet, prefer icon_state over item_state (to avoid pink)
        // If using original icon, prefer item_state first for accurate on-mob visuals
        var/preview_state = null
        var/using_sheet = final_icon && icon_file && final_icon != icon_file
        if(using_sheet)
            // Using inventory sheet: validate against available states, then score candidates generically
            var/list/avail = icon_states(final_icon)
            // 1) direct candidates that exist on this sheet
            for(var/cand in list(item_state, rec_icon_state, default_icon_state))
                if(istext(cand) && islist(avail) && (cand in avail))
                    preview_state = cand
                    break
            // 2) build normalized tokens from the type path
            var/list/tokens = list()
            var/tok = ""
            var/textlen = length(path_text)
            for(var/i = 1; i <= textlen; i++)
                var/ch = copytext(path_text, i, i+1)
                if((ch >= "a" && ch <= "z") || (ch >= "A" && ch <= "Z"))
                    tok += lowertext(ch)
                else
                    if(length(tok))
                        if(!(tok in tokens)) tokens += tok
                        // normalize common suffixes/prefixes
                        if(length(tok) >= 3 && copytext(tok, length(tok)-2, 0) == "run")
                            var/trim = copytext(tok, 1, length(tok)-2)
                            if(!(trim in tokens)) tokens += trim
                        if(findtext(tok, "inverse"))
                            if(!("inverse" in tokens)) tokens += "inverse"
                        tok = ""
            if(length(tok))
                if(!(tok in tokens)) tokens += tok
                if(length(tok) >= 3 && copytext(tok, length(tok)-2, 0) == "run")
                    var/trim2 = copytext(tok, 1, length(tok)-2)
                    if(!(trim2 in tokens)) tokens += trim2
                if(findtext(tok, "inverse"))
                    if(!("inverse" in tokens)) tokens += "inverse"
            // 3) synthesize token combos like leatherbracers, bracersleather, leather_bracers
            var/list/combo = list()
            for(var/a in tokens)
                for(var/b in tokens)
                    if(a == b) continue
                    var/ab = "[a][b]"
                    var/ba = "[b][a]"
                    var/a_b = "[a]_[b]"
                    var/b_a = "[b]_[a]"
                    if(!(ab in combo)) combo += ab
                    if(!(ba in combo)) combo += ba
                    if(!(a_b in combo)) combo += a_b
                    if(!(b_a in combo)) combo += b_a
            // 4) score each available state by overlap with tokens and combos
            if(!preview_state && islist(avail))
                var/best_state = null
                var/best_score = -1
                for(var/s in avail)
                    if(!istext(s)) continue
                    var/ls = lowertext("[s]")
                    var/score = 0
                    // token exact or substring
                    for(var/t in tokens)
                        var/lt = lowertext("[t]")
                        if(ls == lt) score += 5
                        else if(findtext(ls, lt) || findtext(lt, ls)) score += 2
                    // combo exact
                    for(var/c in combo)
                        var/lc = lowertext("[c]")
                        if(ls == lc) score += 4
                    // prefer longer matches slightly
                    score += min(2, round(length(ls)/8))
                    if(score > best_score)
                        best_score = score
                        best_state = s
                if(best_state && best_score > 0)
                    preview_state = best_state
            // 5) final safe fallback
            if(!preview_state)
                if(islist(avail) && ("default" in avail))
                    preview_state = "default"
                else if(islist(avail) && avail.len)
                    preview_state = avail[1]
                else
                    preview_state = "default"
        else
            // Original icon: prefer the item's icon_state first (most accurate sprite), then item_state
            // Many armor types only override icon_state (not item_state), so this prevents base-state fallback
            preview_state = rec_icon_state || item_state || default_icon_state || "default"
        // Heuristic: some states (e.g. lbracers) are microscopic; prefer a more solid fallback if available
        if(preview_state == "lbracers")
            // Try steel bracers state if exists, then iron/albracers
            preview_state = "bracers"
        // Compute a simple preview scale hint for tiny states (2 = 2x scale)
        // We can't reliably measure pixel bounds here, so use a curated list
        var/preview_scale = 1
        // Expand curated tiny states list; higher scale for ultra-small sprites
        if(preview_state in list("lbracers", "wrappings", "nocwrappings"))
            preview_scale = 2
        if(preview_state in list("bracers", "ironbracers", "albracers", "ibracers"))
            preview_scale = max(preview_scale, 2)
        // Extremely minimal textile wraps get extra boost
        if(preview_state in list("cloth", "rag", "string"))
            preview_scale = max(preview_scale, 3)
        // Coin-like items get a small boost too
        if(findtext(lowertext(path_text), "coin"))
            preview_scale = max(preview_scale, 2)

        // Determine display name
        var/name_val = null
        if(vars_block && vars_block["name"]) name_val = vars_block["name"]
        if(!name_val)
            var/Tn = text2path(path_text) 
            if(ispath(Tn))
                name_val = initial(Tn:name)

        // Rarity and enchantments (for tooltip display)
        var/rarity_val = rec["rarity"]
        var/rarity_color = isnum(rarity_val) ? get_ratworld_rarity_color(rarity_val) : null
        var/list/ench_ids = rec["ench"]
        var/list/ench_vals = rec["ench_vals"]
        var/list/ench_texts = list()
        if(islist(ench_ids) && ench_ids.len)
            // infer slot key for percent suffixes
            var/slot_key_hint = null
            var/Tsk = text2path(path_text)
            if(ispath(Tsk))
                var/obj/item/tmp_sk = new Tsk()
                slot_key_hint = ratworld_slot_key_for_item(tmp_sk)
                qdel(tmp_sk)
            for(var/eid in ench_ids)
                if(!istext(eid)) continue
                var/list/defe = ratworld_get_enchant_def(eid)
                var/ename = defe?defe["name"] : "[eid]"
                var/val = (islist(ench_vals) && isnum(ench_vals[eid])) ? ench_vals[eid] : null
                var/suf = ""
                if(istext(slot_key_hint))
                    var/list/rr = ratworld_get_enchant_slot_range(eid, slot_key_hint)
                    if(islist(rr) && rr["percent"]) suf = "%"
                if(!isnull(val))
                    var/sign = (val >= 0) ? "+" : ""
                    ench_texts += "- [ename] [sign][val][suf]"
                else
                    ench_texts += "- [ename]"

        // Use preview_state as the final icon_state sent to UI, since it already
        // accounts for whether we're using an inventory sheet or the original icon.
        var/final_icon_state = preview_state

        // Human-friendly UID for display (do not use for actions if legacy numeric)
        var/display_uid = null
        if(istext(rec["vault_uid"]))
            display_uid = rec["vault_uid"]
        else if(isnum(rec["uid"]))
            // Use D# for legacy numeric fallback; avoid showing confusing U
            display_uid = "D#[rec["uid"]]"
        else
            display_uid = "D#?"

        out += list(list(
            "uid" = "[item_uid]",
            "path" = "[path_text]",
            "icon" = final_icon,

            "preview_icon" = final_icon,
            "preview_state" = preview_state,
            "preview_scale" = preview_scale,
            "mob_overlay_icon" = mob_overlay_icon,
            "item_state" = item_state,
            "name" = name_val,
            "rarity" = rarity_val,
            "rarity_color" = rarity_color,
            "ench_texts" = ench_texts,
            "display_uid" = display_uid,
            "icon_state" = final_icon_state,
            "x" = rec["x"],
            "y" = rec["y"],
            "w" = rec["w"],
            "h" = rec["h"]
        ))
    return out

// Adjacency-gated UI state: closes when the opener is more than 1 tile away from the reliquary
GLOBAL_DATUM_INIT(rw_reliquary_adjacent_state, /datum/ui_state/rw_reliquary_adjacent_state, new)

/datum/ui_state/rw_reliquary_adjacent_state/can_use_topic(src_object, mob/user)
    // Consciousness gate first
    if(user.stat != CONSCIOUS)
        return UI_CLOSE
    // If this UI is bound to a stash_session with a host reliquary, enforce adjacency to that host
    if(istype(src_object, /datum/ratworld/stash_session))
        var/datum/ratworld/stash_session/S = src_object
        if(S?.host)
            if(get_dist(user, S.host) > 1 || user.z != S.host.z)
                return UI_CLOSE
    // Otherwise allow interaction
    return UI_INTERACTIVE

/datum/ratworld/stash_session/ui_state(mob/user)
    return GLOB.rw_reliquary_adjacent_state

/datum/ratworld/stash_session/ui_interact(mob/user, datum/tgui/ui)
    ui = SStgui.try_update_ui(user, src, ui)
    if(!ui)
        ui = new(user, src, "RatworldStash", "Ratworld Reliquary")
        ui.open()

/datum/ratworld/stash_session/ui_data(mob/user)
    refresh()
    var/list/data = list()
    // Show nervelock account balance instead of stash currency
    var/bal = 0
    if(!(user in SStreasury.bank_accounts))
        SStreasury.create_bank_account(user)
    bal = SStreasury.bank_accounts[user]
    data["currency"] = bal
    data["items"] = build_item_array()
    data["grid_w"] = stash.grid_w
    data["grid_h"] = stash.grid_h
    // Pixel size for one logical grid cell (used by UI for consistent scaling); slightly larger
    data["cell_px"] = 36
    // Expose debug state to UI for toggling
    data["debug_enabled"] = ratworld_is_debug(src.user)
    // Only admins should see the Debug toggle
    data["is_admin"] = (user?.client?.holder) ? TRUE : FALSE
    // simple versioning for reactive refresh
    data["rev"] = stash.items.len
    return data

/datum/ratworld/stash_session/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
    if(..()) // call parent for signals / gating
        return TRUE
    switch(action)
        if("withdraw")
            var/uid = params["uid"] // allow string vault_uid
            ratworld_withdraw_item(user, uid)
            refresh()
            return TRUE
        if("toggle_debug")
            var/en = !ratworld_is_debug(user)
            ratworld_set_debug(user, en)
            refresh()
            return TRUE
        if("sfx_pickup")
            // Client-side immediate pickup feedback (drag start)
            var/uid_raw = params["uid"]
            var/uid_key
            if(istext(uid_raw))
                uid_key = uid_raw
            else
                uid_key = "[text2num(uid_raw)]"
            if(uid_key)
                var/datum/ratworld/stash/S = ratworld_get_stash(user.client.ckey)
                if(uid_key in S.items)
                    // Peek item for sound category, but do not modify
                    var/list/rec = S.items[uid_key]
                    if(islist(rec))
                        var/path_text = rec["path"]
                        if(istext(path_text))
                            var/obj/item/tmp = new (text2path(path_text))
                            ratworld_play_stash_sfx(user, tmp, "pickup")
                            qdel(tmp)
            return TRUE
        if("deposit_at")
            var/new_x = text2num(params["x"]) 
            var/new_y = text2num(params["y"]) 
            var/obj/item/H = user.get_active_held_item()
            if(H && new_x && new_y)
                to_chat(user, span_notice("Attempting targeted deposit of [H] at ([new_x],[new_y])."))
                if(ratworld_deposit_item(user, H, new_x, new_y))
                    refresh()
                    return TRUE
                else
                    refresh()
                    to_chat(user, span_warning("Targeted deposit failed."))
                    return TRUE
        if("move")
            var/uid = params["uid"] 
            var/new_x = text2num(params["x"]) 
            var/new_y = text2num(params["y"]) 
            if(ratworld_move_item(user, uid, new_x, new_y))
                refresh()
                return TRUE
    return FALSE

// Open the stash UI via the standard ui_interact pattern
// Ensure a single session per user per reliquary; reuse existing to avoid double opens
/obj/structure/ratworld_reliquary/var/list/user_sessions = list()

/obj/structure/ratworld_reliquary/proc/open_ui(mob/living/user)
    if(!user?.client) return
    // Check if we already have a session open for this user
    var/datum/ratworld/stash_session/S = user_sessions[user]
    if(!S)
        S = new(user, src)
        user_sessions[user] = S
    S.ui_interact(user)

/obj/structure/ratworld_reliquary/proc/close_ui(mob/living/user)
    if(!user?.client) return
    var/datum/ratworld/stash_session/S = user_sessions[user]
    if(S)
        // Force close existing UI if any
        var/datum/tgui/ui = SStgui.get_open_ui(user, S)
        if(ui)
            ui.close()
        user_sessions -= user

// attack_hand for reliquary lives in stash.dm to avoid duplicate definitions
