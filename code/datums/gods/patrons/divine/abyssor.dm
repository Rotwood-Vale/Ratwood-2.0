/datum/patron/divine/abyssor
	name = "Abyssor"
	domain = "海洋、梦境、纯净、净化"
	desc = "Pure Tide 沉入了长眠，却未曾想到，祂的梦会召来那些因祂神圣缺席而追随祂的人。Dreamers 扭曲的心智与肉体玷污了祂的领域，但也唯有借由祂的水域，我们方可得到洗净。若祂苏醒，世界将被彻底净化。"
	worshippers = "渔民、Axians、Lamia、Dreamers、疯子"
	virtues = "做梦、开放心胸、纯净"
	sins = "遗忘、欺瞒、妄称其名"
	mob_traits = list(TRAIT_ABYSSOR_SWIM, TRAIT_SEA_DRINKER)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/aquatic_compulsion	= CLERIC_T0,
					/obj/effect/proc_holder/spell/self/abyssor_wind				= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/abyssor_bends			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/abyssor_undertow		= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/abyssheal				= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/call_mossback			= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/call_dreamfiend		= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/abyssal_infusion		= CLERIC_T4,
					/obj/effect/proc_holder/spell/invoked/resurrect/abyssor		= CLERIC_T4,
	)
	confess_lines = list(
		"ABYSSOR 号令海浪！",
		"海洋的怒涛即是 ABYSSOR 的意志！",
		"我正被潮汐的牵引所召唤！",
	)

	storyteller = /datum/storyteller/abyssor

// Near water, cross, or within the church.
/datum/patron/divine/abyssor/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer near psycross
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("那座被亵渎的十字架打断了我的祈祷！"))
			return FALSE
		return TRUE
	// Allows prayer in the church
	if(istype(get_area(follower), /area/rogue/indoors/town/church))
		return TRUE
	// Allows prayer near any body of water turf.
	for(var/turf/open/water in view(4, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("若想让 Abyssor 听见我的祈祷，我必须在教堂内、psycross 附近，或任意一片水域旁祈祷，好让祈祷的潮汐得以流动……"))
	return FALSE

/datum/patron/divine/abyssor/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus
)
	*message_out = span_info("一阵带着咸味的雾气笼罩在[target]身上！")
	*message_self = span_notice("治疗的雾气令我精神焕发！")

	if(istype(get_turf(target), /turf/open/water))
		*conditional_buff = TRUE
		*situational_bonus = 1.5
