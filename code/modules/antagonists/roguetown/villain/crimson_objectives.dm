// Crimson-specific objective tweaks
// - Assassination: succeeds if the target was killed at least once (permanent death not required)
// - Theft: must have the exact target item on your person at round end (no alternates)

/datum/objective/assassinate/crimson
    name = "assassinate (Crimson)"

// In Roguetown, GLOB.data_core may not be populated; override to select from active minds.
/datum/objective/assassinate/crimson/find_target(dupe_search_range, blacklist)
    var/list/datum/mind/owners = get_owners()
    if(!dupe_search_range)
        dupe_search_range = get_owners()
    var/list/possible_targets = list()
    // Prefer live, human players from the active mind list
    for(var/datum/mind/possible_target in SSticker.minds)
        if(!possible_target)
            continue
        if(possible_target in owners)
            continue
        if(!ishuman(possible_target.current))
            continue
        if(possible_target.current.stat == DEAD)
            continue
        if(blacklist && (possible_target in blacklist))
            continue
        if(!is_unique_objective(possible_target, dupe_search_range))
            continue
        possible_targets += possible_target
    if(length(possible_targets))
        target = pick(possible_targets)
    update_explanation_text()
    return target

/datum/objective/assassinate/crimson/check_completion()
    // Success if: already flagged completed, or the target is currently not considered alive,
    // or the target has been revived at least once (implies they died earlier this round).
    if(..())
        return TRUE
    if(target?.current)
        // TRAIT_IWASREVIVED is applied by all standard revival flows
        if(HAS_TRAIT(target.current, TRAIT_IWASREVIVED))
            return TRUE
    return FALSE

/datum/objective/assassinate/crimson/update_explanation_text()
    ..()
    if(target && target.current)
        explanation_text = "Ensure [target.name] the [!target_role_type ? target.assigned_role : target.special_role] is slain at least once. Permanent death is not required."


/datum/objective/steal/crimson
    name = "steal (Crimson)"

// Gather all items on a mob, traversing both traditional contents and storage-component contents.
/datum/objective/steal/crimson/proc/_collect_inventory_graph(mob/living/L)
    var/list/queue = list(L)
    var/list/seen = list()
    var/list/parents = list() // child => parent container
    var/list/objects = list()
    while(queue.len)
        var/atom/A = queue[1]
        queue.Cut(1,2)
        if(seen[A])
            continue
        seen[A] = TRUE

        // Traverse normal contents
        for(var/atom/B in A.contents)
            if(!seen[B])
                parents[B] = A
                queue += B

        // Traverse storage component contents
        if(isobj(A))
            var/obj/O = A
            var/datum/component/storage/STR = O.GetComponent(/datum/component/storage)
            if(STR)
                var/list/things = STR.contents()
                for(var/obj/item/I in things)
                    if(!seen[I])
                        parents[I] = O
                        queue += I

        if(isobj(A) && A != L)
            objects += A

    return list("objects" = objects, "parents" = parents)

/datum/objective/steal/crimson/proc/_is_inside_roguebag(atom/child, list/parents)
    var/atom/A = child
    var/safety = 0
    while(A && safety++ < 200)
        if(istype(A, /obj/item/storage/roguebag))
            return TRUE
        A = parents[A]
    return FALSE

// Collect objects on the turf beneath the mob (e.g., items dropped from hands at round end).
// Important: Do NOT traverse into mob inventories from the turf; only consider objs and their storage-component contents.
/datum/objective/steal/crimson/proc/_collect_turf_graph(mob/living/L)
    var/turf/T = get_turf(L)
    if(!T)
        return list("objects" = list(), "parents" = list())
    var/list/queue = list(T)
    var/list/seen = list()
    var/list/parents = list()
    var/list/objects = list()
    while(queue.len)
        var/atom/A = queue[1]
        queue.Cut(1,2)
        if(seen[A])
            continue
        seen[A] = TRUE

        // Traverse normal contents, but skip mobs so we don't include other players' inventories
        for(var/atom/B in A.contents)
            if(ismob(B))
                continue
            if(!seen[B])
                parents[B] = A
                queue += B

        // Traverse storage component contents
        if(isobj(A))
            var/obj/O = A
            var/datum/component/storage/STR = O.GetComponent(/datum/component/storage)
            if(STR)
                var/list/things = STR.contents()
                for(var/obj/item/I in things)
                    if(!seen[I])
                        parents[I] = O
                        queue += I

        if(isobj(A) && A != T)
            objects += A

    return list("objects" = objects, "parents" = parents)

/datum/objective/steal/crimson/check_completion()
    // Only the exact target item counts, and it must be on the owner's person at round end.
    var/list/datum/mind/owners = get_owners()
    if(!steal_target)
        return TRUE
    for(var/datum/mind/M in owners)
        if(!isliving(M.current))
            continue
        var/mob/living/L = M.current
        var/list/graph = _collect_inventory_graph(L)
        var/list/objs = graph["objects"]
        var/list/parents = graph["parents"]
        for(var/obj/I in objs)
            if(istype(I, steal_target))
                // Priestmask (Solar Visage) must be inside a sack
                if(targetinfo && istype(targetinfo, /datum/objective_item/steal/rogue/priestmask))
                    if(_is_inside_roguebag(I, parents))
                        return TRUE
                    else
                        continue
                // Others: use special completion if defined
                if(!targetinfo)
                    return TRUE
                else if(targetinfo.check_special_completion(I))
                    return TRUE
        // As a fallback for forced hand drops at round end, also accept the item if it's on the turf beneath the owner
        var/list/turf_graph = _collect_turf_graph(L)
        var/list/tobjs = turf_graph["objects"]
        var/list/tparents = turf_graph["parents"]
        for(var/obj/J in tobjs)
            if(istype(J, steal_target))
                if(targetinfo && istype(targetinfo, /datum/objective_item/steal/rogue/priestmask))
                    if(_is_inside_roguebag(J, tparents))
                        return TRUE
                    else
                        continue
                if(!targetinfo)
                    return TRUE
                else if(targetinfo.check_special_completion(J))
                    return TRUE
    return FALSE

/datum/objective/steal/crimson/update_explanation_text()
    // Clarify stricter completion text for Crimson theft
    if(targetinfo)
        explanation_text = "Steal [targetinfo.name] and keep it on your person until the end of the round. You must be alive at round end. Keeping it on the ground beneath you still counts."
        // Special hint for Solar Visage: it must be bagged in a sack
        if(istype(targetinfo, /datum/objective_item/steal/rogue/priestmask))
            explanation_text += " Bag it in a sack." // the mask only counts if placed inside a sack
    else if(steal_target)
        explanation_text = "Steal the target and keep it on your person until the end of the round. You must be alive at round end. Keeping it on the ground beneath you still counts."
    else
        explanation_text = "Free objective"

// Provide a human-readable failure reason at round end
/datum/objective/steal/crimson/proc/failure_reason()
    var/list/datum/mind/owners = get_owners()
    var/datum/mind/alive_owner = null
    for(var/datum/mind/M in owners)
        if(considered_alive(M))
            alive_owner = M
            break
    if(!alive_owner)
        return "You were dead at round end."

    if(!steal_target)
        return null

    var/mob/living/L = alive_owner.current
    var/list/graph = _collect_inventory_graph(L)
    var/list/objs = graph["objects"]
    var/list/parents = graph["parents"]
    var/found_but_failed_special = FALSE
    for(var/obj/I in objs)
        if(istype(I, steal_target))
            if(targetinfo && istype(targetinfo, /datum/objective_item/steal/rogue/priestmask))
                if(!_is_inside_roguebag(I, parents))
                    found_but_failed_special = TRUE
                else
                    return null
            else if(!targetinfo)
                return null
            else if(!targetinfo.check_special_completion(I))
                found_but_failed_special = TRUE
            else
                return null

    if(found_but_failed_special)
        if(istype(targetinfo, /datum/objective_item/steal/rogue/priestmask))
            return "The Solar Visage must be bagged in a sack."
        return "Special requirement not met."
    // Check turf beneath as a fallback
    var/list/turf_graph = _collect_turf_graph(L)
    var/list/tobjs = turf_graph["objects"]
    var/list/tparents = turf_graph["parents"]
    for(var/obj/J in tobjs)
        if(istype(J, steal_target))
            if(targetinfo && istype(targetinfo, /datum/objective_item/steal/rogue/priestmask))
                if(!_is_inside_roguebag(J, tparents))
                    return "The Solar Visage must be bagged in a sack."
                else
                    return null
            else if(!targetinfo)
                return null
            else if(!targetinfo.check_special_completion(J))
                return "Special requirement not met."
            else
                return null

