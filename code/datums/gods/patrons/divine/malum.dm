/datum/patron/divine/malum
	name = "Malum"
	domain = "工艺、火焰、毁灭、巧思"
	desc = "这位无偏之神教导我们：无论是用来杀戮还是用来拯救，工具终究只是工具。润滑得当的断头台与磨得锋利的斧头都不过是器物而已，在它们的锻造之中，本无善恶可言。"
	worshippers = "铁匠、矿工、工匠、矮人"
	virtues = "工艺、贞洁、勤勉"
	sins = "懒惰、道德说教、自尽"
	mob_traits = list(TRAIT_FORGEBLESSED, TRAIT_BETTER_SLEEP)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/malum_flame_rogue 	= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/conjure_tool			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/vigorousexchange		= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/heatmetal				= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/hammerfall			= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/craftercovenant		= CLERIC_T4,
					/obj/effect/proc_holder/spell/invoked/resurrect/malum		= CLERIC_T4,
	)
	confess_lines = list(
		"MALUM 是我的灵感之源！",
		"真正的价值存在于劳作之中！",
		"我是创造的器具！",
	)

	storyteller = /datum/storyteller/malum

// Near a smelter, hearth, cross, within the smithy, or within the church
/datum/patron/divine/malum/can_pray(mob/living/follower)
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
	// Allows prayer in the smith's building.
	if(istype(get_area(follower), /area/rogue/indoors/town/dwarfin))
		return TRUE
	// Allows prayer near hearths.
	for(var/obj/machinery/light/rogue/hearth/H in view(4, get_turf(follower)))
		return TRUE
	// Allows prayer near smelters.
	for(var/obj/machinery/light/rogue/smelter/H in view(4, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("若想让 Malum 听见我的祈祷，我必须在教堂内、铁匠工坊中、psycross 附近、熔炉旁，或在壁炉边沐浴于 Malum 的荣光之下……"))
	return FALSE

/datum/patron/divine/malum/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus
)
	*message_out = span_info("一股淬炼般的热浪自[target]体内迸发而出！")
	*message_self = span_info("我感到熔炉的热度正在抚慰我的痛楚！")

	var/list/firey_stuff = list(/obj/machinery/light/rogue/torchholder, /obj/machinery/light/rogue/campfire, /obj/machinery/light/rogue/hearth, /obj/machinery/light/rogue/campfire/fireplace, /obj/machinery/light/rogue/candle, /obj/machinery/light/rogue/forge)
	var/bonus = 0

	// extra healing for every source of fire/light near us
	for(var/obj/obj in oview(5, user))
		if(!(obj.type in firey_stuff))
			continue

		bonus = min(bonus + 0.5, 2.5)

	if(!bonus)
		return

	*situational_bonus = bonus
	*conditional_buff = TRUE
