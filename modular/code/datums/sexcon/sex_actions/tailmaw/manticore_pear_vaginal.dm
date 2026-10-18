/datum/sex_action/manticore_pear_vaginal
	parent_type = /datum/sex_action/tailmaw/pear
	name = "Pear of Anguish (Vaginal)"
	check_same_tile = FALSE
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_CUNT
	user_sex_part = SEX_PART_TAIL_MAW
	wound_type = /datum/wound/cbt

/datum/sex_action/manticore_pear_vaginal/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/list/excluded = get_extreme_content_excluded_mobs(target)
	user.visible_message(span_userdanger("[user]'s tail pushes its sealed bud between [target]'s legs, the interlocking plates pressing against [target]'s entrance before forcing inside with a sick, grinding push."), ignored_mobs = excluded)
	playsound(target, 'sound/misc/mat/insert (1).ogg', 35, TRUE, ignore_walls = FALSE)

/datum/sex_action/manticore_pear_vaginal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!..())
		return
	var/list/excluded = get_extreme_content_excluded_mobs(target)
	user.sexcon_action_message(span_userdanger("The tail bud blossoms inside [target], the plates spreading apart with merciless force, stretching walls that were never meant to give this far. Something tears deep inside, the wet sound of ripping flesh drowned out by [target]'s agonized screaming."), ignored_mobs = excluded)
	playsound(target, 'sound/combat/fracture/fracturewet (1).ogg', 40, TRUE, ignore_walls = FALSE)
	user.visible_message(span_userdanger("[user] tears [user.p_their()] tail free from [target]'s savaged cunt, the plates folding shut with a crunch, dragging blood and tissue with them."), ignored_mobs = excluded)
