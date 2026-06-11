/datum/sex_action/force_blowjob
	name = "强迫对方含弄"
	require_grab = TRUE
	stamina_cost = 1.0
	category = SEX_CATEGORY_PENETRATE
	user_sex_part = SEX_PART_COCK
	target_sex_part = SEX_PART_JAWS

/datum/sex_action/force_blowjob/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		if(isdullahan(user))
			var/datum/species/dullahan/dullahan = user.dna.species
			if(dullahan.headless && !user.is_holding(dullahan.my_head))
				return FALSE
		else
			return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/force_blowjob/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		if(isdullahan(user))
			var/datum/species/dullahan/dullahan = user.dna.species
			if(dullahan.headless && !user.is_holding(dullahan.my_head))
				return FALSE
		else
			return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!user.sexcon.can_use_penis())
		return FALSE
	return TRUE

/datum/sex_action/force_blowjob/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]强按着[target]的脑袋，让其吞含并吮弄[user.p_their()]肉棒！"))
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), 20, TRUE, ignore_walls = FALSE)

/datum/sex_action/force_blowjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]强迫[target]含弄[user.p_their()]肉棒。"))
	user.sexcon.oralcourse_noise(target)
	target.sexcon.do_thrust_animate(user)

	user.sexcon.perform_sex_action(user, 2, 4, TRUE)
	if(user.sexcon.check_active_ejaculation())
		user.visible_message(span_love("[user]射进了[target]的喉咙里！"))
		for(var/i = 1; i <= user.sexcon.get_load_bursts(); i++)
			user.sexcon.cum_into(oral = TRUE, splashed_user = target, consume_charge = i == 1 ? TRUE : FALSE) // give facial status effect for the target, considering this was rough throat sex
			sleep(10)

	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || (user.STASTR > 12))
		if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			user.sexcon.try_jaw_crush(target)

	user.sexcon.perform_sex_action(target, 0, 7, FALSE)
	if(!user.sexcon.considered_limp())
		user.sexcon.perform_deepthroat_oxyloss(target, 1.3)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/force_blowjob/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]肉棒从[target]喉中抽了出来。"))

/datum/sex_action/force_blowjob/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
