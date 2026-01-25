/datum/antagonist/khan_sahnuzal
    name = "Khan"
    var/description = "A great warlord of Gronn, a Khan of many Khanates."
    antagpanel_category = "Khan"
    show_in_antagpanel = TRUE
    rogue_enabled = TRUE
    var/hostile = TRUE
    var/spawn_weight = 1 
    var/max_simultaneous = 1
    var/active = FALSE
    var/mob = null

    proc/Initialize()
        // Called when module loads or antagonist manager registers this antagonist
        // Register any required resources here
        return

    proc/CanSpawn() // extra checks before spawning
        // e.g., check map, round stage, or config flags
        return TRUE

    proc/OnSpawn(mob/living/carbon/H)
        // Called when Khan is spawned/created in the world
        active = TRUE
        mob = H
        // Give unique equipment (create item with mob as owner/location)
        if(mob)
            new /obj/item/rogueweapon/mace/maul/grand/sahnuzal(mob)
        return

    // Attempt to set the antagonist's displayed name. Returns 1 on success, 0 on failure.
    // Enforces that only admins may use the reserved name "Sahn-Uzal".
    proc/TrySetAntagName(mob/living/carbon/H, new_name as text)
        if(!H)
            return 0
        var/clean = trim(new_name)
        if(!length(clean))
            return 0

        // reserved names (common variants)
        var/list/reserved = list("Sahn-Uzal", "sahn-uzal", "Sahnuzal", "sahnuzal", "SAHN-UZAL", "SAHNUZAL")
        for(var/word in reserved)
            if(clean == word)
                // allow if the player is an admin
                if(!(H.client && check_rights_for(H.client, R_ADMIN)))
                    to_chat(H, span_boldred("You are not worthy of such a name!"))
                    return 0

        // Apply the name
        H.name = clean

        // Play spawn music locally
        if(isturf(get_turf(H)))
            playsound(get_turf(H), "sound/shuz/antag/spawnmusic.ogg", 60, FALSE, FALSE)

        // Welcome message in bright bold red
        var/msg = "I am Khan " + clean + ", A great Warlord, Khan of the many Khanates of Gronn. I am here on holy mission. The mission to see the vale conquered, for I am conqueror of conquerors. I will not fail, for Graggar has bestowed upon me power great enough to topple even Kingsfield itself."
        to_chat(H, span_boldred(msg))
        return 1

    proc/OnDeath(mob/living/carbon/H)
        // Called on Khan death — reward players, clean up
        active = FALSE
        mob = null
        return

    proc/OnTick()
        // Periodic behaviour: can be used to run AI checks, spawn adds, etc.
        if(!active || !mob) return
        // TODO: implement behaviour
        return

    // on_gain/after_name_change are defined below via absolute-path procs

    // Spell placeholders
    proc/spell_shadow_blast(mob/target)
        // placeholder for an AOE blast
        return

    proc/spell_tendril_grasp(mob/target)
        // placeholder for a tether/pull spell
        return

    proc/spell_realm_of_doom(mob/target)
        // placeholder for ultimate that isolates target
        return

// Hook: make this antagonist discoverable by any antagonist manager in the project
// Registration is handled by the antagonist manager; avoid top-level mutations here.

/datum/antagonist/khan_sahnuzal/apply_innate_effects(mob/living/mob_override)
    . = ..()
    var/mob/living/M = mob_override || owner.current
    if(M)
        M.verbs |= /mob/living/carbon/human/verb/declare_khan_war
        var/datum/action/innate/A = M.mind.khan_declare_action
        if(!A)
            A = new /datum/action/innate()
            A.name = "Declare War"
            A.desc = "Declare war upon the Vale with a thunderous proclamation."
            A.button_icon = 'icons/mob/actions.dmi'
            A.button_icon_state = "default"
            A.icon_icon = 'icons/mob/actions.dmi'
            A.owner_has_control = TRUE
            A.Grant(M)
            M.mind.khan_declare_action = A

/datum/antagonist/khan_sahnuzal/remove_innate_effects(mob/living/mob_override)
    . = ..()
    var/mob/living/M = mob_override || owner.current
    if(M)
        M.verbs -= /mob/living/carbon/human/verb/declare_khan_war
        var/datum/action/innate/A = M.mind.khan_declare_action
        M.mind.khan_declare_action = null
        if(A)
            A.Remove(M)
            qdel(A)


/datum/antagonist/khan_sahnuzal/on_gain()
    . = ..()
    // Prompt the player to choose a name when they gain this antagonist.
    if(owner && owner.current)
        addtimer(CALLBACK(owner.current, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "[name]", 0), 5 SECONDS)
    return

/datum/antagonist/khan_sahnuzal/after_name_change()
    // Called by the global choose_name flow after the player picks a name.
    if(owner && owner.current)
        src.TrySetAntagName(owner.current, owner.current.real_name)
    return
