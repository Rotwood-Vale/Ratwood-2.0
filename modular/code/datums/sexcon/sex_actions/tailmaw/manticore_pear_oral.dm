/datum/sex_action/manticore_pear_oral
	parent_type = /datum/sex_action/tailmaw/pear
	name = "Pear of Anguish (Oral)"
	check_same_tile = FALSE
	target_sex_part = SEX_PART_JAWS
	user_sex_part = SEX_PART_TAIL_MAW
	wound_type = /datum/wound/fracture/mouth
	wound_zone = BODY_ZONE_HEAD

/datum/sex_action/manticore_pear_oral/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/list/excluded = get_extreme_content_excluded_mobs(target)
	user.visible_message(span_userdanger("[user]'s tail forces its sealed bud past [target]'s lips, the ridged plates scraping across teeth and gums as it pushes deep into [target]'s mouth."), ignored_mobs = excluded)
	playsound(target, 'sound/misc/mat/insert (1).ogg', 35, TRUE, ignore_walls = FALSE)

/datum/sex_action/manticore_pear_oral/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!..())
		return
	var/list/excluded = get_extreme_content_excluded_mobs(target)
	user.sexcon_action_message(span_userdanger("The bud inside [target]'s mouth begins to blossom, the bonelike plates cranking apart with agonizing slowness, forcing [target]'s jaw wider and wider until the joints pop and creak, teeth cracking against the unyielding chitin."), ignored_mobs = excluded)
	playsound(target, 'sound/combat/fracture/fracturewet (1).ogg', 40, TRUE, ignore_walls = FALSE)
	user.visible_message(span_userdanger("[user] wrenches [user.p_their()] tail free from [target]'s ruined mouth, the plates folding shut as they drag loose teeth and blood with them, leaving [target]'s jaw hanging at a sickening angle."), ignored_mobs = excluded)
