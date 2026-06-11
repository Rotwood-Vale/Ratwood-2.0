/datum/patron/divine/pestra
	name = "Pestra"
	domain = "医药、瘟疫、腐朽"
	desc = "万灵药是 THE TEN 中唯一诞生自 wildkin 的神祇，她教会了我们医术与外科手艺。与其他 Tennites 相比，她的追随者对腐烂与朽坏的痴迷已到了令人忧心的地步。"
	worshippers = "病患、外科医师、药剂师"
	virtues = "怜悯、腐朽、求知"
	sins = "傲慢、愤怒、拒绝向任何人提供医治"
	mob_traits = list(TRAIT_EMPATH, TRAIT_ROT_EATER)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/diagnose				= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/pestra_leech			= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/infestation			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/pestilent_blade		= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/pestra_heal			= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/attach_bodypart		= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/heal					= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/cure_rot				= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/resurrect/pestra		= CLERIC_T4,
	)
	confess_lines = list(
		"PESTRA 抚慰一切病苦！",
		"腐朽便是生命的延续！",
		"我的苦难便是我的见证！",
	)
	storyteller = /datum/storyteller/pestra

// Near a well, cross, within the physicians, or within the church
/datum/patron/divine/pesta/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer near psycross
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("那座被亵渎的 psycross 打断了我的祈祷！"))
			return FALSE
		return TRUE
	// Allows prayer in the church
	if(istype(get_area(follower), /area/rogue/indoors/town/church))
		return TRUE
	// Allows prayer in the appothocary's building.
	if(istype(get_area(follower), /area/rogue/indoors/town/physician))
		return TRUE
	// Allows prayer near wells. Weird one, but makes sense for health and disease. Miasma, water, etc.
	for(var/obj/structure/well/W in view(4, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("若想让 Pestra 听见我的祈祷，我必须在教堂内、医馆中、psycross 附近，或在井边见证生命的完整轮回……"))
	return FALSE

/datum/patron/divine/pestra/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus
)
	*message_out = span_info("一股冷静而专业的疗护气息笼罩着 [target]！")
	*message_self = span_notice("神圣的医术正将我重新缝合起来！")

	target.adjustToxLoss(-*situational_bonus)
	target.blood_volume += BLOOD_VOLUME_SURVIVE / 3
