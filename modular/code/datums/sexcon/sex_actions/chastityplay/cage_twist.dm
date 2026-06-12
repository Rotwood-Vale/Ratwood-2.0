/datum/sex_action/chastityplay/cage_twist
    name = "扭转对方的贞操笼"
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
        user.visible_message(span_warning("[user]握住[target]尖刺[get_chastity_device_name(target)]的外壳，像拧螺丝一样缓缓开始扭动。"))
        return
    user.visible_message(span_warning("[user]双手抓住[target]的[get_chastity_device_name(target)]，开始将其旋转。"))

/datum/sex_action/chastityplay/cage_twist/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU))
        user.sexcon.try_pelvis_crush(target)

    if(HAS_TRAIT(target, TRAIT_CHASTITY_SPIKED))
        play_chastity_impact_sound(target, 'sound/combat/fracture/fracturedry (1).ogg', 50)
        user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]像开瓶钻般扭动[target]的尖刺[get_chastity_device_name(target)]，让内侧尖刺缓慢而可怖地画出一圈……"))
        user.sexcon.perform_sex_action(target, 0.2, 8.8, TRUE)
        user.sexcon.try_do_pain_scream(target, 8.8)
        target.sexcon.handle_passive_ejaculation(user)
        // At extreme force the corkscrew motion can catastrophically avulse trapped anatomy.
        if(user.sexcon.force >= SEX_FORCE_EXTREME && prob(15))
            _try_spiked_catastrophe(user, target, "twist")
        return
    play_chastity_impact_sound(target, list('sound/combat/hits/onmetal/grille (2).ogg', 'sound/combat/hits/onmetal/grille (3).ogg'), 42, 50)
    user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]拧扭[target]固定着的[get_chastity_device_name(target)]，整具装置在被困住的肌肤上滚磨，金属声刺耳作响……"))
    user.sexcon.perform_sex_action(target, 0.4, 6, TRUE)
    user.sexcon.try_do_pain_scream(target, 6)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/cage_twist/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]松开扭力，让[target]的[get_chastity_device_name(target)]吱呀作响地回到原位。"))

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
            target.visible_message(span_userdanger("[user]以灾难性的力量将[target]的尖刺贞操笼硬生生扯下——[target.p_their()]的肉棒还卡在里面，被整个撕断，其余腹股沟也被一并毁得不成样子。"))
        else
            target.visible_message(span_userdanger("随着最后一次灾难性的扭转，[target]的尖刺贞操笼彻底脱落——[target.p_their()]的肉棒被整个撕断留在其中，脱离时碰触到的一切也都被毁坏。"))
        playsound(drop_turf, pick('modular/sound/masomoans/agony/CBTScreamIntersex1.ogg', 'modular/sound/masomoans/agony/CBTScreamIntersex2.ogg'), 85, FALSE, 2)
        target.add_splatter_floor(drop_turf)
        penis_organ.Remove(target)
        penis_organ.forceMove(drop_turf)
        if(chest && !chest.has_wound(/datum/wound/cbt))
            chest.add_wound(/datum/wound/cbt)
    else if(penis_organ)
        // Cock-only: device and organ torn free together.
        if(action_type == "pull")
            target.visible_message(span_userdanger("最后猛地一拽，[target]的尖刺贞操笼被整个扯下——[target.p_their()]的肉棒仍卡在其中，自根部被连根撕断。"))
        else
            target.visible_message(span_userdanger("伴随着令人作呕的最后一圈扭转，[target]的尖刺贞操笼从固定处彻底撕脱——[target.p_their()]被困住的肉棒也随之被内侧尖刺整个拖断。"))
        playsound(drop_turf, pick('modular/sound/masomoans/agony/CBTScreamMale1.ogg', 'modular/sound/masomoans/agony/CBTScreamMale2.ogg'), 85, FALSE, 2)
        target.add_splatter_floor(drop_turf)
        penis_organ.Remove(target)
        penis_organ.forceMove(drop_turf)
    else if(vagina_organ && chastity_dev && chest && !chest.has_wound(/datum/wound/cbt))
        // Vagina-only: device wrenches loose, CBT wound from the internal damage.
        if(action_type == "pull")
            target.visible_message(span_userdanger("[user]将[target]的尖刺[get_chastity_device_name(target)]整个撕了下来——它带着令人作呕的猛扯声从[target.p_their()]双腿间脱出，鲜血紧随其后。"))
        else
            target.visible_message(span_userdanger("随着最后一次凶狠的扭钻，[target]的尖刺[get_chastity_device_name(target)]被整个拧脱——它从[target.p_their()]体内撕裂而出，留下的只有一片狼藉。"))
        playsound(drop_turf, pick('modular/sound/masomoans/agony/CBTScreamFemale1.ogg', 'modular/sound/masomoans/agony/CBTScreamFemale2.ogg'), 85, FALSE, 2)
        target.add_splatter_floor(drop_turf)
        chest.add_wound(/datum/wound/cbt)
    else
        return // No qualifying anatomy found; nothing to tear.

    // Strip and drop the device if it is still worn.
    if(chastity_dev && target.chastity_device == chastity_dev)
        chastity_dev.remove_chastity(target)
        chastity_dev.forceMove(drop_turf)
