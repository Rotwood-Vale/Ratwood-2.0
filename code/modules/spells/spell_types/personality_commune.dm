/obj/effect/proc_holder/spell/targeted/personality_commune
	name = "人格共鸣"
	desc = ""
	recharge_time = 0
	clothes_req = FALSE
	range = -1
	include_user = TRUE
	action_icon_state = "telepathy"
	action_background_icon_state = "bg_spell"
	var/datum/brain_trauma/severe/split_personality/trauma
	var/flufftext = "你的脑海深处响起了一道回荡的声音……"

/obj/effect/proc_holder/spell/targeted/personality_commune/New(datum/brain_trauma/severe/split_personality/T)
	. = ..()
	trauma = T

// Pillaged and adapted from telepathy code
/obj/effect/proc_holder/spell/targeted/personality_commune/cast(list/targets, mob/user)
	if(!istype(trauma))
		to_chat(user, span_warning("情况不对；要么是出了错误，要么是管理操作所致，你正在没有分裂人格的情况下施放这道法术！"))
		return
	var/msg = stripped_input(usr, "你想对另一个自己说些什么？", null , "")
	if(!msg)
		charge_counter = recharge_time
		return
	to_chat(user, span_boldnotice("我凝神将思绪送往另一个自己：</span> <span class='notice'>[msg]"))
	to_chat(trauma.owner, span_boldnotice("[flufftext]</span> <span class='notice'>[msg]"))
	log_directed_talk(user, trauma.owner, msg, LOG_SAY ,"[name]")
	for(var/ded in GLOB.dead_mob_list)
		if(!isobserver(ded))
			continue
		to_chat(ded, "[FOLLOW_LINK(ded, user)] <span class='boldnotice'>[user] [name]:</span> <span class='notice'>\"[msg]\" 传达给</span> <span class='name'>[trauma]</span>")
