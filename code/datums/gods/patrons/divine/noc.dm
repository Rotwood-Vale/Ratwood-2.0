/datum/patron/divine/noc
	name = "Noc"
	domain = "黑夜、月亮、知识、魔法、秘密"
	desc = "秘密之父是辉煌的月光，祂通过知识赐予我们力量。祂让我们得见祂那秘藏宝库的幻象，又以祂的仁慈赐予我们驾驭 Arcyne 的能力。"
	worshippers = "巫师、学者、夜猫子"
	virtues = "智慧、好奇、求索 Arcyne"
	sins = "无知、审查、焚书"
	mob_traits = list(TRAIT_NIGHT_OWL, TRAIT_NOCSIGHT)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison				= CLERIC_ORI,
					/obj/effect/proc_holder/spell/targeted/touch/prestidigitation	= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/silence/miracle			= CLERIC_T0,//wisdom is knowing when to shut up, or to make someone shut up.
					/obj/effect/proc_holder/spell/invoked/lesser_heal 				= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal				= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/invisibility/miracle		= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blindness					= CLERIC_T2,
					/obj/effect/proc_holder/spell/self/noc_spell_bundle				= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/resurrect/noc				= CLERIC_T4,
	)
	confess_lines = list(
		"NOC 即是黑夜！",
		"NOC 洞察万物！",
		"我寻求月亮的奥秘！",
	)
	storyteller = /datum/storyteller/noc

// In moonlight, church, cross, or ritual chalk
/datum/patron/divine/noc/can_pray(mob/living/follower)
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
	// Allows prayer during nightime if outside.
	if(istype(get_area(follower), /area/rogue/outdoors) && (GLOB.tod == "night" || GLOB.tod == "dusk"))
		return TRUE
	// Allows praying atop ritual chalk of the god.
	for(var/obj/structure/ritualcircle/noc in view(1, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("若想让 Noc 听见我的祈祷，我必须沐浴在祂赐福的月光下、身处教堂内，或在 psycross 附近。"))
	return FALSE

/datum/patron/divine/noc/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus
)
	*message_out = span_info("柔和的月光洒落在 [target] 身上！")
	*message_self = span_notice("温柔的月光正笼罩着我！")

	if(GLOB.tod == "night")
		*conditional_buff = TRUE
