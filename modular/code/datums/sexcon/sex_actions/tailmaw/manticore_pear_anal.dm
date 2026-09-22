/// The pear of anguish actions are uniquely locked behind both partners having extreme ERP toggled.
/// Observers do not see the flavor text spans for these actions unless they have extreme ERP toggled.
/datum/sex_action/manticore_pear_anal
	parent_type = /datum/sex_action/tailmaw/pear
	name = "Pear of Anguish (Anal)"
	check_same_tile = FALSE
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_ANUS
	user_sex_part = SEX_PART_TAIL_MAW
	wound_type = /datum/wound/fracture/groin

/datum/sex_action/manticore_pear_anal/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/list/excluded = get_extreme_content_excluded_mobs(target)
	user.visible_message(span_userdanger("[user]'s tail presses its sealed bud against [target]'s rim, the interlocking plates grinding together as it forces its way inside with a cruel, deliberate slowness."), ignored_mobs = excluded)
	playsound(target, 'sound/misc/mat/insert (1).ogg', 35, TRUE, ignore_walls = FALSE)

/datum/sex_action/manticore_pear_anal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!..())
		return
	var/list/excluded = get_extreme_content_excluded_mobs(target)
	user.sexcon_action_message(span_userdanger("[user]'s tail bud begins to flower open inside [target]'s ass, the bonelike plates spreading apart with a grinding creak, stretching [target]'s insides far beyond what flesh was meant to accommodate. [target]'s screams are accompanied by the wet crack of something giving way deep inside."), ignored_mobs = excluded)
	playsound(target, 'sound/combat/fracture/fracturewet (1).ogg', 40, TRUE, ignore_walls = FALSE)
	user.visible_message(span_userdanger("[user] rips [user.p_their()] tail free from [target]'s destroyed rear, the plates snapping shut with a wet crunch, leaving behind a gaping, prolapsed ruin."), ignored_mobs = excluded)
