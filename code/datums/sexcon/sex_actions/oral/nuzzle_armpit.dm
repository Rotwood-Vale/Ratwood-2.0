/datum/sex_action/armpit_nuzzle
	name = "Nuzzle their armpit"
	user_sex_part = SEX_PART_JAWS
	target_sex_part = SEX_PART_CHEST

/datum/sex_action/armpit_nuzzle/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] moves [user.p_their()] head against [target]'s armpit..."))

/datum/sex_action/armpit_nuzzle/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] nuzzles [target]'s armpit..."))

/datum/sex_action/armpit_nuzzle/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] stops nuzzling [target]'s armpit..."))
