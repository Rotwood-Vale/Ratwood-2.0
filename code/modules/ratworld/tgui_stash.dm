// Ratworld stash TGUI session datum & structure integration

/datum/ratworld/stash_session
    var/mob/living/user
    var/datum/ratworld/stash/stash
    var/last_refresh = 0

<<<<<<< Updated upstream
/// Try to choose the correct inventory icon sheet based on the item's type path
/datum/ratworld/stash_session/proc/inventory_sheet_for_path(path_text)
    if(!istext(path_text))
        return null
    var/lp = lowertext(path_text)
    // Clothing categories
    if(findtext(lp, "/clothing/wrists/"))
        return 'icons/roguetown/clothing/wrists.dmi'
    if(findtext(lp, "/clothing/head/"))
        return 'icons/roguetown/clothing/head.dmi'
    if(findtext(lp, "/clothing/shirts") || findtext(lp, "/clothing/shirt/"))
        return 'icons/roguetown/clothing/shirts.dmi'
    if(findtext(lp, "/clothing/pants/"))
        return 'icons/roguetown/clothing/pants.dmi'
    if(findtext(lp, "/clothing/gloves/"))
        return 'icons/roguetown/clothing/gloves.dmi'
    if(findtext(lp, "/clothing/masks/"))
        return 'icons/roguetown/clothing/masks.dmi'
    if(findtext(lp, "/clothing/neck/"))
        return 'icons/roguetown/clothing/neck.dmi'
    if(findtext(lp, "/clothing/feet/"))
        return 'icons/roguetown/clothing/feet.dmi'
    if(findtext(lp, "/clothing/belts/"))
        return 'icons/roguetown/clothing/belts.dmi'
    if(findtext(lp, "/clothing/cloaks/"))
        return 'icons/roguetown/clothing/cloaks.dmi'
    if(findtext(lp, "/clothing/rings/"))
        return 'icons/roguetown/clothing/rings.dmi'
    // Default generic items sheet fallback
    // Prefer valuable.dmi for currency/treasure if path hints at coins or currency
    if(findtext(lp, "coin") || findtext(lp, "currency") || findtext(lp, "mammon") || findtext(lp, "zenny"))
        return 'icons/roguetown/items/valuable.dmi'
    return 'icons/roguetown/items/produce.dmi'

=======
>>>>>>> Stashed changes
/datum/ratworld/stash_session/proc/refresh()
    if(user?.client?.ckey)
        // Re-fetch latest persisted stash so UI reflects changes after deposits
        stash = ratworld_get_stash(user.client.ckey)

/datum/ratworld/stash_session/New(mob/living/U)
    ..()
    user = U
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
        var/item_uid = rec["uid"]
        // Fallback: if rec lacks uid (corruption), skip
        if(!item_uid)
            continue
        var/icon_file = rec["icon"]
        // Derive a sensible icon file from the item's type if not present in the record
        if(!istext(icon_file))
            var/T = text2path(rec["path"]) // dynamic type path
            if(ispath(T))
                var/atom/tmp = new T()
                if(istext(tmp.icon))
                    icon_file = tmp.icon
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
            var/Ts = text2path(rec["path"]) 
            if(ispath(Ts))
                var/obj/item/tmpi = new Ts()
                if(istext(tmpi.item_state))
                    item_state = tmpi.item_state
                qdel(tmpi)
        // Determine final icon and state preference order:
        // 1. Serialized inventory icon sheet (rec["icon"])
        // 2. Fallback instantiated type icon
        // For state: prefer explicit icon_state var; then item_state; then initial()
<<<<<<< Updated upstream
        // Prefer a deterministic inventory sheet based on type path to avoid on-mob overlays
        var/final_icon = inventory_sheet_for_path(rec["path"]) || (istext(icon_file) ? icon_file : null)
=======
        var/final_icon = istext(icon_file) ? icon_file : null
>>>>>>> Stashed changes
        var/list/vars_block = (islist(rec["vars"])) ? rec["vars"] : null
        var/final_icon_state = null
        if(vars_block)
            if(istext(vars_block["icon_state"]))
                final_icon_state = vars_block["icon_state"]
            else if(istext(vars_block["item_state"]))
                final_icon_state = vars_block["item_state"]
        if(!final_icon_state)
            var/T2 = text2path(rec["path"]) 
            if(ispath(T2))
                var/atom/tmp2 = new T2()
                if(istext(tmp2.icon_state))
                    final_icon_state = tmp2.icon_state
                qdel(tmp2)
        var/path_text = rec["path"]
<<<<<<< Updated upstream
        // Dedicated preview fields: choose the best inventory icon + state (prefer item_state, then icon_state)
        var/preview_state = item_state || final_icon_state || "default"
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
            preview_scale = 2
        // Extremely minimal textile wraps get extra boost
        if(preview_state in list("cloth", "rag", "string"))
            preview_scale = 3
=======
>>>>>>> Stashed changes
        out += list(list(
            "uid" = item_uid,
            "path" = "[path_text]",
            "icon" = final_icon,
<<<<<<< Updated upstream
            "preview_icon" = final_icon,
            "preview_state" = preview_state,
            "preview_scale" = preview_scale,
=======
>>>>>>> Stashed changes
            "mob_overlay_icon" = mob_overlay_icon,
            "item_state" = item_state,
            "name" = (vars_block && vars_block["name"]) || initial(text2path(rec["path"]).name),
            "icon_state" = final_icon_state,
            "x" = rec["x"],
            "y" = rec["y"],
            "w" = rec["w"],
            "h" = rec["h"]
        ))
    return out

/datum/ratworld/stash_session/ui_state(mob/user)
    // Allow conscious users to interact regardless of adjacency, since the host is a datum
    return GLOB.conscious_state

/datum/ratworld/stash_session/ui_interact(mob/user, datum/tgui/ui)
    ui = SStgui.try_update_ui(user, src, ui)
    if(!ui)
        ui = new(user, src, "RatworldStash", "Ratworld Reliquary")
        ui.open()

/datum/ratworld/stash_session/ui_data(mob/user)
    refresh()
    var/list/data = list()
    data["currency"] = stash.currency
    data["items"] = build_item_array()
    data["grid_w"] = stash.grid_w
    data["grid_h"] = stash.grid_h
    // simple versioning for reactive refresh
    data["rev"] = stash.items.len
    return data

/datum/ratworld/stash_session/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
    if(..()) // call parent for signals / gating
        return TRUE
    switch(action)
        if("withdraw")
            var/uid = text2num(params["uid"])
            ratworld_withdraw_item(user, uid)
            refresh()
            return TRUE
        if("deposit_hand")
            var/obj/item/I = user.get_active_held_item()
            if(I)
                to_chat(user, span_notice("Attempting hand deposit of [I]."))
                if(ratworld_deposit_item(user, I))
                    refresh()
                    return TRUE
                else
                    refresh()
                    to_chat(user, span_warning("Hand deposit failed."))
                    return TRUE
            else
                to_chat(user, span_warning("No active item in hand to deposit."))
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
            var/uid = text2num(params["uid"]) 
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
        S = new(user)
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
