/datum/patron/inhumen/graggar
	name = "Graggar"
	domain = "征服、残酷、弑亲、屠戮、食人、支配"
	desc = "血缚之星曾是一位半兽人军阀，因爱侣遭受残酷命运而愤怒到想将 Ravox 击落。他被斩首之后，头颅却以蓝色腐肉与令人作呕的触须畸变复生。凡是凝视那颗星的人，都会被逼入疯狂。"
	worshippers = "堕落战士、食人者、连环杀手、残酷之人"
	virtues = "武勇、支配、暴力"
	sins = "软弱、奴性、怯懦"
	mob_traits = list(TRAIT_HORDE, TRAIT_ORGAN_EATER)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison					= CLERIC_ORI,
					/obj/effect/proc_holder/spell/self/graggar_bloodrage				= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal					= CLERIC_T1,
					/obj/effect/proc_holder/spell/self/call_to_slaughter 				= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/projectile/blood_net 			= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/revel_in_slaughter 			= CLERIC_T3,
	)
	confess_lines = list(
		"GRAGGAR 就是我所崇拜的凶兽！",
		"唯有暴力，方可登神！",
		"征服之神渴求鲜血！",
	)
	storyteller = /datum/storyteller/graggar

/datum/patron/inhumen/graggar/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus,
	is_inhumen
)
	*is_inhumen = TRUE
	*message_out = span_info("肮脏的恶臭烟雾翻涌而出，[target]随之恢复了！")
	*message_self = span_notice("刺鼻的腥臭灼烧着我的鼻腔，但我感觉好多了！")

	var/bonus = 0

	for(var/obj/effect/decal/cleanable/blood/blood in oview(5, target))
		bonus = min(bonus + 0.1, 2.5)

	if(!bonus)
		return

	*situational_bonus = bonus
	*conditional_buff = TRUE

/datum/patron/inhumen/graggar/on_gain(mob/living/living)
	. = ..()

	RegisterSignal(living, COMSIG_LIVING_DRINKED_LIMB_BLOOD, PROC_REF(on_drink_blood))

/datum/patron/inhumen/graggar/proc/on_drink_blood(mob/living/drinker, mob/living/target)
	SIGNAL_HANDLER

	drinker.adjust_hydration(8)

/datum/patron/inhumen/graggar/on_loss(mob/living/living)
	. = ..()

	UnregisterSignal(living, COMSIG_LIVING_DRINKED_LIMB_BLOOD)

// When bleeding, near blood on ground, zchurch, bad-cross, or ritual chalk
/datum/patron/inhumen/graggar/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer in the Zzzzzzzurch(!)
	if(istype(get_area(follower), /area/rogue/indoors/shelter/mountains))
		return TRUE
	// Allows prayer near EEEVIL psycross
	for(var/obj/structure/fluff/psycross/zizocross/cross in view(4, get_turf(follower)))
		if(cross.divine == TRUE)
			to_chat(follower, span_danger("那座遭诅咒的十字架打断了我的祈祷！"))
			return FALSE
		return TRUE
	// Allows prayer if actively bleeding.
	if(follower.bleed_rate > 0)
		return TRUE
	// Allows prayer near blood.
	for(var/obj/effect/decal/cleanable/blood in view(3, get_turf(follower)))
		return TRUE
	// Allows praying atop ritual chalk of the god.
	for(var/obj/structure/ritualcircle/graggar in view(1, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("若想让 Graggar 听见我的祈祷，我必须身处被遗弃者的教堂、倒置的 psycross 附近、靠近新鲜血迹，或亲手放出自己的血！"))
	return FALSE
