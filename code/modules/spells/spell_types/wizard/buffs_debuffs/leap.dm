/obj/effect/proc_holder/spell/invoked/leap
	name = "腾跃术"
	desc = "强化目标的双腿，使其能高高跃起，甚至跳上更高楼层；但这并不能免除从高处跌落时受到的伤害。"
	cost = 2
	releasedrain = 35
	chargedrain = 1
	chargetime = 1 SECONDS
	recharge_time = 2 MINUTES
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	gesture_required = TRUE // Mobility spell
	spell_tier = 1
	invocations = list("跃起吧！")
	invocation_type = "whisper"
	hide_charge_effect = TRUE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/wind
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "rune5"
	range = 7

/obj/effect/proc_holder/spell/invoked/leap/cast(list/targets, mob/user = usr)
	if(isliving(targets[1]))
		var/mob/living/carbon/target = targets[1]
		if(HAS_TRAIT(target,TRAIT_ZJUMP))
			to_chat(user, "<span class='warning'>对方本就已经能跳得这么高了！</span>")
			revert_cast()
			return
		ADD_TRAIT(target, TRAIT_ZJUMP, MAGIC_TRAIT)
		to_chat(target, span_warning("我的双腿变得更有力了！我感觉自己能一跃而起！"))
		addtimer(CALLBACK(src, PROC_REF(remove_buff), target), wait = 20 SECONDS)
		return TRUE
	

/obj/effect/proc_holder/spell/invoked/leap/proc/remove_buff(mob/living/carbon/target)
	REMOVE_TRAIT(target, TRAIT_ZJUMP, MAGIC_TRAIT)
	to_chat(target, span_warning("我的双腿忽然变得沉重无力。"))
	target.Immobilize(5)
