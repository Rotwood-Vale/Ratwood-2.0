// Khan's Decimate / Nightfall spell

/obj/effect/proc_holder/spell/invoked/decimate
    name = "Obliterate"
    desc = "Swing a crushing maul in a wide cone in front of you, battering foes and leaving scars on the earth if you miss."
    range = 3
    associated_skill = /datum/skill/combat/maces
    recharge_time = 6 SECONDS
    cast_without_targets = TRUE
    sound = 'sound/shuz/obliterate/oncast1.ogg'

/obj/effect/proc_holder/spell/invoked/decimate/cast(list/targets, mob/living/carbon/human/user)
    // Only the Khan antagonist should normally have this spell; ensure caller is the Khan datum owner
    var/datum/antagonist/khan_sahnuzal/K = user.mind?.has_antag_datum(/datum/antagonist/khan_sahnuzal)
    if(!K)
        revert_cast()
        return FALSE

    // Delegate to the antagonist datum's implementation which handles visuals/effects
    K.Perform_Decimate(user)
    return TRUE
