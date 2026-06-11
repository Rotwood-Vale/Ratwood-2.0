/datum/patron/divine/ravox
	name = "Ravox"
	domain = "正义、战斗、荣耀、义怒"
	desc = "辉耀的正义与 Astrata 的秩序彼此制衡，避免世界沦为太阳暴政的统治。他是公正无私的神，只为贯彻神圣正义而存在。祂的追随者在追求这一目标时往往会误入歧途。"
	worshippers = "战士、佣兵、骑士、求索正义者"
	virtues = "公正、战斗技艺、勇气"
	sins = "怯懦、施虐、性暴力"
	mob_traits = list(TRAIT_SHARPER_BLADES)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/tug_of_war			= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal			= CLERIC_T1,
					/obj/effect/proc_holder/spell/self/divine_strike			= CLERIC_T1,
					/obj/effect/proc_holder/spell/self/call_to_arms				= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/challenge				= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/persistence			= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/resurrect/ravox		= CLERIC_T4,
	)
	confess_lines = list(
		"RAVOX 即是正义！",
		"历经斗争，方得恩典！",
		"坚持到底，方见荣耀！",
	)
	storyteller = /datum/storyteller/ravox
	COOLDOWN_DECLARE(lesser_heal_buff_cooldown)

// Near a knight statue, cross, or within the church
/datum/patron/divine/ravox/can_pray(mob/living/follower)
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
	// Allows prayer near any knight statue and its subtypes.
	for(var/obj/structure/fluff/statue/knight/K in view(4, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("若想让 Ravox 听见我的祈祷，我必须在教堂内、psycross 附近，或在纪念阵亡者的骑士雕像旁祈祷……"))
	return FALSE

/datum/patron/divine/ravox/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus
)
	*message_out = span_info("一股正义不屈的气势在 [target] 身旁升起！")
	*message_self = span_notice("我心中充满了继续战斗下去的冲动！")

	var/bonus = 0

	if(istype(target.rmb_intent, /datum/rmb_intent/strong))
		bonus++

	if(istype(target.get_active_held_item(), /obj/item/rogueweapon))
		bonus += 0.5

	if(target == user && target.blood_volume <= BLOOD_VOLUME_OKAY && COOLDOWN_FINISHED(src, lesser_heal_buff_cooldown))
		user.emote("warcry")
		user.blood_volume += BLOOD_VOLUME_SURVIVE / 3
		bonus += 2
		COOLDOWN_START(src, lesser_heal_buff_cooldown, 30 SECONDS)

	if(!bonus)
		return

	*conditional_buff = TRUE
	*situational_bonus = bonus
