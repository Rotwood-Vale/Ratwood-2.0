/datum/sex_action/manticore_reacharound_anal
	parent_type = /datum/sex_action/tailmaw
	name = "Fuck their ass while engulfing their dick"
	check_same_tile = FALSE
	user_needs_functional = TRUE
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_ANUS | SEX_PART_COCK
	user_sex_part = SEX_PART_TAIL_MAW | SEX_PART_COCK

/datum/sex_action/manticore_reacharound_anal/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(span_notice("[user]'s tail curls around to the front of [target] before swallowing up their quivering dick. With arms wrapped tightly around [target.p_their()] waist, [user] eases [user.p_their()] partner down around [user.p_their()] length..."))

/datum/sex_action/manticore_reacharound_anal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || user.STASTR > 12)
		user.sexcon.try_pelvis_crush(target)
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user]'s tail paints long, luscious licks up and down [target]'s penis while [user.p_their()] dick [user.sexcon.get_generic_force_adjective()] scrapes along [target.p_their()] insides until kissing [target]'s rim."
		if(SEX_FORCE_MID)
			message = "[user]'s tailcunt [user.sexcon.get_generic_force_adjective()] milks the cloudy precum beading from [target]'s dick. Each thrust against [target]'s prostate causes full-body shivers, of which the tailcunt takes ample advantage."
		if(SEX_FORCE_HIGH)
			message = "[user]'s cock [user.sexcon.get_generic_force_adjective()] tugs at [target]'s asshole with growing ease. Hundreds of feelers wriggle and grope [target]'s cock with the single-minded goal of wringing it of all it has."
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user] [user.sexcon.get_generic_force_adjective()] ruts [target]'s guts. [target.p_their(TRUE)] stomach bulges and guts bleed as the tail pussy painfully pumps [target.p_their()] tormented dick. Each two-pronged, fuck-hungry thrust produces a wet slap from the tailcunt and a meaty thwack from the sodomy."
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.intercourse_noise(target, TRUE)
	user.sexcon.perform_sex_action(target, 4, 1, TRUE)
	user.sexcon.perform_sex_action(user, 1, 0, TRUE)
	if(user.sexcon.check_active_ejaculation())
		for(var/i = 1; i <= user.sexcon.get_load_bursts(); i++)
			user.sexcon.cum_into(splashed_user = target, orifice = SEX_PART_ANUS, skip_knot_try = TRUE, consume_charge = i == 1)
			if(HAS_TRAIT(target, TRAIT_BAOTHA_FERTILITY_BOON) && !target.getorganslot(ORGAN_SLOT_VAGINA))
				user.try_impregnate(target)
		user.virginity = FALSE

		var/datum/status_effect/facial/external/coating = target.has_status_effect(/datum/status_effect/facial/external)
		if(coating)
			coating.refresh_cum()
		else
			target.apply_status_effect(/datum/status_effect/facial/external)

	handle_tailmaw_ejaculation(user, target, target, user)

/datum/sex_action/manticore_reacharound_anal/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]'s tail slides free from [target]'s spasming, venom-soaked dick. The tired member spurts out a trickle of pre as [user] yanks free of [target.p_their()] equally exhausted asshole."))

/datum/sex_action/manticore_reacharound_anal/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return user.sexcon.finished_check() || target.sexcon.finished_check()
