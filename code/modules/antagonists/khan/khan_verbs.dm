// Khan-specific verbs

/mob/living/carbon/human/verb/declare_khan_war()
    // Verb metadata shown in the verbs UI
    set name = "Declare War"
    set category = "THE KHAN"
    set hidden = TRUE  // Hidden by default, shown only when added to Khan's verbs

    // Only the Khan may use this
    if(!(src.mind && src.mind.has_antag_datum(/datum/antagonist/khan_sahnuzal)))
        to_chat(src, span_warning("You are not the Khan."))
        return

    var/inputty = input(src, "Write your declaration upon the Vale:", "TEXT") as text|null
    if(!inputty)
        return

    src.visible_message(span_warning("[src] prepares to declare war upon the Vale..."))
    // Wind-up time (can be interrupted) — use target so it can be cancelled by moving/being stunned
    if(do_after(src, 5 SECONDS, target = src))
        // Use priority_announce so the headline is large and the body is the player's input
        priority_announce("[inputty]", "THE KHAN HAS DECLARED WAR UPON THE VALE!", 'sound/shuz/antag/declaration.ogg', sender = src)
        message_admins("[src] has declared war upon the Vale.")
        log_game("[src] declared war upon the Vale.")
    return


/mob/living/carbon/human/verb/decimate()
    // Decimate is provided as a spell now; use the spellcasting UI.
    to_chat(src, span_notice("Nightfall is now a spell. Open your spell panel to cast it."))
    return

