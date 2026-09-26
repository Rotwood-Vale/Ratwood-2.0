/datum/sex_action/manticore_tail_suck_breast
	parent_type = /datum/sex_action/tailmaw
	name = "Suckle their breast with tail maw"
	check_same_tile = FALSE
	user_sex_part = SEX_PART_TAIL_MAW
	target_sex_part = SEX_PART_BREASTS

/datum/sex_action/manticore_tail_suck_breast/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]'s tail rises and blooms open over [target]'s breast, the maw sealing around the soft flesh as feelers spill out to map every curve, latching onto the nipple with a wet, suckling pop."))
	playsound(target, 'sound/misc/mat/insert (1).ogg', 20, TRUE, ignore_walls = FALSE)

/datum/sex_action/manticore_tail_suck_breast/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	var/obj/item/organ/breasts/tits = target.getorganslot(ORGAN_SLOT_BREASTS)
	var/lactating = tits?.lactating
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			if(lactating)
				message = "[user]'s tail maw pulses in slow, coaxing waves around [target]'s breast, feelers tracing circles around the nipple as warm milk beads against the tiny tendrils, each drop eagerly siphoned into the orifice."
			else
				message = "[user]'s tail suckles [target]'s breast in lazy, kneading waves, the feelers curling around the nipple and tugging gently, leaving small circular marks in the soft flesh."
		if(SEX_FORCE_MID)
			if(lactating)
				message = "The feelers inside [user]'s tail wrap tight around [target]'s nipple and pull in rhythmic pulses, milking with mechanical precision as the maw's vacuum seal draws a steady flow of warm cream into the hungry orifice."
			else
				message = "[user]'s tail maw suckles harder, the feelers spiraling around [target]'s nipple in tight coils, each pulse of suction pulling the flesh deeper into the warm, slick maw."
		if(SEX_FORCE_HIGH)
			if(lactating)
				message = "[user]'s tail clamps [target]'s breast with bruising suction, the feelers aggressively pumping the nipple as milk sprays into the maw in thick jets, the orifice gulping audibly with each contraction."
			else
				message = "[user]'s tail bears down on [target]'s breast, the feelers suctioned so tight they leave angry welts, the maw chewing and massaging the flesh with its muscular walls."
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			if(lactating)
				message = "[user]'s tail maw swallows [target]'s entire breast, feelers coating every inch in suctioning tendrils that milk with desperate, bruising force, cream overflowing from the orifice's sealed edges as it drinks and drinks."
			else
				message = "[user]'s tail maw engulfs [target]'s breast whole, the feelers inside writhing against every inch of captured flesh, suctioning hard enough to leave the skin mottled dark when it finally releases."
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.make_sucking_noise()
	user.sexcon.perform_sex_action(target, 3, 0, TRUE)
	user.sexcon.perform_sex_action(user, 1, 0, FALSE)
	user.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)

/datum/sex_action/manticore_tail_suck_breast/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]'s tail releases [target]'s breast with a wet pop, the feelers peeling free reluctantly, leaving the flesh slick with nectar and covered in small, circular suction marks."))

/datum/sex_action/manticore_tail_suck_breast/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return target.sexcon.finished_check()
