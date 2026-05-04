/datum/sex_action/chastityplay/cage_twist
    name = "Twist their cage"
    category = SEX_CATEGORY_HANDS
    target_sex_part = SEX_PART_COCK

/datum/sex_action/chastityplay/cage_twist/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!target_has_cage(target))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/cage_twist/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!target_has_cage(target))
        return FALSE
    if(!can_reach_target_groin(user, target))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/cage_twist/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(HAS_TRAIT(target, TRAIT_CHASTITY_SPIKED))
        user.visible_message(span_warning("[user] grips [target]'s spiked [get_chastity_device_name(target)] by the outer housing and starts turning it — slow as a screw."))
        return
    user.visible_message(span_warning("[user] takes hold of [target]'s [get_chastity_device_name(target)] with both hands and begins to rotate it."))

/datum/sex_action/chastityplay/cage_twist/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU))
        user.sexcon.try_pelvis_crush(target)

    if(HAS_TRAIT(target, TRAIT_CHASTITY_SPIKED))
        play_chastity_impact_sound(target, 'sound/combat/fracture/fracturedry (1).ogg', 50)
        user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] corkscrews [target]'s spiked [get_chastity_device_name(target)], driving the inward spikes in a slow, terrible circle..."))
        user.sexcon.perform_sex_action(target, 0.2, 8.8, TRUE)
        user.sexcon.try_do_pain_scream(target, 8.8)
        target.sexcon.handle_passive_ejaculation(user)
        // At extreme force the corkscrew motion can catastrophically avulse trapped anatomy.
        if(user.sexcon.force >= SEX_FORCE_EXTREME && prob(15))
            _try_spiked_catastrophe(user, target, "twist")
        return
    play_chastity_impact_sound(target, list('sound/combat/hits/onmetal/grille (2).ogg', 'sound/combat/hits/onmetal/grille (3).ogg'), 42, 50)
    user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] torques [target]'s [get_chastity_device_name(target)] against its mount, metal grinding as the whole device rolls against trapped skin..."))
    user.sexcon.perform_sex_action(target, 0.4, 6, TRUE)
    user.sexcon.try_do_pain_scream(target, 6)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/cage_twist/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] releases the torque and lets [target]'s [get_chastity_device_name(target)] creak back into position."))

/datum/sex_action/chastityplay/cage_twist/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(target.sexcon.finished_check())
        return TRUE
    return FALSE

/**
 * Shared catastrophe handler for spiked cage_twist and cage_pull at extreme force.
 * Defined on the parent /datum/sex_action/chastityplay so both subtypes can call it.
 * action_type is "twist" or "pull" to select appropriately flavored visible messages.
 * - Penis anatomy: organ ripped free with device.
 * - Vagina anatomy: device wrenched out, CBT wound applied.
 * - Intersex (both): cock ripped off, CBT wound, device stripped off.
 */
/datum/sex_action/chastityplay/proc/_try_spiked_catastrophe(mob/living/carbon/human/user, mob/living/carbon/human/target, action_type = "twist")
    var/obj/item/organ/penis_organ = target.getorganslot(ORGAN_SLOT_PENIS)
    var/obj/item/organ/vagina_organ = target.getorganslot(ORGAN_SLOT_VAGINA)
    var/obj/item/chastity/chastity_dev = target.chastity_device
    var/obj/item/bodypart/chest = target.get_bodypart(BODY_ZONE_CHEST)
    var/turf/drop_turf = get_turf(target)

    if(penis_organ && vagina_organ)
        // Intersex: corkscrew/pull tears the cock loose and batters the remaining anatomy.
        if(action_type == "pull")
            target.visible_message(span_userdanger("[user] hauls [target]'s spiked cage free with catastrophic force — [target.p_their()] prick still inside it, ripped clean off, the rest of [target.p_their()] groin left wrecked by what came with it."))
        else
            target.visible_message(span_userdanger("With a catastrophic final rotation, [target]'s spiked cage tears loose completely — [target.p_their()] prick ripped free inside it, the violence of it wrecking everything else it touched on the way out."))
        playsound(drop_turf, pick('modular/sound/masomoans/agony/CBTScreamIntersex1.ogg', 'modular/sound/masomoans/agony/CBTScreamIntersex2.ogg'), 85, FALSE, 2)
        target.add_splatter_floor(drop_turf)
        penis_organ.Remove(target)
        penis_organ.forceMove(drop_turf)
        if(chest && !chest.has_wound(/datum/wound/cbt))
            chest.add_wound(/datum/wound/cbt)
    else if(penis_organ)
        // Cock-only: device and organ torn free together.
        if(action_type == "pull")
            target.visible_message(span_userdanger("With one final heave, [target]'s spiked cage tears clean off — [target.p_their()] prick hauled out still inside it, ripped free at the root."))
        else
            target.visible_message(span_userdanger("With a gut-wrenching final revolution, [target]'s spiked cage tears itself from the mount entirely — [target.p_their()] trapped prick ripped clean off with it, dragged free by the inward spines."))
        playsound(drop_turf, pick('modular/sound/masomoans/agony/CBTScreamMale1.ogg', 'modular/sound/masomoans/agony/CBTScreamMale2.ogg'), 85, FALSE, 2)
        target.add_splatter_floor(drop_turf)
        penis_organ.Remove(target)
        penis_organ.forceMove(drop_turf)
    else if(vagina_organ && chastity_dev && chest && !chest.has_wound(/datum/wound/cbt))
        // Vagina-only: device wrenches loose, CBT wound from the internal damage.
        if(action_type == "pull")
            target.visible_message(span_userdanger("[user] tears [target]'s spiked [get_chastity_device_name(target)] free entirely — ripping loose from between [target.p_their()] thighs with a sickening wrench, blood following after."))
        else
            target.visible_message(span_userdanger("With a vicious final corkscrew, [target]'s spiked [get_chastity_device_name(target)] wrenches itself entirely loose — tearing free of [target.p_their()] body and leaving nothing but ruin."))
        playsound(drop_turf, pick('modular/sound/masomoans/agony/CBTScreamFemale1.ogg', 'modular/sound/masomoans/agony/CBTScreamFemale2.ogg'), 85, FALSE, 2)
        target.add_splatter_floor(drop_turf)
        chest.add_wound(/datum/wound/cbt)
    else
        return // No qualifying anatomy found; nothing to tear.

    // Strip and drop the device if it is still worn.
    if(chastity_dev && target.chastity_device == chastity_dev)
        chastity_dev.remove_chastity(target)
        chastity_dev.forceMove(drop_turf)
