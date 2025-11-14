// Ratworld admin item creation TGUI

/datum/ui_state/rw_admin_holder
/datum/ui_state/rw_admin_holder/can_use_topic(src_object, mob/user)
    if(user?.client?.holder)
        return UI_INTERACTIVE
    return UI_CLOSE

GLOBAL_DATUM_INIT(rw_admin_holder_state, /datum/ui_state/rw_admin_holder, new)

/datum/ratworld/item_creation_session
    var/mob/living/user
    var/search = ""
    var/list/search_results = list() // list of maps {path, name, icon, icon_state}
    var/show_search = FALSE
    var/selected_path = null
    var/selected_icon = null
    var/selected_icon_state = null
    var/selected_name = null
    var/slot_key = RW_SLOT_1H
    var/rarity = RW_RARITY_COMMON
    var/attr_slots = 0
    var/list/ench_ids = list() // length = attr_slots, id strings (or null)
    var/list/ench_vals = list() // id->number
    var/custom_name = ""
    var/custom_desc = ""
    var/custom_color = "" // hex
    var/undiscovered = FALSE // if TRUE, skip setting enchants now; roll on discovery

/datum/ratworld/item_creation_session/New(mob/living/U)
    ..()
    user = U
    rarity = RW_RARITY_COMMON
    attr_slots = get_ratworld_rarity_slot_count(rarity)
    ench_ids = list()
    return

// Admin-only UI state
/datum/ratworld/item_creation_session/ui_state(mob/user)
    // Allow any admin role (any holder), not just specific flags
    return GLOB.rw_admin_holder_state

/datum/ratworld/item_creation_session/ui_interact(mob/user, datum/tgui/ui)
    ui = SStgui.try_update_ui(user, src, ui)
    if(!ui)
        ui = new(user, src, "RatworldItemCreation", "Ratworld: Item Creation")
        ui.open()

// Build a light-weight record for a type
/proc/_rw_type_preview(path_text)
    var/list/L = list("path" = path_text)
    var/T = text2path(path_text)
    if(ispath(T))
        var/name_val = initial(T:name)
        if(istext(name_val)) L["name"] = name_val
    // Prefer the type's own icon/state for better uniqueness
    var/final_icon_res = null
    var/final_state = null
    if(ispath(T))
        var/orig_icon = initial(T:icon)
        var/orig_state = initial(T:icon_state)
        if(orig_icon)
            var/list/orig_avail = icon_states(orig_icon)
            if(islist(orig_avail) && orig_avail.len)
                if(istext(orig_state) && (orig_state in orig_avail))
                    final_icon_res = orig_icon
                    final_state = orig_state
    // If original icon/state not usable, use stash classifier sheet with token scoring
    if(!final_icon_res)
        var/list/C = ratworld_classify_item_for_stash(path_text)
        if(islist(C) && C["icon"]) final_icon_res = C["icon"]
    if(!final_icon_res && ispath(T))
        var/icon_val = initial(T:icon)
        if(icon_val) final_icon_res = icon_val
    if(!final_icon_res)
        final_icon_res = 'icons/roguetown/items/produce.dmi'
    // Determine candidate states
    if(!final_state)
        var/item_state = null
        var/default_icon_state = null
        if(ispath(T))
            item_state = initial(T:item_state)
            default_icon_state = initial(T:icon_state)
        var/list/avail = icon_states(final_icon_res)
        if(islist(avail) && avail.len)
            // 1) direct candidates that exist on this sheet
            for(var/cand in list(item_state, default_icon_state))
                if(istext(cand) && (cand in avail))
                    final_state = cand
                    break
            // 2) tokenize type path and score
            if(!final_state)
                var/list/tokens = list()
                var/tok = ""
                var/lt = lowertext("[path_text]")
                for(var/i = 1; i <= length(lt); i++)
                    var/ch = copytext(lt, i, i+1)
                    if((ch >= "a" && ch <= "z") || (ch >= "0" && ch <= "9")) tok += ch
                    else if(length(tok)) { if(!(tok in tokens)) tokens += tok; tok = "" }
                if(length(tok)) if(!(tok in tokens)) tokens += tok
                // Also include display name tokens to improve matching (e.g., "Terminus Est")
                var/name_tok = ""
                var/name_text = null
                if(ispath(T))
                    var/nv = initial(T:name)
                    if(istext(nv)) name_text = lowertext("[nv]")
                if(istext(name_text))
                    for(var/i2 = 1; i2 <= length(name_text); i2++)
                        var/ch2 = copytext(name_text, i2, i2+1)
                        if((ch2 >= "a" && ch2 <= "z") || (ch2 >= "0" && ch2 <= "9")) name_tok += ch2
                        else if(length(name_tok)) { if(!(name_tok in tokens)) tokens += name_tok; name_tok = "" }
                    if(length(name_tok)) if(!(name_tok in tokens)) tokens += name_tok
                var/leaf = null
                var/last_slash = findlasttext(path_text, "/")
                if(last_slash) leaf = lowertext(copytext(path_text, last_slash+1))
                var/list/combos = list()
                for(var/a in tokens)
                    for(var/b in tokens)
                        if(a == b) continue
                        var/ab = "[a][b]"
                        if(!(ab in combos)) combos += ab
                var/best = null
                var/best_score = -1
                for(var/s in avail)
                    if(!istext(s)) continue
                    var/ls = lowertext("[s]")
                    var/score = 0
                    // exact whole-name bias (condensed)
                    if(istext(name_text))
                        var/name_condensed = replacetext(name_text, " ", "")
                        if(ls == name_condensed) score += 10
                    for(var/tk in tokens)
                        var/ltk = lowertext("[tk]")
                        if(ls == ltk) score += 5
                        else if(findtext(ls, ltk) || findtext(ltk, ls)) score += 2
                    for(var/cb in combos)
                        var/lcb = lowertext("[cb]")
                        if(ls == lcb) score += 3
                    if(istext(leaf))
                        if(ls == leaf) score += 8
                        else if(findtext(ls, leaf) || findtext(leaf, ls)) score += 3
                    if(score > best_score)
                        best_score = score
                        best = s
                if(best && best_score > 0) final_state = best
            // 3) safe fallback
            if(!final_state)
                if("default" in avail) final_state = "default"
                else final_state = avail[1]
        else
            final_state = "default"
    // Tiny-state heuristic
    if(final_state == "lbracers") final_state = "bracers"
    if(final_icon_res) L["icon"] = "[final_icon_res]"
    L["icon_state"] = final_state
    return L

// Search types matching text
/proc/_rw_search_types(query)
    var/list/out = list()
    if(!istext(query) || length(query) < 2) return out
    var/lq = lowertext(query)
    for(var/T in typesof(/obj/item))
        if(T == /obj/item) continue
        var/path_text = "[T]"
        var/lp = lowertext(path_text)
        var/match = findtext(lp, lq)
        if(!match)
            // Check display name via initial(), no instantiation
            var/disp = initial(T:name)
            if(istext(disp))
                var/ln = lowertext("[disp]")
                if(findtext(ln, lq)) match = TRUE
        if(match)
            out += list(_rw_type_preview(path_text))
            if(out.len >= 50) break
    return out

/datum/ratworld/item_creation_session/proc/recalc_slots()
    attr_slots = get_ratworld_rarity_slot_count(rarity)
    // maintain selected entries length
    while(ench_ids.len < attr_slots) ench_ids += null
    while(ench_ids.len > attr_slots) ench_ids.Cut(ench_ids.len, 0)

/datum/ratworld/item_creation_session/ui_data(mob/user)
    var/list/data = list()
    data["search"] = search
    data["results"] = search_results
    data["show_search"] = show_search
    var/list/sel = list("path" = selected_path, "icon" = selected_icon, "icon_state" = selected_icon_state, "name" = selected_name)
    // Always recompute preview from the selected type to guarantee a valid icon/state
    if(istext(selected_path))
        var/list/prev = _rw_type_preview(selected_path)
        if(istext(prev["icon"])) sel["icon"] = prev["icon"]
        if(istext(prev["icon_state"])) sel["icon_state"] = prev["icon_state"]
        if(istext(prev["name"])) sel["name"] = prev["name"]
    else
        if(!istext(sel["icon"]) || !istext(sel["icon_state"]))
            var/defT = /obj/item/roguegem/diamond
            var/def_icon = initial(defT:icon)
            var/def_state = initial(defT:icon_state)
            var/list/avail = icon_states(def_icon)
            if(!istext(def_state) || !(def_state in avail))
                def_state = (islist(avail) && avail.len) ? ( ("default" in avail) ? "default" : avail[1] ) : "default"
            sel["icon"] = "[def_icon]"
            sel["icon_state"] = def_state
            if(!istext(sel["name"])) sel["name"] = "Select an item"
    data["selected"] = sel
    // Rarity options
    var/list/rarities = list()
    for(var/r in list(RW_RARITY_COMMON, RW_RARITY_MAGIC, RW_RARITY_RARE, RW_RARITY_EPIC, RW_RARITY_LEGENDARY, RW_RARITY_UNIQUE, RW_RARITY_ARTIFACT, RW_RARITY_ASCENDANT))
        var/list/entry = list(
            id = r,
            name = get_ratworld_rarity_name(r),
            color = get_ratworld_rarity_color(r),
            slots = get_ratworld_rarity_slot_count(r),
            special = ratworld_rarity_has_special(r),
            ascendant = (r == RW_RARITY_ASCENDANT)
        )
        rarities += list(entry)
    data["rarities"] = rarities
    data["rarity"] = rarity
    data["attr_slots"] = attr_slots
    data["undiscovered"] = undiscovered
    // Slot keys list
    data["slot_key"] = slot_key
    data["slot_keys"] = list(RW_SLOT_1H, RW_SLOT_1H_SHIELD, RW_SLOT_2H_PHYS, RW_SLOT_2H_MAGICAL, RW_SLOT_CHEST, RW_SLOT_LEGS, RW_SLOT_FOOT, RW_SLOT_HEAD, RW_SLOT_HANDS, RW_SLOT_CLOAK, RW_SLOT_NECKLACE, RW_SLOT_RING, RW_SLOT_ARMS, RW_SLOT_MASK, RW_SLOT_SHIRT)
    // Eligible enchants for current slot
    var/list/opts = list()
    for(var/id in ratworld_list_enchants_for_slot(slot_key))
        var/list/def = ratworld_get_enchant_def(id)
        var/list/rng = ratworld_get_enchant_slot_range(id, slot_key)
        opts += list(list(id = id, name = def?["name"], min = rng?["min"], max = rng?["max"], percent = rng?["percent"]))
    data["enchant_options"] = opts
    // Current selections
    data["ench_ids"] = ench_ids
    var/list/show_vals = list()
    for(var/i = 1; i <= ench_ids.len; i++)
        var/id = ench_ids[i]
        var/val = (istext(id) && ench_vals && isnum(ench_vals[id])) ? ench_vals[id] : null
        show_vals += val
    data["ench_vals"] = show_vals
    // Custom fields
    data["name"] = custom_name
    data["desc"] = custom_desc
    data["color"] = custom_color
    return data

/datum/ratworld/item_creation_session/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
    if(..()) return TRUE
    switch(action)
        if("toggle_search")
            show_search = !show_search
            return TRUE
        if("search")
            search = params["q"]
            search_results = _rw_search_types(search)
            return TRUE
        if("select_type")
            var/path = params["path"]
            selected_path = istext(path) ? path : null
            if(selected_path)
                var/list/prev = _rw_type_preview(selected_path)
                selected_icon = prev["icon"]
                selected_icon_state = prev["icon_state"]
                selected_name = prev["name"]
                slot_key = ratworld_slot_key_for_path(selected_path)
                // Clear search and results to return to main customize view
                search = ""
                search_results = list()
                show_search = FALSE
            return TRUE
        if("set_rarity")
            var/r = text2num(params["rarity"]) 
            if(isnum(r) && r >= RW_RARITY_COMMON && r <= RW_RARITY_ASCENDANT)
                rarity = r
                recalc_slots()
            return TRUE
        if("set_slot_key")
            var/sk = params["slot_key"]
            if(istext(sk)) slot_key = sk
            return TRUE
        if("set_ench")
            var/index = clamp(text2num(params["index"]), 1, 6)
            var/id = params["id"]
            if(index && istext(id))
                while(ench_ids.len < index) ench_ids += null
                ench_ids[index] = id
                // Initialize a default value for this enchant using slot min to avoid blocking Create
                var/list/rng2 = ratworld_get_enchant_slot_range(id, slot_key)
                if(islist(rng2))
                    var/minv2 = rng2["min"]
                    if(isnum(minv2))
                        if(!islist(ench_vals)) ench_vals = list()
                        ench_vals[id] = minv2
            return TRUE
        if("set_ench_val")
            var/id2 = params["id"]
            var/val = text2num(params["val"]) 
            if(istext(id2) && isnum(val))
                if(!islist(ench_vals)) ench_vals = list()
                ench_vals[id2] = val
            return TRUE
        if("set_name")
            custom_name = copytext_char("[params["name"]]", 1, 128)
            return TRUE
        if("set_desc")
            custom_desc = copytext_char("[params["desc"]]", 1, 2048)
            return TRUE
        if("set_color")
            custom_color = copytext_char("[params["color"]]", 1, 16)
            return TRUE
        if("toggle_undiscovered")
            undiscovered = !undiscovered
            return TRUE
        if("create")
            // Allow any admin holder, consistent with UI gating
            if(!(user?.client?.holder))
                to_chat(user, span_warning("You lack permission to create items."))
                return TRUE
            if(!istext(selected_path))
                to_chat(user, span_warning("Pick an item type first."))
                return TRUE
            var/T3 = text2path(selected_path)
            if(!ispath(T3))
                to_chat(user, span_warning("Invalid item type."))
                return TRUE
            to_chat(user, span_notice("Creating [selected_path] at rarity [rarity]."))
            var/slots_needed = get_ratworld_rarity_slot_count(rarity)
            // Validate enchants & values
            var/list/final_ids = list()
            var/list/final_vals = list()
            for(var/i = 1; i <= slots_needed; i++)
                var/eid = ench_ids.len >= i ? ench_ids[i] : null
                if(!istext(eid)) continue
                var/list/rng = ratworld_get_enchant_slot_range(eid, slot_key)
                if(!islist(rng)) continue
                var/minv = rng["min"]
                var/maxv = rng["max"]
                var/val = ench_vals && isnum(ench_vals[eid]) ? ench_vals[eid] : null
                if(isnull(val))
                    to_chat(user, span_warning("Missing value for [eid]."))
                    return TRUE
                if(val < minv || val > maxv)
                    to_chat(user, span_warning("[eid] value [val] outside [minv]-[maxv]."))
                    return TRUE
                final_ids += eid
                final_vals[eid] = val
            // Spawn item
            var/mob/living/L = user
            var/turf/Tloc = get_turf(L)
            if(!Tloc)
                var/cx = round(world.maxx/2)
                var/cy = round(world.maxy/2)
                Tloc = locate(max(1,cx), max(1,cy), 1)
            var/obj/item/I = new T3(Tloc)
            if(custom_name && length(custom_name)) I.name = custom_name
            if(custom_desc && length(custom_desc)) I.desc = custom_desc
            if(custom_color && length(custom_color)) I.color = custom_color
            // Mark as admin spawned so downstream systems (vault origin, logs) classify correctly
            if("flags_1" in I.vars)
                I.flags_1 |= ADMIN_SPAWNED_1
            I.vars["rw_rarity"] = rarity
            // Ensure socketable for magic+ gear
            ratworld_ensure_socketable(I)
            // Semi-rare +STAT bonus
            ratworld_maybe_roll_item_stat_bonus(I)
            if(undiscovered)
                // Flag for identification gameplay: hide/unused enchants until discovered; roll later
                I.vars["rw_discovered"] = FALSE
                I.vars["rw_roll_on_discover"] = TRUE
                I.vars["rw_enchants"] = null
                I.vars["rw_enchant_vals"] = null
            else
                I.vars["rw_enchants"] = final_ids.Copy()
                I.vars["rw_enchant_vals"] = final_vals.Copy()
                ratworld_apply_enchantments(I)
            // Ensure examine name-line shows correct rarity color even for items without enchants
            I.AddComponent(/datum/component/ratworld_rarity_namecolor)
            // Try to give to hand
            if(L && I)
                var/hand_ok = FALSE
                // Ensure item is at a turf first
                if(!isturf(I.loc)) I.forceMove(Tloc)
                // put_in_hands(self, del_on_fail=FALSE, merge_stacks=TRUE, forced=TRUE)
                hand_ok = L.put_in_hands(I, FALSE, TRUE, TRUE)
                if(!hand_ok)
                    if(!L.get_active_held_item())
                        hand_ok = L.put_in_active_hand(I, TRUE)
                    if(!hand_ok && !L.get_inactive_held_item())
                        hand_ok = L.put_in_inactive_hand(I, TRUE)
                // Immediately apply wearer-side effects so bonuses are visible right away
                if(hand_ok)
                    ratworld_apply_wearer_effects(I, L)
                if(hand_ok)
                    to_chat(user, span_notice("Created [I] in your hands."))
                else
                    to_chat(user, span_notice("Created [I] at your feet."))
            return TRUE
    return FALSE

// Admin verb to open the UI
/client/verb/ratworld_item_creation()
    set name = "Item Creation"
    set category = "Ratworld"
    if(!(usr?.client?.holder))
        to_chat(usr, span_warning("You lack permission to open the Item Creation UI."))
        return
    var/mob/living/M = usr
    if(!M) return
    var/datum/ratworld/item_creation_session/S = new(M)
    S.ui_interact(M)
