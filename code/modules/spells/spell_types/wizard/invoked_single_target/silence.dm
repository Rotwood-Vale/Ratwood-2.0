/obj/effect/proc_holder/spell/invoked/silence
	name = "缄默术"
	desc = "封住目标之舌。对真正的大法师不起作用。"
	overlay_icon = 'icons/mob/actions/nocmiracles.dmi'
	action_icon = 'icons/mob/actions/nocmiracles.dmi'
	overlay_state = "silence"
	cost = 3
	xp_gain = TRUE
	releasedrain = 60
	chargedrain = 1
	chargetime = 15
	recharge_time = 100 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 1
	invocations = list("归于缄默。")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	zizo_spell = TRUE

/obj/effect/proc_holder/spell/invoked/silence/miracle
	cost = 0
	spell_tier = 0
	associated_skill = /datum/skill/magic/holy
	chargetime = 9
	recharge_time = 120 SECONDS
	invocations = list("月辉，赐其缄默。")

/obj/effect/proc_holder/spell/invoked/silence/cast(list/targets, mob/user = usr)
	if(isliving(targets[1]))
		var/mob/living/carbon/target = targets[1]
		if(HAS_TRAIT(target, TRAIT_COUNTERCOUNTERSPELL) || HAS_TRAIT(target, TRAIT_ANTIMAGIC) || HAS_TRAIT(target, TRAIT_MUTE))
			to_chat(user, "<span class='warning'>法术噗地散掉了，对方不会受影响！</span>")
			revert_cast()
			return
		if(target.get_skill_level(/datum/skill/magic/arcane) > 2 || target.get_skill_level(/datum/skill/magic/holy) > 2)
			to_chat(user, "<span class='warning'>对方的魔力过于强盛，这招对他无效！</span>")
			revert_cast()
			return
		ADD_TRAIT(target, TRAIT_MUTE, MAGIC_TRAIT)
		playsound(get_turf(target), 'sound/magic/zizo_snuff.ogg', 80, TRUE, soundping = TRUE)
		to_chat(target, span_warning("我喉中的风声忽然止息了。我说不出话了！"))
		var/dur = max((9 * (user.get_skill_level(associated_skill, 5))))
		addtimer(CALLBACK(src, PROC_REF(remove_buff), target), wait = dur SECONDS)
		return TRUE


/obj/effect/proc_holder/spell/invoked/silence/proc/remove_buff(mob/living/carbon/target)
	REMOVE_TRAIT(target, TRAIT_MUTE, MAGIC_TRAIT)
	to_chat(target, span_warning("我的声音回来了！"))
