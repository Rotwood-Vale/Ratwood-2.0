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
    var/khan_scaled = FALSE

// Attempt to set the antagonist's displayed name. Returns 1 on success, 0 on failure.
// Enforces that only admins may use the reserved name "Sahn-Uzal".
/datum/antagonist/khan_sahnuzal/proc/TrySetAntagName(mob/living/carbon/H, new_name as text)
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
        // Clear any pre-existing traits so the Khan has a clean traitset, just in case
        if(M.status_traits)
            for(var/trait in list(M.status_traits))
                REMOVE_TRAIT(M, trait, null)

        // Reset any existing skill data and apply Khan-specific skill ranks in case we're converting someone who was already in game.
        if(M.skills)
            M.skills.Destroy()
            M.skills = null
        M.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_LEGENDARY, TRUE)
        M.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
        M.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_NOVICE, TRUE)
        M.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
        M.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_JOURNEYMAN, TRUE)
        M.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_MASTER, TRUE)
        M.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
        ADD_TRAIT(M, TRAIT_BIGGUY, INNATE_TRAIT)
        ADD_TRAIT(M, TRAIT_STEEL_SKIN, INNATE_TRAIT)
        ADD_TRAIT(M, TRAIT_STEEL_FEET, INNATE_TRAIT)
        ADD_TRAIT(M, TRAIT_CRITICAL_RESISTANCE, INNATE_TRAIT)
        ADD_TRAIT(M, TRAIT_TRUE_CRITICAL_RESISTANCE, INNATE_TRAIT)
        ADD_TRAIT(M, TRAIT_NODISMEMBER, INNATE_TRAIT)
        ADD_TRAIT(M, TRAIT_CONQUEROR_STEPS, INNATE_TRAIT)
        ADD_TRAIT(M, TRAIT_GRABIMMUNE, INNATE_TRAIT)
        ADD_TRAIT(M, TRAIT_NOPAINSTUN, INNATE_TRAIT)
        ADD_TRAIT(M, TRAIT_TRUEUNSTOPPABLE, INNATE_TRAIT)
        ADD_TRAIT(M, TRAIT_NOPAIN, INNATE_TRAIT)
        ADD_TRAIT(M, TRAIT_KNEESTINGER_IMMUNITY, INNATE_TRAIT)
        if(M)
            // Remove any existing equipped clothing/weapons so we reliably replace with Khan kit
            // Delete everything the mob is wearing/holding (nuclear option, in case of admin fuckery, like making someone the Khan)
            for(var/obj/item/I in M.get_equipped_items(TRUE))
                if(I)
                    qdel(I)
            for(var/obj/item/I in M.held_items)
                if(I)
                    qdel(I)
            M.update_inv_hands()
            M.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/bucket/gronn(M), SLOT_HEAD, TRUE)
            var/obj/item/clothing/gloves/G = new /obj/item/clothing/gloves/roguetown/chain/gronn(M)
            if(G)
                G.color = "#FFFF00"
            M.equip_to_slot_or_del(G, SLOT_GLOVES, TRUE)
            var/obj/item/clothing/shoes/S = new /obj/item/clothing/shoes/roguetown/boots/armor/iron/gronn(M)
            if(S)
                S.color = "#FFFF00"
            M.equip_to_slot_or_del(S, SLOT_SHOES, TRUE)
            var/obj/item/clothing/under/P = new /obj/item/clothing/under/roguetown/chainlegs/kilt(M)
            if(P)
                P.color = "#FFFF00"
            M.equip_to_slot_or_del(P, SLOT_PANTS, TRUE)
            M.equip_to_slot_or_del(new /obj/item/clothing/cloak/lordcloak(M), SLOT_CLOAK, TRUE)
            M.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(M), SLOT_BACK_R, TRUE)
            M.put_in_hands(new /obj/item/rogueweapon/mace/maul/grand/sahnuzal(M), TRUE)

            // had this weird bug where things would constantly get colored. I am the dye machine!!111!
            for(var/obj/item/I in M.get_equipped_items())
                if(!I)
                    continue
                if(I.type == /obj/item/clothing/cloak/lordcloak)
                    continue
                if(I.type == /obj/item/rogueweapon/scabbard/gwstrap)
                    continue
                I.color = "#FFFF00"
            M.STASTR = 20
            M.STASPD = 3
            M.STACON = 15 + rand(1,3)
            M.STAWIL = 15 + rand(1,3)
            M.STAPER = 15 + rand(1,3)


            M.setMaxHealth(4000)
            
            
            if(iscarbon(M))
                var/mob/living/carbon/C = M
                for(var/obj/item/bodypart/BP in C.bodyparts)
                    BP.max_damage = BP.max_damage * 20
            
            M.status_flags &= ~GODMODE // Make sure Khan doesn't have GODMODE (except during death sequence)
            M.updatehealth() // Initialize health tracking

            // So, i've had a lot of issues with getting the Khan to actually die...
            // the only physical way I could actually make him die was by uncapping his limb damage, and make his hp go down via brute damage.
            // the way i figured this out was because i always used to kill people via oxy damage from the VV panel. I looked into the code and
            // brute damage is commented out from counting towards their hp. 
            // i hope the carbon changes and stuff i made aren't too intrusive but this is the only way i could figure out how to make him actually die lol.

            M.cmode_music_override_name = "Khan of Gronn"

            if(!src.khan_scaled)
                M.transform = M.transform.Scale(1.25, 1.25)
                M.transform = M.transform.Translate(0, (0.25 * 16))
                M.update_transform()
                src.khan_scaled = TRUE
        // Grant the Obliterate spell as an innate ability
        if(M.mind && !M.mind.has_spell(/obj/effect/proc_holder/spell/invoked/decimate))
            M.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/decimate)
        // Grant the Indestructible spell
        if(M.mind && !M.mind.has_spell(/obj/effect/proc_holder/spell/invoked/indestructible))
            M.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/indestructible)
        // Grant Death's Grasp spell
        if(M.mind && !M.mind.has_spell(/obj/effect/proc_holder/spell/invoked/deathsgrasp))
            M.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/deathsgrasp)
        // Grant Realm of Death spell
        if(M.mind && !M.mind.has_spell(/obj/effect/proc_holder/spell/invoked/realm_of_death))
            M.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/realm_of_death)

/datum/antagonist/khan_sahnuzal/remove_innate_effects(mob/living/mob_override)
    . = ..()
    var/mob/living/M = mob_override || owner.current
    if(M)
        M.verbs -= /mob/living/carbon/human/verb/declare_khan_war
        var/datum/action/innate/A = M.mind.khan_declare_action
        M.mind.khan_declare_action = null
        M.mind.khan_indestructible_active = null

        REMOVE_TRAIT(M, TRAIT_BIGGUY, INNATE_TRAIT)
        REMOVE_TRAIT(M, TRAIT_STEEL_SKIN, INNATE_TRAIT)
        REMOVE_TRAIT(M, TRAIT_CRITICAL_RESISTANCE, INNATE_TRAIT)
        REMOVE_TRAIT(M, TRAIT_TRUE_CRITICAL_RESISTANCE, INNATE_TRAIT)
        REMOVE_TRAIT(M, TRAIT_NODISMEMBER, INNATE_TRAIT)
        REMOVE_TRAIT(M, TRAIT_CONQUEROR_STEPS, INNATE_TRAIT)
        REMOVE_TRAIT(M, TRAIT_GRABIMMUNE, INNATE_TRAIT)
        REMOVE_TRAIT(M, TRAIT_NOPAINSTUN, INNATE_TRAIT)
        REMOVE_TRAIT(M, TRAIT_STEEL_FEET, INNATE_TRAIT)
        REMOVE_TRAIT(M, TRAIT_TRUEUNSTOPPABLE, INNATE_TRAIT)
        REMOVE_TRAIT(M, TRAIT_NOPAIN, INNATE_TRAIT)
        if(A)
            A.Remove(M)
            qdel(A)
        // Remove the granted spells if present
        if(M.mind)
            M.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/decimate)
            M.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/indestructible)
            M.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/deathsgrasp)
            M.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/realm_of_death)
            // Clean up any active chains
            if(M.mind.khan_chain_targets && length(M.mind.khan_chain_targets) > 0)
                var/obj/effect/proc_holder/spell/invoked/deathsgrasp/spell = locate() in M.mind.spell_list
                if(spell)
                    for(var/mob/living/carbon/human/victim in M.mind.khan_chain_targets)
                        spell.break_chain(M, victim, "death")
        // Revert giant transform if applied
        if(src && src.khan_scaled)
            if(M)
                M.transform = M.transform.Translate(0, -(0.25 * 16))
                M.transform = M.transform.Scale(1/1.25, 1/1.25)
                M.update_transform()
            src.khan_scaled = FALSE


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

// Custom death sequence for the Khan
/mob/living/carbon/human/proc/khan_death_sequence()
    if(!mind?.has_antag_datum(/datum/antagonist/khan_sahnuzal))
        return FALSE
    
    // Completely immobilize the Khan during the sequence
    Immobilize(10 SECONDS)
    Stun(10 SECONDS)
    
    // Drop any held items
    dropItemToGround(get_active_held_item(), TRUE)
    dropItemToGround(get_inactive_held_item(), TRUE)
    
    // Prevent normal death during sequence
    var/old_godmode = status_flags & GODMODE
    status_flags |= GODMODE
    
    // Play initial death foley
    playsound(get_turf(src), 'sound/shuz/antag/deathfoley1.ogg', 100, TRUE)
    
    // Choose a random death voice line
    var/voice_choice = rand(1, 3)
    var/vo_file
    var/death_message
    var/vo_duration
    
    switch(voice_choice)
        if(1)
            vo_file = 'sound/shuz/antag/deth1.ogg'
            death_message = "O' Gods...Greet me..."
            vo_duration = 5 SECONDS // Adjust based on actual file length
        if(2)
            vo_file = 'sound/shuz/antag/deth2.ogg'
            death_message = "The Hall of Bones....awaits..."
            vo_duration = 5 SECONDS
        if(3)
            vo_file = 'sound/shuz/antag/deth3.ogg'
            death_message = "I have +EARNED+....my place..."
            vo_duration = 5 SECONDS
    
    // Play the voice line and say the message
    playsound(get_turf(src), vo_file, 100, TRUE)
    say(death_message, forced = "death")
    visible_message(span_userdanger("[src] stumbles, strength finally failing..."))
    
    // Wait for voice line to finish
    sleep(vo_duration)
    
    // Play final death sounds
    playsound(get_turf(src), 'sound/shuz/antag/deathgasp.ogg', 100, TRUE)
    playsound(get_turf(src), 'sound/shuz/antag/deathfoleyfinal.ogg', 100, TRUE)
    
    // Force lying down
    Knockdown(100)
    
    // Collapse message
    visible_message(span_danger("[src] collapses to the ground, the legendary Khan finally fallen!"))
    
    // Brief pause for dramatic effect
    sleep(1 SECONDS)
    
    // Restore godmode state and actually die
    if(!old_godmode)
        status_flags &= ~GODMODE
    
    return TRUE
