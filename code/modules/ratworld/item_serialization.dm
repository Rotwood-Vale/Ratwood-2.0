// Ratworld item serialization & UID assignment
// Provides lightweight persistence for items placed into a player's stash.
// Strategy: Serialize minimal diff from initial vars + components of interest, then qdel the live item.

// Global incremental UID counter
GLOBAL_VAR_INIT(ratworld_next_item_uid, 100000) // start higher to avoid tiny early collisions

/obj/item
    var/ratworld_uid // legacy numeric id (unused for collisions; retained for debug/back-compat)
    var/ratworld_stored = FALSE // item currently removed from world and represented only by stash record
    var/vault_uid // canonical string key with origin prefix (A/D/S/U)
    // Ratworld metadata fields (declare on base item so dynamic access is always safe)
    var/rw_rarity // numeric rarity tier (see RW_RARITY_* defines)
    var/list/rw_enchants // list of enchant id strings
    var/list/rw_enchant_vals // map id -> numeric value
    var/rw_discovered = TRUE // default discovered; only special items will be undiscovered
    var/rw_roll_on_discover = FALSE // roll enchants when identified if set
    // Socket metadata for UI cues
    var/rw_socket_gem
    var/rw_socket_gem_color

/// Assigns a UID to an item if it does not have one yet
/proc/ratworld_assign_uid(obj/item/I)
    if(!I) return
    var/needs_numeric = TRUE
    if(!isnull(I.ratworld_uid) && I.ratworld_uid)
        needs_numeric = FALSE
    // Assign a deterministic non-U prefix for initial UID; deposit will refine to A/D later
    // Initial prefix: derive from item provenance (admin-spawned => A, else D)
    var/pfx_initial = "D"
    if(I && ("flags_1" in I.vars))
        var/fl = I.vars["flags_1"]
        if(isnum(fl) && (fl & ADMIN_SPAWNED_1))
            pfx_initial = "A"
    if(istext(I.vault_uid) && length(I.vault_uid))
        var/pref = copytext(I.vault_uid,1,2)
        if(pref == "U" || !(pref in list("A","D","S","U")))
            I.vault_uid = "[pfx_initial][copytext(I.vault_uid,2)]"
    else
        var/rnum = rand(1,999999)
        I.vault_uid = "[pfx_initial][rnum]"
    // Legacy numeric UID retained for debug; not used as primary key
    if(needs_numeric)
        var/base_num = GLOB.ratworld_next_item_uid
        GLOB.ratworld_next_item_uid++
        I.ratworld_uid = base_num

/// Returns TRUE if item is valid for stash (not already stored, has a loc or is held)
/proc/ratworld_can_stash(obj/item/I)
    if(!I) return FALSE
    if(I.ratworld_stored) return FALSE
    // Block obvious container/storage classes (backpacks, satchels, pouches, boxes, generic storage)
    // We don't want nested inventories inside the stash to avoid persistence complexity & duping exploits.
    if(istype(I, /obj/item/storage)) return FALSE
    // Path substring heuristics for custom modular storage types that may not inherit directly (fallback defense)
    var/lpath = lowertext("[I.type]")
    if(findtext(lpath, "/storage/") || findtext(lpath, "/backpack/") || findtext(lpath, "/satchel/") || findtext(lpath, "/pouch/") || findtext(lpath, "/quiver/") || findtext(lpath, "/scabbard/"))
        return FALSE
    // If it contains other items already (non-empty contents) treat as a container for now
    if(I.contents && I.contents.len)
        return FALSE
    return TRUE

/// Produce a serialized representation of an item suitable to store in JSON
/// Includes: path, uid, diff vars, (future: components, sockets, reagents, contents)
// Robust serialization: never returns null; always produces a minimal record
// Robust serialization: never returns null; always produces a minimal record.
// Some items may have unusual icon types (e.g., mutable appearances); we coerce them to strings safely.
/proc/ratworld_serialize_item(obj/item/I)
    // Minimal, robust variant: avoid initial() calls and complex diff logic to sidestep runtime aborts.
    if(!I)
        return list("path"="<null>", "uid"=0, "vault_uid"="U0", "icon"='icons/roguetown/clothing/wrists.dmi', "icon_state"="default")
    ratworld_assign_uid(I)
    var/typepath_text = "[I.type]"
    if(!length(typepath_text)) typepath_text = "/obj/item"
    var/list/data = list()
    data["path"] = typepath_text
    data["uid"] = I.ratworld_uid
    if(istext(I.vault_uid) && length(I.vault_uid))
        data["vault_uid"] = I.vault_uid
    if(istext(I.icon))
        data["icon"] = I.icon
    else
        data["icon"] = 'icons/roguetown/clothing/wrists.dmi'
    if(istext(I.icon_state))
        data["icon_state"] = I.icon_state
    else
        data["icon_state"] = "default"
    if(!istext(data["vault_uid"]) || !length(data["vault_uid"]))
        var/vu = I.vault_uid
        if(!istext(vu) || !length(vu))
            vu = ratworld_generate_vault_uid(null, I)
        if(isnum(vu))
            var/pfx = ratworld_classify_item_origin(null, I)
            vu = "[pfx][vu]"
        I.vault_uid = vu
        data["vault_uid"] = vu
    // Optional: rarity and enchantment ids (skeleton fields)
    if("rw_rarity" in I.vars && isnum(I.vars["rw_rarity"]))
        data["rarity"] = I.vars["rw_rarity"]
    // Identification state
    if("rw_discovered" in I.vars)
        data["undiscovered"] = !I.vars["rw_discovered"]
    if("rw_roll_on_discover" in I.vars && I.vars["rw_roll_on_discover"]) 
        data["roll_on_discover"] = TRUE
    var/list/ench_ids = I.vars?["rw_enchants"]
    if(islist(ench_ids) && ench_ids.len)
        var/list/serialized_ench = list()
        for(var/id in ench_ids)
            if(istext(id)) serialized_ench += id
        if(serialized_ench.len)
            data["ench"] = serialized_ench
    var/list/ench_vals = I.vars?["rw_enchant_vals"]
    if(islist(ench_vals) && ench_vals.len)
        var/list/vals_out = list()
        for(var/k in ench_vals)
            if(istext(k) && isnum(ench_vals[k]))
                vals_out[k] = ench_vals[k]
        if(vals_out.len)
            data["ench_vals"] = vals_out
    // Socket gem display fields
    if("rw_socket_gem" in I.vars)
        var/sg = I.vars["rw_socket_gem"]
        if(istext(sg) && length(sg)) data["socket_gem"] = sg
    if("rw_socket_gem_color" in I.vars)
        var/sgc = I.vars["rw_socket_gem_color"]
        if(istext(sgc) && length(sgc)) data["socket_gem_color"] = sgc
    // Minimal safe vars block: persist cosmetic fields and common icon hints used by UI
    var/list/vout = list()
    if(istext(I.name) && length(I.name)) vout["name"] = I.name
    if(istext(I.desc) && length(I.desc)) vout["desc"] = I.desc
    if(istext(I.color) && length(I.color)) vout["color"] = I.color
    if("mob_overlay_icon" in I.vars)
        var/mo = I.vars["mob_overlay_icon"]
        if(istext(mo) && length(mo)) vout["mob_overlay_icon"] = mo
    if("item_state" in I.vars)
        var/itst = I.vars["item_state"]
        if(istext(itst) && length(itst)) vout["item_state"] = itst
    if(vout.len)
        data["vars"] = vout
    // Failsafe: if rarity missing or too low for the number of enchants, derive from enchant count
    if(!isnum(data["rarity"]))
        if(islist(ench_ids))
            var/ech = ench_ids.len
            if(ech > 0)
                data["rarity"] = ratworld_min_rarity_for_enchants(ech)
    else
        // If rarity exists but is below the minimum implied by enchant count, bump it
        if(islist(ench_ids))
            var/ech2 = ench_ids.len
            if(ech2 > 0)
                var/minr = ratworld_min_rarity_for_enchants(ech2)
                if(data["rarity"] < minr)
                    data["rarity"] = minr
    return data

/// Reconstruct an item from serialized data and place near a mob or a target turf
/proc/ratworld_deserialize_item(list/data, atom/target)
    if(!islist(data)) return null
    // Normalize and validate path
    var/raw_path = data["path"]
    var/text_path = istext(raw_path) ? "[raw_path]" : null
    var/path = text2path(text_path)
    var/turf/loc_turf
    if(istype(target,/mob))
        var/mob/M = target
        loc_turf = get_turf(M)
    else
        loc_turf = get_turf(target)
    if(!loc_turf)
        // Fallback to a safe turf near map center if target is invalid
        var/cx = round(world.maxx/2)
        var/cy = round(world.maxy/2)
        loc_turf = locate(max(1,cx), max(1,cy), 1)
    // Snapshot items in a small radius (1) around spawn turf to detect new spawns even if they land adjacent
    var/list/pre_items = list()
    var/list/pre_set = list()
    for(var/tx in -1 to 1)
        for(var/ty in -1 to 1)
            var/turf/Tscan = locate(loc_turf.x+tx, loc_turf.y+ty, loc_turf.z)
            if(!isturf(Tscan)) continue
            for(var/obj/item/J in Tscan)
                pre_items += J
                pre_set[J] = TRUE
    var/obj/item/I = null
    if(path)
        I = new path(loc_turf)
    // If constructor returned null or item self-deleted, try to detect a freshly created item nearby
    if(!I || QDELETED(I))
        var/obj/item/new_found = null
        var/obj/item/path_matched = null
        for(var/tx2 in -1 to 1)
            for(var/ty2 in -1 to 1)
                var/turf/Tscan2 = locate(loc_turf.x+tx2, loc_turf.y+ty2, loc_turf.z)
                if(!isturf(Tscan2)) continue
                for(var/obj/item/K in Tscan2)
                    if(!(K in pre_set))
                        // Prefer exact path match if available
                        if(path && istype(K, path))
                            path_matched = K
                            break
                        if(!new_found) new_found = K
                if(path_matched) break
            if(path_matched) break
        if(path_matched)
            I = path_matched
        else if(new_found)
            I = new_found
    // If still no valid item, produce a generic placeholder so we never fail
    if(!I || QDELETED(I))
        I = new /obj/item(loc_turf)
        if(istext(data["icon"])) I.icon = data["icon"]
        if(istext(data["icon_state"])) I.icon_state = data["icon_state"]
        var/list/Vn = data["vars"]
        if(islist(Vn) && istext(Vn["name"])) I.name = Vn["name"]
    if(!I || QDELETED(I)) return null
    if(data["uid"]) I.ratworld_uid = data["uid"]
    // Preserve vault_uid on reconstructed items so re-deposits keep their prefix
    if(istext(data["vault_uid"]) && length(data["vault_uid"]))
        I.vault_uid = data["vault_uid"]
        // Optional: seed stable origin hint for classifier
        var/firstc = copytext(I.vault_uid, 1, 2)
        if(firstc == "A" || firstc == "D" || firstc == "S")
            I.vars["vault_origin"] = firstc
        // Failsafe: reflect admin-spawn flag based on A-prefix
        if(firstc == "A" && ("flags_1" in I.vars))
            I.flags_1 |= ADMIN_SPAWNED_1
    var/list/diff = data["vars"]
    if(islist(diff))
        // Apply only a safe subset explicitly to avoid read-only/type runtime errors
        if(istext(diff["name"])) I.name = diff["name"]
        if(istext(diff["desc"])) I.desc = diff["desc"]
        if(istext(diff["color"])) I.color = diff["color"]
        if("mob_overlay_icon" in I.vars)
            var/mo_in = diff["mob_overlay_icon"]
            if(istext(mo_in)) I.vars["mob_overlay_icon"] = mo_in
        if("item_state" in I.vars)
            var/its_in = diff["item_state"]
            if(istext(its_in)) I.vars["item_state"] = its_in
    // Restore rarity and enchantments if present
    // Restore identification flags first
    if(isnum(data["rarity"]))
        I.vars["rw_rarity"] = data["rarity"]
        // Ensure socketable for magic+ items restored from stash
        ratworld_ensure_socketable(I)
    if(data["undiscovered"]) I.vars["rw_discovered"] = FALSE
    else if(!("rw_discovered" in I.vars)) I.vars["rw_discovered"] = TRUE
    if(data["roll_on_discover"]) I.vars["rw_roll_on_discover"] = TRUE
    // Restore socket gem display fields
    if(istext(data["socket_gem"])) I.vars["rw_socket_gem"] = data["socket_gem"]
    if(istext(data["socket_gem_color"])) I.vars["rw_socket_gem_color"] = data["socket_gem_color"]
    var/list/ench = data["ench"]
    if(islist(ench) && ench.len)
        I.vars["rw_enchants"] = list()
        for(var/id in ench)
            if(istext(id)) I.vars["rw_enchants"] += id
        // Apply hooks so stats/effects take hold post-spawn
        ratworld_apply_enchantments(I)
    // Failsafe: derive rarity from enchant count if missing or too low
    if(!isnum(data["rarity"]))
        if(islist(ench) && ench.len)
            var/ech = ench.len
            I.vars["rw_rarity"] = ratworld_min_rarity_for_enchants(ech)
    else
        if(islist(ench) && ench.len)
            var/minr = ratworld_min_rarity_for_enchants(ench.len)
            if(I.vars?["rw_rarity"] && I.vars["rw_rarity"] < minr)
                I.vars["rw_rarity"] = minr
    var/list/vals_in = data["ench_vals"]
    if(islist(vals_in) && vals_in.len)
        I.vars["rw_enchant_vals"] = list()
        for(var/k2 in vals_in)
            if(istext(k2) && isnum(vals_in[k2])) I.vars["rw_enchant_vals"][k2] = vals_in[k2]
    return I
