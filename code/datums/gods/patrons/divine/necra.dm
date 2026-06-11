/datum/patron/divine/necra
	name = "Necra"
	domain = "死亡、来世、重生"
	desc = "冥下侍女是来世的看守者，所有灵魂终将去往那里。她令迷失者接受“遗忘者试炼”，在那里反复思索自己的一生，方能获得重生。她的追随者将复活视为可憎之举，宁愿守着自己的墓园，与世隔绝。"
	worshippers = "掘墓人、入殓师、失势医者、独行者"
	virtues = "敬重死者、怠惰、宿命论"
	sins = "不死、嬉笑、复生"
	mob_traits = list(TRAIT_SOUL_EXAMINE, TRAIT_NOSTINK)	//No stink is generic but they deal with dead bodies so.. makes sense, I suppose?
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison				= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/necras_sight				= CLERIC_T0,
					/obj/effect/proc_holder/spell/targeted/locate_dead				= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal				= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal				= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/avert						= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/speakwithdead				= CLERIC_T1,
					/obj/effect/proc_holder/spell/targeted/abrogation				= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/necra_crows				= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/deaths_door				= CLERIC_T3,//This was bad enough at T1. No, thanks. Cool as it is.
					/obj/effect/proc_holder/spell/targeted/churn					= CLERIC_T4,//Priest/Acolytes only. Thanks.
	)
	confess_lines = list(
		"众魂终将归于 NECRA！",
		"冥下侍女便是我们最终的安息！",
		"我无惧死亡，我的女主人正等待着我！",
	)
	storyteller = /datum/storyteller/necra

// Near a grave, cross, or within the church
/datum/patron/divine/necra/can_pray(mob/living/follower)
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
	// Allows prayer near a grave.
	for(var/obj/structure/closet/dirthole/grave/G in view(4, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("若想让 Necra 听见我的祈祷，我必须在教堂内、psycross 附近，或靠近那终将迎来我们所有人的坟墓祈祷……"))
	return FALSE

/datum/patron/divine/necra/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus
)
	*message_out = span_info("[target] 身上散发出一股静谧安息的气息！")
	*message_self = span_notice("我感觉冥下侍女的目光暂时从我身上移开了！")

	if(iscarbon(target))
		var/mob/living/carbon/carbon = target
		if(carbon.health <= (carbon.maxHealth * 0.25))
			*conditional_buff = TRUE
			*situational_bonus = 2.5
