/datum/patron/inhumen/matthios
	name = "Matthios"
	domain = "贪婪、盗窃、巨龙、真正的自由"
	desc = "千面之 Matthios 没有真正固定的形态。有人视祂为快活的拦路强盗，有人视祂为乞者之神，还有人认为祂是群龙之父。但有一点可以确定：祂的追随者都憎恶 Astrata 的贵族统治。"
	worshippers = "拦路强盗、受压迫的农民、商人、奴隶、Kobolds"
	virtues = "因人而异；通常是贪婪与贸易"
	sins = "贵族、懒惰、屈从于“不公的等级秩序”"
	crafting_recipes = list(/datum/crafting_recipe/roguetown/sewing/bandithood)
	mob_traits = list(TRAIT_COMMIE, TRAIT_MATTHIOS_EYES, TRAIT_SEEPRICES_SHITTY)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison					= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/appraise						= CLERIC_ORI,
					/obj/effect/proc_holder/spell/targeted/touch/lesserknock/miracle	= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/transact						= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/equalize						= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/churnwealthy					= CLERIC_T3,
	)
	confess_lines = list(
		"MATTHIOS 从无价值之人手中夺取一切！",
		"MATTHIOS 即是正义！",
		"MATTHIOS 是我的主！",
	)
	storyteller = /datum/storyteller/matthios

// When near coin of at least 100 mammon, zchurch, bad-cross, or ritual talk
/datum/patron/inhumen/matthios/can_pray(mob/living/follower)
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
	// Allows prayer if the user has more than 100 mammon on them.
	var/mammon_count = get_mammons_in_atom(follower)
	if(mammon_count >= 100)
		return TRUE
	// Spend 5/10 mammon to pray. Megachurch pastors be like.....
	var/obj/item/held_item = follower.get_active_held_item()
	var/helditemvalue = held_item.get_real_price()
	if(istype(held_item, /obj/item/roguecoin) && helditemvalue >= 5)
		qdel(held_item)
		return TRUE
	// Allows praying atop ritual chalk of the god.
	for(var/obj/structure/ritualcircle/matthios in view(1, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("若想让 Matthios 听见我的祈祷，我必须身处被遗弃者的教堂、倒置的 psycross 附近，身怀至少 100 mammons 的财富，或向祂献上一枚至少值五 mammons 的钱币！"))
	return FALSE

/datum/patron/inhumen/matthios/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus,
	is_inhumen
)
	*is_inhumen = TRUE
	*message_out = span_info("一圈……奇异的光辉拂过了[target]？")
	*message_self = span_notice("我正沐浴在……某种奇怪的圣光里？")

	if(HAS_TRAIT(target, TRAIT_COMMIE))
		*conditional_buff = TRUE
		*situational_bonus = 2.5
