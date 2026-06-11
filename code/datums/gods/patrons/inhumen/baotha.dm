/datum/patron/inhumen/baotha
	name = "Baotha"
	domain = "享乐、放荡、成瘾、碎心"
	desc = "放纵之女是唯一从 Zizo 屠杀中活下来的雪精灵，曾被 Naledi 当作侍妾豢养。直到某一天，她彻底沉沦于自己的堕落与瘾欲之中，从囚禁她的人手中盗走了一块 SYON 碎片，并由此登临神位。她的追随者只渴望体验那些足以腐蚀心智的欢愉。"
	worshippers = "寡妇、赌徒、瘾君子、失意恋人、彻底沉沦的娼妓"
	virtues = "色欲、暴食、寻求刺激"
	sins = "贞洁、节制、阴郁"
	mob_traits = list(TRAIT_DEPRAVED, TRAIT_CRACKHEAD)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison					= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/baothavice					= CLERIC_T0,
					/obj/effect/proc_holder/spell/targeted/touch/loversruin				= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/baothablessings				= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/griefflower					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/projectile/blowingdust		= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/joyride						= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/lasthigh						= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/painkiller					= CLERIC_T3,
	)
	confess_lines = list(
		"BAOTHA 渴求欢愉！",
		"活着，欢笑，去爱！",
		"BAOTHA 就是我的快乐！",
	)
	storyteller = /datum/storyteller/baotha

/datum/patron/inhumen/baotha/can_pray(mob/living/follower)
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
	// Allows prayers in the bath house - whore.
	if(istype(get_area(follower), /area/rogue/indoors/town/bath))
		return TRUE
	// Allows prayers if actively high on drugs.
	if(follower.has_status_effect(/datum/status_effect/buff/ozium) || follower.has_status_effect(/datum/status_effect/buff/moondust) || follower.has_status_effect(/datum/status_effect/buff/moondust_purest) || follower.has_status_effect(/datum/status_effect/buff/druqks) || follower.has_status_effect(/datum/status_effect/buff/starsugar))
		return TRUE
	// Allows prayers if the user is drunk.
	if(follower.has_status_effect(/datum/status_effect/buff/drunk))
		return TRUE
	// Allows praying atop ritual chalk of the god.
	for(var/obj/structure/ritualcircle/baotha in view(1, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("若想让 Baotha 听见我的祈祷，我必须身处被遗弃者的教堂、倒置的 psycross 附近、镇上的浴场之中，或正沉浸在某种鼻中妙药带来的快意里！"))
	return FALSE

#define BAOTHA_SUFFERING_DIVIDER 3.535 // max bonus at 50 pain/bleedrate and pain_mod = 1

/datum/patron/inhumen/baotha/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus,
	is_inhumen
)
	*is_inhumen = TRUE
	*message_out = span_info("自[target]体内迸发出阵阵享乐冲动与炽烈情绪。")
	*message_self = span_notice("一阵令人沉醉的麻醉快感抚平了我的痛苦！")

	if(!ishuman(target))
		*message_self = span_notice("一阵令人沉醉的麻醉快感流遍了我的全身！")
		return

	var/mob/living/carbon/human/human_target = target
	var/bonus = 0

	if(human_target.has_status_effect(/datum/status_effect/buff/druqks) \
	|| human_target.has_status_effect(/datum/status_effect/buff/drunk))
		bonus += 0.5

	if(human_target.get_stress_event(/datum/stressevent/lasthigh))
		bonus += 0.5

	if(!HAS_TRAIT(target, TRAIT_NOPAIN) || HAS_TRAIT(target, TRAIT_CRACKHEAD))
		var/raw_suffering = 0

		for(var/datum/wound/wound in human_target.get_wounds())
			raw_suffering += wound.woundpain + wound.bleed_rate

		var/suffering = sqrt(raw_suffering) / BAOTHA_SUFFERING_DIVIDER
		var/to_add = HAS_TRAIT(target, TRAIT_DEPRAVED) ? suffering : suffering * human_target.physiology.pain_mod
		bonus += min(to_add, 2)

	*conditional_buff = TRUE
	*situational_bonus = bonus

#undef BAOTHA_SUFFERING_DIVIDER
