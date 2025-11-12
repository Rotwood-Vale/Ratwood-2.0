// Ratworld item serialization & UID assignment
// Provides lightweight persistence for items placed into a player's stash.
// Strategy: Serialize minimal diff from initial vars + components of interest, then qdel the live item.

// Global incremental UID counter
GLOBAL_VAR_INIT(ratworld_next_item_uid, 1)

/obj/item
    var/ratworld_uid // unique id assigned on first stash deposit (or explicit request)
    var/ratworld_stored = FALSE // item currently removed from world and represented only by stash record

/// Assigns a UID to an item if it does not have one yet
/proc/ratworld_assign_uid(obj/item/I)
    if(!I) return
    if(!isnull(I.ratworld_uid) && I.ratworld_uid)
        return
    I.ratworld_uid = GLOB.ratworld_next_item_uid
    GLOB.ratworld_next_item_uid++

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
/proc/ratworld_serialize_item(obj/item/I)
    if(!I) return null
    ratworld_assign_uid(I)
    var/list/data = list()
    // Store type path as string for JSON reliability
    data["path"] = "[I.type]"
    data["uid"] = I.ratworld_uid
    // Icon file (string) and icon_state (string) for UI
    // Convert icon resource to text path via string interpolation when needed
    if(istext(I.icon))
        data["icon"] = I.icon
    else
        var/icon_text = "[I.icon]"
        if(istext(icon_text) && length(icon_text))
            data["icon"] = icon_text
        else
            var/init_icon_text = "[initial(I.icon)]"
            if(istext(init_icon_text) && length(init_icon_text))
                data["icon"] = init_icon_text
    if(istext(I.icon_state))
        data["icon_state"] = I.icon_state
    else
        var/init_state = initial(I.icon_state)
        if(istext(init_state))
            data["icon_state"] = init_state
    // Override icon_state with the item's current icon_state if defined (ensures leather uses lbracers)
    if(istext(I.icon_state))
        data["icon_state"] = I.icon_state
    // If still missing, assign a generic stable sheet to avoid pink placeholder
    if(!istext(data["icon"]))
        data["icon"] = 'icons/roguetown/clothing/wrists.dmi'
    if(!istext(data["icon_state"]))
        data["icon_state"] = "default"
    var/list/diff = list()
    // Track small set of overridable vars; must compare to initial via static references
    // because BYOND initial() cannot take a dynamic var reference
    // name
    if(I.name != initial(I.name))
        diff["name"] = I.name
    // desc
    if(I.desc != initial(I.desc))
        diff["desc"] = I.desc
    // icon_state
    if(I.icon_state != initial(I.icon_state))
        diff["icon_state"] = I.icon_state
    // color
    if(I.color != initial(I.color))
        diff["color"] = I.color
    // on-mob overlay and item_state can matter for correct sprite selection in UI
    if(I.vars && ("mob_overlay_icon" in I.vars) && I.mob_overlay_icon != initial(I.mob_overlay_icon))
        diff["mob_overlay_icon"] = I.mob_overlay_icon
    if(I.vars && ("item_state" in I.vars) && I.item_state != initial(I.item_state))
        diff["item_state"] = I.item_state
    if(diff.len)
        data["vars"] = diff
    // Placeholder for future complex data (socketed gems etc.)
    // if(istype(I, /obj/item)) collect components of interest later
    return data

/// Reconstruct an item from serialized data and place near a mob or a target turf
/proc/ratworld_deserialize_item(list/data, atom/target)
    if(!islist(data)) return null
    var/path = text2path(data["path"]) // expects string
    if(!path) return null
    var/loc_turf
    if(istype(target,/mob))
        var/mob/M = target
        loc_turf = get_turf(M)
    else
        loc_turf = get_turf(target)
    var/obj/item/I = new path(loc_turf)
    if(data["uid"]) I.ratworld_uid = data["uid"]
    var/list/diff = data["vars"]
    if(islist(diff))
        for(var/k in diff)
            I.vars[k] = diff[k]
    return I
