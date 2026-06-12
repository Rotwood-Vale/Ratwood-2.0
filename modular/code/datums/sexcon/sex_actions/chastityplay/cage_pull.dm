// Tugging the cage outward. At extreme force with a spiked device this can trigger a catastrophic avulsion injury.
// _try_spiked_catastrophe() is defined on the parent /datum/sex_action/chastityplay in cage_twist.dm;
// it handles anatomy branching (intersex / cock-only / vagina-only) and device stripping in one place
// so both cage_pull and cage_twist share identical consequences for the worst-case scenario.
/datum/sex_action/chastityplay/cage_pull
    name = "拉拽对方的贞操笼"
    category = SEX_CATEGORY_HANDS
    target_sex_part = SEX_PART_COCK

/datum/sex_action/chastityplay/cage_pull/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!target_has_cage(target))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/cage_pull/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!target_has_cage(target))
        return FALSE
    if(!can_reach_target_groin(user, target))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/cage_pull/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(HAS_TRAIT(target, TRAIT_CHASTITY_SPIKED))
        user.visible_message(span_warning("[user]小心抓住[target]尖刺[get_chastity_device_name(target)]的外缘，缓慢而刻意地拉扯。"))
        return
    user.visible_message(span_warning("[user]将[user.p_their()]的手指勾进[target]的[get_chastity_device_name(target)]边缘下方，缓慢地试探着拉了一下。"))

/datum/sex_action/chastityplay/cage_pull/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU))
        user.sexcon.try_pelvis_crush(target)

    if(HAS_TRAIT(target, TRAIT_CHASTITY_SPIKED))
        play_chastity_impact_sound(target, 'sound/combat/hits/bladed/genstab (1).ogg', 45, 45)
        user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]猛地向外拽动[target]的尖刺[get_chastity_device_name(target)]，每一次拉扯都让内侧的尖刺刮过[target.p_their()]被困住的血肉……"))
        user.sexcon.perform_sex_action(target, 0.25, 6.6, TRUE)
        user.sexcon.try_do_pain_scream(target, 6.6)
        target.sexcon.handle_passive_ejaculation(user)
        // At extreme force the repeated outward wrenching risks catastrophic avulsion injury.
        if(user.sexcon.force >= SEX_FORCE_EXTREME && prob(15))
            _try_spiked_catastrophe(user, target, "pull")
        return
    play_chastity_impact_sound(target, list('sound/combat/hits/onmetal/grille (1).ogg', 'sound/combat/hits/onmetal/grille (2).ogg'), 40, 40)
    user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]猛拽[target]的[get_chastity_device_name(target)]，金属咬入并拖磨着它所压迫的一切……"))
    user.sexcon.perform_sex_action(target, 0.6, 4, TRUE)
    user.sexcon.try_do_pain_scream(target, 4)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/cage_pull/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]松开[target]的[get_chastity_device_name(target)]，任其落回原位。"))

/datum/sex_action/chastityplay/cage_pull/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(target.sexcon.finished_check())
        return TRUE
    return FALSE
