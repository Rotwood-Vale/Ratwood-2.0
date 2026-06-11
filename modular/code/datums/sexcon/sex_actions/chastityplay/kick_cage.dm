/datum/sex_action/chastityplay/kick_cage
	name = "踢击他们的贞操装置"
	check_same_tile = FALSE
	category = SEX_CATEGORY_HANDS

/datum/sex_action/chastityplay/kick_cage/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!requires_other_target(user, target))
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_NUTCRACKER))
		return FALSE
	if(!target_has_front_chastity(target))
		return FALSE
	return TRUE

/datum/sex_action/chastityplay/kick_cage/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!requires_other_target(user, target))
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_NUTCRACKER))
		return FALSE
	if(user.resting)
		return FALSE
	if(!target_has_front_chastity(target))
		return FALSE
	if(!user.Adjacent(target))
		return FALSE
	if(!can_reach_target_groin(user, target))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_L_FOOT) && !check_location_accessible(user, user, BODY_ZONE_PRECISE_R_FOOT))
		return FALSE
	return TRUE

/datum/sex_action/chastityplay/kick_cage/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/device = target.sexcon.has_chastity_cage() ? "贞操笼" : "贞操带"
	play_chastity_impact_sound(target, 'sound/combat/hits/kick/kick.ogg', 40, 100, TRUE, -1)
	if(HAS_TRAIT(target, TRAIT_CHASTITY_SPIKED))
		user.visible_message(span_warning("[user]把脚掌贴上[target]带刺的[device]，缓缓施压，试探它究竟能承受到什么地步。"))
		return
	user.visible_message(span_warning("[user]将重心后移，抬起脚，与[target]的[device]平齐相对。"))

/datum/sex_action/chastityplay/kick_cage/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/force = user.sexcon.force
	var/device = target.sexcon.has_chastity_cage() ? "贞操笼" : "贞操带"
	var/msg
	var/arousal_amt = 0.7
	var/pain_amt = 2

	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU))
		user.sexcon.try_pelvis_crush(target)

	switch(force)
		if(SEX_FORCE_LOW)
			msg = "[user][user.sexcon.get_generic_force_adjective()]让脚掌在[target]的[device]上缓慢而刻意地打着圈碾动，那压力离残忍只差一点点......"
			arousal_amt = 1.0
			pain_amt = 1.5
		if(SEX_FORCE_MID)
			msg = "[user][user.sexcon.get_generic_force_adjective()]猛地一脚踢进[target]的[device]，伴着一声清脆爆响，冲击力隔着钢铁狠狠咬了进去......"
			arousal_amt = 0.6
			pain_amt = 4.5
		if(SEX_FORCE_HIGH)
			msg = "[user][user.sexcon.get_generic_force_adjective()]一脚又一脚重重砸向[target]的[device]，节奏毫不停歇，每一次踢击都比上一次更响、更狠......"
			arousal_amt = 0.25
			pain_amt = 7.5
		if(SEX_FORCE_EXTREME, SEX_FORCE_LUDICROUS)
			msg = "[user][user.sexcon.get_generic_force_adjective()]以碾踏般的脚跟重踩将全身重量都压向[target]的[device]，钢铁与钢铁尖啸摩擦......"
			arousal_amt = 0.0
			pain_amt = 11

	user.visible_message(user.sexcon.spanify_force(msg))
	if(force >= SEX_FORCE_EXTREME)
		play_chastity_impact_sound(target, 'sound/combat/hits/kick/stomp.ogg', 65, 100, TRUE, -1)
	else
		play_chastity_impact_sound(target, 'sound/combat/hits/kick/kick.ogg', 55, 100, TRUE, -1)
	user.sexcon.perform_sex_action(target, arousal_amt, pain_amt, TRUE)

	if(HAS_TRAIT(target, TRAIT_CHASTITY_SPIKED))
		play_chastity_impact_sound(target, 'sound/combat/hits/bladed/genstab (1).ogg', 45, 45)
		user.visible_message(span_warning("内侧尖刺惩罚着每一次踢击，随着每下冲击越陷越深！"))
		user.sexcon.perform_sex_action(target, 0, 3.2, TRUE)
		user.sexcon.try_do_pain_scream(target, pain_amt + 3.2)
		if(force >= SEX_FORCE_HIGH && prob(35))
			to_chat(user, span_warning("踢击时有根尖刺挂住了你的脚，传来一阵锐利刺痛。"))
			user.sexcon.perform_sex_action(user, 0, 1.2, TRUE)
			user.sexcon.try_do_pain_scream(user, 1.2)
		// At extreme force the heel-stomp can drive the spikes inward hard enough to cause internal torsion damage.
		// Applies to anyone with front chastity regardless of anatomy — the damage is blunt-force internal, not a tear.
		if(force >= SEX_FORCE_EXTREME && prob(20))
			var/obj/item/bodypart/chest = target.get_bodypart(BODY_ZONE_CHEST)
			if(chest && !chest.has_wound(/datum/wound/cbt))
				var/has_cock = !!target.getorganslot(ORGAN_SLOT_PENIS)
				var/has_cunt = !!target.getorganslot(ORGAN_SLOT_VAGINA)
				if(has_cock && has_cunt)
					playsound(get_turf(target), pick('modular/sound/masomoans/agony/CBTScreamIntersex1.ogg', 'modular/sound/masomoans/agony/CBTScreamIntersex2.ogg'), 85, FALSE, 2)
					target.add_splatter_floor(get_turf(target))
					target.visible_message(span_userdanger("[user]的脚跟以灾难性的力量将[target]带刺的[device]狠狠踩入体内，某种东西在腹股沟深处撕裂开来，鲜血浸透了大腿，而[target]也随之瘫倒。"))
					chest.add_wound(/datum/wound/cbt)
				else if(has_cock)
					playsound(get_turf(target), pick('modular/sound/masomoans/agony/CBTScreamMale1.ogg', 'modular/sound/masomoans/agony/CBTScreamMale2.ogg'), 85, FALSE, 2)
					target.add_splatter_floor(get_turf(target))
					target.visible_message(span_userdanger("[user]的脚跟裹着全身重量把带刺的笼子狠狠踩了进去，随后传来的碎裂闷响既不对劲又沉得吓人，[target]立刻弓身蜷倒，睾丸已被这一下彻底摧毁。"))
					chest.add_wound(/datum/wound/cbt)
				else if(has_cunt)
					playsound(get_turf(target), pick('modular/sound/masomoans/agony/CBTScreamFemale1.ogg', 'modular/sound/masomoans/agony/CBTScreamFemale2.ogg'), 85, FALSE, 2)
					target.add_splatter_floor(get_turf(target))
					target.visible_message(span_userdanger("这一记脚跟重踏带着残酷的终结意味，将[target]带刺的贞操带狠狠踩进腹股沟，体内有什么东西随之崩裂，双腿一软，在鲜血涌出时才真正意识到伤势。"))
					chest.add_wound(/datum/wound/cbt)

	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/kick_cage/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/device = target.sexcon.has_chastity_cage() ? "贞操笼" : "贞操带"
	user.visible_message(span_warning("[user]放下脚，朝后退开，留下[target]的[device]兀自嗡鸣作响。"))

/datum/sex_action/chastityplay/kick_cage/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
